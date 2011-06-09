class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    
    if user.root?
      can :manage, :all
    else
      can :assign, Issue do |issue|
        issue.user == user or user.is_project_manager?
      end
      
      can :change_state, Issue do |issue|
        (not issue.assigned_user.nil?) and (issue.assigned_user == user or user.is_project_manager?)
      end
      
      can :manage_todo, Issue do |issue|
        (not issue.closed?) and (issue.assigned_user == user or issue.user == user)
      end
      
      can :manage, Issue do |issue|
        (not issue.closed?) and issue.user == user
      end
      
      can :manage, Comment do |comment|
        (not comment.issue.closed?) and comment.user == user
      end
      
      can :show, Document
      
      can :manage, Document do |doc|
        doc.user == user
      end

      can :manage_milestone, Project do |project|
        project.user == user
      end
    end
    
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
