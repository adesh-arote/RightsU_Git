CREATE PROCEDURE [dbo].[USPSynSupplementaryTabData]
(
	@DepartmentCode NVARCHAR(1000),
	@BVCode NVARCHAR(1000),
	@TitleCode VARCHAR(MAX),
	@AcqDealCode VARCHAR(1000),
	@TabName NVARCHAR(MAX)	
)
AS
--Declare
--	@DepartmentCode NVARCHAR(1000) = 7,
--	@BVCode NVARCHAR(1000) = 19,
--	@TitleCode VARCHAR(MAX) = 42797, --34406,
--	@AcqDealCode VARCHAR(1000) = 25968, --5818, --25970,
--	@TabName NVARCHAR(MAX)	= 'Syndication Supplementary Tab'
BEGIN
	
	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempSupplementaryCursor') IS NOT NULL DROP TABLE #TempSupplementaryCursor

	CREATE TABLE #TempFields(
		ViewName VARCHAR(100),
		DisplayName VARCHAR(100),
		FieldOrder INT,
		ValidOpList VARCHAR(100)
	)	

	CREATE TABLE #TempSupplementaryCursor
	(
	    Supplementary_Code INT,
		Supplementary_Tab_Code INT,
		Supplementary_Tab_Description NVARCHAR(MAX),
		Data_Desc NVARCHAR(MAX),
		Data_Value NVARCHAR(MAX),
		Title_Code INT,
		Syn_Deal_Code INT
	)	

	INSERT INTO #TempFields(ViewName, DisplayName, FieldOrder, ValidOpList)
	SELECT View_Name, Display_Name, Display_Order, ValidOpList FROM Report_Setup WHERE Department_Code = @DepartmentCode AND Business_Vertical_Code = @BVCode AND IsPartofSelectOnly IN ('Y', 'B') AND ValidOpList = @TabName	
	
	IF EXISTS(SELECT TOP 1 * FROM #TempFields WHERE DisplayName IN ('Syndication Supplementary') AND ValidOpList = 'Syndication Supplementary Tab' )
	BEGIN
	
		PRINT 'Syndication Supplementary - Start'		
		
		INSERT INTO #TempSupplementaryCursor (Supplementary_Code, Supplementary_Tab_Code, Supplementary_Tab_Description, Data_Desc, Data_Value, Title_Code, Syn_Deal_Code)
		
		SELECT * FROM
			(SELECT sc.Supplementary_Code, sdsd.Supplementary_Tab_Code, st.Supplementary_Tab_Description,
			CASE WHEN Control_Type = 'TXTDDL' AND EditWindowType = 'inLine' THEN ISNULL(STUFF((SELECT  ', ' + CAST(x.DataDesc AS VARCHAR(Max))[text()] from 
								                (SELECT (SELECT Data_Description FROM Supplementary_Data sd WHERE sd.Supplementary_Data_Code IN (number)) AS DataDesc
												FROM [dbo].[fn_Split_withdelemiter](ISNULL(sdsd.Supplementary_Data_Code, ''), ','))x 
												FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' '),'' ) 
			     WHEN  EditWindowType = 'PopUp' THEN (SELECT Supplementary_Name FROM Supplementary WHERE Supplementary_Code=sc.Supplementary_Code) 
			ELSE NULL END AS Data_Desc,
			
			CASE WHEN Control_Type = 'TXTDDL' AND EditWindowType = 'inLine' THEN (SELECT User_Value FROM Syn_Deal_Supplementary_detail 
										WHERE Syn_Deal_Supplementary_Code = sdsd.Syn_Deal_Supplementary_Code 
										AND Supplementary_Tab_Code = sdsd.Supplementary_Tab_Code 
										AND Row_Num= sdsd.Row_Num
										AND Supplementary_Data_Code IS NULL) 
				 WHEN Control_Type = 'TXTDDL' AND EditWindowType = 'PopUp' THEN ISNULL(STUFF((SELECT  ', ' + CAST(x.DataDesc AS VARCHAR(Max))[text()] from 
								        (SELECT (SELECT Data_Description FROM Supplementary_Data sd WHERE sd.Supplementary_Data_Code IN (number)) AS DataDesc
										FROM [dbo].[fn_Split_withdelemiter](ISNULL(sdsd.Supplementary_Data_Code, ''), ','))x 
										FOR XML PATH(''), TYPE).value('.','NVARCHAR(MAX)'),1,2,' '),'' ) 
			ELSE User_Value END AS User_Value,sds.Title_code, sds.Syn_Deal_Code
			
			FROM Syn_Deal_Supplementary sds         
										 INNER JOIN Syn_Deal_Supplementary_detail sdsd ON sdsd.Syn_Deal_Supplementary_Code = sds.Syn_Deal_Supplementary_Code  
										 INNER JOIN Supplementary_Config sc ON sc.Supplementary_Config_Code = sdsd.Supplementary_Config_Code
										 INNER JOIN Supplementary_Tab st ON st.Supplementary_Tab_Code = sdsd.Supplementary_Tab_Code
			WHERE sds.title_code = @TitleCode AND sds.Syn_Deal_Code IN (SELECT DISTINCT Syn_Deal_Code FROM Syn_Acq_Mapping WHERE Deal_Code IN (@AcqDealCode))  ) AS T WHERE Data_Desc IS NOT NULL

		PRINT 'Syndication Supplementary - End'

	END

	SELECT 1 AS GroupOrder, tsc.Title_Code AS TitleCode, tsc.Syn_Deal_Code AS Deal_Code, ISNULL(tsc.Data_Desc,'NA') AS KeyField,
	       ISNULL(tsc.Data_Value,'NA') AS ValueField, ISNULL(tsc.Supplementary_Tab_Description,'NA') AS DataValue, tsc.Supplementary_Tab_Code AS FieldOrder, t.Title_Name AS TitleName, 
		   sd.Agreement_No AS AgreementNo, bu.Business_Unit_Name AS BusinessUnitName, dt.Deal_Type_Name AS DealType, sd.Deal_Description AS DealDescription
	FROM #TempSupplementaryCursor tsc
	INNER JOIN Syn_Deal sd ON sd.Syn_Deal_Code = tsc.Syn_Deal_Code
	INNER JOIN Title t ON t.Title_Code= tsc.Title_Code
	INNER JOIN Business_Unit bu ON bu.Business_Unit_Code = sd.Business_Unit_Code
	INNER JOIN Deal_Type dt ON dt.Deal_Type_Code = sd.Deal_Type_Code

	IF OBJECT_ID('tempdb..#TempFields') IS NOT NULL DROP TABLE #TempFields
	IF OBJECT_ID('tempdb..#TempSupplementaryCursor') IS NOT NULL DROP TABLE #TempSupplementaryCursor

END