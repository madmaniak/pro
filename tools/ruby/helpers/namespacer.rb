$services = {}

module Namespacer

  def self.make(path, sclass, block, prefix = 'front')
    ns = prepare(path, prefix)
    modules = ns.split('/').map(&:camelize)
    klass = modules.pop

    $services[ns] = \
      modules.inject(Kernel) { |mod, mod_name|
        if mod.const_defined?("#{mod.to_s}::#{mod_name}")
        then mod.const_get(mod_name)
        else mod.const_set(mod_name, Module.new)
        end
      }.const_set klass, Class.new(sclass, &block)
  end

  def self.take(path, prefix = 'front')
    prepare(path, prefix).gsub(/\/\w+$/, "" ).camelize.constantize
  end

  def self.prepare(path, prefix)
    "#{prefix}/#{path.gsub!(/^#{ENV['root']}\//, '')}"[0...-3] # [0...-3] rm .rb
  end

end

NS = Namespacer
