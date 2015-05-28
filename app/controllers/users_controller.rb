class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user,     only: :destroy


  def index
    @search = User.search(params[:q])
    @users = @search.result.paginate(page: params[:page],per_page: 10)
  end

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
    @tweets = @user.tweets.paginate(page: params[:page])
  end

  def create
    @user = User.new(user_params)
    if @user.save
      link = url_for(:action => 'confirm', :id => @user.id,
                       :confirmation_code => @user.confirmation_code)
      UserMailer.confirmation_email(@user, link).deliver!
      flash[:success] = "Welcome to Honk App! Please confirm your e-mail!"
      redirect_to root_url
    else
      render 'new'
    end
  end

  def confirm
    user = User.find(params[:id])
    if user.confirmation_code == params[:confirmation_code]
      user.activated = true
      user.confirmation_code = nil
      user.save
      flash[:success] = "Confirmare reusita. Bine ai venit!"
      log_in user
      redirect_to root_url
    else
      flash[:danger] = "Link-ul nu e valid!"
      redirect_to signup_path
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  def suggest
    @suggested2 = candidates2(current_user)

    Suggested.where(owner: current_user.id).delete_all
    @suggested2.each do |user|
       @new_suggest = Suggested.new
       @new_suggest.user_id = user.id
       @new_suggest.owner = current_user.id
       @new_suggest.save
    end

    redirect_to :back
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end


    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end