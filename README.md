mother_flocker_rails_real
=========================

A Ruby on Rails app built with a partner in our second week of Ruby (first week of Rails) that gamifies Twitter use and collects user metrics to help chart behavior. It pulls real-time Twitter data via the API and assigns values based off the following behavior triggers:
- Number of tweets (with a cap to discourage spamming, prioritize engagement)
- Consecutivity (gives more points for consecutive days tweeting rather; you get more points for tweeting Tuesday if you tweeted on Monday than if you didn't tweet at all Monday)
- User mentions (Twitter handle used in other users' tweets)
- Number of user's tweets that were retweeted by other users (no points if user is retweeting someone else's tweets)

Incorporated gamification concepts along with Twitter data analysis to present information.
