class StaticPagesController < ApplicationController
  def home
  	if logged_in?
      @tweet = current_user.tweets.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      @groupi = Grouprel.where(user_id: current_user.id).pluck(:group_id)
      @groupies = Group.where(id: @groupi).paginate(page: params[:page])
      @suggested = candidates(current_user)
      @candidate = Suggested.where(owner: current_user.id).pluck(:user_id)
      @suggested2 = User.where(id: @candidate)
    end
  end

  def help
  end

  def about
  end


end
