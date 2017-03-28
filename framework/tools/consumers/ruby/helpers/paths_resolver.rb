module PathsResolver
  def self.resolve(kind, blacklist: [], sort: false)
    @paths.map{ |paths_group|
      paths = paths_group.select{ |path| path =~ /#{kind}$/ }

      if blacklist.any?
        paths.reject!{ |path| path =~ /(#{blacklist.join('|')})/ }
      end

      if sort
        paths.sort_by!{ |path|
          parts = path.split("/")
          [ ( sort == :leafs_first ? -parts.size : parts.size ) , parts.last ]
        }
      else paths end
    }.flatten
  end

  def self.load
    @paths = [ Dir["services/**/*"], Dir["components/**/*"], Dir["app/**/*"] ]
  end

  def self.free
    @paths = nil
  end
end

PathsResolver.load
