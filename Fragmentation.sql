/**************

	CAUTION! This may be very expensive

**************/

-- Get all index stats
DECLARE @DBId INT = (SELECT database_id FROM sys.databases WHERE name = DB_NAME()) 
SELECT DB_NAME(i.database_id) AS DbName
	, SCHEMA_NAME(o.schema_id) AS SchemaName
	, OBJECT_NAME(i.object_id) AS TableName
	, si.Name AS IndexName
	, avg_fragmentation_in_percent AS PageFragmentation -- I put it here under a new column name just to see it at the beginning
	, si.is_unique, si.is_primary_key, si.fill_factor
	, STATS_DATE(i.object_id, stats_id) AS LastStatsUpdate
	, i.*
FROM sys.dm_db_index_physical_stats ( -- Does not show up in SSMS
	@DBId -- database_id
	, NULL -- object_id
	, NULL -- index_id 
	, NULL -- partition_number
	, NULL -- Mode: Valid inputs are DEFAULT, NULL, LIMITED, SAMPLED, or DETAILED. The default (NULL) is LIMITED. 
) i JOIN sys.objects o
	ON i.object_id = o.object_id
JOIN sys.indexes si
	ON i.index_id = si.index_id
	AND si.object_id = o.object_id
LEFT JOIN sys.stats s
	ON s.object_id = i.object_id
	AND s.name = si.name
WHERE OBJECTPROPERTY(o.object_id, 'IsMSShipped') = 0
	AND  OBJECTPROPERTY(o.object_id, 'IsTable') = 1
	--AND i.page_count > 100
	--AND i.index_type_desc <> 'HEAP'
ORDER BY avg_fragmentation_in_percent DESC, fragment_count DESC


--When was an index last rebuilt.
SELECT name AS Stats,
STATS_DATE(object_id, stats_id) AS LastStatsUpdate
FROM sys.stats
WHERE object_id = OBJECT_ID('dbo.BillPayment')
and left(name,4)!='_WA_';

