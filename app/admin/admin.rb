ActiveAdmin.register Admin do
  # TODO dairg roles not saved
  permit_params :email, :password, :password_confirmation, :name, :telephone, roles: []

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
      # TODO dairg 管理员角色显示汉字
      f.input :roles
    end
    f.inputs "密码信息" do
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

  ## Controller 
  controller do
    def update_resource(object, attributes)
      update_method = attributes.first[:password].present? ? :update_attributes : :update_without_password
      object.send(update_method, *attributes)
    end
  end

  # 修改个人信息Action
  member_action :modify_personal_info, method: [:post, :get] do
    admin = Admin.find(params[:id])
    authorize! :modify_personal_info, admin
    if request.post?
    else
      render 'modify_personal_info'
    end
  end

  # 修改密码Action
  member_action :modify_password, method: [:patch, :get] do
    @admin = Admin.find(params[:id])
    authorize! :modify_password, @admin
    if request.patch?
      attributes = {password: params[:admin][:password],
                    password_confirmation: params[:admin][:password_confirmation]}
      if @admin.update_attributes(attributes)
        # TODO dairg
        if @admin.id == current_admin.id
          sign_in(Admin.find(current_admin.id), :bypass => true)
        end
        redirect_to admin_console_root_path, notice: I18n.t("views.notice.admin.modify_password_success")
      else
        render 'modify_password'
      end
    else
      render 'modify_password'
    end
  end
end
