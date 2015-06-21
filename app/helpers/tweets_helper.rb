module TweetsHelper

	def twitify(tweet = '')
     tweet.gsub(/(?:\s|^)(?:#(?!(?:\d+|\w+?_|_\w+?)(?:\s|$)))(\w+)(?=\s|$)/) do |tag|
      
      " " + link_to("#{tag.strip}", hashtag_path(name: tag.strip[1..-1]))
     end.html_safe
    end

    def add_hashtags(tweet)
     tweet.content.scan(/(?:\s|^)(?:#(?!(?:\d+|\w+?_|_\w+?)(?:\s|$)))(\w+)(?=\s|$)/).flatten.each do  |tag|

       hashtag = Hashtag.where(name: tag.strip).first_or_create
       if Hashrelation.where(tweet_id: tweet.id, hashtag_id: hashtag.id).empty?
        Hashrelation.create(tweet_id: tweet.id, hashtag_id: hashtag.id)
       end
     end
    end

    def is_retweet?(tweet)
      if(tweet.original_tweet_id == nil) then false
      else true
      end
    end

    def get_original_tweet(tweet)
      @original = Tweet.find(tweet.original_tweet_id) 
    end

    def isgrouptweet?(tweet)
       if(tweet.group == nil) then false
         else true
       end 
    end



end
