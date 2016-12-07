module Calypso

  module GithubClient

    module ProjectsAPI

      def project(name)
        projects = fetch(projects_url)
        projects.select { |p| p['name'] == name }.first
      end

      def project_issues(project_name:, column_name: nil, state: 'closed')
        project = project(project_name)
        column = column_name ? column(project, column_name) : nil
        issues_ids = cards(project: project, column: column).map do |card|
          issue_url = card['content_url']
          next if issue_url.nil?
          issue_url[/http.*[^0-9]([0-9]+)$/, 1].to_i
        end.compact
        issues(state: state).select { |i| issues_ids.include?(i['number']) }
      end

      def column_cards(project_name:, column_name:)
        project = project(project_name)
        column = column(project, column_name)
        fetch(cards_url(column))
      end

      def drop_cards(cards)
        cards.each do |card|
          delete(delete_card_url(card))
        end
      end

      private

      def column(project, name)
        columns(project).select { |c| c['name'] == name }.first
      end

      def columns(project)
        fetch(columns_url(project['id']))
      end

      def cards(project:, column: nil)
        if column.nil?
          cards = []
          columns(project).each do |col|
            print "#{col['name']} > "
            column_cards = cards(project: project, column: col)
            cards += column_cards
          end
          cards
        else
          fetch(cards_url(column))
        end
      end

      def projects_url
        repos_url('projects')
      end

      def columns_url(project_id)
        api_url(path: "projects/#{project_id}/columns")
      end

      def cards_url(column)
        api_url(path: "projects/columns/#{column['id']}/cards")
      end

      def delete_card_url(card)
        api_url(path: "projects/columns/cards/#{card['id']}")
      end

    end

  end

end
