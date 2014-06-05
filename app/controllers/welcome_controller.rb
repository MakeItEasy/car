class WelcomeController < FrontBaseController
  ## 主页
  def index
    set_nav_field
  end

  ## 文章列表页
  def list_posts
    set_nav_field
    @catagory = Catagory.find(params[:catagory_id])
    # TODO dairg 404共通页面处理
  end

  ## 文章明细页
  def show_post
    set_nav_field
    @catagory = Catagory.find(params[:catagory_id])
    @post = Post.find(params[:post_id])
    # 如果post不是发布状态，那么返回404
    raise ActiveRecord::RecordNotFound unless @post.status_published?
    @pre_post = @post.pre_published_post
    @next_post = @post.next_published_post
  end

  ## 预约
  # TODO dairg 暂时放到这里
  def order
    set_nav_field
  end

end
