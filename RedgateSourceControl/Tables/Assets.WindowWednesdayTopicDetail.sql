CREATE TABLE [Assets].[WindowWednesdayTopicDetail]
(
[TagId] [int] NOT NULL,
[Description1] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Description2] [varchar] (300) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[WindowWednesdayTopicDetail] ADD CONSTRAINT [PK__WindowWe__657CF9AC5C1871D0] PRIMARY KEY CLUSTERED  ([TagId]) ON [PRIMARY]
GO
