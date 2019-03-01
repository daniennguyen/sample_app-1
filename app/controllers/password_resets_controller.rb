class PasswordResetsController < ApplicationController
  before_action :find_user, :valid_user, :check_expiration, only: %i(edit update)

  def new; end

  def create
    @user = User.find_by email: params[:password_reset][:email].downcase!

    if @user
      sent_password_reset_instructionss @user
    else
      flash.now[:danger] = t :not_found_email
      render :new
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      @user.errors.add :password, t(:not_empty)
      render :edit
    elsif @user.update :user_params
      log_in_and_redirect_to @user
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit :password, :password_confirmation
  end

  def find_user
    return if @user = User.find_by email: params[:email]
    flash[:danger] = t :user_not_found
    redirect_to root_pathactive
  end

  def valid_user
    condition = @user&.activated?&.authenticated?(:reset, params[:id])
    redirect_to root_url unless condition
  end

  def check_expiration
    return unless @user.password_reset_expired?
    flash[:danger] = t :password_expire
    redirect_to new_password_reset_url
  end

  def log_in_and_redirect_to user
    log_in user
    user.update reset_digest: nil
    flash[:success] = t :reseted_password
    redirect_to user
  end

  def sent_password_reset_instructions user
    user.create_reset_digest
    user.send_password_reset_email
    flash[:info] = t :email_and_password_reset_instructions
    redirect_to root_url
  end
end
