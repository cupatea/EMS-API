class FeedsController < ApplicationController
  before_action :authenticate_with_token!

  def show
    if current_user
      render json: PublicActivity::Activity.all
    else
      render json: { error: "Access denied"}
    end  
  end
end
