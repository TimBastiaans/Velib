USE master
DECLARE @ddl VARCHAR(MAX) = ''
DECLARE tblCUrsor CURSOR FOR 
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES 
				  WHERE TABLE_NAME != 'spt_values'
				  AND TABLE_NAME != 'spt_monitor'
				  AND TABLE_NAME != 'MSreplication_options'
				  AND TABLE_NAME != 'spt_fallback_dev'
				  AND TABLE_NAME != 'spt_fallback_db'
				  AND TABLE_NAME != 'spt_fallback_usg'
DECLARE @count INT = 0
DECLARE @val VARCHAR(MAX)
OPEN tblCursor
FETCH NEXT FROM tblCursor INTO @val
WHILE @count <= (SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES 
				 WHERE TABLE_NAME != 'spt_values'
				 AND TABLE_NAME != 'spt_monitor'
				 AND TABLE_NAME != 'MSreplication_options'
				 AND TABLE_NAME != 'spt_fallback_dev'
				 AND TABLE_NAME != 'spt_fallback_db'
				 AND TABLE_NAME != 'spt_fallback_usg')
BEGIN
	SET @ddl = 'DROP TABLE ' + @val
	PRINT @ddl
	FETCH NEXT FROM tblCursor INTO @val
	SET @count = @count + 1
END
CLOSE tblCursor
DEALLOCATE tblCursor