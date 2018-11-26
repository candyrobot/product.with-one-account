class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def index
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> app"

    if params.key?(:imageID)
      images = Image.where(id: params[:imageID])
    else
      images = Image.all
    end

    render json: {
      images: images,
      session: {
        userID: session[:user_id]
      }
    }
  end
end
