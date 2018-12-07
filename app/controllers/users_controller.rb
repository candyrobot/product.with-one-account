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
      user = User.where(email: params[:email], password: params[:password])[0]
      return render json: { toast: @@toastNotfound }, status: :bad_request if user.blank?
      
      return render json: {
        session: excludeFromUser(user)
      }
    end
  end

  def logout
    logger.debug ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> logout"
    # INFO: no more logout system from server-side. 
  end

end
