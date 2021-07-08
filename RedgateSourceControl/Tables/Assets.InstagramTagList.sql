CREATE TABLE [Assets].[InstagramTagList]
(
[Type] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Taglist] [nvarchar] (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[InstagramTagList] ADD CONSTRAINT [PKInstagramTagList] PRIMARY KEY CLUSTERED  ([Type]) ON [PRIMARY]
GO
