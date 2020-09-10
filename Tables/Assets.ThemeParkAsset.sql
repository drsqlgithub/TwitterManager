CREATE TABLE [Assets].[ThemeParkAsset]
(
[ThemeParkAreaId] [int] NOT NULL,
[ThemeParkAssetId] [int] NOT NULL IDENTITY(1, 1),
[ThemeParkAssetHashtag] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PopularityFactor] [int] NOT NULL CONSTRAINT [DFLTThemeParkAsset_PopularityFactor] DEFAULT ((1)),
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Abbreviation] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SpecialTagId] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[ThemeParkAsset] ADD CONSTRAINT [CHKThremeParkAsset_PopularityFactorRange] CHECK (([PopularityFactor]>=(1) AND [PopularityFactor]<=(100)))
GO
ALTER TABLE [Assets].[ThemeParkAsset] ADD CONSTRAINT [PLThemeParkAsset] PRIMARY KEY CLUSTERED  ([ThemeParkAssetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_252] ON [Assets].[ThemeParkAsset] ([SpecialTagId]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[ThemeParkAsset] ADD CONSTRAINT [ind_198] UNIQUE NONCLUSTERED  ([ThemeParkAreaId], [ThemeParkAssetHashtag]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[ThemeParkAsset] ADD CONSTRAINT [FK_252] FOREIGN KEY ([SpecialTagId]) REFERENCES [Assets].[Tag] ([TagId])
GO
ALTER TABLE [Assets].[ThemeParkAsset] ADD CONSTRAINT [FKThemeParkAsset$ref$ThemeParkArea] FOREIGN KEY ([ThemeParkAreaId]) REFERENCES [Assets].[ThemeParkArea] ([ThemeParkAreaId]) ON DELETE CASCADE
GO
