# == Schema Information
# Schema version: 20110415041713
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
#  persistence_token  :string(255)
#

require 'digest'

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :email
    c.crypted_password_field = :encrypted_password
    c.password_salt_field = :salt
    c.validates_length_of_password_field_options = {:minimum => 1} 
  end

  has_many :projects
  has_many :issues
  has_many :comments
  has_many :status_logs

  has_many :issue_assignments
  has_many :assigned_issues, :through => :issue_assignments, :source => :issue, :order => 'position ASC'

  attr_protected :encrypted_password, :salt

  validates :name, :email, :presence => true
  validates :email, :uniqueness => true
  validates :password, :presence => true, :confirmation => true
  validates :password_confirmation, :presence => true

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :format => { :with => email_regex }
end
