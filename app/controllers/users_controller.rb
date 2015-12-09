class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :logged_in_user, only: [:edit, :update]
  before_action :correct_user,   only: [:edit, :update]

  # GET /users
  def index
    @users = User.all
  end

  # GET /users/1
  def show
    redirect_to current_user unless current_user == User.find(params[:id])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  def create
    @user = User.new(user_params)
    @user.password = params[:password]
    @user.logo_valid = false
    if @user.save
      UserMailer.account_activation(@user).deliver_now
      flash[:info] = 'Please check your email to activate your account.'
      redirect_to root_url
    else
      render :new
    end
  end

  # PATCH/PUT /users/1
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:info] = 'Your information has been updated.'
      redirect_to @user
    else
      render 'edit'
    end
  end

  # DELETE /users/1
  # def destroy
  #   @user.destroy
  #   reset_session
  #   redirect_to '/users', notice: 'User was successfully destroyed.'
  # end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password,
                                 :password_confirmation,
                                 :primary_contact_name,
                                 :primary_contact_email,
                                 :logo)
  end

  def logged_in_user
    return if logged_in?
    flash[:danger] = 'Please log in.'
    redirect_to login_url
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url) unless current_user?(@user)
  end
end
