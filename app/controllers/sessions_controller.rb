class SessionsController < ApplicationController

  # Listing 8.3: The initial Sessions controller
  def new
  end

  def create
    # Listing 8.13: Authenticate user and handle failed signin.
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
    else
      flash.now[:error] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end
end
