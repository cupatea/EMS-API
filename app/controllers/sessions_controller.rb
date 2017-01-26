class SessionsController < ApplicationController
  def create
    user_password = params[:session][:password]
    user_email = params[:session][:email]
    user = user_email.present? && User.find_by(email: user_email)

    if user and user.valid_password? user_password
      sign_in user, store: false
      user.generate_authentication_token!
      user.save
      render json: user, status: 200
    else
      render json: { errors: "Invalid email or password" }, status: 422
    end
  end

  def destroy
    user = User.find_by(auth_token: params[:auth_token])
    if user
      user.generate_authentication_token!
      user.save
      render json: { status: "Successfuly loged out"}
    else
      render json: { status: "Not found"}, status: 404
    end
  end
end
