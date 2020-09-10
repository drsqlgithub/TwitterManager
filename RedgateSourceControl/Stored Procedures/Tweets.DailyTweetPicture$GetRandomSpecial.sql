SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO







CREATE    PROCEDURE [Tweets].[DailyTweetPicture$GetRandomSpecial] 
(
	@TweetTypeTag varchar(30),
	@TweetDate date = NULL,
	@FileSampleCount int = 10,
	@TweetNumber int = 1,
	@IncludeHolidayPicturesFlag bit = 0
) AS
SET NOCOUNT ON
IF @TweetDate IS NULL SET @TweetDate = SYSDATETIME();

TRUNCATE TABLE FileAssets.PicturePreview;

INSERT INTO FileAssets.PicturePreview(stream_id,
                           file_stream,
                           name,
                           path_locator,
                           creation_time,
                           last_write_time,
                           last_access_time,
                           is_directory,
                           is_offline,
                           is_hidden,
                           is_readonly,
                           is_archive,
                           is_system,
                           is_temporary)
SELECT TOP (@FileSampleCount) filePicture.stream_id,
                           filePicture.file_stream,
                           filePicture.name,
                           filePicture.path_locator,
                           filePicture.creation_time,
                           filePicture.last_write_time,
                           filePicture.last_access_time,
                           filePicture.is_directory,
                           filePicture.is_offline,
                           filePicture.is_hidden,
                           filePicture.is_readonly,
                           filePicture.is_archive,
                           filePicture.is_system,
                           filePicture.is_temporary
FROM   assets.specialPicture
		 JOIN Assets.Picture
			ON Picture.PictureId = SpecialPicture.PictureId
		 JOIN FileAssets.PictureDecoded
			ON PictureDecoded.PictureNumber = Picture.PictureNumber
		JOIN FileAssets.Picture AS filePicture
			ON PictureDecoded.PhysicalFileName  = filePicture.Name
WHERE  Picture.PictureId NOT IN (SELECT DailyTweetPicture.PictureId
								 FROM Tweets.DailyTweetPicture
										JOIN Tweets.DailyTweet
											ON DailyTweet.DailyTweetId = DailyTweetPicture.DailyTweetId
								 WHERE DailyTweet.TweetDate >= DATEADD(DAY,-60,SYSDATETIME()))
  AND  (picture.PictureId NOT IN (SELECT PictureId --do not include holiday pictures in NORMAL searches
								FROM   Assets.PictureTag
										JOIN Assets.Tag
											ON Tag.TagId = PictureTag.TagId
								WHERE Tag.HolidayTag = 1) 
			OR @IncludeHolidayPicturesFlag = 1)

  AND  SpecialPicture.SpecialTag = @TweetTypeTag 
ORDER BY NEWID();

SELECT CONCAT('EXEC Tweets.DailyTweetPicture$Insert @TweetDate = ''',@TweetDate,''', @TweetTypeTag = ''' +  @TweetTypeTag + ''', @TweetNumber = ' + CAST(@TweetNumber AS varchar(10)) + ',@PictureNumber = ''',PictureDecoded.PictureNumber, '''')
FROM  FileAssets.PicturePreview
		JOIN FileAssets.PictureDecoded
			ON PicturePreview.name = PictureDecoded.PhysicalFileName

GO
