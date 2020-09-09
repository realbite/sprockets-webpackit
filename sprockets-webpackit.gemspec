Gem::Specification.new do |s|
  s.name = 'sprockets-webpackit'
  s.description = %Q[compile a js asset using webpacker]
  s.summary = %Q[sprockets webpack javascript compiler]
  s.version = '0.1.1'
  s.platform = Gem::Platform::RUBY
  s.authors = ['Clive Andrews']
  s.license = 'MIT'
  s.email = ['gems@realitybites.eu']

  s.add_dependency('sprockets')
  s.add_dependency('json')

  s.files << 'lib/sprockets/webpackit.rb'
  s.files << 'LICENSE'
  s.files << 'README.md'

  s.extra_rdoc_files = ['README.md','LICENSE']
  s.require_paths = ['lib']
end
