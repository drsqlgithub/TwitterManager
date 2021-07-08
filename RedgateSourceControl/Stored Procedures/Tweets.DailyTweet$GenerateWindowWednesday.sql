SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE    PROCEDURE [Tweets].[DailyTweet$GenerateWindowWednesday]
(
	@TweetDate date = NULL,
	@FileSampleCount int = 10,
	@AssetRepeatToleranceDayCount int = 60
)
AS


SET NOCOUNT ON 

IF @TweetDate IS NULL SET @TweetDate = SYSDATETIME();

DECLARE @SpecialTagId int 
SET @SpecialTagId = (SELECT TagId FROM Assets.Tag WHERE tag = '{WindowWednesday}' AND Tag.SpecialFlag = 1)
IF @SpecialTagId IS NULL
	THROW 50000, 'Invalid special tag ',1
 
SELECT 'SET XACT_ABORT ON; 
BEGIN TRANSACTION;'

DECLARE @WindowWednesdayTopicTag varchar(30), @WindowsWednesdayTopicTagId int

SELECT @WindowWednesdayTopicTag = Tag.Tag,
	   @WindowsWednesdayTopicTagId = Tag.TagId
FROM   [Assets].[WindowWednesdayTopicDetail]
		 JOIN Assets.Tag
			ON WindowWednesdayTopicDetail.TagId = Tag.TagId
WHERE  NOT EXISTS (SELECT *
				   FROM   Assets.DailyTweetWindowWednesday
								JOIN Tweets.DailyTweet
									ON DailyTweetWindowWednesday.DailyTweetId = DailyTweet.DailyTweetId
				   WHERE  DailyTweet.TweetDate >= DATEADD(DAY, -@AssetRepeatToleranceDayCount,@tweetdate))
ORDER BY NEWID();

--generate statements to get pictures and create the directories for the images
SELECT '--#' + @WindowWednesdayTopicTag + ' for #WindowWednesday' + 
			CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'EXECUTE ' + DB_NAME() + '.Tweets.DailyTweet$Insert @TweetDate = ''' + CAST(@TweetDate AS varchar(30)) + ''' ,@TweetTypeTag = ''{WindowWednesday}'',' + CHAR(13) + CHAR(10) + '@TweetText = ''Here''''s a picture of #' + @WindowWednesdayTopicTag + ' for #WindowWednesday;'''

EXEC Tweets.DailyTweetPicture$GetRandomTag @TweetTypeTag = '{WindowWednesday}', @TweetDate = @TweetDate, @FileSampleCount = @FileSampleCount, @OverrideFilterTag = @WindowWednesdayTopicTag

SELECT '--Background' + CHAR(13) + CHAR(10) + '--' + COALESCE(Description1,'') + CHAR(13) + CHAR(10) + '--' + REPLACE(COALESCE(Description2,''),CHAR(13) + CHAR(10),CHAR(13) + CHAR(10) + '--')
FROM   [Assets].[WindowWednesdayTopicDetail]
WHERE  TagId = (SELECT TagId FROM Assets.Tag WHERE tag = @WindowWednesdayTopicTag)

SELECT '--COMMIT TRANSACTION;'

SELECT 'SELECT DailyTweet.TweetText
FROM   ' + DB_NAME() + '.Tweets.DailyTweet
WHERE  TweetDate = ''' + CAST(@TweetDate AS nvarchar(20)) + ''''


GO
