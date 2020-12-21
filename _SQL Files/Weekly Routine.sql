USE TwitterManager
GO
EXIT
--Sunday

--SpaceshipEarthSunday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Sunday',1,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{SpaceshipEarthSunday}', @TweetDate=@TweetDate;

--Normal (Optional)
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Sunday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

--Holiday
DECLARE @HolidayTag nvarchar(100) = '{Christmas}'
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Sunday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;


--Monday
--MonorailMonday
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{MonorailMonday}', @TweetDate=@TweetDate;


--Normal 
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

DECLARE @HolidayTag nvarchar(100) = '{Christmas}'
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;

--Tuesday
--TrashcanTuesday

DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{TrashcanTuesday}', @TweetDate=@TweetDate;

--Normal 
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

--Holiday
DECLARE @HolidayTag nvarchar(100) = '{Christmas}'
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;


--Wednesday
--TBD: WindowWednesday

--Normal 
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Wednesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;


--Holiday
DECLARE @HolidayTag nvarchar(100) = '{Christmas}'
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Wednesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;


--Thursday
--ThrowbackThursday
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{ThrowbackThursday}', @TweetDate=@TweetDate,@FilesampleCount = 4;

--Normal 
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

DECLARE @HolidayTag nvarchar(100) = '{Christmas}'
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1, @TweetNumber = 1;


--Friday
--FollowFriday
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Friday',0,DEFAULT),
		@NumberOfTweets int = 10;
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateFollowFriday]  @TweetDate=@TweetDate, @NumberOfTweets=@NumberOfTweets;

DECLARE @HolidayTag nvarchar(100) = '{Christmas}'
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Friday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1, @TweetNumber = 1;

--Saturday
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Saturday',0,DEFAULT)
EXEC [Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;


DECLARE @HolidayTag nvarchar(100) = '{Christmas}'
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Saturday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;
------------------------------------------------
--Getting a specific item
DECLARE @TweetDate date = '2020-10-30'
EXEC [Tweets].[DailyTweet$GenerateSpecific] @ThemeParkAreaHashTag = 'MagicKingdom', @ThemeParkAssetHashTag = 'BooToYou', @TweetDate = @TweetDate, @FileSampleCount = 10