--todo  Happily ever after pics to follow friday

USE TwitterManager
GO
EXIT


----------------------

--Monday

DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{MonorailMonday}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 0;

--Normal 
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate]  @TweetDate=@TweetDate;

----------------------
--Tuesday
--TrashcanTuesday

DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{TrashcanTuesday}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 0;

--Normal 
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate]  @TweetDate=@TweetDate, @FreshPicturesOnlyFlag = 0;

----------------------

--Wednesday
--TBD: WindowWednesday

DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Wednesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateWindowWednesday2] @TweetDate = @TweetDate, @FileSampleCount = 10

--Normal 
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Wednesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate]  @TweetDate=@TweetDate;

----------------------

--Thursday
--ThrowbackThursday
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{ThrowbackThursday}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 20;
GO

--Normal 
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate]  @TweetDate=@TweetDate;
GO
----------------------

--Friday
--FollowFriday
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Friday',0,DEFAULT),
		@NumberOfTweets int = 2;
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateFollowFriday]  @TweetDate=@TweetDate, @NumberOfTweets=@NumberOfTweets;
GO

--Normal 
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Friday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate]  @TweetDate=@TweetDate;
GO

----------------------

--Saturday
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Saturday',0,DEFAULT)
EXEC TwitterManager.[Tweets].[DailyTweet$Generate]  @TweetDate=@TweetDate;
GO

----------------------


--Sunday

--SpaceshipEarthSunday
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Sunday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{SpaceshipEarthSunday}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 0;

--Normal (Optional)
DECLARE @TweetDate date = TwitterManager.Tools.[Date$GetNthDay]('Sunday',1,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @TweetDate=@TweetDate

------------------------------------------------
EXIT
GO



--Holiday Schedule:

--Holiday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Sunday',1,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{Christmas}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 15;

--Holiday
DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Monday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{Christmas}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 15;

DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Tuesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{Christmas}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 15;

DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Wednesday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{Christmas}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 15;

DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Thursday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{Christmas}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 15;

DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Friday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{Christmas}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 15;

DECLARE @TweetDate date = Tools.[Date$GetNthDay]('Saturday',0,DEFAULT);
EXEC TwitterManager.[Tweets].[DailyTweet$Generate] @SpecialTag = '{Christmas}', @TweetDate=@TweetDate, @AssetRepeatToleranceDayCount = 15;


---------------------------------------------


--Getting a specific item
DECLARE @TweetDate date = '2020-03-19'
EXEC TwitterManager.[Tweets].[DailyTweet$GenerateSpecific] @ThemeParkAreaHashTag = 'AnimalKingdom', @ThemeParkAssetHashTag = 'ExpeditionEverest', @TweetDate = @TweetDate, @FileSampleCount = 10
GO


DECLARE @TweetDate date = SYSDATETIME()

SELECT DailyTweet.TweetDate, DATENAME(DW,TweetDate),DailyTweet.TweetText, Tag
FROM   TwitterManager.Tweets.DailyTweet
		JOIN TwitterManager.Assets.Tag
			ON Tag.TagId = DailyTweet.TweetTypeTagId
WHERE  DailyTweet.TweetDate >= @TweetDate
ORDER BY DailyTweet.TweetDate 

EXEC FileAssets.DailyTweetMedia$CopyAndClean