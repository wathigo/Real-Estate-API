class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create
  def create
    user = User.create(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    if user.valid?
      render json: { auth_token: auth_token.result }
    else
      render json: { error: user.errors }, status: :unauthorized
    end
  end

  def show
    render json: current_user
  end

  private

  def user_params
    params.require(:user).permit(
      :name, :email, :password, :password_confirmation
    )
  end
end
