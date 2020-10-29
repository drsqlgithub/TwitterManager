USE TwitterManager
GO
EXIT
--Sunday

--SpaceshipEarthSunday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Sunday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{SpaceshipEarthSunday}', @TweetDate=@TweetDate;

--Normal (Optional)
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Sunday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

--Holiday
DECLARE @HolidayTag nvarchar(100) = '{Halloween}'
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Sunday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;



--Monday
--MonorailMonday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{MonorailMonday}', @TweetDate=@TweetDate;

--Normal 
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

DECLARE @HolidayTag nvarchar(100) = '{Halloween}'
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;

--Tuesday
--TrashcanTuesday

DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{TrashcanTuesday}', @TweetDate=@TweetDate;

--Normal 
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

--Holiday
DECLARE @HolidayTag nvarchar(100) = '{Halloween}'
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;


--Wednesday
--TBD: WindowWednesday

--Normal 
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Wednesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;


--Holiday
DECLARE @HolidayTag nvarchar(100) = '{Halloween}'
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Wednesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;


--Thursday
--ThrowbackThursday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = '{ThrowbackThursday}', @TweetDate=@TweetDate,@FilesampleCount = 4;

--Normal 
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;

DECLARE @HolidayTag nvarchar(100) = '{Halloween}'
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;


--Friday
--use me: PIC0022695
--FollowFriday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Friday',0,DEFAULT),
		@NumberOfTweets int = 2;
EXEC [Tweets].[DailyTweet$GenerateFollowFriday]  @TweetDate=@TweetDate, @NumberOfTweets=@NumberOfTweets;

--Saturday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Saturday',0,DEFAULT)
EXEC [Tweets].[DailyTweet$GenerateNormal]  @TweetDate=@TweetDate;


DECLARE @HolidayTag nvarchar(100) = '{Halloween}'
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Saturday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecial] @TweetTypeTag = @HolidayTag, @TweetDate=@TweetDate, @IncludeHolidayPicturesFlag = 1;
------------------------------------------------
--Getting a specific item
DECLARE @TweetDate date = '2020-10-26'
EXEC [Tweets].[DailyTweet$GenerateSpecific] @ThemeParkAreaHashTag = 'HollywoodStudios', @ThemeParkAssetHashTag = 'TwilightZoneTowerOfTerror', @TweetDate = @TweetDate, @FileSampleCount = 10