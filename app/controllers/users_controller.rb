class UsersController < ApplicationController
  def create
    # 重複チェック
    email = User.where email: params[:email]
    return if email.length != 0

    email = User.new({email: params[:email], password: params[:password] })
    email.save
  end

  def start_session
    if session[:user_name]
      logger.debug "#{session[:user_name]}でログインしています。"
    else
      logger.debug "ログインしていない。"
    end

    if params.key?(:name) || params.key?(:password)
      user = User.where(name: params[:name], password: params[:password])
      # if user && user.authenticate(params[:password])
      if user.length != 0
        logger.debug "ある"
        session[:user_name] = params[:name]
      else
        session[:user_name] = nil
      end
    end
  end

end
