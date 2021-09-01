--Select the database for which you want to view permissions.
USE OUHealthDW
GO

--Change this variable to the role for which you want to view permissions.
DECLARE @Database_Role VARCHAR(100) = 'DnA_Read_Role'

SELECT DISTINCT rp.[Name]
    , rp.[type_desc] AS ObjectType
    , pm.class_desc AS PermissionType
    , pm.[permission_name]
    , pm.state_desc
    , CASE 
        WHEN obj.[type_desc] IS NULL OR obj.[type_desc] = 'SYSTEM_TABLE'
            THEN pm.class_desc 
        ELSE obj.[type_desc]
        END AS ObjectType
    , s.[Name] AS SchemaName
    , [ObjectName] = ISNULL(ss.[name], OBJECT_NAME(pm.major_id))
    , pm.class_desc
FROM sys.database_principals rp 
INNER JOIN sys.database_permissions pm 
    ON pm.grantee_principal_id = rp.principal_id 
LEFT JOIN sys.schemas ss 
    ON pm.major_id = ss.[schema_id]
LEFT JOIN sys.objects obj 
    ON pm.[major_id] = obj.[object_id] 
LEFT JOIN sys.schemas s
    ON s.[schema_id] = obj.[schema_id]
WHERE rp.[name] = @Database_Role 
AND pm.class_desc <> 'DATABASE' 
ORDER BY rp.[name] 
    ,rp.[type_desc]
    ,pm.class_desc 
