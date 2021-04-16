	--Tables that have not been used since last service restart.
	SELECT	ao.[name] [Table]
		   ,s.[name] [Schema]
		   ,[create_date] [Created]
		   ,[modify_date] [LastModified]
	FROM	sys.all_objects ao
	JOIN	sys.schemas s
			ON ao.schema_id = s.schema_id
	WHERE	object_id NOT IN (SELECT	object_id
							  FROM		sys.dm_db_index_usage_stats)
			AND [type] = 'U'
	ORDER BY [modify_date] DESC

	--Use the dm_db_partition_stats DMV to list all empty tables
	;WITH	[Empty]
			  AS (SELECT	OBJECT_NAME(object_id) [Table]
						   ,SUM(row_count) [Records]
				  FROM		sys.dm_db_partition_stats
				  WHERE		index_id = 0
							OR index_id = 1
				  GROUP BY	object_id)
		SELECT	[Table]
			   ,Records
		INTO	#tmpEmptyTables
		FROM	[Empty]
		WHERE	[Records] = 0
		ORDER BY [Table]


	--Find those empty tables that are not referenced by other objects (excluding Audit stuff)
	SELECT	tet.*,
	referencing_schema_name = SCHEMA_NAME(o.SCHEMA_ID),
	referencing_object_name = o.name,
	referencing_object_type_desc = o.type_desc,
	referenced_schema_name,
	referenced_object_name = referenced_entity_name,
	referenced_object_type_desc = o1.type_desc,
	referenced_server_name, referenced_database_name
	--,sed.* -- Uncomment for all the columns
	FROM	#tmpEmptyTables tet
	LEFT JOIN sys.sql_expression_dependencies sed
			ON tet.[Table] = sed.referenced_entity_name
			AND ISNULL(sed.referenced_database_name,'') <> 'MedTrack2Audit'
	LEFT JOIN sys.objects o
			ON sed.referencing_id = o.[object_id]
	LEFT OUTER JOIN sys.objects o1
			ON sed.referenced_id = o1.[object_id]
	WHERE o.name IS NULL
	ORDER BY tet.[Table]
	
