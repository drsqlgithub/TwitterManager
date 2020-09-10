CREATE TABLE [Assets].[ThemeParkArea]
(
[ThemeParkAreaHashtag] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ThemeParkAreaId] [int] NOT NULL IDENTITY(1, 1),
[RandomMultiplierValue] [numeric] (4, 2) NOT NULL,
[AreaTypeCode] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Abbreviation] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[ThemeParkArea] ADD CONSTRAINT [PKThemePark] PRIMARY KEY CLUSTERED  ([ThemeParkAreaId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_119] ON [Assets].[ThemeParkArea] ([AreaTypeCode]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[ThemeParkArea] ADD CONSTRAINT [FK_119] FOREIGN KEY ([AreaTypeCode]) REFERENCES [Assets].[AreaType] ([AreaTypeCode])
GO
