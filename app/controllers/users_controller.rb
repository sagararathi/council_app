class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  before_action :require_login, except: [:new, :create]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      set_session
      redirect_to user_path(@user)
    else
      flash[:error] = 'Field cannot be left blank.'
      redirect_to root_path
    end
  end

  def show
    @user = current_user
    @questions = []
    
    @user.questions.each do |question|
      @questions << question
    end

    @user.councils.each do |council|
      council.questions.each do |question|
        @questions << question
      end
    end
    @questions = @questions.sort_by(&:created_at)
  end

  def edit
  end

  def update
    @user = User.find params[:id]
    if @user.update_attributes user_params
      redirect_to user_path(@user)
    else
      flash[:error] = 'Field cannot be left blank.'
      render :edit
    end
  end

  def destroy
    session.clear if @user == current_user
    @user.destroy
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:firstname, :lastname, :email, :password)
  end


end