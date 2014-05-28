class Admin < ActiveRecord::Base
  ## 角色管理
  rolify

  ## 登录管理
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable, 
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable,
         :lockable

  ## Associations
  has_many :posts, foreign_key: :create_user_id

end
