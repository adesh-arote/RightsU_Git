CREATE PROCEDURE [dbo].[USPListResolveConflict]
	@DM_Master_Import_Code VARCHAR(MAX) = '0',
	@Code INT = 0,	
	@FileType VARCHAR(1) = '',
	@PageNo INT = 1,
	@PageSize INT = 99,
	@RecordCount INT OUT
AS
/*=============================================
Author:			
Create date:	11 Feb, 2019
Description:	
--===============================================*/
BEGIN
--DECLARE
--	@DM_Master_Import_Code VARCHAR(MAX) = '10169',
--	@Code INT = 17,	
--	@FileType VARCHAR(1) = 'T',
--	@PageNo INT = 1,
	--@PageSize INT = 10,
	--@RecordCount INT 

	IF(OBJECT_ID('TEMPDB..#TempRoles') IS NOT NULL)
		DROP TABLE #TempRoles
	IF(OBJECT_ID('TEMPDB..#tempMasterLog') IS NOT NULL)
		DROP TABLE #tempMasterLog
    IF(OBJECT_ID('TEMPDB..#temp') IS NOT NULL)
		DROP TABLE #temp	
		
	CREATE TABLE #tempMasterLog
	(
		Row_No INT IDENTITY(1,1),		
		DMMasterLogCode NVARCHAR(MAX),	
		MasterType NVARCHAR(MAX),
		Type VARCHAR(MAX),
		ImportData NVARCHAR(MAX),
		MappedTo NVARCHAR(MAX),
		MappedBy NVARCHAR(MAX),		
		ActionBy NVARCHAR(MAX),
		MappedDate Datetime,
		DMMasterImportCode NVARCHAR(MAX)
	)

	CREATE TABLE #temp
	(
		Row_No INT IDENTITY(1,1),			
		Type VARCHAR(MAX),
		ImportData NVARCHAR(MAX),
		MappedTo NVARCHAR(MAX),
		MappedBy NVARCHAR(MAX),	
		ActionBy NVARCHAR(MAX),
		MappedDate Datetime
	)


	SELECT DML.DM_Master_Log_Code , LTRIM(RTRIM(number)) AS ROLE INTO #TempRoles
	FROM DM_Master_Log DML 
	CROSS APPLY dbo.fn_Split_withdelemiter(Roles,',') 
	WHERE LTRIM(RTRIM(ISNULL(Roles, ''))) <> '' 
	AND DML.DM_Master_Import_Code = @DM_Master_Import_Code 
					   
	INSERT INTO #tempMasterLog(DMMasterLogCode,  MasterType, Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate, DMMasterImportCode)
	SELECT DISTINCT DML.DM_Master_Log_Code, DML.Master_Type,
		CASE WHEN DML.Master_Type = 'TA' THEN TR.Role
			 WHEN DML.Master_Type = 'LB' THEN 'Music Label'
			 WHEN DML.Master_Type = 'GE' THEN 'Genres'
			 WHEN DML.Master_Type = 'MA' THEN 'Movie/Album'
			 WHEN DML.Master_Type = 'ML' THEN 'Language'
			 WHEN DML.Master_Type = 'MT' THEN 'Theme'
			 WHEN DML.Master_Type = 'TT' THEN 'Title Type'
			 WHEN DML.Master_Type = 'TL' THEN 'Title Language'
			 WHEN DML.Master_Type = 'OL' THEN 'Original Language'
			 WHEN DML.Master_Type = 'PC' THEN 'Program Category'
			 WHEN DML.Master_Type = 'CM' THEN 'Music Track'
		END AS Type, 
		DML.Name, 
		CASE WHEN DML.Master_Type = 'TA' THEN T.Talent_Name
			 WHEN DML.Master_Type = 'LB' THEN LB.Music_Label_Name
			 WHEN DML.Master_Type = 'GE' THEN G.Genres_Name
			 WHEN DML.Master_Type = 'MA' THEN MA.Music_Album_Name
			 WHEN DML.Master_Type = 'ML' THEN ML.Language_Name
			 WHEN DML.Master_Type = 'MT' THEN MT.Music_Theme_Name
			 WHEN DML.Master_Type = 'TT' THEN DT.Deal_Type_Name
			 WHEN DML.Master_Type = 'TL' THEN TL.Language_Name
			 WHEN DML.Master_Type = 'OL' THEN TL.Language_Name
			 WHEN DML.Master_Type = 'PC' THEN ECV.Columns_Value
			 WHEN DML.Master_Type = 'CM' THEN TM.Music_Title_Name
		END AS MappedTo,
		CASE WHEN (DML.Mapped_By = 'U' AND DML.Master_Code IS NOT NULL)THEN 'Users'
			 WHEN (DML.Mapped_By = 'S' OR DML.Mapped_By = 'V' AND DML.Master_Code IS NOT NULL )THEN 'System'
		END AS MappedBy, 
		CASE WHEN (DML.Mapped_By = 'U' AND DML.Master_Code IS NOT NULL) THEN U.First_Name
		     ELSE '' END,
		CASE WHEN DML.Master_Code IS NOT NULL THEN DML.Action_On
			 ELSE NULL END,
	DML.DM_Master_Import_Code
	FROM DM_Master_Log DML
	LEFT JOIN Users U ON DML.Action_By = U.Users_Code
	LEFT JOIN Talent T ON T.Talent_Code = DML.Master_Code
	LEFT JOIN Music_Label LB ON LB.Music_Label_Code = DML.Master_Code
	LEFT JOIN Genres G ON G.Genres_Code = DML.Master_Code
	LEFT JOIN Music_Album MA ON MA.Music_Album_Code = DML.Master_Code
	LEFT JOIN Music_Language ML ON ML.Music_Language_Code = DML.Master_Code
	LEFT JOIN Music_Theme MT ON MT.Music_Theme_Code = DML.Master_Code
	LEFT JOIN Deal_Type DT ON DT.Deal_Type_Code = DML.Master_Code
	LEFT JOIN Language TL ON TL.Language_Code = DML.Master_Code
	LEFT JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = DML.Master_Code
	LEFT JOIN Music_Title TM ON TM.Music_Title_Code = DML.Master_Code
	LEFT JOIN #TempRoles TR ON DML.DM_Master_Log_Code = TR.DM_Master_Log_Code
	
	WHERE @DM_Master_Import_Code = '0' OR DML.DM_Master_Import_Code IN(SELECT number FROM dbo.fn_Split_withdelemiter(''+@DM_Master_Import_Code+'',','))  
					
	IF(@FileType = 'M')
	BEGIN
		IF(OBJECT_ID('TEMPDB..#TempSinger') IS NOT NULL)
			DROP TABLE #TempSinger
		IF(OBJECT_ID('TEMPDB..#TempMusicComposer') IS NOT NULL)
			DROP TABLE #TempMusicComposer
		IF(OBJECT_ID('TEMPDB..#TempStarCast') IS NOT NULL)
			DROP TABLE #TempStarCast   
		IF(OBJECT_ID('TEMPDB..#TempLyricist') IS NOT NULL)
			DROP TABLE #TempLyricist  
        IF(OBJECT_ID('TEMPDB..#TempLanguage') IS NOT NULL)
			DROP TABLE #TempLanguage
		IF(OBJECT_ID('TEMPDB..#TempTheme') IS NOT NULL)
			DROP TABLE #TempTheme

		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Singers INTO #TempSinger
		FROM DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Singers],',') 
		WHERE LTRIM(RTRIM(ISNULL([Singers], ''))) <> '' 
		AND DMT.IntCode = @Code

		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Composers INTO #TempMusicComposer
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Music_Director,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Music_Director, ''))) <> '' 
		AND DMT.IntCode = @Code

		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS StarCast INTO #TempStarCast
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Star_Cast,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Star_Cast, ''))) <> '' 
		AND DMT.IntCode = @Code

		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Lyricist INTO #TempLyricist
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Lyricist,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Lyricist, ''))) <> '' 
		AND DMT.IntCode = @Code
		
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Language INTO #TempLanguage
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Title_Language,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Title_Language, ''))) <> '' 
		AND DMT.IntCode = @Code
		
		SELECT DMT.IntCode, LTRIM(RTRIM(number)) AS Theme INTO #TempTheme
		from DM_Music_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter(DMT.Theme,',') 
		WHERE LTRIM(RTRIM(ISNULL(DMT.Theme, ''))) <> '' 
		AND DMT.IntCode = @Code

	    INSERT INTO #temp(Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate)
		SELECT DISTINCT Type, 
		CASE WHEN (t.MasterType = 'TA' AND t.Type = 'Music Composer')THEN (SELECT TMS.Composers where TMS.Composers COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'Singers')THEN (SELECT TS.Singers where TS.Singers COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'star cast')THEN (SELECT TSC.StarCast where TSC.StarCast COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'Lyricist')THEN (SELECT TL.Lyricist where TL.Lyricist COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
		     WHEN t.MasterType = 'GE' THEN (SELECT DMT.Genres where DMT.Genres COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS))
			 WHEN (t.MasterType = 'ML' OR t.MasterType = 'TL') THEN (SELECT LT.Language where LT.Language COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'MA' THEN (SELECT DMT.Movie_Album WHERE DMT.Movie_Album COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'MT' THEN (SELECT TT.Theme WHERE TT.Theme COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'LB' THEN (SELECT DMT.Music_Label WHERE DMT.Music_Label COLLATE SQL_Latin1_General_CP1_CI_AS IN(SELECT t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS))
		END AS ImportData, 
		MappedTo, MappedBy, ActionBy, MappedDate
		FROM #tempMasterLog t 
		INNER JOIN DM_Music_Title DMT ON DMT.DM_Master_Import_Code = t.DMMasterImportCode
		LEFT Join #TempSinger TS ON DMT.IntCode = TS.IntCode
		LEFT JOIN #TempMusicComposer TMS ON DMT.IntCode = TMS.IntCode
		LEFT JOIN #TempStarCast TSC ON DMT.IntCode = TSC.IntCode		
		LEFT JOIN #TempLanguage LT ON DMT.IntCode = LT.IntCode
		LEFT JOIN #TempTheme TT ON DMT.IntCode = TT.IntCode
		LEFT JOIN #TempLyricist TL ON DMT.IntCode = TL.IntCode
		WHERE DMT.IntCode = @Code   
	END		

	IF(@FileType = 'T')
	BEGIN
		DECLARE @Str_Contenate NVARCHAR(MAX) 

		SELECT @Str_Contenate = CONCAT(Col3,'-',Col4,'-',Col5,'-',Col6,'-',Col7,'-',Col8,'-',Col9,'-',Col10,'-',Col11,'-',Col12,'-',Col13,'-',Col14,'-',Col15,'-',Col16,'-',Col17,'-',Col18,'-',Col19,'-',Col20,'-',Col21,'-',Col22,'-',Col23,'-',Col24,'-',Col25,'-',Col26,'-',Col27,'-',Col28,'-',Col29,'-',Col30,'-',Col31,'-',Col32,'-',Col33,'-',Col34,'-',Col35,'-',Col36,'-',Col37,'-',Col38,'-',Col39,'-',Col40,'-',Col41,'-',Col42,'-',Col43,'-',Col44,'-',Col45,'-',Col46,'-',Col47,'-',Col48,'-',Col49,'-',Col50,'-',Col51,'-',Col52,'-',Col53,'-',Col54,'-',Col55,'-',Col56,'-',Col57,'-',Col58,'-',Col59,'-',Col60,'-',Col61,'-',Col62,'-',Col63,'-',Col64,'-',Col65,'-',Col66,'-',Col67,'-',Col68,'-',Col69,'-',Col70,'-',Col71,'-',Col72,'-',Col73,'-',Col74,'-',Col75,'-',Col76,'-',Col77,'-',Col78,'-',Col79,'-',Col80,'-',Col81,'-',Col82,'-',Col83,'-',Col84,'-',Col85,'-',Col86,'-',Col87,'-',Col88,'-',Col89,'-',Col90,'-',Col91,'-',Col92,'-',Col93,'-',Col94,'-',Col95,'-',Col96,'-',Col97,'-',Col98,'-',Col99,'-',Col100)
		FROM DM_Title_Import_Utility_Data  DT WHERE DM_Master_Import_Code =  @DM_Master_Import_Code AND DM_Title_Import_Utility_Data_Code = @Code

		INSERT INTO #temp(Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate)
		SELECT Distinct Type,ImportData,MappedTo, MappedBy, ActionBy, MappedDate
		FROM #tempMasterLog t
		WHERE T.DMMasterLogCode IN (SELECT DM_Master_Log_Code FROM DM_Master_Log WHERE DM_Master_Import_Code = @DM_Master_Import_Code and @Str_Contenate like '%'+Name+'%')
	END
		
	
	IF(@FileType = 'C')
	BEGIN
		INSERT INTO #temp(Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate)
		SELECT DISTINCT Type, 
		CASE WHEN t.MasterType = 'CM' THEN (SELECT DCM.Music_Track  WHERE DCM.Music_Track COLLATE SQL_Latin1_General_CP1_CI_AS IN (t.ImportData COLLATE SQL_Latin1_General_CP1_CI_AS)) 
		END AS ImportData, 
		MappedTo, MappedBy, ActionBy, MappedDate
		FROM #tempMasterLog t
		INNER JOIN DM_Content_Music DCM ON DCM.DM_Master_Import_Code = t.DMMasterImportCode   
		WHERE  DCM.IntCode = @Code 
	END

	SELECT Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate FROM #temp t WHERE t.ImportData IS NOT NULL

	IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	IF OBJECT_ID('tempdb..#TempComposer') IS NOT NULL DROP TABLE #TempComposer
	IF OBJECT_ID('tempdb..#TempDirector') IS NOT NULL DROP TABLE #TempDirector
	IF OBJECT_ID('tempdb..#TempKeyStarCast') IS NOT NULL DROP TABLE #TempKeyStarCast
	IF OBJECT_ID('tempdb..#TempLanguage') IS NOT NULL DROP TABLE #TempLanguage
	IF OBJECT_ID('tempdb..#TempLyricist') IS NOT NULL DROP TABLE #TempLyricist
	IF OBJECT_ID('tempdb..#tempMasterLog') IS NOT NULL DROP TABLE #tempMasterLog
	IF OBJECT_ID('tempdb..#TempMusicComposer') IS NOT NULL DROP TABLE #TempMusicComposer
	IF OBJECT_ID('tempdb..#TempRoles') IS NOT NULL DROP TABLE #TempRoles
	IF OBJECT_ID('tempdb..#TempSinger') IS NOT NULL DROP TABLE #TempSinger
	IF OBJECT_ID('tempdb..#TempStarCast') IS NOT NULL DROP TABLE #TempStarCast
	IF OBJECT_ID('tempdb..#TempTheme') IS NOT NULL DROP TABLE #TempTheme

END