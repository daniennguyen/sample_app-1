class FollowerController < ApplicationController
  def show
    @title = t :follower
    @user = User.find_by id: params[:id]
    @users = @user.followers.page params[:page]
    render "users/show_follow"
  end
end
