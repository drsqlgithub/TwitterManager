CREATE TABLE [Assets].[Picture]
(
[PictureId] [int] NOT NULL IDENTITY(1, 1),
[PictureNumber] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ThemeParkAssetId] [int] NOT NULL,
[Year] [char] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowRecoveryPhysicalFileName] [nvarchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[Picture] ADD CONSTRAINT [PK_picture] PRIMARY KEY CLUSTERED  ([PictureId]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[Picture] ADD CONSTRAINT [AKPictureDetail] UNIQUE NONCLUSTERED  ([PictureNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ind_204] ON [Assets].[Picture] ([PictureNumber]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_199] ON [Assets].[Picture] ([ThemeParkAssetId]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[Picture] ADD CONSTRAINT [FK_199] FOREIGN KEY ([ThemeParkAssetId]) REFERENCES [Assets].[ThemeParkAsset] ([ThemeParkAssetId])
GO
