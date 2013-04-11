module SessionHelper
  
  def sign_in(user)
    user.session_id = SecureRandom.hex(16)
    user.save!    
    cookies[:session_id] = user.session_id
    self.current_user = user
  end

  def sign_out_user
    cookies.delete :session_id
  end

  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    if cookies[:session_id]
      @current_user ||= User.find_by_session_id(cookies[:session_id])
    else
      nil
    end
  end

  def signed_in?
    !current_user.nil?
  end
  
  def redirect_home_if_signed_in
    redirect_to root_path if signed_in?
  end 
end