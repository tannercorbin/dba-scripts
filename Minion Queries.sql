DECLARE @Server VARCHAR(100) = '180Uptivity'
	,@DriveLetter VARCHAR(100) = 'G:'

;WITH Averages
AS
(
	SELECT CONVERT(DATE,ds.ExecutionDateTime) AS [Day]
	,AVG(CONVERT(FLOAT,ds.FreeSpace)/ds.Capacity)*100 AS [AvgFreeSpace%]
	,AVG((ds.FreeSpace)/1073741824) AS AvgFreeSpaceinGBs
	FROM Collector.DriveSpace ds
	INNER JOIN dbo.Servers s
		ON s.InstanceID = ds.InstanceID
	WHERE s.ServerName = @Server
	AND (ds.DriveLeter = @DriveLetter OR @DriveLetter IS NULL)
	GROUP BY CONVERT(DATE,ds.ExecutionDateTime)
),
Change
AS 
(
	SELECT *,LAG(a.AvgFreeSpaceinGBs,1,NULL) OVER (ORDER BY a.[Day]) - a.AvgFreeSpaceinGBs AS ChangeinGBs
	FROM Averages a
)
SELECT AVG(Change.ChangeinGBs) AS AverageChangeinGBs
FROM Change

