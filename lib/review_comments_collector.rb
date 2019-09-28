require 'review_comments_collector/version'
require 'review_comments_collector/config'
require 'review_comments_collector/github_client'
require 'review_comments_collector/collector'
require 'review_comments_collector/recorder'

module ReviewCommentsCollector
  class Error < StandardError; end

  CONFIG_FILENAME = File.join(ENV['HOME'], '.review_comments_collector_rc')

  def self.run
    config = Config.new
    client = GithubClient.new(config).connect
    data = Collector.new(config, client).collect
    Recorder.output(config, data)
  end
end
