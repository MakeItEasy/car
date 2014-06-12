# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Admin.transaction do
  Admin.create!(email: 'admin@car.com', 
                name: '代如刚',
                password: 'password',
                password_confirmation: 'password', telephone: '13100000000')

  admin = Admin.where({email: 'admin@car.com'}).first
  # 超级管理员
  admin.add_role "superadmin"

  # 版主
  moderatorAdmin = Admin.create!(email: 'moderator@car.com', 
                name: '版主',
                password: 'password',
                password_confirmation: 'password', telephone: '14100000000')
  # 版主
  moderatorAdmin.add_role "moderator"

  # 编辑
  editorAdmin = Admin.create!(email: 'editor@car.com', 
                name: '编辑',
                password: 'password',
                password_confirmation: 'password', telephone: '15100000000')
  # 编辑
  moderatorAdmin.add_role "editor"
  puts "Admin done"
end


## catagory分类
Catagory.transaction do
  Catagory.create!(id: 1, name: "车检知识", order: 1)
  Catagory.create!(id: 2, name: "车检流程", order: 2)
  Catagory.create!(id: 3, name: "维修知识", order: 3)
  puts "Catagory done"
end
