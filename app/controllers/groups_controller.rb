class GroupsController < ApplicationController
	before_action :logged_in_user
	before_action :correct_user,   only: :destroy


  def index
    @search = Group.search(params[:q])
    @groups = @search.result.paginate(page: params[:page])
  end

	def show
    @tweet = current_user.tweets.build
	  @group = Group.find_by_id(params[:id])
    @ids = Grouprel.where(group_id: params[:id]).pluck(:user_id)
    @users = User.where(id: @ids)
    @feed_items = current_user.group_feed(params[:id]).paginate(page: params[:page])
	end

  def leave_group
    @group = Group.find_by_id(params[:id])
    Grouprel.where(group_id: params[:id],user_id: current_user.id).destroy_all
    redirect_to request.referrer
  end

	def create
	  @group = Group.new(group_params)
	  @group.admin = session[:user_id]
	  if @group.save
	  	@grouprel = Grouprel.new(user_id: current_user.id,group_id: @group.id)
	  	@grouprel.save
	  	flash[:succes] = "Group created"
	  	redirect_to root_path
	   else
	   	render 'new'
	  end
  end

  def update
    @group = Group.find_by_id(params[:id])
    if @group.update_attributes(group_params)
      flash[:success] = "Group updated"
      redirect_to manage_groups_path
    else
      render 'edit'
    end
  end

  def edit
    @group = Group.find_by_id(params[:id])
  end

  def new
    @group = Group.new
  end

  def destroy
    @group.destroy
    redirect_to manage_groups_path
  end

  def manage
    user_id = session[:user_id]
    @group_ids = Grouprel.where(user_id: user_id).pluck(:group_id)
    @groups = Group.where(id: @group_ids).paginate(page: params[:page])
  end

  def show_to_add
    @users = User.all
  	@group_users = @users.paginate(page: params[:page])
  end

  def add_member
    group_id = params[:group]
    @group_rel = Grouprel.new(user_id: params[:user_id],group_id: group_id)
    if @group_rel.save
      flash[:success] = "User added!"
      redirect_to request.referrer
    else
      flash[:error] = "User Not Added"
      redirect_to request.referrer
    end
  end 

  def kick
    group_id = params[:id]
    @group_rel = Grouprel.where(user_id: params[:user_id],group_id: group_id)
    if @group_rel.destroy_all
      flash[:succes] = "User kicked"
      redirect_to request.referrer
    else
      flash[:error] = "User not kicked"
      redirect_to request.referrer
    end
  end

  def ban
    group_id = params[:id]
    @group_rel = Grouprel.where(user_id: params[:user_id],group_id: group_id)
    @ban_rel = Ban.new(user_id: params[:user_id], group_id: group_id)
    if @ban_rel.save && @group_rel.destroy_all
      flash[:success] = "User banned!"
      redirect_to request.referrer
    else
      flash[:error] = "User Not banned"
      redirect_to request.referrer
    end
  end

  def remove_ban
    group_id = params[:id]
    @ban_rel = Ban.where(user_id: params[:user_id], group_id: group_id)
    if @ban_rel.destroy_all
      flash[:success] = "User debanned!"
      redirect_to request.referrer
    else
      flash[:error] = "User Not debanned"
      redirect_to request.referrer
    end
  end

    private

      def group_params 
        params.require(:group).permit(:name, :description,:open)
      end

      def correct_user
      	@group = Group.find_by_id(params[:id])
      	ok = (session[:user_id] == @group.admin)
      	redirect_to root_url unless ok
      end

      def add_memeber(user_id)
      	@grouprel = Grouprel.new(user_id: user_id,group_id: group.id)
      	@grouprel.save
      end

      
end
