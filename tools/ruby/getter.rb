class Getter < Service

  class << self

    attr_reader :s

    def setup(opts)
      @s = {
        base:  nil,                                                 # collection name
        scope: ->(ds, params) { ds.order(:id).reverse.limit(20) },  # set scope using Sequel
        relations: {},                                              # hash of relations name => Getter
        fields: [],                                                 # fields to select from data
        params: []                                                  # relevant keys from request data
      }.merge(opts)
    end

    def iterate(sql, request, results)
      result = $db.fetch(sql)
      return result if result.empty?
      @s[:relations].each do |name, getter|
        relation = model.association_reflections[name]

        relation_sql = \
          case relation[:type]
          when :one_to_many
            query = getter
              .base_scope(request)
              .where("#{relation[:key]} = relation_id")
              .sql

            "select results.* from unnest(ARRAY#{result.map{ |r| r[:id] }}) as relation_id join lateral (#{query}) results on true"
          end

        relation_result = getter.iterate(relation_sql, request, results)

        # add relation pointers
        results[@s[:base]] +=
          relation_result
            .group_by{ |row| row.delete relation[:key] }
            .map{ |id, rows| { id: id, getter.s[:base] => rows.map{ |r| r[:id] } } }
      end

      # merge relevant data
      results[@s[:base]] +=
        result
          .map{ |row|
            row
              .merge(row[:data].select{ |k| @s[:fields].include? k.to_sym })
              .reject{ |k| k == :data }
            }
    end

    def base_scope(request)
      params = request.select{ |k| @s[:params].include? k }
      @s[:scope].call(model, params)
    end

    private

    def model
      @model ||= $models[@s[:base]]
    end

  end

  def perform(data)
    base_scope = self.class.base_scope(data)
    base_sql = \
      if cursor = data['before']
        base_scope.seek cursor.to_i, by_pk: true, back: true
      elsif cursor = data['after']
        base_scope.seek cursor.to_i, by_pk: true
      elsif ids = data['ids']
        base_scope.limit(false).where id: ids.map(&:to_i)
      elsif page = data['page']
        base_scope.offset base_scope.opts[:limit] * page.to_i
      else
        base_scope
      end.sql

    self.class.iterate base_sql, data, results = Hash.new([])
    reply sid: data['sid'], data: results
  end

end
