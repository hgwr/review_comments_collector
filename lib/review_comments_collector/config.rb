require 'optparse'
require 'ostruct'
require 'yaml'

module ReviewCommentsCollector
  # Config class
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

      read_config
      validate

      %w(login two_fa repository target_user output token).each do |var_name|
        send("#{var_name}=".to_sym, @config[var_name])
      end
    end

    private

    def read_config
      unless @config.output.respond_to?(:puts)
        filename = @config.output.to_s
        @config.output = open(filename, 'wb')
      end
      if File.readable?(ReviewCommentsCollector::CONFIG_FILENAME)
        config_yaml = YAML.load_file(ReviewCommentsCollector::CONFIG_FILENAME)
        @config.token = config_yaml[:token] if config_yaml
      end
      puts "@config = #{@config.inspect}"
    end

    def validate
      %w(login repository).each do |name|
        output_error_and_exit(name) unless @config[name]
      end
    end

    def output_error_and_exit(name)
      warn "Error: #{name} is not specified."
      exit 1
    end
  end
end
