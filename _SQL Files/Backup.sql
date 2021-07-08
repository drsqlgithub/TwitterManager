--:setvar version 1

--BACKUP DATABASE [TwitterManagerDollywood] TO  DISK = N'E:\Dropbox\z_Backups\TwitterManagerDollywood$(version).bck' WITH NOFORMAT, INIT,  NAME = N'TwitterManagerDollywood-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
--GO
--declare @backupSetId as int
--select @backupSetId = position from msdb..backupset where database_name=N'TwitterManagerDollywood' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'TwitterManagerDollywood' )
--if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''TwitterManagerDollywood'' not found.', 16, 1) end
--RESTORE VERIFYONLY FROM  DISK = N'E:\Dropbox\z_Backups\TwitterManagerDollywood$(version).bck' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
--GO



----disney too
--BACKUP DATABASE [TwitterManager] TO  DISK = N'E:\Dropbox\z_Backups\Twittermanager$(version).bck' WITH NOFORMAT, INIT,  NAME = N'TwitterManager-Full Database Backup', SKIP, NOREWIND, NOUNLOAD,  STATS = 10, CHECKSUM
--GO
--declare @backupSetId as int
--select @backupSetId = position from msdb..backupset where database_name=N'TwitterManager' and backup_set_id=(select max(backup_set_id) from msdb..backupset where database_name=N'TwitterManager' )
--if @backupSetId is null begin raiserror(N'Verify failed. Backup information for database ''TwitterManager'' not found.', 16, 1) end
--RESTORE VERIFYONLY FROM  DISK = N'E:\Dropbox\z_Backups\Twittermanager$(version).bck' WITH  FILE = @backupSetId,  NOUNLOAD,  NOREWIND
--GO

sp_BackupServer