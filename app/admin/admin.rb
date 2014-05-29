ActiveAdmin.register Admin do
  permit_params :email, :password, :password_confirmation, :name

  index do
    selectable_column
    column :email
    column :name
    column :telephone
    column :current_sign_in_at
    actions
  end

  filter :email
  filter :name
  filter :telephone

  form do |f|
    # TODO dairg I18n
    f.inputs "后台管理员详细" do
      f.input :email
      f.input :name
      f.input :telephone
      # f.input :password
      # f.input :password_confirmation
      # TODO dairg 管理员角色显示汉字
      f.input :roles
    end
    f.actions
  end

end
