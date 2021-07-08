SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE PROCEDURE [FileAssets].[DailyTweet$Redate] 
(
		@DailyTweetId int ,
		@NewDate date,
		@CommitFlag bit = 0
) AS

SET XACT_ABORT ON;
BEGIN TRANSACTION

SELECT 'Data Before'
SELECT *
FROM   Tweets.DailyTweet
WHERE  DailyTweet.DailyTweetId = @DailyTweetId

SELECT Name
FROM   FileAssets.DailyTweetMedia
WHERE  name LIKE CONCAT('%(',@DailyTweetId,').jpg')

UPDATE Tweets.DailyTweet
SET   DailyTweet.TweetDate = @NewDate
WHERE  DailyTweetId = @DailyTweetId

UPDATE FileAssets.DailyTweetMedia
SET DailyTweetMedia.name = CAST(@NewDate AS nvarchar(20)) + SUBSTRING(name,11,100)
WHERE  name LIKE CONCAT('%(',@DailyTweetId,').jpg')

SELECT 'Data After'
SELECT *
FROM   Tweets.DailyTweet
WHERE  DailyTweet.DailyTweetId = @DailyTweetId

SELECT Name
FROM   FileAssets.DailyTweetMedia
WHERE  name LIKE CONCAT('%(',@DailyTweetId,').jpg')

IF @CommitFlag = 1
  COMMIT
ELSE
 BEGIN 
	ROLLBACK 
	SELECT 'Data Not Saved'
 END
GO
