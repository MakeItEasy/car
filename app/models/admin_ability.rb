class AdminAbility
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities

    user ||= Admin.new # guest user (not logged in)

    alias_action :create, :read, :update, :destroy, :to => :crud

    if user.is_superadmin?
      # 超级管理员
      can :manage, :all
    else
      # TODO dairg QA 版主和编辑的责任划分
      if user.is_moderator?
        # 版主
        can :read, Catagory
        can :read, Post
        can :destroy, Post
        can :publish, Post, :status => "waiting"
        can :reject, Post, :status => "waiting"
        can :lock, Post, :status => "published"
        # 可以删除附件以及图片
        can :destroy, Ckeditor::Picture
        can :destroy, Ckeditor::AttachmentFile
      end
      if user.is_editor?
        # 编辑
        can :read, Catagory
        can :read, Post
        can :create, Post
        can :update, Post, :create_user_id => user.id
        can :complete, Post, :create_user_id => user.id, :status => "draft"
        can :read, Ckeditor::Picture
        can :create, Ckeditor::Picture
      end
    end

    ### CkEditor相关权限
    # Always performed
    can :access, :ckeditor   # needed to access Ckeditor filebrowser
    # Performed checks for actions:
    can [:read, :create], Ckeditor::Picture
    can [:read, :create], Ckeditor::AttachmentFile

    can :show, Admin, :id => user.id
    can :update, Admin, :id => user.id
    can :read, ActiveAdmin::Page, :name => "Dashboard"
  end
end
