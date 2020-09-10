CREATE TABLE [Tweets].[DailyTweetFollowFriday]
(
[DailyTweetId] [int] NOT NULL,
[FollowFridayPrefixId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweetFollowFriday] ADD CONSTRAINT [PK_dailytweetfollowfriday] PRIMARY KEY CLUSTERED  ([DailyTweetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_144] ON [Tweets].[DailyTweetFollowFriday] ([DailyTweetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_224] ON [Tweets].[DailyTweetFollowFriday] ([FollowFridayPrefixId]) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweetFollowFriday] ADD CONSTRAINT [FK_144] FOREIGN KEY ([DailyTweetId]) REFERENCES [Tweets].[DailyTweet] ([DailyTweetId])
GO
ALTER TABLE [Tweets].[DailyTweetFollowFriday] ADD CONSTRAINT [FK_224] FOREIGN KEY ([FollowFridayPrefixId]) REFERENCES [Assets].[FollowFridayPrefix] ([FollowFridayPrefixId])
GO
