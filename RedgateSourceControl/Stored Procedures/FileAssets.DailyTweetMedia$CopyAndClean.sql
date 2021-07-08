SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE   PROCEDURE [FileAssets].[DailyTweetMedia$CopyAndClean]
AS
SET NOCOUNT ON;
RAISERROR ('Starting copy processing', 10,1) WITH NOWAIT;

DECLARE @Path nvarchar(2000) = CONCAT('\\', @@SERVERNAME , '\',
											(  Select directory_name
												FROM sys.database_filestream_options
												WHERE DB_NAME(database_id)= DB_NAME()), '\',
											(  SELECT PathValue
												FROM Settings.PathValue
												WHERE PathHandle = 'DailyTweetMediaSourceFolder'
												) + '\*.*')
IF @Path IS NULL
 THROW 50000,'Invalid path configuration',1;

DECLARE @command nvarchar(2000), @cmdshellresult int
SET @command = 'xcopy "' + @path + '" /S "' + (  SELECT PathValue
												FROM Settings.PathValue
												WHERE PathHandle = 'DailyTweetMediaDestFolder'
												) + '" /Y '
--SELECT @command

DECLARE @cmdshelloutput TABLE (Value nvarchar(1000))


--Copy all files from directory
INSERT INTO @cmdshelloutput (value)
EXEC @cmdshellresult = xp_cmdshell @command
IF @cmdshellresult <> 0
 BEGIN
	SELECT * FROM @cmdshelloutput;
	THROW 50000,'Error copying files',1;
 END

RAISERROR ('Files Copied to target, starting cleanup', 10,1) WITH NOWAIT;

--delete directories that are not from this month or the previous month
DECLARE @thisperiod char(7) = CONCAT(YEAR(SYSDATETIME()), '_',RIGHT( CONCAT('0',MONTH(SYSDATETIME())),2))
DECLARE @prevperiod char(7) = CONCAT(YEAR(DATEADD(MONTH,-1,SYSDATETIME())), '_',RIGHT( CONCAT('0',MONTH(DATEADD(MONTH,-1,SYSDATETIME()))),2))
--SELECT @thisperiod,@prevperiod

DELETE FileAssets.DailyTweetMedia
FROM   FileAssets.DailyTweetMedia
		JOIN FileAssets.DailyTweetMedia AS Folder
			ON folder.path_locator = FileAssets.DailyTweetMedia.parent_path_locator
WHERE folder.name NOT IN (@prevperiod,@thisperiod)

DELETE Folder
FROM   FileAssets.DailyTweetMedia AS folder
WHERE folder.name NOT IN (@prevperiod,@thisperiod)
 AND folder.parent_path_locator IS NULL

RAISERROR ('Done', 10,1) WITH NOWAIT;
GO
