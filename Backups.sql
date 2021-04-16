DECLARE @dbname sysname
SET @dbname = 'ICG_RPM' --set this to be whatever dbname you want
SELECT bup.user_name AS [User],
 bup.database_name AS [Database],
 bup.server_name AS [Server],
 bup.backup_start_date AS [Backup Started],
 bup.backup_finish_date AS [Backup Finished],
CAST(((bup.compressed_backup_size)* 0.00000095367432) AS DECIMAL(15,2)) as BackupSizeInMB
, Cast(DAtepart(hour,(bup.backup_finish_date - bup.backup_start_date)) as varchar) + ' hour(s) ' 
+ Cast(DAtepart(mi,(bup.backup_finish_date - bup.backup_start_date)) as varchar) + ' minute(s) '
+ Cast(DAtepart(ss,(bup.backup_finish_date - bup.backup_start_date)) as varchar) + ' second(s) '
AS [Total Time]
FROM msdb.dbo.backupset bup
WHERE bup.backup_set_id IN
  (SELECT backup_set_id FROM msdb.dbo.backupset
  WHERE database_name = ISNULL(@dbname, database_name) --if no dbname, then return all
  AND type = 'D') --only interested in the time of last full backup)
  --GROUP BY database_name) 
/* COMMENT THE NEXT LINE IF YOU WANT ALL BACKUP HISTORY */
AND bup.database_name IN (SELECT name FROM master.dbo.sysdatabases)
ORDER BY bup.database_name


SELECT  CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server
       ,msdb.dbo.backupset.database_name
       ,msdb.dbo.backupset.backup_start_date
       ,msdb.dbo.backupset.backup_finish_date
       ,msdb.dbo.backupset.expiration_date
       ,CASE msdb..backupset.type
          WHEN 'D' THEN 'Database'
          WHEN 'L' THEN 'Log'
        END AS backup_type
       ,msdb.dbo.backupset.backup_size
       ,msdb.dbo.backupmediafamily.logical_device_name
       ,msdb.dbo.backupmediafamily.physical_device_name
       ,msdb.dbo.backupset.name AS backupset_name
       ,msdb.dbo.backupset.description
FROM    msdb.dbo.backupmediafamily
INNER JOIN msdb.dbo.backupset
        ON msdb.dbo.backupmediafamily.media_set_id = msdb.dbo.backupset.media_set_id 
--WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7) 
ORDER BY msdb.dbo.backupset.database_name
       ,msdb.dbo.backupset.backup_finish_date; 


SELECT  CONVERT(CHAR(100), SERVERPROPERTY('Servername')) AS Server
       ,bs.database_name
       ,bs.backup_start_date
       ,bs.backup_finish_date
       ,bs.expiration_date
       ,CASE bs.[type]
          WHEN 'D' THEN 'Database'
          WHEN 'L' THEN 'Log'
        END AS backup_type
       ,bs.backup_size
       ,bmf.logical_device_name
       ,bmf.physical_device_name
       ,bs.name AS backupset_name
       ,bs.[description]
FROM    msdb.dbo.backupmediafamily bmf
INNER JOIN msdb.dbo.backupset bs
        ON bmf.media_set_id = bs.media_set_id 
--WHERE (CONVERT(datetime, msdb.dbo.backupset.backup_start_date, 102) >= GETDATE() - 7) 
ORDER BY bs.database_name
       ,bs.backup_finish_date; 


