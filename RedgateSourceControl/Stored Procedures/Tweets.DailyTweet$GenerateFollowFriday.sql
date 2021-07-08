SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO








CREATE    PROCEDURE [Tweets].[DailyTweet$GenerateFollowFriday]
(
	@TweetDate date,
	@AllowNonFridayDateFlag bit = 0,
	@NumberOfTweets int = 2
)
AS
SET NOCOUNT ON;
SET XACT_ABORT ON;
--BEGIN TRAN;

IF DATENAME(WEEKDAY,@TweetDate) <> 'Friday' AND @AllowNonFridayDateFlag = 0
	THROW 50000,'@TweetDate parameter to be a date that is Friday unless @AllowNonFridayDateFlag is set to true',1;

CREATE TABLE #holdMessages
(
	followFridayPrefixId int,
	messageText nvarchar(110),
	position int
)

INSERT INTO #holdMessages(FollowFridayPrefixId, messageText, position)
SELECT TOP 1 FollowFridayPrefix.FollowFridayPrefixId, TweetText, 1
FROM    Assets.FollowFridayPrefix
WHERE   FollowFridayPrefix.PositionNumber = 1
	AND  NOT exists (SELECT *
					 FROM   Tweets.DailyTweet
							 JOIN Tweets.DailyTweetFollowFriday
								ON DailyTweetFollowFriday.DailyTweetId = DailyTweet.DailyTweetId
					 WHERE  DailyTweetFollowFriday.FollowFridayPrefixId = FollowFridayPrefix.FollowFridayPrefixId
					   AND  DailyTweet.TweetDate >= DATEADD(DAY,-60,SYSDATETIME()))
ORDER BY NEWID()
	
DECLARE @i int = 2
WHILE @I <= @NumberOfTweets
 BEGIN
	INSERT INTO #holdMessages(FollowFridayPrefixId, messageText, position)
	SELECT TOP 1 FollowFridayPrefix.FollowFridayPrefixId, TweetText, @i
	FROM    Assets.FollowFridayPrefix
	WHERE   FollowFridayPrefix.PositionNumber = 2
		AND  NOT exists (SELECT *
						 FROM   Tweets.DailyTweet
								 JOIN Tweets.DailyTweetFollowFriday
									ON DailyTweetFollowFriday.DailyTweetId = DailyTweet.DailyTweetId
						 WHERE  DailyTweetFollowFriday.FollowFridayPrefixId = FollowFridayPrefix.FollowFridayPrefixId
						   AND  DailyTweet.TweetDate >= DATEADD(DAY,-60,SYSDATETIME()))
	ORDER BY NEWID();

	SET @i = @i + 1;
 END


 SET @i = 1

 CREATE TABLE #holdAccountNames 
 (
	TwitterAccountId int,
	Position int
)

DECLARE @position INT = 1, @TwitterAccountId int, @CurrentLength tinyint, @NewItemLength tinyint
 WHILE @position <= @NumberOfTweets
  BEGIN

	SELECT TOP 1 @TwitterAccountId = TwitterAccount.TwitterAccountId
	FROM   Assets.TwitterAccount
			LEFT JOIN Tweets.FollowFriday
				JOIN Tweets.DailyTweetFollowFriday
					ON DailyTweetFollowFriday.DailyTweetId = FollowFriday.DailyTweetId
				JOIN Tweets.DailyTweet
					ON DailyTweet.DailyTweetId = DailyTweetFollowFriday.DailyTweetId

				ON FollowFriday.TwitterAccountId = TwitterAccount.TwitterAccountId
	WHERE   TwitterAccount.DeadAccountFlag <> 1
		AND TwitterAccount.LockedFlag <> 1
		AND TwitterAccount.FollowFridayFlag = 1
		AND TwitterAccount.TwitterAccountId NOT IN (SELECT TwitterAccountId FROM #holdAccountNames)
    GROUP BY TwitterAccount.TwitterAccountId
	ORDER BY  COALESCE(MAX(DailyTweet.TweetDate),'1999-01-01') ASC,NEWID()
	
	SELECT @CurrentLength = SUM(LEN(TwitterAccount.TwitterHandle))
	FROM  #holdAccountNames
				JOIN Assets.TwitterAccount
					ON TwitterAccount.TwitterAccountId = #holdAccountNames.TwitterAccountId
	WHERE #holdAccountNames.Position = @position

	SELECT @NewItemLength = LEN(TwitterAccount.TwitterHandle) 
    FROM   Assets.TwitterAccount
	WHERE  TwitterAccount.TwitterAccountId = @TwitterAccountId 
	
	IF COALESCE(@CurrentLength,0) + @NewItemLength < 170
	   BEGIN
			INSERT INTO #holdAccountNames(TwitterAccountId, Position)
			VALUES(@TwitterAccountId, @Position)-- Position - int
	   END
	   ELSE
	   BEGIN
			SET @position = @position + 1;
		END
			
  END;

  SELECT '--Position = ' + CAST(#holdAccountNames.position AS varchar(10))+ CHAR(13) + CHAR(10) + 'SET XACT_ABORT ON; BEGIN TRANSACTION;' + CHAR(13) + CHAR(10) + 'EXECUTE ' + DB_NAME() + '.Tweets.DailyTweet$Insert @TweetNumber = ' + CAST(#holdAccountNames.Position AS varchar(10)) + ', @TweetDate = ''' + CAST(@TweetDate AS varchar(30)) + ''' ,@TweetTypeTag = ''{FollowFriday}'',' + CHAR(13) + CHAR(10) + '@TweetText = ''' + tools.[String$EscapeString](#holdMessages.messageText,DEFAULT,0) + ' ' +  STRING_AGG(TwitterAccount.TwitterHandle,' ') + ''''+ 
	', @FollowFridayPrefixId = ' + CAST(#holdMessages.followFridayPrefixId AS char(10)) + CHAR(13) + CHAR(10) + 
	', @FollowFridayList = ''' + STRING_AGG(TwitterAccount.TwitterHandle ,',') + '''' +CHAR(13) + CHAR(10) + CHAR(13) + CHAR(10) + 
	
	'EXEC ' + DB_NAME() + '.Tweets.DailyTweetPicture$Insert @TweetDate = ''' + CAST(@TweetDate AS varchar(30)) + 
	''', @TweetTypeTag = ''{FollowFriday}'', @TweetNumber = ' + CAST(#holdAccountNames.position AS varchar(10)) + ',@PictureNumber =   ;' + 
		 CHAR(13) + CHAR(10) + '--COMMIT' +CHAR(13) + CHAR(10)  +CHAR(13) + CHAR(10)  + '-------------------'  + CHAR(13) + CHAR(10)  
 
  FROM   #holdAccountNames
		    JOIN #holdMessages
				ON #holdMessages.position = #holdAccountNames.Position
			JOIN Assets.TwitterAccount
				ON TwitterAccount.TwitterAccountId = #holdAccountNames.TwitterAccountId
  GROUP BY #holdMessages.messageText,#holdAccountNames.Position, #holdMessages.followFridayPrefixId
  ORDER BY #holdAccountNames.position
  
  EXEC [Tweets].[DailyTweetPicture$GetRandomTag] @TweetTypeTag = '{FollowFriday}', @TweetDate = @TweetDate,@TweetNumber = 10
	

SELECT 'SELECT DailyTweet.TweetText
FROM   ' + DB_NAME() + '.Tweets.DailyTweet
WHERE  TweetDate = ''' + CAST(@TweetDate AS nvarchar(20)) + ''''
	
GO
