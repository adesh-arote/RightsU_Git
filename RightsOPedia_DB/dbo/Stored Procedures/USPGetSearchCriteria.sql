CREATE PROCEDURE [dbo].[USPGetSearchCriteria]
@UsersCode INT,
@DepartmentCode INT,
@BVCode INT
AS
BEGIN
	IF OBJECT_ID('tempdb..#TempSearchCriteria') IS NOT NULL DROP TABLE #TempSearchCriteria

	--INSERT INTO temp
	--SELECT @UsersCode, @DepartmentCode, @BVCode

	CREATE TABLE #TempSearchCriteria
	(
		Display_Name VARCHAR(1000), 
		Display_Order INT, 
		Control_Type CHAR(3), 
		View_Name VARCHAR(1000), 
		Lookup_Column VARCHAR(1000), 
		Display_Column VARCHAR(1000),
		Value_Field VARCHAR(1000),
		Text_Field NVARCHAR(1000),
		WhCondition VARCHAR(1000),
		Icon VARCHAR(100),
		Is_Mandatory CHAR(2),
		Css_Class NVARCHAR(1000)
	)
	
	INSERT INTO #TempSearchCriteria(Display_Name, Display_Order, Control_Type, View_Name, Lookup_Column, Display_Column,WhCondition,Icon,Is_Mandatory,Css_Class)
	Select Display_Name, Display_Order, Control_Type, View_Name, Lookup_Column, Display_Column,ISNULL(WhCondition, ''),Icon,Is_Mandatory,Css_Class from Report_Setup where Department_Code = @DepartmentCode AND Business_Vertical_Code = @BVCode --AND IsPartofSelectOnly = 'N'

	DECLARE 
		@ViewName VARCHAR(100),
		@ValueField VARCHAR(100),
		@TextField NVARCHAR(100),
		@Display_Name VARCHAR(100),
		@Display_Order VARCHAR(2),
		@Control_Type VARCHAR(3),
		@Lookup_Column VARCHAR(100),
		@Display_Column VARCHAR(100),
		@Icon VARCHAR(100),
		@Css_Class VARCHAR(100),
		@Is_Mandatory CHAR(2),
		@WhCondition VARCHAR(1000)
		--SELECT Display_Name,Display_Order,Control_Type,View_Name,Value_Field,Text_Field FROM #TempSearchCriteria WHERE Control_Type = 3
		print 'A'
		DECLARE db_cursor CURSOR FOR
			SELECT Display_Name,Display_Order,Control_Type,View_Name,Lookup_Column,Display_Column,Icon,Is_Mandatory,Css_Class, WhCondition FROM #TempSearchCriteria WHERE Control_Type = '3' AND View_Name <> 'Board'
		OPEN db_cursor
		FETCH NEXT FROM db_cursor INTO @Display_Name,@Display_Order,@Control_Type,@ViewName, @Lookup_Column,@Display_Column,@Icon,@Is_Mandatory,@Css_Class,@WhCondition
			WHILE @@FETCH_STATUS = 0
				BEGIN
		
				DECLARE @sqlcommand nvarchar(max)
				if(@Control_Type = 3)
					BEGIN
						SET @Control_Type = 'DDL'
					END
				else if(@Control_Type = 5)
					BEGIN
						SET @Control_Type = 'TTS'
					END
				else
					BEGIN
						SET @Control_Type = 'DR'
					END


				SET @sqlcommand = 'SELECT '''+@Display_Name+''','+@Display_Order+','''+@Control_Type+''','+ @Lookup_Column +','+ @Display_Column + ','''+@Icon+''','''+@Is_Mandatory+''','''+@Css_Class+''' FROM '+@ViewName+' WHERE 1 = 1 ' + @WhCondition
				--print  @sqlcommand
		
				INSERT INTO #TempSearchCriteria(Display_Name, Display_Order, Control_Type, Value_Field, Text_Field,Icon,Is_Mandatory,Css_Class)
				EXEC(@sqlcommand)

				FETCH NEXT FROM db_cursor INTO @Display_Name,@Display_Order,@Control_Type,@ViewName, @Lookup_Column,@Display_Column,@Icon,@Is_Mandatory,@Css_Class,@WhCondition

				END
			CLOSE db_cursor
			DEALLOCATE db_cursor

		IF(@BVCode = 21)
		 DELETE FrOm #TempSearchCriteria WHERE Display_Name IN ('Geography','Media Platform')
		
		Select Display_Name AS DisplayName, Display_Order AS DisplayOrder, Control_Type AS ControlType, View_Name AS ViewName, Lookup_Column AS LookupColumn, Display_Column AS DisplayColumn, Value_Field AS ValueField,
		Text_Field AS TextField,WhCondition,Icon,Is_Mandatory,Css_Class 
		from #TempSearchCriteria
		WHERE (Control_Type <> '3')
	

		IF OBJECT_ID('tempdb..#TempSearchCriteria') IS NOT NULL DROP TABLE #TempSearchCriteria
END

--EXEC USPGetSearchCriteria 0,7,19
