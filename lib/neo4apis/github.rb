require 'neo4apis'

module Neo4Apis
  class Github < Base
    prefix :Github

    uuid :Repository, :id
    uuid :User, :id
    uuid :Issue, :id

    importer :Repository do |repository|
      owner_node = import :User, repository.owner

      node = add_node :Repository, repository, [:id, :name, :full_name, :html_url, :description, :fork,
                                                :stargazers_count, :watchers_count, :language, :forks]

      add_relationship(:has_owner, node, owner_node)

      node
    end

    importer :Issue do |issue|
      user_node = import :User, issue.user
      assignee_node = import :User, issue.assignee
      repository_node = import :Repository, issue.repository

      node = add_node :Issue, issue, [:id, :number, :title, :body, :html_url, :comments,
                                      :created_at, :updated_at, :closed_at]

      add_relationship(:from_repository, node, repository_node)
      add_relationship(:has_user, node, user_node)
      add_relationship(:has_assignee, node, assignee_node)

      node
    end

    importer :User do |user|
      add_node :User, user, [:id, :login, :html_url, :site_admin]
    end

  end
end

