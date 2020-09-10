SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE    PROCEDURE  [FileAssets].[Picture$FetchDuplicatePictureNumberToFix]
@outputListInResultSetFlag bit = 1
AS
SET XACT_ABORT ON;
BEGIN TRANSACTION

CREATE TABLE #dups
(
	PictureNumber varchar(10)
)

INSERT INTO #dups
SELECT PictureNumber
FROM    FileAssets.PictureDecoded
GROUP BY PictureDecoded.PictureNumber
HAVING COUNT(*) > 1;


IF @outputListInResultSetFlag = 1
	SELECT *
	FROM   #dups

INSERT INTO FileAssets.FixImages(stream_id,
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
SELECT stream_id,
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
                           is_temporary
FROM   #dups
		 JOIN FileAssets.PictureDecoded
			ON PictureDecoded.PictureNumber = #dups.PictureNumber
		 JOIN FileAssets.Picture
			ON Picture.name = PictureDecoded.PhysicalFileName

DELETE FROM FileAssets.Picture
FROM   #dups
		 JOIN FileAssets.PictureDecoded
			ON PictureDecoded.PictureNumber = #dups.PictureNumber
		 JOIN FileAssets.Picture
			ON Picture.name = PictureDecoded.PhysicalFileName

COMMIT
GO
