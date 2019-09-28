require 'review_comments_collector/version'
require 'review_comments_collector/config'
require 'review_comments_collector/github_client'
require 'review_comments_collector/collector'
require 'review_comments_collector/recorder'

module ReviewCommentsCollector
  class Error < StandardError; end

  def self.run
    config = Config.new
    client = GithubClient.new(config)
    data = Collector.new(config, client).collect
    Recorder.output(config, data)
  end
end
