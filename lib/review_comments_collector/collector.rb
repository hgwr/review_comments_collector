require 'octokit'
require 'pry'

module ReviewCommentsCollector
  class Collector
    PR_KEYS = %i(
      id
      node_id
      number
      state
      locked
      title
      user
      body
      created_at
      updated_at
      closed_at
      merged_at
      merge_commit_sha
      assignee
      assignees
      requested_reviewers
      requested_teams
      labels
      milestone
    )

    # html_url issue_url review_comment_url
    # patch_url
    
    # PR_URL_KEYS = %i(
    #   commits_url
    #   diff_url
    #   review_comments_url
    #   comments_url
    #   statuses_url
    # )

    PR_URL_KEYS = %i(
      review_comments_url
      comments_url
      statuses_url
    )
    
    def initialize(config, client)
      @config = config
      @client = client
    end

    def collect
      pull_request_data = @client.pull_requests(@config.repository, state: 'all').map do |pr|
        sleep 2
        STDERR.puts("Processing #{@config.repository} ##{pr[:number]} ...")
        ret_val = {}
        PR_KEYS.each do |k|
          ret_val[k.to_s] = pr[k].to_s
        end
        # binding.pry
        PR_URL_KEYS.each do |url_key|
          url_key_name = url_key.to_s.sub(/_url$/, '')
          ret_val[url_key_name] = 
            begin
              results = @client.get(pr[url_key])
              if results.respond_to?(:map)
                results.map { |r| r.to_h }
              else
                results.to_s
              end
            rescue => e
              STDERR.puts("Error: Failed to get #{url_key} #{pr[url_key]} on #{@config.repository} ##{pr[:number]}: #{e.message}")
              nil
            end
        end
        ret_val
      end
      {
        user: @client.user.to_h,
        pull_request: pull_request_data
      }
    end
  end
end
