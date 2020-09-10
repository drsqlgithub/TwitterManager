SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE   FUNCTION [Tools].[Number$Translate3DigitsToWords]
(
	@NumberToTranslate numeric(3,0)
)
RETURNS varchar(100)
AS
BEGIN
	IF @NumberToTranslate = 0
		RETURN null

	DECLARE @NumberToTranslateText varchar(3), @output nvarchar(500)
	SET @NumberToTranslateText = RIGHT(REPLICATE('0',3) + CAST(@numberToTranslate AS nvarchar(3)),3)

	DECLARE @FirstDigit table (Value char(1), Word varchar(10))
	INSERT INTO @FirstDigit(Value, Word)
	values('0',''),('1','One'),
	('2','Two'),('3','Three'),('4','Four'),('5','Five'),
	('6','Six'),('7','Seven'),('8','Eight'),('9','Nine')

	DECLARE @Teens table (Value char(2), Word varchar(10))
	INSERT INTO @Teens(Value, Word)
	VALUES ('10','Ten'),('11','Eleven'),('12','Twelve'),('13','Thirteen'),
	('14','Forteen'),('15','Fifteen'),('16','Sixteen'),
	('17','Seventeen'),('18','Eighteen'),('19','Nineteen')


	DECLARE @Tens table (Value char(1), Word varchar(10))
	INSERT INTO @Tens(Value, Word)
	VALUES('0',''),('2','Twenty'),('3','Thirty'),
	('4','Forty'),('5','Fifty'),('6','Sixty'),
	('7','Seventy'),('8','Eighty'),('9','Ninety')

	SELECT @Output = Word
	FROM   @Teens
	WHERE  Value = SUBSTRING(@NumberToTranslateText,2,2)

	IF @output IS NULL
		SELECT @output = word
		FROM @FirstDigit
		WHERE  Value = SUBSTRING(@NumberToTranslateText,3,1) 

	SELECT @output = CONCAT(Word, IIF(@output = '' ,'','-'), + @output )
	FROM  @Tens
	WHERE  Value = SUBSTRING(@NumberToTranslateText,2,1)
	  AND  SUBSTRING(@NumberToTranslateText,2,1) <>  0

	SELECT @output = CONCAT(Word, '-Hundred ', IIF(@output = '','','and '), @output)
	FROM  @FirstDigit
	WHERE  Value = SUBSTRING(@NumberToTranslateText,1,1)
	  AND  SUBSTRING(@NumberToTranslateText,1,1) <> '0'

	RETURN TRIM(@output)
 END
GO
