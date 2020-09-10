SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE    FUNCTION [Tools].[String$SplitPart]
(
    @inputValue nvarchar(4000),
    @delimiter  nchar(1) = ',',  
    @position   int = 1
)
------------------------------------------------------------------------
-- Helps to normalize a delimited string by fetching one value from the
-- list. (note, can’t use STRING_SPLIT because return order not guaranteed)
--
-- 2020 Louis Davidson – drsql@hotmail.com – drsql.org 
------------------------------------------------------------------------
RETURNS nvarchar(4000)
WITH SCHEMABINDING, EXECUTE AS CALLER AS
BEGIN
       DECLARE @start int, @end int
       --add commas to end and start
       SET @inputValue = @delimiter + @inputValue + @delimiter;

       WITH BaseRows AS (
            SELECT Number.I, 
                   ROW_NUMBER() OVER (ORDER BY Number.I) AS StartPosition, 
                   ROW_NUMBER() OVER (ORDER BY Number.I) - 1 AS EndPosition
            FROM   Tools.Number
            WHERE  Number.I <= LEN(@inputValue)
             AND  SUBSTRING(@inputValue,Number.I,1) = @delimiter
       )                   --+1 to deal with commas
       SELECT @start = (SELECT BaseRows.I + 1 FROM BaseRows 
                        WHERE BaseRows.StartPosition = @Position),
              @end = (  SELECT BaseRows.I FROM BaseRows 
                        WHERE BaseRows.EndPosition = @Position)

       RETURN TRIM(SUBSTRING(@inputValue,@start,@end - @start))
 END;
GO
