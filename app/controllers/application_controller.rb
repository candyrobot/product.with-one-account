class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def index
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> app"
    logger.debug session[:user_id]

    render json: {
      images: Image.all,
      session: {
        userID: session[:user_id]
      }
    }
  end
end
