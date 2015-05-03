class TweetsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]
  before_action :correct_user,   only: :destroy


  def create
    @tweet = current_user.tweets.build(tweet_params)
    if @tweet.save
      add_hashtags(@tweet)
      flash[:success] = "Tweet created!"
      redirect_to :back
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @retweets = Tweet.where(original_tweet_id: @tweet.id)

    @retweets.each do |retweet|
      retweet.destroy
    end

    @tweet.destroy
    flash[:success] = "Tweet deleted"
    redirect_to request.referrer || root_url
  end

  def show
    @hashtag = Hashtag.find_by_name(params[:name])
    @tweet_ids = Hashrelation.where(hashtag_id: @hashtag.id).pluck(:tweet_id)
    @feed_items = Tweet.where(id: @tweet_ids)
    @feed_items = @feed_items.where(group: nil).paginate(page: params[:page])
  end

  def retweet
    @tweet = current_user.tweets.build(retweet_params)
    if @tweet.save
      add_hashtags(@tweet)
      flash[:success] = "Tweet created!"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end 

  private

    def tweet_params
      params.require(:tweet).permit(:content, :picture, :group)
    end

    def retweet_params
      params.require(:tweet).permit(:content, :picture, :group, :original_tweet_id)
    end

    def correct_user
      @tweet = current_user.tweets.find_by_id(params[:id])
      redirect_to root_url if @tweet.nil?
    end



end
