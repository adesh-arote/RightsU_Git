﻿
CREATE PROCEDURE [dbo].[USP_Get_Dashboard_Detail_Payment_Term]
(
	@DashboardType varchar(10)='AE',
	@SearchFor NVARCHAR(1000) ='',
	@User_Code INT = 143,
	@DashboardDays INT=30
)
AS
BEGIN
	SET NOCOUNT ON;
	--DECLARE 
	--@DashboardType varchar(10)='MT',
	--@SearchFor NVARCHAR(1000) ='',
	--@User_Code INT = 203,
	--@DashboardDays INT=30

	/**************************************Show Hide Deal View button on the basis of Rights******************************************/
	DECLARE @UserSecCode  INT = 0,@Module_Code INT = 30,@Is_Deal_Rights CHAR(1)= 'N'
	
	SELECT @UserSecCode = Security_Group_Code FROM Users WHERE Users_Code = @User_Code  
	SELECT DISTINCT @Is_Deal_Rights = CASE WHEN SMR.Module_Code = @Module_Code THEN 'Y' ELSE 'N' END
	FROM System_Module_Right SMR
	INNER JOIN Security_Group_Rel sgr ON smr.Module_Right_Code = sgr.System_Module_Rights_Code AND sgr.Security_Group_Code = @UserSecCode
	WHERE Module_Code IN(@Module_Code)

	/********************************************************************************/

	Declare @StartDate AS date
	Declare @EndDate AS date
	Declare @Search As NVarchar(2000)
	Declare @SQL As NVarchar(MAX)
 
	SET @StartDate = (SELECT CONVERT(date,GETDATE(),103))
	SET @EndDate = (SELECT CONVERT(date,GETDATE() + @DashboardDays,103))

    SET @Search = ''
    SET @SQL = ''

    IF(LEN(@SearchFor) > 0)
		 SET @Search = ' and( TitleName LIKE N''%'+@SearchFor+'%''OR Customer LIKE N''%'+@SearchFor+'%'' OR Agreement_No LIKE ''%'+@SearchFor+'%'')'
 
	BEGIN
		CREATE TABLE #TempAS
		(	
			Deal_Code INT,
			Agreement_No NVARCHAR(MAX)
		)

		SET @SQL = ' INSERT INTO #TempAS (Deal_Code, Agreement_No)
					SELECT DISTINCT Temp.Deal_Code, Temp.Agreement_No FROM (SELECT DISTINCT '''+@Is_Deal_Rights+''' AS Is_Deal_Rights,d.Acq_deal_code AS Deal_Code,d.Agreement_No,v.Vendor_Name AS Customer,
					STUFF((SELECT Distinct '','' + ISNULL(Title_Name,Original_Title)
					FROM Acq_Deal_Movie ADM       
					INNER JOIN Title T On T.title_code = ADM.Title_Code    
					WHERE ADM.Acq_Deal_Code = d.Acq_Deal_Code
					FOR XML PATH('''')),1,1,'''') AS TitleName,
					(SELECT SUM(Deal_Cost) AS Deal_Cost FROM Acq_Deal_Cost WHERE Acq_Deal_Code = d.Acq_Deal_Code) AS Deal_Movie_Cost,
					RightPeriod = CASE ADR.Right_Type
					WHEN ''U'' THEN ''Perpetuity'' 
					ELSE (Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_Start_Date as datetime),103) as Varchar)+ ''  -  '' + Cast(Convert(VARCHAR(11),cast(ADR.Actual_Right_End_Date as datetime),103) as Varchar))
					END,ADR.Actual_Right_Start_Date  FROM Acq_Deal d
					INNER JOIN Acq_Deal_Rights AS ADR ON ADR.Acq_Deal_Code = d.Acq_Deal_Code
					INNER JOIN dbo.Vendor AS v ON v.vendor_code = d.Vendor_Code
					LEFT OUTER JOIN Acq_Deal_Cost AS ADC ON ADC.Acq_Deal_Code = d.Acq_Deal_Code 
					WHERE  d.Deal_Workflow_Status NOT IN (''AR'', ''WA'') AND  d.Business_Unit_Code IN(select Business_Unit_Code from Users_Business_Unit U where U.Users_Code = '+CAST(@User_Code AS VARCHAR(50))+'))as Temp
					WHERE CONVERT(date,Actual_Right_Start_Date,103)BETWEEN '''+ cast(@StartDate as varchar(50)) +''' and '''+ cast(@EndDate as varchar(50))+'''' + @Search 
					
		EXEC(@SQL)

		SELECT
			TAS.Deal_Code,
			tas.Agreement_No,
			pt.Payment_Terms, 
			adpt.Days_After, 
			ct.Cost_Type_Name +' '+ ISNULL(CAST(adpt.Amount AS VARCHAR),'') +' '+ CAST(adpt.Percentage AS VARCHAR) as 'Cost_Percentage', 
			adpt.Due_Date
		FROM Acq_Deal_Payment_Terms adpt
			INNER JOIN #TempAS TAS ON TAS.Deal_Code = adpt.Acq_Deal_Code
			INNER JOIN Payment_Terms pt ON pt.Payment_Terms_Code =  adpt.Payment_Term_Code
			INNER JOIN Cost_Type ct ON ct.Cost_Type_Code = adpt.Cost_Type_Code
		--WHERE adpt.Acq_Deal_Code = 4696
		ORDER by adpt.Acq_Deal_Payment_Terms_Code

		DROP TABLE #TempAS

	END

		--SELECT CAST('0' AS INT) AS Deal_Code,
		--	CAST('' AS NVARCHAR(MAX)) Agreement_No,
		--	CAST('' AS NVARCHAR(MAX)) Payment_Terms,
		--	CAST('0' AS INT) AS Days_After,
		--	CAST('' AS NVARCHAR(MAX)) Cost_Percentage,
		--	GETDATE() AS Due_Date
END


  

  
