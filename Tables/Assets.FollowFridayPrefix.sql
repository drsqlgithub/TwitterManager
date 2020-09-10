CREATE TABLE [Assets].[FollowFridayPrefix]
(
[FollowFridayPrefixId] [int] NOT NULL IDENTITY(1, 1),
[TweetText] [nvarchar] (110) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PositionNumber] [int] NOT NULL CONSTRAINT [DF_FollowFridayPrefix_PositionNumber] DEFAULT ((1))
) ON [PRIMARY]
GO
ALTER TABLE [Assets].[FollowFridayPrefix] ADD CONSTRAINT [PKFollowFridayPreamble] PRIMARY KEY CLUSTERED  ([FollowFridayPrefixId]) ON [PRIMARY]
GO
ALTER TABLE [Assets].[FollowFridayPrefix] ADD CONSTRAINT [AKFollowFridayPrefix] UNIQUE NONCLUSTERED  ([TweetText]) ON [PRIMARY]
GO
