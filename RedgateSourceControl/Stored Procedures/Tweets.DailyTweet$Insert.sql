SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE    PROCEDURE [Tweets].[DailyTweet$Insert](
	@TweetDate date,
	@TweetTypeTag varchar(30),
	@TweetText nvarchar(2000),
	@TweetNumber int = 1,
	@ThemeParkAssetId nvarchar(50) = NULL,
	@FollowFridayPrefixId int = NULL,
	@FollowFridayList nvarchar(MAX) = NULL,
	@OverrideDailyLimitFlag int = 0
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
BEGIN TRANSACTION;

DECLARE @LenTweetText int = LEN(@TweetText)
DECLARE @DailyTweetId int, @msg nvarchar(2000);
DECLARE @TweetTypeTagId int = (SELECT TagId FROM Assets.Tag WHERE Tag = @TweetTypeTag);


IF  @LenTweetText > 280
 BEGIN
	SET @msg = 'The value of @TweetText was too long. It must be 280 or less and it was ' + CAST(@LenTweetText AS varchar(20));
	THROW 50000,@msg,1;
 END

DECLARE @TagUseCount int;
DECLARE @MaxTagUseCount int;

SELECT @TagUseCount = COUNT(*)
FROM   Tweets.DailyTweet
		JOIN Assets.Tag
		ON DailyTweet.TweetTypeTagId = Tag.TagId
WHERE  DailyTweet.TweetTypeTagId = @TweetTypeTagId
  AND  DailyTweet.TweetDate = @TweetDate

SELECT @MaxTagUseCount = Tag.MaxDailyUseCount
FROM   Assets.Tag
WHERE  Tag.TagId = @TweetTypeTagId

IF @TagUseCount >= @MaxTagUseCount
  BEGIN
	IF @OverrideDailyLimitFlag = 0
	  BEGIN
		SET @msg = CONCAT('The maximum limit of uses for the ', @TweetTypeTag,' is ',@MaxTagUseCount,' and this tag has been used ',@TagUseCount,' times. Use @OverrideDailyLimitFlag parameter to continue');
		THROW 50000, @msg,1;
	  END
	ELSE 
	  BEGIN
		SET @msg = CONCAT('@OverrideDailyLimitFlag parameter used. The maximum limit of uses for the ', @TweetTypeTag,' is ',@MaxTagUseCount,' and this tag has been used ',@TagUseCount,' times.');
		PRINT @msg;
	  END;
  END;


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

IF @TweetTypeTag NOT IN ('FollowFriday','WindowWednesday','{WindowWednesday}','{FollowFriday}')
   BEGIN
	IF @ThemeParkAssetId IS NULL 
		THROW 50000,'@ThemeParkAssetId is required for "Normal" TweetTagType',1;

	INSERT INTO  Tweets.DailyTweetNormal(DailyTweetId, ThemeParkAssetId)
	VALUES(@DailyTweetId, -- DailyTweetId - int
	       @ThemeParkAssetId  -- ThemeParkAssetId - int
	    )
   END;
ELSE IF @TweetTypeTag = '{FollowFriday}'
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
