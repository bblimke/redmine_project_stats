require_dependency 'issue'


  module IssuePatch
    def story_points
      story_points_value.to_f
    end

    def unestimated
      story_points_value == "Estimate me"
    end

    private

      def story_points_value
        self.custom_values.detect {|cv| cv.custom_field.name == "Story points estimate"}.try(:value)
      end
  end


Issue.send(:include, IssuePatch)
