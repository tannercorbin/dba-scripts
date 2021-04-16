
SELECT 
        [Job Name] = sj.[name], 
        [Owner] = SUSER_SNAME(sj.[owner_sid]), 
        [Category] = c.[name], 
        [Email Operator] = o.[name], 
		sj.[enabled],
        [Email Notification] = CASE sj.[notify_level_email] 
            WHEN 0 THEN 'Never'
            WHEN 1 THEN 'When the job succeeds'
            WHEN 2 THEN 'When the job fails'
            WHEN 3 THEN 'When the job completes (regardless of the job outcome)'
            ELSE 'UNKNOWN' END 
FROM msdb.dbo.[sysjobs] sj 
LEFT JOIN msdb.dbo.[sysoperators] o 
	ON sj.[notify_email_operator_id] = o.[id] 
LEFT JOIN msdb.dbo.[syscategories] C 
	ON sj.[category_id] = c.[category_id]
--WHERE  NOT (sj.[name] LIKE '_____________-____-____-____________') --ignore auto-created jobs (Reporting Services schedules) 
        --AND sj.[enabled] = 1 
ORDER BY sj.[name] 

