module LiveAssetsHelper
  # Returns an html script tag for app/assets/live_assets/application.js
  # i.e, <script src="app/assets/live_assets/application.js"/>
  def live_assets
    javascript_include_tag "live_assets/application"
  end
end