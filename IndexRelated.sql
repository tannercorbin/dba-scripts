SELECT DB_NAME() AS DB, f.name, f.physical_name, u.*
FROM sys.dm_db_file_space_usage u
JOIN sys.database_files f
	ON u.file_id = f.file_id
-- Extent = 8 8kb pages


-- Find "large" objects with lots of scans and few seeks
SELECT OBJECT_NAME(u.object_id) AS Object, u.index_id, u.user_seeks, u.user_scans, u.user_lookups
	, i.name, i.type_desc
FROM sys.dm_db_index_usage_stats u
JOIN sys.indexes i
	ON u.index_id = i.index_id
	AND u.object_id = i.object_id
WHERE u.object_id > 100 
	AND OBJECT_NAME(u.object_id) is not null
	AND u.user_scans > u.user_seeks
ORDER BY u.object_id, u.index_id

-- SELECT * FROM sys.dm_db_index_physical_stats(db_id(), object_id('Orders'), NULL, NULL , 'DETAILED')

SELECT OBJECT_NAME(x.object_id) AS Object
	, x.avg_fragmentation_in_percent
	, x.page_count
	, x.fragment_count
	, x.index_id
	, x.index_type_desc
	, x.record_count
	, x.avg_page_space_used_in_percent
	, x.avg_record_size_in_bytes
FROM sys.dm_db_index_physical_stats(db_id(), NULL, NULL, NULL , 'DETAILED') x
WHERE x.avg_fragmentation_in_percent > 50
	AND x.page_count > 10
ORDER BY x.page_count DESC
GO


SELECT * 
FROM sys.dm_db_index_physical_stats(
	DB_ID()
	, DEFAULT
	, DEFAULT
	, DEFAULT
	, DEFAULT
) x
WHERE x.avg_fragmentation_in_percent > 50
GO

-- Find missing indexes:

SELECT grp.avg_user_impact
	, grp.last_user_seek, mid.[statement] AS [Database.Schema.Table]
	, mid.equality_columns, mid.inequality_columns, mid.included_columns
	, grp.unique_compiles, grp.user_seeks, grp.avg_total_user_cost
FROM sys.dm_db_missing_index_group_stats AS grp
JOIN sys.dm_db_missing_index_groups AS mig
	ON grp.group_handle = mig.index_group_handle
JOIN sys.dm_db_missing_index_details AS mid
	ON mig.index_handle = mid.index_handle
ORDER BY grp.avg_user_impact DESC