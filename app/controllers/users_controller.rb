class UsersController < ApplicationController
  before_action :find_user, only: %i(show edit update destroy)
  before_action :logged_in_user, only: %i(index edit update destroy)
  before_action :correct_user, only: %i(edit update)
  before_action :admin_user, only: %i(destroy)

  def index
    @users = User.page(params[:page]).per Settings.page_of_user.pages_user
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      @user.send_activation_email
      flash[:info] = t "warn"
      redirect_to root_url
    else
      flash[:danger] = t "content3"
      render :new
    end
  end

  def show
    @btn_follow = current_user.active_relationships.build
    @btn_unfollow = current_user.active_relationships
                                .find_by followed_id: @user.id
    return unless @user.microposts
    @microposts = @user.microposts.order_desc.page(params[:page])
                       .per Settings.micropost_items_page
  end

  def edit; end

  def update
    if @user.update user_params
      flash[:success] = t "content4"
      redirect_to @user
    else
      flash[:danger] = t "content2"
      render :edit
    end
  end

  def destroy
    @user.destroy
    flash[:success] = t "content6"
    redirect_to users_url
  end

  def logged_in_user
    return false if logged_in?
    flash[:danger] = t "content5"
    redirect_to login_url
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end

  def find_user
    @user = User.find_by id: params[:id]

    return if @user
    flash[:danger] = t "content1"
    redirect_to root_path
  end

  def correct_user
    @user = User.find_by id: params[:id]
    redirect_to(root_url) unless @user.current_user?(current_user)
  end

  def admin_user
    redirect_to(root_url) unless current_user.admin?
  end
end
