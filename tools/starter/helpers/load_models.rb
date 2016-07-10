require_relative 'paths_resolver'

module Sequel::Plugins::CustomModel
  module ClassMethods
    def immutable(*value)
      return @immutable if value.empty?
      @immutable = !!value.first
    end
  end
end

Sequel::Model.plugin :custom_model

constants = Object.constants

PathsResolver.resolve('model.rb').each do |model|
  require "#{Dir.pwd}/#{model}"
end

$models = (Object.constants - constants).inject({}) { |h, model|
  model = Kernel.const_get(model)
  h[model.table_name] = model
  h
}
