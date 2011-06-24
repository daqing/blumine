require 'test_helper'

class RedirectAfterLoginTest < ActionDispatch::IntegrationTest
  fixtures :all

  setup do
    Project.destroy_all
  end

  test "should redirect to create project page when no projects" do
    assert_equal 0, Project.count

    register_as_foobar
    assert_redirected_to new_project_path
  end

  test "should redirect to project page if there's only one project" do
    users(:daqing).projects.create!(:name => "foobar")
    assert_equal 1, Project.count

    register_as_foobar
    assert_redirected_to project_path(Project.first)
  end

  test "should redirect to project index page if there're many projects" do
    users(:daqing).projects.create!(:name => "foobar")
    users(:daqing).projects.create!(:name => "foobar2")
    assert_equal 2, Project.count

    register_as_foobar
    assert_redirected_to projects_path
  end
end
