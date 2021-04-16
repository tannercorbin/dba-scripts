-- Tells you what tables and indexes are using the most memory in the buffer cache
SELECT OBJECT_NAME(p.object_id) AS [ObjectName], p.object_id, 
p.index_id, COUNT(*)/128 AS [buffer size(MB)],  COUNT(*) AS [buffer_count] 
FROM sys.allocation_units AS a
INNER JOIN sys.dm_os_buffer_descriptors AS b
ON a.allocation_unit_id = b.allocation_unit_id
INNER JOIN sys.partitions AS p
ON a.container_id = p.hobt_id
WHERE b.database_id = db_id()
AND p.object_id > 100
GROUP BY p.object_id, p.index_id
ORDER BY buffer_count DESC;