SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [Assets].[ThemeParkAssetExpanded]
AS 

SELECT DISTINCT ThemeParkAsset.ThemeParkAreaId,
                ThemeParkAsset.ThemeParkAssetId,
                ThemeParkAsset.ThemeParkAssetHashtag,
                ThemeParkAsset.PopularityFactor,
                ThemeParkAsset.Description,
                ThemeParkAsset.Abbreviation,
                Tag.TagId AS SpecialTagId
FROM   Assets.Picture
		JOIN Assets.ThemeParkAsset
			ON ThemeParkAsset.ThemeParkAssetId = Picture.ThemeParkAssetId
		JOIN Assets.PictureTag
			ON PictureTag.PictureId = Picture.PictureId
		JOIN Assets.Tag
			ON Tag.TagId = PictureTag.TagId
WHERE  Tag.SpecialFlag = 1
UNION 
SELECT ThemeParkAsset.ThemeParkAreaId,
       ThemeParkAsset.ThemeParkAssetId,
       ThemeParkAsset.ThemeParkAssetHashtag,
       ThemeParkAsset.PopularityFactor,
       ThemeParkAsset.Description,
       ThemeParkAsset.Abbreviation,
       ThemeParkAsset.SpecialTagId
FROM   Assets.ThemeParkAsset
GO
