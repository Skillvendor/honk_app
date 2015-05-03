module GroupsHelper
	include SessionsHelper

	def is_admin?(user)
	  session[:user_id] == user
	end

  def is_member?(idish,gid)
    @boolean = Grouprel.where(user_id: idish,group_id: gid)
    if(@boolean.any?) then true
      else false
    end
  end

  def is_open?(gid)
    @boolean = Group.where(id: gid).pluck(:open)
    @boolean == [true]
  end

	def group_owner
    @group = Group.find_by_id(params[:id])
    user_id = @group.admin
    user_id
  end

  def is_group_admin(gid)
    @group = Group.find_by_id(gid)
    user_id = @group.admin
    user_id
  end

  def is_banned?(idish,gid)
    @boolean = Ban.where(user_id: idish,group_id: gid)
    unless(@boolean.any?) then true
      else false
    end
  end

  def in_group(idish)
    @boolean = Grouprel.where(user_id: idish, group_id: params[:id]) 
    if(@boolean.any?) then true
      else false
    end
  end
end
