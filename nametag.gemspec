require File.expand_path('../lib/nametag/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'nametag'
  s.homepage    = 'https://github.com/obfusk/nametag'
  s.summary     = 'set audio file tags based on file name'

  s.description = <<-END.gsub(/^ {4}/, '')
    ...
  END

  s.version     = NameTag::VERSION
  s.date        = NameTag::DATE

  s.authors     = [ 'Felix C. Stegerman' ]
  s.email       = %w{ flx@obfusk.net }

  s.license     = 'GPLv2'

  s.executables = %w{ nametag }
  s.files       = %w{ .yardopts README.md bin/nametag
                      nametag.gemspec } + Dir['lib/**/*.rb']

  s.add_runtime_dependency 'taglib-ruby'

  s.required_ruby_version = '>= 1.9.1'
end
