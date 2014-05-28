# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

=begin
Admin.create!(email: 'admin@car.com', 
              name: '代如刚',
              password: 'password',
              password_confirmation: 'password')

admin = Admin.where({email: 'admin@car.com'}).first
# 超级管理员
admin.add_role "superadmin"


normalAdmin = Admin.create!(email: 'normal@car.com', 
              name: '普通操作员',
              password: 'password',
              password_confirmation: 'password', telephone: '13100000000')

# 版主
normalAdmin.add_role "moderator"


Role.create!(name: "editor")
=end
