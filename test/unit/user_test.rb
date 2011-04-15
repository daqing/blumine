require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @params = {:name => "test", :email => "daqing@demo.com", :password => "foobar", :password_confirmation => "foobar"}
    @user = User.new(@params)
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
    assert @user.save
    clone = User.new(@params)

    assert ! clone.save # because emails should be unique
  end

  test "password should be confirmed" do
    user = User.new(:name => "daqing", :email => "daqing1986@gmail.com", :password => "daqing")
    assert ! user.save

    user.password_confirmation = "foobar"
    assert ! user.save
  end

  test "create user" do
    assert @user.save
    assert ! @user.salt.blank?
    assert ! @user.encrypted_password.blank?
  end
end
