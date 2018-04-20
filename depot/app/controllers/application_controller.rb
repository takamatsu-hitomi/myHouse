class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params

	# このアプリケーションのすべてのアクションの前にauthorizeが実行されるようになるよ
	# 適応しない場合はそのコントローラーにskip_before_action :authorizeを入れよう
	before_action :authorize
  protect_from_forgery with: :exception

  private
  def current_cart
  	Cart.find(session[:cart_id])
  rescue ActiveRecord::RecordNotFound
  	cart = Cart.create
  	session[:cart_id] = cart.id
  	cart
  end

  private
  def authorize
    puts "ログイン確認"
  	unless User.find_by_id(session[:user_id])
      puts "ログインしてください"
  		redirect_to login_url, notice: "ログインしてください"
  	end
  end

  private
  def set_i18n_locale_from_params
    if params[:locale]
      if I18n.available_locales.include?(params[:locale].to_sym)
        I18n.locale = params[:locale]
      else
        flash.now[:notice] =  
        "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
      end
    end
  end

  def default_url_options
    {locale: I18n.locale}
  end
end
