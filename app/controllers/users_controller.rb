class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :following, :followers]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: :destroy
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
  @user = User.find(params[:id])
  @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end 

  def create
  	@user = User.new(user_params)
  	if @user.save
      @user.send_activation_email
      #log_in @user
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = "请检查您的电子邮件以激活您的账号"
  		#处理注册成功的情况
      redirect_to root_url
  		else
  			render 'new'
end
end

def edit
  @user = User.find(params[:id])
end

def update
  @user = User.find(params[:id])
  if @user.update_attributes(user_params)
    flash[:success] = "资料更新"
    redirect_to @user
    #处理更新成功的情况
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "用户已删除"
    redirect_to users_url
  end


def following
  @title = "Following"
  @user = User.find(params[:id])
  @users = @user.following.paginate(page: params[:page])
  render 'show_follow'
end

def followers
  @title = "Followers"
  @user = User.find(params[:id])
  @users = @user.followers.paginate(page: params[:id])
  render 'show_follw'
end


private
def user_params
params.require(:user).permit(:name, :email, :password,:password_confirmation)
end
 #事前过滤器
=begin
#确保用户已登录
 def logged_in_user
  unless logged_in?
    store_location
    flash[:danger] = "请登录"
    redirect_to login_url
  end
end
=end
#确保是正确的用户
def currect_user
  @user = User.find(params[:id])
  redirect_to(root_url) unless current_user?(@user)
end

#确保是管理员
def admin_user
  redirect_ro(root_url) unless current_user.admin?
end
end