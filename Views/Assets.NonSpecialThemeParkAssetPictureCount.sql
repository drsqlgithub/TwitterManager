SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [Assets].[NonSpecialThemeParkAssetPictureCount]
AS
SELECT ThemeParkAssetId,COUNT(*) AS PictureCount
FROM   Assets.Picture
WHERE EXISTS (SELECT *
			  FROM Assets.NonSpecialPicture
			  WHERE NonSpecialPicture.PictureId = Picture.PictureId)
GROUP BY ThemeParkAssetId
GO
