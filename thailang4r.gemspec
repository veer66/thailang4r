Gem::Specification.new do |s|
  s.name = 'thailang4r'
  s.version = '0.0.2'
  s.authors = ['Vee Satayamas']
  s.email = ['5ssgdxltv@relay.firefox.com']
  s.description = "Thai language tools for Ruby, i.e. a word tokenizer, a character level indentifier, and a romanization tool"
  s.homepage = "https://github.com/veer66/thailang4r"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 3.0.0")
  s.summary = "Thai language utility for Ruby"
  s.files = Dir.glob("lib/**/*") + %w(LICENSE README.md Rakefile) + Dir.glob("data/*")
  s.require_path = 'lib'
  s.licenses = ['Apache-2.0']
end
