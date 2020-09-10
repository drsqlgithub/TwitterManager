SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE   FUNCTION [Tools].[Number$TranslateToWords]
(
	@NumberToTranslate numeric(15,0)
)
RETURNS varchar(100)
AS
BEGIN

	DECLARE @NumberToTranslateText varchar(15), @output nvarchar(100)
	SET @NumberToTranslateText = RIGHT(REPLICATE('0',15)  + CAST(@numberToTranslate AS nvarchar(15)),15)

	RETURN(
	SELECT CONCAT(
	Tools.Number$Translate3DigitsToWords(SUBSTRING(@NumberToTranslateText,1,3)) + '-Trillion, '
	,
	 Tools.Number$Translate3DigitsToWords(SUBSTRING(@NumberToTranslateText,4,3)) + '-Billion, '
	,
	Tools.Number$Translate3DigitsToWords(SUBSTRING(@NumberToTranslateText,7,3)) + '-Million, '
	,
	 Tools.Number$Translate3DigitsToWords(SUBSTRING(@NumberToTranslateText,10,3)) + '-Thousand, '
	,	
	CASE WHEN @NumberToTranslate > 100 AND CAST(SUBSTRING(@NumberToTranslateText,13,3) AS int) < 100 THEN ' and ' END
	,
	Tools.Number$Translate3DigitsToWords(SUBSTRING(@NumberToTranslateText,13,3)))
	)
END

GO
