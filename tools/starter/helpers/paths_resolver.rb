module PathsResolver
  def self.resolve(kind, blacklist: [], sort: false)
    paths = @paths.select{ |path| path =~ /#{kind}$/ }

    if blacklist.any?
      paths.reject!{ |path| path =~ /(#{blacklist.join('|')})/ }
    end

    if sort
      paths.sort_by!{ |path|
        parts = path.split("/")
        [ ( sort == :leafs_first ? -parts.size : parts.size ) , parts.last ]
      }
    else paths end
  end

  def self.load
    @paths = Dir["{app,components,services}/**/*"].reject{ |path| path =~ /node_modules/ }
  end

  def self.free
    @paths = nil
  end
end

PathsResolver.load
