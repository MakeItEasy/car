class WelcomeController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  layout "front"

  ## 主页
  def index
    @catagories = Catagory.all
  end

  ## 文章列表页
  def list_posts
    @catagories = Catagory.all
    @catagory = Catagory.find(params[:catagory_id])
    # TODO dairg 404共通页面处理
    
  end

  ## 文章明细页
  def show_post
    @catagories = Catagory.all
  end

end
