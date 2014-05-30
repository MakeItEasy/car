module WelcomeHelper
  def current_nav_class(action, catagory_id = nil)
    # TODO dairg 使用path进行比较
    if params[:controller] == "welcome"
      if params[:action] == action
        if catagory_id.present? 
          return (catagory_id.to_s == params[:catagory_id] ? 'active' : '')
        else
          return 'active'
        end
      end
    end
  end
end
