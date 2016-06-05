Gem::Specification.new do |s|
  s.name        = 'leafleter'
  s.version     = '0.0.0'
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Mateusz Konieczny']
  s.email       = ['matkoniecz@gmail.com']
  s.homepage    = 'https://github.com/matkoniecz/leafleter'
  s.summary     = 'Generator of Leaflet maps.'
  s.description = 'Generator of Leaflet maps.'
  s.license     = 'CC0'

  s.required_rubygems_version = '>= 1.8.23'

  # If you need to check in files that aren't .rb files, add them here
  s.files        = Dir['{lib}/**/*.rb', 'bin/*', '*.txt', '*.md']
  s.require_path = 'lib'
end

=begin
how to release new gem version:

gem build leafleter.gemspec
gem install leafleter-*.*.*.gem
gem push leafleter-*.*.*.gem
=end
