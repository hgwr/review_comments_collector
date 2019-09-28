require 'io/console'
require 'octokit'
require 'yaml'

module ReviewCommentsCollector
  class GithubClient
    def initialize(config)
      @config = config
    end

    def connect
      if @config.token
        login_with_token
      else
        login_with_password
      end
    end

    def login_with_token
      @client = Octokit::Client.new(access_token: @config.token)
    end

    def login_with_password
      STDERR.print('GitHub password: ')
      STDERR.flush
      password = STDIN.noecho(&:gets).chomp
      STDERR.print("\n")
      STDERR.flush
      
      @client = Octokit::Client.new(login: @config.login, password: password)
      puts "@client = #{@client.inspect}"
      
      if @config.two_fa
        STDERR.print('2FA: ')
        STDERR.flush
        two_fa = STDIN.gets.chomp
        STDERR.print("\n")
        STDERR.flush

        options = {
          note: 'token for review_comments_collector gem',
          scopes: %w(read:user user:email repo:status repo_deployment),
          headers: { 'X-GitHub-OTP' => two_fa }
        }
        begin
          @config.token = @client.create_authorization(options)
          open(ReviewCommentsCollector::CONFIG_FILENAME, 'wb', 0600) do |f|
            f.puts(@config.token.to_h.to_yaml)
          end
        rescue Octokit::Unauthorized => e
          warn e.to_s
        end
      end
      
      @client
    end
  end
end
