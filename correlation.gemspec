Gem::Specification.new do |s|
  s.name        = 'correlation'
  s.version     = '0.0.3'
  s.date        = '2015-12-04'
  s.summary     = "Allows correlation tracking from request down the network stack"
  s.description = "Allows correlation tracking from request down the network stack"
  s.authors     = ["John Chow"]
  s.email       = 'john.chow@teespring.com'
  s.files       = Dir['README.md', 'lib/**/*', 'spec/**/*']
  s.test_files  = Dir['spec/**/*']
  s.require_paths  = ["lib"]
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'

  s.add_development_dependency 'rspec'
end
