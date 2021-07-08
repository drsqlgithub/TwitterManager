SET XACT_ABORT ON
BEGIN TRANSACTION

DELETE FROM Tweets.FollowFriday
WHERE  FollowFriday.DailyTweetId IN (
SELECT DailyTweet.DailyTweetId
FROM   Tweets.DailyTweet
WHERE  DailyTweet.TweetDate = '2021-02-19')


DELETE FROM Tweets.DailyTweetFollowFriday
WHERE  DailyTweetFollowFriday.DailyTweetId IN (
SELECT DailyTweet.DailyTweetId
FROM   Tweets.DailyTweet
WHERE  DailyTweet.TweetDate = '2021-02-19')

DELETE FROM Tweets.DailyTweetPicture
WHERE  DailyTweetPicture.DailyTweetId IN (
SELECT DailyTweet.DailyTweetId
FROM   Tweets.DailyTweet
WHERE  DailyTweet.TweetDate = '2021-02-19')



DELETE FROM Tweets.DailyTweet
FROM   Tweets.DailyTweet
WHERE  DailyTweet.TweetDate = '2021-02-19'



ROLLBACK