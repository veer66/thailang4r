$LOAD_PATH << File.expand_path("../lib", __FILE__)

Gem::Specification.new do |s|
  s.name = 'thailang4r'
  s.version = '0.0.1'
  s.authors = ['Vee Satayamas']
  s.email = ['v.satayamas@gmail.com']
  s.description = "Thai language utility for Ruby"
  s.homepage = "https://github.com/veer66/thailang4r"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.summary = "Thai language utility for Ruby"
  s.files = Dir.glob("lib/**/*") + %w(LICENSE README.md Rakefile)
  s.require_path = 'lib'
  s.add_development_dependency("cucumber", "~> 1.2.1")
end