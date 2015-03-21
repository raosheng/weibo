module SessionsHelper
	#登入指定的用户
	def log_in(user)
		session[:user_id] = user.id
	end

	#在持久会话中记住用户
	def remember(user)
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	#返回cookie中记忆令牌对应的用户
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			#raise #测试仍能通过，所以没有覆盖这个分支
			user = User.find_by(id: user_id)
			if user && user.authenticated?(cookies[:remember_token])
				log_in user
				@current_user = user_id
			end
		end
	end

    #如果用户已登录，返回true，否则返回false
	def logged_in?
		!current_user.nil?
	end

	#忘记持久会话
	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

   #退出当前用户
	def  log_out
		session.delete(:user_id)
		@current_user = nil
	end
end