require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "should not create user when name or email is empty" do
    user = User.new
    assert ! user.save

    user.name = "daqing"
    assert ! user.save
  end

  test "should provide valid email address" do
    user = User.new(:name => "daqing", :email => "foobar", :password => "abc", :password_confirmation => "abc")
    assert ! user.save
  end

  test "password should be confirmed" do
    user = User.new(:name => "daqing", :email => "daqing1986@gmail.com", :password => "daqing")
    assert ! user.save

    user.password_confirmation = "foobar"
    assert ! user.save
  end

  test "create user" do
    user = User.new(:name => "daqing", :email => "daqing1986@gmail.com", :password => "love", :password_confirmation => "love")
    assert user.save
  end
end
