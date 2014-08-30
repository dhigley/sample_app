# Listing 8.3: The initial Sessions controller
class SessionsController < ApplicationController

  def new
  end

  def create
    # Listing 8.13: Authenticate user and handle failed signin.
    # Exercise 8: Refactor the signin form to use form_tag in place of form_for
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      sign_in user
      redirect_back_or user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render "new"
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
