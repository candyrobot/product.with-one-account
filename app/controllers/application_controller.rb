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
      favorites: Favorite.where(userID: session[:user_id]),
      session: {
        userID: session[:user_id],
        email: User.find(session[:user_id]).email
      }
    }
  end
end
