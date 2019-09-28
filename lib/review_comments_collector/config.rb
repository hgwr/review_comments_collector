require 'optparse'

module ReviewCommentsCollector
  class Config
    attr_accessor :login
    attr_accessor :repository
    attr_accessor :target_user
    attr_accessor :output
    
    def initialize
      @config = ARGV.getopts('', 'login:', 'repository:', 'target-user:', 'output:')
      @config['output'] ||= STDOUT
      
      validate
      
      self.login = @config['login']
      self.repository = @config['repository']
      self.target_user = @config['target_user']
      self.output = @config['output']
    end

    private
    
    def validate
      output_error_and_exit('login') unless @config['login']
      output_error_and_exit('repository') unless @config['repository']
    end

    def output_error_and_exit(name)
      STDERR.puts "Error: #{name} is not specified."
      exit 1
    end
  end
end
