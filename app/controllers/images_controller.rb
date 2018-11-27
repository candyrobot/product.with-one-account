class ImagesController < ApplicationController
  def index
    if params.key?(:related) && params.key?(:imageID)
      render json: (Favorite.where(imageID: params[:imageID]).map do |dat|
        Favorite.where(userID: dat.userID).map do |dat|
          dat
        end
      end)
    else
      render json: Image.all
    end
  end

  def create
    # 重複チェック
    # image = Image.where url: params[:url]
    # return if image.length != 0

    image = Image.new({url: params[:url] })
    image.save
  end

end
