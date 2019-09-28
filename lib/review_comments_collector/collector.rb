require 'octokit'

module ReviewCommentsCollector
  class Collector
    def initialize(config, client)
      @config = config
      @client = client
    end

    def collect
      # TODO: do something
    end
  end
end
