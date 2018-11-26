class FavoritesController < ApplicationController
  def create
    return if !session[:user_id] || !params.key?(:imageID)

    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    logger.debug "通過"

    # 重複チェック
    favorite = Favorite.where imageID: params[:imageID]
    return if favorite.length != 0

    favorite = Favorite.new({favorite: params[:favorite], userID: session[:user_id] })
    favorite.save
  end
end
