module SessionsHelper

  # Listing 8.19: The complete (but not-yet-working) 'sign_in' function.
  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.digest(remember_token))
    self.current_user = user
  end

  # Listing 8.23: The 'signed_in?' helper method.
  def signed_in?
    !current_user.nil?
  end

  # Listing 8.20: Definign assignment to 'current_user'.
  def current_user=(user)
    @current_user = user
  end

  # Listing 8.22: Finding the current user using the 'remember_token'.
  def current_user
    remember_token = User.digest(cookies[:remember_token])
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  # Listing 9.15: The 'current_user?' method; used to determine if the user
  # information being requested matches the current user.
  def current_user?(user)
    user == current_user
  end

  # Listing 9.12: Require users to be signed in before using the 'edit' and 'update' actions.
  # Listing 10.24: Moving the signed_in_user method into the Sessions helper.
  def signed_in_user
    # Listing 9.18: Adding store_location to the signed-in user before filter.
    unless signed_in?
      store_location
      redirect_to signin_url, notice: "Please sign in."
    end
  end

  def sign_out
    current_user.update_attribute(:remember_token,
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end

  # # Listing 9.17: Code to implement friendly forwarding.
  # Listing 9.17: Code to implement friendly forwarding.
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

  def store_location
    session[:return_to] = request.url if request.get?
  end
end
