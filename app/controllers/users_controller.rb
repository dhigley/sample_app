class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  # Listing 7.21: A create action taht can handle signup failure.
  def create
    # Listing 7.22: Using strong parameters in the create action.
    @user = User.new(user_params)
    if @user.save
      # Listing 8.27: Signing in the user upon signup.
      sign_in @user
      # Listing 7.26: Redirecting the create action to the new user page.
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  # Listing 9.2: the user 'edit' action.
  def edit
    @user = User.find(params[:id])
  end

  # Listing 9.8: The user 'Update' action.
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      # Listing 9.10: Handle a succesfull update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  private

  # Listing 7.22: Requiring params hash to have a :user attribute and permit only given attributes.
  def user_params
    params.require(:user).permit(:name, :email, :password,
                                :password_confirmation)
  end
end
