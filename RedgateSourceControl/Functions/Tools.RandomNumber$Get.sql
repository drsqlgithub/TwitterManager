SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE   FUNCTION [Tools].[RandomNumber$Get]
(
@MinValue int = 0,
@MaxValue int = 100
)
RETURNS int 
AS
BEGIN
	--FLOOR algorithm from here: https://www.techonthenet.com/sql_server/functions/rand.php
	RETURN(SELECT FLOOR(RandomNumber*(@MaxValue-@MinValue+1))+@MinValue
		   FROM Tools.RandomNumber)
END
GO
