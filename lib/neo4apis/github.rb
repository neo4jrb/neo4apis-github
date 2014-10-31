require 'neo4apis'

module Neo4Apis
  class Github < Base
    prefix :Github

    uuid :Repository, :id
    uuid :User, :id
    uuid :Issue, :id

    importer :Repository do |repository|
      owner_node = import :User, repository.owner

      node = add_node :Repository, {
        id: repository.id,
        name: repository.name,
        full_name: repository.full_name,
        html_url: repository.html_url,
        description: repository.description,
        fork: repository.fork,

        stargazers_count: repository.stargazers_count,
        watchers_count: repository.watchers_count,
        language: repository.language,
        forks: repository.forks
      }

      add_relationship(:has_owner, node, owner_node)

      node
    end

    importer :Issue do |issue|
      user_node = import :User, issue.user
      assignee_node = import :User, issue.assignee
      repository_node = import :Repository, issue.repository

      node = add_node :Issue, {
        id: issue.id,
        number: issue.number,
        title: issue.title,
        body: issue.body,
        html_url: issue.html_url,
        comments: issue.comments,
        created_at: issue.created_at,
        updated_at: issue.updated_at,
        closed_at: issue.closed_at,
      }

      add_relationship(:from_repository, node, repository_node)
      add_relationship(:has_user, node, user_node)
      add_relationship(:has_assignee, node, assignee_node)

      node
    end

    importer :User do |user|
      add_node :User, {
        id: user.id,
        login: user.login,
        html_url: user.html_url,
        site_admin: user.site_admin
      }
    end

  end
end

