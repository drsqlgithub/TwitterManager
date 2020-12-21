USE TwitterManager
GO
EXIT

--Adding new pictures

--add picture number to new files
EXEC FileAssets.Picture$AddPictureNumber;


EXIT
--copy files for fixing to the FixImages folder
FileAssets.PictureInvalidImage$CopyToFix

EXIT
Assets.Picture$MakeDetailsMatchFileAssets


--list files to fix
SELECT *
FROM    FileAssets.PictureInvalidImage;


SELECT *
FROM   AssetsInterface.ThemeParkAsset
WHERE  ThemeParkAsset.ThemeParkAssetHashtag LIKE '%Africa%'

EXIT
DECLARE @findTag varchar(100) = 'Frontierland'
DECLARE @ReplaceTag varchar(100) = 'FrontierlandArea'

BEGIN TRANSACTION

UPDATE fileAssets.Picture
SET name = REPLACE(name,CONCAT('_',@findtag,'_'),CONCAT('_',@replacetag,'_'))
WHERE  Picture.name LIKE CONCAT('%~_',@findtag,'~_%') ESCAPE '~'

SELECT name
FROM   FileAssets.Picture
WHERE  Picture.name LIKE CONCAT('%~_',@findtag,'~_%') ESCAPE '~'

SELECT *
FROM   FileAssets.Picture
WHERE  Picture.name LIKE CONCAT('%~_',@Replacetag,'~_%') ESCAPE '~'
ORDER BY creation_Time desc

ROLLBACK

COMMIT