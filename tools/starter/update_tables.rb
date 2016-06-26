module Sequel::Plugins::UpdateTable
  module ClassMethods
    def update_table!
      unless db.table_exists? table_name
        puts "Creating #{table_name} table."
        $db.create_table table_name do
          primary_key :id
          Integer :version, default: 0
          column :data, :jsonb
        end
      end
    end

    def update_relations!
      schema = $db.schema(table_name).to_h
      association_reflections.each do |name, details|
        if key = details[:qualified_key] and not schema[key.column]
          puts "Adding #{name} key to #{table_name}"
          $db.alter_table(table_name) do
            add_foreign_key key.column, Kernel.const_get(details[:class_name]).table_name
          end
        end
      end
    end
  end
end

Sequel::Model.plugin :update_table

$models.values.each do |model|
  model.update_table!
end.each do |model|
  model.update_relations!
end
