
ALTER PROCEDURE [dbo].[USPListResolveConflict]
@DM_Master_Import_Code VARCHAR(MAX) = '0',
@Code INT = 0,	
@FileType VARCHAR(1) = '',
@PageNo INT = 1,
@PageSize INT = 99,
@RecordCount INT OUT
AS
/*=============================================
Author:			Darshana
Create date:	11 Feb, 2019
Description:	
===============================================*/
BEGIN
--DECLARE
--	@DM_Master_Import_Code VARCHAR(MAX) = '7470',
--	@Code INT = 6275,	
--	@FileType VARCHAR(1) = 'M',
--	@PageNo INT = 1,
--	@PageSize INT = 10,
--	@RecordCount INT OUT

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


	SELECT DML.DM_Master_Log_Code , LTRIM(RTRIM(number)) AS Role Into #TempRoles
	from DM_Master_Log DML 
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
	from DM_Master_Log DML
	Left Join Users U ON DML.Action_By = U.Users_Code
	Left Join Talent T ON T.Talent_Code = DML.Master_Code
	Left Join Music_Label LB ON LB.Music_Label_Code = DML.Master_Code
	Left Join Genres G ON G.Genres_Code = DML.Master_Code
	Left Join Music_Album MA ON MA.Music_Album_Code = DML.Master_Code
	Left Join Music_Language ML ON ML.Music_Language_Code = DML.Master_Code
	Left Join Music_Theme MT ON MT.Music_Theme_Code = DML.Master_Code
	Left Join Deal_Type DT ON DT.Deal_Type_Code = DML.Master_Code
	Left Join Language TL ON TL.Language_Code = DML.Master_Code
	Left Join Extended_Columns_Value ECV ON ECV.Columns_Value_Code = DML.Master_Code
	Left Join Music_Title TM ON TM.Music_Title_Code = DML.Master_Code
	Left Join #TempRoles TR ON DML.DM_Master_Log_Code = TR.DM_Master_Log_Code
	
	Where @DM_Master_Import_Code = '0' OR DML.DM_Master_Import_Code IN(select number from dbo.fn_Split_withdelemiter(''+@DM_Master_Import_Code+'',','))  
					
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
		from DM_Music_Title DMT
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
		CASE WHEN (t.MasterType = 'TA' AND t.Type = 'Music Composer')THEN (select TMS.Composers where TMS.Composers collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'Singers')THEN (select TS.Singers where TS.Singers collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'star cast')THEN (select TSC.StarCast where TSC.StarCast collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'Lyricist')THEN (select TL.Lyricist where TL.Lyricist collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
		     WHEN t.MasterType = 'GE' THEN (select DMT.Genres where DMT.Genres collate SQL_Latin1_General_CP1_CI_AS IN(select t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
			 WHEN (t.MasterType = 'ML' OR t.MasterType = 'TL') THEN (select LT.Language where LT.Language collate SQL_Latin1_General_CP1_CI_AS IN(select t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'MA' THEN (select DMT.Movie_Album where DMT.Movie_Album collate SQL_Latin1_General_CP1_CI_AS IN(select t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'MT' THEN (select TT.Theme where TT.Theme collate SQL_Latin1_General_CP1_CI_AS IN(select t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'LB' THEN (select DMT.Music_Label where DMT.Music_Label collate SQL_Latin1_General_CP1_CI_AS IN(select t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
		END as ImportData, 
		MappedTo, MappedBy, ActionBy, MappedDate
		from #tempMasterLog t 
		Inner Join DM_Music_Title DMT ON DMT.DM_Master_Import_Code = t.DMMasterImportCode
		LEFT Join #TempSinger TS ON DMT.IntCode = TS.IntCode
		LEFT JOIN #TempMusicComposer TMS ON DMT.IntCode = TMS.IntCode
		LEFT JOIN #TempStarCast TSC ON DMT.IntCode = TSC.IntCode		
		LEFT JOIN #TempLanguage LT ON DMT.IntCode = LT.IntCode
		LEFT JOIN #TempTheme TT ON DMT.IntCode = TT.IntCode
		LEFT JOIN #TempLyricist TL ON DMT.IntCode = TL.IntCode
		Where DMT.IntCode = @Code   
	END	

	IF(@FileType = 'T')
	BEGIN
		IF(OBJECT_ID('TEMPDB..#TempKeyStarCast') IS NOT NULL)
			DROP TABLE #TempKeyStarCast
		IF(OBJECT_ID('TEMPDB..#TempDirector') IS NOT NULL)
			DROP TABLE #TempDirector
		IF(OBJECT_ID('TEMPDB..#TempComposer') IS NOT NULL)
			DROP TABLE #TempComposer

		SELECT DM_Title_Code, LTRIM(RTRIM(number)) AS StarCast INTO #TempKeyStarCast from DM_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Key Star Cast],',') 
		WHERE LTRIM(RTRIM(ISNULL([Key Star Cast], ''))) <> '' 
		AND DMT.DM_Title_Code = @Code

		SELECT DM_Title_Code, LTRIM(RTRIM(number)) AS Director INTO #TempDirector from DM_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Director Name],',') 
		WHERE LTRIM(RTRIM(ISNULL([Director Name], ''))) <> '' 
		AND DMT.DM_Title_Code = @Code

		SELECT DM_Title_Code, LTRIM(RTRIM(number)) AS Composer INTO #TempComposer from DM_Title DMT
		CROSS APPLY dbo.fn_Split_withdelemiter([Music Composer],',') 
		WHERE LTRIM(RTRIM(ISNULL([Music Composer], ''))) <> '' 
		AND DMT.DM_Title_Code = @Code
		
		INSERT INTO #temp(Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate)
		SELECT Distinct Type,
		CASE WHEN t.MasterType = 'TT' THEN (select DT.[Title Type] where DT.[Title Type] collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
		  	 WHEN t.MasterType = 'TL' THEN (select DT.[Original Language (Hindi)] where DT.[Original Language (Hindi)] collate SQL_Latin1_General_CP1_CI_AS IN(select t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'OL' THEN (select DT.Original_Language where DT.Original_Language collate SQL_Latin1_General_CP1_CI_AS IN(select t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
			 WHEN t.MasterType = 'LB' THEN (select DT.Music_Label where DT.Music_Label collate SQL_Latin1_General_CP1_CI_AS IN(select t.ImportData collate SQL_Latin1_General_CP1_CI_AS))
			 WHEN (t.MasterType = 'TA' AND t.Type = 'Music Composer')THEN (select TC.Composer Where TC.Composer collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'Director')THEN (select TD.Director where TD.Director collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN (t.MasterType = 'TA' AND t.Type = 'Star Cast')THEN (select TKST.StarCast where TKST.StarCast collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
			 WHEN t.MasterType = 'PC' THEN (select DT.[Program Category] where DT.[Program Category] collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
		END as ImportData,
		MappedTo, MappedBy, ActionBy, MappedDate
		from #tempMasterLog t
		LEFT Join DM_Title DT ON DT.DM_Master_Import_Code = t.DMMasterImportCode	
		LEFT Join #TempKeyStarCast TKST ON DT.DM_Title_Code = TKST.DM_Title_Code
		LEFT Join #TempDirector TD ON DT.DM_Title_Code = TD.DM_Title_Code
		LEFT Join #TempComposer TC ON DT.DM_Title_Code = TC.DM_Title_Code
		where DT.DM_Title_Code = @Code
	END
	
	IF(@FileType = 'C')
	BEGIN
		INSERT INTO #temp(Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate)
		SELECT DISTINCT Type, 
		CASE WHEN t.MasterType = 'CM' THEN (select DCM.Music_Track  where DCM.Music_Track collate SQL_Latin1_General_CP1_CI_AS IN (t.ImportData collate SQL_Latin1_General_CP1_CI_AS)) 
		END as ImportData, 
		MappedTo, MappedBy, ActionBy, MappedDate
		from #tempMasterLog t
		Inner Join DM_Content_Music DCM ON DCM.DM_Master_Import_Code = t.DMMasterImportCode   
		where  DCM.IntCode = @Code 
	END

	select Type, ImportData, MappedTo, MappedBy, ActionBy, MappedDate from #temp t where t.ImportData IS NOT NULL
END




--DECLARE @RC INT = 0
--EXEC USPListResolveConflict '7470',6275,'M',1,10,@RC

--ALTER PROCEDURE [dbo].[USPListResolveConflict] 
--@DM_Master_Import_Code VARCHAR(MAX) = '0',
--@Code INT = 0,	
--@FileType VARCHAR(1) = '',
--@PageNo INT = 1,
--@PageSize INT = 99,
--@RecordCount INT OUT
--AS
--BEGIN

--DECLARE @Type VARCHAR(MAX) = '',
--		@ImportData NVARCHAR(MAX)='',
--		@MappedTo NVARCHAR(MAX)='',
--		@MappedBy NVARCHAR(MAX)='',	
--		@ActionBy NVARCHAR(MAX)='',
--		@MappedDate Datetime=GETDATE()

--select @Type Type, @ImportData ImportData, @MappedTo MappedTo, @MappedBy MappedBy, @MappedDate MappedDate, @ActionBy ActionBy 
--END