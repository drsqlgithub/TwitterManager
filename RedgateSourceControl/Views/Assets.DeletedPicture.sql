SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   VIEW [Assets].[DeletedPicture] AS 
WITH DeletedFiles AS (
SELECT ThemeParkArea.ThemeParkAreaHashtag, ThemeParkAsset.ThemeParkAssetHashtag, STRING_AGG(Tag,',') AS Tags, 
		Picture.PictureNumber AS OriginalPictureNumber, Picture.PictureId
FROM    Assets.Picture
		JOIN Assets.ThemeParkAsset
			ON ThemeParkAsset.ThemeParkAssetId = Picture.ThemeParkAssetId
		JOIN Assets.ThemeParkArea
			ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
		LEFT JOIN Assets.PictureTag
			JOIN Assets.Tag
				ON Tag.TagId = PictureTag.TagId
			ON PictureTag.PictureId = Picture.PictureId

WHERE  NOT EXISTS (SELECT *
					FROM FileAssets.PictureDecoded
					WHERE Picture.PictureNumber = PictureDecoded.PictureNumber)
GROUP BY ThemeParkArea.ThemeParkAreaHashtag, ThemeParkAsset.ThemeParkAssetHashtag, Picture.PictureNumber, Picture.PictureId)
SELECT *, CASE WHEN EXISTS (SELECT * FROM Tweets.DailyTweetPicture WHERE DailyTweetPicture.PictureId = DeletedFiles.PictureId) THEN 1 ELSE 0 END AS PictureInUseFlag
FROM DeletedFiles;
GO
