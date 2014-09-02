class UsersController < ApplicationController
  # Listing 9.12: Adding a signed_in_user before filter.
  before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
  # Listing 9.14: Listing 9.14: A correct_user before filter to protect the edit/update pages.
  before_action :correct_user,   only: [:edit, :update]
  # Listing 9.46: A before filter restricting the destroy action to admins.
  before_action :admin_user, only: :destroy
  # Exercise 9: Protect the 'new' and 'create' actions from signed in users.
  before_action :non_signed_in_user, only: [:new, :create]

  # Listing 9.21: Requiring a signed-in user for the index action.
  def index
    # Listing 9.23: The user index action.
    # Listing 9.34: Paginating the users in the 'index' action.
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    # Listing 10.19: Adding an @microposts instance variable to the user show action.
    @microposts = @user.microposts.paginate(page: params[:page])
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

  # Listing 9.2: The user 'edit' action.
  def edit
    # Listing 9.14: Finding the correct user is now handled by the correct_user before_action.
  end

  # Listing 9.8: The user 'Update' action.
  def update
    # Listing 9.14: Finding the correct user is now handled by the correct_user before_action.
    if @user.update_attributes(user_params)
      # Listing 9.10: Handle a succesfull update
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  # Listing 9.44: Adding a working destroy action.
  def destroy
    @user = User.find(params[:id])
    if current_user?(@user)
      redirect_to users_path, notice: "Admins are not able to destroy themselves."
    else
      @user.destroy
      flash[:success] = "User deleted."
      redirect_to users_url
    end
  end

  private

  # Listing 7.22: Requiring params hash to have a :user attribute and permit only given attributes.
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                  :password_confirmation)
    end

    # Before filters

    # Listing 9.12: Require users to be signed in before using the 'edit' and 'update' actions.
    def signed_in_user
      # Listing 9.18: Adding store_location to the signed-in user before filter.
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end

    # Exercise 9: Protect the 'new' and 'create' actions from signed in users.
    def non_signed_in_user
      redirect_to(root_url) if signed_in?
    end

    # Listing 9.14: Require that the user be the correct user before allowing
    # access to the 'edit' and 'update' actions.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
