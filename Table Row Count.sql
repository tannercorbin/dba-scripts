
SELECT	QUOTENAME(SCHEMA_NAME(sOBJ.schema_id)) + '.' + QUOTENAME(sOBJ.name) AS [TableName]
	   ,SUM(sPTN.rows) AS [RowCount]
FROM	sys.objects AS sOBJ
INNER JOIN sys.partitions AS sPTN
		ON sOBJ.object_id = sPTN.object_id
WHERE	sOBJ.type = 'U'
		AND sOBJ.is_ms_shipped = 0x0
		AND index_id < 2 -- 0:Heap, 1:Clustered
		--AND sobj.name IN ('CONST_ALARM_CODES','CONST_ALARM_CATEGORIES','CONST_ALARM_DEVICES','SITE','LOG_ALARMS','CONST_DEVICE_TYPES'
		--	,'LOG_COMPLIANCE','LOG_DELIVERY','LOG_INVENTORY','STORAGE')
GROUP BY sOBJ.schema_id,sOBJ.name
ORDER BY SUM(sPTN.rows) DESC
GO

sp_helpdb

--If you don't specify a table then sp_spaceused gives you list of reserved, data, index_size, and unsused in KBs.
sp_spaceused


SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT CONVERT(DATE,bc.AuditDate),COUNT(*)
FROM MedTrack2Audit.dbo.BillClaim bc
GROUP BY CONVERT(DATE,bc.AuditDate)
ORDER BY CONVERT(DATE,bc.AuditDate)

SELECT bc.AuditType,COUNT(*)
FROM MedTrack2Audit.dbo.BillClaim bc
WHERE bc.AuditDate > '05/13/2015'
GROUP BY bc.AuditType
ORDER BY bc.AuditType

SELECT * 
FROM dbaUtility.dbo.DDLEvents de
WHERE de.EventDate < '04/11/2015'
AND de.EventDate > '04/01/2015'
AND de.EventDDL LIKE '%billclaim%'
AND de.EventType <> 'Alter_index'
ORDER BY de.EventDate DESC

SELECT * 
FROM dbaUtility.dbo.DDLEvents de
WHERE de.ObjectName = 'uspBillCreateClaims'
ORDER BY de.EventDate


