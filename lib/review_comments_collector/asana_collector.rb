require 'asana'
require 'pry'

module ReviewCommentsCollector
  class AsanaCollector
    attr_accessor :config

    def initialize(config)
      @config = config
    end

    def collect
      binding.pry
      client = Asana::Client.new do |c|
        c.authentication :access_token, @config.asana_token
      end
      puts client.workspaces.find_all.first
      binding.pry
    end
  end
end
