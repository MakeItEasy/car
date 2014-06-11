ActiveAdmin.register Station do

  permit_params :name, :telephone, :province, :city, :district, :address, :recommend
  
  ## Scopes
  scope :all do |members|
    members.unscoped.default_order
  end
  scope :waiting do |members|
    members.unscoped.waiting.default_order
  end
  scope :reviewed do |members|
    members.unscoped.reviewed.default_order
  end
  scope :rejected do |members|
    members.unscoped.rejected.default_order
  end
  scope :locked do |members|
    members.unscoped.locked.default_order
  end

  ## Controller 
  controller do
  end

  ## 过滤条件
  filter :name
  filter :address


  ## form
  form partial: 'form'


  ## Actions
  index do
    selectable_column
    column :name
    column :status do |station|
      station.status_text
    end
    column :address do |station|
      "#{ChinaCity.get(station.province)}#{ChinaCity.get(station.city)}#{ChinaCity.get(station.district)}#{station.address}"
    end
    column :telephone
    actions
  end
  ## show
  show do
    attributes_table do
      row :name
      row :status do
        station.status_text
      end
      row :address do
        "#{ChinaCity.get(station.province)} #{ChinaCity.get(station.city)} 
        #{ChinaCity.get(station.district)} #{station.address}"
      end
      row :telephone
      row :recommend
      row :created_at do
        I18n.l(station.created_at)
      end
      row :updated_at do
        I18n.l(station.updated_at)
      end
    end
  end

  # 审核通过Action
  member_action :review, method: :post do
    station = Station.find(params[:id])
    authorize! :review, station
    if station.status_waiting?
      station.update_attributes!({status: 'reviewed', check_user_id: current_admin.id})
      redirect_to admin_console_station_path(station), notice: I18n.t("views.notice.station.reviewed")
    else
      redirect_to admin_console_station_path(station), alert: I18n.t("views.alert.status_error")
    end
  end

  # 拒绝Action
  member_action :reject, method: :post do
    station = Station.find(params[:id])
    authorize! :reject, station
    if station.status_waiting?
      # TODO dairg 使用model box，填写理由
      station.update_attributes!({status: 'rejected', check_user_id: current_admin.id})
      redirect_to admin_console_station_path(station), notice: I18n.t("views.notice.station.rejected")
    else
      redirect_to admin_console_station_path(station), alert: I18n.t("views.alert.status_error")
    end
  end

  # 锁定Action
  member_action :lock, method: :post do
    station = Station.find(params[:id])
    authorize! :lock, station
    if station.status_reviewed?
      station.update_attributes!({status: 'locked', lock_user_id: current_admin.id})
      redirect_to admin_console_station_path(station), notice: I18n.t("views.notice.station.locked")
    else
      redirect_to admin_console_station_path(station), alert: I18n.t("views.alert.status_error")
    end
  end

  # 解锁Action
  member_action :unlock, method: :post do
    station = Station.find(params[:id])
    authorize! :unlock, station
    if station.status_locked?
      station.update_attributes!({status: 'reviewed', lock_user_id: nil})
      redirect_to admin_console_station_path(station), notice: I18n.t("views.notice.station.unlocked")
    else
      redirect_to admin_console_station_path(station), alert: I18n.t("views.alert.status_error")
    end
  end

  ## Show页面的动作
  action_item only: :show do 
    link_to I18n.t("views.action.review"), review_admin_console_station_path(station), method: :post if authorized?(:review, station)
  end

  action_item only: :show do 
    link_to I18n.t("views.action.reject"), reject_admin_console_station_path(station), method: :post if authorized?(:reject, station)
  end
  action_item only: :show do 
    link_to I18n.t("views.action.lock"), lock_admin_console_station_path(station), method: :post if authorized?(:lock, station)
  end
  action_item only: :show do 
    link_to I18n.t("views.action.unlock"), unlock_admin_console_station_path(station), method: :post if authorized?(:unlock, station)
  end


  ## sidebar
  # sidebar "project detail", only: [:show, :edit] do
  #  div do
  #    "hello"
  #  end
  # end
end
