require 'optparse'
require 'ostruct'
require 'yaml'

module ReviewCommentsCollector
  class Config
    attr_accessor :login
    attr_accessor :two_fa
    attr_accessor :repository
    attr_accessor :target_user
    attr_accessor :output
    attr_accessor :token
    
    def initialize
      option_hash = ARGV.getopts('', 'login:', 'two_fa', 'repository:', 'user:', 'output:')
      @config = OpenStruct.new(option_hash)
      @config.output ||= STDOUT
      unless @config.output.respond_to?(:puts)
        filename = @config.output.to_s
        @config.output = open(filename, 'wb')
      end
      if File.readable?(ReviewCommentsCollector::CONFIG_FILENAME)
        config_yaml = YAML.load_file(ReviewCommentsCollector::CONFIG_FILENAME)
        if config_yaml
          @config.token = config_yaml[:token]
        end
      end
      puts "@config = #{@config.inspect}"
      
      validate

      %w(login two_fa repository target_user output token).each do |var_name|
        self.send("#{var_name}=".to_sym, @config[var_name])
      end
    end

    private
    
    def validate
      %w(login repository).each do |name|
        output_error_and_exit(name) unless @config[name]
      end
    end

    def output_error_and_exit(name)
      STDERR.puts "Error: #{name} is not specified."
      exit 1
    end
  end
end
