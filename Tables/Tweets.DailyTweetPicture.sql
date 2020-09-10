CREATE TABLE [Tweets].[DailyTweetPicture]
(
[DailyTweetPictureId] [int] NOT NULL IDENTITY(1, 1),
[DailyTweetId] [int] NOT NULL,
[PictureId] [int] NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweetPicture] ADD CONSTRAINT [CLUSTERED] PRIMARY KEY CLUSTERED  ([DailyTweetPictureId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_149] ON [Tweets].[DailyTweetPicture] ([DailyTweetId]) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweetPicture] ADD CONSTRAINT [AKDailyTweetPicture] UNIQUE NONCLUSTERED  ([DailyTweetId], [PictureId]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [fkIdx_184] ON [Tweets].[DailyTweetPicture] ([PictureId]) ON [PRIMARY]
GO
ALTER TABLE [Tweets].[DailyTweetPicture] ADD CONSTRAINT [FK_149] FOREIGN KEY ([DailyTweetId]) REFERENCES [Tweets].[DailyTweet] ([DailyTweetId])
GO
ALTER TABLE [Tweets].[DailyTweetPicture] ADD CONSTRAINT [FK_184] FOREIGN KEY ([PictureId]) REFERENCES [Assets].[Picture] ([PictureId])
GO
