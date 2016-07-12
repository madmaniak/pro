require_relative 'paths_resolver'
require_relative 'namespacer'
require './tools/ruby/service'
require './tools/ruby/getter'

def Getter  namespace, &block; Namespacer.make(namespace, Getter, block); end
def Service namespace, &block; Namespacer.make(namespace, Service, block); end

PathsResolver.resolve(:rb, blacklist: [:model], sort: :leafs_first).each{ |service|
  require "./#{service}"
}

PathsResolver.free # PathsResolver will be not used anymore
