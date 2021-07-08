SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [FileAssets].[Picture$ChangeDelimitedTag]
(
	@FindTag varchar(100),
	@ReplaceTag varchar(100),
	@CommitChangeFlag bit = 0
)
AS 
IF LEN(@FindTag) = 0 OR LEN(@ReplaceTag) = 0 OR @FindTag + @ReplaceTag IS NULL
	THROW 50000,'The tag parameters need to be > 0 and not null',1;

SET XACT_ABORT ON
BEGIN TRANSACTION

DROP TABLE IF EXISTS #PicturesToChange
SELECT PictureDecoded.PictureNumber
INTO #PicturesToChange
FROM   FileAssets.PictureDecoded
WHERE  PictureDecoded.PhysicalFileName LIKE CONCAT('%~_',@findtag,'~_%') ESCAPE '~'

SELECT *
FROM   #PicturesToChange

SELECT PhysicalFileName
FROM   FileAssets.PictureDecoded
WHERE  PictureDecoded.PhysicalFileName LIKE CONCAT('%~_',@findtag,'~_%') ESCAPE '~'

UPDATE fileAssets.Picture
SET name = REPLACE(name,CONCAT('_',@findtag,'_'),CONCAT('_',@replacetag,'_'))
WHERE  Picture.name LIKE CONCAT('%~_',@findtag,'~_%') ESCAPE '~'

SELECT *, CASE WHEN EXISTS (SELECT * FROM  #PicturesToChange AS two WHERE two.PictureNumber = PictureDecoded.PictureNumber) THEN 1 ELSE 0 END AS ChangedFlag
FROM   FileAssets.PictureDecoded
WHERE  PictureDecoded.PhysicalFileName LIKE CONCAT('%~_',@Replacetag,'~_%') ESCAPE '~'
ORDER BY ChangedFlag desc

IF @CommitChangeFlag = 0
	ROLLBACK
ELSE
	COMMIT
GO
