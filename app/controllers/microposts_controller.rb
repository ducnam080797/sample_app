class MicropostsController < ApplicationController
  before_action :logged_in_user, only: %i(create destroy)
  before_action :correct_user, only: %i(destroy)

  def create
    @micropost = current_user.microposts.build(micropost_params)

    if @micropost.save
      flash[:success] = t "micropost_created"
    else
      @feed_items = current_user.feed.page params[:page]
    end
    redirect_to root_url
  end

  def destroy
    if @micropost.destroy
      flash[:success] = t "micropost_deleted"
      redirect_to request.referrer || root_url
    else
      flash[:danger] = t "micropost_not_deleted"
      redirect_to root_url
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit :content, :picture
  end

  def correct_user
    @micropost = current_user.microposts.find_by id: params[:id]
    redirect_to root_url unless @micropost
  end
end
