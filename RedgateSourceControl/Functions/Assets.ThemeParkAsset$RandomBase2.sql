SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE    FUNCTION [Assets].[ThemeParkAsset$RandomBase2](@DateValue date, @SpecialTagId int, @AssetRepeatToleranceDayCount int)
RETURNS table AS 
RETURN(
SELECT Value.ThemeParkAssetId,
	   Value.StartingPopularityFactorBase + LAG(Value.RunningTotal,1,0) OVER (ORDER BY Bucket) AS BaseTicketsStart, 
	   Value.EndingPopularityFactorBase + LAG(Value.RunningTotal,1,0) OVER (ORDER BY Bucket) -1 AS BaseTicketsEnd
FROM (
	SELECT *, SUM(ItemsAdded.EndingPopularityFactorBase) OVER(ORDER BY Bucket) AS RunningTotal
	FROM  ( SELECT ThemeParkAssetId, 
				   0 AS StartingPopularityFactorBase,  
				   PopularityFactor AS EndingPopularityFactorBase,
				   ROW_NUMBER() OVER (ORDER BY ThemeParkAsset.ThemeParkAssetId) AS Bucket
			FROM  [Assets].[ThemeParkAssetExpanded] AS ThemeParkAsset
			WHERE EXISTS (SELECT *
						  FROM  [Assets].[NonSpecialThemeParkAssetPictureCount]
						  WHERE ThemeParkAsset.ThemeParkAssetId = [NonSpecialThemeParkAssetPictureCount].ThemeParkAssetId)
			  AND (ThemeParkAsset.SpecialTagId = @SpecialTagId OR (@SpecialTagId IS NULL AND SpecialTagId IS NULL)
						  )) AS ItemsAdded
			  
	WHERE NOT EXISTS (SELECT *
					  FROM   Tweets.DailyTweet	
								JOIN Tweets.DailyTweetNormal
									ON DailyTweetNormal.DailyTweetId = DailyTweet.DailyTweetId
					  WHERE  DailyTweet.TweetDate > DATEADD(DAY,-@AssetRepeatToleranceDayCount,@DateValue)
					    AND  DailyTweetNormal.ThemeParkAssetId = ItemsAdded.ThemeParkAssetId) ) AS Value
)
GO
