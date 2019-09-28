require 'review_comments_collector/version'
require 'review_comments_collector/config'
require 'review_comments_collector/github_client'
require 'review_comments_collector/collector'
require 'review_comments_collector/recorder'

module ReviewCommentsCollector
  class Error < StandardError; end

  def self.run(args = [])
    config = Config.build_with(args)
    client = GithubClient.new(config)
    collector = Collector.new(config, client)
    data = collector.collect
    Recorder.output(config, data)
  end
end
