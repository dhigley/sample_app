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

  def sign_out
    current_user.update_attribute(:remember_token, 
                                  User.digest(User.new_remember_token))
    cookies.delete(:remember_token)
    self.current_user = nil
  end
end
