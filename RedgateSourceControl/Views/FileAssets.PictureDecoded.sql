SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE     VIEW [FileAssets].[PictureDecoded]
AS
WITH Decoded AS (
SELECT Tools.String$SplitPart(name, '_',1) AS Year,
	  Tools.String$SplitPart(name, '_',2) AS ThemeParkAreaHashtag,
	  Tools.String$SplitPart(name, '_',3) AS ThemeParkAssetHashtag,
	  Tools.String$SplitPart(name, '_',4) AS Tags,
	   name AS PhysicalFileName,
	   CAST(REPLACE(Tools.String$SplitPart(name, '_',5),'.jpg','') AS varchar(10)) AS PictureNumber
FROM   FileAssets.Picture
WHERE  name NOT IN ('desktop.ini')
)
SELECT Decoded.*, ThemeParkAsset.ThemeParkAssetId, ThemeParkArea.ThemeParkAreaId,
	   CONCAT(
		CASE WHEN Decoded.PhysicalFileName LIKE  '%~_ %' ESCAPE '~' THEN 'SpaceAfter _' END + ';', 
		CASE WHEN Decoded.PhysicalFileName NOT LIKE  '%~_%~_%~_%~_%' ESCAPE '~' THEN 'Wrong Number Of _' END + ';',
		CASE WHEN Decoded.PictureNumber IS NULL THEN 'No Picture Number' END + ';',
		CASE WHEN ThemeParkAsset.ThemeParkAssetId IS NULL THEN 'No Asset' END + ';',
		CASE WHEN ThemeParkArea.ThemeParkAreaId IS NULL THEN 'No Area' END + ';'
		) AS DataIssues
FROM   Decoded
		LEFT JOIN Assets.ThemeParkArea
			ON ThemeParkArea.ThemeParkAreaHashtag = Decoded.ThemeParkAreaHashtag
		LEFT JOIN Assets.ThemeParkAsset
			ON ThemeParkAsset.ThemeParkAreaId = ThemeParkArea.ThemeParkAreaId
			   AND Decoded.ThemeParkAssetHashtag = ThemeParkAsset.ThemeParkAssetHashtag
GO
