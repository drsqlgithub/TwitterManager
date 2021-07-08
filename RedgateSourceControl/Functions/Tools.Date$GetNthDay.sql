SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   FUNCTION [Tools].[Date$GetNthDay]
(
	@DayName varchar(20), --Spelled out the name of the day of the week
	@NumberOfWeeks int = 0, --positive or negative offset from the current week
	@DateValue date = NULL --the day to start the calculation
)
---------------------------------------------
-- Example: Tuesday, 0, 2/17/2021 (Wednesday) Return: 2/23 
-- Example: Tuesday, 0, 2/17/2021 (Wednesday) Return: 03/02
-- Example: Wednesday, 0, 2/17/2021 (Wednesday) Return: 02/17
-- Example: Tuesday, -3, 2/17/2021 (Wednesday) Return: 1/27
/*
SELECT [Tools].[Date$GetNthDay] ('Tuesday', 0, '2021-02-17')
SELECT [Tools].[Date$GetNthDay] ('Tuesday', 1, '2021-02-17')
SELECT [Tools].[Date$GetNthDay] ('Wednesday', 0, '2021-02-17')
SELECT [Tools].[Date$GetNthDay] ('Wednesday', -3, '2021-02-17')
--a couple of fun tests
SELECT [Tools].[Date$GetNthDay] ('Wednesday', -1000, '2021-02-17')
SELECT [Tools].[Date$GetNthDay] ('Wednesday', 100000, '2021-02-17')
*/
---------------------------------------------

RETURNS date
AS
 BEGIN 
	--if the date parameter is NULL, use current date
	SET @dateValue = COALESCE(@DateValue,SYSDATETIME());

	--this is a stand in for a calendar table to make it portable and not subject
	--to any date settings
	DECLARE @DaysOfWeek table (DayNumber int NOT NULL, DayName varchar(20) NOT NULL);

	--load 14 days to make the math of days between days easy
	INSERT INTO @DaysOfWeek(DayNumber, DayName)
	VALUES(1,'Sunday'),(2,'Monday'),(3,'Tuesday'),(4,'Wednesday'),
		  (5,'Thursday'),(6,'Friday'),(7,'Saturday'),
		  (8,'Sunday'),(9,'Monday'),(10,'Tuesday'),(11,'Wednesday'),
		  (12,'Thursday'),(13,'Friday'),(14,'Saturday');


	--get the day number of the date that was passed in on the DateValue parameter
	DECLARE @CurrentDayNumber int = (SELECT MIN(DayNumber) 
									 FROM @DaysOfWeek 
									 WHERE DayName = DATENAME(weekday, @DateValue));  

	--get the next day number in the table to get the number of days to add
	DECLARE @NextDayNumber int = (SELECT MIN(DayNumber) 
								  FROM @DaysOfWeek 
								  WHERE DayName = @DayName 
								    AND DayNumber >= @CurrentDayNumber); 

	--add the number of weeks to the date you calculate to be the upcoming day that matched your parameters
	RETURN (DATEADD(WEEK,@NumberOfWeeks,DATEADD(DAY, @NextDayNumber - @CurrentDayNumber, @DateValue)));
 END
GO
