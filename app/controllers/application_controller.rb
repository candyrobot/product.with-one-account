class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # protect_from_forgery with: :exception
  protect_from_forgery with: :null_session
  # protect_from_forgery except: ["create", "login"]

  @@toastNotLogin = 'ログインしていません'
  @@toastEmpty = '入力値が空です'
  @@toastInvalidFileType = '拡張子が無効。別のURLを試して下さい'
  @@toastDuplicates = '既にデータベースに存在します'
  @@toastNotfound = 'データベースに存在しません'

  def index
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> app"

    user = User.where(token: request.headers['X-CSRF-Token'])[0]

    render json: {
      images: Image.all.reverse_order,
      favorites: Favorite.all.reverse_order,
      session: user.present? && excludeFromUser(user)
    }
  end

  protected

  def excludeFromUser(user)
    sessionUser = user.attributes
    sessionUser.delete('password')
    return sessionUser
  end

  private

  # def isValidFileType(url)
  #   url.include?('.jpg') ||
  #   url.include?('.jpeg') ||
  #   url.include?('.png') ||
  #   url.include?('.gif') ||
  #   url.include?('.JPG') ||
  #   url.include?('.JPEG') ||
  #   url.include?('.PNG') ||
  #   url.include?('.GIF')
  # end
end
