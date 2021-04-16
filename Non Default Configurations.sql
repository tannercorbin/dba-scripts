/*********************************
SQL Server Configuration Checker
Mike Walsh | Linchpin People, LLC
Modified November 22, 2013
http://www.linchpinpeople.com
http://www.straightpathsql.com
twitter: Mike_Walsh

Version 0.1 - Beta Release 
This has been tested in limited instances on SQL Server 2008, 2008R2 and 2012.


Current Version Works on SQL Server 2008, 2008R2, 2012

Notes: You've downloaded this script from the
 internet. You should review it, understand what it
 does, test it and ensure it is fine for your environment.
 This script is free to use for your environments. If you
 have any suggestions, feel free to reach out with them.

 A SQL Server 2014 version will be coming out when it is RTM.
 
How To Use: This script checks your configurations for 
 your SQL Server instance against common best practices
 from our experience and commonly checked in 
 our WellDBA(tm) Exams. Your mileage may vary on the settings
 checked and recommendations. After reviewing this script,
 you can run it as one script, it will check your SQL version
 first and run the appropriate scripts.  
 
 This is best run in results to text mode.

Info about checks:

- Value In Use Does Not Equal Set Value
This looks for the set value for a configuration and shows if
the currently in use - or running - value differs. This is likely
a setting that has changed from default but a RECONFIGURE or a 
restart of the instance is needed.

- In Use Value Differs From Default 
This is not necessarily indicating an issue, but allows us to quickly
review a setting that differs from the default. These should be reviewed
to make sure they are expected differences in accordance with best practices.

- Potentially Bad Defaults In Use
POTENTIALLY is important here. These are configuration options
that we often encounter and work on changing with clients. You might review
these against best practices in your environent and your standards.
These are not all going to be issues in every environment, but worth
looking at in depth.

Credit: This script was started by looking at the source of the "Non Default
Configuration" section of the "Server Dashboard" report in SSMS. 
As discussed in this blog post:


*****************************************************************/
SET NOCOUNT ON

DECLARE @Version VARCHAR(20)
SELECT	@Version = CAST (SERVERPROPERTY('ProductVersion') AS VARCHAR(20))

IF  @Version NOT LIKE '10%' 
and @Version NOT LIKE '11%'

BEGIN

PRINT 'Currently this works only on SQL Server 2008, 2008R2 and 2012'

END

IF @Version LIKE '10.0%'
BEGIN

Print 'SQL Server 2008 Check'
PRINT ''

-- SQL Server 2008 Defaults
DECLARE @Default_configurations_options_table2008 TABLE (name varchar(500), Default_Value BIGINT);


