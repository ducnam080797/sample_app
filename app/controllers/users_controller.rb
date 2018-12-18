class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new user_params

    if @user.save
      flash[:success] = t "content"
      redirect_to @user
    else
      flash[:danger] = t "content3"
      render :new
    end
  end

  def show
    @user = User.find_by id: params[:id]

    if @user
      flash[:success] = t "content1"
    else
      flash[:danger] = t "content2"
      redirect_to root_url
    end
  end

  private

  def user_params
    params.require(:user)
          .permit :name, :email, :password, :password_confirmation
  end
end
