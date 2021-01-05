
CREATE PROCEDURE [dbo].[USP_Get_Dashboard_Detail]
(
	--DECLARE 
	@DashboardType varchar(10)='AE',
	@SearchFor NVARCHAR(1000) ='',
	@User_Code INT = 143,
	@DashboardDays INT=30
)
AS
 --=============================================
 --Author:		<Rajesh Godse / Akshay Rane>
 --Create date: <18 Dec 2014>
 --Description:	<Dashboard Details>
 --Last Updated By:	<Akshay Rane>
 --=============================================
BEGIN
	SET NOCOUNT ON;
	--DECLARE 
	--@DashboardType varchar(10)='AA',
	--@SearchFor NVARCHAR(1000) ='',
	--@User_Code INT = 211,
	--@DashboardDays INT=30
	/**************************************Show Hide Deal View button on the basis of Rights******************************************/
	DECLARE @UserSecCode  INT = 0,@Module_Code INT = 30,@Is_Deal_Rights CHAR(1)= 'N'
	IF(@DashboardType = 'SS' OR @DashboardType = 'SE' OR @DashboardType = 'SR')
	BEGIN
		SET @Module_Code = 35
	END
	SELECT @UserSecCode = Security_Group_Code FROM Users WHERE Users_Code = @User_Code  
	SELECT DISTINCT @Is_Deal_Rights = CASE WHEN SMR.Module_Code = @Module_Code THEN 'Y' ELSE 'N' END
	FROM System_Module_Right SMR
	INNER JOIN Security_Group_Rel sgr ON smr.Module_Right_Code = sgr.System_Module_Rights_Code AND sgr.Security_Group_Code = @UserSecCode
	WHERE Module_Code IN(@Module_Code)
	/********************************************************************************/
  --Declare @DashboardDays AS int
	Declare @StartDate AS date
	Declare @EndDate AS date
	Declare @Search As NVarchar(2000)
	Declare @SQL As NVarchar(MAX)
  --SET @DashboardDays = (SELECT ISNULL(Parameter_Value,'') AS Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Dashboard_Days')
	
	IF(@DashboardType = 'AA' OR @DashboardType = 'SA')
	BEGIN
		SET @StartDate = (SELECT CONVERT(date,GETDATE() -  @DashboardDays,103))
		SET @EndDate = (SELECT CONVERT(date,GETDATE() ,103))
	END
	ELSE
	BEGIN
		SET @StartDate = (SELECT CONVERT(date,GETDATE(),103))
		SET @EndDate = (SELECT CONVERT(date,GETDATE() + @DashboardDays,103))
	END

    SET @Search = ''
    SET @SQL = ''
    if(LEN(@SearchFor) > 0)
		 SET @Search = ' and( TitleName LIKE N''%'+@SearchFor+'%''OR Customer LIKE N''%'+@SearchFor+'%'' OR Agreement_No LIKE ''%'+@SearchFor+'%'')'
   --  PRINT @SearchFor
	--Query to Get Deals which starts in next @DashboardDays days
	IF(@DashboardType = 'AS')
	BEGIN	
	SET @SQL = 'SELECT * FROM (SELECT DISTINCT '''+@Is_Deal_Rights+''' AS Is_Deal_Rights,d.Acq_deal_code AS Deal_Code,d.Agreement_No,v.Vendor_Name AS Customer,
	STUFF((SELECT Distinct '','' + ISNULL(Title_Name,Original_Title)
	FROM Acq_Deal_Movie ADM       
	INNER JOIN Title T On T.title_code = ADM.Title_Code    
	WHERE ADM.Acq_Deal_Code = d.Acq_Deal_Code
	FOR XML PATH('''')),1,1,'''') AS TitleName,
	(SELECT SUM(Deal_Cost) AS Deal_Cost FROM Acq_Deal_Cost WHERE Acq_Deal_Code = d.Acq_Deal_Code) AS Deal_Movie_Cost,
	RightPeriod = CASE ADR.Right_Type
	WHEN ''U'' THEN ''Perpetuity'' 
	ELSE (Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_Start_Date as datetime),103) as Varchar)+ ''  -  '' + Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_End_Date as datetime),103) as Varchar))
	END,ADR.Actual_Right_Start_Date FROM Acq_Deal d
	INNER JOIN Acq_Deal_Rights AS ADR ON ADR.Acq_Deal_Code = d.Acq_Deal_Code
	INNER JOIN dbo.Vendor AS v ON v.vendor_code = d.Vendor_Code
	LEFT OUTER JOIN Acq_Deal_Cost AS ADC ON ADC.Acq_Deal_Code = d.Acq_Deal_Code 
	WHERE  d.Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND  d.Business_Unit_Code IN(select Business_Unit_Code from Users_Business_Unit U where U.Users_Code = '+CAST(@User_Code AS VARCHAR(50))+'))as Temp
	WHERE CONVERT(date,Actual_Right_Start_Date,103)BETWEEN '''+ cast(@StartDate as varchar(50)) +''' and '''+ cast(@EndDate as varchar(50))+'''' + @Search 
	+' Order by Actual_Right_Start_Date ASC'
		EXEC(@SQL)
	END
	ELSE
	IF(@DashboardType = 'AE')
	BEGIN
	--Query to Get Deals which expires in next @DashboardDays days

	IF OBJECT_ID('tempdb..#Temp_Acq_Expiry') IS NOT NULL
		DROP TABLE #Temp_Acq_Expiry

	Declare @Temp_Acq Table(
			 Agreement_No NVARCHAR(MAX),
			 Customer NVARCHAR(MAX), 
			 Deal_Code INT,
			 Right_End_Date DATETIME, 
			 Deal_Movie_Cost DECIMAL,
			 RightPeriod NVARCHAR(MAX),
			 TitleName NVARCHAR(MAX)
		)

	INSERT INTO @Temp_Acq EXEC USP_Dashboard_AcqSyn_Expiry '', @DashboardDays ,'A','N',@User_Code

	SELECT * INTO #Temp_Acq_Expiry FROM @Temp_Acq

	SET @SQL =	'SELECT * FROM ( SELECT DISTINCT '''+@Is_Deal_Rights+''' AS Is_Deal_Rights, Agreement_No, Customer, Deal_Code, Right_End_Date, Deal_Movie_Cost, RightPeriod, TitleName FROM #Temp_Acq_Expiry ) as Temp
		WHERE CONVERT(date, Right_End_Date,103)BETWEEN '''+ cast(@StartDate as varchar(50)) +''' and '''+ cast(@EndDate as varchar(50))+'''' + @Search
		+' Order by Right_End_Date ASC'
		
		EXEC(@SQL)
	END
	ELSE
	IF(@DashboardType = 'SS')
	BEGIN
	--Query to Get Deals which starts in next @DashboardDays days
	SET @SQL =	'SELECT * FROM (SELECT DISTINCT '''+@Is_Deal_Rights+''' AS Is_Deal_Rights,d.Syn_Deal_Code AS Deal_Code,d.Agreement_No,v.Vendor_Name AS Customer,
	STUFF((SELECT DISTINCT '','' + ISNULL(Title_Name,Original_Title)
	FROM Syn_Deal_Movie SDM      
	INNER JOIN Title T On T.title_code = SDM.Title_Code    
	WHERE SDM.Syn_Deal_Code = d.Syn_Deal_Code 
	FOR XML PATH('''')),1,1,'''') AS TitleName,
	(SELECT SUM(Deal_Cost) AS Deal_Cost FROM Acq_Deal_Cost WHERE Acq_Deal_Code = d.Syn_Deal_Code) AS Deal_Movie_Cost,
	RightPeriod = CASE SDR.Right_Type
	WHEN ''U'' THEN ''Perpetuity'' 
	ELSE (Cast(Convert(VARCHAR(11),cast(SDR.Actual_Right_Start_Date as datetime),103) as Varchar)+ ''  -  '' + Cast(Convert(VARCHAR(11),cast(SDR.Actual_Right_End_Date as datetime),103) as Varchar))
	END,SDR.Actual_Right_Start_Date FROM Syn_Deal d
	INNER JOIN Syn_Deal_Rights AS SDR ON SDR.Syn_Deal_Code = d.Syn_Deal_Code
	INNER JOIN dbo.Vendor AS v ON v.vendor_code = d.Vendor_Code 
	WHERE Business_Unit_Code IN(select Business_Unit_Code from Users_Business_Unit  where Users_Code = '+CAST(@User_Code AS VARCHAR(50))+'))as Temp
	WHERE CONVERT(date,Actual_Right_Start_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' and '''+ cast(@EndDate as varchar(50))+'''' + @Search
	+ ' Order by Actual_Right_Start_Date ASC'
	
		EXEC(@SQL)
	END
	ELSE
	IF(@DashboardType = 'SE')
	BEGIN
	--Query to Get Deals which expires in next @DashboardDays days

	IF OBJECT_ID('tempdb..#Temp_Syn_Expiry') IS NOT NULL
		DROP TABLE #Temp_Syn_Expiry

	Declare @Temp_Syn Table(
			 Agreement_No NVARCHAR(MAX),
			 Customer NVARCHAR(MAX), 
			 Deal_Code INT,
			 Right_End_Date DATETIME, 
			 Deal_Movie_Cost DECIMAL,
			 RightPeriod NVARCHAR(MAX),
			 TitleName NVARCHAR(MAX)
		)

	INSERT INTO @Temp_Syn EXEC USP_Dashboard_AcqSyn_Expiry '',@DashboardDays,'S','N',@User_Code

	SELECT * INTO #Temp_Syn_Expiry FROM @Temp_Syn

    SET @SQL = 'SELECT * FROM ( SELECT DISTINCT '''+@Is_Deal_Rights+''' AS Is_Deal_Rights, Agreement_No, Customer, Deal_Code, Right_End_Date, Deal_Movie_Cost, RightPeriod, TitleName FROM #Temp_Syn_Expiry ) as Temp
	WHERE CONVERT(date,Right_End_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' and '''+ cast(@EndDate as varchar(50))+'''' + @Search
	+' Order by Right_End_Date ASC '
		
		EXEC(@SQL)
	END
	ELSE
	IF(@DashboardType = 'AA')
	BEGIN
	--Query to Get Deals which Approved in next @DashboardDays days
		CREATE TABLE #Acq_Deals (
			Acq_Deal_Code INT,
			Agreement_No NVARCHAR(MAX),
			Vendor_Code INT,
			Status_Changed_On DATETIME
		)

		INSERT INTO #Acq_Deals (Acq_Deal_Code, Agreement_No, Vendor_Code, Status_Changed_On)
		SELECT  MD.Record_Code, MAX(AD.Agreement_No), MAX(AD.Vendor_Code), MAX(MD.Status_Changed_On) FROM Acq_Deal AD
		INNER JOIN Module_Status_History MD ON MD.Record_Code = AD.Acq_Deal_Code 
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  MD.Module_Code = 30 AND MD.Status = 'A' AND 
		AD.Business_Unit_Code   IN (select Business_Unit_Code from Users_Business_Unit U where U.Users_Code = CAST(@User_Code AS VARCHAR(50)))
		GROUP BY  MD.Record_Code 

		SET @SQL = 'SELECT * FROM (SELECT DISTINCT '''+@Is_Deal_Rights+''' AS Is_Deal_Rights, d.Acq_deal_code AS Deal_Code, d.Agreement_No,v.Vendor_Name AS Customer,
				STUFF((SELECT Distinct '','' + ISNULL(Title_Name,Original_Title)
				FROM Acq_Deal_Movie ADM  INNER JOIN Title T On T.title_code = ADM.Title_Code WHERE ADM.Acq_Deal_Code = d.Acq_Deal_Code
				FOR XML PATH('''')),1,1,'''') AS TitleName,
				(SELECT SUM(Deal_Cost) AS Deal_Cost FROM Acq_Deal_Cost WHERE Acq_Deal_Code = d.Acq_Deal_Code) AS Deal_Movie_Cost,
				(Cast(Convert(VARCHAR(11),cast(d.Status_Changed_On as datetime),103) as Varchar))  RightPeriod
			FROM #Acq_Deals d
			INNER JOIN Acq_Deal_Rights AS ADR ON ADR.Acq_Deal_Code = d.Acq_Deal_Code
			INNER JOIN dbo.Vendor AS v ON v.vendor_code = d.Vendor_Code
			LEFT OUTER JOIN Acq_Deal_Cost AS ADC ON ADC.Acq_Deal_Code = d.Acq_Deal_Code 	
		 ) AS Temp
		WHERE CONVERT(date,RightPeriod,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' and '''+ cast(@EndDate as varchar(50))+'''' + @Search
		+' Order by RightPeriod ASC'
	

	--RightPeriod = CASE ADR.Right_Type WHEN ''U'' THEN ''Perpetuity'' 
	--			ELSE (Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_Start_Date as datetime),103) as Varchar)+ ''  -  '' + Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_End_Date as datetime),103) as Varchar))
	--			END
		EXEC(@SQL)
		DROP TABLE #Acq_Deals
	END
	ELSE
	IF(@DashboardType = 'SA')
	BEGIN
	--Query to Get Deals which Approved in next @DashboardDays days
		CREATE TABLE  #Syn_Deals (
			Syn_Deal_Code INT,
			Agreement_No NVARCHAR(MAX),
			Vendor_Code INT,
			Status_Changed_On DATETIME
		)

		INSERT INTO #Syn_Deals (Syn_Deal_Code, Agreement_No, Vendor_Code, Status_Changed_On)
		SELECT  MD.Record_Code, MAX(SD.Agreement_No), MAX(SD.Vendor_Code), MAX(MD.Status_Changed_On) FROM Syn_Deal SD
		INNER JOIN Module_Status_History MD ON MD.Record_Code = SD.Syn_Deal_Code 
		WHERE MD.Module_Code = 35 AND MD.Status = 'A' 
		AND SD.Business_Unit_Code  IN (select Business_Unit_Code from Users_Business_Unit U where U.Users_Code = CAST(@User_Code AS VARCHAR(50)))
		GROUP BY  MD.Record_Code 

		SET @SQL = 'SELECT * FROM ( SELECT DISTINCT '''+@Is_Deal_Rights+''' AS Is_Deal_Rights,
		d.Syn_Deal_Code AS Deal_Code, d.Agreement_No,v.Vendor_Name AS Customer,
		STUFF((SELECT DISTINCT '','' + ISNULL(Title_Name,Original_Title)
			FROM Syn_Deal_Movie SDM  INNER JOIN Title T On T.title_code = SDM.Title_Code WHERE SDM.Syn_Deal_Code = d.Syn_Deal_Code 
			FOR XML PATH('''')),1,1,'''') AS TitleName,
		(SELECT SUM(Deal_Cost) AS Deal_Cost FROM Acq_Deal_Cost WHERE Acq_Deal_Code = d.Syn_Deal_Code) AS Deal_Movie_Cost,
		(Cast(Convert(VARCHAR(11),cast(d.Status_Changed_On as datetime),103) as Varchar))  RightPeriod
		FROM  #Syn_Deals d
		INNER JOIN Syn_Deal_Rights AS SDR ON SDR.Syn_Deal_Code = d.Syn_Deal_Code INNER JOIN dbo.Vendor AS v ON v.vendor_code = d.Vendor_Code )as Temp
		WHERE CONVERT(date,RightPeriod,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' and '''+ cast(@EndDate as varchar(50))+'''' + @Search
		+ ' Order by RightPeriod ASC'

		--RightPeriod = CASE SDR.Right_Type
		--	WHEN ''U'' THEN ''Perpetuity'' 
		--	ELSE (Cast(Convert(VARCHAR(11),cast(SDR.Actual_Right_Start_Date as datetime),103) as Varchar)+ ''  -  '' + Cast(Convert(VARCHAR(11),cast(SDR.Actual_Right_End_Date as datetime),103) as Varchar))
		--	END

		EXEC(@SQL)
		DROP TABLE #Syn_Deals
	END
	ELSE
	IF(@DashboardType = 'AR')
	BEGIN
	--Query to Get Deals whose Refusal date in next @DashboardDays days
	SET @SQL =	'SELECT * FROM (SELECT DISTINCT '''+@Is_Deal_Rights+''' AS Is_Deal_Rights,d.Acq_deal_code AS Deal_Code,d.Agreement_No,v.Vendor_Name AS Customer,
	STUFF((SELECT Distinct '','' + ISNULL(Title_Name,Original_Title)
	FROM Acq_Deal_Movie ADM       
	INNER JOIN Title T On T.title_code = ADM.Title_Code    
	WHERE ADM.Acq_Deal_Code = d.Acq_Deal_Code
	FOR XML PATH('''')),1,1,'''') AS TitleName,
	(SELECT SUM(Deal_Cost) AS Deal_Cost FROM Acq_Deal_Cost WHERE Acq_Deal_Code = d.Acq_Deal_Code) AS Deal_Movie_Cost,
	RightPeriod = CASE ADR.Right_Type
	WHEN ''U'' THEN ''Perpetuity'' 
	ELSE (Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_Start_Date as datetime),103) as Varchar)+ ''  -  '' + Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_End_Date as datetime),103) as Varchar))
	END,ADR.ROFR_Date FROM Acq_Deal d
	INNER JOIN Acq_Deal_Rights AS ADR ON ADR.Acq_Deal_Code = d.Acq_Deal_Code
	INNER JOIN dbo.Vendor AS v ON v.vendor_code = d.Vendor_Code
	LEFT OUTER JOIN Acq_Deal_Cost AS ADC ON ADC.Acq_Deal_Code = d.Acq_Deal_Code WHERE  d.Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND   ADR.Is_ROFR = ''Y'' AND
	d.Business_Unit_Code IN(select Business_Unit_Code from Users_Business_Unit where Users_Code = '+CAST(@User_Code AS VARCHAR(50))+') AND d.Deal_workflow_status = '+ '''A'''+')as Temp
	WHERE CONVERT(date,ROFR_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' and '''+ cast(@EndDate as varchar(50))+'''' + @Search
	+ 'Order by ROFR_Date ASC'
		
		EXEC(@SQL)
	END
	ELSE
	IF(@DashboardType = 'AT')
	BEGIN
	--Query to Get Deals whose Tentative date in next @DashboardDays days
	SET @SQL =	'SELECT * FROM (SELECT DISTINCT '''+@Is_Deal_Rights+''' AS Is_Deal_Rights,d.Acq_deal_code AS Deal_Code,d.Agreement_No,v.Vendor_Name AS Customer,
	STUFF((SELECT Distinct '','' + ISNULL(Title_Name,Original_Title)
	FROM Acq_Deal_Movie ADM       
	INNER JOIN Title T On T.title_code = ADM.Title_Code    
	WHERE ADM.Acq_Deal_Code = d.Acq_Deal_Code
	FOR XML PATH('''')),1,1,'''') AS TitleName,
	(SELECT SUM(Deal_Cost) AS Deal_Cost FROM Acq_Deal_Cost WHERE Acq_Deal_Code = d.Acq_Deal_Code) AS Deal_Movie_Cost,
	RightPeriod = CASE ADR.Right_Type
	WHEN ''U'' THEN ''Perpetuity'' 
	ELSE (Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_Start_Date as datetime),103) as Varchar)+ ''  -  '' + Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_End_Date as datetime),103) as Varchar))
	END,ADR.Actual_Right_Start_Date FROM Acq_Deal d
	INNER JOIN Acq_Deal_Rights AS ADR ON ADR.Acq_Deal_Code = d.Acq_Deal_Code
	INNER JOIN dbo.Vendor AS v ON v.vendor_code = d.Vendor_Code
	LEFT OUTER JOIN Acq_Deal_Cost AS ADC ON ADC.Acq_Deal_Code = d.Acq_Deal_Code WHERE  d.Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND   ADR.Is_Tentative = ''Y'' AND
	d.Business_Unit_Code IN(select Business_Unit_Code from Users_Business_Unit  where Users_Code = '+CAST(@User_Code AS VARCHAR(50))+') )as Temp
	WHERE CONVERT(date,Actual_Right_Start_Date,103) BETWEEN '''+ cast(@StartDate as varchar(50)) +''' and '''+ cast(@EndDate as varchar(50))+'''' + @Search
	+' Order by Actual_Right_Start_Date ASC '
		
		EXEC(@SQL)
	END
			--PRINT @SQL
		--DECLARE @Deal_Code INT ,@Agreement_No VARCHAR(20) ,@Customer NVARCHAR(MAX),@TitleName NVARCHAR(MAX),@Deal_Movie_Cost DECIMAL ,@RightPeriod VARCHAR(20),@Is_Deal_Rights CHAR(1)='N'
		--SELECT @Deal_Code AS Deal_Code,@Agreement_No AS Agreement_No ,@Customer  AS Customer ,@TitleName TitleName ,@Deal_Movie_Cost Deal_Movie_Cost ,@RightPeriod RightPeriod ,@Is_Deal_Rights Is_Deal_Rights
END
/*
--EXEC [dbo].[USP_Get_Dashboard_Detail] 'AE',N'मेरा भारत महान',143,30
*/
--EXEC USP_Get_Dashboard_Detail 'SA','',143,30
