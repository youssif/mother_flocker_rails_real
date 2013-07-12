module Flocker
	class Email
	  @@username=ENV['USERNAME']
	  @@password=ENV['PSWD']

	  def self.set_handles(tweeters, emails)
	    @tweeters = tweeters
	    @email_array = emails   
	    Email.send(@email_array,@tweeters)
	  end

	  def self.send(emails, handles)
	    flock = Flock.new(handles)
	    email_body = flock.email_format
	    gmail = Gmail.connect(@@username, @@password)
	    emails.each do |recipient|
	      email = gmail.compose do
	        to recipient
	        subject "Mother Flocker Weekly Leaderboard"
	        body email_body
	      end
	      email.deliver!
	    end
	    gmail.logout
      flock.leaderboard
      
	  end

    
	end

	class Dates
	  
	  # Create an array of dates included in queries which will be crossed against the tweet_counter loop
	  # to count tweest on a per-day basis

	  def self.week_dates
	    i = 0
	    @@dates = []
	    while i < 8
	      @@dates <<(Time.now - i*86400).strftime("%Y-%m-%d")
	      i += 1
	    end
	    @@dates
	  end

	end

	class Tweeter
	  attr_accessor :total_tweets

	  def initialize(dates)
	    @dates=dates
	#total number of tweets pulled for a handle using API
	  end

	  #count tweets -- FINISHED
	  def tweet_counter(handle)
	    i = 0
	    @tweets = []
	    @tweets_per_day = [] #array contains number of tweets for each day of the week by index 0 being today and 6 being start of the week
	    @total_tweets = 0
	    until i > (@dates.length-2) #until the last item in array, which we need to pull today's tweet
	      @tweets << Twitter.search("from:#{handle}", :count => 5, :until => @dates[i], :since => @dates[i+1]).results.map do |status|
	        "#{status.id}"
	      end
	      @tweets_per_day << @tweets[i].length #storing on a given day how many tweets were tweeted to calculate consecutiveness
	      @total_tweets += @tweets[i].length
	      i +=1
	    end
	      @total_tweets 
	  end

	  #mentions
	  def mention_counter(handle)
	    @mentions = Twitter.search("to:#{handle}", :count => 200, :until => @dates[0], :since => @dates[6]).results.count
	  end

	  #retweet counter to assign points
	  def retweet_count(handle)
	    @retweet_total = 0
	    Twitter.search("from:#{handle} -rt", :count => 2000, :until => @dates[0], :since => @dates[6]).results.map do |status|
	       @retweet_total += status.retweet_count
	    end
	    @retweet_total
	  end

	  #use to pass through points method so we don't have to call all the methods
	  def counter(handle)
	    tweet_counter(handle)
	    mention_counter(handle)
	    retweet_count(handle)
	  end

	  #calculate points for original tweets only
	  def tweet_points
	    @tweet_points = 0
	    @points_per_day = @tweets_per_day.map do |tweets|
	      tweets
	    end
	    @points_per_day.each do |points|
	      @tweet_points += points
	    end
	  end

	  def mention_points
	    @mention_points = @mentions * 2
	    @mention_points
	  end

	  def retweet_points
	    @retweet_points = @retweet_total* 2
	    @retweet_points
	  end

	  #takes handle as argument to just run all the counter methods to get points
	  def total_points(handle)
	    counter(handle)
	    tweet_points
	    consec_points
	    mention_points
	    retweet_points
	    @total_points = @retweet_points + @mention_points + @consec_points
	    @tweeter_hash = {}
	    @tweeter_hash[:handle] = handle
	    @tweeter_hash[:total_points] = @total_points
	    @tweeter_hash[:tweet_points] = @tweet_points
	    @tweeter_hash[:consec_points] = @consec_points
	    @tweeter_hash[:mention_points] = @mention_points
	    @tweeter_hash[:retweet_points] = @retweet_points
	    @tweeter_hash
	  end

	  # def follower_points

	  # end

	  def consec_points
	    #example of array -> [0,1,2,3,1,4,0]
	    #i = 0
	    index = 0 
	    i = 1
	    @consec_modified = @points_per_day.map do |point|
	      if index > 0
	        if @points_per_day[index] > 0 && @points_per_day[index-1] > 0
	          i+=0.5
	        else
	          i = 1
	        end
	      else 
	        i = 1
	      end
	      index += 1
	      point*i
	    end
	    @consec_points = 0
	    @consec_modified.each do |point|
	      @consec_points += point
	    end
	    @consec_points
	  end

	end

	class Flock
	  def initialize(array)
	    @array = array
	    @@dates = Dates.week_dates
	  end

	  def user_gen
	    @flock_array = []
	    @array.each do |handle|
	      @flock_array << Tweeter.new(@@dates).total_points(handle)
	    end
	    @flock_array.sort_by! {|tweeter| tweeter[:total_points]}.reverse!
	    @flock_array
	  end

	  def email_format
	      user_gen
	      @email_output = "The Mother Flocker Weekly Leaderboard

	@#{@flock_array.first[:handle]} is the Mother Flocker of the week!


	      "  
	    @flock_array.each do |tweeter|
	      @email_output += "@#{tweeter[:handle]} | TOTAL POINTS: #{tweeter[:total_points]} | TOTAL RETWEETS: #{tweeter[:retweet_points]/2} | TOTAL MENTIONS: #{tweeter[:mention_points]/2} | TOTAL TWEETS: #{tweeter[:tweet_points]}
	      
	      "

	    end

	    @email_output += "*** Points are calculated based off weekly statistics pulled from the Twitter API measuring: the number of tweets (up to five per day) by a given user, the consistency of tweets (used as a point modifier based off consecutive days a user is tweeting), number of user-originated tweets retweeted by other users, and number of mentions."
	    # puts @email_output
	    @email_output
	  end

    def leaderboard
      @flock_array
    end

	end

	# flock = Flock.new(['sagarispatel', 'lydiaguarino', 'youssifwashere'])
	# flock.email_format

  def self.execute(handles,emails)
	  Email.set_handles(handles,emails)
  end

	# Email.send(['lydiahguarino@gmail.com','abdulyoussif@gmail.com'])
end