# == Schema Information
# Schema version: 20110412132107
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  encrypted_password :string(255)
#  salt               :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#
require 'digest'

class User < ActiveRecord::Base
  attr_accessor :password
  attr_protected :encrypted_password, :salt

  validates :name, :email, :presence => true
  validates :password, :presence => true, :confirmation => true
  validates :password_confirmation, :presence => true

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :format => { :with => email_regex }

  before_validation :make_salt_and_encrypt_password
  validates :encrypted_password, :salt, :presence => true

  private
    def make_salt_and_encrypt_password
      self.salt = secure_hash("#{Time.now.utc}-_-!#{password}") if new_record?
      self.encrypted_password = secure_hash("#{salt}:-)#{password}")
    end

    def secure_hash(str)
      Digest::SHA2.hexdigest(str)
    end

end
