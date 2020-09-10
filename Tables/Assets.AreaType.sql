CREATE TABLE [Assets].[AreaType]
(
[AreaTypeCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RandomMultiplierValue] [numeric] (4, 2) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[AreaType] ADD CONSTRAINT [PK_areatype] PRIMARY KEY CLUSTERED  ([AreaTypeCode]) ON [PRIMARY]
GO
