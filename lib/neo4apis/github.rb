require 'neo4apis'

module Neo4Apis
  class Github < Base
    common_label :GitHub

    uuid :Repository, :id
    uuid :User, :id
    uuid :Issue, :id
    uuid :Comment, :id
    uuid :Commit, :sha

    importer :Repository do |repository|
      owner_node = import :User, repository.owner

      node = add_node :Repository, repository, [:id, :name, :full_name, :html_url, :description,# :fork,
                                                :stargazers_count, :watchers_count, :language, :forks,
                                                :git_url, :ssh_url, :clone_url, :svn_url, :homepage,
                                                :size, :forks_count, :mirror_url,
                                                :created_at, :updated_at, :pushed_at]

      add_relationship(:HAS_OWNER, node, owner_node)

      node
    end

    importer :Issue do |issue|
      user_node = import :User, issue.user
      assignee_node = import :User, issue.assignee if issue.assignee

      node = add_node :Issue, issue, [:id, :number, :title, :body, :html_url, :comments,
                                      :created_at, :updated_at, :closed_at]

      add_relationship(:HAS_USER, node, user_node)
      add_relationship(:HAS_ASSIGNEE, node, assignee_node) if assignee_node

      node
    end

    importer :Comment do |comment|
      user_node = import :User, comment.user

      node = add_node :Comment, comment, [:id, :html_url, :body,
                                          :position, :line, :path, :commit_id,
                                          :created_at, :updated_at]

      add_relationship(:MADE_COMMENT, user_node, node)

      node
    end

    importer :Commit do |commit|
      author_node = import :User, commit.author if commit.author
      committer_node = import :User, commit.committer if commit.committer

      node = add_node(:Commit, commit, [:sha, :html_url]) do |props|
        props.commit_author_date = commit.commit.author.date
        props.commit_committer_date = commit.commit.committer.date

        props.commit_message = commit.commit.message

        props.stats = commit.stats.to_json
      end


      add_relationship(:AUTHORED, author_node, node) if author_node
      add_relationship(:COMMITTED, committer_node, node) if committer_node

      node
    end

    importer :User do |user|
      add_node :User, user, [:id, :login, :avatar_url, :gravatar_id, :type, :html_url, :site_admin]
    end

  end
end

