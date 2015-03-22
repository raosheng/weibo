class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:session][:email].downcase)
  	if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1'? remember(user):forget(user)
      redirect_back_or user
  		#登入用户，然后重定向到用户的资料页面
  	else
  		flash.now[:danger] = '无效的电子邮件/密码组合' #不完全正确
  	  render 'new'
  end
end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
