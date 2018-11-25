class UsersController < ApplicationController
  def create
    # 重複チェック
    email = User.where email: params[:email]
    return if email.length != 0

    email = User.new({email: params[:email], password: params[:password] })
    email.save
  end

  def start_session
    # if session[:user_name]
    #   @notice = "#{session[:user_name]}でログインしています。"
    # end

    # if params.key?(:name) || params.key?(:password)
    #   user = User.find_by_name(params[:name])
    #   if user && user.authenticate(params[:password])
    #     session[:user_name] = params[:name]
    #   else
    #     session[:user_name] = nil
    #   end
    # end
  end

end
