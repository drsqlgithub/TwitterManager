SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Assets].[SpecialTagAssetPictureCount]
AS
SELECT Tag.Tag,COUNT(*) AS PictureCount
FROM   Assets.Picture
		 JOIN Assets.PictureTag
			ON PictureTag.PictureId = Picture.PictureId
		 JOIN Assets.Tag
			ON Tag.TagId = PictureTag.TagId
WHERE  tag.SpecialFlag = 1
GROUP BY Tag.Tag
GO
