class FavoritesController < ApplicationController
  def create
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> fav"
    logger.debug params[:imageID]
    return if !session[:user_id] || !params.key?(:imageID)

    # 重複チェック
    favorites = Favorite.where imageID: params[:imageID], userID: session[:user_id]
    return if favorites.length != 0

    favorite = Favorite.new({imageID: params[:imageID], userID: session[:user_id] })
    favorite.save
  end

  def list
    render json: (Favorite.where userID: session[:user_id])
  end

  def destroy
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> del"
    favorites = Favorite.where imageID: params[:imageID], userID: session[:user_id]
    favorites[0].destroy
  end
end
