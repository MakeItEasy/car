## 车检站
class StationController < FrontBaseController

  ## 一览
  def list
    set_nav_field
  end

  ## 预约
  # TODO dairg 暂时放到这里
  def order
    set_nav_field
    @steps = steps
    @current_step = steps.first
    session[:current_step] = @current_step
  end

  def step
    set_nav_field
    @steps = steps
    @current_step = session[:current_step]
    if params[:type] == 'next'
      @current_step = steps[steps.index(@current_step)+1] || steps.first
    elsif params[:type] == 'pre'
      @current_step = steps[steps.index(@current_step)-1]
    end
    session[:current_step] = @current_step

    render :order
  end

private
  def steps
    %w[select_station select_date basic_info confirmation success]
  end

end
