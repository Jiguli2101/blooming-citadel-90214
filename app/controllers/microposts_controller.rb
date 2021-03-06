class MicropostsController < ApplicationController
  before_action :correct_user,   only: [:destroy]
  before_action :set_micropost,  only: [:vote]
  before_action :logged_in_user, only: [:create, :destroy]
  respond_to :js, :json, :html

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  def vote
    if !current_user.liked? @micropost
      @micropost.liked_by current_user
    elsif current_user.liked? @micropost
      @micropost.unliked_by current_user
    end

    redirect_to root_url
  end

  private

  def correct_user
    @micropost = current_user.microposts.find(params[:id])
    redirect_to root_url if @micropost.nil?
  end

  def set_micropost
    @micropost = Micropost.find(params[:id])
  end

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end
end