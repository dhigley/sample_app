# Listing 10.25: Adding authentication to the Microposts controller actions.
class MicropostsController < ApplicationController
  before_action :signed_in_user
  # Listing 10.46: The Microposts controller destroy action.
  before_action :correct_user,   only: :destroy

  # Listing 10.27: The Microposts controller create action.
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Micropost created!"
      redirect_to root_url
    else
      # Listing 10.42: Adding an (empty) @feed_items instance variable to the create action.
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    # Listing 10.46: The Microposts controller destroy action.
    @micropost.destroy
    redirect_to root_url
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content)
    end

    # Listing 10.46: The Microposts controller destroy action.
    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
