require_relative 'lib/ar_shard/version'

Gem::Specification.new do |spec|
  spec.name          = 'ar_shard'
  spec.version       = ARShard::VERSION
  spec.authors       = ['Alex Tsirel']
  spec.email         = ['noma4i@gmail.com']

  spec.summary       = 'Isolated Multibase Support for ActiveRecord Models with dynamic config'
  spec.description   = 'Isolated Multibase Support for ActiveRecord Models with dynamic config'
  spec.homepage      = 'https://github.com/noma4i/ar_shard'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/noma4i/ar_shard'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activerecord', '>= 6'

  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'sqlite3', '~> 1.4'
end
