class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper
  include TweetsHelper



  def logged_in_user
    unless logged_in?
      store_location
      flash[:danger] = "Please log in."
      redirect_to login_url
    end
  end

  def get_groups
    @groupi = Grouprel.where(user_id: current_user.id).pluck(:group_id)
    @groupies = Group.where(id: @groupi)
  end
  
  def all_members
    all = User.all
    return all
  end

  def delete_tweets(group)
    @tweets = Tweet.where(group: group.id)
    destroy_retweets_group(@tweets)
    if @tweets
      @tweets.each do |tweet|
        tweet.destroy
      end
    end
  end

  def destroy_retweets(tweet)
    @retweets = Tweet.where(original_tweet_id: @tweet.id)
    if @retweets
      @retweets.each do |retweet|
        retweet.destroy
      end
    end
  end
  

  def destroy_retweets_group(tweets)
    if tweets
      tweets.each do |tweet|
        @retweets = Tweet.where(original_tweet_id: tweet.id)
        if @retweets
          @retweets.each do |retweet|
            retweet.destroy
          end
        end
      end
    end
  end

  def candidates(user)
    @following = user.following 
    @follower = []

    @following.each  do |follow|
      @follower = @follower + follow.followers
    end

    @followees = []

    @follower.each do |ff|
      @followees = @followees + ff.following 
    end

    @followees = @followees - @following

    @rezultat = []
    @sugested = @followees & @followees
    scoreHash = Hash.new
    score = 0

    @sugested.each do |gg|
      nr = 0
      @followees.each do |ff|
        if (ff.email == gg.email) then nr = nr + 1
        end
      end
      if(gg.following.count != 0 && count_retweets(gg) != 0 && count_tweets(gg) != 0) then
        score = ( (nr*1.0)/(@followees.count * 1.0) ) * ( (gg.followers.count*1.0) / (gg.following.count*1.0)) * ((count_retweets(gg) * 1.0)/count_tweets(gg) * 1.0)
        scoreHash[gg.email] = score   
      else 
        score = 0.0
        scoreHash[gg.email] = score
      end 
    end

    sortedHash = Hash[scoreHash.sort_by{|email, score| score}.reverse[0..4]]

    @sugested.each do |rank|
      if sortedHash[rank.email] then
        @rezultat = @rezultat + Array(rank)
      end
    end


    @rezultat
  end

  def candidates2(user)
     @follower_tweet_string = ""  ## storing all the text from all the tweets from all the followers that a user has
     @rest_of_users_strings ## storing all the text from all the tweets a user, that the current user is not following, has.
     scoreHash = Hash.new ## a score hash where the score between the similarities found by the TfIdSimilarity gem are kept
     @rezultat = [] ## the array of users returned 
     @users = User.all.includes(:tweets) ## all the users
     @rest_of_users = [] ## all the users that the current user is not following
     @following = user.following + Array(user) ## all the user the current user is following + the user

     @following.each do |followee|
        @tweets = followee.feed ## feed is a method for requesting all the tweets of that person
         @tweets.each do |tweet|
           @follower_tweet_string = @follower_tweet_string + tweet.content ## getting all the text from all the tweets of all the followers
         end
     end

     @rest_of_users = @users - @following  ## finding out all the users that the user is not following

     document1 = TfIdfSimilarity::Document.new(@follower_tweet_string)
     corpus = [document1]

     @rest_of_users.each do |person|
      @tweets = person.feed ## getting all the tweets of the user 
      @tweets.each do |tweet|
        @follower_tweet_string = @follower_tweet_string + tweet.content ## getting all the text from all the tweets that a user has(a user that isn't followed by the current user)
      end

      ##calculating the score 
      document2 = TfIdfSimilarity::Document.new(@follower_tweet_string)
      corpus = corpus + Array(document2)

      model = TfIdfSimilarity::TfIdfModel.new(corpus)
      matrix = model.similarity_matrix
      scoreHash[person.email] = matrix[model.document_index(document1), model.document_index(document2)]
      corpus = corpus - Array(document2)
      ## stop calculating the score

     end

     sortedHash = Hash[scoreHash.sort_by{|email, score| score}.reverse[0..4]] ## sorting the hash
     @rest_of_users.each do |rank|
      if sortedHash[rank.email] then
        @rezultat = @rezultat + Array(rank) ## getting the resulting users
      end
    end


    @rezultat ## returning the resulting users
  end


    private

      def count_tweets(user)
        nr = Tweet.where(user_id: user.id).count
      end

      def count_retweets(user)

        @Tweets = Tweet.where(user_id: user.id)
        nr = 0
        @Tweets.each do |retweet|
          if retweet.original_tweet_id then
            nr += 1
          end
        end

        nr
      end
  
end
