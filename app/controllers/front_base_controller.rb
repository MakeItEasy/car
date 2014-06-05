class FrontBaseController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout "front"

  rescue_from ActiveRecord::RecordNotFound do |exception|
    # TODO dairg 404画面定制：使用front模版，保证菜单栏和footer显示
    render File.join(Rails.root, 'public', '404'), formats: [:html], status: 404, layout: false
  end

private

  def set_nav_field
    # 菜单catagory的设置
    @catagories = Catagory.all
  end

end
