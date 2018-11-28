class FavoritesController < ApplicationController
  def create
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> fav"
    return render json: { toast: @@toastNotLogin }, status: :unauthorized if session[:user_id].blank?
    return render json: { toast: @@toastDuplicates }, status: :bad_request if Favorite.where(imageID: params[:imageID], userID: session[:user_id]).present?

    favorite = Favorite.new({imageID: params[:imageID], userID: session[:user_id] })
    favorite.save
  end

  def list
    render json: (Favorite.where userID: session[:user_id])
  end

  def destroy
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> del"
    return render json: { toast: @@toastNotLogin }, status: :unauthorized if session[:user_id].blank?

    favorites = Favorite.where imageID: params[:imageID], userID: session[:user_id]
    favorites[0].destroy
  end
end
