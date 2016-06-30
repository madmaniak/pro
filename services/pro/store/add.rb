module Front::Services::Pro
  module Store
    class Add < Service

      def perform(data)
        collection = data['object']['type'].to_sym

        # insert
        id = $db[collection].insert \
          sql_relations(collection, data['relations']).merge \
            data: Sequel.pg_jsonb(data['object'].reject{ |k,_| ['id', 'type', 'v'].include? k })

        # broadcast
        reply broadcast: true, sid: data['sid'], data: { collection => {
          id => data['object'].merge('id' => id)
        } }.merge( json_relations collection, id, data['relations'] )

        # fix tmp_id in origin client
        reply sid: data['sid'], event: :real_id,
          change: {
            collection: collection,
            tmp_id: data['object']['id'],
            id: id
          }
      end

      private

      def sql_relations(collection, references)
        references.inject({}) { |h, (type, id)|
          foreign_key = \
            $models[type.to_sym].association_reflections[collection][:key]
          h[foreign_key] = id; h
        }
      end

      def json_relations(collection, object_id, references)
        references.inject({}) { |h, (type, id)|
          h[type] = { id => { collection => [object_id] } }; h
        }
      end

    end
  end
end
