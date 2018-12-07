class FavoritesController < ApplicationController
  def create
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> fav"
    user = User.where(token: request.headers['X-CSRF-Token'])[0]

    return render json: { toast: @@toastNotLogin }, status: :unauthorized if user.blank?
    return render json: { toast: @@toastDuplicates }, status: :bad_request if Favorite.where(imageID: params[:imageID], userID: user.id).present?

    favorite = Favorite.new({imageID: params[:imageID], userID: user.id })
    favorite.save
  end

  def list
    render json: (Favorite.where userID: user.id)
  end

  def destroy
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> del"
    user = User.where(token: request.headers['X-CSRF-Token'])[0]

    return render json: { toast: @@toastNotLogin }, status: :unauthorized if user.blank?

    favorites = Favorite.where imageID: params[:imageID], userID: user.id
    favorites[0].destroy
  end
end
