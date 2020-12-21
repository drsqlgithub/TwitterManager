SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [Tweets].[DailyTweet$GenerateSpecial]
(
	@TweetTypeTag varchar(30),
	@TweetDate date = NULL,
	@FileSampleCount int = 4,
	@IncludeHolidayPicturesFlag bit = 0,
	@TweetNumber int = 1
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

IF  EXISTS (SELECT *
			   FROM   Assets.Tag
			   WHERE  Tag.tag = @TweetTypeTag
			     AND  Tag.HolidayTag = 1
				 AND  @IncludeHolidayPicturesFlag =  0)
 THROW 50000,'Cannot use a holiday tag with parameter @IncludeHolidayPicturesFlag = 0',1;
 
SELECT 'SET XACT_ABORT ON; 
BEGIN TRANSACTION;'

--generate statements to get pictures and create the directories for the images
SELECT '--#' + @TweetTypeTag + ' [--Topic], ' + 
			CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'EXECUTE ' + DB_NAME() + '.Tweets.DailyTweet$Insert @TweetDate = ''' + CAST(@TweetDate AS varchar(30)) + ''' ,@TweetTypeTag = ''' + @TweetTypeTag  +  ''',' + CHAR(13) + CHAR(10) + '@TweetText = '' #' + REPLACE(REPLACE(@TweetTypeTag,'{',''),'}','') + ''', @TweetNumber =' + CAST(@TweetNumber AS varchar(30)) + ',  @OverrideDailyLimitFlag = 0;' --hardcoded to give you the choice at save time

EXEC Tweets.DailyTweetPicture$GetRandomSpecial @TweetDate = @TweetDate, @FileSampleCount = @FileSampleCount, @TweetTypeTag = @TweetTypeTag, @IncludeHolidayPicturesFlag = @IncludeHolidayPicturesFlag, @TweetNumber = @TweetNumber;

SELECT '--COMMIT TRANSACTION;'

SELECT 'SELECT DailyTweet.TweetText
FROM   ' + DB_NAME() + '.Tweets.DailyTweet
WHERE  TweetDate = ''' + CAST(@TweetDate AS nvarchar(20)) + ''''

GO
