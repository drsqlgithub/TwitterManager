SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE   FUNCTION [Tools].[Date$GetNthDay]
(
	@Dayname varchar(20) = NULL,
	@NumberOfWeeks int = 0,
	@DateValue date = NULL
)
RETURNS date
AS
BEGIN
   SET @dateValue = COALESCE(@DateValue,SYSDATETIME())
   DECLARE @output date
   SELECT @output = DATEADD(WEEK,@NumberOfWeeks,Calendar.DateValue)
   FROM   Tools.Calendar
   WHERE  Calendar.DateValue >= @dateValue
     AND  DayName = @DayName
   ORDER BY Calendar.DateValue DESC

	RETURN @output
 END;
GO
