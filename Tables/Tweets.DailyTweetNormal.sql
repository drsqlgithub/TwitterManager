CREATE TABLE [Tweets].[DailyTweetNormal]
(
[DailyTweetId] [int] NOT NULL,
[ThemeParkAssetId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweetNormal] ADD CONSTRAINT [PK_dailytweetnormal] PRIMARY KEY CLUSTERED  ([DailyTweetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_139] ON [Tweets].[DailyTweetNormal] ([DailyTweetId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_135] ON [Tweets].[DailyTweetNormal] ([ThemeParkAssetId]) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweetNormal] ADD CONSTRAINT [FK_135] FOREIGN KEY ([ThemeParkAssetId]) REFERENCES [Assets].[ThemeParkAsset] ([ThemeParkAssetId])
GO
ALTER TABLE [Tweets].[DailyTweetNormal] ADD CONSTRAINT [FK_139] FOREIGN KEY ([DailyTweetId]) REFERENCES [Tweets].[DailyTweet] ([DailyTweetId])
GO
