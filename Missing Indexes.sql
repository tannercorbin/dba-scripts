


-- Missing Indexes in current database by Index Advantage
SELECT user_seeks * avg_total_user_cost * ( avg_user_impact * 0.01 ) AS [index_advantage] ,
migs.last_user_seek ,
mid.[statement] AS [Database.Schema.Table] , mid.equality_columns , mid.inequality_columns , mid.included_columns 
, migs.unique_compiles , migs.user_seeks , migs.avg_total_user_cost , migs.avg_user_impact
FROM sys.dm_db_missing_index_group_stats AS migs WITH ( NOLOCK ) 
INNER JOIN sys.dm_db_missing_index_groups AS mig WITH ( NOLOCK ) ON migs.group_handle = mig.index_group_handle 
INNER JOIN sys.dm_db_missing_index_details AS mid WITH ( NOLOCK ) ON mig.index_handle = mid.index_handle
WHERE mid.database_id = DB_ID()
--AND mid.[statement] = '[MedTrack2].[dbo].[OrderShipment]'
ORDER BY index_advantage DESC ;

--sp_BlitzIndex:

--	Diagnose:
		EXEC [master].dbo.sp_BlitzIndex @DatabaseName='Medtrack2Audit';
--	Return detail for a specific table:
		EXEC [master].dbo.sp_BlitzIndex @DatabaseName='Medtrack2Audit', @SchemaName='dbo', @TableName='BillEdi835Remittance';


-- List unused indexes
-- Be cautious of these results if sql has recently been restarted (resets counters).
    SELECT OBJECT_NAME(i.[object_id]) AS [Table Name], i.name 
    FROM sys.indexes AS i
    INNER JOIN sys.objects AS o
    ON i.[object_id] = o.[object_id]
    WHERE i.index_id 
    NOT IN (SELECT s.index_id 
            FROM sys.dm_db_index_usage_stats AS s 
            WHERE s.[object_id] = i.[object_id] 
            AND i.index_id = s.index_id 
            AND database_id = DB_ID())
    AND o.[type] = 'U'
    ORDER BY OBJECT_NAME(i.[object_id]) ASC;


-- Index fragmentation levels
SELECT	dbschemas.[name] AS 'Schema'
	   ,dbtables.[name] AS 'Table'
	   ,dbindexes.[name] AS 'Index'
	   ,indexstats.avg_fragmentation_in_percent
	   ,indexstats.page_count
FROM	sys.dm_db_index_physical_stats(DB_ID(), NULL, NULL, NULL, NULL) AS indexstats
INNER JOIN sys.tables dbtables
		ON dbtables.[object_id] = indexstats.[object_id]
INNER JOIN sys.schemas dbschemas
		ON dbtables.[schema_id] = dbschemas.[schema_id]
INNER JOIN sys.indexes AS dbindexes
		ON dbindexes.[object_id] = indexstats.[object_id]
		   AND indexstats.index_id = dbindexes.index_id
WHERE	indexstats.database_id = DB_ID()
ORDER BY indexstats.avg_fragmentation_in_percent DESC


--Number of rows in all tables
SELECT
      QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [TableName]
      , SUM(sPTN.Rows) AS [RowCount]
FROM 
      sys.objects AS sOBJ
      INNER JOIN sys.partitions AS sPTN
            ON sOBJ.object_id = sPTN.object_id
WHERE
      sOBJ.type = 'U'
      AND sOBJ.is_ms_shipped = 0x0
      AND index_id < 2 -- 0:Heap, 1:Clustered
GROUP BY 
      sOBJ.schema_id
      , sOBJ.name
ORDER BY  SUM(sPTN.Rows) desc
GO


--This should no longer be needed as I have set up a job to rebuild even small indexes once a week.
--/*May want to run this before querying missing indexes.
--  This uses the @PageCountLevel to rebuild small indexes.  The default on Ola's script
--  only rebuilds those with 1000 or more pages.  The idea was that performance gains
--  were only seen with large indexes 10000 pages or more.  But for querying missing indexes
--  it is helpful to not to see indexes that already exist but are not use because statistics 
--  are excluding these small but fragmented indexes.
-- */
--EXECUTE [master].[dbo].[IndexOptimize] @Databases = 'MedTrack2',
--	@FragmentationMedium = 'INDEX_REORGANIZE,INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE',
--	@FragmentationHigh = 'INDEX_REBUILD_ONLINE,INDEX_REBUILD_OFFLINE', @FragmentationLevel1 = 5,
--	@FragmentationLevel2 = 30, @UpdateStatistics = 'ALL', @LogToTable = 'Y', @PageCountLevel = 10


