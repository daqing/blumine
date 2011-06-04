require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:daqing)
    @issue = issues(:bug_report)
  end

  test "should not create user when name or email is empty" do
    user = User.new
    assert ! user.valid?

    user.name = "daqing"
    assert ! user.valid?
  end

  test "should provide valid email address" do
    user = User.new(:name => "daqing", :email => "abc", :password => "pop", :password_confirmation => "pop")
    assert ! user.valid?
  end

  test "emails should be unique" do
    another_user = User.new({:name => "another", :email => @user.email, :password => "another_user", :password_confirmation => "another_user"})
    assert ! another_user.valid?
  end

  test "password should be confirmed" do
    user = User.new(:name => "daqing", :email => "daqing1986@gmail.com", :password => "daqing")
    assert ! user.valid?

    user.password_confirmation = "foobar"
    assert ! user.valid?
  end

  test "create user" do
    user = User.new(:name => "daqing", :email => "daqing1986@gmail.com", :password => "daqing", :password_confirmation => "daqing")
    assert user.valid?
    assert ! user.salt.blank?
    assert ! user.encrypted_password.blank?
  end
end
