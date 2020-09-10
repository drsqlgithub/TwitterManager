SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   VIEW [FileAssets].[PictureInvalidImage]
AS
SELECT PictureDecoded.Year,
       PictureDecoded.ThemeParkAreaHashtag,
       PictureDecoded.ThemeParkAssetHashtag,
       PictureDecoded.Tags,
       PictureDecoded.PhysicalFileName,
       PictureDecoded.PictureNumber,
       PictureDecoded.ThemeParkAssetId,
       PictureDecoded.ThemeParkAreaId,
       PictureDecoded.DataIssues
FROM   FileAssets.PictureDecoded
WHERE  LEN(PictureDecoded.DataIssues) > 0
GO
