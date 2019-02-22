class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy

  def index
    @search = User.all.ransack params[:q] 
    @users = User.all.page(params[:page]).per params[:limit] 
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      logged_and_redirect_to @user
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

  def update
    if @user.update :user_params
      flash[:success] = t :update_success
      redirect_to @user
    else
      render :edit
      flash[:success] = t :update_failed
    end
  end

  def edit; end

  def destroy
    User.find_by(params[:id]).destroy
    flash[:success] = t :delete_success
    redirect_to users_path 
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end
end
