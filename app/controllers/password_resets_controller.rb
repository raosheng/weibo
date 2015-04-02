class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :chaeck_expiration, only: [:edit, :update]
  def new
  end
 
 def create
 	@user = User.find_by(email: params[:password_reset][:email].downcase)
 	if @user
 		@user.create_reset_digest
 		@user.send_password_reset_email
 		flash[:info] = "电子邮件发送的密码重置说明"
 		redirect_to root_url
 	   else
 	   	flash.now[:danger] = "电子邮件地址找不到"
 	   	render 'new'
 	   end
 	end
 	
  def edit
  end

def update
	if both_passwords_blank?
		flash.now[:danger] = "密码/确认不能为空"
		render 'edit'
	elsif @user.update_attributes(user_params)
		log_in @user
		flash[:sucess] = "密码已重置"
		redirect_to @user
	else
		render 'edit'
	end
end

  private
  def user_params
  	params.require(:user).permit(:password, :password_cofirmation)
  end

   #如果密码和密码确认都为空，返回true
   def both_passwords_blank?
   	params[:user][:password].blank? &&
   	params[:user][:password_confirmation].blank?
   end

   #事前过滤
  def get_user
  	@user = User.find_by(email: params[:email])
  end

  #确保是有效用户
  def valid_user
  	unless (@user && @user.activated? &&
  		    @user.authenticated?(:reset, params[:id]))
  	redirect_to root_url
  end
end

#检查重设令牌是否过期
def check_expiration
	if @user.password_reset_expired?
		flash[:danger] = "密码重置已过期"
		redirect_to new_password_reset_url
	end
end
end
