class UsersController < ApplicationController
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: :destroy

  def index
    @search = User.all.ransack params[:q]
    @users = User.all.page(params[:page]).per params[:limit]
  end

  def show
    @user = User.find_by id: params[:id]
    @microposts = @user.microposts.order_desc.page(params[:page])
                       .per Settings.micropost_items
    redirect_and_show @user
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

  def edit; end

  def update
    if @user.update :user_params
      flash[:success] = t :update_success
      redirect_to @user
    else
      render :edit
      flash[:success] = t :update_failed
    end
  end

  def destroy
    if @user.destroy
      flash[:success] = t :delete_success
      redirect_to users_path
    else
      flash[:danger] = t :delete_fail
      redirect_to root_path
    end
  end

  private

  def user_params
    params.require(:user).permit :name, :email, :password,
      :password_confirmation
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to root_url unless @user.current_user? current_user
  end

  def admin_user
    redirect_to root_url unless current_user.admin?
  end

  def redirect_and_show user
    return if user
    redirect_to :new
    flash[:danger] = t :fail_to_load_user
  end
end
