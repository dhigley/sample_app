class StaticPagesController < ApplicationController

  def home
    # Listing 10.38: Added a test for signed in status.
    if signed_in?
      # Listing 10.31: Adding a micropost instance variable to the home action.
      @micropost = current_user.microposts.build if signed_in?
      # Listing 10.38: Adding a feed instance variable to the home action.
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end

  def help
  end

  # Listing 3.16: Add about action in the StaticPages controller
  def about
  end

  # Excercise 3: Make a Contact page
  def contact
  end
end
