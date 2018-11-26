class UsersController < ApplicationController
  def create
    # 重複チェック
    email = User.where email: params[:email]
    return if email.length != 0

    email = User.new({email: params[:email], password: params[:password] })
    email.save
  end

  def login
    if params.key?(:email) || params.key?(:password)
      user = User.where(email: params[:email], password: params[:password])
      logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>"
      if user.length != 0
        logger.debug "🌟session start"
        session[:user_id] = params[:id]
      else
        session[:user_id] = nil
      end
    end
  end

  def logout
    session[:user_id] = nil
  end

end
