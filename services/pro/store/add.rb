Service __FILE__ do

  def perform(data)
    collection = data['object']['type'].to_sym

    # insert
    id = $models[collection].insert \
      sql_relations(collection, data['relations']).merge \
        data: Sequel.pg_jsonb(data['object'].reject{ |k,_| ['id', 'type'].include? k })

    # broadcast
    serialized = json_relations(collection, id, data['relations'])
    serialized[collection] += [ data['object'].reject{ |k| k == 'type' }.merge('id' => id) ]
    broadcast data, data: serialized

    # fix tmp_id in origin client
    reply data,
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
    references.inject(Hash.new([])) { |h, (type, id)|
      h[type] += [{ id: id, collection => [object_id] }]; h
    }
  end

end
