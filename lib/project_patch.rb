require_dependency 'project'


  module ProjectPatch
    def unestimated_issues_count(options = {})
      not_done_issues(options).select(&:unestimated).size
    end

    def remaining_story_points(options = {})
      not_done_issues(options).map(&:story_points).sum
    end

    def points_done_within(start_date, end_date, options = {})
      resolved_issues_within(start_date, end_date, options).map {|issue| issue.story_points }.sum
    end

    protected

      def not_done_issues(options = {})
        if options[:include_children]
          self.hierarchy.map{|p| p.not_done_issues_for_this_project}.flatten
        else
          self.not_done_issues_for_this_project
        end
      end

      def not_done_issues_for_this_project
        self.issues.select {|i|
          i.status.name == "New" || i.status.name == "Assigned" || i.status.name == "Feedback"
        }
      end

      def resolved_issues_within(start_date, end_date, options = {})
        resolved_issue_changes_within(start_date, end_date, options).map(&:issue)
      end

      def resolved_issue_changes_within(start_date, end_date, options = {})
        if options[:include_children]
          self.hierarchy.map {|p| p.resolved_issue_changes_for_this_project_within(start_date, end_date) }.flatten
        else
          self.resolved_issue_changes_for_this_project_within(start_date, end_date)
        end
      end

      def resolved_issue_changes_for_this_project_within(start_date, end_date)
        resolved_status_id = IssueStatus.find_by_name('Resolved').id
        issue_changes.select { |issue_change|
          detail = issue_change.details.last
          issue_change.created_on.to_date <= end_date && issue_change.created_on.to_date >= start_date && detail && detail.value.to_i == 3
        }
      end
  end

Project.send(:include, ProjectPatch)
