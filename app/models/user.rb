# encoding: utf-8

# == Schema Information
# Schema version: 20110503080934
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
#  locale             :string(255)
#  role               :string(255)
#

require 'digest'

class User < ActiveRecord::Base
  acts_as_authentic do |c|
    c.login_field = :email
    c.crypted_password_field = :encrypted_password
    c.password_salt_field = :salt
    c.validate_password_field = false
    c.ignore_blank_passwords = true
  end

  ROLES = %w(ProjectManager Developer Designer SystemAdministrator Marketer)
  AVAILABLE_LANGUAGES = {:zh => '中文', :en => 'English'}

  has_many :projects, :dependent => :destroy
  has_many :issues, :dependent => :destroy
  has_many :comments, :dependent => :destroy
  has_many :activities, :dependent => :destroy

  has_many :issue_assignments, :dependent => :destroy
  has_many :assigned_issues, :through => :issue_assignments, :source => :issue, :order => 'position ASC'

  attr_protected :encrypted_password, :salt, :persistence_token, :role

  validates :name, :email, :presence => true
  validates :email, :uniqueness => true
  validates :password, :presence => true, :confirmation => true, :on => :create
  validates :password_confirmation, :presence => true, :on => :create

  validates :password, :presence => true, :confirmation => true, :on => :update, :unless => "self.password.blank?"
  validates :password_confirmation, :presence => true, :on => :update, :unless => "self.password.blank?"

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, :format => { :with => email_regex }

  # role and permissions
  
  ROLES.each do |role|
    define_method("is_#{role.underscore}?") { self.role == role }
  end

  def role_name
    I18n.t("role.#{self.role}") if self.role
  end

  def root?
    self.id == 1 || self.role == 'root'
  end
end
