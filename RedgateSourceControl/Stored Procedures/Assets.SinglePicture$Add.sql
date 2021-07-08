SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [Assets].[SinglePicture$Add]
	@SourceFileName nvarchar(255) ,
	@ThemeParkAreaHashtag varchar(100),
	@ThemeParkAssetHashtag varchar(100),
	@Year char(4),
	@TagList  varchar(1000) 
AS
 BEGIN


IF @SourceFileName LIKE '%PIC%'
	THROW 50000,'This procedure can only be used to add a new picture. Use CREATE Assets.SinglePicture$SetTags',1

IF @SourceFileName NOT LIKE '%.jpg'
	SET @SourceFileName = @SourceFileName + '.jpg'

IF NOT EXISTS (SELECT *
				FROM   FileAssets.PictureDecoded
				WHERE PictureDecoded.PhysicalFileName = @SourceFileName)
	THROW 50000,'Invalid source file name',1;


IF NOT EXISTS (
	SELECT *
	FROM   Assets.ThemeParkAsset
			JOIN Assets.ThemeParkArea
				ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
	WHERE ThemeParkArea.ThemeParkAreaHashtag = @ThemeParkAreaHashtag
	  AND  ThemeParkAsset.ThemeParkAssetHashtag = @ThemeParkAssetHashtag
	)
 THROW 50000, 'Invalid Area or Asset Hashtag',1;

IF CAST(@Year AS int) NOT BETWEEN 1970 AND YEAR(SYSDATETIME())
	 THROW 50000, 'Unrealistic year passed in',1;

DECLARE @NewFileName nvarchar(255) = CONCAT(@Year,'_',@ThemeParkAreaHashtag,'_',@ThemeParkAssetHashtag,'_',@TagList,'.jpg') 

SELECT @NewFileName

UPDATE FileAssets.PictureDecoded
SET PictureDecoded.PhysicalFileName = @NewFileName
WHERE  PictureDecoded.PhysicalFileName = @SourceFileName


EXEC [FileAssets].[Picture$AddPictureNumber]

SELECT *
FROM   FileAssets.PictureDecoded
WHERE  PictureDecoded.PhysicalFileName LIKE CONCAT(@Year,'_',@ThemeParkAreaHashtag,'_',@ThemeParkAssetHashtag,'_',@TagList,'%') 

END;
GO
