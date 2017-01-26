class UsersController < ApplicationController
  before_action :authenticate_with_token!, only: [:update, :destroy]
  respond_to :json

  def create
    user = User.new(permitted_user_params)
    if user.save
      render json: user, status: 201
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def update
    user = current_user

    if user.update permitted_user_params
      render json: user, status: 200
    else
      render json: { errors: user.errors }, status: 422
    end
  end

  def destroy
    if current_user.destroy
      render status: 200
    end
  end

  private

  def permitted_user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end
end