insert into @Default_configurations_options_table2008 values ('access check cache bucket count',0)
insert into @Default_configurations_options_table2008 values ('access check cache quota',0)
insert into @Default_configurations_options_table2008 values ('Ad Hoc Distributed Queries',0)
insert into @Default_configurations_options_table2008 values ('affinity I/O mask',0)
insert into @Default_configurations_options_table2008 values ('affinity mask',0)
insert into @Default_configurations_options_table2008 values ('affinity64 I/O mask',0)
insert into @Default_configurations_options_table2008 values ('affinity64 mask',0)
insert into @Default_configurations_options_table2008 values ('Agent XPs',1)
insert into @Default_configurations_options_table2008 values ('allow updates',0)
insert into @Default_configurations_options_table2008 values ('awe enabled',0)
insert into @Default_configurations_options_table2008 values ('backup compression default',0)
insert into @Default_configurations_options_table2008 values ('blocked process threshold (s)',0)
insert into @Default_configurations_options_table2008 values ('c2 audit mode',0)
insert into @Default_configurations_options_table2008 values ('clr enabled',0)
insert into @Default_configurations_options_table2008 values ('common criteria compliance enabled',0)
insert into @Default_configurations_options_table2008 values ('cost threshold for parallelism',5)
insert into @Default_configurations_options_table2008 values ('cross db ownership chaining',0)
insert into @Default_configurations_options_table2008 values ('cursor threshold',-1)
insert into @Default_configurations_options_table2008 values ('Database Mail XPs',0)
insert into @Default_configurations_options_table2008 values ('default full-text language',1033)
insert into @Default_configurations_options_table2008 values ('default language',0)
insert into @Default_configurations_options_table2008 values ('default trace enabled',1)
insert into @Default_configurations_options_table2008 values ('disallow results from triggers',0)
insert into @Default_configurations_options_table2008 values ('EKM provider enabled',0)
insert into @Default_configurations_options_table2008 values ('filestream access level',0)
insert into @Default_configurations_options_table2008 values ('fill factor (%)',0)
insert into @Default_configurations_options_table2008 values ('ft crawl bandwidth (max)',100)
insert into @Default_configurations_options_table2008 values ('ft crawl bandwidth (min)',0)
insert into @Default_configurations_options_table2008 values ('ft notify bandwidth (max)',100)
insert into @Default_configurations_options_table2008 values ('ft notify bandwidth (min)',0)
insert into @Default_configurations_options_table2008 values ('index create memory (KB)',0)
insert into @Default_configurations_options_table2008 values ('in-doubt xact resolution',0)
insert into @Default_configurations_options_table2008 values ('lightweight pooling',0)
insert into @Default_configurations_options_table2008 values ('locks',0)
insert into @Default_configurations_options_table2008 values ('max degree of parallelism',0)
insert into @Default_configurations_options_table2008 values ('max full-text crawl range',4)
insert into @Default_configurations_options_table2008 values ('max server memory (MB)',2147483647)
insert into @Default_configurations_options_table2008 values ('max text repl size (B)',65536)
insert into @Default_configurations_options_table2008 values ('max worker threads',0)
insert into @Default_configurations_options_table2008 values ('media retention',0)
insert into @Default_configurations_options_table2008 values ('min memory per query (KB)',1024)
insert into @Default_configurations_options_table2008 values ('min server memory (MB)',0)
insert into @Default_configurations_options_table2008 values ('nested triggers',1)
insert into @Default_configurations_options_table2008 values ('network packet size (B)',4096)
insert into @Default_configurations_options_table2008 values ('Ole Automation Procedures',0)
insert into @Default_configurations_options_table2008 values ('open objects',0)
insert into @Default_configurations_options_table2008 values ('optimize for ad hoc workloads',0)
insert into @Default_configurations_options_table2008 values ('PH timeout (s)',60)
insert into @Default_configurations_options_table2008 values ('precompute rank',0)
insert into @Default_configurations_options_table2008 values ('priority boost',0)
insert into @Default_configurations_options_table2008 values ('query governor cost limit',0)
insert into @Default_configurations_options_table2008 values ('query wait (s)',-1)
insert into @Default_configurations_options_table2008 values ('recovery interval (min)',0)
insert into @Default_configurations_options_table2008 values ('remote access',1)
insert into @Default_configurations_options_table2008 values ('remote admin connections',0)
insert into @Default_configurations_options_table2008 values ('remote login timeout (s)',20)
insert into @Default_configurations_options_table2008 values ('remote proc trans',0)
insert into @Default_configurations_options_table2008 values ('remote query timeout (s)',600)
insert into @Default_configurations_options_table2008 values ('Replication XPs',0)
insert into @Default_configurations_options_table2008 values ('scan for startup procs',0)
insert into @Default_configurations_options_table2008 values ('server trigger recursion',1)
insert into @Default_configurations_options_table2008 values ('set working set size',0)
insert into @Default_configurations_options_table2008 values ('show advanced options',0)
insert into @Default_configurations_options_table2008 values ('SMO and DMO XPs',1)
insert into @Default_configurations_options_table2008 values ('SQL Mail XPs',0)
insert into @Default_configurations_options_table2008 values ('transform noise words',0)
insert into @Default_configurations_options_table2008 values ('two digit year cutoff',2049)
insert into @Default_configurations_options_table2008 values ('user connections',0)
insert into @Default_configurations_options_table2008 values ('user options',0)
insert into @Default_configurations_options_table2008 values ('xp_cmdshell',0)


-- Potentially Problematic Defaults To Highlights and Look Into
DECLARE @BadDefault_configurations_options_table2008 TABLE
 (name VARCHAR(500), Bad_Default BIGINT)

