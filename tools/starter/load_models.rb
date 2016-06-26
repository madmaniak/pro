constants = Object.constants

Dir['{app,components,services}/**/*/model.rb'].each do |model|
  require "#{Dir.pwd}/#{model}"
end

$models = (Object.constants - constants).inject({}) { |h, model|
  model = Kernel.const_get(model)
  h[model.table_name] = model
  h
}
