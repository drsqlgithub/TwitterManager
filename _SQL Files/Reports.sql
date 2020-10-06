

--as latest tweets
DECLARE @TopNumber int = 14;
SELECT TOP (@TopNumber) TweetDate, Tag, dayname, MonthName, DailyTweet.TweetText, ThemeParkArea.ThemeParkAreaHashtag, ThemeParkAsset.ThemeParkAssetHashtag, 
       CASE WHEN DailyTweet.TweetDate = CAST(SYSDATETIME() AS date) THEN 'Today' ELSE '' END
FROM   Tweets.DailyTweet
		 JOIN Assets.Tag
			ON Tag.TagId = DailyTweet.TweetTypeTagId
		 JOIN Tools.Calendar
			ON Calendar.DateValue = DailyTweet.TweetDate
		 LEFT JOIN Tweets.DailyTweetNormal
			JOIN Assets.ThemeParkAsset
				JOIN Assets.ThemeParkArea	
					ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
				ON ThemeParkAsset.ThemeParkAssetId = DailyTweetNormal.ThemeParkAssetId
			ON DailyTweetNormal.DailyTweetId = DailyTweet.DailyTweetId
ORDER BY tweetDate DESC

SELECT ThemeParkArea.ThemeParkAreaHashtag, ThemeParkAsset.ThemeParkAssetHashtag, MAX(DailyTweet.TweetDate) AS LastUseDate, 
	  COUNT(DailyTweetNormal.ThemeParkAssetId) AS UsedCount
FROM   Assets.ThemeParkAsset
		 JOIN Assets.ThemeParkArea
			ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
		 LEFT OUTER JOIN Tweets.DailyTweetNormal
			JOIN Tweets.DailyTweet
				ON DailyTweet.DailyTweetId = DailyTweetNormal.DailyTweetId
			ON DailyTweetNormal.ThemeParkAssetId = ThemeParkAsset.ThemeParkAssetId
GROUP BY ThemeParkArea.ThemeParkAreaHashtag, ThemeParkAsset.ThemeParkAssetHashtag
ORDER BY LastUseDate DESC

SELECT ThemeParkArea.ThemeParkAreaHashtag, ThemeParkAsset.ThemeParkAssetHashtag,  Tag.Tag, COUNT(*) AS UsedCount
FROM   Tweets.DailyTweetPicture
		 JOIN Tweets.DailyTweet
			ON DailyTweet.DailyTweetId = DailyTweetPicture.DailyTweetId
		 JOIN Assets.Tag
			ON Tag.TagId = DailyTweet.TweetTypeTagId
		 JOIN Assets.Picture
			ON Picture.PictureId = DailyTweetPicture.PictureId
		 JOIN Assets.ThemeParkAsset
			ON ThemeParkAsset.ThemeParkAssetId = Picture.ThemeParkAssetId
		 JOIN Assets.ThemeParkArea
			ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
GROUP BY ThemeParkArea.ThemeParkAreaHashtag, ThemeParkAsset.ThemeParkAssetHashtag, Tag.Tag
ORDER BY UsedCount DESC

--Lost picture numbers
SELECT PictureNumber
FROM   Assets.Picture
		 JOIN Tweets.DailyTweetPicture
			ON DailyTweetPicture.PictureId = Picture.PictureId
WHERE  NOT EXISTS (	SELECT *
					FROM   FileAssets.PictureDecoded
					WHERE PictureDecoded.PictureNumber = Picture.PictureNumber)
GO


SELECT ThemeParkArea.ThemeParkAreaHashtag, ThemeParkAsset.ThemeParkAssetHashtag, SUM(CASE WHEN pictureId IS NULL THEN 0 ELSE 1 END) AS PictureCount
FROM   Assets.ThemeParkAsset
		JOIN Assets.ThemeParkArea
			ON ThemeParkArea.ThemeParkAreaId = ThemeParkAsset.ThemeParkAreaId
		LEFT JOIN Assets.Picture
		ON ThemeParkAsset.ThemeParkAssetId = Picture.ThemeParkAssetId 
GROUP BY ThemeParkArea.ThemeParkAreaHashtag, ThemeParkAsset.ThemeParkAssetHashtag
HAVING SUM(CASE WHEN pictureId IS NULL THEN 0 ELSE 1 END) <6
ORDER BY 1,2, PictureCount ASC

