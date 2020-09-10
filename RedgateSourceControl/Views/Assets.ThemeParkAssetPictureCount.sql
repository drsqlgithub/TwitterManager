SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE VIEW [Assets].[ThemeParkAssetPictureCount]
AS
SELECT ThemeParkAssetId,COUNT(*) AS PictureCount
FROM   Assets.Picture
GROUP BY ThemeParkAssetId

GO
