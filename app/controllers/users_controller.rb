class UsersController < ApplicationController
  skip_before_action :authenticate_request, only: :create
  def create
    user = User.create(user_params)
    if user.valid?
      auth_token = AuthenticateUser.new(user.email, user.password).call 
      render json: { auth_token: auth_token.result, current_user: current_user }
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
