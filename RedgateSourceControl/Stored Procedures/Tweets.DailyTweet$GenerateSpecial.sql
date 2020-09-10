SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





	
CREATE      PROCEDURE [Tweets].[DailyTweet$GenerateSpecial]
(
	@TweetTypeTag varchar(30),
	@TweetDate date = NULL,
	@FileSampleCount int = 4
)
AS

SET NOCOUNT ON 

IF @TweetTypeTag = 'FollowFriday'
	THROW 50000,'FollowFriday tweets are managed using Tweets.DailyTweet$GenerateFollowFriday',1;

IF @TweetDate IS NULL SET @TweetDate = SYSDATETIME();

IF NOT EXISTS (SELECT *
			   FROM   Assets.Tag
			   WHERE  Tag.tag = @TweetTypeTag
			     AND  Tag.SpecialFlag = 1)
 THROW 50000,'Only special tags are allowed to be used for a DailyTweet',1;
 
SELECT 'SET XACT_ABORT ON; 
BEGIN TRANSACTION;'

--generate statements to get pictures and create the directories for the images
SELECT '--#' + @TweetTypeTag + ' [--Topic], ' + 
			CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'EXECUTE Tweets.DailyTweet$Insert @TweetDate = ''' + CAST(@TweetDate AS varchar(30)) + ''' ,@TweetTypeTag = ''' + @TweetTypeTag  +  ''',' + CHAR(13) + CHAR(10) + '@TweetText = '' #' + REPLACE(REPLACE(@TweetTypeTag,'{',''),'}','') + ''';'

EXEC Tweets.DailyTweetPicture$GetRandomSpecial @TweetDate = @TweetDate, @FileSampleCount = @FileSampleCount, @TweetTypeTag = @TweetTypeTag

SELECT '--COMMIT TRANSACTION;'

SELECT 'SELECT DailyTweet.TweetText
FROM   Tweets.DailyTweet
WHERE  TweetDate = ''' + CAST(@TweetDate AS nvarchar(20)) + ''''

GO
