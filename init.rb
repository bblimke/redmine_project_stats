require 'redmine'

require 'dispatcher'

module ProjectStats
end

Redmine::Plugin.register :redmine_project_stats do
  name 'Redmine Project Stats plugin'
  author 'Author name'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'http://example.com/path/to/plugin'
  author_url 'http://example.com/about'

  permission :project_stats, { :project_stats => [:index] }, :public => true
  menu :project_menu, :project_stats, { :controller => 'project_stats', :action => 'index', :start_date => (Date.today - 10).to_s, :end_date => Date.today.to_s, :include_children => true}, :caption => 'Project Stats', :after => :new_issue, :param => :project_id

end

Dispatcher.to_prepare :redmine_project_stats do
  unless Issue.included_modules.include? IssuePatch
    Issue.send(:include, IssuePatch)
  end
  unless Project.included_modules.include? ProjectPatch
    Project.send(:include, ProjectPatch)
  end
end