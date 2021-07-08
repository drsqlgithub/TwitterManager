SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE      FUNCTION [Assets].[DailyTweet$GetRandom](@DateValue date = NULL, @SpecialTagId int, @AssetRepeatToleranceDayCount int)
RETURNS @output table (ThemeParkAssetId int NOT NULL)
AS
 BEGIN
	IF @DateValue IS NULL SET @DateValue = SYSDATETIME()
	DECLARE @maxValue int = (SELECT MAX(BaseTicketsEnd) FROM Assets.ThemeParkAsset$RandomBase2(@DateValue,@SpecialTagId,@AssetRepeatToleranceDayCount) AS RandomBase)
    DECLARE @random int = Tools.[RandomNumber$get](1,@maxValue);	

	INSERT INTO @output(ThemeParkAssetId)
	SELECT RandomBase.ThemeParkAssetId
	FROM   Assets.ThemeParkAsset$RandomBase2(@DateValue,@SpecialTagId,@AssetRepeatToleranceDayCount) AS RandomBase
	WHERE  @random BETWEEN RandomBase.BaseTicketsStart AND RandomBase.BaseTicketsEnd

	RETURN
 END;
GO
