SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE      PROCEDURE [Tweets].[DailyTweetPicture$Insert](
	@TweetDate date,
	@TweetTypeTag varchar(30),
	@TweetNumber int = 1,
	@PictureNumber varchar(10)
)
AS
SET XACT_ABORT ON
BEGIN TRANSACTION

DECLARE @Subdir nvarchar(10) = CONCAT(YEAR(@TweetDate) ,'_' , RIGHT(CONCAT('00',MONTH(@TweetDate)),2))

DECLARE @PictureSuffix nvarchar(30) =''

IF @TweetTypeTag <> 'Normal'
	SET @PictureSuffix = '{' + @TweetTypeTag + '}'

DECLARE @PictureId int = (SELECT PictureId
						  FROM   Assets.Picture
						  WHERE  Picture.PictureNumber = @PictureNumber)

DECLARE @TweetTypeTagId int = (SELECT TagId FROM Assets.Tag WHERE Tag = @TweetTypeTag);

DECLARE @DailyTweetId int = (SELECT DailyTweetId
					   FROM   Tweets.DailyTweet
					   WHERE  TweetDate = @TweetDate
					     AND  TweetTypeTagId = @TweetTypeTagId
						 AND  TweetNumber = @TweetNumber)

INSERT INTO Tweets.DailyTweetPicture(PictureId, DailyTweetId)
SELECT @PictureId, @DailyTweetId

--if the directory doesn't exist yet, creat it
IF NOT EXISTS (SELECT *
			   FROM   FileAssets.DailyTweetMedia
			   WHERE  DailyTweetMedia.is_directory = 1
			     AND  name = @Subdir)
  INSERT INTO FileAssets.DailyTweetMedia(
                              name,
                              is_directory)
  VALUES(@Subdir,1)


--get the pathlocator for the insert
DECLARE @parentPath hierarchyid,
        @PathLocator VARCHAR(675)
SELECT  @parentPath = DailyTweetMedia.path_locator
FROM   FileAssets.DailyTweetMedia
WHERE  name = @Subdir
  AND is_directory = 1

SELECT  @PathLocator = @parentPath.ToString()
        + CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(CONVERT(binary(16), NEWID()),
                                                         1, 6))) + '.'
        + CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(CONVERT(binary(16), NEWID()),
                                                         7, 6))) + '.'
        + CONVERT(varchar(20), CONVERT(bigint, SUBSTRING(CONVERT(binary(16), NEWID()),
                                                         13, 4))) + '/'

INSERT INTO FileAssets.DailyTweetMedia(stream_id,
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
SELECT NEWID(),
                                   file_stream,
                                   CAST(@TweetDate AS varchar(10)) + '_' + CASE WHEN @PictureSuffix <> '' THEN REPLACE(REPLACE(@TweetTypeTag,'{',''),'}','') + '_' ELSE '' END + PictureDecoded.PictureNumber + '.jpg',
                                   @PathLocator ,
                                   creation_time,
                                   last_write_time,
                                   last_access_time,
                                   is_directory,
                                   is_offline,
                                   is_hidden,
                                   is_readonly,
                                   is_archive,
                                   is_system,
                                   is_temporary
FROM   FileAssets.Picture
		JOIN FileAssets.PictureDecoded
			ON picture.name = PictureDecoded.PhysicalFileName
WHERE  PictureDecoded.PictureNumber = @PictureNumber

COMMIT TRANSACTION

GO
