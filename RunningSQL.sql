SELECT	CASE sp.transaction_isolation_level
		  WHEN 0 THEN 'Unspecified'
		  WHEN 1 THEN 'ReadUncomitted'
		  WHEN 2 THEN 'Readcomitted'
		  WHEN 3 THEN 'Repeatable'
		  WHEN 4 THEN 'Serializable'
		  WHEN 5 THEN 'Snapshot'
		END AS TRANSACTION_ISOLATION_LEVEL
	   ,sp.session_id
	   ,er.request_id
	   ,er.command
	   ,[Database] = DB_NAME(er.database_id)
	   ,[User] = login_name
	   ,er.blocking_session_id
	   ,[Status] = er.status
	   ,[Wait] = wait_type
	   ,CAST('<?query --' + CHAR(13) + SUBSTRING(qt.text, (er.statement_start_offset / 2) + 1, ((CASE er.statement_end_offset
																								   WHEN -1 THEN DATALENGTH(qt.text)
																								   ELSE er.statement_end_offset
																								 END - er.statement_start_offset) / 2) + 1) + CHAR(13) + '--?>' AS XML) AS sql_statement
	   ,[Parent Query] = qt.text
	   ,p.query_plan
	   ,er.cpu_time
	   ,er.reads
	   ,er.writes
	   ,er.logical_reads
	   ,er.row_count
	   ,Program = program_name
	   ,host_name
	   ,start_time
FROM	sys.dm_exec_requests er
JOIN	sys.dm_exec_sessions sp
		ON er.session_id = sp.session_id
CROSS APPLY sys.dm_exec_sql_text(er.sql_handle) AS qt
CROSS APPLY sys.dm_exec_query_plan(er.plan_handle) p
WHERE	sp.is_user_process = 1
		AND sp.session_id > 50-- Ignore system spids.
		AND sp.session_id NOT IN (@@SPID)
ORDER BY 1 ,2



 --Displays the last statement sent from a client to an instance of Microsoft SQL Server.
--DBCC INPUTBUFFER(193)
