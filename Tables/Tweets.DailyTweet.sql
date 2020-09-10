CREATE TABLE [Tweets].[DailyTweet]
(
[DailyTweetId] [int] NOT NULL IDENTITY(1, 1),
[TweetDate] [date] NOT NULL,
[TweetNumber] [tinyint] NOT NULL,
[TweetText] [nvarchar] (280) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[TweetTypeTagId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweet] ADD CONSTRAINT [PKDailyTweet] PRIMARY KEY CLUSTERED  ([DailyTweetId]) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweet] ADD CONSTRAINT [AKDailyTweet] UNIQUE NONCLUSTERED  ([TweetDate], [TweetNumber], [TweetTypeTagId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_232] ON [Tweets].[DailyTweet] ([TweetTypeTagId]) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweet] ADD CONSTRAINT [FK_232] FOREIGN KEY ([TweetTypeTagId]) REFERENCES [Assets].[Tag] ([TagId])
GO