insert into @BadDefault_configurations_options_table2008 values ('backup compression default',0)
insert into @BadDefault_configurations_options_table2008 values ('max degree of parallelism',0)
insert into @BadDefault_configurations_options_table2008 values ('max server memory (MB)',2147483647)
insert into @BadDefault_configurations_options_table2008 values ('min server memory (MB)',0)
insert into @BadDefault_configurations_options_table2008 values ('optimize for ad hoc workloads',0)
insert into @BadDefault_configurations_options_table2008 values ('remote admin connections',0)
insert into @BadDefault_configurations_options_table2008 values ('cost threshold for parallelism',5)

-- Report Findings

-- In place value and value_in_use mismatch
-- Not an issue per se - but worth noting to understand
PRINT 'Value In Use Does Not Equal Set Value'
SELECT name, 
       CAST(Value AS VARCHAR(15)), 
	   CAST(Value_in_use AS VARCHAR(15))
FROM sys.configurations 
WHERE value <> value_in_use

-- Value In Use differs from SQL Server Deafults
-- Not always bad and with certain options this can be expected/desired
PRINT 'In Use Value Differs from Default'
SELECT Live.name, 
       CAST(Live.value_in_use AS VARCHAR(15)) AS Live_In_Use, 
	   CAST(Defaults.Default_Value AS VARCHAR(15)) AS Default_Value 
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2008 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value


-- Potentially problematic defaults not changed
-- values here represent out of box defaults that may be 
-- less than ideal - further investigation should be undertaken
PRINT 'Potentially bad defaults in use'
SELECT Live.name, 
       CAST (Live.value_in_use as varchar(15)) AS Live_In_Use, 
	   CAST (BadDefaults.Bad_Default as VARCHAR(15)) AS Bad_Default_Value 
FROM sys.configurations AS Live
  INNER JOIN @BadDefault_configurations_options_table2008 AS BadDefaults
    ON Live.name = BadDefaults.name 
   AND Live.value_in_use = BadDefaults.Bad_Default

END




IF @Version LIKE '10.50%'
BEGIN

Print 'SQL Server 2008 R2 Check'
PRINT ''

-- SQL Server 2008R2 Defaults
DECLARE @Default_configurations_options_table TABLE
(name varchar(500), Default_Value BIGINT)


