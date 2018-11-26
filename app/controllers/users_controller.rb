class UsersController < ApplicationController
  def create
    # 重複チェック
    email = User.where email: params[:email]
    return if email.length != 0

    email = User.new({email: params[:email], password: params[:password] })
    email.save
  end

  def start_session
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
    logger.debug params[:email]
    if session[:user_email]
      logger.debug "#{session[:user_email]}でログインしています。"
    else
      logger.debug "ログインしていない。"
    end

    if params.key?(:email) || params.key?(:password)
      user = User.where(email: params[:email], password: params[:password])
      logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      logger.debug user.length
      if user.length != 0
        logger.debug "ある"
        session[:user_email] = params[:email]
      else
        session[:user_email] = nil
      end
    end
  end

end
