lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'review_comments_collector/version'

Gem::Specification.new do |spec|
  spec.name = 'review_comments_collector'
  spec.version = ReviewCommentsCollector::VERSION
  spec.authors = ['Shigeru Hagiwara']
  spec.email = ['hgwrsgr@gmail.com']

  spec.summary = %q(Tools for collecting review comments on GitHub.)
  spec.description = %q(This tool retrieves the specified pull request information
                          for the specified repository and comments for review issues.)
  spec.homepage = 'https://rubygems.org/gems/review-tools'
  spec.license = 'MIT'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/hgwr/review_comments_collector/'
  spec.metadata['changelog_uri'] = 'https://github.com/hgwr/review_comments_collector/'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = %w(lib)

  spec.add_runtime_dependency 'octokit', '>= 4.4.1', '< 4.18.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'pry-byebug', '~> 3.0'
end