insert into @Default_configurations_options_table values ('access check cache bucket count',0)
insert into @Default_configurations_options_table values ('access check cache quota',0)
insert into @Default_configurations_options_table values ('Ad Hoc Distributed Queries',0)
insert into @Default_configurations_options_table values ('affinity I/O mask',0)
insert into @Default_configurations_options_table values ('affinity mask',0)
insert into @Default_configurations_options_table values ('affinity64 I/O mask',0)
insert into @Default_configurations_options_table values ('affinity64 mask',0)
insert into @Default_configurations_options_table values ('Agent XPs',1)
insert into @Default_configurations_options_table values ('allow updates',0)
insert into @Default_configurations_options_table values ('awe enabled',0)
insert into @Default_configurations_options_table values ('backup compression default',0)
insert into @Default_configurations_options_table values ('blocked process threshold (s)',0)
insert into @Default_configurations_options_table values ('c2 audit mode',0)
insert into @Default_configurations_options_table values ('clr enabled',0)
insert into @Default_configurations_options_table values ('common criteria compliance enabled',0)
insert into @Default_configurations_options_table values ('cost threshold for parallelism',5)
insert into @Default_configurations_options_table values ('cross db ownership chaining',0)
insert into @Default_configurations_options_table values ('cursor threshold',-1)
insert into @Default_configurations_options_table values ('Database Mail XPs',0)
insert into @Default_configurations_options_table values ('default full-text language',1033)
insert into @Default_configurations_options_table values ('default language',0)
insert into @Default_configurations_options_table values ('default trace enabled',1)
insert into @Default_configurations_options_table values ('disallow results from triggers',0)
insert into @Default_configurations_options_table values ('EKM provider enabled',0)
insert into @Default_configurations_options_table values ('filestream access level',0)
insert into @Default_configurations_options_table values ('fill factor (%)',0)
insert into @Default_configurations_options_table values ('ft crawl bandwidth (max)',100)
insert into @Default_configurations_options_table values ('ft crawl bandwidth (min)',0)
insert into @Default_configurations_options_table values ('ft notify bandwidth (max)',100)
insert into @Default_configurations_options_table values ('ft notify bandwidth (min)',0)
insert into @Default_configurations_options_table values ('index create memory (KB)',0)
insert into @Default_configurations_options_table values ('in-doubt xact resolution',0)
insert into @Default_configurations_options_table values ('lightweight pooling',0)
insert into @Default_configurations_options_table values ('locks',0)
insert into @Default_configurations_options_table values ('max degree of parallelism',0)
insert into @Default_configurations_options_table values ('max full-text crawl range',4)
insert into @Default_configurations_options_table values ('max server memory (MB)',2147483647)
insert into @Default_configurations_options_table values ('max text repl size (B)',65536)
insert into @Default_configurations_options_table values ('max worker threads',0)
insert into @Default_configurations_options_table values ('media retention',0)
insert into @Default_configurations_options_table values ('min memory per query (KB)',1024)
insert into @Default_configurations_options_table values ('min server memory (MB)',0)
insert into @Default_configurations_options_table values ('nested triggers',1)
insert into @Default_configurations_options_table values ('network packet size (B)',4096)
insert into @Default_configurations_options_table values ('Ole Automation Procedures',0)
insert into @Default_configurations_options_table values ('open objects',0)
insert into @Default_configurations_options_table values ('optimize for ad hoc workloads',0)
insert into @Default_configurations_options_table values ('PH timeout (s)',60)
insert into @Default_configurations_options_table values ('precompute rank',0)
insert into @Default_configurations_options_table values ('priority boost',0)
insert into @Default_configurations_options_table values ('query governor cost limit',0)
insert into @Default_configurations_options_table values ('query wait (s)',-1)
insert into @Default_configurations_options_table values ('recovery interval (min)',0)
insert into @Default_configurations_options_table values ('remote access',1)
insert into @Default_configurations_options_table values ('remote admin connections',0)
insert into @Default_configurations_options_table values ('remote login timeout (s)',20)
insert into @Default_configurations_options_table values ('remote proc trans',0)
insert into @Default_configurations_options_table values ('remote query timeout (s)',600)
insert into @Default_configurations_options_table values ('Replication XPs',0)
insert into @Default_configurations_options_table values ('scan for startup procs',0)
insert into @Default_configurations_options_table values ('server trigger recursion',1)
insert into @Default_configurations_options_table values ('set working set size',0)
insert into @Default_configurations_options_table values ('show advanced options',0)
insert into @Default_configurations_options_table values ('SMO and DMO XPs',1)
insert into @Default_configurations_options_table values ('SQL Mail XPs',0)
insert into @Default_configurations_options_table values ('transform noise words',0)
insert into @Default_configurations_options_table values ('two digit year cutoff',2049)
insert into @Default_configurations_options_table values ('user connections',0)
insert into @Default_configurations_options_table values ('user options',0)
insert into @Default_configurations_options_table values ('xp_cmdshell',0)


-- Potentially Problematic Defaults To Highlights and Look Into
DECLARE @BadDefault_configurations_options_table TABLE
 (name VARCHAR(500), Bad_Default BIGINT)

insert into @BadDefault_configurations_options_table values ('backup compression default',0)
insert into @BadDefault_configurations_options_table values ('max degree of parallelism',0)
insert into @BadDefault_configurations_options_table values ('max server memory (MB)',2147483647)
insert into @BadDefault_configurations_options_table values ('min server memory (MB)',0)
insert into @BadDefault_configurations_options_table values ('optimize for ad hoc workloads',0)
insert into @BadDefault_configurations_options_table values ('remote admin connections',0)
insert into @BadDefault_configurations_options_table values ('cost threshold for parallelism',5)

-- Report Findings

-- In place value and value_in_use mismatch
-- Not an issue per se - but worth noting to understand
PRINT 'Value In Use Does Not Equal Set Value'
SELECT name, 
       CAST(Value AS VARCHAR(15)), 
	   CAST(Value_in_use AS VARCHAR(15))
FROM sys.configurations 
WHERE value <> value_in_use

-- Value In Use differs from SQL Server Deafults
-- Not always bad and with certain options this can be expected/desired
PRINT 'In Use Value Differs from Default'
SELECT Live.name, 
       CAST(Live.value_in_use AS VARCHAR(15)) AS Live_In_Use, 
	   CAST(Defaults.Default_Value AS VARCHAR(15)) AS Default_Value 
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value


