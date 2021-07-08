SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [Assets].[SpecialPicture]
AS
SELECT Picture.PictureId, Tag.Tag AS Tag
FROM   Assets.Picture
		 JOIN Assets.PictureTag
			ON PictureTag.PictureId = Picture.PictureId
		 JOIN Assets.Tag
			ON Tag.TagId = PictureTag.TagId
GO
