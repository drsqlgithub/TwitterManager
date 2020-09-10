SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE    FUNCTION [Assets].[DailyTweet$GetRandomNormal](@DateValue date = NULL)
RETURNS @output table (ThemeParkAssetId int NOT NULL)
AS
 BEGIN
	IF @DateValue IS NULL SET @DateValue = SYSDATETIME()
	DECLARE @maxValue int = (SELECT MAX(BaseTicketsEnd) FROM Assets.ThemeParkAsset$RandomBaseNormal(@DateValue) AS RandomBase)
    DECLARE @random int = Tools.[RandomNumber$get](1,@maxValue);	

	INSERT INTO @output(ThemeParkAssetId)
	SELECT RandomBase.ThemeParkAssetId
	FROM   Assets.ThemeParkAsset$RandomBaseNormal(@DateValue) AS RandomBase
	WHERE  @random BETWEEN RandomBase.BaseTicketsStart AND RandomBase.BaseTicketsEnd

	RETURN
 END;
GO