-- Potentially problematic defaults not changed
-- values here represent out of box defaults that may be 
-- less than ideal - further investigation should be undertaken
PRINT 'Potentially bad defaults in use'
SELECT Live.name, 
       CAST (Live.value_in_use as varchar(15)) AS Live_In_Use, 
	   CAST (BadDefaults.Bad_Default as VARCHAR(15)) AS Bad_Default_Value 
FROM sys.configurations AS Live
  INNER JOIN @BadDefault_configurations_options_table AS BadDefaults
    ON Live.name = BadDefaults.name 
   AND Live.value_in_use = BadDefaults.Bad_Default

END


IF @Version LIKE '11%'
BEGIN
PRINT 'SQL Server 2012 Check'
PRINT ''

-- SQL Server 2008R2 Defaults
DECLARE @Default_configurations_options_table2012 TABLE
(name varchar(500), Default_Value BIGINT)


insert into @Default_configurations_options_table2012 values ('access check cache bucket count',0)
insert into @Default_configurations_options_table2012 values ('access check cache quota',0)
insert into @Default_configurations_options_table2012 values ('Ad Hoc Distributed Queries',0)
insert into @Default_configurations_options_table2012 values ('affinity I/O mask',0)
insert into @Default_configurations_options_table2012 values ('affinity mask',0)
insert into @Default_configurations_options_table2012 values ('affinity64 I/O mask',0)
insert into @Default_configurations_options_table2012 values ('affinity64 mask',0)
insert into @Default_configurations_options_table2012 values ('Agent XPs',1)	
insert into @Default_configurations_options_table2012 values ('allow updates',0)
insert into @Default_configurations_options_table2012 values ('backup compression default',0)
insert into @Default_configurations_options_table2012 values ('blocked process threshold (s)',0)
insert into @Default_configurations_options_table2012 values ('c2 audit mode',0)
insert into @Default_configurations_options_table2012 values ('clr enabled',0)
insert into @Default_configurations_options_table2012 values ('common criteria compliance enabled',0)
insert into @Default_configurations_options_table2012 values ('contained database authentication',0)

insert into @Default_configurations_options_table2012 values ('cost threshold for parallelism',5)
insert into @Default_configurations_options_table2012 values ('cross db ownership chaining',0)
insert into @Default_configurations_options_table2012 values ('cursor threshold',-1)
insert into @Default_configurations_options_table2012 values ('Database Mail XPs',0)
insert into @Default_configurations_options_table2012 values ('default full-text language',1033)
insert into @Default_configurations_options_table2012 values ('default language',0)
insert into @Default_configurations_options_table2012 values ('default trace enabled',1)
insert into @Default_configurations_options_table2012 values ('disallow results from triggers',0)
insert into @Default_configurations_options_table2012 values ('EKM provider enabled',0)
insert into @Default_configurations_options_table2012 values ('filestream access level',0)
insert into @Default_configurations_options_table2012 values ('fill factor (%)',0)
insert into @Default_configurations_options_table2012 values ('ft crawl bandwidth (max)',100)
insert into @Default_configurations_options_table2012 values ('ft crawl bandwidth (min)',0)
insert into @Default_configurations_options_table2012 values ('ft notify bandwidth (max)',100)
insert into @Default_configurations_options_table2012 values ('ft notify bandwidth (min)',0)
insert into @Default_configurations_options_table2012 values ('index create memory (KB)',0)
insert into @Default_configurations_options_table2012 values ('in-doubt xact resolution',0)
insert into @Default_configurations_options_table2012 values ('lightweight pooling',0)
insert into @Default_configurations_options_table2012 values ('locks',0)
insert into @Default_configurations_options_table2012 values ('max degree of parallelism',0)
insert into @Default_configurations_options_table2012 values ('max full-text crawl range',4)
insert into @Default_configurations_options_table2012 values ('max server memory (MB)',2147483647)
insert into @Default_configurations_options_table2012 values ('max text repl size (B)',65536)
insert into @Default_configurations_options_table2012 values ('max worker threads',0)
insert into @Default_configurations_options_table2012 values ('media retention',0)
insert into @Default_configurations_options_table2012 values ('min memory per query (KB)',1024)
insert into @Default_configurations_options_table2012 values ('min server memory (MB)',0)
insert into @Default_configurations_options_table2012 values ('nested triggers',1)
insert into @Default_configurations_options_table2012 values ('network packet size (B)',4096)
insert into @Default_configurations_options_table2012 values ('Ole Automation Procedures',0)
insert into @Default_configurations_options_table2012 values ('open objects',0)
insert into @Default_configurations_options_table2012 values ('optimize for ad hoc workloads',0)
insert into @Default_configurations_options_table2012 values ('PH timeout (s)',60)
insert into @Default_configurations_options_table2012 values ('precompute rank',0)
insert into @Default_configurations_options_table2012 values ('priority boost',0)
insert into @Default_configurations_options_table2012 values ('query governor cost limit',0)
insert into @Default_configurations_options_table2012 values ('query wait (s)',-1)
insert into @Default_configurations_options_table2012 values ('recovery interval (min)',0)
insert into @Default_configurations_options_table2012 values ('remote access',1)
insert into @Default_configurations_options_table2012 values ('remote admin connections',0)
insert into @Default_configurations_options_table2012 values ('remote login timeout (s)',10)
insert into @Default_configurations_options_table2012 values ('remote proc trans',0)
insert into @Default_configurations_options_table2012 values ('remote query timeout (s)',600)
insert into @Default_configurations_options_table2012 values ('Replication XPs',0)
insert into @Default_configurations_options_table2012 values ('scan for startup procs',0)
insert into @Default_configurations_options_table2012 values ('server trigger recursion',1)
insert into @Default_configurations_options_table2012 values ('set working set size',0)
insert into @Default_configurations_options_table2012 values ('show advanced options',0)
insert into @Default_configurations_options_table2012 values ('SMO and DMO XPs',1)
insert into @Default_configurations_options_table2012 values ('transform noise words',0)
insert into @Default_configurations_options_table2012 values ('two digit year cutoff',2049)
insert into @Default_configurations_options_table2012 values ('user connections',0)
insert into @Default_configurations_options_table2012 values ('user options',0)
insert into @Default_configurations_options_table2012 values ('xp_cmdshell',0)


