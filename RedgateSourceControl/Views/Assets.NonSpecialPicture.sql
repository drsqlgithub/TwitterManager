SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Assets].[NonSpecialPicture]
AS
SELECT PictureId
FROM   Assets.Picture
WHERE  NOT EXISTS (SELECT * 
						 FROM Assets.PictureTag
								JOIN Assets.Tag
									ON Tag.TagId = PictureTag.TagId
						 WHERE  PictureTag.PictureId = Picture.PictureId
						   AND  Tag.SpecialFlag = 1) ;
GO
