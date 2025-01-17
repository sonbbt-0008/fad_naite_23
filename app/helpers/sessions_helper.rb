module SessionsHelper
  def log_in user
    session[:user_id] = user.id
  end

  def redirect_back_or default
    redirect_to(session[:forwarding_url] || default)
    session.delete :forwarding_url
  end

  def logged_in?
    current_user.present?
  end

  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by id: user_id
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by id: user_id
      if user&.authenticated? remember, cookies[:remember_token]
        log_in user
        @current_user = user
      end
    end
  end

  def log_out
    forget current_user
    session.delete :user_id
    @current_user = nil
  end

  def remember user
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget user
    user.forget
    cookies.delete :user_id, :remember_token
  end

  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end

  def current_user? user
    current_user == user
  end

  def current_rating
    if current_user.rated? @product
      current_user.ratings.find_by product_id: @product.id
    else
      current_user.ratings.build
    end
  end

  def toggled_rating? rate_points
    rate_points <= current_rating.rate.to_i ? "btn-warning" : "btn-default"
  end

  def logged_admin?
    logged_in? && current_user.admin?
  end
end