-- Potentially Problematic Defaults To Highlights and Look Into
DECLARE @BadDefault_configurations_options_table2012 TABLE
 (name VARCHAR(500), Bad_Default BIGINT)

insert into @BadDefault_configurations_options_table2012 values ('backup compression default',0)
insert into @BadDefault_configurations_options_table2012 values ('max degree of parallelism',0)
insert into @BadDefault_configurations_options_table2012 values ('max server memory (MB)',2147483647)
insert into @BadDefault_configurations_options_table2012 values ('min server memory (MB)',0)
insert into @BadDefault_configurations_options_table2012 values ('optimize for ad hoc workloads',0)
insert into @BadDefault_configurations_options_table2012 values ('remote admin connections',0)
insert into @BadDefault_configurations_options_table2012 values ('cost threshold for parallelism',5)

-- Report Findings

-- In place value and value_in_use mismatch
-- Not an issue per se - but worth noting to understand
PRINT 'Value In Use Does Not Equal Set Value'
SELECT name, 
       CAST(Value AS VARCHAR(15)) AS Value_Set, 
	   CAST(Value_in_use AS VARCHAR(15)) AS Value_In_Use
FROM sys.configurations 
WHERE value <> value_in_use

-- Value In Use differs from SQL Server Deafults
-- Not always bad and with certain options this can be expected/desired
PRINT 'In Use Value Differs from Default'
SELECT Live.name, 
       CAST(Live.value_in_use AS VARCHAR(15)) AS Live_In_Use, 
	   CAST(Defaults.Default_Value AS VARCHAR(15)) AS Default_Value 
FROM sys.configurations Live
  INNER JOIN @Default_configurations_options_table2012 Defaults
   ON Live.name = Defaults.name 
  AND Live.value_in_use <> Defaults.Default_Value


-- Potentially problematic defaults not changed
-- values here represent out of box defaults that may be 
-- less than ideal - further investigation should be undertaken
PRINT 'Potentially bad defaults in use'
SELECT Live.name, 
       CAST (Live.value_in_use as varchar(15)) AS Live_In_Use, 
	   CAST (BadDefaults.Bad_Default as VARCHAR(15)) AS Bad_Default_Value 
FROM sys.configurations AS Live
  INNER JOIN @BadDefault_configurations_options_table2012 AS BadDefaults
    ON Live.name = BadDefaults.name 
   AND Live.value_in_use = BadDefaults.Bad_Default

END