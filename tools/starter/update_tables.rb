module Sequel::Plugins::UpdateTable
  module ClassMethods
    def update_table!
      unless db.table_exists? table_name
        puts "Creating #{table_name} table."
        immut = immutable # pass immutable value to the block
        $db.create_table table_name do
          primary_key :id
          column :data, :jsonb
          Integer :v, default: 0 unless immut
        end
      end
    end

    def update_relations!
      schema = $db.schema(table_name).to_h
      association_reflections.each do |name, details|
        if key = details[:qualified_key] and not schema[key.column]
          rel_table_name = Kernel.const_get(details[:class_name]).table_name

          puts "Adding #{name} key to #{table_name}"
          $db.run "ALTER TABLE #{table_name}
                   ADD COLUMN #{key.column} integer REFERENCES #{rel_table_name}
                   ON DELETE CASCADE"
        end
      end
    end
  end
end

Sequel::Model.plugin :update_table

require_relative '../consumers/ruby/helpers/load_models'

$models.values.each do |model|
  model.update_table!
end.each do |model|
  model.update_relations!
end
