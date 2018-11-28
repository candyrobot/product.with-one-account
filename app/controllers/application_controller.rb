class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  def index
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> app"

    if params.key?(:imageID)
      images = Image.where(id: params[:imageID])
    elsif params.key?(:favorite) && session[:user_id]
      images = Image.all.reverse_order.select {|image|
        Favorite.where(imageID: image.id, userID: session[:user_id]).present?
      }.reverse
    else
      images = Image.all.reverse_order
    end

    render json: {
      images: images,
      favorites: Favorite.where(userID: session[:user_id]),
      session: {
        userID: session[:user_id],
        email: session[:user_id] && User.find(session[:user_id]).email
      }
    }
  end
end
