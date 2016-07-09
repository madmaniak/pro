module Namespacer

  def self.from(path, sclass, block, prefix = 'front')
    path.gsub!(/^#{ENV['root']}\//, '')                    # make path relative
    modules = ([prefix] + path.split('/')).map(&:camelize)
    klass = modules.pop[0...-3]                            # rm .rb

    modules.inject(Kernel) { |mod, mod_name|
      if mod.const_defined?(mod_name)
      then mod.const_get(mod_name)
      else mod.const_set(mod_name, Module.new)
      end
    }.const_set klass, Class.new(sclass, &block)
  end

end
