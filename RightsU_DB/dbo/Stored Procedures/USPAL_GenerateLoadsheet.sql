CREATE PROCEDURE [dbo].[USPAL_GenerateLoadsheet]
@AL_Load_Sheet_Code INT,
@AL_Lab_Code VARCHAR(100)
AS

--DECLARE
--@AL_Load_Sheet_Code INT = 19,
--@AL_Lab_Code VARCHAR(100) = 'West Entertainment'

BEGIN
	--DECLARE
	--@AL_Load_Sheet_Code INT = 2079,
	--@AL_Lab_Code VARCHAR(100) = 'West Entertainment'
	----Select * from AL_Lab

	IF OBJECT_ID('tempdb..#template') IS NOT NULL DROP TABLE #template
	IF OBJECT_ID('tempdb..#final') IS NOT NULL DROP TABLE #final
	IF OBJECT_ID('tempdb..#view') IS NOT NULL DROP TABLE #view
	IF OBJECT_ID('tempdb..#temp_OEM') IS NOT NULL DROP TABLE #temp_OEM
	IF OBJECT_ID('tempdb..##tmp') IS NOT NULL DROP TABLE ##tmp
	IF OBJECT_ID('tempdb..#tempTrailorData') IS NOT NULL DROP TABLE #tempTrailorData
	IF OBJECT_ID('tempdb..#tempTableSchema') IS NOT NULL DROP TABLE #tempTableSchema
	IF OBJECT_ID('tempdb..#FinalOutput') IS NOT NULL DROP TABLE #FinalOutput

	CREATE TABLE #tempTableSchema
	(
		ColumnName VARCHAR(100)
	)

	CREATE TABLE #temp_OEM(
		Title_Content_Code INT,
		AL_BookingSheet_Code INT,
		AL_OEM_COde INT,
		Company_Name VARCHAR(100),
		Company_Short_Name VARCHAR(100),
		Device_Name VARCHAR(500),
		OEM_File_Name VARCHAR(500),
		OEM_Trailer_Name VARCHAR(500),
	)
	
	CREATE TABLE #final(
		Title_Content_Code INT, 
		AL_Booking_Sheet_Code INT,
		Display_Name VARCHAR(500), 
		Columns_Code INT, 
		Columns_Value VARCHAR(500), 
		Group_Control_Order INT,
		Company_Name VARCHAR(500), 
		Company_Short_Name VARCHAR(20),
		Device_Name	VARCHAR(500),
		OEM_File_Name VARCHAR(500),
		OEM_Trailer_Name VARCHAR(500)

	)
	
	UPDATE AL_Load_Sheet SET Status = 'W' WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code
	
	Select Columns_Code,Display_Name, Target_Column, egc.Group_Control_Order, egc.Default_Value 
	INTO #template
	from AL_Lab l
	INNER JOIN Extended_Group eg ON eg.Extended_Group_Code = l.Extended_Group_Code
	INNER JOIN Extended_Group_Config egc ON egc.Extended_Group_Code = eg.Extended_Group_Code
	WHERE l.AL_Lab_Name = @AL_Lab_Code--'Aeroplay Lab Limited'


	Select vw.Title_Content_Code, vw.AL_Booking_Sheet_Code INTO #view
	from vwBookingSheetData_LS vw 
	where vw.AL_Booking_Sheet_Code IN ( Select  AL_Booking_Sheet_Code from AL_Load_Sheet_Details WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code)
	AND vw.Columns_Code = 70 AND vw.Columns_Value = @AL_Lab_Code
	
	--INSERT INTO #temp_OEM(AL_OEM_Code, Company_Name, Company_Short_Name) 
	--SELECT DISTINCT o.AL_OEM_Code, o.Company_Name, o.Company_Short_Name from (
	--	Select * FROM Map_Extended_Columns WHERE Table_Name = 'AL_OEM' AND Columns_Code IN (
	--		Select Columns_Code from AL_Booking_Sheet_Details WHERE Columns_Code IN (
	--			Select DISTINCT Columns_Code from Extended_Group_Config WHERE Validations like '%&%'
	--		) AND Columns_Value = '1' AND AL_Booking_Sheet_Code IN (
	--			SELECT AL_Booking_Sheet_Code FROM AL_Load_Sheet_Details WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code
	--		)
	--	)
	--) AS A
	--INNER JOIN AL_OEM o ON o.AL_OEM_Code = A.Record_Code
	
	INSERT INTO #temp_OEM(Title_Content_Code, AL_BookingSheet_Code, AL_OEM_Code, Company_Name, Company_Short_Name) 
	SELECT DISTINCT bsd.Title_Content_Code, lsd.AL_Booking_Sheet_Code, om.AL_OEM_Code, om.Company_Name, om.Company_Short_Name
	FROM AL_Load_Sheet_Details lsd
	INNER JOIN AL_Booking_Sheet_Details bsd ON lsd.AL_Booking_Sheet_Code = bsd.AL_Booking_Sheet_Code
	INNER JOIN Map_Extended_Columns mec ON mec.Columns_Code = bsd.Columns_Code AND mec.Table_Name = 'AL_OEM'
	INNER JOIN AL_OEM om ON om.AL_OEM_Code = mec.Record_Code
	INNER JOIN #view v ON v.Title_Content_Code = bsd.Title_Content_Code AND v.AL_Booking_Sheet_Code = lsd.AL_Booking_Sheet_Code
	WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code AND Validations like '%&%' AND Columns_Value = '1'	

	--SELECT * FROM #temp_OEM
	--Device_Name VARCHAR(500),
	--	OEM_File_Name VARCHAR(500),
	--	OEM_Trailer_Name
	--SELECT * 

	
	UPDATE tom SET tom.OEM_File_Name = bsd.Columns_Value
	FROM #temp_OEM tom
	INNER JOIN Map_Extended_Columns mec ON tom.AL_OEM_Code = mec.Record_Code 
	INNER JOIN AL_Booking_Sheet_Details bsd ON tom.AL_BookingSheet_Code = bsd.AL_Booking_Sheet_Code AND tom.Title_Content_Code = bsd.Title_Content_Code AND mec.Columns_Code = bsd.Columns_Code
	WHERE mec.TABLE_Name = 'AL_OEM' AND mec.Columns_Code IN (142,168,176,182,200,237)

	UPDATE tom SET tom.OEM_Trailer_Name = bsd.Columns_Value
	FROM #temp_OEM tom
	INNER JOIN AL_Booking_Sheet_Details bsd ON tom.AL_BookingSheet_Code = bsd.AL_Booking_Sheet_Code AND tom.Title_Content_Code = bsd.Title_Content_Code
	WHERE bsd.Columns_Code IN (205)

	--SELECT *,
	UPDATE tom
	SET tom.Device_Name = 
		STUFF((
			SELECT ', ' + ec.Columns_Name FROM AL_Load_Sheet_Details lsd
			INNER JOIN AL_Booking_Sheet_Details bsd ON lsd.AL_Booking_Sheet_Code = bsd.AL_Booking_Sheet_Code
			INNER JOIN Map_Extended_Columns mec ON mec.Columns_Code = bsd.Columns_Code AND mec.Table_Name = 'AL_OEM'
			INNER JOIN AL_OEM om ON om.AL_OEM_Code = mec.Record_Code
			INNER JOIN Extended_Columns ec ON ec.Columns_Code = bsd.Columns_Code
			WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code AND Validations like '%&%' AND Columns_Value = '1'
			AND bsd.Title_Content_Code = tom.Title_Content_Code
			AND lsd.AL_Booking_Sheet_Code = tom.AL_BookingSheet_Code
			AND om.AL_OEM_Code = tom.AL_OEM_Code
			FOR XML PATH('')), 1, 2, ''
		)
	FROM #temp_OEM tom
	
	PRINT '1'
	
	INSERT INTO #final(Title_Content_Code, AL_Booking_Sheet_Code, Display_Name, Columns_Code, Columns_Value, Group_Control_Order, Company_Name, Company_Short_Name, Device_Name, OEM_File_Name, OEM_Trailer_Name)
	SELECT toem.Title_Content_Code, AL_BookingSheet_Code, Display_Name, t.Columns_Code, t.Default_Value, Group_Control_Order, toem.Company_Name, toem.Company_Short_Name, Device_Name, OEM_File_Name, OEM_Trailer_Name 
	FROM #temp_OEM toem
	INNER JOIN #template t ON 1 = 1
	
	--INSERT INTO #final(Title_Content_Code, AL_Booking_Sheet_Code, Display_Name, Columns_Code, Columns_Value, Group_Control_Order, Company_Name, Company_Short_Name)
	--SELECT intbl.Title_Content_Code, AL_Booking_Sheet_Code, Display_Name, t.Columns_Code, t.Default_Value, Group_Control_Order, toem.Company_Name, toem.Company_Short_Name FROM (
	--	SELECT DISTINCT vwbs.Title_Content_Code, vwbs.AL_Booking_Sheet_Code FROM vwBookingSheetData_LS vwbs
	--	INNER JOIN AL_Load_Sheet_Details lsd ON vwbs.AL_Booking_Sheet_Code = lsd.AL_Booking_Sheet_Code
	--	INNER JOIN #view v ON v.Title_Content_Code = vwbs.Title_Content_Code AND v.AL_Booking_Sheet_Code = lsd.AL_Booking_Sheet_Code
	--	WHERE lsd.AL_Load_Sheet_Code = @AL_Load_Sheet_Code
	--) AS intbl
	--INNER JOIN #template t ON 1 = 1
	--INNER JOIN #temp_OEM toem ON toem.Title_Content_Code = intbl.Title_Content_Code

	UPDATE  fn SET fn.Columns_Value = vwbs.Columns_Value
	--SELECT fn.AL_Booking_Sheet_Code, vwbs.AL_Booking_Sheet_Code  ,fn.Columns_Value , vwbs.Columns_Value, fn.Columns_Code, vwbs.Columns_Code, fn.Title_Content_Code, vwbs.Title_Content_Code
	FROM #final fn
	INNER JOIN vwBookingSheetData_LS vwbs ON vwbs.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code 
	AND fn.Title_Content_Code = vwbs.Title_Content_Code AND fn.Columns_Code = vwbs.Columns_Code
	AND ISNULL(vwbs.Columns_Value,'') <> ''
	
	--Select * FROM #final WHERE Title_Content_Code IN (34233, 34232) AND Columns_Code = 214

	
	UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
	FROM #final fn
	INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
	AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (141,167,175,181,221) AND fn.Display_Name = 'Aspect Ratio'
	
	
	IF(@AL_Lab_Code = 'Above')
	BEGIN
		UPDATE fn SET fn.Columns_Value = (SELECT FORMAT(Inserted_On, 'dd-MMM-yyyy') from AL_Load_Sheet WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code)
		FROM #final fn
		WHERE fn.Display_Name = 'Date REquested'

		UPDATE fn SET fn.Columns_Value = (SELECT FORMAT(Inserted_On, 'yyyy-MM') from AL_Load_Sheet WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code)
		FROM #final fn
		WHERE fn.Display_Name = 'Cycle (YYYY-MM)'

	END

	IF(@AL_Lab_Code = 'West Entertainment')
	BEGIN
		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (140, 166, 174, 180, 222) AND fn.Display_Name = 'Feature Format'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (82) AND fn.Display_Name = 'PO#'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (58) AND fn.Display_Name = 'New/Holdover/Re-License'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (77) AND fn.Display_Name = 'Genre 1'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (138,163,171,178,185,231) AND fn.Display_Name = 'Category 1'

		
	END
	
	IF(@AL_Lab_Code = 'The Hub' OR @AL_Lab_Code = 'Aerolab')
	BEGIN
		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (140, 166, 174, 180, 222) AND fn.Display_Name = 'MPEG'

		UPDATE fn SET fn.Columns_Value = (SELECT FORMAT(Inserted_On, 'dd-MMM-yyyy') from AL_Load_Sheet WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code)
		FROM #final fn
		WHERE fn.Display_Name = 'Date Added'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (82) AND fn.Display_Name = 'PO#'

		
		--Select bsd.Columns_Value, * --from #final
		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (138,163,171,178,185,231) AND fn.Display_Name = 'Category'

		--UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		--FROM #final fn
		--INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		--AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (138,163,171,178,185) AND fn.Display_Name = 'Category'
	END
	
	IF(@AL_Lab_Code = 'The Hub' OR @AL_Lab_Code = 'CMI')
	BEGIN
		UPDATE fn SET fn.Columns_Value = v.Short_Code
		FROM #final fn
		INNER JOIN AL_Booking_Sheet bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code-- AND bsd.Title_Content_Code = fn.Title_Content_Code
		INNER JOIN Vendor v ON v.Vendor_Code = bsd.Vendor_Code
		WHERE fn.Display_Name = 'A/L'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (138,163,171,178,185,231) AND fn.Display_Name = 'Category'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (82) AND fn.Display_Name = 'PO#'
		
	END
	
	IF(@AL_Lab_Code = 'Anuvu')
	BEGIN
		UPDATE fn SET fn.Columns_Value = (SELECT FORMAT(Inserted_On, 'dd/MMM/yyyy') from AL_Load_Sheet WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code)
		FROM #final fn
		WHERE fn.Display_Name = 'Date Added'
		
		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (141,167,175,181,221) AND fn.Display_Name = 'Aspect Ratio (If 16:9 is not availble the send 4:3)'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (140, 166, 174, 180, 222) AND fn.Display_Name = 'MPEG Type'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (87) AND fn.Display_Name = 'Embed Subs 1'

	END

	IF(@AL_Lab_Code = 'CMI')
	BEGIN
		UPDATE fn SET fn.Columns_Value = (SELECT FORMAT(Inserted_On, 'dd/MMM/yyyy') from AL_Load_Sheet WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code)
		FROM #final fn
		WHERE fn.Display_Name = 'Date Added'

		UPDATE fn SET fn.Columns_Value = bsd.Columns_Value
		FROM #final fn
		INNER JOIN AL_Booking_Sheet_Details bsd ON bsd.AL_Booking_Sheet_Code = fn.AL_Booking_Sheet_Code AND bsd.Title_Content_Code = fn.Title_Content_Code
		AND ISNULL(bsd.Columns_Value,'') <> '' AND bsd.Columns_Code IN (140, 166, 174, 180, 222) AND fn.Display_Name = 'MPEG'
	END

	PRINT '2'
	
	--SELECT * FROM #final WHERE (Display_Name = 'MOVIE / SERIES TITLE' OR Display_Name = 'DUE DATE' OR Display_Name = 'EPISODE #')
	--RETURN

	--SELECT DistINCT vwbs.Title_Content_Code ,ls.AL_Load_Sheet_Code, lsd.AL_Booking_Sheet_Code, 
	--t.Display_Name, vwbs.Columns_Value, t.Group_Control_Order, toem.Company_Name, toem.Company_Short_Name 
	--INTO #final
	--FROM AL_Load_Sheet ls
	--INNER JOIN AL_Load_Sheet_Details lsd ON lsd.AL_Load_Sheet_Code = ls.AL_Load_Sheet_Code
	--INNER JOIN vwBookingSheetData_LS vwbs ON vwbs.AL_Booking_Sheet_Code = lsd.AL_Booking_Sheet_Code
	--INNER JOIN #template t ON t.Columns_Code = vwbs.Columns_Code
	--INNER JOIN #view v ON v.Title_Content_Code = vwbs.Title_Content_Code AND v.AL_Booking_Sheet_Code = lsd.AL_Booking_Sheet_Code
	--INNER JOIN #temp_OEM toem ON 1=1 
	--WHERE ls.AL_Load_Sheet_Code = @AL_Load_Sheet_Code  AND vwbs.Title_Content_Code IN (
	--	Select vw.Title_Content_Code from vwBookingSheetData_LS vw where vw.AL_Booking_Sheet_Code = vwbs.AL_Booking_Sheet_Code 
	--	AND vw.Columns_Code = 70 AND vw.Columns_Value = @AL_Lab_Code
	--)
	--ORDER BY t.Group_Control_Order 
	--UNION
	--SELECT DistINCT vwbs.Title_Content_Code ,ls.AL_Load_Sheet_Code, lsd.AL_Booking_Sheet_Code, 
	--t.Display_Name, vwbs.Columns_Value, t.Group_Control_Order, toem.Company_Name, toem.Company_Short_Name 
	----INTO #final
	--FROM AL_Load_Sheet ls
	--INNER JOIN AL_Load_Sheet_Details lsd ON lsd.AL_Load_Sheet_Code = ls.AL_Load_Sheet_Code
	--INNER JOIN vwBookingSheetData_LS vwbs ON vwbs.AL_Booking_Sheet_Code = lsd.AL_Booking_Sheet_Code
	--INNER JOIN #template t ON t.Columns_Code = vwbs.Columns_Code
	--INNER JOIN #view v ON v.Title_Content_Code = vwbs.Title_Content_Code AND v.AL_Booking_Sheet_Code = lsd.AL_Booking_Sheet_Code
	--INNER JOIN #temp_OEM toem ON 1=1 
	--WHERE vwbs.Columns_name = 'Lang 1' AND vwbs.Columns_Value = 'HIndi'
	--AND vwbs.Columns_name = 'Trailer-in-house' AND vwbs.Columns_Value = ''
	--AND vwbs.Columns_name = 'Title Type' AND vwbs.Columns_Value = 'Movie'
	--ORDER BY t.Group_Control_Order 

	
	--RETURN
	DECLARE @ColNames NVARCHAR(MAX) 

	SELECT @ColNames = STUFF((
		SELECT ', [' + t.Display_Name + ']'  
		FROM #template t
		ORDER BY Group_Control_Order
		FOR XML PATH('')), 1, 2, ''
	)

	PRINT '3'
	--Select * from #final

	DECLARE @query NVARCHAR(MAX) 
	SELECT @query = 'Select * into ##tmp from ( Select tb.Title_Content_Code, tb.Company_Name, tb.Company_Short_Name , tb.Display_Name, tb.Columns_Value, Device_Name, OEM_File_Name, OEM_Trailer_Name from #final tb ) a
					 pivot (max(Columns_Value) for Display_Name in ('+@ColNames+')) p'

	PRINT '4'
	PRINT @query
	EXEC (@query)

	IF(@AL_Lab_Code = 'West Entertainment')
	BEGIN
		UPDATE ##tmp SET [System] = Device_Name, [Filename] = OEM_File_Name, [Hardware Vendor] = Company_Name, [Ship To] = Company_Short_Name,
		[Trailer Format ] = '',[Trailer Qty] = '',[Trailer Filename]=''

	END

	IF(@AL_Lab_Code = 'The Hub')
	BEGIN
	
		UPDATE ##tmp SET [System] = Company_Short_Name, [Filename] = OEM_File_Name, [Trailer Filename] = ''
	END

	IF(@AL_Lab_Code = 'Anuvu')
	BEGIN
		UPDATE ##tmp SET [System] = Device_Name, [Filename] = OEM_File_Name,[Ship To] = Company_Short_Name
	END

	IF(@AL_Lab_Code = 'CMI')
	BEGIN
		UPDATE ##tmp SET [Trailer Filename] = '', [System] = Company_Short_Name, [Filename] = OEM_File_Name
	END

	IF(@AL_Lab_Code = 'Aerolab')
	BEGIN
		UPDATE ##tmp SET [Trailer Filename] = '', [System (OEM devices EACH)] = Company_Short_Name, [Filename] = OEM_File_Name
	END

	IF(@AL_Lab_Code = 'Above')
	BEGIN
		UPDATE ##tmp SET [System] = Company_Short_Name
	END

	DECLARE @tblBookingSheetCodes TABLE (
		BookingSheetCodes INT
	)

	DECLARE @TitleContentIntersect TABLE (
		TitleContentCode INT,
		Vendor_Name VARCHAR(1000)
	)

	INSERT INTO @tblBookingSheetCodes(BookingSheetCodes)
	SELECT AL_Booking_Sheet_Code FROM AL_Load_Sheet_Details WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code 

	INSERT INTO @TitleContentIntersect
	SELECT Title_Content_Code, v.Vendor_Name FROM AL_Booking_Sheet_Details  bsd
	INNER JOIN  AL_Booking_Sheet bs ON bsd.AL_Booking_Sheet_Code = bs.AL_Booking_Sheet_Code
	INNER JOIN Vendor v ON v.Vendor_Code = bs.Vendor_Code
	WHERE COlumns_Code =  78 AND Columns_Value = 'English'AND bsd.AL_Booking_Sheet_Code IN (SELECT BookingSheetCodes FROM @tblBookingSheetCodes )
	INTERSECT
	SELECT Title_Content_Code, v.Vendor_Name FROM AL_Booking_Sheet_Details  bsd
	INNER JOIN  AL_Booking_Sheet bs ON bsd.AL_Booking_Sheet_Code = bs.AL_Booking_Sheet_Code
	INNER JOIN Vendor v ON v.Vendor_Code = bs.Vendor_Code
	WHERE COlumns_Code =  63 AND Columns_Value = 'Movie' AND bsd.AL_Booking_Sheet_Code IN (SELECT BookingSheetCodes FROM @tblBookingSheetCodes )
	INTERSECT
	SELECT Title_Content_Code, v.Vendor_Name FROM AL_Booking_Sheet_Details  bsd
	INNER JOIN  AL_Booking_Sheet bs ON bsd.AL_Booking_Sheet_Code = bs.AL_Booking_Sheet_Code
	INNER JOIN Vendor v ON v.Vendor_Code = bs.Vendor_Code 
	WHERE COlumns_Code =  83 AND ISNULL(Columns_Value,'') = '' AND bsd.AL_Booking_Sheet_Code IN (SELECT BookingSheetCodes FROM @tblBookingSheetCodes )	
	
	IF EXISTS(SELECT * from ##tmp WHERE Title_Content_Code IN (Select TitleContentCode FROM @TitleContentIntersect))
	BEGIN
		PRINT 'Inside Trailor'
		Select 0 AS row_num,* INTO #tempTrailorData from ##tmp

		DELETE FROM #tempTrailorData
			
		----INSERT INTO #tempTrailorData
		----Select top 1 * from ##tmp WHERE Title_Content_Code IN (Select TitleContentCode FROM @TitleContentIntersect)
		
		--INSERT INTO #tempTrailorData
		--SELECT * from (
		--	SELECT ROW_NUMBER() OVER (PARTITION BY Title_Content_Code ORDER BY  Title_Content_Code) AS row_num,* FROM 
		--	##tmp AS tmp WHERE Title_Content_Code IN (Select TitleContentCode FROM @TitleContentIntersect tci WHERE tmp.Airline = tci.Vendor_Name)
		--) AS a
		--WHERE a.row_num = 1		

		If NOT EXISTS (SELECT * FROM tempdb.information_schema.columns WHERE table_name like'##tmp' AND column_name = 'Airline')
		BEGIN
			INSERT INTO #tempTrailorData
			SELECT * from (
				SELECT ROW_NUMBER() OVER (PARTITION BY Title_Content_Code ORDER BY  Title_Content_Code) AS row_num,* FROM 
				##tmp AS tmp WHERE Title_Content_Code IN (Select TitleContentCode FROM @TitleContentIntersect)
			) AS a
			WHERE a.row_num = 1
		END
		ELSE
		BEGIN
			INSERT INTO #tempTrailorData
			SELECT * from (
				SELECT ROW_NUMBER() OVER (PARTITION BY Title_Content_Code ORDER BY  Title_Content_Code) AS row_num,* FROM 
				##tmp AS tmp WHERE Title_Content_Code IN (Select TitleContentCode FROM @TitleContentIntersect tci WHERE tmp.Airline = tci.Vendor_Name)
			) AS a
			WHERE a.row_num = 1
		END
		
		ALTER TABLE #tempTrailorData DROP COLUMN row_num

		INSERT INTO #tempTableSchema(ColumnName)
		SELECT name
		FROM   tempdb.sys.columns
		WHERE  object_id = Object_id('tempdb..#tempTrailorData'); 
		
		IF(@AL_Lab_Code = 'West Entertainment')
		BEGIN
			UPDATE  td  SET td.[Program Type (ex. Movie/Short/Trailer/Other.)] = 'Trailer', td.[Hardware Vendor] = '', td.[System] = '', td.[Version] = 'Trailer', td.[Trailer Aspect Ratio] = [Aspect Ratio], 
			td.[Trailer Format ] = [Feature Format],
			td.[Feature Qty] = '0', td.[Trailer Qty] = '1', td.[Ship To] = 'Aeroplay',
			td.[Aspect Ratio] = '', td.[Feature Format] = '',td.[Filename] = '', td.[Trailer Filename] = [OEM_Trailer_Name], td.[DRM/NON-DRM] = '',
			td.[Hardware File Due Date] = bsd.Columns_Value
			FROM #tempTrailorData td
			LEFT JOIN AL_Booking_Sheet_Details bsd ON td.Title_Content_Code = bsd.Title_Content_Code AND bsd.Columns_Code = 215
			AND bsd.AL_Booking_Sheet_Code IN (SELECT BookingSheetCodes FROM @tblBookingSheetCodes )
		END

		IF(@AL_Lab_Code = 'The Hub')
		BEGIN

			
			UPDATE  td  SET td.[System] = 'Trailer to Aeroplay', td.[Version] = 'Trailer', td.[MPEG] = '', td.[Aspect Ratio] = '', td.[Filename] = '', td.[Trailer Filename] = [OEM_Trailer_Name],
			td.[Master file Delivery Date] = bsd.Columns_Value
			FROM #tempTrailorData td
			LEFT JOIN AL_Booking_Sheet_Details bsd ON td.Title_Content_Code = bsd.Title_Content_Code AND bsd.Columns_Code = 215
			AND bsd.AL_Booking_Sheet_Code IN (SELECT BookingSheetCodes FROM @tblBookingSheetCodes )

		END

		IF(@AL_Lab_Code = 'Anuvu')
		BEGIN
			

			UPDATE  td  SET td.[System] = 'None', td.[Movie / Trailer / Short] = 'Trailer', td.[Ship To] = 'Aeroplay', td.[Bill To] = 'Aeroplay', td.[Filename] = [OEM_Trailer_Name],td.[MPEG Type] = 'ProRes',
			td.[Version] = 'Trailer', td.[Due Date] = bsd.Columns_Value
			FROM #tempTrailorData td
			LEFT JOIN AL_Booking_Sheet_Details bsd ON td.Title_Content_Code = bsd.Title_Content_Code AND bsd.Columns_Code = 215
			AND bsd.AL_Booking_Sheet_Code IN (SELECT BookingSheetCodes FROM @tblBookingSheetCodes )
			
		END

		IF(@AL_Lab_Code = 'CMI')
		BEGIN
			
			UPDATE  td  SET td.[System] = 'Trailer to Aeroplay', td.[Filename] = '',  td.[Trailer Filename] = [OEM_Trailer_Name], td.[Version] = 'Trailer',
			td.[Master file Delivery Date] = bsd.Columns_Value
			FROM #tempTrailorData td
			LEFT JOIN AL_Booking_Sheet_Details bsd ON td.Title_Content_Code = bsd.Title_Content_Code AND bsd.Columns_Code = 215
			AND bsd.AL_Booking_Sheet_Code IN (SELECT BookingSheetCodes FROM @tblBookingSheetCodes )
			

		END

		IF(@AL_Lab_Code = 'Aerolab')
		BEGIN
			
			UPDATE  td  SET td.[System (OEM devices EACH)] = 'Trailer', td.[Filename] = '',  td.[Trailer Filename] = [OEM_Trailer_Name], td.[Version] = 'Trailer',
			td.[Master file Delivery Date] = bsd.Columns_Value
			FROM #tempTrailorData td
			LEFT JOIN AL_Booking_Sheet_Details bsd ON td.Title_Content_Code = bsd.Title_Content_Code AND bsd.Columns_Code = 215
			AND bsd.AL_Booking_Sheet_Code IN (SELECT BookingSheetCodes FROM @tblBookingSheetCodes )
			
		END
			
		--IF EXISTS(Select * FROM #tempTableSchema WHERE ColumnName = 'Category')
		--BEGIN

		--	UPDATE  td  SET td.[Category] = 'Trailor' FROM #tempTrailorData td

		--END
			
		--ALTER TABLE ##tmp DROP COLUMN Title_Content_Code
		ALTER TABLE ##tmp DROP COLUMN Company_Name
		--ALTER TABLE ##tmp DROP COLUMN Company_Short_Name

		--ALTER TABLE #tempTrailorData DROP COLUMN Title_Content_Code
		ALTER TABLE #tempTrailorData DROP COLUMN Company_Name
		--ALTER TABLE #tempTrailorData DROP COLUMN Company_Short_Name
		
		ALTER TABLE ##tmp DROP COLUMN Company_Short_Name
		ALTER TABLE ##tmp DROP COLUMN Device_Name	
		ALTER TABLE ##tmp DROP COLUMN OEM_File_Name	
		ALTER TABLE ##tmp DROP COLUMN OEM_Trailer_Name
		
		
		ALTER TABLE #tempTrailorData DROP COLUMN Company_Short_Name
		ALTER TABLE #tempTrailorData DROP COLUMN Device_Name	
		ALTER TABLE #tempTrailorData DROP COLUMN OEM_File_Name	
		ALTER TABLE #tempTrailorData DROP COLUMN OEM_Trailer_Name
		ALTER TABLE ##tmp DROP COLUMN Title_Content_Code
		ALTER TABLE #tempTrailorData DROP COLUMN Title_Content_Code

		IF(@AL_Lab_Code = 'West Entertainment' OR @AL_Lab_Code = 'The Hub' OR @AL_Lab_Code = 'CMI' OR @AL_Lab_Code = 'Aerolab')
		BEGIN
			SELECT * FROM (
				Select * from ##tmp
				UNION 
				Select * from #tempTrailorData
			) AS A
			ORDER BY A.Title
		END
		ELSE IF(@AL_Lab_Code = 'Anuvu')
		BEGIN
			SELECT ROW_NUMBER() OVER (PARTITION BY [Airline] ORDER BY A.[English Title]) row_num, * 
			INTO #FinalOutputAnuvu
			FROM (
				Select * from ##tmp
				UNION 
				Select * from #tempTrailorData
			) AS A
			ORDER BY A.[English Title]

			UPDATE t SET t.[Line Item ID] = row_num
			FROM #FinalOutputAnuvu t

			ALTER TABLE #FinalOutputAnuvu DROP COLUMN row_num

			Select * from #FinalOutputAnuvu
		END
		ELSE IF(@AL_Lab_Code = 'Above')
		BEGIN

			ALTER TABLE ##tmp ADD [ITEM #] INT

			SELECT ROW_NUMBER() OVER (PARTITION BY [AIRLINE/IATA Code] ORDER BY A.[MOVIE / SERIES TITLE], A.[EPISODE NAME]) row_num, * 
			INTO #FinalOutputAbove
			FROM (
				Select * from ##tmp
				UNION 
				Select * from #tempTrailorData
			) AS A
			ORDER BY A.[MOVIE / SERIES TITLE], A.[EPISODE NAME]

			UPDATE t SET [ITEM #] = row_num
			FROM #FinalOutputAbove t

			ALTER TABLE #FinalOutputAbove DROP COLUMN row_num

			Select * from #FinalOutputAbove

		END
		
	
	
	END
	ELSE
	BEGIN
	PRINT 'No Trailor'

		ALTER TABLE ##tmp DROP COLUMN Title_Content_Code
		--ALTER TABLE ##tmp DROP COLUMN Company_Name
		ALTER TABLE ##tmp DROP COLUMN Company_Short_Name

		--Select * from ##tmp

		IF(@AL_Lab_Code = 'West Entertainment' OR @AL_Lab_Code = 'The Hub')
		BEGIN
			Select * from ##tmp A
			ORDER BY A.Title
		END
		ELSE IF(@AL_Lab_Code = 'Anuvu')
		BEGIN

			ALTER TABLE ##tmp ADD [ITEM #] INT

			UPDATE B SET B.[ITEM #] = B.row_num
			FROM (
				SELECT ROW_NUMBER() OVER (PARTITION BY [Airline] ORDER BY [English Title] ) row_num,* 
				FROM ##tmp A
			) AS B

			SELECT * from ##tmp A
			ORDER BY A.[English Title]
			
		END
		ELSE IF(@AL_Lab_Code = 'Above')
		BEGIN
			
			--SELECT * 
			UPDATE B SET B.[ITEM #] = B.row_num
			FROM (
				SELECT ROW_NUMBER() OVER (PARTITION BY [AIRLINE/IATA Code] ORDER BY [MOVIE / SERIES TITLE], [EPISODE NAME] ) row_num,* 
				FROM ##tmp A
			) AS B

			SELECT * from ##tmp A
			ORDER BY A.[MOVIE / SERIES TITLE], A.[EPISODE NAME]
		END
		ELSE
		BEGIN
			SELECT * FROM ##tmp
		END
	END

	

	
	--SELECT * FROM ##tmp WHERE [Lang 1] = 'English' AND Title

	--IF(@AL_Lab_Code = 'West Entertainment Limited')
	--BEGIN

	--	SELECT top 10 * FROM Title
		
	--	--UPDATE Device

	--	SELECT * FROM ##tmp
	--END
	
	--IF(@AL_Lab_Code = 'Aeroplay Lab Limited')
	--BEGIN
	--	SELECT top 10 * FROM Talent
	--END

	--IF(@AL_Lab_Code = 'Eastern Entertainment')
	--BEGIN
	--	SELECT top 10 * FROM Genres
	--END

	--IF(@AL_Lab_Code = 'The HUB')
	--BEGIN
	--	SELECT top 10 * FROM Country
	--END

	--UPDATE AL_Load_Sheet SET Status = 'D' WHERE AL_Load_Sheet_Code = @AL_Load_Sheet_Code

	IF OBJECT_ID('tempdb..#template') IS NOT NULL DROP TABLE #template
	IF OBJECT_ID('tempdb..#final') IS NOT NULL DROP TABLE #final
	IF OBJECT_ID('tempdb..#view') IS NOT NULL DROP TABLE #view
	IF OBJECT_ID('tempdb..#temp_OEM') IS NOT NULL DROP TABLE #temp_OEM
	IF OBJECT_ID('tempdb..##tmp') IS NOT NULL DROP TABLE ##tmp
	IF OBJECT_ID('tempdb..#tempTrailorData') IS NOT NULL DROP TABLE #tempTrailorData
	IF OBJECT_ID('tempdb..#tempTableSchema') IS NOT NULL DROP TABLE #tempTableSchema
	IF OBJECT_ID('tempdb..#FinalOutputAbove') IS NOT NULL DROP TABLE #FinalOutputAbove
	IF OBJECT_ID('tempdb..#FinalOutputAnuvu') IS NOT NULL DROP TABLE #FinalOutputAnuvu
	
	--DROP TABLE ##tmp
END
