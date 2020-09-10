SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

 CREATE   PROCEDURE [Tools].[Table$ListExtendedProperties]
	@schema_name_like sysname = '%',
	@table_name_like sysname = '%',
	@property_name_like sysname = '%'
------------------------------------------------------------------------
-- List the extended property on tables, based on a set of like expressions
--
-- 2020 Louis Davidson – drsql@hotmail.com – drsql.org 
------------------------------------------------------------------------

WITH EXECUTE AS OWNER --need extra rights to view extended properties
AS
 BEGIN
	SELECT schemas.name AS schema_name,  tables.name AS table_name, 
	       extended_properties.name AS property_name, 
		   extended_properties.value AS property_value
	FROM   sys.extended_properties 
	           JOIN sys.tables
				JOIN sys.schemas	
					ON tables.schema_id = schemas.schema_id
			ON tables.object_id = extended_properties.major_id
	WHERE  extended_properties.class_desc = 'OBJECT_OR_COLUMN'
	  AND  extended_properties.minor_id = 0
	  AND  schemas.name LIKE @schema_name_like
	  AND  tables.name LIKE @table_name_like
	  AND  extended_properties.name LIKE @property_name_like
	ORDER BY schema_name, table_name, property_name;
  END
GO
