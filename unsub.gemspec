# -*- encoding: utf-8 -*-
$:.push File.expand_path(File.join('..', 'lib'), __FILE__)
require 'unsub/metadata'

Gem::Specification.new do |s|
  s.name        = Unsub::NAME
  s.version     = Unsub::VERSION
  s.platform    = Gem::Platform::RUBY
  s.author      = Unsub::AUTHOR
  s.email       = Unsub::EMAIL
  s.summary     = Unsub::SUMMARY
  s.description = Unsub::SUMMARY + '.'
  s.homepage    = Unsub::HOMEPAGE
  s.license     = Unsub::LICENSE

  s.add_runtime_dependency 'thor', '~> 0'
  s.add_runtime_dependency 'slog', '~> 1'
  s.add_runtime_dependency 'ridley'
  s.add_runtime_dependency 'aws-sdk'
  s.add_runtime_dependency 'daybreak'

  # Bundled libs
  s.add_runtime_dependency 'eventmachine', '= %s' % Unsub::EM_VERSION
  s.add_runtime_dependency 'thin', '= %s' % Unsub::THIN_VERSION
  s.add_runtime_dependency 'ffi', '= %s' % Unsub::FFI_VERSION

  s.files         = Dir['{bin,lib}/**/*'] + %w[ LICENSE Readme.md VERSION ]
  s.test_files    = Dir['test/**/*']
  s.executables   = %w[ unsub ]
  s.require_paths = %w[ lib ]
end