
CREATE PROCEDURE [dbo].[USP_Audit_Log_Report_for_Territory_and_Language_Group]
 @Search_Key NVARCHAR(MAX),
 @Log CHAR
AS
BEGIN

	SET FMTONLY OFF

	IF @Search_Key <> ''
		SET @Search_Key = '%' + @Search_Key + '%'
	
	CREATE TABLE #Temp3(
		Agreement_No VARCHAR(20),
		Affected_Dates VARCHAR(20),
		Territory_Name NVARCHAR(1000),
		Country_Names NVARCHAR(MAX),
		Language_Group_Name NVARCHAR(1000),
		Language_Names NVARCHAR(MAX),
		Language_Type VARCHAR(10),
		UserName NVARCHAR(50)
	)

	IF @Log = 'T'
	BEGIN
		
		CREATE TABLE #Temp(
			Agreement_No VARCHAR(20),
			Deal_Type CHAR,
			Affected_Date DATE,
			Territory_Name VARCHAR(500),
			Country_Codes INT,
			UserName VARCHAR(50)
		)


		INSERT INTO #Temp (Agreement_No,Affected_Date,Territory_Name,Deal_Type, UserName, Country_Codes)
		SELECT AD.Agreement_No, Affected_Date, T.Territory_Name, TDL.Deal_Type, U.Login_Name, number AS Country_Codes
		FROM Territory_Deal_Log TDL
		INNER JOIN Users U ON U.Users_Code = TDL.User_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = TDL.Deal_Code AND TDL.Deal_Type='A'
		INNER JOIN Territory T ON T.Territory_Code = TDL.Territory_Code
		CROSS APPLY dbo.fn_Split_withdelemiter(TDL.Country_Codes,',') AS TEMP


		INSERT INTO #Temp (Agreement_No,Affected_Date,Territory_Name,Deal_Type, UserName, Country_Codes)
		SELECT SD.Agreement_No, Affected_Date, T.Territory_Name, TDL.Deal_Type, U.Login_Name, number AS Country_Codes
		FROM Territory_Deal_Log TDL
		INNER JOIN Users U ON U.Users_Code = TDL.User_Code
		INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code = TDL.Deal_Code AND TDL.Deal_Type='S'
		INNER JOIN Territory T ON T.Territory_Code = TDL.Territory_Code
		CROSS APPLY dbo.fn_Split_withdelemiter(TDL.Country_Codes,',') AS TEMP

		--SELECT *,'temp' FROM #Temp

		
		INSERT INTO #Temp3 (Agreement_No, Affected_Dates, Language_Group_Name, Language_Names, 
			Territory_Name, Country_Names, UserName, Language_Type)
		SELECT DISTINCT T.Agreement_No, CONVERT(VARCHAR(20),T.Affected_Date,103) Affected_Dates,'' Language_Group_Name, '' Language_Name, 
			T.Territory_Name, C.Country_Name, T.UserName, '' Language_Type
		FROM #Temp T
		INNER JOIN Country C ON C.Country_Code = T.Country_Codes
		WHERE (@Search_Key <> '' AND (UserName LIKE @Search_Key OR Agreement_No LIKE @Search_Key
			OR T.Territory_Name LIKE @Search_Key OR Country_Name LIKE @Search_Key
			OR CONVERT(VARCHAR(20),Affected_Date,103) LIKE @Search_Key))
			OR (@Search_Key = '')
		

		DROP TABLE #Temp
	END
	ELSE
	BEGIN
		CREATE TABLE #Temp2(
			Agreement_No VARCHAR(20),
			Deal_Type CHAR,
			Affected_Date DATE,
			Language_Codes INT,
			Language_Type CHAR,
			Language_Group_Name NVARCHAR(MAX),
			UserName NVARCHAR(50)
		)

		INSERT INTO #Temp2 (Agreement_No, Affected_Date, Language_Group_Name, Language_Type, Deal_Type, UserName, Language_Codes)
		SELECT AD.Agreement_No, Affected_Date, LG.Language_Group_Name, LDL.Language_Type, LDL.Deal_Type, 
			U.Login_Name, number AS Language_Codes
		FROM Language_Deal_Log LDL
		INNER JOIN Users U ON U.Users_Code = LDL.User_Code
		INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = LDL.Deal_Code AND LDL.Deal_Type='A'
		INNER JOIN Language_Group LG ON LG.Language_Group_Code = LDL.Language_Group_Code
		CROSS APPLY dbo.fn_Split_withdelemiter(LDL.Language_Codes,',') AS TEMP


		INSERT INTO #Temp2 (Agreement_No, Affected_Date, Language_Group_Name, Language_Type, Deal_Type, UserName, Language_Codes)
		SELECT SD.Agreement_No, Affected_Date, LG.Language_Group_Name, LDL.Language_Type, LDL.Deal_Type, 
			U.Login_Name, number AS Language_Codes
		FROM Language_Deal_Log LDL
		INNER JOIN Users U ON U.Users_Code = LDL.User_Code
		INNER JOIN Syn_Deal SD ON SD.Syn_Deal_Code = LDL.Deal_Code AND LDL.Deal_Type='S'
		INNER JOIN Language_Group LG ON LG.Language_Group_Code = LDL.Language_Group_Code
		CROSS APPLY dbo.fn_Split_withdelemiter(LDL.Language_Codes,',') AS TEMP
		
		--SELECT *,'temp2' FROM #Temp2
		
		INSERT INTO #Temp3 (Agreement_No, Affected_Dates, Language_Group_Name, Language_Names, 
			Territory_Name, Country_Names, UserName, Language_Type)
		SELECT DISTINCT T.Agreement_No, CONVERT(VARCHAR(20), T.Affected_Date,103), T.Language_Group_Name,
			L.Language_Name, '' Territory_Name, '' Country_Name, T.UserName,
		CASE WHEN T.Language_Type = 'S' THEN 'Subtitling' ELSE 'Dubbing' END AS Language_Type
		FROM #Temp2 T
		INNER JOIN Language L ON L.Language_Code = T.Language_Codes
		WHERE (@Search_Key <> '' AND (UserName LIKE @Search_Key  OR  Agreement_No LIKE @Search_Key
			OR  Language_Group_Name LIKE @Search_Key  OR  Language_Name LIKE @Search_Key
			OR  CONVERT(VARCHAR(20),Affected_Date,103) LIKE @Search_Key))
			OR  (@Search_Key = '')
		
		
		DROP TABLE #Temp2	
	END
	
	--SELECT *,'temp3' FROM #Temp3
		
	IF @Log = 'T'
	BEGIN
		SELECT DISTINCT Agreement_No, Affected_Dates, Territory_Name, 
			STUFF((SELECT DISTINCT ', ' + t1.Country_Names
					FROM #Temp3 t1
					WHERE  t1.Agreement_No = T.Agreement_No AND t1.Affected_Dates=T.Affected_Dates AND t1.UserName = T.UserName
					FOR XML PATH, TYPE).value('.','NVARCHAR(MAX)')
					,1,2,'') Country_Names,
			Language_Group_Name, Language_Names, Language_Type,UserName
		FROM #Temp3 T
	END
	ELSE
	BEGIN
		SELECT DISTINCT Agreement_No, Affected_Dates, Territory_Name, Country_Names, Language_Group_Name,
			STUFF((SELECT DISTINCT ', ' + t1.Language_Names
					FROM #Temp3 t1
					WHERE  t1.Agreement_No = T.Agreement_No AND t1.Affected_Dates=T.Affected_Dates AND t1.UserName = T.UserName
					FOR XML PATH, TYPE).value('.','NVARCHAR(MAX)')
					,1,2,'') Language_Names,
			Language_Type, UserName
		FROM #Temp3 T
	END
	
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#Temp2') IS NOT NULL DROP TABLE #Temp2
	IF OBJECT_ID('tempdb..#Temp3') IS NOT NULL DROP TABLE #Temp3
END

/*
EXEC USP_Audit_Log_Report_for_Territory_and_Language_Group '', 'T'
*/
