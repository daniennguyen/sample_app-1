module AccountActivationsHelper
  def edit
    user = User.find_by email: params[:email]

    if !user.activated? && user&.authenticated?(:activation, params[:id])
      update_attribute_to user
    else
      flash[:danger] = t :invalid_activation_link
      redirect_to root_url
    end
  end

  private

  def update_attribute_to user
    user.update activated: true
    user.update activated_at: Time.zone.now
    log_in user
    flash[:success] = t :account_active
    redirect_to user
  end
end
