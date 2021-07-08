SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    PROCEDURE [Tweets].[DailyTweet$Generate]
(
	@TweetDate date = NULL,
	@FileSampleCount int = 10,
	@SpecialTag varchar(30) = NULL,
	@AssetRepeatToleranceDayCount int = 60,
	@FreshPicturesOnlyFlag bit = 0
)
AS
SET NOCOUNT ON 

IF @TweetDate IS NULL SET @TweetDate = SYSDATETIME();

DECLARE @SpecialTagId int 
IF @SpecialTag IS NOT NULL
 BEGIN
	SET @SpecialTagId = (SELECT TagId FROM Assets.Tag WHERE tag = @SpecialTag AND Tag.SpecialFlag = 1)
	IF @SpecialTagId IS NULL
		THROW 50000, 'Invalid special tag passed in',1
 END
 
SELECT 'SET XACT_ABORT ON; 
BEGIN TRANSACTION;'

DECLARE @ThemeParkAssetId int
SET @ThemeParkAssetId = (SELECT ThemeParkAssetId FROM [Assets].[DailyTweet$GetRandom2](@TweetDate,@SpecialTagId,@AssetRepeatToleranceDayCount))

SELECT TOP 10 '--' + CAST(DailyTweet.TweetDate AS varchar(20)) + ' ' + ThemeParkArea.ThemeParkAreaHashtag + ' ' + ThemeParkAsset.ThemeParkAssetHashtag AS '--Last 5 uses of this asset'
FROM   Tweets.DailyTweet
		JOIN Tweets.DailyTweetNormal
			ON DailyTweetNormal.DailyTweetId = DailyTweet.DailyTweetId
		JOIN Assets.ThemeParkAsset
			ON ThemeParkAsset.ThemeParkAssetId = DailyTweetNormal.ThemeParkAssetId
		JOIN Assets.ThemeParkArea
			ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
WHERE  DailyTweetNormal.ThemeParkAssetId = @ThemeParkAssetId
 ORDER BY DailyTweet.TweetDate DESC;

SELECT TOP 10 '--' + CAST(DailyTweet.TweetDate AS varchar(20)) + ' ' + ThemeParkArea.ThemeParkAreaHashtag + ' ' + ThemeParkAsset.ThemeParkAssetHashtag AS '--Last 10 tweets'
FROM   Tweets.DailyTweet
		JOIN Tweets.DailyTweetNormal
			ON DailyTweetNormal.DailyTweetId = DailyTweet.DailyTweetId
		JOIN Assets.ThemeParkAsset
			ON ThemeParkAsset.ThemeParkAssetId = DailyTweetNormal.ThemeParkAssetId
		JOIN Assets.ThemeParkArea
			ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
--WHERE  DailyTweetNormal.ThemeParkAssetId = @ThemeParkAssetId
 ORDER BY DailyTweet.TweetDate DESC;

DECLARE @TweetType varchar(40) = COALESCE (@SpecialTag ,'Normal')
  
--generate statements to get pictures and create the directories for the images
SELECT '--#' + ThemeParkAssetHashtag + ' at #' + ThemeParkAreaHashtag AS [--TweetTextHelper], 
			CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'EXECUTE ' + DB_NAME() + '.Tweets.DailyTweet$Insert @ThemeParkAssetId = ' + CAST(ThemeParkAssetId AS varchar(10)) + 
			', @TweetDate = ''' + CAST(@TweetDate AS varchar(30)) + ''' ,@TweetTypeTag = ''' + @TweetType + ''',' + CHAR(13) + CHAR(10) + '@TweetText = ''Here''''s picture(s) of #' + ThemeParkAssetHashtag + ' at #' + ThemeParkAreaHashtag + CASE WHEN @SpecialTag IS NOT NULL THEN ' for #' + REPLACE(REPLACE(@SpecialTag,'}',''),'{','')  ELSE '' END + CASE WHEN @FreshPicturesOnlyFlag = 1 THEN ' #FreshPictures ' ELSE '' END + ''';'
FROM Assets.ThemeParkAssetExpanded AS ThemeParkAsset
		JOIN Assets.ThemeParkArea
			ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
WHERE  ThemeParkAsset.ThemeParkAssetId = @ThemeParkAssetId
 AND (ThemeParkAsset.SpecialTagId = @SpecialTagId OR (@SpecialTagId IS NULL AND SpecialTagId IS NULL))

EXEC Tweets.DailyTweetPicture$GetRandom @ThemeParkAssetId = @ThemeParkAssetId, @TweetDate = @TweetDate, @FileSampleCount = @FileSampleCount, @SpecialTagId = @SpecialTagId, @FreshPicturesOnlyFlag = @FreshPicturesOnlyFlag

SELECT '--COMMIT TRANSACTION;'

SELECT 'SELECT DailyTweet.TweetText
FROM   ' + DB_NAME() + '.Tweets.DailyTweet
WHERE  TweetDate = ''' + CAST(@TweetDate AS nvarchar(20)) + ''''

GO
