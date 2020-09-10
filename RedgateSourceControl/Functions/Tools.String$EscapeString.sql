SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

--TODO: Add security to this schema after you create.

CREATE    FUNCTION [Tools].[String$EscapeString]
(
	@inputString nvarchar(4000), --would work on varchar(max) too
	@character nchar(1) = N'''', --if you needed that
	@surroundOutputFlag bit = 1
) 
RETURNS nvarchar(4000)
AS
  BEGIN
	RETURN (CASE WHEN @surroundOutputFlag = 1 THEN @character ELSE '' END
	       +REPLACE(@inputString,'''','''''')
	       +CASE WHEN @surroundOutputFlag = 1 THEN @character ELSE '' END)
  END;
GO
