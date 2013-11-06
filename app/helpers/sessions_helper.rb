module SessionsHelper
  def current_user=(user)
    @current_user = user
  end

  def current_user
    session_token = cookies[:session_token]
    encrypted_session_token = User.encrypt(session_token)
    @current_user ||= User.find_by(session_token: encrypted_session_token)
  end

  def sign_in(user)
    session_token = User.new_session_token
    cookies.permanent[:session_token] = session_token
    encrypted = User.encrypt(session_token)
    updated = user.update_attribute(:session_token, encrypted)

    self.current_user = user
  end

  def signed_in?
    !current_user.nil?
  end

  def sign_out
    self.current_user = nil
    cookies.delete(:session_token)
  end
end
