class FavoritesController < ApplicationController
  def create
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> fav"
    logger.debug params[:imageID]
    return if !session[:user_id] || !params.key?(:imageID)

    # 重複チェック
    favorite = Favorite.where imageID: params[:imageID], userID: session[:user_id]
    return if favorite.length != 0

    favorite = Favorite.new({imageID: params[:imageID], userID: session[:user_id] })
    favorite.save
  end
end
