CREATE TABLE [Assets].[Tag]
(
[TagId] [int] NOT NULL IDENTITY(1, 1),
[Tag] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SpecialFlag] [bit] NOT NULL CONSTRAINT [DFLTTag_SpecialTag] DEFAULT ((0)),
[MaxDailyUseCount] [tinyint] NOT NULL CONSTRAINT [DFLTTag_MaxDailyUseCount] DEFAULT ((1)),
[HolidayTag] [bit] NOT NULL CONSTRAINT [DFLTTag_HolidayTag] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[Tag] ADD CONSTRAINT [CHKTag_HolidayTagSetting] CHECK (([HolidayTag]=(0) OR [HolidayTag]=(1) AND [SpecialFlag]=(1)))
GO
ALTER TABLE [Assets].[Tag] ADD CONSTRAINT [PK_tag] PRIMARY KEY CLUSTERED  ([TagId]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[Tag] ADD CONSTRAINT [AKTag] UNIQUE NONCLUSTERED  ([Tag]) ON [PRIMARY]
GO
