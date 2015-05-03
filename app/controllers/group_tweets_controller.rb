class GroupTweetsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy


  def create
    @tweet = current_group.tweets.build(tweet_params)
    if @tweet.save
      add_hashtags(@tweet)
      flash[:success] = "Tweet created!"
    else
      flash[:danger] = "Can't create tweet"
    end
    redirect_to group_path(params[:id])
  end

  def destroy
    @tweet.destroy
    flash[:success] = "Micropost deleted"
    redirect_to request.referrer || root_url
  end

  def show
    @hashtag = Hashtag.find_by_name(params[:name])
    @tweet_ids = Hashrelation.where(hashtag_id: @hashtag.id).pluck(:tweet_id)
    @feed_items = Tweet.where(id: @tweet_ids).paginate(page: params[:page])
  end
end
