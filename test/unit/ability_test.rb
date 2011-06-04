require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  setup do
    @user = users(:daqing)
    @issue = issues(:bug_report)
  end

  test "only creator of an issue or PM can assign issues" do
    ability = Ability.new(@user)
    assert ability.can? :assign, @issue

    another = users(:two)
    another.role = 'ProjectManager'
    a2 = Ability.new(another)
    assert a2.can? :assign, @issue

    another.role = 'Developer'
    assert a2.cannot? :assign, @issue
  end

  test "should not change state before the issue is assigned" do
    @issue.assigned_user = nil
    
    ability = Ability.new(@user)
    # only root can change issue state even if the issue has not been assigned
    assert ability.can? :change_state, @issue

    two = users(:two)
    a2 = Ability.new(two)
    assert a2.cannot? :change_state, @issue
    
    two.role = 'ProjectManager'
    assert a2.cannot? :change_state, @issue
  end

  test "only creator of an issue, PM or assigned user can change issue state after the issue is assigned" do
    @issue.assigned_user = users(:daqing)

    another = users(:two)
    another.role = 'ProjectManager'
    ability = Ability.new(another)
    assert ability.can? :change_state, @issue

    another.role = 'Developer'
    assert ability.cannot? :change_state, @issue

    @issue.assigned_user = another
    assert ability.can? :change_state, @issue
  end

  test "only assinged user can manage todo items" do
    two = users(:two)
    @issue.assigned_user = @user
    ability = Ability.new(two)
    assert ability.cannot? :manage_todo, @issue

    @issue.assigned_user = two
    assert ability.can? :manage_todo, @issue

    @issue.close!
    assert ability.cannot? :manage_todo, @issue
  end

  test "only issue creator can manage issue when issue's not closed" do
    @issue.work_on!
    issue_two = issues(:two)
    ability = Ability.new(users(:two))

    issue_two.work_on!
    assert ability.can? :manage, issue_two
    
    a2 = Ability.new(users(:nana))
    assert a2.cannot? :manage, issue_two

    issue_two.mark_finished!
    issue_two.close!
    assert ability.cannot? :manage, issue_two
  end

  test "only creator can manage comments when the related issue is not closed" do
    comment = comments(:two)
    ability = Ability.new(users(:two))
    issue = comment.issue
    issue.work_on!
    assert ability.can? :manage, comment
    
    a2 = Ability.new(users(:nana))
    assert a2.cannot? :manage, comment

    issue.mark_finished!
    issue.close!
    assert ability.cannot? :manage, comment
  end
end