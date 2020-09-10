SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE    PROCEDURE  [FileAssets].[PictureInvalidImage$CopyToFix]
@outputListInResultSetFlag bit = 1
AS
SET XACT_ABORT ON;
BEGIN TRANSACTION

IF @outputListInResultSetFlag = 1
	SELECT *
	FROM    FileAssets.PictureInvalidImage;

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
FROM   FileAssets.PictureInvalidImage
		 JOIN FileAssets.Picture
			ON Picture.name = PictureInvalidImage.PhysicalFileName

DELETE FROM FileAssets.Picture
FROM   FileAssets.PictureInvalidImage
		 JOIN FileAssets.Picture
			ON Picture.name = PictureInvalidImage.PhysicalFileName



COMMIT
GO
