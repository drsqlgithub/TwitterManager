SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    PROCEDURE [FileAssets].[Picture$AddPictureNumber]
AS
 BEGIN
	UPDATE FileAssets.Picture
	 SET name = REPLACE(name,'.jpg','') + '_PIC' + RIGHT(CONCAT('0000000', NEXT VALUE FOR Assets.PictureNumberSequence),7) + '.jpg' 
	 FROM   FileAssets.Picture
	WHERE  Picture.name <> 'desktop.ini'
	  AND  name NOT LIKE '%_PIC[0-9][0-9][0-9][0-9][0-9][0-9][0-9].jpg'
 END

 
 
GO
