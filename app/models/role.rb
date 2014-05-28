class Role < ActiveRecord::Base
  has_and_belongs_to_many :admins, :join_table => :admins_roles
  belongs_to :resource, :polymorphic => true
  
  scopify


  ###
  # superadmin: 超级管理员
  # moderator: 版主
  # editor: 网站编辑
  ###
end
