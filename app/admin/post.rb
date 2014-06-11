ActiveAdmin.register Post do

  permit_params :title, :content, :status, :catagory_id, :create_user_id
  
  ## Controller 
  controller do
    def create
      params[:post][:create_user_id] = current_admin.id
      super
    end

    def update
      params[:post][:status] = "draft"
      super
    end
  end

  ## Scopes
  scope :all do |members|
    members.unscoped.default_order
  end
  scope :draft do |members|
    members.unscoped.draft.default_order
  end
  scope :waiting do |members|
    members.unscoped.waiting.default_order
  end
  scope :published do |members|
    members.unscoped.published.default_order
  end
  scope :rejected do |members|
    members.unscoped.rejected.default_order
  end
  scope :locked do |members|
    members.unscoped.locked.default_order
  end
 
  ## 过滤条件
  filter :title
  filter :status

  ## Form
  form do |f|
    # TODO dairg I18n
    f.inputs "文章详细" do
      f.input :catagory
      f.input :title
      f.input :content, as: :ckeditor
    end
    f.actions
  end

  ## Actions
  index do
    selectable_column
    column :title
    column :status do |post|
      post.status_text
    end
    column :create_user_id do |post|
      post.admin.name
    end
    actions
  end

  show do
    attributes_table do
      row :title
      row :catagory
      row :status do
        post.status_text
      end
      row :create_user_id do
        post.admin.name
      end
      # TODO dairg check user name show
      row :check_user_id
      row :reject_reason
      row :lock_user_id
      row :created_at do
        I18n.l(post.created_at)
      end
      row :updated_at do
        I18n.l(post.updated_at)
      end
    end

    # div sanitize(post.content, attributes: %w(id class style))
    div class: 'panel' do
      h3 Post.human_attribute_name(:content)
      div class: 'panel_contents', style: 'padding:10px' do
        post.content.html_safe
      end
    end
  end

  # 编辑完成Action
  member_action :complete, method: :post do
    post = Post.find(params[:id])
    authorize! :complete, post
    if post.status_draft?
      # TODO dairg I18n
      post.update_attributes!({status: 'waiting'})
      redirect_to admin_console_post_path(post), notice: I18n.t("views.notice.post.completed")
    else
      redirect_to admin_console_post_path(post), alert: I18n.t("views.alert.post.status_error")
    end
  end

  # 发布Action
  member_action :publish, method: :post do
    post = Post.find(params[:id])
    authorize! :publish, post
    if post.status_waiting?
      post.update_attributes!({status: 'published', check_user_id: current_admin.id})
      redirect_to admin_console_post_path(post), notice: I18n.t("views.notice.post.published")
    else
      redirect_to admin_console_post_path(post), alert: I18n.t("views.alert.post.status_error")
    end
  end

  # 拒绝Action
  member_action :reject, method: :post do
    post = Post.find(params[:id])
    authorize! :reject, post
    if post.status_waiting?
      # TODO dairg 使用model box，填写理由
      post.update_attributes!({status: 'rejected', check_user_id: current_admin.id})
      redirect_to admin_console_post_path(post), notice: I18n.t("views.notice.post.rejected")
    else
      redirect_to admin_console_post_path(post), alert: I18n.t("views.alert.post.status_error")
    end
  end

  # 锁定Action
  member_action :lock, method: :post do
    post = Post.find(params[:id])
    authorize! :lock, post
    if post.status_published?
      post.update_attributes!({status: 'locked', lock_user_id: current_admin.id})
      redirect_to admin_console_post_path(post), notice: I18n.t("views.notice.post.locked")
    else
      redirect_to admin_console_post_path(post), alert: I18n.t("views.alert.post.status_error")
    end
  end

  ## Show页面的动作
  action_item only: :show do 
    link_to I18n.t("views.action.complete"), complete_admin_console_post_path(post), method: :post if authorized?(:complete, post)
  end

  action_item only: :show do 
    link_to I18n.t("views.action.publish"), publish_admin_console_post_path(post), method: :post if authorized?(:publish, post)
  end

  action_item only: :show do 
    link_to I18n.t("views.action.reject"), publish_admin_console_post_path(post), method: :post if authorized?(:reject, post)
  end

  action_item only: :show do 
    link_to I18n.t("views.action.lock"), publish_admin_console_post_path(post), method: :post if authorized?(:lock, post)
  end
  
  # See permitted parameters documentation:
  # https://github.com/gregbell/active_admin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # permit_params :list, :of, :attributes, :on, :model
  #
  # or
  #
  # permit_params do
  #  permitted = [:permitted, :attributes]
  #  permitted << :other if resource.something?
  #  permitted
  # end
 
end
