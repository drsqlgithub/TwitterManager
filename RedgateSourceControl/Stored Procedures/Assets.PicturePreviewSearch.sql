SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE    PROCEDURE [Assets].[PicturePreviewSearch] 
(
	@TagLike varchar(50) = '%',
	@ThemeParkAreaHashTagLike varchar(50) = '%'
) AS


 IF (SELECT COUNT(*)
	 FROM   FileAssets.PictureDecoded
			 JOIN FileAssets.Picture
				ON Picture.name = PictureDecoded.PhysicalFileName
	WHERE  (ThemeParkAssetHashTag LIKE '%' + @TagLike + '%'
		  OR  PictureDecoded.Tags LIKE '%' + @TagLike + '%')
	  AND  ThemeParkAreaHashTag LIKE @ThemeParkAreaHashTagLike) > 100
   RAISERROR ('Search limited to 100 items. Narrow search to get all items',10,1);

TRUNCATE TABLE FileAssets.PicturePreview

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
SELECT TOP 100 stream_id,
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
FROM   FileAssets.PictureDecoded
		 JOIN FileAssets.Picture
			ON Picture.name = PictureDecoded.PhysicalFileName
WHERE  (ThemeParkAssetHashTag LIKE '%' + @TagLike + '%'
      OR  PictureDecoded.Tags LIKE '%' + @TagLike + '%')
  AND  ThemeParkAreaHashTag LIKE @ThemeParkAreaHashTagLike
GO
