USE TwitterManager
EXIT
--Sunday

--SpaceshipEarthSunday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Sunday',1,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{SpaceshipEarthSunday}', @TweetDate=@TweetDate;

--Normal (Optional)
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Sunday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;



--Monday
--MonorailMonday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{MonorailMonday}', @TweetDate=@TweetDate;

--Normal 
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

--Tuesday
--TrashcanTuesday

DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{TrashcanTuesday}', @TweetDate=@TweetDate;

--Normal 
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;


--Wednesday
--TBD: WindowWednesday

--Normal 
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Wednesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

--Thursday
--ThrowbackThursday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{ThrowbackThursday}', @TweetDate=@TweetDate,@FilesampleCount = 4;

--Normal 
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;


--Friday

--FollowFriday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Friday',0,DEFAULT),
		@NumberOfTweets int = 2;
EXEC [Tweets].[DailyTweet$GenerateFollowFriday]  @TweetDate=@TweetDate, @NumberOfTweets=@NumberOfTweets;

--Saturday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Saturday',0,DEFAULT)
EXEC [Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;



------------------------------------------------
--Getting a specific item
DECLARE @TweetDate date = '2020-10-05'
EXEC [Tweets].[DailyTweet$GenerateSpecific] @ThemeParkAreaHashTag = 'MagicKingdom', @ThemeParkAssetHashTag = 'BuzzLightyearsSpaceRangerSpin', @TweetDate = @TweetDate