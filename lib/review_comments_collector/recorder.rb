require 'pry'
require 'yaml'

module ReviewCommentsCollector
  class Recorder
    def self.output(config, data)
      @config = config
      @data = data

      # binding.pry

      @config.output.puts @data.to_yaml
    end
  end
end
