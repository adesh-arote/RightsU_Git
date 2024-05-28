CREATE PROCEDURE [dbo].[USP_DealWorkFlow_Status_Pending_Reports]
(
	@Module_Code VARCHAR(200),
	@Content_Category VARCHAR(100)
)
AS 
------------------------------------------------
-- Created By : Ayush
-- Description : 
------------------------------------------------
BEGIN
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_DealWorkFlow_Status_Pending_Reports]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE 
		--@Module_Code VARCHAR(200)='30',
		--@Content_Category VARCHAR(MAX)='9,11,10,12,13,14,15,16,17,18,19,20'

		/*
			Deal Type 30= Acquisition
			Deal Type 35= Syndication
		*/
		SET NOCOUNT ON 

		IF(OBJECT_ID('tempdb..#Output') IS NOT NULL) DROP TABLE #Output
		IF(OBJECT_ID('tempdb..#RoleLevel') IS NOT NULL) DROP TABLE #RoleLevel
		IF(OBJECT_ID('tempdb..#TEMPDATA') IS NOT NULL) DROP TABLE #TEMPDATA
		IF(OBJECT_ID('tempdb..#TEMP') IS NOT NULL) DROP TABLE #TEMP

		CREATE TABLE #Output(																												--[TABLE TO RETURN OUTPUT]
			Content_Category VARCHAR(MAX),
			[Level] VARCHAR(MAX),
			Deal_Count INT
		)

		CREATE TABLE #RoleLevel(																											--[TO STORE ROLE LEVEL-USE-NO NEED TO HARD CODE ROLE LEVEL]
			Role_Level INT
		)

		CREATE TABLE #TEMPDATA(																												--[TO STORE ALL THE BUSINESS UNIT AND ROLE LEVEL-USE-TO DIFFERENTIATE BETWEEN PENDING AND APPROVED DEAL]
			Business_Unit VARCHAR(MAX),
			R_Level VARCHAR(MAX)
		)

		CREATE TABLE #TEMP(																													--[TO STORE THE EXTRACTED/FILTERED DATA]
			Business_Unit VARCHAR(MAX),
			R_Level VARCHAR(MAX)
		)

		INSERT INTO #RoleLevel (Role_Level)
		SELECT DISTINCT MIN(Role_Level) FROM Module_Workflow_Detail (NOLOCK) WHERE Is_Done = 'N' GROUP BY Role_Level

		--Select * from #RoleLevel
	
		IF(@Module_Code=30)																													--[ACQUISITION]
		BEGIN

			INSERT INTO #Output(Content_Category,Level,Deal_Count)
			SELECT DISTINCT BU.Business_Unit_Name,'Level ' + CAST(MWD.Role_Level AS VARCHAR),COUNT(MWD.Role_Level)
			FROM (SELECT  Record_Code, MIN(Role_Level) AS Role_Level FROM Module_Workflow_Detail (NOLOCK) WHERE Is_Done ='N' AND MODULE_Code = @Module_Code GROUP BY Record_Code)   MWD
			INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = MWD.Record_Code
			INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_Unit_Code = AD.Business_Unit_Code
			INNER JOIN #RoleLevel RL ON RL.Role_Level =MWD.Role_Level 
			WHERE  BU.Business_Unit_Code IN (SELECT number FROM fn_Split_withdelemiter(@Content_Category,',')) AND MWD.Role_Level > 0 AND AD.Deal_Workflow_Status='W'
			AND AD.Acq_Deal_Code = MWD.Record_Code --AND Module_Code=@Module_Code
			GROUP BY Business_Unit_Name,MWD.Role_Level--,RL.Role_Level
		
			INSERT INTO #TEMPDATA(Business_Unit,R_Level)
			Select DISTINCT BU.Business_Unit_Name,'Level ' + CAST(MWD.Role_level + 1 AS VARCHAR) FROM Acq_Deal AD (NOLOCK)
			INNER JOIN Module_Workflow_Detail MWD (NOLOCK) ON MWD.Record_Code = AD.Acq_Deal_Code
			INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_unit_code = AD.Business_Unit_code
			WHERE BU.Business_Unit_Code IN (select number from fn_Split_withdelemiter(@Content_Category,','))

			INSERT INTO #TEMP(Business_Unit,R_Level)
			SELECT Business_Unit,R_Level FROM #TEMPDATA 
			EXCEPT
			SELECT Content_Category,level FROM #Output

		END
		ELSE IF(@Module_Code=35)																													--[SYNDICATION]
		BEGIN
			INSERT INTO #Output(Content_Category,Level,Deal_Count)
			SELECT DISTINCT BU.Business_Unit_Name,'Level ' + CAST(MWD.Role_Level AS VARCHAR),COUNT(MWD.Role_Level)
			FROM (SELECT  Record_Code, MIN(Role_Level) AS Role_Level FROM Module_Workflow_Detail (NOLOCK) WHERE Is_Done ='N' AND MODULE_Code = @Module_Code GROUP BY Record_Code) MWD
			INNER JOIN Syn_Deal SD (NOLOCK) ON SD.Syn_Deal_Code = MWD.Record_Code
			INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_unit_code = SD.Business_Unit_code 
			INNER JOIN #RoleLevel Rl ON Rl.Role_Level =MWD.Role_Level
			WHERE BU.Business_Unit_Code IN (select number from fn_Split_withdelemiter(@Content_Category,',')) AND MWD.Role_Level > 0 AND SD.Deal_Workflow_Status='W'
			AND SD.Syn_Deal_Code = MWD.Record_Code
			GROUP BY Business_Unit_Name,MWD.Role_level

			INSERT INTO #TEMPDATA(Business_Unit,R_Level)
			Select DISTINCT BU.Business_Unit_Name,'Level ' + CAST(MWD.Role_level + 1 AS VARCHAR) FROM Syn_Deal SD (NOLOCK)
			INNER JOIN Module_Workflow_Detail MWD (NOLOCK) ON MWD.Record_Code = SD.Syn_Deal_Code
			INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_unit_code = SD.Business_Unit_code
			WHERE BU.Business_Unit_Code IN (select number from fn_Split_withdelemiter(@Content_Category,','))

			INSERT INTO #TEMP(Business_Unit,R_Level)
			SELECT Business_Unit,R_Level FROM #TEMPDATA 
			EXCEPT
			SELECT Content_Category,level FROM #Output 

		END
		--SELECT * from #output
		SELECT Content_Category, [Level], Deal_Count FROM #Output OP
		UNION ALL 
		Select Business_Unit,R_level,0 FROM #TEMP T ORDER BY 1,2,3																			--[UNION WITH THE EXTRACTED DATA]
	
		IF(OBJECT_ID('tempdb..#Output') IS NOT NULL) DROP TABLE #Output
		IF(OBJECT_ID('tempdb..#RoleLevel') IS NOT NULL) DROP TABLE #RoleLevel
		IF(OBJECT_ID('tempdb..#TEMPDATA') IS NOT NULL) DROP TABLE #TEMPDATA
		IF(OBJECT_ID('tempdb..#TEMP') IS NOT NULL) DROP TABLE #TEMP
	
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_DealWorkFlow_Status_Pending_Reports]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END