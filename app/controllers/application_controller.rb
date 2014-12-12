class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception


  # Routing Error

  if !Rails.env.development?
    rescue_from Exception,                        with: :render_error
    rescue_from ActiveRecord::RecordNotFound,     with: :render_error
    rescue_from ActionController::RoutingError,   with: :render_error
  end

  def routing_error
    raise ActionController::RoutingError.new(params[:path])
  end

  def render_403(e = nil)
    render_error(403, e)
  end

  def render_404(e = nil)
    render_error(404, e)
  end

  def render_500(e = nil)
    render_error(500, e)
  end

  private

  def render_error(status_code, e = nil)
    logger.info "Rendering #{status_code} with exception: #{e.message}" if e
    #Airbrake.notify(e) if e # Airbrake/Errbit

    if request.xhr?
      render json: { error: "#{status_code} error" }, status: status_code
    else
      render template: "errors/error_#{status_code}", status: status_code, layout: 'application', content_type: 'text/html'
    end
  end
end
