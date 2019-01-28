class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      log_in @user
      redirect_to @user
      flash[:success] = t :success_to_create_user
    else
      render :new
      flash[:danger] = t :fail_to_create_user
    end
  end

  def show
    @user = User.find_by id: params[:id]

    return if @user
    redirect_to :new
    flash[:danger] = t :fail_to_load_user
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
