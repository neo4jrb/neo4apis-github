
neo4apis-github is a ruby gem for making importing data from github to neo4j easy

This adapter supports objects created from the `github` gem.

```ruby

require 'github_api'
github_client = Github.new(oauth_token: token)

require 'neo4apis/github'
neo4japis_github = Neo4Apis::Github.new(Neo4j::Session.open)

neo4japis_github.batch do
  github_client.issues.list.each do |issue|
    # Imports:
    #  * The issue
    #  * The creator / assignee
    #  * The repo
    #  * The owner of the repo
    import :Issue, issue
  end
end

```

Current supports importing of User, Issue, and Repository
