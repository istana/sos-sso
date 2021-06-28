# Add the following to your Rake file to test routes by default:
#   Minitest::Rails::Testing.default_tasks << "routes"
require "test_helper"

class RouteTest < ActionDispatch::IntegrationTest
  def test_root
    assert_routing "/", controller: "rails_admin/main", action: "dashboard"
  end
end
