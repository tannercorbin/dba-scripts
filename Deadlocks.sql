
USE MedTrack2
GO

SELECT TOP 500 CONVERT(VARCHAR,timeutc,100), Message, user, StatusCode 
FROM mt2.ELMAH_Error
WHERE message LIKE '%deadlock%'
ORDER BY timeutc DESC 
GO


USE msdb
GO

--Enable trace flags to monitor deadlocks.  These are turned off after a restart so if we want them permanently we need to add them to the startup parameters.
DBCC TRACEON (1204, -1)  --1204 = Returns the resources and types of locks participating in a deadlock and also the current command affected.
DBCC TRACEON (1222, -1)	 --1222 = Returns the resources and types of locks that are participating in a deadlock and also the current command affected, in an XML format that does not comply with any XSD schema.

--Make sure the 'Is_Event_Logged' field is set to true
EXEC master..sp_altermessage 1205, 'WITH_LOG', TRUE;
GO

--SELECT * 
--FROM master.sys.messages m
--WHERE m.message_id = 1205
--AND m.language_id = 1033

--Add alert.  Will only alter if Is_event_logged = true on message_id 1205
EXEC msdb.dbo.sp_add_alert 
        @name = N'1205 - Deadlock Detected', 
    @message_id = 1205,
    @severity = 0,
    @enabled = 1,
    @delay_between_responses = 0,
    @include_event_description_in = 1;
GO
EXEC msdb.dbo.sp_add_notification 
        @alert_name = N'1205 - Deadlock Detected', 
        @operator_name = N'DBA', -- name of profile here
        @notification_method = 1; 
GO


--Query extended events for deadlocks

-- ring_buffer target
SELECT	XEvent.query('(event/data/value/deadlock)[1]') AS DeadlockGraph
FROM	(SELECT	XEvent.query('.') AS XEvent
		 FROM	(SELECT	CAST(target_data AS XML) AS TargetData
				 FROM	sys.dm_xe_session_targets st
				 JOIN	sys.dm_xe_sessions s
						ON s.address = st.event_session_address
				 WHERE	s.name = 'system_health'
						AND st.target_name = 'ring_buffer') AS Data
		 CROSS APPLY TargetData.nodes('RingBufferTarget/event[@name="xml_deadlock_report"]') AS XEventData (XEvent)) AS src; 
GO

-- event file target
SELECT	XEvent.query('(event/data[@name="xml_report"]/value/deadlock)[1]') AS DeadlockGraph
FROM	(SELECT	XEvent.query('.') AS XEvent
		 FROM	(   -- Cast the target_data to XML 
				 SELECT	CAST(event_data AS XML) AS TargetData
				 FROM	sys.fn_xe_file_target_read_file('system_health*xel', 'Not used in 2012', NULL, NULL)) AS Data -- Split out the Event Nodes 
		 CROSS APPLY TargetData.nodes('event[@name="xml_deadlock_report"]') AS XEventData (XEvent)) AS src;
GO


