class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create
  def create
    user = User.create(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    if user.valid?
      render json: auth_token
    else
      render json: { error: user.errors, status: 422 }
    end
  end

    private

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end
  end
