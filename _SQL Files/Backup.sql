BACKUP DATABASE [TwitterManager] TO  DISK = N'E:\Dropbox\z_Backups\Twittermanager2.bck' WITH NOFORMAT, INIT,  NAME = N'TwitterManager-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
GO
declare @backupSetId as int
select @backupSetId = position from msdb..backupset where database_name=N'TwitterManager' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'TwitterManager' )
if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''TwitterManager'' not found.', 16, 1) end
RESTORE VERIFYONLY FROM  DISK = N'E:\Dropbox\z_Backups\Twittermanager1.bck' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
GO
