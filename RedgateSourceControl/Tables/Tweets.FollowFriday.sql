CREATE TABLE [Tweets].[FollowFriday]
(
[FollowFridayTwitterAccountId] [int] NOT NULL IDENTITY(1, 1),
[DailyTweetId] [int] NOT NULL,
[TwitterAccountId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[FollowFriday] ADD CONSTRAINT [PKFollowFriday] PRIMARY KEY CLUSTERED  ([FollowFridayTwitterAccountId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_153] ON [Tweets].[FollowFriday] ([DailyTweetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_156] ON [Tweets].[FollowFriday] ([TwitterAccountId]) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[FollowFriday] ADD CONSTRAINT [FK_153] FOREIGN KEY ([DailyTweetId]) REFERENCES [Tweets].[DailyTweetFollowFriday] ([DailyTweetId])
GO
ALTER TABLE [Tweets].[FollowFriday] ADD CONSTRAINT [FK_156] FOREIGN KEY ([TwitterAccountId]) REFERENCES [Assets].[TwitterAccount] ([TwitterAccountId])
GO
