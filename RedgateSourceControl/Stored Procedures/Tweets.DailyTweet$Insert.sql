SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    PROCEDURE [Tweets].[DailyTweet$Insert](
	@TweetDate date,
	@TweetTypeTag varchar(30),
	@TweetText nvarchar(280),
	@TweetNumber int = 1,
	@ThemeParkAssetId nvarchar(50) = NULL,
	@FollowFridayPrefixId int = NULL,
	@FollowFridayList nvarchar(MAX) = NULL
)
AS
SET XACT_ABORT ON;
BEGIN TRANSACTION;

DECLARE @DailyTweetId int;
DECLARE @TweetTypeTagId int = (SELECT TagId FROM Assets.Tag WHERE Tag = @TweetTypeTag);


INSERT INTO Tweets.DailyTweet(TweetDate, TweetNumber, TweetText, TweetTypeTagId)
VALUES(@TweetDate, -- TweetDate - date
	   @TweetNumber,
	   @TweetText,
	   @TweetTypeTagId
    )

SELECT @DailyTweetId= (SELECT DailyTweetId
					   FROM   Tweets.DailyTweet
					   WHERE  TweetDate = @TweetDate
					     AND  TweetTypeTagId = @TweetTypeTagId
						 AND  TweetNumber = @TweetNumber)

IF @DailyTweetId IS NULL
	THROW 50000,'@DailyTweetId IS NULL',1;

IF @TweetTypeTag = 'Normal'
   BEGIN
	IF @ThemeParkAssetId IS NULL
		THROW 50000,'@ThemeParkAssetId is required for "Normal" TweetTagType',1;

	INSERT INTO  Tweets.DailyTweetNormal(DailyTweetId, ThemeParkAssetId)
	VALUES(@DailyTweetId, -- DailyTweetId - int
	       @ThemeParkAssetId  -- ThemeParkAssetId - int
	    )
   END;
ELSE IF @TweetTypeTag = 'FollowFriday'
 BEGIN
	
	INSERT INTO Tweets.DailyTweetFollowFriday(DailyTweetId, FollowFridayPrefixId)
	VALUES(@DailyTweetId, @FollowFridayPrefixId)

	INSERT INTO  Tweets.FollowFriday(DailyTweetId, TwitterAccountId)
	SELECT @DailyTweetId, TwitterAccount.TwitterAccountId
	FROM   STRING_SPLIT(@FollowFridayList, ',')
			 JOIN Assets.TwitterAccount
				ON TwitterAccount.TwitterHandle = value
	WHERE  LEN(value) > 0 AND LEFT(value,1) = '@'

 END

COMMIT

GO
