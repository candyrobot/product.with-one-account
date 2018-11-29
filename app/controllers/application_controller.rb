class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  @@toastNotLogin = 'ログインしてません'
  @@toastEmpty = '入力値が空です'
  @@toastInvalidFileType = '拡張子が無効。別のURLを試して下さい'
  @@toastDuplicates = '既にデータベースに存在します'
  @@toastNotfound = 'データベースに存在しません'

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

  def isValidFileType(url)
    url.include?('.jpg') ||
    url.include?('.jpeg') ||
    url.include?('.png') ||
    url.include?('.gif') ||
    url.include?('.JPG') ||
    url.include?('.JPEG') ||
    url.include?('.PNG') ||
    url.include?('.GIF')
  end
end
