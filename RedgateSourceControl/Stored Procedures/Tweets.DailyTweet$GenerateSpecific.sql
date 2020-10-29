SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO









CREATE   PROCEDURE [Tweets].[DailyTweet$GenerateSpecific]
(
	@ThemeParkAreaHashtag varchar(100),
	@ThemeParkAssetHashtag varchar(100),
	@TweetDate date = NULL,
	@FileSampleCount int = 10
)
AS

SET NOCOUNT ON 

IF @TweetDate IS NULL SET @TweetDate = SYSDATETIME();
 
SELECT 'SET XACT_ABORT ON; 
BEGIN TRANSACTION;'

DECLARE @ThemeParkAssetId int
SET @ThemeParkAssetId = (SELECT ThemeParkAssetId 
						 FROM   Assets.ThemeParkAsset
								 JOIN Assets.ThemeParkArea
									ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
						 WHERE ThemeParkArea.ThemeParkAreaHashtag = @ThemeParkAreaHashtag
						   AND ThemeParkAsset.ThemeParkAssetHashtag = @ThemeParkAssetHashtag)
IF @ThemeParkAssetId IS NULL
 THROW 50000,'The @ThemeParkAreaHashTag and @ThemeParkAssetHashTag returned no asset it',1;

--generate statements to get pictures and create the directories for the images
SELECT '--#' + ThemeParkAssetHashtag + ' at #' + ThemeParkAreaHashtag AS [--TweetTextHelper], 
			CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 'EXECUTE ' + DB_NAME() + '.Tweets.DailyTweet$Insert @ThemeParkAssetId = ' + CAST(ThemeParkAssetId AS varchar(10)) + 
			', @TweetDate = ''' + CAST(@TweetDate AS varchar(30)) + ''' ,@TweetTypeTag = ''Normal'',' + CHAR(13) + CHAR(10) + '@TweetText = ''Here''''s a picture of #' + ThemeParkAssetHashtag + ' at #' + ThemeParkAreaHashtag + ''';'
FROM Assets.ThemeParkAsset
		JOIN Assets.ThemeParkArea
			ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
WHERE  ThemeParkAsset.ThemeParkAssetId = @ThemeParkAssetId
 AND   ThemeParkAsset.SpecialTagId IS NULL --This says the Asset is only for special events


EXEC Tweets.DailyTweetPicture$GetRandomNormal @ThemeParkAssetId = @ThemeParkAssetId, @TweetDate = @TweetDate, @FileSampleCount = @FileSampleCount

SELECT '--COMMIT TRANSACTION;'

SELECT 'SELECT DailyTweet.TweetText
FROM   ' + DB_NAME() + '.Tweets.DailyTweet
WHERE  TweetDate = ''' + CAST(@TweetDate AS nvarchar(20)) + ''''

GO
