require 'test_helper'

class IssueTest < ActiveSupport::TestCase
  setup do
    @issue = Issue.new
  end

  test "required fields" do
    assert ! @issue.save

    @issue.title = "foobar"
    assert ! @issue.save

    @issue.content = "Just a test"
    assert ! @issue.save # user_id and project_id is required

    @issue.project_id = 1
    @issue.user_id = 1

    assert @issue.save
  end

  test "search issues" do
    build_search_index
    Issue.search_with_ferret(%(title:"bug")) do |index, id, score|
      assert_equal index[id][:id], issues(:bug_report).id.to_s
    end
  end

  def build_search_index
    index = Issue.get_index
    [:bug_report, :two].each do |key|
      item = issues(key)
      index << {:id => item.id, :title => item.title, :content => item.content}
    end
  end
end
