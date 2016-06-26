# find configs
configs = Dir['**/*/config.yml*'].group_by { |config|
  config =~ /\.example$/ ? :example : :real
}

configs[:real] ||= []
errors = []

# check existance
configs[:example].each do |config|
  real_config = config[0...-8]
  errors << "Missing #{real_config}" unless configs[:real].include? real_config
end

# load configs
require 'yaml'
map = configs[:real].inject({}) do |h, config|
  h[config] = YAML.load_file(config)
  h
end

# check uniqueness
map.keys.combination(2).to_a.each do |pair|
  common = map[pair[0]].keys & map[pair[1]].keys
  errors << "Double definition of #{common} in #{pair}" if common.any?
end

# log errors and break if any
abort errors.join("\n") if errors.any?

# merge
merged_config = map.values.inject :merge

# set env
ENV['app'] = Dir.pwd.split('/').last
ENV.update merged_config
