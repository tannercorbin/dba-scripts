
--Move Log File to a different drive.
USE [master]
GO

:setvar targetdb "TMW"
:setvar logicalfilename "TMWLog"
:setvar physicalfilename "L:\SQL\DATA\LDF\TS2005First_log.ldf"

--1. Alter the file location.
	ALTER DATABASE $(targetdb)
	MODIFY FILE (name = '$(logicalfilename)', filename = N'$(physicalfilename)')
	GO

--2. Take the database offline.
	ALTER DATABASE $(targetdb) SET OFFLINE WITH ROLLBACK IMMEDIATE;
	GO

--3. Move the file
	--Copy V:\RDBMS\secondaryData\ARC_DWH_FPA_DEV_148.ldf 
	--to L:\RDBMS\transactionalData\ARC_DWH_FPA_PROD\ARC_DWH_FPA_DEV_148.ldf

--4.Put the database back online.
	ALTER DATABASE $(targetdb) SET ONLINE;
	GO

--5.Confirm change
	SELECT * ,UPPER(physical_name)
	FROM sys.master_files
	WHERE database_id = db_id('$(targetdb)') and file_id = 2


	