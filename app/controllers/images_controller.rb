class ImagesController < ApplicationController
  def list
    if params.key?(:related) && params.key?(:imageID)
      render json: (Favorite.where(imageID: params[:imageID]).map do |dat|
        Favorite.where(userID: dat.userID).map do |dat|
          Image.find(dat.imageID)
        end
      end)
    else
      render json: Image.all.reverse_order
    end
  end

  def create
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> create"
    return render json: { toast: @@toastEmpty } if params[:url].blank?
    # return render json: { toast: @@toastInvalidFileType } if !isValidFileType params[:url]
    return render json: { toast: @@toastDuplicates } if Image.where(url: params[:url]).present?

    image = Image.new({url: params[:url] })
    image.save
  end

end
