require_relative 'paths_resolver'
require_relative 'namespacer'
require './framework/tools/consumers/ruby/service'
require './framework/tools/consumers/ruby/getter'

def Getter  namespace, &block; Namespacer.make(namespace, Getter, block); end
def Service namespace, &block; Namespacer.make(namespace, Service, block); end

require './framework/services/store/index'

PathsResolver.resolve(:rb, blacklist: [:model], sort: :leafs_first).each{ |service|
  require "./#{service}"
}
