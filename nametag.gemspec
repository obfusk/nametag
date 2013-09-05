require File.expand_path('../lib/nametag/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'nametag'
  s.homepage    = 'https://github.com/obfusk/nametag'
  s.summary     = 'set audio file tags based on file name'

  s.description = <<-END.gsub(/^ {4}/, '')
    set audio file tags based on file name

    ...
  END

  s.version     = NameTag::VERSION
  s.date        = NameTag::DATE

  s.authors     = [ 'Felix C. Stegerman' ]
  s.email       = %w{ flx@obfusk.net }

  s.licenses    = %w{ GPLv2 }

  s.executables = %w{ nametag }
  s.files       = %w{ .yardopts README.md Rakefile bin/nametag } \
                + %w{ nametag.gemspec } \
                + Dir['{lib,spec}/**/*.rb']

  s.add_runtime_dependency 'taglib-ruby'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'

  s.required_ruby_version = '>= 1.9.1'
end
