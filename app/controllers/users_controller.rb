class UsersController < ApplicationController
	before_action :signed_in_user,	only: [:index, :edit, :update, :destroy]  
	before_action :correct_user, 	only: [:edit, :update]
	before_action :admin_user,		only: :desroy 	

	def destroy
		user = User.find(params[:id])
		unless current_user?(user)
			user.destroy
			flash[:success] = "User deleted."
		else 
			flash[:error] = "You can't destory yourself."
		end
		redirect_to root_url  		#changed from users_url
	end

	def index
		@users = User.paginate(page: params[:page] )
	end

	def show
		@user = User.find(params[:id])
		@microposts = @user.microposts.paginate(page: params[:page])
	end

	def new
		@user = User.new 
		if signed_in?
			redirect_to root_url
		end
	end

	def create
		if signed_in?
			admin_user
		else
			@user = User.new(user_params)
			if @user.save
				sign_in @user
				flash[:success] = "Welcome to the Sample App!"
				redirect_to @user
			else 
				render 'new'
			end
		end
	end

	def edit 
	end

	def update 
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end


	private

		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		# Before filters

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end
end
