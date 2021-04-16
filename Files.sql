

--View recovery model info for each database on connection
SELECT recovery_model_desc,*
FROM sys.databases


--Review file sizes and free-space
SELECT f.name AS [File Name] 
, f.physical_name AS [Physical Name]
, CAST((f.size/128.0) AS decimal(10,2)) AS [Total Size in MB]
, CAST(f.size/128.0 - CAST(FILEPROPERTY(f.name, 'SpaceUsed') AS int)/128.0 AS decimal(10,2)) AS [Available Space In MB]
, CAST(CAST(FILEPROPERTY(f.name, 'SpaceUsed') AS int)/128.0 AS decimal(10,2)) AS [Used Space In MB]
, fg.name AS [Filegroup Name]
, d.name as [Database Name]
, [file_id]
FROM sys.database_files AS f 
LEFT JOIN sys.data_spaces AS fg 
	ON f.data_space_id = fg.data_space_id 
LEFT JOIN sys.databases d
	ON d.database_id = db_id()
--WHERE f.physical_name like 'X:%'
ORDER BY 4 DESC OPTION (RECOMPILE);

SELECT log_reuse_wait,log_reuse_wait_desc,*
FROM sys.databases

DBCC SQLPERF(LOGSPACE);

--Shrink file to specified size.
USE [ARC_DWH_MA_PROD]
GO
DBCC SHRINKFILE (N'ARC_DWH_MA_FCT_SALES_DSP_F3' , 4096)
GO





--I used this to increase the size of database files.
USE [master]
GO
ALTER DATABASE [internalStatistics] MODIFY FILE ( NAME = N'iStatistics01', SIZE = 2097152KB )
GO
ALTER DATABASE [internalStatistics] MODIFY FILE ( NAME = N'iStatistics02', SIZE = 2097152KB )
GO
ALTER DATABASE [internalStatistics] MODIFY FILE ( NAME = N'iStatistics03', SIZE = 2097152KB )
GO
ALTER DATABASE [internalStatistics] MODIFY FILE ( NAME = N'iStatistics04', SIZE = 2097152KB )
GO
ALTER DATABASE [internalStatistics] MODIFY FILE ( NAME = N'iStatistics05', SIZE = 2097152KB )
GO
ALTER DATABASE [internalStatistics] MODIFY FILE ( NAME = N'iStatistics06', SIZE = 2097152KB )
GO
ALTER DATABASE [internalStatistics] MODIFY FILE ( NAME = N'iStatistics07', SIZE = 2097152KB )
GO
ALTER DATABASE [internalStatistics] MODIFY FILE ( NAME = N'iStatistics08', SIZE = 2097152KB )
GO

--Used to shrink log file to specified size (in MB).
USE ARC_DWH_MA_PROD
GO
DBCC SHRINKFILE (N'ARC_DWH_MA_PROD_log' , 4128) --Size given is in MB.
GO


--Auto growth events from the default trace
DECLARE @path NVARCHAR(260);

SELECT @path = REVERSE(SUBSTRING(REVERSE([path]), 
   CHARINDEX('\', REVERSE([path])), 260)) + N'log.trc'
FROM    sys.traces
WHERE   is_default = 1;

SELECT DatabaseName,
   [FileName],
   SPID,
   Duration,
   StartTime,
   EndTime,
   FileType = CASE EventClass WHEN 92 THEN 'Data' WHEN 93 THEN 'Log' END
FROM sys.fn_trace_gettable(@path, DEFAULT)
WHERE EventClass IN (92,93)
ORDER BY StartTime DESC;



