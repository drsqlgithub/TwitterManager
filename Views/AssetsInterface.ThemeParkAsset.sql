SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE VIEW [AssetsInterface].[ThemeParkAsset]
as

SELECT ThemeParkAreaHashtag AS RO_ThemeParkAreaHashtag,
	   ThemeParkArea.ThemeParkAreaId AS RO_ThemeParkAreaId,
	   ThemeParkAsset.*
FROM   Assets.ThemeParkArea
		 LEFT JOIN Assets.ThemeParkAsset
			ON ThemeParkAsset.ThemeParkAreaId = ThemeParkArea.ThemeParkAreaId
GO
