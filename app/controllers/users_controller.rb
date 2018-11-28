class UsersController < ApplicationController
  def create
    return render json: { toast: @@toastEmpty }, status: :bad_request if params[:email].blank?
    return render json: { toast: @@toastEmpty }, status: :bad_request if params[:password].blank?
    return render json: { toast: @@toastDuplicates }, status: :bad_request if User.where(email: params[:email]).present?

    email = User.new({email: params[:email], password: params[:password] })
    email.save
  end

  def login
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> login"
    return render json: { toast: @@toastEmpty }, status: :bad_request if params[:email].blank?
    return render json: { toast: @@toastEmpty }, status: :bad_request if params[:password].blank?
    if params.key?(:email) || params.key?(:password)
      user = User.where(email: params[:email], password: params[:password])
      if user.length != 0
        session[:user_id] = user[0].id
        logger.debug "🌟session start"
        logger.debug session[:user_id]
      else
        session[:user_id] = nil
      end
    end
  end

  def logout
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> logout"
    session[:user_id] = nil
    logger.debug session[:user_id]
  end

end
