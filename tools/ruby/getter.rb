module CollectionIds

  refine Array do
    def ids
      @ids ||= map{ |c| c[:id] }
    end
  end

end

class Getter < Service

  using CollectionIds

  class << self
    attr_reader :s

    def setup(opts)
      @s = {
        base:  nil,                                                 # collection name
        scope: ->(ds, params) { ds },                               # set scope using Sequel
        order: [ [:id, true] ],                                     # order [Sequel:key, boolean:descending]
        limit: 20,                                                  # limit per page
        relations: {},                                              # relations name => Getter
        fields: [],                                                 # fields to select from data
        params: []                                                  # relevant keys from request data
      }.merge(opts)
    end

    def iterate(sql, request, results)
      result = $db.fetch(sql).all
      return result if result.empty?

      # merge relevant data
      results[@s[:base]] +=
        result
          .map{ |row|
            row
              .select{ |k| [:id, :data, :v].include? k }
              .merge(row[:data].select{ |k| @s[:fields].include? k.to_sym })
              .reject{ |k| k == :data }
            }

      @s[:relations].each do |rel_name, getter|
        relation = model.association_reflections[getter.s[:base]]

        relation_sql = \
          case relation[:type]
          when :one_to_many
            query = getter
              .base_scope(request)
              .where("#{relation[:key]} = relation_id")
              .sql

            "select results.* from unnest(ARRAY#{result.ids}) as relation_id join lateral (#{query}) results on true"
          end

        # add relation pointers
        results[@s[:base]] +=
          getter.iterate(relation_sql, request, results)
            .group_by{ |row| row[relation[:key]] }
            .map{ |id, rows| { id: id, rel_name => rows.ids } }
      end

      result
    end

    def base_scope(request)
      scope = @s[:scope]
        .call(model, request.select{ |k| @s[:params].include? k })
        .limit(@s[:limit])
      scope.opts[:order] ||= order
      scope
    end

    def model
      @model ||= $models[@s[:base]]
    end

    def order
      @order ||= @s[:order].map{ |field, descending|
        descending ? Sequel::SQL::OrderedExpression.new(field) : field
      }
    end

    private

    def j
      @j ||= Sequel.expr(:data).pg_jsonb
    end

    def field(name)
      j.get_text(name)
    end

  end

  def perform(data)
    base_scope = self.class.base_scope(data)
    base_sql = \
      if cursor = data[:before]
        base_scope.seek cursor, by_pk: !cursor.is_a?(Array), back: true
      elsif cursor = data[:after]
        base_scope.seek cursor, by_pk: !cursor.is_a?(Array)
      elsif cursor = data[:dynamic]
        base_scope.exclude(id: cursor)
      elsif cursor = data[:ids]
        base_scope.limit(false).where id: cursor
      elsif cursor = data[:page]
        $db["select results.* from (#{base_scope.offset(base_scope.opts[:limit] * cursor).select(:id).sql}) ids join lateral (#{base_scope.limit(false).where('id = ids.id').sql}) results on true"]
      else
        base_scope
      end.sql

    result = self.class.iterate(base_sql, data, results = Hash.new([]))
    reply data, data: results, scope: result.ids
  end

end
