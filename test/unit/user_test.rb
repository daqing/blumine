require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = users(:daqing)
  end

  test "should not create user when name or email is empty" do
    user = User.new
    assert ! user.save

    user.name = "daqing"
    assert ! user.save
  end

  test "should provide valid email address" do
    @user.email = "abc"
    assert ! @user.save
  end

  test "emails should be unique" do
    assert ! @user.save
  end

  test "password should be confirmed" do
    user = User.new(:name => "daqing", :email => "daqing1986@gmail.com", :password => "daqing")
    assert ! user.save

    user.password_confirmation = "foobar"
    assert ! user.save
  end

  test "create user" do
    user = User.new(:name => "daqing", :email => "daqing1986@gmail.com", :password => "daqing", :password_confirmation => "daqing")
    assert user.save
    assert ! user.salt.blank?
    assert ! user.encrypted_password.blank?
  end
end
