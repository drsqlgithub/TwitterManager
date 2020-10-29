SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   VIEW [AssetsInterface].[ThemeParkAsset]
AS

SELECT ThemeParkAssetId,
	   ThemeParkAreaHashtag,
	   ThemeParkAsset.ThemeParkAssetHashtag,
	   ThemeParkAsset.PopularityFactor,
	   ThemeParkAsset.Description,
	   ThemeParkAsset.Abbreviation,
	   Tag.Tag AS SpecialTag
FROM   Assets.ThemeParkArea
		 JOIN Assets.ThemeParkAsset
			ON ThemeParkAsset.ThemeParkAreaId = ThemeParkArea.ThemeParkAreaId
		 LEFT JOIN Assets.Tag
			ON Tag.TagId = ThemeParkAsset.SpecialTagId
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   TRIGGER [AssetsInterface].[ThemeParkAsset$Delete]
ON [AssetsInterface].[ThemeParkAsset]
INSTEAD OF DELETE
AS 
BEGIN
	SET NOCOUNT ON;

	DELETE FROM Assets.ThemeParkAsset
	WHERE  ThemeParkAsset.ThemeParkAssetId IN (SELECT ThemeParkAssetId FROM Deleted);
	
 END;
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   TRIGGER [AssetsInterface].[ThemeParkAsset$Insert]
ON [AssetsInterface].[ThemeParkAsset]
INSTEAD OF INSERT
AS 
BEGIN
	SET NOCOUNT ON;
	INSERT INTO Assets.ThemeParkAsset(
							   ThemeParkAreaId,
	                           ThemeParkAssetHashtag,
	                           PopularityFactor,
	                           Description,
	                           Abbreviation,
	                           SpecialTagId)
	SELECT ThemeParkArea.ThemeParkAreaId, Inserted.ThemeParkAssetHashtag,
		   Inserted.PopularityFactor, inserted.Description, Inserted.Abbreviation, tag.TagId
	FROM   Inserted
			LEFT OUTER JOIN Assets.Tag
				ON Inserted.SpecialTag = Tag.Tag
			LEFT OUTER JOIN Assets.ThemeParkArea
				ON ThemeParkArea.ThemeParkAreaHashtag = Inserted.ThemeParkAreaHashtag;

 END
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   TRIGGER [AssetsInterface].[ThemeParkAsset$Update]
ON [AssetsInterface].[ThemeParkAsset]
INSTEAD OF UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	UPDATE Assets.ThemeParkAsset
	SET   ThemeParkAreaId = ThemeParkArea.ThemeParkAreaId,
		  ThemeParkAssetHashtag = Inserted.ThemeParkAssetHashtag,
	      PopularityFactor = Inserted.PopularityFactor,
	      Description = inserted.Description,
	      Abbreviation = Inserted.Abbreviation,
	      SpecialTagId = tag.TagId
	FROM   Inserted
			JOIN Assets.ThemeParkAsset
				ON ThemeParkAsset.ThemeParkAssetId = Inserted.ThemeParkAssetId
			LEFT OUTER JOIN Assets.Tag
				ON Inserted.SpecialTag = Tag.Tag
			LEFT OUTER JOIN Assets.ThemeParkArea
				ON ThemeParkArea.ThemeParkAreaHashtag = Inserted.ThemeParkAreaHashtag;
 END;
GO
