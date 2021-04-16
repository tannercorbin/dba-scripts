SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

SELECT	TOP 1000 *
FROM	msdb.dbo.sysmail_mailitems sm
--WHERE sm.sent_status <> 1
ORDER BY sm.mailitem_id DESC


SELECT	sf.sent_status,sf.send_request_date,*
FROM	msdb.dbo.sysmail_faileditems sf
WHERE	sf.send_request_date > '02/01/2015'
ORDER BY sf.mailitem_id DESC

EXEC msdb.dbo.sysmail_help_configure_sp;
EXEC msdb.dbo.sysmail_help_account_sp;
EXEC msdb.dbo.sysmail_help_profile_sp;
EXEC msdb.dbo.sysmail_help_profileaccount_sp;
EXEC msdb.dbo.sysmail_help_principalprofile_sp;

SELECT	*
FROM	msdb.dbo.sysmail_event_log sel
WHERE	sel.event_type NOT IN ('Information', 'success')
ORDER BY sel.log_date DESC


--Research specific MailItem_Ids
SELECT	*
FROM	msdb.dbo.sysmail_mailitems sm
WHERE	sm.mailitem_id IN (4518)


SELECT	*
FROM	msdb.dbo.sysmail_log sl
ORDER BY sl.log_date DESC


SELECT * 
FROM msdb.dbo.sysmail_unsentitems su
ORDER BY su.mailitem_id desc

--Stop DB mail
EXEC msdb.dbo.sysmail_stop_sp;

--Start DB mail
EXEC msdb.dbo.sysmail_start_sp;

--Check mail queue - you want to see "RECEIVES_OCCURRING" in state
EXEC msdb.dbo.sysmail_help_queue_sp @queue_type = 'mail';

--View Timeout Settings (it was defaulted to NULL)
SELECT	* FROM	msdb.dbo.sysmail_server ss

--Change the timeout
EXEC msdb.dbo.sysmail_update_account_sp @account_id = 3, @timeout = 90

--Set MSDB to trustworthy
ALTER DATABASE MedTrack2 SET TRUSTWORTHY ON	

--Check database owners
EXEC sp_helpdb

--Change database owners
ALTER AUTHORIZATION ON DATABASE::Medtrack2Audit TO [SystemAdministrator]
     
--Check DB MAIL Status - Sysmail should be STARTED
EXECUTE msdb.dbo.sysmail_help_status_sp

--Check that the Service broker is enabled
SELECT is_broker_enabled,* FROM sys.databases WHERE name = 'msdb';

--Clear out unsent messages
EXEC msdb.dbo.sysmail_delete_mailitems_sp @sent_status = 'unsent'

select * from msdb.sys.transmission_queue



--Resend a specific mail item.
DECLARE	@to VARCHAR(MAX)
		,@copy VARCHAR(MAX)
		,@title NVARCHAR(255)
		,@msg NVARCHAR(MAX)
		,@attachment NVARCHAR(MAX)
		,@bodyformat NVARCHAR(255)
		,@FromAddress NVARCHAR(255)
		,@replyto NVARCHAR(255);
SELECT	@to = recipients
	   ,@copy = copy_recipients
	   ,@title = [subject]
	   ,@msg = body
	   ,@attachment = file_attachments
	   ,@bodyformat = body_format
	   ,@FromAddress = from_address
	   ,@replyto = reply_to
FROM	msdb.dbo.sysmail_faileditems
WHERE	mailitem_id = 19799;
EXEC msdb.dbo.sp_send_dbmail 
	 @recipients = @to
	,@copy_recipients = @copy
	,@body = @msg
	,@subject = @title
	,@body_format = @bodyformat
	,@file_attachments = @attachment;



	SELECT * 
	FROM master.sys.databases d
	WHERE d.name = 'Medtrack2'
	
	SELECT * 
	FROM Medtrack2.sys.databases d
	WHERE d.name = 'Medtrack2'


