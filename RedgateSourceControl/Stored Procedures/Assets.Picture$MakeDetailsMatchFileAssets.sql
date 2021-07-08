SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   PROCEDURE [Assets].[Picture$MakeDetailsMatchFileAssets]
(
@ResetSequenceFlag bit = 0
)
AS

BEGIN
SET XACT_ABORT ON;
BEGIN TRANSACTION;

SET NOCOUNT OFF;
UPDATE Assets.Picture
SET    year = pictureDecoded.Year,
	   themeParkAssetId = PDTPA.ThemeParkAssetId,
	   RowRecoveryPhysicalFileName = PictureDecoded.physicalFileName
FROM   FileAssets.PictureDecoded
			JOIN Assets.ThemeParkAsset AS PDTPA
				JOIN Assets.ThemeParkArea AS PDTPAR
					ON PDTPAR.ThemeParkAreaId = PDTPA.ThemeParkAreaId
				ON PDTPA.ThemeParkAssetHashtag = PictureDecoded.ThemeParkAssetHashtag
				   AND PDTPAR.ThemeParkAreaHashtag = PictureDecoded.ThemeParkAreaHashtag
		LEFT JOIN Assets.Picture
			JOIN Assets.ThemeParkAsset
				JOIN Assets.ThemeParkArea
					ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
				ON ThemeParkAsset.ThemeParkAssetId = Picture.ThemeParkAssetId
			ON Picture.PictureNumber = PictureDecoded.PictureNumber
WHERE PictureDecoded.ThemeParkAreaHashtag <> ThemeParkArea.ThemeParkAreaHashtag
  OR  PictureDecoded.ThemeParkAssetHashtag <> ThemeParkAsset.ThemeParkAssetHashtag
  OR  PictureDecoded.Year <> Picture.Year
  OR  Picture.RowRecoveryPhysicalFileName IS NULL 
  OR  picture.RowRecoveryPhysicalFileName <> pictureDecoded.PhysicalFileName COLLATE DATABASE_DEFAULT

INSERT INTO Assets.Picture(PictureNumber, ThemeParkAssetId, Year, RowRecoveryPhysicalFileName)
SELECT PictureDecoded.PictureNumber, PictureDecoded.ThemeParkAssetId, year, PictureDecoded.PhysicalFileName
FROM   FileAssets.PictureDecoded
			JOIN Assets.ThemeParkAsset AS PDTPA
				JOIN Assets.ThemeParkArea AS PDTPAR
					ON PDTPAR.ThemeParkAreaId = PDTPA.ThemeParkAreaId
				ON PDTPA.ThemeParkAssetHashtag = PictureDecoded.ThemeParkAssetHashtag
				   AND PDTPAR.ThemeParkAreaHashtag = PictureDecoded.ThemeParkAreaHashtag
WHERE NOT EXISTS (SELECT *
				  FROM   Assets.Picture 
				  WHERE  Picture.PictureNumber = PictureDecoded.PictureNumber)


SET NOCOUNT ON;
DROP TABLE IF EXISTS #hold
SELECT PictureDecoded.ThemeParkAreaHashtag AS ThemeParkAreaHashtag,
	   PictureDecoded.ThemeParkAssetHashtag AS ThemeParkAssetHashtag,
	   pictureNumber, PictureDecoded.PhysicalFileName, year
INTO #hold
FROM   FileAssets.PictureDecoded

SET NOCOUNT OFF;

INSERT INTO Assets.Picture(PictureNumber, ThemeParkAssetId, Year)
SELECT PictureNumber, ThemeParkAssetId, LEN(YEAR)
FROM   #hold AS PictureDecoded
			JOIN Assets.ThemeParkArea
				ON ThemeParkArea.ThemeParkAreaHashtag = PictureDecoded.ThemeParkAreaHashtag
			JOIN Assets.ThemeParkAsset
				ON ThemeParkAsset.ThemeParkAreaId = ThemeParkArea.ThemeParkAreaId
				 AND ThemeParkAsset.ThemeParkAssetHashtag = PictureDecoded.ThemeParkAssetHashtag
WHERE NOT EXISTS (SELECT *
				  FROM   Assets.Picture AS checker
				  WHERE  checker.PictureNumber = PictureDecoded.PictureNumber)

INSERT INTO Assets.Tag(Tag, SpecialFlag)
SELECT  DISTINCT TRIM(Value), 0
FROM   FileAssets.PictureDecoded
		CROSS APPLY STRING_SPLIT(Tags,' ')
WHERE NOT (value LIKE '([0-9]%'
           AND value LIKE '%[0-9])')
  AND value NOT IN (SELECT Tag FROM Assets.Tag)
  AND value NOT IN ('of','the','from','A')
  

SET NOCOUNT ON;
DROP TABLE IF EXISTS #hold2   
SELECT Picture.PictureId,Tag.TagId 
INTO #hold2
FROM   FileAssets.PictureDecoded
		CROSS APPLY STRING_SPLIT(Tags,' ') AS Tags
	   JOIN Assets.Picture
		ON Picture.PictureNumber = PictureDecoded.PictureNumber
	   JOIN Assets.Tag
		ON Tag.Tag = Tags.Value

SET NOCOUNT OFF;
INSERT INTO Assets.PictureTag(PictureId, TagId)
SELECT DISTINCT PictureId, TagId
FROM  #hold2 AS PictureDecodedTags
WHERE NOT EXISTS (SELECT *
			      FROM  Assets.PictureTag AS checker
				  WHERE  checker.PictureId = PictureDecodedTags.PictureId
				    AND  checker.TagId = PictureDecodedTags.TagId)

DELETE checker
FROM Assets.PictureTag AS checker
WHERE  NOT EXISTS (SELECT *
				   FROM #hold2
				   WHERE #hold2.PictureId = checker.PictureId
				     AND #hold2.TagId = #hold2.TagId)

--reset the sequence if needed
IF @ResetSequenceFlag = 1
 BEGIN
	DECLARE @i int = CAST((SUBSTRING((SELECT MAX(pictureNumber) FROM Assets.Picture),4,8)) AS int), @statement nvarchar(MAX) 
	SET @i = COALESCE(@i + 1,1)
	SET @statement = CONCAT('
	ALTER SEQUENCE [Assets].[PictureNumberSequence] 
	RESTART WITH ',@i)
	EXECUTE (@statement)
 END


INSERT INTO Assets.WindowWednesdayTopicDetail(TagId)
SELECT tagId
FROM   Assets.Tag
WHERE  tag LIKE '(WW%)'
  AND  tagId NOT IN (SELECT tagId
                     FROM   Assets.WindowWednesdayTopicDetail)

 COMMIT



END;
GO
