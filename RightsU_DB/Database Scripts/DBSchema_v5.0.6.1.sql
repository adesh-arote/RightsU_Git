GO
PRINT N'Altering [dbo].[Acq_Deal]...';


GO
ALTER TABLE [dbo].[Acq_Deal]
    ADD [Confirming_Party] NVARCHAR (MAX) NULL;


GO
PRINT N'Altering [dbo].[AT_Acq_Deal]...';


GO
ALTER TABLE [dbo].[AT_Acq_Deal]
    ADD [Confirming_Party] NVARCHAR (MAX) NULL;


GO
PRINT N'Refreshing [dbo].[VW_Acq_Approved_Data]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_Acq_Approved_Data]';


GO
PRINT N'Refreshing [dbo].[VW_Acq_Deals]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_Acq_Deals]';


GO
PRINT N'Refreshing [dbo].[VW_ACQ_EXPIRING_DEALS]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_ACQ_EXPIRING_DEALS]';


GO
PRINT N'Refreshing [dbo].[VW_ACQ_EXPIRING_DEALS_All]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_ACQ_EXPIRING_DEALS_All]';


GO
PRINT N'Refreshing [dbo].[vw_acquisition_deal_data_AsRunSchedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[vw_acquisition_deal_data_AsRunSchedule]';


GO
PRINT N'Refreshing [dbo].[VW_BMS_Schedule_Acq_Rights_Data]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_BMS_Schedule_Acq_Rights_Data]';


GO
PRINT N'Refreshing [dbo].[VW_Validate_SYN_General_Data]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[VW_Validate_SYN_General_Data]';


GO
PRINT N'Altering [dbo].[USP_INSERT_ACQ_DEAL]...';


GO


ALTER PROCEDURE [dbo].[USP_INSERT_ACQ_DEAL]
( 
 @Version VARCHAR(50)
,@Agreement_Date DATETIME
,@Deal_Desc NVARCHAR(1000)
,@Deal_Type_Code INT
,@Year_Type CHAR(2)
,@Entity_Code INT
,@Is_Master_Deal CHAR(1)
,@Category_Code INT
,@Vendor_Code INT
,@Vendor_Contacts_Code INT
,@Currency_Code INT
,@Exchange_Rate numeric(10,3)
,@Ref_No NVARCHAR(100)
,@Attach_Workflow CHAR(1)
,@Deal_Workflow_Status VARCHAR(50)
,@Parent_Deal_Code INT
,@Work_Flow_Code INT
,@Amendment_Date DATETIME
,@Is_Released CHAR(1)
,@Release_On DATETIME
,@Release_By INT
,@Is_Completed CHAR(1)
,@Is_Active CHAR(1)
,@Content_Type CHAR(2)
,@Payment_Terms_Conditions NVARCHAR(4000)
,@Status CHAR(1)
,@Is_Auto_Generated CHAR(1)
,@Is_Migrated CHAR(1)
,@Cost_Center_Id INT
,@Master_Deal_Movie_Code_ToLink INT
,@BudgetWise_Costing_Applicable VARCHAR(2)
,@Validate_CostWith_Budget VARCHAR(2)
,@Deal_Tag_Code INT
,@Business_Unit_Code INT
,@Ref_BMS_Code VARCHAR(100)
,@Remarks NVARCHAR(4000)
,@Rights_Remarks NVARCHAR(4000)
,@Payment_Remarks NVARCHAR(4000)
,@Inserted_By INT
,@Inserted_On DATETIME
,@Last_Updated_Time DATETIME
,@Last_Action_By INT
,@Lock_Time DATETIME
,@Role_Code Int
,@Channel_Cluster_Code Int
,@Is_Auto_Push CHAR(1)
,@Deal_Segment_Code INT
,@Revenue_Vertical_Code INT
,@Confirming_Party NVARCHAR(MAX)
)
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 07-October-2014
-- Description:	Inserts Acq Deal Call From EF Table Mapping
-- =============================================
BEGIN

INSERT INTO [Acq_Deal]
		([Agreement_No]
		,[Version]
		,[Agreement_Date]
		,[Deal_Desc]
		,[Deal_Type_Code]
		,[Year_Type]
		,[Entity_Code]
		,[Is_Master_Deal]
		,[Category_Code]
		,[Vendor_Code]
		,[Vendor_Contacts_Code]
		,[Currency_Code]
		,[Exchange_Rate]
		,[Ref_No]
		,[Attach_Workflow]
		,[Deal_Workflow_Status]
		,[Parent_Deal_Code]
		,[Work_Flow_Code]
		,[Amendment_Date]
		,[Is_Released]
		,[Release_On]
		,[Release_By]
		,[Is_Completed]
		,[Is_Active]
		,[Content_Type]
		,[Payment_Terms_Conditions]
		,[Status]
		,[Is_Auto_Generated]
		,[Is_Migrated]
		,[Cost_Center_Id]
		,[Master_Deal_Movie_Code_ToLink]
		,[BudgetWise_Costing_Applicable]
		,[Validate_CostWith_Budget]
		,[Deal_Tag_Code]
		,[Business_Unit_Code]
		,[Ref_BMS_Code]
		,[Remarks]
		,[Rights_Remarks]
		,[Payment_Remarks]
		,[Deal_Complete_Flag]
		,[Inserted_By]
		,[Inserted_On]
		,[Last_Updated_Time]
		,[Last_Action_By]
		,[Lock_Time]
		,[Role_Code]
		,[Channel_Cluster_Code]
		,[Is_Auto_Push]
		,[Deal_Segment_Code]
		,[Revenue_Vertical_Code]
		,[Confirming_Party] )
	Select [dbo].[UFN_Auto_Genrate_Agreement_No]('A', @Agreement_Date, ISNULL(@Master_Deal_Movie_Code_ToLink, 0)) [Agreement_No]
		,@Version
		,@Agreement_Date
		,@Deal_Desc
		,@Deal_Type_Code
		,@Year_Type
		,@Entity_Code
		,@Is_Master_Deal
		,@Category_Code
		,@Vendor_Code
		,@Vendor_Contacts_Code
		,@Currency_Code
		,@Exchange_Rate
		,@Ref_No
		,@Attach_Workflow
		,@Deal_Workflow_Status
		,@Parent_Deal_Code
		,@Work_Flow_Code
		,@Amendment_Date
		,@Is_Released
		,@Release_On
		,@Release_By
		,@Is_Completed
		,@Is_Active
		,@Content_Type
		,@Payment_Terms_Conditions
		,@Status
		,@Is_Auto_Generated
		,@Is_Migrated
		,@Cost_Center_Id
		,@Master_Deal_Movie_Code_ToLink
		,@BudgetWise_Costing_Applicable
		,@Validate_CostWith_Budget
		,@Deal_Tag_Code
		,@Business_Unit_Code
		,NULL--@Ref_BMS_Code
		,@Remarks
		,@Rights_Remarks
		,@Payment_Remarks
		,(Select Parameter_Value From System_Parameter_New Where Parameter_Name = 'Deal_Complete_Flag')
		,@Inserted_By
		,GETDATE()
		,Getdate()
		,@Last_Action_By
		,@Lock_Time
		,@Role_Code
		,@Channel_Cluster_Code
		,@Is_Auto_Push
		,@Deal_Segment_Code
		,@Revenue_Vertical_Code
		,@Confirming_Party

		SELECT Acq_Deal_Code,Agreement_No
		FROM Acq_Deal WHERE Acq_Deal_Code=SCOPE_IDENTITY()
END
GO
PRINT N'Altering [dbo].[USP_Acquition_Deal_List_Report]...';


GO

ALTER Procedure [dbo].[USP_Acquition_Deal_List_Report](
	@Agreement_No VARCHAR(100), 
	@Is_Master_Deal VARCHAR(2), 
	@Start_Date VARCHAR(30), 
	@End_Date VARCHAR(30), 
	@Deal_Tag_Code Int, 
	@Title_Name NVARCHAR(100), 
	@Business_Unit_code VARCHAR(100), 
	@Is_Pushback VARCHAR(100), 
	@SysLanguageCode INT,
	@DealSegment INT,
	@TypeOfFilm INT)
As
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date:	18 Feb 2015
-- Description:	Get Acquisition Deal List Report Data
-- =============================================
BEGIN

	--DECLARE 
	-- @Agreement_No Varchar(100)= ''
	--, @Is_Master_Deal Varchar(2) = 'Y'
	--, @Start_Date Varchar(30) = '' 
	--, @End_Date Varchar(30) = ''
	--, @Deal_Tag_Code Int = 0
	--, @Title_Name Varchar(100)= ''
	--, @Business_Unit_code VARCHAR(100)= '1' 
	--, @Is_Pushback Varchar(100)= 'Y'
	--, @SysLanguageCode INT= 1
	--, @DealSegment INT= 0
	--, @TypeOfFilm INT = 3

	IF CHARINDEX(',',@Business_Unit_code) > 0 
		set @Business_Unit_code = '0'

	DECLARE 
	@Col_Head01 NVARCHAR(MAX) = '',  
	@Col_Head02 NVARCHAR(MAX) = '',  
	@Col_Head03 NVARCHAR(MAX) = '',
	@Col_Head04 NVARCHAR(MAX) = '', 
	@Col_Head05 NVARCHAR(MAX) = '', 
	@Col_Head06 NVARCHAR(MAX) = '', 
	@Col_Head07 NVARCHAR(MAX) = '', 
	@Col_Head08 NVARCHAR(MAX) = '', 
	@Col_Head09 NVARCHAR(MAX) = '', 
	@Col_Head10 NVARCHAR(MAX) = '', 
	@Col_Head11 NVARCHAR(MAX) = '', 
	@Col_Head12 NVARCHAR(MAX) = '', 
	@Col_Head13 NVARCHAR(MAX) = '', 
	@Col_Head14 NVARCHAR(MAX) = '', 
	@Col_Head15 NVARCHAR(MAX) = '', 
	@Col_Head16 NVARCHAR(MAX) = '', 
	@Col_Head17 NVARCHAR(MAX) = '', 
	@Col_Head18 NVARCHAR(MAX) = '', 
	@Col_Head19 NVARCHAR(MAX) = '', 
	@Col_Head20 NVARCHAR(MAX) = '', 
	@Col_Head21 NVARCHAR(MAX) = '', 
	@Col_Head22 NVARCHAR(MAX) = '', 
	@Col_Head23 NVARCHAR(MAX) = '', 
	@Col_Head24 NVARCHAR(MAX) = '', 
	@Col_Head25 NVARCHAR(MAX) = '', 
	@Col_Head26 NVARCHAR(MAX) = '', 
	@Col_Head27 NVARCHAR(MAX) = '', 
	@Col_Head28 NVARCHAR(MAX) = '', 
	@Col_Head29 NVARCHAR(MAX) = '', 
	@Col_Head30 NVARCHAR(MAX) = '', 
	@Col_Head31 NVARCHAR(MAX) = '', 
	@Col_Head32 NVARCHAR(MAX) = '', 
	@Col_Head33 NVARCHAR(MAX) = '', 
	@Col_Head34 NVARCHAR(MAX) = '', 
	@Col_Head35 NVARCHAR(MAX) = '', 
	@Col_Head36 NVARCHAR(MAX) = '', 
	@Col_Head37 NVARCHAR(MAX) = '', 
	@Col_Head38 NVARCHAR(MAX) = '',
	@Col_Head39 NVARCHAR(MAX) = '',
	@Col_Head40 NVARCHAR(MAX) = '',
	@Col_Head41 NVARCHAR(MAX) = '',
	@Col_Head42 NVARCHAR(MAX) = '',
	@Col_Head43 NVARCHAR(MAX) = '',
	@Col_Head44 NVARCHAR(MAX) = '',
	@Col_Head45 NVARCHAR(MAX) = '',
	@Col_Head46 NVARCHAR(MAX) = '',
	@Col_Head47 NVARCHAR(MAX) = '',
	@Col_Head48 NVARCHAR(MAX) = '',
	@Col_Head49 NVARCHAR(MAX) = '',
	@Col_Head50 NVARCHAR(MAX) = '',
	@Col_Head51 NVARCHAR(MAX) = '',
	@Col_Head52 NVARCHAR(MAX) = ''

	PRINT 'Dropping temp table form temp db if already created'
	BEGIN
		IF OBJECT_ID('tempdb..#TempAcqDealListReport') IS NOT NULL
		DROP TABLE #TempAcqDealListReport

		IF OBJECT_ID('tempdb..#AncData') IS NOT NULL
		DROP TABLE #AncData

		IF OBJECT_ID('tempdb..#TEMP_Acquition_Deal_List_Report') IS NOT NULL
		DROP TABLE #TEMP_Acquition_Deal_List_Report

		IF OBJECT_ID('tempdb..#TEMP_Acquition_Deal_List_Report_Pushback') IS NOT NULL
		DROP TABLE #TEMP_Acquition_Deal_List_Report_Pushback
	
		IF OBJECT_ID('tempdb..#RightTable') IS NOT NULL
		DROP TABLE #RightTable
	
		IF OBJECT_ID('tempdb..#PlatformTable') IS NOT NULL
		DROP TABLE #PlatformTable

		IF OBJECT_ID('tempdb..#RegionTable') IS NOT NULL
		DROP TABLE #RegionTable

		IF OBJECT_ID('tempdb..#LangTable') IS NOT NULL
		DROP TABLE #LangTable

		IF OBJECT_ID('tempdb..#RegionSubDubTable') IS NOT NULL
		DROP TABLE #RegionSubDubTable
	
		IF OBJECT_ID('tempdb..#TitleTable') IS NOT NULL
		DROP TABLE #TitleTable

		IF OBJECT_ID('tempdb..#DealTitleTable') IS NOT NULL
		DROP TABLE #DealTitleTable
	END

	PRINT 'Creating temp table'
	BEGIN
		CREATE TABLE #RightTable(
			Acq_Deal_Code INT,
			Acq_Deal_Rights_Code INT,
			Acq_Deal_Pushback_Code INT,
			Platform_Codes NVARCHAR(MAX),
			Region_Codes NVARCHAR(MAX),
			SL_Codes NVARCHAR(MAX),
			DB_Codes NVARCHAR(MAX),
			Platform_Names NVARCHAR(MAX),
			Region_Name NVARCHAR(MAX),
			Subtitle NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			RunType NVARCHAR(MAX),
			RGType VARCHAR(10),
			SLType VARCHAR(10),
			DBType VARCHAR(10),
			Run_Type VARCHAR(100)
		)
		CREATE TABLE #PlatformTable(
			Platform_Codes NVARCHAR(MAX),
			Platform_Names NVARCHAR(MAX)
		)
		CREATE TABLE #RegionTable(
			Region_Codes NVARCHAR(MAX),
			Region_Names NVARCHAR(MAX),
			Region_Type NVARCHAR(10)
		)
		CREATE TABLE #LangTable(
			Lang_Codes NVARCHAR(MAX),
			Lang_Names NVARCHAR(MAX),
			Lang_Type NVARCHAR(10)
		)	
		CREATE TABLE #TitleTable(
			Title_Code INT,
			Eps_From INT,
			Eps_To INT,
			Director NVARCHAR(MAX),
			StarCast NVARCHAR(MAX),
			Genre NVARCHAR(MAX)
		)
		CREATE TABLE #DealTitleTable(
			Acq_Deal_Code INT,
			Title_Code INT,
			Eps_From INT,
			Eps_To INT,
			Run_Type VARCHAR(10)
		)
		CREATE TABLE #TEMP_Acquition_Deal_List_Report(
			Acq_Deal_Right_Code VARCHAR(100),
			Business_Unit_Name NVARCHAR(MAX),
			Title_Code INT,
			Title_Name NVARCHAR(MAX),
			Episode_From INT,
			Episode_To INT,
			Deal_Type_Code INT,
			Director NVARCHAR(MAX),
			Star_Cast NVARCHAR(MAX),
			Genre NVARCHAR(MAX),
			Title_Language NVARCHAR(MAX),
			year_of_production INT,
			Acq_Deal_code INT,
			Agreement_No VARCHAR(MAX),
			Deal_Description NVARCHAR(MAX),
			Reference_No NVARCHAR(MAX),
			Is_Master_Deal CHAR(1),
			Agreement_Date DATETIME,
			Deal_Tag_Code INT,
			Deal_Tag_Description NVARCHAR(MAX),
			Party NVARCHAR(MAX),
			Party_Master NVARCHAR(MAX),
			Platform_Name VARCHAR(MAX),
			Right_Start_Date DATETIME, 
			Right_End_Date DATETIME,
			Is_Title_Language_Right CHAR(1),
			Country_Territory_Name NVARCHAR(MAX),
			Is_Exclusive CHAR(1),
			Subtitling NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			Sub_Licencing NVARCHAR(MAX),
			Is_Tentative CHAR(1),
			Is_ROFR CHAR(1),
			First_Refusal_Date DATETIME,
			Restriction_Remarks NVARCHAR(MAX),
			Holdback_Platform NVARCHAR(MAX),
			Holdback_Rights NVARCHAR(MAX),
			Blackout NVARCHAR(MAX),
			General_Remark NVARCHAR(MAX),
			Rights_Remarks NVARCHAR(MAX),
			Payment_Remarks NVARCHAR(MAX),
			Right_Type VARCHAR(MAX),
			Right_Term VARCHAR(MAX),
			Deal_Workflow_Status VARCHAR(MAX),
			Is_Pushback CHAR(1),
			Master_Deal_Movie_Code_ToLink INT,
			Run_Type CHAR(9),
			Is_Attachment CHAR(3),
			[Program_Name] NVARCHAR(MAX),
			Promtoer_Group NVARCHAR(MAX),
			Promtoer_Remarks NVARCHAR(MAX),
			Due_Diligence VARCHAR(MAX),
			Category_Name VARCHAR(MAX),
			Deal_Segment NVARCHAR(MAX),
			Revenue_Vertical NVARCHAR(MAX),
			Columns_Value_Code INT
		)
		CREATE TABLE #TEMP_Acquition_Deal_List_Report_Pushback(
			Acq_Deal_Pushback_Code VARCHAR(100),
			Business_Unit_Name NVARCHAR(MAX),
			Title_Code INT,
			Title_Name NVARCHAR(MAX),
			Episode_From INT,
			Episode_To INT,
			Deal_Type_Code INT,
			Director NVARCHAR(MAX),
			Star_Cast NVARCHAR(MAX),
			Genre NVARCHAR(MAX),
			Title_Language NVARCHAR(MAX),
			year_of_production INT,
			Acq_Deal_code INT,
			Agreement_No VARCHAR(MAX),
			Deal_Description NVARCHAR(MAX),
			Reference_No NVARCHAR(MAX),
			Is_Master_Deal CHAR(1),
			Agreement_Date DATETIME,
			Deal_Tag_Code INT,
			Deal_Tag_Description NVARCHAR(MAX),
			Party NVARCHAR(MAX),
			Party_Master NVARCHAR(MAX),
			Platform_Name VARCHAR(MAX),
			Right_Start_Date DATETIME, 
			Right_End_Date DATETIME,
			Is_Title_Language_Right CHAR(1),
			Country_Territory_Name NVARCHAR(MAX),
			Is_Exclusive CHAR(1),
			Subtitling NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			Sub_Licencing NVARCHAR(MAX),
			Is_Tentative CHAR(1),
			Is_ROFR CHAR(1),
			First_Refusal_Date DATETIME,
			Restriction_Remarks NVARCHAR(MAX),
			Holdback_Platform NVARCHAR(MAX),
			Holdback_Rights NVARCHAR(MAX),
			Blackout NVARCHAR(MAX),
			General_Remark NVARCHAR(MAX),
			Rights_Remarks NVARCHAR(MAX),
			Payment_Remarks NVARCHAR(MAX),
			Right_Type VARCHAR(MAX),
			Right_Term VARCHAR(MAX),
			Deal_Workflow_Status VARCHAR(MAX),
			Is_Pushback CHAR(1),
			Master_Deal_Movie_Code_ToLink INT,
			Run_Type CHAR(9),
			Is_Attachment CHAR(3),
			[Program_Name] NVARCHAR(MAX),
			Promtoer_Group NVARCHAR(MAX),
			Promtoer_Remarks NVARCHAR(MAX),
			Due_Diligence VARCHAR(MAX),
			Category_Name VARCHAR(MAX),
			Deal_Segment NVARCHAR(MAX),
			Revenue_Vertical NVARCHAR(MAX),
			Columns_Value_Code INT
		)
	END

	DECLARE @IsDealSegment VARCHAR(MAX), @IsRevenueVertical VARCHAR(MAX), @IsTypeOfFilm VARCHAR(MAX), @Columns_Code INT
	SELECT @IsDealSegment = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Deal_Segment' 
	SELECT @IsRevenueVertical = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Revenue_Vertical' 
	SELECT @IsTypeOfFilm = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Type_Of_Film' 
	SELECT @Columns_Code = Columns_Code FROM Extended_Columns WHERE UPPER(Columns_Name) = 'TYPE OF FILM'

	PRINT 'Insertion in #TEMP_Acquition_Deal_List_Report'
	INSERT INTO #TEMP_Acquition_Deal_List_Report
	(
		Acq_Deal_Right_Code
		,Business_Unit_Name
		,Title_Code
		,Title_Name
		,Episode_From
		,Episode_To
		,Deal_Type_Code
		,Director, Star_Cast
		,Genre, Title_Language, year_of_production, Acq_Deal_code 
		,Deal_Description, Reference_No, Agreement_No, Is_Master_Deal, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party,Party_Master
		,Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right
		,Country_Territory_Name
		,Is_Exclusive, Subtitling
		,Dubbing
		,Sub_Licencing
		,Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks
		,Holdback_Platform
		,Holdback_Rights 
		,Blackout
		,General_Remark, Rights_Remarks, Payment_Remarks, Right_Type
		,Right_Term
		,Deal_Workflow_Status
		,Is_Pushback, Master_Deal_Movie_Code_ToLink
		,Run_Type
		,Is_Attachment
		,[Program_Name]
		,Promtoer_Group
		,Promtoer_Remarks
		,Due_Diligence
		,Category_Name
		,Columns_Value_Code
	)
	SELECT 
		ADR.Acq_Deal_Rights_Code
		,BU.Business_Unit_Name
		,T.Title_Code
		,T.Title_Name
		,CAST(ADRT.Episode_From AS INT)
		,ADRT.Episode_To
		,AD.Deal_Type_Code 
		--,dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) Director
		,'' Director
		--,dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) Star_Cast
		,'' Star_Cast
		--,dbo.UFN_Get_Title_Genre(t.title_code) Genre
		,'' Genre
		,ISNULL(L.language_name, '') AS Title_Language
		,t.year_of_production
		,AD.Acq_Deal_Code
		,AD.Deal_Desc, AD.Ref_No, AD.Agreement_No, AD.Is_Master_Deal, CAST(AD.Agreement_Date as date), AD.Deal_Tag_Code
		,TG.Deal_Tag_Description, V.Vendor_Name,PG.Party_Group_Name
		--,[dbo].[UFN_Get_Platform_Name](ADR.Acq_Deal_Rights_Code, 'AR') Platform_Name
		,'' Platform_Name
		,ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right
		--,CASE (DBO.UFN_Get_Rights_Country(ADR.Acq_Deal_Rights_Code, 'A',''))
		--	WHEN '' THEN DBO.UFN_Get_Rights_Territory(ADR.Acq_Deal_Rights_Code, 'A')
		--	ELSE DBO.UFN_Get_Rights_Country(ADR.Acq_Deal_Rights_Code, 'A','')
		-- END AS  Country_Territory_Name
		,'' AS  Country_Territory_Name
		,ADR.Is_Exclusive AS Is_Exclusive
		--,DBO.UFN_Get_Rights_Subtitling(ADR.Acq_Deal_Rights_Code, 'A') Subtitling
		 ,'' Subtitling
		--,DBO.UFN_Get_Rights_Dubbing(ADR.Acq_Deal_Rights_Code, 'A') Dubbing
		,'' Dubbing
		,CASE LTRIM(RTRIM(ADR.Is_Sub_License))
			WHEN 'Y' THEN SL.Sub_License_Name
			ELSE 'No Sub Licensing'
		END AS SubLicencing
		,ADR.Is_Tentative, ADR.Is_ROFR, ADR.ROFR_Date AS First_Refusal_Date, ADR.Restriction_Remarks AS Restriction_Remarks
		,[dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](ADR.Acq_Deal_Rights_Code, 'AR','P') Holdback_Platform
		,[dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](ADR.Acq_Deal_Rights_Code, 'AR','R') Holdback_Right
		,[dbo].[UFN_Get_Blackout_Period](ADR.Acq_Deal_Rights_Code, 'AR') Blackout
		--,'' Holdback_Platform
		--,'' Holdback_Right
		--,'' Blackout
		,AD.Remarks AS General_Remark, AD.Rights_Remarks AS Rights_Remarks, AD.Payment_Terms_Conditions AS Payment_Remarks, ADR.Right_Type,
		CASE ADR.Right_Type
			WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, Term) 
			WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
			WHEN 'U' THEN 'Perpetuity'
		END AS Right_Term,
		CASE UPPER(LTRIM(RTRIM(ISNULL(AD.Deal_Workflow_Status, '')))) 
			WHEN 'N' THEN 'Created'
			WHEN 'W' THEN 'Sent for authorization'
			WHEN 'A' THEN 'Approved' 
			WHEN 'R' THEN 'Declined'
			WHEN 'AM' THEN 'Amended'
			ELSE Deal_Workflow_Status 
		END AS Deal_Workflow_Status
		,'N' as Is_Pushback
		,AD.Master_Deal_Movie_Code_ToLink
		--,[dbo].[UFN_Get_Run_Type] (AD.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code ,@Title_Name) AS Run_Type
		,'' Run_Type
		,CASE WHEN (SELECT count(*) FROM Acq_Deal_Attachment ADT WHERE ADT.Acq_Deal_Code = AD.Acq_Deal_Code) > 0 THEN 'Yes'
             ELSE 'No'
		END AS Is_Attachment,
		P.Program_Name as 'Program_Name'
		,[dbo].[UFN_Get_Rights_Promoter_Group_Remarks](ADR.Acq_Deal_Rights_Code,'P','A') AS Promoter_Group_Name
		--,'' Promoter_Group_Name
		,[dbo].[UFN_Get_Rights_Promoter_Group_Remarks](ADR.Acq_Deal_Rights_Code,'R','A') AS Promoter_Remarks_Name
		--,'' Promoter_Remarks_Name
		,CASE UPPER(LTRIM(RTRIM(ISNULL(ADM.Due_Diligence, '')))) 
			WHEN 'N' THEN 'No'
			WHEN 'Y' THEN 'Yes'
			ELSE 'No' 
		END AS Due_Diligence,
		C.Category_Name AS Category_Name,MEC.Columns_Value_Code
	FROM Acq_Deal AD
		INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
		INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Title ADRT On ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
		LEFT JOIN Party_Group PG ON v.Party_Group_Code = PG.Party_Group_Code
		LEFT JOIN Sub_License SL ON ADR.Sub_License_Code = SL.Sub_License_Code
		INNER JOIN Deal_Tag TG On AD.Deal_Tag_Code = TG.Deal_Tag_Code
		INNER JOIN Title T On ADRT.Title_Code = T.title_code
		LEFT JOIN Program P on T.Program_Code = P.Program_Code
		LEFT JOIN Language L on T.Title_Language_Code = L.language_code
		LEFT JOIN Acq_Deal_Movie ADM on ADRT.Title_Code = ADM.Title_Code AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To AND ADM.Acq_Deal_Code = AD.Acq_Deal_Code
		INNER JOIN Category C ON AD.Category_Code = C.Category_Code
		LEFT JOIN Map_Extended_columns MEC ON MEC.Record_Code = T.Title_Code AND MEC.Columns_Code = @Columns_Code
	WHERE  
		AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
		(((ISNULL(CONVERT(date,ADR.Actual_Right_Start_Date ,103),'') >= CONVERT(date,@Start_Date,103)  OR @Start_Date = '' )AND (ISNULL(CONVERT(date,ADR.Actual_Right_Start_Date,103),'') <= CONVERT(date,@End_Date,103) OR @End_Date = '' ))
		AND ((CONVERT(date,ISNULL(ADR.Actual_Right_End_Date,'9999-12-31'),103) <=  CONVERT(date,@End_Date,103) OR @End_Date = '') AND (CONVERT(date,ISNULL(ADR.Actual_Right_End_Date,'9999-12-31'),103)>= CONVERT(date,@Start_Date,103) OR @Start_Date = '' )))
		AND AD.Agreement_No like '%' + @Agreement_No + '%' 
		AND (AD.Is_Master_Deal = @Is_Master_Deal Or @Is_Master_Deal = '')
		AND (AD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
		AND (AD.Business_Unit_Code = CAST(@Business_Unit_code AS INT) OR CAST(@Business_Unit_code AS INT) = 0)
		AND (
				@Title_Name = '' OR ADRT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Name,','))
				OR 
				ad.Master_Deal_Movie_Code_ToLink IN (SELECT admT.Acq_Deal_Movie_Code FROM Acq_Deal_Movie admT where admT.Title_Code IN (select number from fn_Split_withdelemiter(@Title_Name,',')))
			)

	PRINT 'Insertion in temp table'
	BEGIN

		INSERT INTO #RightTable(Acq_Deal_Code,Acq_Deal_Rights_Code,Platform_Codes,Platform_Names,Region_Name,Subtitle,Dubbing,RunType)
		SELECT Acq_Deal_Code,Acq_Deal_Right_Code,null,null,null,null,null,null  FROM #TEMP_Acquition_Deal_List_Report

		INSERT INTO #TitleTable(Title_Code,Eps_From,Eps_To,Director,StarCast,Genre)
		Select DISTINCT Title_Code,Episode_From,Episode_To,null,null,null FROM #TEMP_Acquition_Deal_List_Report

		INSERT INTO #DealTitleTable(Acq_Deal_Code,Title_Code,Eps_From,Eps_To,Run_Type)
		SELECT DISTINCT Acq_Deal_code,Title_Code,Episode_From,Episode_To,null FROM #TEMP_Acquition_Deal_List_Report
	END

	PRINT 'Updating temp table'
	BEGIN
		IF(@IsDealSegment = 'Y')
		BEGIN
			DELETE tadlr FROM #TEMP_Acquition_Deal_List_Report tadlr
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = tadlr.Acq_Deal_Code
			WHERE AD.Deal_Segment_Code <> @DealSegment AND @DealSegment > 0
			
			UPDATE tadlr
			SET Deal_Segment = DS.Deal_Segment_Name
			FROM #TEMP_Acquition_Deal_List_Report tadlr
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = tadlr.Acq_Deal_Code
			INNER JOIN Deal_Segment DS ON DS.Deal_Segment_Code = AD.Deal_Segment_Code
		END

		IF(@IsRevenueVertical = 'Y')
		BEGIN
			UPDATE tadlr
			SET Revenue_Vertical = DS.Revenue_Vertical_Name
			FROM #TEMP_Acquition_Deal_List_Report tadlr
			INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = tadlr.Acq_Deal_Code
			INNER JOIN Revenue_Vertical DS ON DS.Revenue_Vertical_Code = AD.Revenue_Vertical_Code
		END

		IF(@IsTypeOfFilm = 'Y' AND @TypeOfFilm > 0)
		BEGIN
			DELETE tadlr FROM #TEMP_Acquition_Deal_List_Report tadlr
			WHERE (Columns_Value_Code <> @TypeOfFilm ) OR Columns_Value_Code IS NULL
		END
		

		PRINT '		Director, StartCast Insert and update for Primary Rights'	

		UPDATE TT SET TT.Director = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 1),TT.StarCast = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 2),TT.Genre = dbo.UFN_Get_Title_Genre(TT.TItle_Code)  
		FROM #TitleTable TT

		UPDATE TADLR SET TADLR.Director = TT.Director,TADLR.Star_Cast = TT.StarCast,TADLR.Genre = TT.Genre
		FROM #TEMP_Acquition_Deal_List_Report TADLR
		INNER JOIN #TitleTable TT ON TADLR.Title_Code = TT.Title_Code AND TADLR.Episode_From = TT.Eps_From AND TADLR.Episode_To = Eps_To

		PRINT '		Platform Insert and update for Primary Rights'

		UPDATE RT SET RT.Platform_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(AADRP.Platform_Code AS NVARCHAR(MAX)) from  Acq_Deal_Rights_Platform AADRP 
		WHERE RT.Acq_Deal_Rights_Code = AADRP.Acq_Deal_Rights_Code FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
		
		INSERT INTO #PlatformTable(Platform_Codes,Platform_Names)
		SELECT DISTINCT Platform_Codes,Platform_Names FROM #RightTable

		UPDATE PT SET PT.Platform_Names = a.Platform_Hierarchy
		from #PlatformTable PT
		CROSS APPLY  [dbo].[UFN_Get_Platform_Hierarchy_WithNo](Platform_Codes) a
		WHERE Platform_Codes IS NOT NULL

		UPDATE RT SET RT.Platform_Names = PT.Platform_Names
		FROM #RightTable RT
		INNER JOIN #PlatformTable PT ON RT.Platform_Codes = PT.Platform_Codes

		UPDATE TADLR SET TADLR.Platform_Name = RT.Platform_Names
		FROM #TEMP_Acquition_Deal_List_Report TADLR 
		INNER JOIN #RightTable RT ON TADLR.Acq_Deal_Right_Code = RT.Acq_Deal_Rights_Code
		
		PRINT '		Region,Subtitle,Dubbing Insert and update for Primary Rights'

		UPDATE RT SET RT.Region_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRP.Country_Code IS NULL THEN AADRP.Territory_Code ELSE AADRP.Country_Code END AS NVARCHAR(MAX))
		from  Acq_Deal_Rights_Territory AADRP 
		WHERE RT.Acq_Deal_Rights_Code = AADRP.Acq_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 

		UPDATE RT SET RT.RGType = ADRT.Territory_Type
		FROM #RightTable RT 
		INNER JOIN Acq_Deal_Rights_Territory ADRT ON RT.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 

		UPDATE RT SET RT.SL_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRS.Language_Code IS NULL THEN AADRS.Language_Group_Code ELSE AADRS.Language_Code END AS NVARCHAR(MAX))
		from  Acq_Deal_Rights_Subtitling AADRS 
		WHERE RT.Acq_Deal_Rights_Code = AADRS.Acq_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,''),
		RT.DB_Codes =
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRD.Language_Code IS NULL THEN AADRD.Language_Group_Code ELSE AADRD.Language_Code END AS NVARCHAR(MAX))
		from  Acq_Deal_Rights_Dubbing AADRD 
		WHERE RT.Acq_Deal_Rights_Code = AADRD.Acq_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 

		UPDATE RT SET RT.SLType = ADRS.Language_Type
		FROM #RightTable RT 
		INNER JOIN Acq_Deal_Rights_Subtitling ADRS ON RT.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code 

		UPDATE RT SET RT.DBType = ADRD.Language_Type
		FROM #RightTable RT 
		INNER JOIN Acq_Deal_Rights_Dubbing ADRD ON RT.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code 

		INSERT INTO #RegionTable(Region_Codes,Region_Names,Region_Type)
		SELECT DISTINCT Region_Codes,NULL,RGType FROM #RightTable

		INSERT INTO #LangTable(Lang_Codes,Lang_Names,Lang_Type)
		SELECT DISTINCT SL_Codes,NULL,SLType FROM #RightTable
		UNION
		SELECT DISTINCT DB_Codes,NULL,DBType FROM #RightTable

		UPDATE RT SET RT.Region_Names = CT.Criteria_Name FROM #RegionTable RT
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](RT.Region_Codes,RT.Region_Type,'RG') CT

		UPDATE LTB SET LTB.Lang_Names = LT.Criteria_Name FROM #LangTable LTB
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](LTB.Lang_Codes,LTB.Lang_Type,'SL') LT

		UPDATE RT SET RT.Region_Name = RTG.Region_Names FROM #RightTable RT
		INNER JOIN #RegionTable RTG ON RT.Region_Codes = RTG.Region_Codes AND RT.RGType = RTG.Region_Type

		UPDATE RT SET RT.Subtitle = LTG.Lang_Names FROM #RightTable RT
		INNER JOIN #LangTable LTG ON RT.SL_Codes = LTG.Lang_Codes AND RT.SLType = LTG.Lang_Type

		UPDATE RT SET RT.Dubbing = LTG.Lang_Names FROM #RightTable RT
		INNER JOIN #LangTable LTG ON RT.DB_Codes = LTG.Lang_Codes AND RT.DBType = LTG.Lang_Type

		UPDATE TADLR SET TADLR.Country_Territory_Name = RT.Region_Name
		,TADLR.Subtitling = ISNULL(RT.Subtitle,''),TADLR.Dubbing = ISNULL(RT.Dubbing,'') FROM #TEMP_Acquition_Deal_List_Report TADLR
		INNER JOIN #RightTable RT ON TADLR.Acq_Deal_Right_Code = RT.Acq_Deal_Rights_Code

		UPDATE DTT SET DTT.Run_Type = adr.Run_Type
		from #DealTitleTable DTT
		INNER JOIN Acq_Deal_Run adr ON adr.Acq_Deal_Code = DTT.Acq_Deal_Code
		INNER JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adr.Acq_Deal_Run_Code
		WHERE adrt.Title_Code = DTT.Title_Code AND adrt.Episode_From = DTT.Eps_From AND adrt.Episode_To = DTT.Eps_To

		UPDATE TADLR SET TADLR.Run_Type = CASE WHEN DTT.Run_Type = 'U' THEN 'Unlimited' WHEN DTT.Run_Type = 'C' THEN 'Limited' ELSE 'NA' END
		FROM #TEMP_Acquition_Deal_List_Report TADLR
		INNER JOIN #DealTitleTable DTT ON TADLR.Acq_Deal_code = DTT.Acq_Deal_Code AND TADLR.Episode_From = DTT.Eps_From AND TADLR.Episode_To = DTT.Eps_To

	END

	IF(@Is_Pushback != 'N' )
	BEGIN
		---- Tnsert Right in #TEMP_Acquition_Deal_List_Report table ---

		INSERT INTO #TEMP_Acquition_Deal_List_Report_Pushback
		(
			Acq_Deal_Pushback_Code
			,Business_Unit_Name
			,Title_Code
			,Title_Name 
			,Episode_From
			,Episode_To
			,Deal_Type_Code
			,Director, Star_Cast 
			,Genre, Title_Language, year_of_production, Acq_Deal_code, Deal_Description, Reference_No, 
			Agreement_No, Is_Master_Deal, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party,Party_Master,
			Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right, 
			Country_Territory_Name, Is_Exclusive, 
			Subtitling, Dubbing, Sub_Licencing, 
			Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks, 
			Holdback_Platform,Holdback_Rights
			,Blackout, 
			General_Remark, Rights_Remarks, Payment_Remarks, 
			Right_Type, Right_Term,
			Deal_Workflow_Status, Is_Pushback, Master_Deal_Movie_Code_ToLink, Run_Type,Is_Attachment,[Program_Name],
			Due_Diligence,
			Category_Name,
			Columns_Value_Code
		)
		SELECT 
			ADP.Acq_Deal_Pushback_Code
			,BU.Business_Unit_Name
			,T.Title_Code
			,T.Title_Name
			,CAST(ADPT.Episode_From AS INT)
			,ADPT.Episode_To
			,AD.Deal_Type_Code
			--,dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) Director
			--,dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) Star_Cast
			--,dbo.UFN_Get_Title_Genre(t.title_code) Genre
			,'' Director 
			,'' Star_Cast
			,'' Genre
			,ISNULL(L.language_name, '') AS Title_Language, t.year_of_production, AD.Acq_Deal_Code, AD.Deal_Desc, AD.Ref_No,
			AD.Agreement_No, AD.Is_Master_Deal, CAST(AD.Agreement_Date as date), ad.Deal_Tag_Code, tg.Deal_Tag_Description, V.Vendor_Name, pg.Party_Group_Name
			--,[dbo].[UFN_Get_Platform_Name](ADP.Acq_Deal_Pushback_Code, 'AP') Platform_Name
			,'' Platform_Name
			, ADP.Right_Start_Date, ADP.Right_End_Date, ADP.Is_Title_Language_Right, 
			--CASE (DBO.UFN_Get_Rights_Country(ADP.Acq_Deal_Pushback_Code, 'P',''))
			--	WHEN '' THEN DBO.UFN_Get_Rights_Territory(ADP.Acq_Deal_Pushback_Code, 'P')
			--	ELSE DBO.UFN_Get_Rights_Country(ADP.Acq_Deal_Pushback_Code, 'P','')
			-- END AS  Country_Territory_Name,
			'' AS  Country_Territory_Name,
			'' Is_Exclusive
			--DBO.UFN_Get_Rights_Subtitling(ADP.Acq_Deal_Pushback_Code, 'P') Subtitling
			--,DBO.UFN_Get_Rights_Dubbing(ADP.Acq_Deal_Pushback_Code, 'P') Dubbing,
			,'' Subtitling
			,'' Dubbing
			,'' SubLicencing, ADP.Is_Tentative, 'N' Is_ROFR, NULL First_Refusal_Date, '' Restriction_Remarks 
			,'' Holdback_Platform,'' Holdback_Rights
			,'' Blackout, '' General_Remark ,ADP.Remarks Rights_Remarks
			,'' Payment_Remarks, ADP.Right_Type,
			CASE ADP.Right_Type
				WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](ADP.Right_Start_Date, Right_End_Date, Term) 
				WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
				WHEN 'U' THEN 'Perpetuity'
			End Right_Term,
			CASE UPPER(LTRIM(RTRIM(ISNULL(AD.Deal_Workflow_Status, '')))) 
				WHEN 'N' THEN 'Created'
				WHEN 'W' THEN 'Sent for authorization'
				WHEN 'A' THEN 'Approved' 
				WHEN 'R' THEN 'Declined'
				WHEN 'AM' THEN 'Ammended'
				ELSE Deal_Workflow_Status 
			END AS Deal_Workflow_Status, 'Y' as Is_Pushback, AD.Master_Deal_Movie_Code_ToLink, '--',
			CASE WHEN (SELECT count(*) from Acq_Deal_Attachment ADT WHERE ADT.Acq_Deal_Code = AD.Acq_Deal_Code) > 0 THEN 'Yes'
			           ELSE 'No'
			END AS Is_Attachment,
			P.Program_Name as 'Program_Name',
			CASE UPPER(LTRIM(RTRIM(ISNULL(ADM.Due_Diligence, '')))) 
				WHEN 'N' THEN 'No'
				WHEN 'Y' THEN 'Yes'
				ELSE 'No' 
			END AS Due_Diligence,
			C.Category_Name,MEC.Columns_Value_Code
		FROM Acq_Deal AD
			INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
			INNER JOIN Acq_Deal_Pushback ADP On AD.Acq_Deal_Code = ADP.Acq_Deal_Code
			INNER JOIN Acq_Deal_Pushback_Title ADPT On ADP.Acq_Deal_Pushback_Code = ADPT.Acq_Deal_Pushback_Code 
			INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
			LEFT JOIN Party_Group PG ON v.Party_Group_Code = PG.Party_Group_Code
			INNER JOIN Deal_Tag TG On AD.Deal_Tag_Code = TG.Deal_Tag_Code
			INNER JOIN Title T On ADPT.Title_Code = T.title_code
			LEFT JOIN Program P on T.Program_Code = P.Program_Code
			LEFT JOIN Language L on T.Title_Language_Code = L.language_code
			LEFT JOIN Acq_Deal_Movie ADM on ADPT.Title_Code = ADM.Title_Code AND ADPT.Episode_From = ADM.Episode_Starts_From AND ADPT.Episode_To = ADM.Episode_End_To AND ADM.Acq_Deal_Code = AD.Acq_Deal_Code
			INNER JOIN Category C ON AD.Category_Code = C.Category_Code
			LEFT JOIN Map_Extended_columns MEC ON MEC.Record_Code = T.Title_Code AND MEC.Columns_Code = @Columns_Code
		WHERE  
			AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
			(((ISNULL(CONVERT(date,ADP.Right_Start_Date,103),'') >= CONVERT(date,@Start_Date,103)OR @Start_Date = ''  )AND (ISNULL(CONVERT(date,ADP.Right_Start_Date,103),'') <= CONVERT(date,@End_Date,103)OR @End_Date = ''))
			AND ((CONVERT(date,ISNULL(ADP.Right_End_Date,'9999-12-31'),103)<=  CONVERT(date,@End_Date,103) OR @End_Date = ''  ) AND (CONVERT(date,ISNULL(ADP.Right_End_Date,'9999-12-31'),103) >= CONVERT(date,@Start_Date,103)OR @Start_Date = ''  )))
			AND AD.Agreement_No like '%' + @Agreement_No + '%' 
			AND (AD.Is_Master_Deal = @Is_Master_Deal Or @Is_Master_Deal = '')
			AND (AD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
			AND (AD.Business_Unit_Code = CAST(@Business_Unit_code AS INT)OR CAST(@Business_Unit_code AS INT) = 0)
			AND (@Title_Name = '' OR ADPT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Name,',')))

		PRINT 'Insertion in temp table In Pushback'
		BEGIN
			DELETE FROM #RightTable
			DELETE FROM #TitleTable
			DELETE FROM #DealTitleTable
			DELETE FROM #PlatformTable

			INSERT INTO #RightTable(Acq_Deal_Code,Acq_Deal_Pushback_Code,Platform_Codes,Platform_Names,Region_Name,Subtitle,Dubbing,RunType)
			SELECT Acq_Deal_Code,Acq_Deal_Pushback_Code,null,null,null,null,null,null  FROM #TEMP_Acquition_Deal_List_Report_Pushback

			INSERT INTO #TitleTable(Title_Code,Eps_From,Eps_To,Director,StarCast,Genre)
			Select DISTINCT Title_Code,Episode_From,Episode_To,null,null,null FROM #TEMP_Acquition_Deal_List_Report_Pushback

			INSERT INTO #DealTitleTable(Acq_Deal_Code,Title_Code,Eps_From,Eps_To,Run_Type)
			SELECT DISTINCT Acq_Deal_code,Title_Code,Episode_From,Episode_To,null FROM #TEMP_Acquition_Deal_List_Report_Pushback
		END

		PRINT 'Updating temp table'
		BEGIN
			IF(@IsDealSegment = 'Y')
			BEGIN
				DELETE tadlr FROM #TEMP_Acquition_Deal_List_Report_Pushback tadlr
				INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = tadlr.Acq_Deal_Code
				WHERE AD.Deal_Segment_Code <> @DealSegment AND @DealSegment > 0
			
				UPDATE tadlr
				SET Deal_Segment = DS.Deal_Segment_Name
				FROM #TEMP_Acquition_Deal_List_Report_Pushback tadlr
				INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = tadlr.Acq_Deal_Code
				INNER JOIN Deal_Segment DS ON DS.Deal_Segment_Code = AD.Deal_Segment_Code
			END

			IF(@IsRevenueVertical = 'Y')
			BEGIN
				UPDATE tadlr
				SET Revenue_Vertical = DS.Revenue_Vertical_Name
				FROM #TEMP_Acquition_Deal_List_Report_Pushback tadlr
				INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = tadlr.Acq_Deal_Code
				INNER JOIN Revenue_Vertical DS ON DS.Revenue_Vertical_Code = AD.Revenue_Vertical_Code
			END

			IF(@IsTypeOfFilm = 'Y' AND @TypeOfFilm > 0)
			BEGIN
				DELETE tadlr FROM #TEMP_Acquition_Deal_List_Report_Pushback tadlr
				WHERE (Columns_Value_Code <> @TypeOfFilm ) OR Columns_Value_Code IS NULL
			END


			PRINT '		Director, StartCast Insert and update for Primary Rights (Pushback)'	

			UPDATE TT SET TT.Director = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 1),TT.StarCast = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 2),TT.Genre = dbo.UFN_Get_Title_Genre(TT.TItle_Code)  
			FROM #TitleTable TT

			UPDATE TADLR SET TADLR.Director = TT.Director,TADLR.Star_Cast = TT.StarCast,TADLR.Genre = TT.Genre
			FROM #TEMP_Acquition_Deal_List_Report_Pushback TADLR
			INNER JOIN #TitleTable TT ON TADLR.Title_Code = TT.Title_Code AND TADLR.Episode_From = TT.Eps_From AND TADLR.Episode_To = Eps_To

			PRINT '		Platform Insert and update for Primary Rights (Pushback)'

			UPDATE RT SET RT.Platform_Codes = 
			STUFF((Select DISTINCT ',' +  CAST(AADRP.Platform_Code AS NVARCHAR(MAX)) from  Acq_Deal_Pushback_Platform AADRP 
			WHERE RT.Acq_Deal_Pushback_Code = AADRP.Acq_Deal_Pushback_Code FOR XML PATH('')),1,1,'')
			FROM #RightTable RT 
		
			INSERT INTO #PlatformTable(Platform_Codes,Platform_Names)
			SELECT DISTINCT Platform_Codes,Platform_Names FROM #RightTable

			UPDATE PT SET PT.Platform_Names = a.Platform_Hierarchy
			from #PlatformTable PT
			CROSS APPLY  [dbo].[UFN_Get_Platform_Hierarchy_WithNo](Platform_Codes) a
			WHERE Platform_Codes IS NOT NULL

			UPDATE RT SET RT.Platform_Names = PT.Platform_Names
			FROM #RightTable RT
			INNER JOIN #PlatformTable PT ON RT.Platform_Codes = PT.Platform_Codes

			UPDATE TADLR SET TADLR.Platform_Name = RT.Platform_Names
			FROM #TEMP_Acquition_Deal_List_Report_Pushback TADLR 
			INNER JOIN #RightTable RT ON TADLR.Acq_Deal_Pushback_Code = RT.Acq_Deal_Pushback_Code
		
			PRINT '		Region,Subtitle,Dubbing Insert and update for Primary Rights (Pushback)'

			UPDATE RT SET RT.Region_Codes = 
			STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRP.Country_Code IS NULL THEN AADRP.Territory_Code ELSE AADRP.Country_Code END AS NVARCHAR(MAX))
			from  Acq_Deal_Pushback_Territory AADRP 
			WHERE RT.Acq_Deal_Pushback_Code = AADRP.Acq_Deal_Pushback_Code --order by AADRP.Platform_Code ASC
					   FOR XML PATH('')),1,1,'')
			FROM #RightTable RT 

			UPDATE RT SET RT.RGType = ADRT.Territory_Type
			FROM #RightTable RT 
			INNER JOIN Acq_Deal_Pushback_Territory ADRT ON RT.Acq_Deal_Pushback_Code = ADRT.Acq_Deal_Pushback_Code 

			UPDATE RT SET RT.SL_Codes = 
			STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRS.Language_Code IS NULL THEN AADRS.Language_Group_Code ELSE AADRS.Language_Code END AS NVARCHAR(MAX))
			from  Acq_Deal_Pushback_Subtitling AADRS 
			WHERE RT.Acq_Deal_Pushback_Code = AADRS.Acq_Deal_Pushback_Code --order by AADRP.Platform_Code ASC
					   FOR XML PATH('')),1,1,''),
			RT.DB_Codes =
			STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRD.Language_Code IS NULL THEN AADRD.Language_Group_Code ELSE AADRD.Language_Code END AS NVARCHAR(MAX))
			from  Acq_Deal_Pushback_Dubbing AADRD 
			WHERE RT.Acq_Deal_Pushback_Code = AADRD.Acq_Deal_Pushback_Code --order by AADRP.Platform_Code ASC
					   FOR XML PATH('')),1,1,'')
			FROM #RightTable RT 

			UPDATE RT SET RT.SLType = ADRS.Language_Type
			FROM #RightTable RT 
			INNER JOIN Acq_Deal_Pushback_Subtitling ADRS ON RT.Acq_Deal_Pushback_Code = ADRS.Acq_Deal_Pushback_Code 

			UPDATE RT SET RT.DBType = ADRD.Language_Type
			FROM #RightTable RT 
			INNER JOIN Acq_Deal_Pushback_Dubbing ADRD ON RT.Acq_Deal_Pushback_Code = ADRD.Acq_Deal_Pushback_Code 

			INSERT INTO #RegionTable(Region_Codes,Region_Names,Region_Type)
			SELECT DISTINCT Region_Codes,NULL,RGType FROM #RightTable

			INSERT INTO #LangTable(Lang_Codes,Lang_Names,Lang_Type)
			SELECT DISTINCT SL_Codes,NULL,SLType FROM #RightTable
			UNION
			SELECT DISTINCT DB_Codes,NULL,DBType FROM #RightTable

			UPDATE RT SET RT.Region_Names = CT.Criteria_Name FROM #RegionTable RT
			CROSS APPLY [UFN_Get_PR_Rights_Criteria](RT.Region_Codes,RT.Region_Type,'RG') CT

			UPDATE LTB SET LTB.Lang_Names = LT.Criteria_Name FROM #LangTable LTB
			CROSS APPLY [UFN_Get_PR_Rights_Criteria](LTB.Lang_Codes,LTB.Lang_Type,'SL') LT

			UPDATE RT SET RT.Region_Name = RTG.Region_Names FROM #RightTable RT
			INNER JOIN #RegionTable RTG ON RT.Region_Codes = RTG.Region_Codes AND RT.RGType = RTG.Region_Type

			UPDATE RT SET RT.Subtitle = LTG.Lang_Names FROM #RightTable RT
			INNER JOIN #LangTable LTG ON RT.SL_Codes = LTG.Lang_Codes AND RT.SLType = LTG.Lang_Type

			UPDATE RT SET RT.Dubbing = LTG.Lang_Names FROM #RightTable RT
			INNER JOIN #LangTable LTG ON RT.DB_Codes = LTG.Lang_Codes AND RT.DBType = LTG.Lang_Type

			UPDATE TADLR SET TADLR.Country_Territory_Name = RT.Region_Name
			,TADLR.Subtitling = ISNULL(RT.Subtitle,''),TADLR.Dubbing = ISNULL(RT.Dubbing,'') FROM #TEMP_Acquition_Deal_List_Report_Pushback TADLR
			INNER JOIN #RightTable RT ON TADLR.Acq_Deal_Pushback_Code = RT.Acq_Deal_Pushback_Code

			UPDATE DTT SET DTT.Run_Type = adr.Run_Type
			from #DealTitleTable DTT
			INNER JOIN Acq_Deal_Run adr ON adr.Acq_Deal_Code = DTT.Acq_Deal_Code
			INNER JOIN Acq_Deal_Run_Title adrt ON adrt.Acq_Deal_Run_Code = adr.Acq_Deal_Run_Code
			WHERE adrt.Title_Code = DTT.Title_Code AND adrt.Episode_From = DTT.Eps_From AND adrt.Episode_To = DTT.Eps_To

			UPDATE TADLR SET TADLR.Run_Type = CASE WHEN DTT.Run_Type = 'U' THEN 'Unlimited' WHEN DTT.Run_Type = 'C' THEN 'Limited' ELSE 'NA' END
			FROM #TEMP_Acquition_Deal_List_Report_Pushback TADLR
			INNER JOIN #DealTitleTable DTT ON TADLR.Acq_Deal_code = DTT.Acq_Deal_Code AND TADLR.Episode_From = DTT.Eps_From AND TADLR.Episode_To = DTT.Eps_To

		END


		PRINT 'Merging with Pushback'
		INSERT INTO #TEMP_Acquition_Deal_List_Report
		(
			Acq_Deal_Right_Code,Business_Unit_Name,Title_Code,Title_Name,Episode_From,Episode_To
			,Deal_Type_Code,Director, Star_Cast
			,Genre, Title_Language, year_of_production, Acq_Deal_code 
			,Deal_Description, Reference_No, Agreement_No, Is_Master_Deal, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party,Party_Master
			,Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right
			,Country_Territory_Name,Is_Exclusive, Subtitling,Dubbing,Sub_Licencing
			,Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks
			,Holdback_Platform,Holdback_Rights ,Blackout
			,General_Remark, Rights_Remarks, Payment_Remarks, Right_Type
			,Right_Term,Deal_Workflow_Status
			,Is_Pushback, Master_Deal_Movie_Code_ToLink
			,Run_Type,Is_Attachment,[Program_Name],Due_Diligence,Category_Name
		)
		SELECT 
			Acq_Deal_Pushback_Code,Business_Unit_Name,Title_Code,Title_Name ,Episode_From,Episode_To
			,Deal_Type_Code,Director, Star_Cast 
			,Genre, Title_Language, year_of_production, Acq_Deal_code
			, Deal_Description, Reference_No, Agreement_No, Is_Master_Deal, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party,Party_Master,
			Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right, 
			Country_Territory_Name, Is_Exclusive, Subtitling, Dubbing, Sub_Licencing, 
			Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks, 
			Holdback_Platform,Holdback_Rights,Blackout, 
			General_Remark, Rights_Remarks, Payment_Remarks, Right_Type
			, Right_Term,Deal_Workflow_Status, 
			Is_Pushback, Master_Deal_Movie_Code_ToLink
			, Run_Type,Is_Attachment,[Program_Name],
			Due_Diligence,
			Category_Name
		FROM #TEMP_Acquition_Deal_List_Report_Pushback

	END


	SELECT DISTINCT 
		CASE
			WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'Y' THEN  TEMP_ADLR.Title_Name
			ELSE DBO.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(TEMP_ADLR.Deal_Type_Code), TEMP_ADLR.Title_Name, TEMP_ADLR.Episode_From, TEMP_ADLR.Episode_To)		
		END AS Title_Name,
		CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN '' ELSE TEMP_ADLR.Director END AS Director,
		CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN '' ELSE TEMP_ADLR.Star_Cast END AS Star_Cast,
		CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN '' ELSE TEMP_ADLR.Genre END AS Genre,
		CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN '' ELSE TEMP_ADLR.Title_Language END AS Title_Language,
		CASE WHEN UPPER(RTRIM(LTRIM(ISNULL(TEMP_ADLR.Is_Master_Deal, '')))) = 'N' THEN NULL ELSE TEMP_ADLR.year_of_production END AS Year_Of_Production,
		TEMP_ADLR.Agreement_No AS Agreement_No, 
		TEMP_ADLR.Deal_Description AS Deal_Description, 
		TEMP_ADLR.Reference_No AS Reference_No, 
		TEMP_ADLR.Is_Master_Deal, 
		TEMP_ADLR.Agreement_Date AS Agreement_Date, TEMP_ADLR.Deal_Tag_Description AS Deal_Tag_Description, 
		TEMP_ADLR.Deal_Segment, 
		TEMP_ADLR.Revenue_Vertical ,
		TEMP_ADLR.Party AS Party, Temp_ADLR.Party_Master,
		CASE WHEN Is_PushBack = 'N' THEN TEMP_ADLR.Platform_Name ELSE '--' END AS Platform_Name, 
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_Start_Date ELSE NULL END AS Rights_Start_Date, 
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_End_Date ELSE NULL END AS Rights_End_Date, 
		TEMP_ADLR.Is_Title_Language_Right,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Country_Territory_Name ELSE '--' END AS Country_Territory_Name,
		TEMP_ADLR.Is_Exclusive AS Is_Exclusive, 
		CASE LTRIM(RTRIM(TEMP_ADLR.Subtitling)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_ADLR.Subtitling)) END AS Subtitling, 
		CASE LTRIM(RTRIM(TEMP_ADLR.Dubbing)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_ADLR.Dubbing)) END AS Dubbing, 
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Sub_Licencing ELSE '--' END AS Sub_Licencing,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Is_Tentative ELSE '--' END AS Is_Tentative,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' AND TEMP_ADLR.Is_ROFR = 'Y' THEN TEMP_ADLR.First_Refusal_Date ELSE NULL END AS First_Refusal_Date,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Restriction_Remarks ELSE '--' END AS Restriction_Remarks,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Holdback_Platform ELSE '--' END AS Holdback_Platform,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Holdback_Rights ELSE '--' END AS Holdback_Rights,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Blackout ELSE '--' END AS Blackout,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.General_Remark ELSE '--' END AS General_Remark,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Rights_Remarks ELSE '--' END AS Rights_Remarks,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Payment_Remarks ELSE '--' END AS Payment_Remarks,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_Type ELSE '--' END AS Right_Type,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_Term ELSE '--' END AS Term,
		CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Is_Tentative ELSE '--' END AS Pushback_Is_Tentative, 
		CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Platform_Name ELSE '--' END AS Pushback_Platform_Name, 
		CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Right_Start_Date ELSE NULL END AS Pushback_Start_Date, 
		CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Right_End_Date ELSE NULL END AS Pushback_End_Date, 
		CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Country_Territory_Name ELSE '--' END AS Pushback_Country_Name, 
		CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Rights_Remarks ELSE '--' END AS Pushback_Remark, 
		CASE WHEN TEMP_ADLR.Is_PushBack = 'Y' THEN TEMP_ADLR.Right_Term ELSE '--' END AS Pushback_Term,
		TEMP_ADLR.Deal_Workflow_Status AS Deal_Workflow_Status, 
		TEMP_ADLR.Is_PushBack AS Is_PushBack,
		TEMP_ADLR.Run_Type AS Run_Type,
		TEMP_ADLR.Is_Attachment As Is_Attachment,
		TEMP_ADLR.[Program_Name] As [Program_Name],
		(SELECT Deal_Type_Name FROM Deal_Type AS DT WHERE DT.Deal_Type_Code=TEMP_ADLR.Deal_Type_Code) AS Deal_Type,
		TEMP_ADLR.Promtoer_Group AS Promoter_Group_Name,
		TEMP_ADLR.Promtoer_Remarks AS Promoter_Remarks_Name,
		TEMP_ADLR.Due_Diligence,
		TEMP_ADLR.Category_Name,
		TEMP_ADLR.Business_Unit_Name
	INTO #TempAcqDealListReport
	FROM #TEMP_Acquition_Deal_List_Report TEMP_ADLR
		LEFT JOIN Acq_Deal_Movie ADM ON TEMP_ADLR.Master_Deal_Movie_Code_ToLink = ADM.Acq_Deal_Movie_Code
	ORDER BY TEMP_ADLR.Agreement_No, TEMP_ADLR.Is_Pushback

	BEGIN
		SELECT 
			@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'ReferenceNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'DealType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'AgreementDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'Party' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'Program' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			@Col_Head11 = CASE WHEN  SM.Message_Key = 'Director' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			@Col_Head12 = CASE WHEN  SM.Message_Key = 'starCast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			@Col_Head13 = CASE WHEN  SM.Message_Key = 'Genres' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			@Col_Head14 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
			@Col_Head15 = CASE WHEN  SM.Message_Key = 'ReleaseYear' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			@Col_Head16 = CASE WHEN  SM.Message_Key = 'Platform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
			@Col_Head17 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			@Col_Head18 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			@Col_Head19 = CASE WHEN  SM.Message_Key = 'Tentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			@Col_Head20 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			@Col_Head21 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
			@Col_Head22 = CASE WHEN  SM.Message_Key = 'Exclusive' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
			@Col_Head23 = CASE WHEN  SM.Message_Key = 'TitleLanguageRight' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
			@Col_Head24 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END,
			@Col_Head25 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head25 END,
			@Col_Head26 = CASE WHEN  SM.Message_Key = 'Sublicensing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head26 END,
			@Col_Head27 = CASE WHEN  SM.Message_Key = 'ROFR' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head27 END,
			@Col_Head28 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head28 END,
			@Col_Head29 = CASE WHEN  SM.Message_Key = 'RightsHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head29 END,
			@Col_Head30 = CASE WHEN  SM.Message_Key = 'RightsHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head30 END,
			@Col_Head31 = CASE WHEN  SM.Message_Key = 'Blackout' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head31 END,
			@Col_Head32 = CASE WHEN  SM.Message_Key = 'RightsRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head32 END,
			@Col_Head33 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head33 END,
 			@Col_Head34 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head34 END,
			@Col_Head35 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head35 END,
			@Col_Head36 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head36 END,
			@Col_Head37 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTerm' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head37 END,
			@Col_Head38 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackCountry' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head38 END,
			@Col_Head39 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head39 END,
			@Col_Head40 = CASE WHEN  SM.Message_Key = 'GeneralRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head40 END,
			@Col_Head41 = CASE WHEN  SM.Message_Key = 'Paymenttermsconditions' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head41 END,
			@Col_Head42 = CASE WHEN  SM.Message_Key = 'WorkflowStatus' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head42 END,
			@Col_Head43 = CASE WHEN  SM.Message_Key = 'RunType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head43 END,
			@Col_Head44 = CASE WHEN  SM.Message_Key = 'Attachment' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head44 END,
			@Col_Head45 = CASE WHEN  SM.Message_Key = 'SelfUtilizationGroup' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head45 END,
			@Col_Head46 = CASE WHEN  SM.Message_Key = 'SelfUtilizationRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head46 END,
			@Col_Head47 = CASE WHEN  SM.Message_Key = 'DueDiligence' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head47 END,
			@Col_Head48 = CASE WHEN  SM.Message_Key = 'CategoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head48 END,
			@Col_Head49 = CASE WHEN  SM.Message_Key = 'PartyMasterName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head49 END,
			@Col_Head50 = 'Deal Segment',
			@Col_Head51 = 'Revenue Vertical',
			@Col_Head52 = 'Business Unit Name'

		 FROM System_Message SM  
		 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
		 AND SM.Message_Key IN ('AgreementNo','TitleType','DealDescription','ReferenceNo','DealType','AgreementDate','Status','Party','PartyMasterName','Program','Title','Director','starCast','Genres','TitleLanguage','ReleaseYear','Platform','RightStartDate','RightEndDate',
		 'Tentative','Term','Region','Exclusive','TitleLanguageRight','Subtitling','Dubbing','Sublicensing','ROFR','RestrictionRemarks','RightsHoldbackPlatform','RightsHoldbackRemark','Blackout','RightsRemark','ReverseHoldbackPlatform','ReverseHoldbackStartDate'
		 ,'ReverseHoldbackEndDate','ReverseHoldbackTentative','ReverseHoldbackTerm','ReverseHoldbackCountry','ReverseHoldbackRemark','GeneralRemarks','Paymenttermsconditions','WorkflowStatus','RunType','Attachment','SelfUtilizationGroup','SelfUtilizationRemarks','DueDiligence','CategoryName')  
		 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  

		IF EXISTS(SELECT TOP 1 * FROM #TempAcqDealListReport)
		BEGIN
			SELECT 
				 [Agreement_No] , [Business Unit Name],
				 [Title Type], [Deal Description], [Reference No], [Deal Type]
				 , [Agreement Date], [Status], [Deal Segment], [Revenue Vertical], [Party],[Party_Master], [Program], [Title], [Director]
				 , [Star Cast],[Genre], [Title Language], [Release Year], [Platform], [Rights Start Date], [Rights End Date], [Tentative], [Pushback], [Term], [Region], [Exclusive], [Title Language Right],
				 [Subtitling], [Dubbing], [Sub Licensing], [ROFR], [Restriction Remark], [Rights Holdback Platform], [Rights Holdback Remarks], [Blackout], [Rights Remarks],
				 [Reverse Holdback Platform], [Reverse Holdback Start Date], [Reverse Holdback End Date], [Reverse Holdback Tentative], [Reverse Holdback Term], [Reverse Holdback Country],
				 [Reverse Holdback Remarks], [General Remark], [Payment terms & Conditions], [Workflow status], [Run Type], [Attachment], [Self Utilization Group], [Self Utilization Remarks], [Due Diligence],[Category_Name]
			FROM (
			    
			SELECT
				sorter = 1,
				CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], CAST(Business_Unit_Name AS VARCHAR(100))  AS [Business Unit Name], 
				CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No], CAST([Is_Master_Deal] AS NVARCHAR(MAX)) As [Deal Type],
				CONVERT(VARCHAR(12),[Agreement_Date],103) As [Agreement Date], CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status], CAST([Deal_Segment] AS NVARCHAR(MAX)) As [Deal Segment], CAST([Revenue_Vertical] AS NVARCHAR(MAX)) As [Revenue Vertical], CAST([Party] AS NVARCHAR(MAX)) As [Party], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
				CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(VARCHAR(12),[Rights_Start_Date],103) AS [Rights Start Date], 
				CONVERT(VARCHAR(12),[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
				CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CAST([First_Refusal_Date] AS NVARCHAR(MAX)) As [ROFR],
				CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
				CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], CONVERT(VARCHAR(12),[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(VARCHAR(12),[Pushback_End_Date],103) As [Reverse Holdback End Date],
				CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
				CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
				CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks],  CAST([Due_Diligence] AS NVARCHAR(MAX)) As [Due Diligence], CAST([Category_Name] AS NVARCHAR(MAX)) AS [Category_Name],Cast([Party_Master] AS NVARCHAR(MAX)) AS Party_Master
			From #TempAcqDealListReport
			UNION ALL
				SELECT CAST(0 AS Varchar(100)), @Col_Head01, @Col_Head52,
				@Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head50, @Col_Head51, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11
				, @Col_Head12, @Col_Head13, @Col_Head14, @Col_Head15,  @Col_Head16, @Col_Head17, @Col_Head18, @Col_Head19,'', @Col_Head20, @Col_Head21, @Col_Head22, @Col_Head23, @Col_Head24, @Col_Head25, @Col_Head26
				, @Col_Head27, @Col_Head28, @Col_Head29, @Col_Head30, @Col_Head31, @Col_Head32, @Col_Head33, @Col_Head34, @Col_Head35, @Col_Head36, @Col_Head37, @Col_Head38, @Col_Head39, @Col_Head40
				, @Col_Head41, @Col_Head42, @Col_Head43, @Col_Head44, @Col_Head45, @Col_Head46, @Col_Head47,@Col_Head48,@Col_Head49
			) X   
			ORDER BY Sorter
		END
		ELSE 
		BEGIN
			SELECT * FROM #TempAcqDealListReport
		END
	END
END
GO
PRINT N'Altering [dbo].[USP_List_Rights]...';


GO
ALTER PROC [dbo].[USP_List_Rights]
(
	@Right_Type Char(2), 
	@View_Type Char(1), 
	@Deal_Code Int, 
	@Deal_Movie_Codes Varchar(5000),
	@RegionCodes varchar(5000),
	@PlatformCodes varchar(5000),
	@ISExclusive Varchar(5),
	@PageNo INT OUT,
	@PageSize INT = 10,
	@TotalRecord INT OUT,
	@SearchText NVARCHAR(MAX)
)
AS
 --=============================================
-- Author:		Abhaysingh N Rajpurohit
-- Create DATE: 14-October-2014
-- Description:	Get Acquistion Right, Syndication List and Syndication Pushback List page
-- =============================================
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT ON 

	--DECLARE @Right_Type Char(2) = 'AR', 
	--@View_Type Char(1) = 'G', 
	--@Deal_Code Int =  16550, 
	--@Deal_Movie_Codes Varchar(5000) = '',
	--@RegionCodes varchar(5000) = '',
	--@PlatformCodes varchar(5000)= '',
	--@ISExclusive Varchar(5) = 'B',
	--@PageNo INT = 1,
	--@PageSize INT = 100,
	--@TotalRecord INT = 0,
	--@SearchText NVARCHAR(MAX) = ''

	PRINT 'Process Started ' + CAST(GETDATE() AS VARCHAR)
	SET @SearchText = LTRIM(RTRIM(@SearchText))
	IF(@SearchText <> '')
		SET @View_Type = 'G'

	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''

	PRINT '  Getting ''Deal_Type_Code'' and ''Deal_Type_Condition'''
	IF(@Right_Type In('AR', 'AP'))
		Select @Selected_Deal_Type_Code = Deal_Type_Code From Acq_Deal WITH(NOLOCK) Where Acq_Deal_Code = @Deal_Code
	Else
		Select @Selected_Deal_Type_Code = Deal_Type_Code From Syn_Deal WITH(NOLOCK) Where Syn_Deal_Code = @Deal_Code

	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	PRINT '  Got ''Deal_Type_Code'' : ' + CAST(@Selected_Deal_Type_Code AS VARCHAR) + ' and ''Deal_Type_Condition'' : ' + @Deal_Type_Condition

	PRINT '  Drop all temp tables, if exists'
	IF(OBJECT_ID('TEMPDB..#TempRightsPagingData') IS NOT NULL)
		DROP TABLE #TempRightsPagingData

	IF(OBJECT_ID('TEMPDB..#TempTitle') IS NOT NULL)
		DROP TABLE #TempTitle

	IF(OBJECT_ID('TEMPDB..#TempRights') IS NOT NULL)
		DROP TABLE #TempRights

	IF(OBJECT_ID('TEMPDB..#TempResultData') IS NOT NULL)
		DROP TABLE #TempResultData

	IF(OBJECT_ID('TEMPDB..#TempDealMovie') IS NOT NULL)
		DROP TABLE #TempDealMovie

	IF(OBJECT_ID('TEMPDB..#TempPlatformCodes') IS NOT NULL)
		DROP TABLE #TempPlatformCodes

	IF(OBJECT_ID('TEMPDB..#TempRightCodes') IS NOT NULL)
		DROP TABLE #TempRightCodes

	IF(OBJECT_ID('TEMPDB..#TempRightCodesGroup') IS NOT NULL)
		DROP TABLE #TempRightCodesGroup

	IF(OBJECT_ID('TEMPDB..#TempRightCodesSummary') IS NOT NULL)
		DROP TABLE #TempRightCodesSummary

	IF(OBJECT_ID('TEMPDB..#TempRightCodesDetails') IS NOT NULL)
		DROP TABLE #TempRightCodesDetails

	PRINT '  Create temp tables'
	CREATE TABLE #TempRightsPagingData
	(
		Row_No INT IDENTITY(1,1),
		Deal_Code INT,
		Rights_Code INT,
		Title_Code INT DEFAULT(0),
		Episode_From INT DEFAULT(0),
		Episode_To INT DEFAULT(0),
		Platform_Code INT DEFAULT(0),
	)

	CREATE TABLE #TempTitle
	(
		Title_Code INT DEFAULT(0),
		Episode_From INT DEFAULT(0),
		Episode_To INT DEFAULT(0),
		Title_Name NVARCHAR(MAX),
		Is_Closed CHAR(1)
	)

	CREATE TABLE #TempRights
	(
		Deal_Code INT,
		Rights_Code INT,
		Title_Code INT DEFAULT(0),
		Episode_From INT DEFAULT(0),
		Episode_To INT DEFAULT(0),
		Platform_Code INT DEFAULT(0),
		Title_Name NVARCHAR(MAX),
		Platform_Name NVARCHAR(MAX),
		Is_Holdback VARCHAR(5),
		Is_Exclusive VARCHAR(100),
		Is_Sublicencing VARCHAR(5),
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Term VARCHAR(10),
		Is_Theatrical VARCHAR(10),
		Country NVARCHAR(MAX),
		Territory NVARCHAR(MAX),
		Remarks NVARCHAR(max),
		Right_Type VARCHAR(5),
		Is_Tentative VARCHAR(10),
		IsTentative CHAR(1),
		Milestone_Type_Code INT,
		Milestone_No_Of_Unit INT,
		Milestone_Unit_Type INT,
		Title_Language_Right VARCHAR(5),
		Sub_Titling_Language NVARCHAR(MAX),
		Dubbing_Titling_Language NVARCHAR(MAX),
		Right_Term VARCHAR(MAX),
		Right_Status CHAR(1),
		Is_Syn_Acq_Mapp CHAR(1),
		Is_ROFR CHAR(1) NULL ,
		ROFR_Date DATETIME NULL ,
		IsDelete char(1) DEFAULT('N'),
		Is_Ref_Close_Title CHAR(1),
		Last_Updated_Time DATETIME
	)

	CREATE TABLE #TempResultData
	(
		Deal_Code INT,
		Rights_Code INT,
		Title_Code INT DEFAULT(0),
		Episode_From INT DEFAULT(0),
		Episode_To INT DEFAULT(0),
		Platform_Code INT DEFAULT(0),
		Title_Name NVARCHAR(MAX),
		Platform_Name NVARCHAR(MAX),
		Is_Holdback VARCHAR(5),
		Is_Exclusive VARCHAR(100),
		Is_Sublicencing VARCHAR(5),
		Rights_Start_Date DATETIME,
		Rights_End_Date DATETIME,
		Term VARCHAR(10),
		Is_Theatrical VARCHAR(10),
		Country NVARCHAR(MAX),
		Territory NVARCHAR(MAX),
		Remarks NVARCHAR(max),
		Right_Type VARCHAR(5),
		Is_Tentative VARCHAR(10),
		Milestone_Type_Code INT,
		Milestone_No_Of_Unit INT,
		Milestone_Unit_Type INT,
		Title_Language_Right VARCHAR(5),
		Sub_Titling_Language NVARCHAR(MAX),
		Dubbing_Titling_Language NVARCHAR(MAX),
		Right_Term VARCHAR(MAX),
		Right_Status CHAR(1),
		Is_Syn_Acq_Mapp CHAR(1),
		Is_ROFR CHAR(1) NULL ,
		ROFR_Date DATETIME NULL ,
		IsDelete char(1) DEFAULT('N'),
		Is_Ref_Close_Title CHAR(1),
		Last_Updated_Time DATETIME
	)

	CREATE TABLE #TempDealMovie
	(
		Deal_Movie_Code INT,
		Title_Code		INT,
		Episode_From	INT,
		Episode_To		INT
	)

	CREATE TABLE #TempPlatformCodes
	(
		Platform_Code		INT,
		Platform_Hiearachy	NVARCHAR(MAX)
	)

	CREATE TABLE #TempRightCodes
	(
		Right_Code INT,
		Is_Exclusive CHAR(1),
		Last_Updated_Time DATETIME
	)

	CREATE TABLE #TempRightCodesGroup
	(
		Row_No INT IDENTITY(1,1),
		Rights_Code INT,
	)

	CREATE TABLE #TempRightCodesSummary
	(
		Row_No INT IDENTITY(1,1),
		Rights_Code INT,
		Title_Code INT DEFAULT(0),
		Episode_From INT DEFAULT(0),
		Episode_To INT DEFAULT(0),
	)

	CREATE TABLE #TempRightCodesDetails
	(
		Row_No INT IDENTITY(1,1),
		Rights_Code INT,
		Platform_Code INT
	)


	IF(ISNULL(@Deal_Movie_Codes, '') = '')
	BEGIN
		PRINT '  Select All ''Deal_Movie_Code'' for current deal'
		IF(@Right_Type IN ('AR', 'AP'))
		BEGIN
			INSERT INTO #TempDealMovie(Deal_Movie_Code, Title_Code, Episode_From, Episode_To)
			SELECT Acq_Deal_Movie_Code, Title_Code, Episode_Starts_From, Episode_End_To FROM Acq_Deal_Movie WITH(NOLOCK) WHERE Acq_Deal_Code = @Deal_Code
		END
		ELSE
		BEGIN
			INSERT INTO #TempDealMovie(Deal_Movie_Code, Title_Code, Episode_From, Episode_To)
			SELECT Syn_Deal_Movie_Code, Title_Code, Episode_From, Episode_End_To FROM Syn_Deal_Movie WITH(NOLOCK) WHERE Syn_Deal_Code = @Deal_Code
		END
	END
	ELSE
	BEGIN
		INSERT INTO #TempDealMovie(Deal_Movie_Code)
		Select  number AS Deal_Movie_Code From DBO.fn_Split_withdelemiter(@Deal_Movie_Codes, ',') WHERE number <> ''

		IF(@Right_Type IN ('AR', 'AP'))
		BEGIN
			UPDATE TDM SET TDM.Title_Code = ADM.Title_Code, TDM.Episode_From = ADM.Episode_Starts_From, TDM.Episode_To = ADM.Episode_End_To 
			FROM Acq_Deal_Movie ADM WITH(NOLOCK)
			INNER JOIN #TempDealMovie TDM ON TDM.Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
		END
		ELSE
		BEGIN
			UPDATE TDM SET TDM.Title_Code = SDM.Title_Code, TDM.Episode_From = SDM.Episode_From, TDM.Episode_To = SDM.Episode_End_To 
			FROM Syn_Deal_Movie SDM WITH(NOLOCK)
			INNER JOIN #TempDealMovie TDM ON TDM.Deal_Movie_Code = SDM.Syn_Deal_Movie_Code
		END
	END

	IF(ISNULL(@PlatformCodes, '') <> '')
	BEGIN
		INSERT INTO #TempPlatformCodes(Platform_Code)
		Select number AS Platform_Code From DBO.fn_Split_withdelemiter(@PlatformCodes, ',')  WHERE NUMBER <> ''

		UPDATE TP SET TP.Platform_Hiearachy = P.Platform_Hiearachy FROM #TempPlatformCodes TP
		INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = TP.Platform_Code
	END

	PRINT '  Select All ''Right_Code'' for current deal'
	IF(@Right_Type = 'AR')
	BEGIN
		INSERT INTO #TempRightCodes(Right_Code, Is_Exclusive, Last_Updated_Time)
		SELECT Acq_Deal_Rights_Code, Is_Exclusive, Last_Updated_Time FROM Acq_Deal_Rights WITH(NOLOCK) WHERE Acq_Deal_Code = @Deal_Code 
		AND(Is_Exclusive IN((Select number From DBO.fn_Split_withdelemiter(@ISExclusive, ',')  WHERE NUMBER <> '')) OR @ISExclusive = 'B')
	END
	ELSE IF(@Right_Type = 'AP')
	BEGIN
		INSERT INTO #TempRightCodes(Right_Code, Is_Exclusive, Last_Updated_Time)
		SELECT Acq_Deal_Pushback_Code, 'Y', Last_Updated_Time FROM Acq_Deal_Pushback WITH(NOLOCK) WHERE Acq_Deal_Code = @Deal_Code
	END
	ELSE IF(@Right_Type = 'SR')
	BEGIN
		INSERT INTO #TempRightCodes(Right_Code, Is_Exclusive, Last_Updated_Time)
		SELECT Syn_Deal_Rights_Code, Is_Exclusive, Last_Updated_Time FROM Syn_Deal_Rights WITH(NOLOCK) WHERE Syn_Deal_Code = @Deal_Code AND ISNULL(Is_Pushback, 'N')  = 'N'
		AND(Is_Exclusive IN((Select number From DBO.fn_Split_withdelemiter(@ISExclusive, ',')  WHERE NUMBER <> '')) OR @ISExclusive = 'B')
	END
	ELSE IF(@Right_Type = 'SP')
	BEGIN
		INSERT INTO #TempRightCodes(Right_Code, Is_Exclusive, Last_Updated_Time)
		SELECT Syn_Deal_Rights_Code, Is_Exclusive, Last_Updated_Time FROM Syn_Deal_Rights WITH(NOLOCK) WHERE Syn_Deal_Code = @Deal_Code AND ISNULL(Is_Pushback, 'N')  = 'Y'
	END

	PRINT '  View Type : ' + CASE WHEN @View_Type = 'G' THEN 'Group'  WHEN @View_Type = 'S' THEN 'Summary' ELSE 'Detail' END
	IF(@Right_Type = 'AR')
	BEGIN
		PRINT '  Right Type : Acq Rights Tab'
		IF(@SearchText = '')
		BEGIN
			PRINT '  Nothing To Search'
			INSERT INTO #TempRightCodesGroup(Rights_Code)
			SELECT Right_Code FROM (
				SELECT DISTINCT ADR.Right_Code, ADR.Last_Updated_Time FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Rights_Platform ADRP WITH(NOLOCK) ON ADRP.Acq_Deal_Rights_Code = ADR.Right_Code
				WHERE (ADRP.Platform_Code IN ((Select number From DBO.fn_Split_withdelemiter(@PlatformCodes, ',')  WHERE NUMBER <> '')) OR @PlatformCodes = '')
				INTERSECT
				SELECT DISTINCT ADR.Right_Code, ADR.Last_Updated_Time FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Rights_Territory ADRTT WITH(NOLOCK) ON ADRTT.Acq_Deal_Rights_Code = ADR.Right_Code
				AND(
					(ADRTT.Territory_Type = 'G' AND ADRTT.Territory_Code IN(SELECT REPLACE(number,'T','') as Territory_Code FROM fn_Split_withdelemiter(@RegionCodes, ',') WHERE number <> '' AND number LIKE 'T%')OR @RegionCodes = '') OR 
					(ADRTT.Territory_Type = 'I' AND ADRTT.Country_Code IN(SELECT REPLACE(number,'C','') as Country_Code FROM fn_Split_withdelemiter(@RegionCodes, ',') WHERE number <> '' AND number LIKE 'C%') OR @RegionCodes = '')
				)
				INTERSECT
				SELECT DISTINCT ADR.Right_Code, ADR.Last_Updated_Time FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Right_Code
				INNER JOIN #TempDealMovie TDM ON ADRT.Title_Code  = TDM.Title_Code AND ADRT.Episode_From = TDM.Episode_From 
				AND ADRT.Episode_To = TDM.Episode_To
			)AS A
			ORDER BY A.Last_Updated_Time DESC
		END
		ELSE IF(@View_Type = 'G')
		BEGIN
			PRINT '  Search for Bulk Update'
			INSERT INTO #TempRightCodesGroup(Rights_Code)
			SELECT Right_Code FROM (
				SELECT DISTINCT ADR.Right_Code, ADR.Last_Updated_Time FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Rights_Platform ADRP WITH(NOLOCK) ON ADRP.Acq_Deal_Rights_Code = ADR.Right_Code
				INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = ADRP.Platform_Code
				WHERE P.Platform_Hiearachy LIKE '%' + @SearchText + '%'
				UNION
				SELECT DISTINCT ADR.Right_Code, ADR.Last_Updated_Time FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Right_Code
				INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = ADRT.Title_Code
				WHERE T.Title_Name LIKE '%' + @SearchText + '%'
				UNION
				SELECT DISTINCT ADR.Right_Code, ADR.Last_Updated_Time FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Rights_Territory ADRC WITH(NOLOCK) ON ADRC.Acq_Deal_Rights_Code = ADR.Right_Code
				LEFT JOIN Country C WITH(NOLOCK) ON C.Country_Code = ADRC.Country_Code AND ADRC.Territory_Type <> 'G' AND ADRC.Territory_Code IS NULL
				LEFT JOIN Territory TC WITH(NOLOCK) ON TC.Territory_Code = ADRC.Territory_Code AND ADRC.Territory_Type = 'G' AND ADRC.Country_Code IS NULL
				WHERE C.Country_Name LIKE '%' + @SearchText + '%' OR TC.Territory_Name LIKE '%' + @SearchText + '%' 
				UNION
				SELECT DISTINCT ADR.Right_Code, ADR.Last_Updated_Time FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Rights_Subtitling ADRS WITH(NOLOCK) ON ADRS.Acq_Deal_Rights_Code = ADR.Right_Code
				LEFT JOIN [Language] LS WITH(NOLOCK) ON LS.Language_Code = ADRS.Language_Code AND ADRS.Language_Type <> 'G' AND ADRS.Language_Group_Code IS NULL
				LEFT JOIN [Language_Group] LSG WITH(NOLOCK) ON LSG.Language_Group_Code = ADRS.Language_Group_Code AND ADRS.Language_Type = 'G' AND ADRS.Language_Code IS NULL
				WHERE LS.Language_Name LIKE '%' + @SearchText + '%' OR LSG.Language_Group_Name LIKE '%' + @SearchText + '%'
				UNION
				SELECT DISTINCT ADR.Right_Code, ADR.Last_Updated_Time FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Rights_Dubbing ADRD WITH(NOLOCK) ON ADRD.Acq_Deal_Rights_Code = ADR.Right_Code
				LEFT JOIN [Language] LD WITH(NOLOCK) ON LD.Language_Code = ADRD.Language_Code AND ADRD.Language_Type <> 'G' AND ADRD.Language_Group_Code IS NULL
				LEFT JOIN [Language_Group] LDG WITH(NOLOCK) ON LDG.Language_Group_Code = ADRD.Language_Group_Code 
					AND ADRD.Language_Type = 'G' AND ADRD.Language_Code IS NULL
				WHERE LD.Language_Name LIKE '%' + @SearchText + '%' OR 
					LDG.Language_Group_Name LIKE '%' + @SearchText + '%'
			)AS A
			ORDER BY A.Last_Updated_Time DESC
		END
	END
	ELSE IF(@Right_Type = 'AP')
	BEGIN
		PRINT '  Right Type : Acq Pushback Tab'
		INSERT INTO #TempRightCodesGroup(Rights_Code)
			SELECT Right_Code FROM (
			SELECT DISTINCT ADP.Right_Code, ADP.Last_Updated_Time FROM #TempRightCodes ADP
			INNER JOIN Acq_Deal_Pushback_Platform ADPP WITH(NOLOCK) ON ADPP.Acq_Deal_Pushback_Code = ADP.Right_Code
			WHERE (ADPP.Platform_Code IN ((Select number From DBO.fn_Split_withdelemiter(@PlatformCodes, ',')  WHERE NUMBER <> '')) OR @PlatformCodes = '')
			INTERSECT	
			SELECT DISTINCT ADP.Right_Code, ADP.Last_Updated_Time FROM #TempRightCodes ADP
			INNER JOIN Acq_Deal_Pushback_Territory ADPTT WITH(NOLOCK) ON ADPTT.Acq_Deal_Pushback_Code = ADP.Right_Code 
			WHERE (
				(ADPTT.Territory_Type = 'G' AND ADPTT.Territory_Code IN(SELECT REPLACE(number,'T','') as Territory_Code FROM fn_Split_withdelemiter(@RegionCodes, ',') WHERE number <> '' AND number LIKE 'T%')OR @RegionCodes = '') OR 
				(ADPTT.Territory_Type = 'I' AND ADPTT.Country_Code IN(SELECT REPLACE(number,'C','') as Country_Code FROM fn_Split_withdelemiter(@RegionCodes, ',') WHERE number <> '' AND number LIKE 'C%') OR @RegionCodes = '')
			)
			INTERSECT
			SELECT DISTINCT ADP.Right_Code, ADP.Last_Updated_Time FROM #TempRightCodes ADP
			INNER JOIN Acq_Deal_Pushback_Title ADPT WITH(NOLOCK) ON ADPT.Acq_Deal_Pushback_Code = ADP.Right_Code
			INNER JOIN #TempDealMovie TDM ON ADPT.Title_Code  = TDM.Title_Code AND ADPT.Episode_From = TDM.Episode_From 
			AND ADPT.Episode_To = TDM.Episode_To
			
		) AS A
		ORDER BY A.Last_Updated_Time DESC
	END
	ELSE IF(@Right_Type IN ('SR', 'SP'))
	BEGIN
		PRINT '  Right Type : ' + CASE @Right_Type WHEN 'SR' THEN 'Syn Rights Tab' ELSE 'Syn Pushback Tab' END
		IF(@SearchText = '')
		BEGIN
			PRINT '  Nothing To Search'
			INSERT INTO #TempRightCodesGroup(Rights_Code)
			SELECT Right_Code FROM (
				SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR
				INNER JOIN Syn_Deal_Rights_Platform SDRP WITH(NOLOCK) ON SDRP.Syn_Deal_Rights_Code = SDR.Right_Code
				WHERE (SDRP.Platform_Code IN ((Select number From DBO.fn_Split_withdelemiter(@PlatformCodes, ',')  WHERE NUMBER <> '')) OR @PlatformCodes = '')
				INTERSECT
				SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR
				INNER JOIN Syn_Deal_Rights_Territory SDRTT WITH(NOLOCK) ON SDRTT.Syn_Deal_Rights_Code = SDR.Right_Code
				WHERE(
					(SDRTT.Territory_Type = 'G' AND SDRTT.Territory_Code IN(SELECT REPLACE(number,'T','') as Territory_Code FROM fn_Split_withdelemiter(@RegionCodes, ',') WHERE number <> '' AND number LIKE 'T%')OR @RegionCodes = '') OR 
					(SDRTT.Territory_Type = 'I' AND SDRTT.Country_Code IN(SELECT REPLACE(number,'C','') as Country_Code FROM fn_Split_withdelemiter(@RegionCodes, ',') WHERE number <> '' AND number LIKE 'C%') OR @RegionCodes = '')
				)
				INTERSECT
				SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR
  				INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDRT.Syn_Deal_Rights_Code = SDR.Right_Code
				INNER JOIN #TempDealMovie TDM ON SDRT.Title_Code  = TDM.Title_Code AND SDRT.Episode_From = TDM.Episode_From 
				AND SDRT.Episode_To = TDM.Episode_To
			) AS A
			ORDER BY A.Last_Updated_Time DESC

		END
		ELSE IF(@View_Type = 'G')
		BEGIN
			PRINT '  Search for Bulk Update'
			INSERT INTO #TempRightCodesGroup(Rights_Code)
			SELECT Right_Code FROM (
				SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR
				INNER JOIN Syn_Deal_Rights_Platform SDRP WITH(NOLOCK) ON SDRP.Syn_Deal_Rights_Code = SDR.Right_Code
				INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = SDRP.Platform_Code
				WHERE P.Platform_Hiearachy LIKE '%' + @SearchText + '%'
				UNION
				SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR 
				INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDRT.Syn_Deal_Rights_Code = SDR.Right_Code
				INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = SDRT.Title_Code
				WHERE T.Title_Name LIKE '%' + @SearchText + '%'
				UNION
				SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR 
				INNER JOIN Syn_Deal_Rights_Territory SDRC WITH(NOLOCK) ON SDRC.Syn_Deal_Rights_Code = SDR.Right_Code
				LEFT JOIN Country C WITH(NOLOCK) ON C.Country_Code = SDRC.Country_Code AND SDRC.Territory_Type <> 'G' AND SDRC.Territory_Code IS NULL
				LEFT JOIN Territory TC WITH(NOLOCK) ON TC.Territory_Code = SDRC.Territory_Code AND SDRC.Territory_Type = 'G' AND SDRC.Country_Code IS NULL
				WHERE C.Country_Name LIKE '%' + @SearchText + '%' OR TC.Territory_Name LIKE '%' + @SearchText + '%'
				UNION
				SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR 
				INNER JOIN Syn_Deal_Rights_Subtitling SDRS WITH(NOLOCK) ON SDRS.Syn_Deal_Rights_Code = SDR.Right_Code
				LEFT JOIN [Language] LS WITH(NOLOCK) ON LS.Language_Code = SDRS.Language_Code AND SDRS.Language_Type <> 'G' AND SDRS.Language_Group_Code IS NULL
				LEFT JOIN [Language_Group] LSG WITH(NOLOCK) ON LSG.Language_Group_Code = SDRS.Language_Group_Code AND SDRS.Language_Type = 'G' AND SDRS.Language_Code IS NULL
				WHERE LS.Language_Name LIKE '%' + @SearchText + '%' OR LSG.Language_Group_Name LIKE '%' + @SearchText + '%'
				UNION
				SELECT DISTINCT SDR.Right_Code, SDR.Last_Updated_Time FROM #TempRightCodes SDR 
				INNER JOIN Syn_Deal_Rights_Dubbing SDRD WITH(NOLOCK) ON SDRD.Syn_Deal_Rights_Code = SDR.Right_Code
				LEFT JOIN [Language] LD WITH(NOLOCK) ON LD.Language_Code = SDRD.Language_Code AND SDRD.Language_Type <> 'G' AND SDRD.Language_Group_Code IS NULL
				LEFT JOIN [Language_Group] LDG WITH(NOLOCK) ON LDG.Language_Group_Code = SDRD.Language_Group_Code AND SDRD.Language_Type = 'G' AND SDRD.Language_Code IS NULL
				WHERE  LD.Language_Name LIKE '%' + @SearchText + '%' OR LDG.Language_Group_Name LIKE '%' + @SearchText + '%'
			)AS A
			ORDER BY A.Last_Updated_Time DESC

		END
	END

	IF(@View_Type = 'G')
	BEGIN
		INSERT INTO #TempRightsPagingData(Deal_Code, Rights_Code)
		SELECT @Deal_Code, Rights_Code FROM #TempRightCodesGroup
		ORDER BY Row_No
	END
	ELSE
	BEGIN
		IF(@Right_Type = 'AR')
		BEGIN
			INSERT INTO #TempRightCodesSummary(Rights_Code, Title_Code, Episode_From, Episode_To)
			SELECT ADRT.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To FROM #TempRightCodesGroup ADR
			INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADR.Rights_Code = ADRT.Acq_Deal_Rights_Code
			INNER JOIN #TempDealMovie TDM ON ADRT.Title_Code  = TDM.Title_Code AND ADRT.Episode_From = TDM.Episode_From AND ADRT.Episode_To = TDM.Episode_To
			INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = ADRT.Title_Code
			ORDER BY T.Title_Name
		END
		IF(@Right_Type = 'AP')
		BEGIN
			INSERT INTO #TempRightCodesSummary(Rights_Code, Title_Code, Episode_From, Episode_To)
			SELECT ADPT.Acq_Deal_Pushback_Code, ADPT.Title_Code, ADPT.Episode_From, ADPT.Episode_To FROM #TempRightCodesGroup ADP
			INNER JOIN Acq_Deal_Pushback_Title ADPT WITH(NOLOCK) ON ADP.Rights_Code = ADPT.Acq_Deal_Pushback_Code
			INNER JOIN #TempDealMovie TDM ON ADPT.Title_Code  = TDM.Title_Code AND ADPT.Episode_From = TDM.Episode_From AND ADPT.Episode_To = TDM.Episode_To
			INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = ADPT.Title_Code
			ORDER BY T.Title_Name
		END
		IF(@Right_Type = 'SR' OR @Right_Type = 'SP')
		BEGIN
			INSERT INTO #TempRightCodesSummary(Rights_Code, Title_Code, Episode_From, Episode_To)
			SELECT SDRT.Syn_Deal_Rights_Code, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To FROM #TempRightCodesGroup SDR
			INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDR.Rights_Code = SDRT.Syn_Deal_Rights_Code
			INNER JOIN #TempDealMovie TDM ON SDRT.Title_Code  = TDM.Title_Code AND SDRT.Episode_From = TDM.Episode_From AND SDRT.Episode_To = TDM.Episode_To
			INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = SDRT.Title_Code
			ORDER BY T.Title_Name
		END	

		IF(@View_Type = 'S')
		BEGIN
			INSERT INTO #TempRightsPagingData(Deal_Code, Rights_Code, Title_Code, Episode_From, Episode_To)
			SELECT @Deal_Code, Rights_Code, Title_Code, Episode_From, Episode_To FROM #TempRightCodesSummary
			ORDER BY Row_No
		END
		ELSE
		BEGIN
			
			DELETE FROM #TempRightCodes
			INSERT INTO #TempRightCodes(Right_Code)
			SELECT DISTINCT Rights_Code FROM #TempRightCodesSummary

			IF(@Right_Type = 'AR')
			BEGIN
				INSERT INTO #TempRightCodesDetails(Rights_Code, Platform_Code)
				SELECT ADR.Right_Code, ADRP.Platform_Code
				FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Rights_Platform ADRP WITH(NOLOCK) ON ADRP.Acq_Deal_Rights_Code = ADR.Right_Code
			END
			IF(@Right_Type = 'AP')
			BEGIN
				INSERT INTO #TempRightCodesDetails(Rights_Code, Platform_Code)
				SELECT ADR.Right_Code, ADPP.Platform_Code
				FROM #TempRightCodes ADR
				INNER JOIN Acq_Deal_Pushback_Platform ADPP WITH(NOLOCK) ON ADPP.Acq_Deal_Pushback_Code = ADR.Right_Code
			END
			IF(@Right_Type = 'SR' OR @Right_Type = 'SP')
			BEGIN
				INSERT INTO #TempRightCodesDetails(Rights_Code, Platform_Code)
				SELECT SDR.Right_Code, SDRP.Platform_Code
				FROM #TempRightCodes SDR
				INNER JOIN Syn_Deal_Rights_Platform SDRP WITH(NOLOCK) ON SDRP.Syn_Deal_Rights_Code = SDR.Right_Code
			END

			IF NOT EXISTS(SELECT TOP 1 Platform_Code FROM #TempPlatformCodes)
			BEGIN
				INSERT INTO #TempPlatformCodes(Platform_Code, Platform_Hiearachy)
				SELECT A.Platform_Code, P.Platform_Hiearachy FROM (
				SELECT DISTINCT Platform_Code FROM #TempRightCodesDetails
				) AS A INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = A.Platform_Code
			END

			INSERT INTO #TempRightsPagingData(Deal_Code, Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code)
			SELECT @Deal_Code, RS.Rights_Code, RS.Title_Code, RS.Episode_From, RS.Episode_To, RD.Platform_Code FROM #TempRightCodesSummary RS
			INNER JOIN #TempRightCodesDetails RD ON RS.Rights_Code = RD.Rights_Code
			INNER JOIN #TempPlatformCodes TP ON TP.Platform_Code = RD.Platform_Code
			ORDER BY RS.Row_No, TP.Platform_Hiearachy
		END
	END
	
	PRINT '  START : Logic For Paging at ' + CAST(GETDATE() AS VARCHAR)
	SELECT @TotalRecord  = MAX(Row_No) FROM #TempRightsPagingData
	SET @TotalRecord = ISNULL(@TotalRecord, 0)
	SELECT @PageNo = DBO.UFN_Get_New_PageNo(@TotalRecord, @PageNo, @PageSize)

	DELETE FROM #TempRightsPagingData WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
	PRINT '  END : Logic For Paging' + CAST(GETDATE() AS VARCHAR)

	INSERT INTO #TempRights(Deal_Code, Rights_Code)
	SELECT DISTINCT Deal_Code, Rights_Code FROM #TempRightsPagingData

	IF(@View_Type <> 'G')
	BEGIN
		INSERT INTO #TempTitle(Title_Code, Episode_From, Episode_To)
		SELECT DISTINCT Title_Code, Episode_From, Episode_To FROM #TempRightsPagingData
	END
	ELSE
	BEGIN
		IF(@Right_Type = 'AR')
		BEGIN
			INSERT INTO #TempTitle(Title_Code, Episode_From, Episode_To)
			SELECT DISTINCT ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To FROM #TempRights TR
			INNER JOIN Acq_Deal_Rights_Title ADRT WITH(NOLOCK) ON ADRT.Acq_Deal_Rights_Code = TR.Rights_Code
		END
		ELSE IF(@Right_Type = 'AP')
		BEGIN
			INSERT INTO #TempTitle(Title_Code, Episode_From, Episode_To)
			SELECT DISTINCT ADPT.Title_Code, ADPT.Episode_From, ADPT.Episode_To FROM #TempRights TR
			INNER JOIN Acq_Deal_Pushback_Title ADPT WITH(NOLOCK) ON ADPT.Acq_Deal_Pushback_Code = TR.Rights_Code
		END
		ELSE
		BEGIN
			INSERT INTO #TempTitle(Title_Code, Episode_From, Episode_To)
			SELECT DISTINCT SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To FROM #TempRights TR
			INNER JOIN Syn_Deal_Rights_Title SDRT WITH(NOLOCK) ON SDRT.Syn_Deal_Rights_Code = TR.Rights_Code
		END
	END

	IF(@Right_Type IN ('AR','AP'))
	BEGIN
		UPDATE TT SET TT.Is_Closed = CASE WHEN  ISNULL(ADM.Is_Closed,'N') IN ('Y', 'X') THEN 'Y' ELSE 'N' END 
		FROM #TempTitle TT
		INNER JOIN Acq_Deal_Movie ADM WITH(NOLOCK) ON ADM.Title_Code = TT.Title_Code 
			AND ADM.Episode_Starts_From = TT.Episode_From AND ADM.Episode_End_To = TT.Episode_To
	END
	ELSE
	BEGIN
		UPDATE TT SET TT.Is_Closed = CASE WHEN  ISNULL(SDM.Is_Closed,'N') IN ('Y', 'X') THEN 'Y' ELSE 'N' END 
		FROM #TempTitle TT
		INNER JOIN Syn_Deal_Movie SDM WITH(NOLOCK) ON SDM.Title_Code = TT.Title_Code 
			AND SDM.Episode_From = TT.Episode_From AND SDM.Episode_End_To = TT.Episode_To
	END

	DECLARE @Is_Acq_Syn_CoExclusive CHAR(1) = ''
	SELECT @Is_Acq_Syn_CoExclusive = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_Acq_Syn_CoExclusive' 

	IF(@Right_Type = 'AR')
	BEGIN
		UPDATE TR SET TR.Is_Holdback = 'No', 
		TR.Is_Exclusive = CASE ISNULL(ADR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.Is_Sublicencing = CASE ISNULL(ADR.Is_Sub_License, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END,
		TR.Rights_Start_Date = ADR.Actual_Right_Start_Date, 
		TR.Rights_End_Date = ADR.Actual_Right_End_Date, 
		TR.Is_Theatrical = CASE ISNULL(ADR.Is_Theatrical_Right, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.Remarks = ADR.Restriction_Remarks, 
		TR.Right_Type = ADR.Right_Type,
		TR.Is_Tentative = CASE ISNULL(ADR.Is_Tentative, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.IsTentative = ISNULL(ADR.Is_Tentative, 'N'),
		TR.Term = ADR.Term,
		TR.Milestone_Type_Code = ADR.Milestone_Type_Code, 
		TR.Milestone_No_Of_Unit = ADR.Milestone_No_Of_Unit, 
		TR.Milestone_Unit_Type = ADR.Milestone_Unit_Type, 
		TR.Title_Language_Right = CASE ISNULL(ADR.Is_Title_Language_Right, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.Right_Status = ADR.Right_Status,
		TR.Is_ROFR = ADR.Is_ROFR, 
		TR.ROFR_Date = ADR.ROFR_Date,
		TR.Last_Updated_Time = ADR.Last_Updated_Time
		FROM Acq_Deal_Rights ADR WITH(NOLOCK)
		INNER JOIN #TempRights TR ON ADR.Acq_Deal_Rights_Code = tr.Rights_Code
		WHERE Acq_Deal_Code = @Deal_Code

		IF (@Is_Acq_Syn_CoExclusive = 'Y')
		BEGIN
			UPDATE TR SET
				TR.Is_Exclusive = CASE ISNULL(ADR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Exclusive' WHEN 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END
			FROM Acq_Deal_Rights ADR WITH(NOLOCK)
			INNER JOIN #TempRights TR ON ADR.Acq_Deal_Rights_Code = tr.Rights_Code
			WHERE Acq_Deal_Code = @Deal_Code
		END

	END
	ELSE IF(@Right_Type = 'AP')
	BEGIN
		UPDATE TR SET TR.Is_Holdback = 'No', 
		TR.Is_Exclusive = 'No', 
		TR.Is_Sublicencing = 'No',
		TR.Rights_Start_Date = ADP.Right_Start_Date, 
		TR.Rights_End_Date = ADP.Right_End_Date, 
		TR.Is_Theatrical = 'No', 
		TR.Remarks = ADP.Remarks, 
		TR.Right_Type = ADP.Right_Type,
		TR.Is_Tentative = CASE ISNULL(ADP.Is_Tentative, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.IsTentative = ISNULL(ADP.Is_Tentative, 'N'),
		TR.Term = ADP.Term,
		TR.Milestone_Type_Code = ADP.Milestone_Type_Code, 
		TR.Milestone_No_Of_Unit = ADP.Milestone_No_Of_Unit, 
		TR.Milestone_Unit_Type = ADP.Milestone_Unit_Type, 
		TR.Title_Language_Right = CASE ISNULL(ADP.Is_Title_Language_Right, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.Right_Status = 'D',
		TR.Last_Updated_Time = ADP.Last_Updated_Time
		FROM Acq_Deal_Pushback ADP WITH(NOLOCK)
		INNER JOIN #TempRights TR ON ADP.Acq_Deal_Pushback_Code = tr.Rights_Code
		WHERE Acq_Deal_Code = @Deal_Code
	END
	ELSE IF(@Right_Type IN ('SR', 'SP'))
	BEGIN
		UPDATE TR SET TR.Is_Holdback = 'No', 
		TR.Is_Exclusive = CASE ISNULL(SDR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.Is_Sublicencing = CASE ISNULL(SDR.Is_Sub_License, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END,
		TR.Rights_Start_Date = SDR.Actual_Right_Start_Date, 
		TR.Rights_End_Date = SDR.Actual_Right_End_Date, 
		TR.Is_Theatrical = CASE ISNULL(SDR.Is_Theatrical_Right, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.Remarks = SDR.Restriction_Remarks, 
		TR.Right_Type = SDR.Right_Type,
		TR.Is_Tentative = CASE ISNULL(SDR.Is_Tentative, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.IsTentative = ISNULL(SDR.Is_Tentative, 'N'),
		TR.Term = SDR.Term,
		TR.Milestone_Type_Code = SDR.Milestone_Type_Code, 
		TR.Milestone_No_Of_Unit = SDR.Milestone_No_Of_Unit, 
		TR.Milestone_Unit_Type = SDR.Milestone_Unit_Type, 
		TR.Title_Language_Right = CASE ISNULL(SDR.Is_Title_Language_Right, 'N') WHEN 'Y' THEN 'Yes' ELSE 'No' END, 
		TR.Right_Status = SDR.Right_Status,
		TR.Is_ROFR = SDR.Is_ROFR, 
		TR.ROFR_Date = SDR.ROFR_Date,
		TR.Last_Updated_Time = SDR.Last_Updated_Time
		FROM Syn_Deal_Rights SDR WITH(NOLOCK)
		INNER JOIN #TempRights TR ON SDR.Syn_Deal_Rights_Code = tr.Rights_Code
		WHERE Syn_Deal_Code = @Deal_Code

		IF (@Is_Acq_Syn_CoExclusive = 'Y' AND @Right_Type = 'SR')
		BEGIN
			UPDATE TR SET
				TR.Is_Exclusive = CASE ISNULL(SDR.Is_Exclusive, 'N') WHEN 'Y' THEN 'Exclusive' WHEN 'N' THEN 'Non-Exclusive' ELSE 'Co-Exclusive' END
			FROM Syn_Deal_Rights SDR WITH(NOLOCK)
			INNER JOIN #TempRights TR ON SDR.Syn_Deal_Rights_Code = tr.Rights_Code
			WHERE Syn_Deal_Code = @Deal_Code
		END

	END

	DECLARE @Type CHAR(1) = ''

	IF(@Right_Type = 'AR')
		SET @Type = 'A'
	ELSE IF(@Right_Type = 'AP')
		SET @Type = 'P'
	ELSE
		SET @Type = 'S'

	UPDATE TR SET 
	TR.Term = CASE WHEN TR.IsTentative = 'N' THEN dbo.UFN_Calculate_Term(TR.Rights_Start_Date, TR.Rights_End_Date) ELSE TR.Term END,
	TR.Country = DBO.UFN_Get_Rights_Country(TR.Rights_Code, @Type,''), 
	TR.Territory = DBO.UFN_Get_Rights_Territory(TR.Rights_Code, @Type),
	TR.Sub_Titling_Language = DBO.UFN_Get_Rights_Subtitling(TR.Rights_Code, @Type),
	TR.Dubbing_Titling_Language = DBO.UFN_Get_Rights_Dubbing(TR.Rights_Code, @Type),
	TR.Is_Syn_Acq_Mapp = CASE WHEN @Right_Type = 'AR' THEN DBO.UFN_Syn_Acq_Mapping(@View_Type, TR.Rights_Code, TR.Title_Code, TR.Platform_Code) ELSE 'N' END,
	TR.Is_Holdback = dbo.UFN_Get_Rights_Holdback_YN(0, TR.Rights_Code, @Type)
	FROM #TempRights TR

	IF(@View_Type <> 'G')
	BEGIN
		UPDATE TR SET 
		TR.Is_Syn_Acq_Mapp = CASE WHEN @Right_Type = 'AR' THEN DBO.UFN_Syn_Acq_Mapping(@View_Type, TRPD.Rights_Code, TRPD.Title_Code, TRPD.Platform_Code) ELSE 'N' END,
		TR.Is_Holdback = dbo.UFN_Get_Rights_Holdback_YN(TRPD.Platform_Code, TRPD.Rights_Code, @Type)
		FROM #TempRights TR
		INNER JOIN #TempRightsPagingData TRPD ON TRPD.Rights_Code = TR.Rights_Code 
	END

	IF(@View_Type <> 'D')
	BEGIN
		IF(@Right_Type = 'AR')
		BEGIN
			UPDATE TR SET TR.Is_Holdback = (
				CASE WHEN (SELECT COUNT(*) FROM Acq_Deal_Rights_Holdback ADRH WITH(NOLOCK) WHERE ADRH.Acq_Deal_Rights_Code = TR.Rights_Code) = 0 THEN 'N' ELSE 'Y' END
			)FROM #TempRights TR
		END
		ELSE IF(@Right_Type = 'SR')
		BEGIN
			UPDATE TR SET TR.Is_Holdback = (
				CASE WHEN (SELECT COUNT(*) FROM Syn_Deal_Rights_Holdback SDRH WITH(NOLOCK) WHERE SDRH.Syn_Deal_Rights_Code = TR.Rights_Code) = 0 THEN 'N' ELSE 'Y' END
			)FROM #TempRights TR
		END
	END
	UPDATE #TempRights SET Is_Holdback = CASE Is_Holdback WHEN 'Y' Then 'Yes' WHEN 'N' THEN 'No' ELSE '' END

	UPDATE TR SET 
	TR.Right_Term = Case TR.Right_Type
		When 'Y' Then [dbo].[UFN_Get_Rights_Term](TR.Rights_Start_Date, TR.Rights_End_Date, TR.Term) 
		When 'M' Then [dbo].[UFN_Get_Rights_Milestone](TR.Milestone_Type_Code, TR.Milestone_No_Of_Unit, TR.Milestone_Unit_Type)
		When 'U' Then 'Perpetuity'
	End
	FROM #TempRights TR

	UPDATE TT SET TT.Title_Name = DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, TT.Episode_From, TT.Episode_To)
	FROM #TempTitle TT
	INNER JOIN Title T WITH(NOLOCK) ON T.Title_Code = TT.Title_Code

	IF(@View_Type <> 'D')
	BEGIN
		IF(@Right_Type = 'AR')
		BEGIN
			UPDATE TR SET 
			TR.Platform_Code = (
				Select TOP 1 ADRP.Platform_Code
				FROM Acq_Deal_Rights_Platform ADRP WITH(NOLOCK)
				WHERE ADRP.Acq_Deal_Rights_Code = TR.Rights_Code
			)
			FROM #TempRights TR

			IF(@View_Type = 'G')
			BEGIN
				UPDATE TR SET 
				TR.Title_Name = (STUFF ((
					Select ', ' + T.Title_Name FROM Acq_Deal_Rights_Title ADRT WITH(NOLOCK)
					INNER JOIN #TempTitle T ON T.Title_Code = ADRT.Title_Code AND T.Episode_From = ADRT.Episode_From AND T.Episode_To = ADRT.Episode_To
					WHERE ADRT.Acq_Deal_Rights_Code = TR.Rights_Code
					ORDER BY T.Title_Name
					FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
				),
				TR.Is_Ref_Close_Title = (
					SELECT TOP 1 T.Is_Closed FROM Acq_Deal_Rights_Title ADRT WITH(NOLOCK)
					INNER JOIN #TempTitle T ON T.Title_Code = ADRT.Title_Code AND T.Episode_From = ADRT.Episode_From AND T.Episode_To = ADRT.Episode_To
					WHERE ADRT.Acq_Deal_Rights_Code = TR.Rights_Code
					ORDER BY T.Is_Closed DESC
				)
				FROM #TempRights TR
			END
		END
		ELSE IF(@Right_Type = 'AP')
		BEGIN
			UPDATE TR SET 
			TR.Platform_Code = (
				Select TOP 1 ADPP.Platform_Code
				FROM Acq_Deal_Pushback_Platform ADPP WITH(NOLOCK)
				WHERE ADPP.Acq_Deal_Pushback_Code = TR.Rights_Code
			)
			FROM #TempRights TR

			IF(@View_Type = 'G')
			BEGIN
				UPDATE TR SET 
				TR.Title_Name = (STUFF ((
					Select ', ' + T.Title_Name FROM Acq_Deal_Pushback_Title ADPT WITH(NOLOCK)
					INNER JOIN #TempTitle T ON T.Title_Code = ADPT.Title_Code AND T.Episode_From = ADPT.Episode_From AND T.Episode_To = ADPT.Episode_To
					WHERE ADPT.Acq_Deal_Pushback_Code = TR.Rights_Code
					FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
				),
				TR.Is_Ref_Close_Title = (
					SELECT TOP 1 T.Is_Closed FROM Acq_Deal_Pushback_Title ADPT WITH(NOLOCK)
					INNER JOIN #TempTitle T ON T.Title_Code = ADPT.Title_Code AND T.Episode_From = ADPT.Episode_From AND T.Episode_To = ADPT.Episode_To
					WHERE ADPT.Acq_Deal_Pushback_Code = TR.Rights_Code
					ORDER BY T.Is_Closed DESC
				)
				FROM #TempRights TR
			END
		END
		ELSE IF(@Right_Type IN ('SR', 'SP'))
		BEGIN
			UPDATE TR SET 
			TR.Platform_Code = (
				Select TOP 1 SDRP.Platform_Code
				FROM Syn_Deal_Rights_Platform SDRP WITH(NOLOCK)
				WHERE SDRP.Syn_Deal_Rights_Code = TR.Rights_Code
			)
			FROM #TempRights TR

			IF(@View_Type = 'G')
			BEGIN
				UPDATE TR SET 
				TR.Title_Name = (STUFF ((
					Select ', ' + T.Title_Name FROM Syn_Deal_Rights_Title SDRT WITH(NOLOCK)
					INNER JOIN #TempTitle T ON T.Title_Code = SDRT.Title_Code AND T.Episode_From = SDRT.Episode_From AND T.Episode_To = SDRT.Episode_To
					WHERE SDRT.Syn_Deal_Rights_Code = TR.Rights_Code
					FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')
				),
				TR.Is_Ref_Close_Title = (
					SELECT TOP 1 T.Is_Closed FROM Syn_Deal_Rights_Title SDRT WITH(NOLOCK)
					INNER JOIN #TempTitle T ON T.Title_Code = SDRT.Title_Code AND T.Episode_From = SDRT.Episode_From AND T.Episode_To = SDRT.Episode_To
					WHERE SDRT.Syn_Deal_Rights_Code = TR.Rights_Code
					ORDER BY T.Is_Closed DESC
				)
				FROM #TempRights TR
			END
		END

		UPDATE TR SET TR.Platform_Name = SUBSTRING(ISNULL(P.Platform_Hiearachy, ''), 1, 
			CASE WHEN CHARINDEX(' --', ISNULL(P.Platform_Hiearachy, ''), 1) > 0 THEN
				CHARINDEX(' --', ISNULL(P.Platform_Hiearachy, ''), 1) - 1 ELSE
				LEN(ISNULL(P.Platform_Hiearachy, '')) END
			),
		TR.Platform_Code = 0 FROM #TempRights TR 
		INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = TR.Platform_Code

		IF(@View_Type = 'G')
		BEGIN
			IF(@Deal_Type_Condition = 'DEAL_MOVIE')
				UPDATE #TempRights SET Episode_From = 1, Episode_To = 1

			INSERT INTO #TempResultData (
				Deal_Code, Rights_Code, Title_Code, Platform_Code, Title_Name, Episode_From, Episode_To, Platform_Name, 
				Is_Holdback, Is_Exclusive, Is_Sublicencing, Rights_Start_Date, Rights_End_Date, Term, Is_Theatrical, Country, 
				Territory, Remarks, Right_Type, Is_Tentative, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
				Title_Language_Right, Sub_Titling_Language, Dubbing_Titling_Language, Right_Term, Right_Status ,Is_Syn_Acq_Mapp, 
				Is_ROFR, ROFR_Date, IsDelete, Is_Ref_Close_Title, Last_Updated_Time
			)
			SELECT 
				TR.Deal_Code, TR.Rights_Code, TR.Title_Code, TR.Platform_Code, TR.Title_Name, TR.Episode_From, TR.Episode_To, TR.Platform_Name, 
				TR.Is_Holdback, TR.Is_Exclusive, TR.Is_Sublicencing, TR.Rights_Start_Date, TR.Rights_End_Date, TR.Term, TR.Is_Theatrical, TR.Country, 
				TR.Territory, TR.Remarks, TR.Right_Type, TR.Is_Tentative, TR.Milestone_Type_Code, TR.Milestone_No_Of_Unit, TR.Milestone_Unit_Type, 
				TR.Title_Language_Right, TR.Sub_Titling_Language, TR.Dubbing_Titling_Language, TR.Right_Term, TR.Right_Status, TR.Is_Syn_Acq_Mapp,
				TR.Is_ROFR ,ROFR_Date, TR.IsDelete, TR.Is_Ref_Close_Title, TR.Last_Updated_Time
			From #TempRights TR
		END
		ELSE
		BEGIN
			INSERT INTO #TempResultData (
				Deal_Code, Rights_Code, Title_Code, Platform_Code, Title_Name, Episode_From, Episode_To, Platform_Name, 
				Is_Holdback, Is_Exclusive, Is_Sublicencing, Rights_Start_Date, Rights_End_Date, Term, Is_Theatrical, Country, 
				Territory, Remarks, Right_Type, Is_Tentative, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
				Title_Language_Right, Sub_Titling_Language, Dubbing_Titling_Language, Right_Term, Right_Status ,Is_Syn_Acq_Mapp, 
				Is_ROFR, ROFR_Date, IsDelete, Is_Ref_Close_Title, Last_Updated_Time
			)
			SELECT 
				TR.Deal_Code, TR.Rights_Code, TT.Title_Code, TR.Platform_Code, TT.Title_Name, TT.Episode_From, TT.Episode_To, TR.Platform_Name, 
				TR.Is_Holdback, TR.Is_Exclusive, TR.Is_Sublicencing, TR.Rights_Start_Date, TR.Rights_End_Date, TR.Term, TR.Is_Theatrical, TR.Country, 
				TR.Territory, TR.Remarks, TR.Right_Type, TR.Is_Tentative, TR.Milestone_Type_Code, TR.Milestone_No_Of_Unit, TR.Milestone_Unit_Type, 
				TR.Title_Language_Right, TR.Sub_Titling_Language, TR.Dubbing_Titling_Language, TR.Right_Term, TR.Right_Status, 
				CASE WHEN @Right_Type = 'AR' THEN DBO.UFN_Syn_Acq_Mapping(@View_Type, TRPD.Rights_Code, TRPD.Title_Code, TRPD.Platform_Code) ELSE TR.Is_Syn_Acq_Mapp END,
				--TR.Is_Syn_Acq_Mapp,
				TR.Is_ROFR ,ROFR_Date, TR.IsDelete, TT.Is_Closed, TR.Last_Updated_Time
			FROM #TempRightsPagingData TRPD
			INNER JOIN #TempRights TR ON TR.Rights_Code = TRPD.Rights_Code
			INNER JOIN #TempTitle TT ON TT.Title_Code = TRPD.Title_Code AND TT.Episode_From = TRPD.Episode_From AND TT.Episode_To = TRPD.Episode_To
		END
	END
	ELSE 
	BEGIN
		INSERT INTO #TempResultData (
			Deal_Code, Rights_Code, Title_Code, Platform_Code, Title_Name, Episode_From, Episode_To, Platform_Name, 
			Is_Holdback, Is_Exclusive, Is_Sublicencing, Rights_Start_Date, Rights_End_Date, Term, Is_Theatrical, Country, 
			Territory, Remarks, Right_Type, Is_Tentative, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
			Title_Language_Right, Sub_Titling_Language, Dubbing_Titling_Language, Right_Term, Right_Status ,Is_Syn_Acq_Mapp, 
			Is_ROFR, ROFR_Date, IsDelete, Is_Ref_Close_Title, Last_Updated_Time
		)
		SELECT 
			TR.Deal_Code, TR.Rights_Code, TT.Title_Code, TRPD.Platform_Code, TT.Title_Name, TT.Episode_From, TT.Episode_To, P.Platform_Hiearachy, 
			TR.Is_Holdback, TR.Is_Exclusive, TR.Is_Sublicencing, TR.Rights_Start_Date, TR.Rights_End_Date, TR.Term, TR.Is_Theatrical, TR.Country, 
			TR.Territory, TR.Remarks, TR.Right_Type, TR.Is_Tentative, TR.Milestone_Type_Code, TR.Milestone_No_Of_Unit, TR.Milestone_Unit_Type, 
			TR.Title_Language_Right, TR.Sub_Titling_Language, TR.Dubbing_Titling_Language, TR.Right_Term, TR.Right_Status, TR.Is_Syn_Acq_Mapp,
			TR.Is_ROFR ,ROFR_Date, TR.IsDelete, TT.Is_Closed, TR.Last_Updated_Time
		FROM #TempRightsPagingData TRPD
		INNER JOIN #TempRights TR ON TR.Rights_Code = TRPD.Rights_Code
		INNER JOIN #TempTitle TT ON TT.Title_Code = TRPD.Title_Code AND TT.Episode_From = TRPD.Episode_From AND TT.Episode_To = TRPD.Episode_To
		INNER JOIN [Platform] P WITH(NOLOCK) ON P.Platform_Code = TRPD.Platform_Code
	END

	if(@View_Type = 'D')
	BEGIN
		IF(@Right_Type = 'AR')
		BEGIN
			UPDATE TRD SET TRD.Is_Holdback = (
				CASE WHEN (
					SELECT COUNT(*) FROM Acq_Deal_Rights_Holdback ADRH WITH(NOLOCK)
					INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRHP WITH(NOLOCK) ON ADRHP.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
							AND ADRHP.Platform_Code = TRD.Platform_Code
					WHERE ADRH.Acq_Deal_Rights_Code = TRD.Rights_Code
					) = 0 THEN 'N' ELSE 'Y' END
			)FROM #TempResultData TRD
		END
		ELSE IF(@Right_Type = 'SR')
		BEGIN
			UPDATE TRD SET TRD.Is_Holdback = (
				CASE WHEN (
						SELECT COUNT(*) FROM Syn_Deal_Rights_Holdback SDRH WITH(NOLOCK)
						INNER JOIN Syn_Deal_Rights_Holdback_Platform SDRHP WITH(NOLOCK) ON SDRHP.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
							AND SDRHP.Platform_Code = TRD.Platform_Code
						WHERE SDRH.Syn_Deal_Rights_Code = TRD.Rights_Code
					) = 0 THEN 'N' ELSE 'Y' END
			)FROM #TempResultData TRD
		END
		UPDATE #TempResultData SET Is_Holdback = CASE Is_Holdback WHEN 'Y' Then 'Yes' WHEN 'N' THEN 'No' ELSE '' END
	END

	PRINT '  Dynamic Query Execution started at ' + CAST(GETDATE() AS VARCHAR)
	DECLARE @Query VARCHAR(MAX)
	SET @Query = 'Select Deal_Code, Rights_Code, Title_Code, 
	ISNULL(Platform_Code, 0) AS Platform_Code, Title_Name, Episode_From, Episode_To, 
	ISNULL(Platform_Name, '''') AS Platform_Name, 
	Is_Holdback, Is_Exclusive, 
	Is_Sublicencing, Rights_Start_Date, Rights_End_Date, Term, Is_Theatrical, Country, Territory, 
	(CASE WHEN ISNULL(Remarks, '''') = '''' THEN ''No'' ELSE Remarks END) Remarks, 
	Right_Type, Is_Tentative, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Title_Language_Right, 
	(CASE WHEN ISNULL(Sub_Titling_Language, '''') = '''' THEN ''No''  ELSE Sub_Titling_Language END) Sub_Titling_Language, 
	(CASE WHEN ISNULL(Dubbing_Titling_Language, '''') = '''' THEN ''No''  ELSE Dubbing_Titling_Language END) Dubbing_Titling_Language,
	Right_Term, Right_Status ,Is_Syn_Acq_Mapp ,Is_ROFR ,ROFR_Date ,IsDelete ,Is_Ref_Close_Title
	From #TempResultData ORDER BY '

	IF(@View_Type = 'G')
		SET @Query = @Query + 'Last_Updated_Time'
	ELSE
		SET @Query = @Query + 'Title_Name, Platform_Name'

	EXEC(@Query)

	PRINT '  Process Ended at' + CAST(GETDATE() AS VARCHAR)

	IF OBJECT_ID('tempdb..#TempDealMovie') IS NOT NULL DROP TABLE #TempDealMovie
	IF OBJECT_ID('tempdb..#TempPlatformCodes') IS NOT NULL DROP TABLE #TempPlatformCodes
	IF OBJECT_ID('tempdb..#TempResultData') IS NOT NULL DROP TABLE #TempResultData
	IF OBJECT_ID('tempdb..#TempRightCodes') IS NOT NULL DROP TABLE #TempRightCodes
	IF OBJECT_ID('tempdb..#TempRightCodesDetails') IS NOT NULL DROP TABLE #TempRightCodesDetails
	IF OBJECT_ID('tempdb..#TempRightCodesGroup') IS NOT NULL DROP TABLE #TempRightCodesGroup
	IF OBJECT_ID('tempdb..#TempRightCodesSummary') IS NOT NULL DROP TABLE #TempRightCodesSummary
	IF OBJECT_ID('tempdb..#TempRights') IS NOT NULL DROP TABLE #TempRights
	IF OBJECT_ID('tempdb..#TempRightsPagingData') IS NOT NULL DROP TABLE #TempRightsPagingData
	IF OBJECT_ID('tempdb..#TempTitle') IS NOT NULL DROP TABLE #TempTitle
END
GO
PRINT N'Altering [dbo].[USP_Validate_Rights_Duplication_UDT_Acq]...';


GO
ALTER PROCEDURE [dbo].[USP_Validate_Rights_Duplication_UDT_Acq]
(
	@Deal_Rights Deal_Rights READONLY,
	@Deal_Rights_Title Deal_Rights_Title  READONLY,
	@Deal_Rights_Platform Deal_Rights_Platform READONLY,
	@Deal_Rights_Territory Deal_Rights_Territory READONLY,
	@Deal_Rights_Subtitling Deal_Rights_Subtitling READONLY,
	@Deal_Rights_Dubbing Deal_Rights_Dubbing READONLY,
	@CallFrom CHAR(2)='AR',	
	@Debug CHAR(1)='D',
	@Deal_Rights_Process_Code INT
)
As
Begin

		SET FMTONLY OFF
		SET NOCOUNT ON
		BEGIN /*Delete temp table if exists */
			IF OBJECT_ID('tempdb..#Acq_Deal_Rights') IS NOT NULL
			BEGIN
				DROP TABLE #Acq_Deal_Rights
			END
			IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Title') IS NOT NULL
			BEGIN
				DROP TABLE #Acq_Deal_Rights_Title
			END
			IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Territory') IS NOT NULL
			BEGIN
				DROP TABLE #Acq_Deal_Rights_Territory
			END
			IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Platform') IS NOT NULL
			BEGIN
				DROP TABLE #Acq_Deal_Rights_Platform
			END
			IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Subtitling') IS NOT NULL
			BEGIN
				DROP TABLE #Acq_Deal_Rights_Subtitling
			END
			IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Dubbing') IS NOT NULL
			BEGIN
				DROP TABLE #Acq_Deal_Rights_Dubbing
			END
			IF OBJECT_ID('tempdb..#TempDupComb') IS NOT NULL
			BEGIN
				DROP TABLE #TempDupComb
			END
				
			IF OBJECT_ID('tempdb..#Dup_Records_Language1') IS NOT NULL
			BEGIN
				DROP TABLE #Dup_Records_Language1	
			END			
			IF OBJECT_ID('tempdb..#Dup_Records_Language') IS NOT NULL
			BEGIN
				DROP TABLE #Dup_Records_Language	
			END			
	
			IF OBJECT_ID('tempdb..#Deal_Rights_Territory') IS NOT NULL
			BEGIN
				DROP TABLE #Deal_Rights_Territory
			END
	
			IF OBJECT_ID('tempdb..#Acq_Rights_Code_Lang') IS NOT NULL
			BEGIN
				DROP TABLE #Acq_Rights_Code_Lang
			END
		END
		Create table #Deal_Rights_Territory
		(
			Deal_Rights_Code int,
			Territory_Type char(2),
			Territory_Code int,
			Country_Code int
		)
		Create table #Deal_Rights_Subtitling
		(
				Deal_Rights_Code int 
				,Language_Type varchar(100)
				,Language_Group_Code int 
				,Subtitling_Code int
		)
			
		Create table #Deal_Rights_Dubbing
		(
				Deal_Rights_Code int 
				,Language_Type varchar(100)
				,Language_Group_Code int 
				,Dubbing_Code int
		)
		create table #Acq_Rights_Code_Lang
		(
			Deal_Rights_Code int
		)
		
		DECLARE @ValidatePUSHBACK_YN CHAR(1),@SKIP_PUSHBACK CHAR(1)='N',@Is_Country_Domestic char(1),@Is_Platform_Thetrical char(1)
	
		set @Is_Country_Domestic = 'N'
		set @Is_Platform_Thetrical= 'N'
	
		SELECT @ValidatePUSHBACK_YN=  Parameter_Value FROM System_Parameter_New WHERE Parameter_NAME='Pushback_Validation_YN'

    

		IF(@ValidatePUSHBACK_YN='N') 
		BEGIN
			IF(@CallFrom='AP')	RETURN
			ELSE SET  @SKIP_PUSHBACK='Y'
		END
	
		IF(EXISTS (select * from @Deal_Rights_Territory where Territory_Type = 'G' AND ISNULL(Country_Code,0) = 0 ))
		BEGIN
			insert into #Deal_Rights_Territory (Deal_Rights_Code,Territory_Type,Territory_Code,Country_Code)
			select td.Deal_Rights_Code, 'I' Territory_Type, 0 Territory_Code, TGD.Country_Code from @Deal_Rights_Territory TD
			inner join Territory_Details TGD on TGD.Territory_Code = TD.Territory_Code
			inner join Country C on C.Country_Code = TGD.Country_Code
		END
		ELSE
		BEGIN
			insert into #Deal_Rights_Territory (Deal_Rights_Code,Territory_Type,Territory_Code,Country_Code)
			select td.Deal_Rights_Code,td.Territory_Type,td.Territory_Code,td.Country_Code From @Deal_Rights_Territory TD
		END
	
		IF (EXISTS (select  Country_Code from Country where Country_Code in  (select Country_Code from #Deal_Rights_Territory)
							AND (Is_Domestic_Territory='Y' )
		 ))
		BEGIN
			set @Is_Country_Domestic = 'Y'
		END
		IF (EXISTS (select Platform_Code from Platform where Applicable_For_Demestic_Territory = 'Y'))
		BEGIN
			set @Is_Platform_Thetrical = 'Y'
		END
	
			
		IF(EXISTS (select * from @Deal_Rights_Subtitling where Language_Type = 'G' AND ISNULL(Subtitling_Code,0) = 0 ))
		BEGIN
			insert into #Deal_Rights_Subtitling (Deal_Rights_Code,Language_Type,Language_Group_Code,Subtitling_Code)
			select Distinct s.Deal_Rights_Code,'L' Language_Type,0 Language_Group_Code, lgd.Language_Code from @Deal_Rights_Subtitling s
			inner join Language_Group_Details LGD on LGD.Language_Group_Code = s.Language_Group_Code
			--inner join Country C on C.Country_Code = TGD.Country_Code
		END
		ELSE
		BEGIN
			insert into #Deal_Rights_Subtitling (Deal_Rights_Code,Language_Type,Language_Group_Code,Subtitling_Code)
			select Distinct s.Deal_Rights_Code, Language_Type, Language_Group_Code, s.Subtitling_Code  from @Deal_Rights_Subtitling s
		END
		
		IF(EXISTS (select * from @Deal_Rights_Dubbing where Language_Type = 'G' AND ISNULL(Dubbing_Code,0) = 0 ))
		BEGIN
			insert into #Deal_Rights_Dubbing (Deal_Rights_Code,Language_Type,Language_Group_Code,Dubbing_Code)
			select Distinct s.Deal_Rights_Code,'L' Language_Type,0 Language_Group_Code, lgd.Language_Code from @Deal_Rights_Dubbing s
			inner join Language_Group_Details LGD on LGD.Language_Group_Code = s.Language_Group_Code
			--inner join Country C on C.Country_Code = TGD.Country_Code
		END
		ELSE
		BEGIN
			insert into #Deal_Rights_Dubbing (Deal_Rights_Code,Language_Type,Language_Group_Code,Dubbing_Code)
			select Distinct s.Deal_Rights_Code, Language_Type, Language_Group_Code, s.Dubbing_Code  from @Deal_Rights_Dubbing s
		END
				
		BEGIN /*Create temp table*/
			
			
		Create table #Acq_Deal_Rights_Subtitling
		(
			Acq_Deal_Rights_Code int 
			,Language_Type varchar(100)
			,Language_Group_Code int 
			,Language_Code int
		)
			
		Create table #Acq_Deal_Rights_Dubbing
		(
			Acq_Deal_Rights_Code int 
			,Language_Type varchar(100)
			,Language_Group_Code int 
			,Language_Code int
		)
		END
	
		BEGIN /*Declare variables*/
		DECLARE @Right_Start_Date DATETIME,
				@Right_End_Date DATETIME,
				@Right_Type CHAR(1),
				@Is_Exclusive CHAR(1),
				@Is_Title_Language_Right CHAR(1),
				@Is_Sub_License CHAR(1),
				@Is_Tentative CHAR(1),
				@Sub_License_Code INT,
				@Deal_Rights_Code INT,
				@Deal_Pushback_Code INT,
				@Deal_Code INT,
				@Title_Code INT,
				@Platform_Code INT,
				@Check_For CHAR(1),
				@Is_Theatrical_Right CHAR(1)
		END
       
		SELECT 
		@Deal_Code=dr.Deal_Code,
		@Deal_Rights_Code=   CASE WHEN @CallFrom = 'AR' THEN dr.Deal_Rights_Code ELSE 0 END,
		@Deal_Pushback_Code= CASE WHEN @CallFrom = 'AP' THEN dr.Deal_Rights_Code ELSE 0 END,
		@Right_Start_Date=dr.Right_Start_Date,
		@Right_End_Date=dr.Right_End_Date,
		--@Right_End_Date=ISNULL(dr.Right_End_Date,DATEADD(YEAR,100,dr.Right_Start_Date)),
		@Right_Type=dr.Right_Type,
		@Is_Exclusive=dr.Is_Exclusive,
		@Is_Tentative=dr.Is_Tentative,
		@Is_Sub_License=dr.Is_Sub_License,
		@Sub_License_Code=dr.Sub_License_Code,
		@Is_Title_Language_Right=dr.Is_Title_Language_Right,	
		@Title_Code=ISNULL(dr.Title_Code,0),
		@Platform_Code=ISNULL(dr.Platform_Code,0),
		@Check_For = dr.Check_For,
		@Is_Theatrical_Right=ISNULL(dr.Is_Theatrical_Right,'N')
		FROM @Deal_Rights dr
	
		DECLARE @Deal_Type_Code INT =0
		SELECT TOP 1 @Deal_Type_Code = ISNULL(Parameter_Value,5) FROM System_Parameter_New WHERE Parameter_Name like 'Deal_Type_Music'
		BEGIN  /* insert in temporary tables*/

			Select    ADR.Acq_Deal_Code
			, ADR.Acq_Deal_Rights_Code
			, ADR.Right_Type
			, ADR.Actual_Right_Start_Date
			, ADR.Actual_Right_End_Date
			, ADR.Is_Sub_License, ADR.Is_Title_Language_Right
			,(Select Count(*) From Acq_Deal_Rights_Subtitling a Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) Sub_Cnt
			,(Select Count(*) From Acq_Deal_Rights_Dubbing a Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) Dub_Cnt
			, 'Combination Conflict with other Rights' ErrorMSG
				InTo #Acq_Deal_Rights
			From Acq_Deal_Rights ADR
			Where 
			ADR.Acq_Deal_Code is not null	
			And ADR.Acq_Deal_Code In (
				Select AD.Acq_Deal_Code From Acq_Deal AD Where 
				AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
				(
					AD.Is_Master_Deal = 'Y'
					OR (ISNULL(AD.Deal_Type_Code,1) = @Deal_Type_Code AND Is_Master_Deal = 'N')
				)
			)
			AND ((ADR.Acq_Deal_Code=@Deal_Code AND @CallFrom='AP') OR @CallFrom='AR')
			--AND ((ISNULL(@Check_For,'') = 'M' AND ADR.Acq_Deal_Code <> @Deal_Code) OR ISNULL(@Check_For,'') = '')
			AND(  
				(@Is_Title_Language_Right = 'Y' AND (ADR.Is_Title_Language_Right = 'Y' OR ADR.Is_Title_Language_Right = 'N'))
				OR @Is_Title_Language_Right = 'N'
			)
			AND
			(
				/******************Case 1***********************************/
				--In Case of Right 1 is YearBased with no tentative and Current Right is Unlimited
				--In Case of Right 1 is YearBased with no tentative and Current Right is MileStone
				--In Case of Right 1 is YearBased with no tentative and Current Right is YearBase With no tentative
				/******************Case 2***********************************/
				--In Case of Right 1 is MileStone and Current Right is Yearbased with no tentative
				--In Case of Right 1 is MileStone and Current Right is Unlimited
				--In Case of Right 1 is MileStone and Current Right is MileStone
				/******************Case 3***********************************/
				--In Case of Right 1 is Unlimited and Current Right is Yearbased and no tentative 
				--In Case of Right 1 is Unlimited and Current Right is MileStone 
				(
					(
						((ADR.Right_Type = 'Y'  AND ADR.Is_Tentative = 'N') AND (@Right_Type = 'U' OR @Right_Type = 'M' OR (@Right_Type = 'Y' AND @Is_Tentative = 'N'))) -- Case 1
						OR
						((ADR.Right_Type = 'M'  AND ((@Right_Type = 'Y' AND  @Is_Tentative = 'N') OR @Right_Type = 'U' OR @Right_Type = 'M'))) -- Case 2
						OR 
						((ADR.Right_Type = 'U' AND ((@Right_Type = 'Y' AND @Is_Tentative = 'N') OR @Right_Type = 'M'))) -- Case 3
					)
					/*
					(
						--Alternative of Case 1,Case 2 and Case 3
						((ADR.Right_Type = 'Y'  AND ADR.Is_Tentative = 'N') OR ADR.Right_Type = 'M' OR ADR.Right_Type = 'U')
						OR
						((@Right_Type = 'Y' AND @Is_Tentative = 'N') OR  @Right_Type = 'U' OR  OR  @Right_Type = 'M')					
					)
					*/				
					AND
					(		
						Convert(DateTime, @Right_Start_Date, 103) between Convert(DateTime, ADR.Actual_Right_Start_Date, 103) and Convert(DateTime, ISNULL(ADR.Actual_Right_End_Date,'31DEC9999'), 103)
						OR
						Convert(DateTime, ISNULL(@Right_End_Date,'31DEC9999'), 103) between Convert(DateTime, ADR.Actual_Right_Start_Date, 103) and Convert(DateTime, ISNULL(ADR.Actual_Right_End_Date,'31DEC9999'), 103)
						OR
						Convert(DateTime, ADR.Actual_Right_Start_Date, 103) between Convert(DateTime, @Right_Start_Date, 103) and Convert(DateTime, ISNULL(@Right_End_Date,'31DEC9999'), 103)
						OR
						Convert(DateTime,ISNULL(ADR.Actual_Right_End_Date,'31DEC9999'), 103) between Convert(DateTime, @Right_Start_Date, 103) and Convert(DateTime, ISNULL(@Right_End_Date,'31DEC9999'), 103)							
					)
					OR
					(				
						/******************Case 4***********************************/
						--In Case of Right 1 is YearBased with tentative and Current Right is Unlimited
						--In Case of Right 1 is YearBased with tentative and Current Right is MileStone
						--In Case of Right 1 is YearBased with tentative and Current Right is YearBased with No tentative
						--In Case of Right 1 is YearBased with tentative and Current Right is YearBased with tentative
						(
							ADR.Right_Type = 'Y' AND  ADR.Is_Tentative = 'Y' 
							AND 
							(
								@Right_Type = 'U' 
								OR 
								(
									(@Right_Type = 'M' OR (@Right_Type= 'Y' AND @Is_Tentative = 'N'))
									AND  
									Convert(DateTime, @Right_End_Date, 103) >= Convert(DateTime,ADR.Actual_Right_Start_Date, 103)
								)
								OR
								(@Right_Type= 'Y' AND @Is_Tentative = 'Y')
							)
						) -- case 4					
						OR
						/******************Case 5***********************************/
						--In Case of Right 1 is MileStone and Current Right is Yearbased with tentative					
						--In case of Right 1 is Yearbased with no tentative and Current Right is Yearbased with tentative
						((ADR.Right_Type = 'M' OR (ADR.Right_Type = 'Y' AND ADR.Is_Tentative = 'N'))
						AND
						(
						 (@Right_Type='Y' AND @Is_Tentative = 'Y')
						 OR
						 (@Right_Type='U')
						)
						AND Convert(DateTime,ADR.Actual_Right_End_Date, 103) >= Convert(DateTime, @Right_Start_Date, 103)) --Case 5
						/******************Case 6***********************************/
						--In Case of Right 1 is Unlimited and Current Right is unlimited 
						--In Case of Right 1 is Unlimited and Current Right is Yearbased and tentative 					
						OR
						(ADR.Right_Type = 'U' AND  ((@Right_Type = 'U') OR (@Right_Type = 'Y' AND @Is_Tentative = 'Y')))  --Case 6
						--OR
						--(ADR.Right_Type = 'U' AND @Right_Type = 'M' AND Convert(DateTime,ADR.Actual_Right_Start_Date, 103) <= Convert(DateTime, @Right_End_Date, 103)) --Case 6)																				
					)
				)
			)
			--AND ADR.Acq_Deal_Rights_Code not in (@Deal_Rights_Code)
			AND
			(
				 (ISNULL(@Title_Code,0) = 0 AND ISNULL(@Platform_Code,0) = 0) AND ADR.Acq_Deal_Rights_Code not in (@Deal_Rights_Code) 
				 OR
				 (ISNULL(@Title_Code,0) <> 0)
				--OR
				--( (ISNULL(@Title_Code,0) <> 0 AND ISNULL(@Platform_Code,0) <> 0) )
				--OR
				--( (ISNULL(@Title_Code,0) <> 0 AND ISNULL(@Platform_Code,0) = 0) )
			)
			select ADR.Acq_Deal_Rights_Code
					,ADRT.Title_Code
					,ADRT.Episode_From
					,ADRT.Episode_To 
			into #Acq_Deal_Rights_Title 
			from #Acq_Deal_Rights ADR 
			inner join Acq_Deal_Rights_Title ADRT on ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			AND ADRT.Acq_Deal_Rights_Code NOT IN
			(
				SELECT A.Acq_Deal_Rights_Code FROM 
				(	SELECT @Deal_Rights_Code Acq_Deal_Rights_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
				) AS A 
				WHERE (A.Title_Code=ADRT.Title_Code AND A.Title_Code > 1 AND @Platform_Code < 1) 
			)
			where 1=1 AND Title_Code in (
				SELECT Title_Code FROM @Deal_Rights_Title inTitle
				Where 
					(inTitle.Episode_From Between ADRT.Episode_From And ADRT.Episode_To) 
				Or	(inTitle.Episode_To Between ADRT.Episode_From And ADRT.Episode_To) 
				Or	(ADRT.Episode_From Between inTitle.Episode_From And inTitle.Episode_To) 
				Or  (ADRT.Episode_To Between inTitle.Episode_From And inTitle.Episode_To)
			)
		

		
			delete from #Acq_Deal_Rights where Acq_Deal_Rights_Code not in (
				select Acq_Deal_Rights_Code from #Acq_Deal_Rights_Title
			)
		


			select DISTINCT ADR.Acq_Deal_Rights_Code 
					,ADRP.Platform_Code 
					into #Acq_Deal_Rights_Platform 
			from #Acq_Deal_Rights_Title ADR 
			inner join Acq_Deal_Rights_Platform ADRP on ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code 
			AND ADRP.Acq_Deal_Rights_Code NOT IN
			(
				SELECT A.Acq_Deal_Rights_Code FROM 
				(	SELECT @Deal_Rights_Code Acq_Deal_Rights_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
				) AS A 
				WHERE ((A.Platform_Code=ADRP.Platform_Code OR A.Platform_Code < 1) AND (A.Title_Code=ADR.Title_Code Or A.Title_Code < 1)) 
			)
			where 1=1 AND Platform_Code in (SELECT Platform_Code FROM @Deal_Rights_Platform)
			
			DECLARE @allowSatelliteRightsOverlapping CHAR(1) = ''
			SELECT TOP 1 @allowSatelliteRightsOverlapping = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AllowSatelliteRightsOverlapping'

			IF(@allowSatelliteRightsOverlapping = 'Y')
			BEGIN
				DELETE FROM #Acq_Deal_Rights_Platform WHERE Platform_Code IN (SELECT Platform_Code FROM [Platform] WHERE ISNULL(Is_No_Of_Run, '') = 'Y')
			END
		
			delete from #Acq_Deal_Rights_Title where Acq_Deal_Rights_Code not in (
				select Acq_Deal_Rights_Code from #Acq_Deal_Rights_Platform
			)

			delete from #Acq_Deal_Rights where Acq_Deal_Rights_Code not in (
				select Acq_Deal_Rights_Code from #Acq_Deal_Rights_Title
			)

			select a.Acq_Deal_Rights_Code 
				   ,a.Territory_Type
				   ,a.Territory_Code
				   ,a.Country_Code 
			into #Acq_Deal_Rights_Territory 
			From (
				Select ADR.Acq_Deal_Rights_Code 
					   ,ADRT.Territory_Type
					   ,ADRT.Territory_Code
					   , Case When ADRT.Territory_Type = 'I' Then ADRT.Country_Code Else TD.Country_Code End Country_Code
				from #Acq_Deal_Rights ADR 
				Inner Join Acq_Deal_Rights_Territory ADRT on ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				Left Join Territory_Details TD On ADRT.Territory_Code = TD.Territory_Code
			) As a
			where 1=1 AND
			( 
				(  
					@Is_Theatrical_Right = 'Y'  
					AND 
					(
						a.Country_Code IN
						(
							select Country_Code from Country where (Is_Theatrical_Territory = 'Y' OR Is_Domestic_Territory ='Y')
								AND Country_code in (select Country_Code from #Deal_Rights_Territory)
						)
						OR a.Country_Code in (select Country_Code from Country where Is_Domestic_Territory ='Y')
					)
				)
				OR
				(		
					@Is_Theatrical_Right = 'N' AND @Is_Country_Domestic = 'Y' AND @Is_Platform_Thetrical = 'Y'
					AND ISNULL(a.Country_Code,0)>0
					AND ( 
							a.Country_Code in 
							(
								select Country_Code from Country where (Is_Theatrical_Territory = 'Y' OR Is_Domestic_Territory = 'Y')
							)
						)
								
				)
				OR (ISNULL(a.Country_Code,0)>0 AND a.Country_Code in (SELECT tr.Country_Code FROM #Deal_Rights_Territory tr) AND @Is_Theatrical_Right = 'N')
			)	

			delete from #Acq_Deal_Rights_Platform where Acq_Deal_Rights_Code not in (
				select Acq_Deal_Rights_Code from #Acq_Deal_Rights_Territory
			)
			delete from #Acq_Deal_Rights_Title where Acq_Deal_Rights_Code not in (
				select Acq_Deal_Rights_Code from #Acq_Deal_Rights_Platform
			)

			delete from #Acq_Deal_Rights where Acq_Deal_Rights_Code not in (
				select Acq_Deal_Rights_Code from #Acq_Deal_Rights_Title
			)
		
		
		
			IF((SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM #Deal_Rights_Subtitling)>0)
			BEGIN

				insert into #Acq_Deal_Rights_Subtitling(Acq_Deal_Rights_Code,Language_Type ,Language_Group_Code,Language_Code)
				Select Acq_Deal_Rights_Code, a.Language_Type, a.Language_Group_Code, Language_Code From (
					select ADR.Acq_Deal_Rights_Code,ADRS.Language_Type,ADRS.Language_Group_Code,
						   Case When ADRS.Language_Type = 'L' Then ADRS.Language_Code  Else LGD.Language_Code End Language_Code
					From #Acq_Deal_Rights ADR 
					inner join Acq_Deal_Rights_Subtitling ADRS on ADRS.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
					Left Join Language_Group_Details LGD On ADRS.Language_Group_Code = LGD.Language_Group_Code
				) as a
				Inner Join #Deal_Rights_Subtitling DRS ON DRS.Subtitling_Code=a.Language_Code

			END


			IF((SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM #Deal_Rights_Dubbing)>0)
			BEGIN
				insert into #Acq_Deal_Rights_Dubbing(Acq_Deal_Rights_Code,Language_Type ,Language_Group_Code,Language_Code)
				Select Acq_Deal_Rights_Code,a.Language_Type, a.Language_Group_Code, Language_Code 
				From (
					select ADR.Acq_Deal_Rights_Code,ADRD.Language_Type,ADRD.Language_Group_Code, 
						   Case When ADRD.Language_Type = 'L' Then ADRD.Language_Code Else LGD.Language_Code End Language_Code
					From #Acq_Deal_Rights ADR
					inner join Acq_Deal_Rights_Dubbing ADRD on ADRD.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
					Left Join Language_Group_Details LGD On ADRD.Language_Group_Code = LGD.Language_Group_Code
				) as a
				INNER JOIN #Deal_Rights_Dubbing DRD ON DRD.Dubbing_Code=a.Language_Code

			END

		
	

			IF(
				(SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM #Deal_Rights_Subtitling) = 0 AND 
				(SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM #Deal_Rights_Dubbing) = 0
			)
			BEGIN
				DELETE  FROM #Acq_Deal_Rights WHERE Is_Title_Language_Right = 'N'
			END
			ELSE 
			BEGIN
				INSERT INTO #Acq_Rights_Code_Lang
				SELECT Distinct R.Acq_Deal_Rights_Code
				FROM #Acq_Deal_Rights R
				WHERE (R.Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y')
				
				INSERT INTO #Acq_Rights_Code_Lang
				SELECT Distinct Acq_Deal_Rights_Code
				FROM #Acq_Deal_Rights_Subtitling where ( ISnull(Language_Code,0) <> 0 OR Isnull(Language_Group_Code,0) <> 0 )
				
				INSERT INTO #Acq_Rights_Code_Lang	
				SELECT Distinct Acq_Deal_Rights_Code
				FROM #Acq_Deal_Rights_Dubbing where ( ISnull(Language_Code,0) <> 0 OR Isnull(Language_Group_Code,0) <> 0 )

				DELETE FROM #Acq_Deal_Rights
				WHERE Acq_Deal_Rights_Code NOT IN(SELECT Deal_Rights_Code FROM #Acq_Rights_Code_Lang)
			
			END
		
			delete from #Acq_Deal_Rights_Title where Acq_Deal_Rights_Code not in (
				select Acq_Deal_Rights_Code from #Acq_Deal_Rights
			)
			delete from #Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code not in (
				select Acq_Deal_Rights_Code from #Acq_Deal_Rights
			)
			delete from #Acq_Deal_Rights_Platform where Acq_Deal_Rights_Code not in (
				select Acq_Deal_Rights_Code from #Acq_Deal_Rights
			)
		
			/*Newly added on 30march2015 For Detail condition on RightsList page*/
			-- IF(ISNULL(@Title_Code,0) <> 0 AND ISNULL(@Platform_Code,0) <> 0 AND @Deal_Rights_Code <> 0)
			--BEGIN
			--	delete ADR from #Acq_Deal_Rights ADR WHERE ADR.Acq_Deal_Rights_Code IN
			--	(
			--		select  ADRP.Acq_Deal_Rights_Code from #Acq_Deal_Rights_Title ADRT
			--		INNER JOIN #Acq_Deal_Rights_Platform ADRP ON ADRT.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			--		where Title_Code = @Title_Code AND ADRP.Acq_Deal_Rights_Code = @Deal_Rights_Code AND Platform_Code = @Platform_Code
			--	)
			-- END
			--IF(ISNULL(@Title_Code,0) = 0 AND ISNULL(@Platform_Code,0) = 0 AND @Deal_Rights_Code <> 0)
			--BEGIN
			--	delete from #Acq_Deal_Rights where Acq_Deal_Rights_Code in (@Deal_Rights_Code)
			--END
			--ELSE IF(ISNULL(@Title_Code,0) <> 0 AND ISNULL(@Platform_Code,0) = 0 AND @Deal_Rights_Code <> 0)
			--BEGIN
			--	delete from #Acq_Deal_Rights_Title where Title_Code  = @Title_Code 
			--	AND Acq_Deal_Rights_Code in (
			--			select  acq_deal_rights_code from #Acq_Deal_Rights_Title
			--			where Title_Code = @Title_Code AND Acq_Deal_Rights_Code = @Deal_Rights_Code
			--	)
			--END
			--ELSE IF(ISNULL(@Title_Code,0) <> 0 AND ISNULL(@Platform_Code,0) <> 0 AND @Deal_Rights_Code <> 0)
			--BEGIN
			--	delete from #Acq_Deal_Rights_Platform where Platform_Code = @Platform_Code
			--	AND Acq_Deal_Rights_Code in (
			--			select  acq_deal_rights_code from #Acq_Deal_Rights_Title
			--			where Title_Code = @Title_Code AND Acq_Deal_Rights_Code = @Deal_Rights_Code
			--	)
			
			--	delete from #Acq_Deal_Rights_Title where Title_Code  = @Title_Code 
			--	AND Acq_Deal_Rights_Code in (
			--			select  acq_deal_rights_code from #Acq_Deal_Rights_Title
			--			where Title_Code = @Title_Code AND Acq_Deal_Rights_Code = @Deal_Rights_Code
			--	)
			
			--	--delete from #Acq_Deal_Rights where Acq_Deal_Rights_Code NOT In 
			--	--(
			--	--	SELECT A.Acq_Deal_Rights_Code FROM 
			--	--	(	SELECT @Deal_Rights_Code Acq_Deal_Rights_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
			--	--	) AS A
			--	--	WHERE (A.Platform_Code=Platform_Code OR A.Platform_Code < 1)AND (A.Title_Code=Title_Code Or A.Title_Code < 1) 
			--	--)
			--END
		
		
		
		
			--delete from #Acq_Deal_Rights_Platform where Platform_Code  In 
			--(
			--	Isnull(@Platform_Code,0)
			--)
			--AND EXISTS(
			--	SELECT A.Acq_Deal_Rights_Code FROM 
			--		(	SELECT @Deal_Rights_Code Acq_Deal_Rights_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
			--		) AS A 
			--		WHERE (A.Platform_Code=Platform_Code OR A.Platform_Code < 1)AND (A.Title_Code=Title_Code Or A.Title_Code < 1) 
			--)
			/*End of add on 30 march2015*/
		
		

		END
	

		--select ADR.*,ADRT.Title_Code,ADRT.Episode_From,ADRT.Episode_To 
		--into #ACQ_RIGHTS_NEW
		--from  #Acq_Deal_Rights ADR 
		--inner join #Acq_Deal_Rights_Title ADRT on ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code

		SELECT ADR.*,ADRT.Title_Code,ADRT.Episode_From,ADRT.Episode_To,ADRP.Platform_Code
		INTO #ACQ_RIGHTS_NEW
		FROM  #Acq_Deal_Rights ADR 
		INNER JOIN #Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		INNER JOIN #Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
		AND ADR.Acq_Deal_Rights_Code NOT IN
		(
			SELECT A.Acq_Deal_Rights_Code FROM 
				(	SELECT @Deal_Rights_Code Acq_Deal_Rights_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
				) AS A 
				WHERE ((A.Platform_Code=ADRP.Platform_Code OR A.Platform_Code < 1) AND (A.Title_Code=ADRT.Title_Code Or A.Title_Code < 1)) 
		)

		IF(@Debug = 'D')
		BEGIN
		Select 'sagar', * FROM #Acq_Deal_Rights
		Select 'sagar', * FROM #Acq_Deal_Rights
		Select 'sagar', * FROM #Acq_Deal_Rights_Title
		Select 'sagar', * FROM #Acq_Deal_Rights_Platform
		Select 'sagar', * FROM #ACQ_RIGHTS_NEW
		END

		Select Title_Name, abcd.Platform_Hiearachy Platform_Name, Actual_Right_Start_Date as Right_Start_Date, Actual_Right_End_Date as Right_End_Date,
			CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
			CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
			CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
			Country_Name,
			CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
			CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
			Agreement_No, ISNULL(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To
		From(
			Select *,
			STUFF
			(
				(
				Select ', ' + C.Country_Name From Country C 
				Where c.Country_Code In(
					Select t.Country_Code From #Acq_Deal_Rights_Territory t 
					Where t.Acq_Deal_Rights_Code In (
						Select adrn.Acq_Deal_Rights_Code From #ACQ_RIGHTS_NEW adrn Where 
							a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
							AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
							And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
							and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
							and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
					)
				) --AND C.Country_Code in (select distinct Country_Code from #Deal_Rights_Territory)
				FOR XML PATH('')), 1, 1, ''
			) as Country_Name,
			STUFF
			(
				(
				Select ',' + CAST(P.Platform_Code as Varchar) 
				From Platform p Where p.Platform_Code In
				(
					Select adrn.Platform_Code 
					FROM #ACQ_RIGHTS_NEW adrn 
					WHERE a.Title_Code = adrn.Title_Code
					AND adrn.Platform_Code = p.Platform_Code
					AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
					And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
					and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
					and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
					--Select t.Platform_Code From #Acq_Deal_Rights_Platform t Where t.Acq_Deal_Rights_Code In 
					--(
					--		Select adrn.Acq_Deal_Rights_Code From #ACQ_RIGHTS_NEW adrn Where 
					--		a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
					--		AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
					--		And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
					--		and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
					--		and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
					--)
				)
				FOR XML PATH('')), 1, 1, ''
			) as Platform_Code,
			STUFF
			(
				(
				Select ', ' + l.Language_Name From Language l 
				Where l.Language_Code In(
					Select t.Language_Code From #Acq_Deal_Rights_Subtitling t 
					Where t.Acq_Deal_Rights_Code In (
						Select adrn.Acq_Deal_Rights_Code From #ACQ_RIGHTS_NEW adrn 
						Where a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
							AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
							And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
							and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
							and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
					)
				)
				FOR XML PATH('')), 1, 1, ''
			) as Subtitling_Language,
			STUFF
			(
				(
				Select ', ' + l.Language_Name From Language l 
				Where l.Language_Code In(
					Select t.Language_Code From #Acq_Deal_Rights_Dubbing t Where t.Acq_Deal_Rights_Code In (
						Select adrn.Acq_Deal_Rights_Code From #ACQ_RIGHTS_NEW adrn 
						Where a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
							AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
							And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
							and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
							and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
					)
				)
				FOR XML PATH('')), 1, 1, ''
			) as Dubbing_Language,
			STUFF
			(
				(
				Select ', ' + t.Agreement_No From Acq_Deal t
				Where t.Deal_Workflow_Status NOT IN ('AR', 'WA') AND t.Acq_Deal_Code In (
					Select adrn.Acq_Deal_Code From #ACQ_RIGHTS_NEW adrn
					Where a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date
						AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
						And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
						and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
						and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
				)
				FOR XML PATH('')), 1, 1, ''
			) as Agreement_No
			From (
				Select T.Title_Code,
					DBO.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name,
					ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date,
					Is_Sub_License, Is_Title_Language_Right, ADR.ErrorMSG, Right_Type, Episode_From, Episode_To
				from #ACQ_RIGHTS_NEW ADR
				--inner join #Acq_Deal_Rights_Title ADRT on ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
				INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
				Group By T.Title_Code, T.Title_Name, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Sub_License,
					Is_Title_Language_Right,ADR.ErrorMSG, Right_Type,Episode_From,Episode_To,Deal_Type_Code
			) as a
		) as MainOutput
		Cross Apply
		(
			Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
		) as abcd


	IF OBJECT_ID('tempdb..#Acq_Deal_Rights') IS NOT NULL DROP TABLE #Acq_Deal_Rights
	IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Dubbing') IS NOT NULL DROP TABLE #Acq_Deal_Rights_Dubbing
	IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Platform') IS NOT NULL DROP TABLE #Acq_Deal_Rights_Platform
	IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Subtitling') IS NOT NULL DROP TABLE #Acq_Deal_Rights_Subtitling
	IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Territory') IS NOT NULL DROP TABLE #Acq_Deal_Rights_Territory
	IF OBJECT_ID('tempdb..#Acq_Deal_Rights_Title') IS NOT NULL DROP TABLE #Acq_Deal_Rights_Title
	IF OBJECT_ID('tempdb..#Acq_Rights_Code_Lang') IS NOT NULL DROP TABLE #Acq_Rights_Code_Lang
	IF OBJECT_ID('tempdb..#ACQ_RIGHTS_NEW') IS NOT NULL DROP TABLE #ACQ_RIGHTS_NEW
	IF OBJECT_ID('tempdb..#Deal_Rights_Dubbing') IS NOT NULL DROP TABLE #Deal_Rights_Dubbing
	IF OBJECT_ID('tempdb..#Deal_Rights_Subtitling') IS NOT NULL DROP TABLE #Deal_Rights_Subtitling
	IF OBJECT_ID('tempdb..#Deal_Rights_Territory') IS NOT NULL DROP TABLE #Deal_Rights_Territory
	IF OBJECT_ID('tempdb..#Dup_Records_Language') IS NOT NULL DROP TABLE #Dup_Records_Language
	IF OBJECT_ID('tempdb..#Dup_Records_Language1') IS NOT NULL DROP TABLE #Dup_Records_Language1
	IF OBJECT_ID('tempdb..#TempDupComb') IS NOT NULL DROP TABLE #TempDupComb
END
GO
PRINT N'Altering [dbo].[USP_Validate_Rights_Duplication_UDT_Syn]...';


GO
ALTER PROC [dbo].[USP_Validate_Rights_Duplication_UDT_Syn]
AS
BEGIN 
	IF((SELECT COUNT(*) From Syn_Deal_Rights_Process_Validation WHERE STATUS = 'W') = 0)
	BEGIN
		SET NOCOUNT ON;
		DECLARE @Is_Acq_Syn_CoExclusive CHAR(1) = 'N', @Tentative VARCHAR(100) = 'N'
		DECLARE @IS_PUSH_BACK_SAME_DEAL CHAR(1) ='N', @Is_Autopush CHAR(1) = 'N',@Sql NVARCHAR(1000),@DB_Name VARCHAR(1000),@Agreement_No VARCHAR(100);
		SELECT @IS_PUSH_BACK_SAME_DEAL  = Parameter_Value from System_Parameter_New WHERE Parameter_Name = 'VALIDATE_PUSHBACK_SAME_DEAL'
		
		Select @Is_Acq_Syn_CoExclusive = Parameter_Value From System_Parameter_New Where Parameter_Name = 'Is_Acq_Syn_CoExclusive'
		
		IF(@Is_Acq_Syn_CoExclusive = 'Y')
			SELECT @Tentative = 'N,Y'
			

		DECLARE @Syn_Deal_Rights_Code INT
		Select Top 1 @Syn_Deal_Rights_Code = Syn_Deal_Rights_Code From Syn_Deal_Rights_Process_Validation Where Status = 'P' Order By Created_On ASC

		--Select @Is_Autopush = Is_Auto_Push from RightsU_Broadcast.dbo.Acq_Deal where Acq_Deal_Code IN (
		--Select SecondaryDataCode From AcqPreReqMappingData APRMD 
		--INNER JOIN  Syn_Deal_Rights SDR ON SDR.Syn_Deal_Code = APRMD.PrimaryDataCode AND SDR.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		--Where APRMD.PrimaryDataCode = SDR.Syn_Deal_Code AND APRMD.MappingFor = 'ACQDEAL'
		--) 

		UPDATE Syn_Deal_Rights_Process_Validation SET STATUS = 'W' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Status = 'P' 
		UPDATE Syn_Deal_Rights Set Right_Status = 'W' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		DELETE FROM Syn_Deal_Rights_Error_Details WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

		IF EXISTS (SELECT * FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND Right_Type = 'M')
		BEGIN
			UPDATE Syn_Deal_Rights SET Right_Status = 'C' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			UPDATE Syn_Deal_Rights_Process_Validation SET Status = 'D' WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			RETURN;
		END

		BEGIN TRY
		
			Begin  /* Drop Temp Tables, if exists */
				If OBJECT_ID('tempdb..#Temp_Acq_Dubbing') Is Not Null
				Begin
					Drop Table #Temp_Acq_Dubbing
				End
				If OBJECT_ID('tempdb..#NA_Dubbing') Is Not Null
				Begin
					Drop Table #NA_Dubbing
				End
				If OBJECT_ID('tempdb..#ApprovedAcqData') Is Not Null
				Begin
					Drop Table #ApprovedAcqData
				End
				If OBJECT_ID('tempdb..#TempCombination') Is Not Null
				Begin
					Drop Table #TempCombination
				End
				If OBJECT_ID('tempdb..#TempCombination_Session') Is Not Null
				Begin
					Drop Table #TempCombination_Session
				End
				If OBJECT_ID('tempdb..#Temp_Tit_Right') Is Not Null
				Begin
					Drop Table #Temp_Tit_Right
				End
				If OBJECT_ID('tempdb..#Temp_Episode_No') Is Not Null
				Begin
					Drop Table #Temp_Episode_No
				End
				If OBJECT_ID('tempdb..#Deal_Right_Title_WithEpsNo') Is Not Null
				Begin
					Drop Table #Deal_Right_Title_WithEpsNo
				End
				If OBJECT_ID('tempdb..#Temp_Syn_Dup_Records') Is Not Null
				Begin
					Drop Table #Temp_Syn_Dup_Records
				End
				If OBJECT_ID('tempdb..#Temp_Exceptions') Is Not Null
				Begin
					Drop Table #Temp_Exceptions
				End
				If OBJECT_ID('tempdb..#Acq_Titles_With_Rights') Is Not Null
				Begin
					Drop Table #Acq_Titles_With_Rights
				End
				If OBJECT_ID('tempdb..#Acq_Titles') Is Not Null
				Begin
					Drop Table #Acq_Titles
				End
				If OBJECT_ID('tempdb..#Title_Not_Acquire') Is Not Null
				Begin
					Drop Table #Title_Not_Acquire
				End
				If OBJECT_ID('tempdb..#Acq_Avail_Title_Eps') Is Not Null
				Begin
					Drop Table #Acq_Avail_Title_Eps
				End
				If OBJECT_ID('tempdb..#Temp_Country') Is Not Null
				Begin
					Drop Table #Temp_Country
				End
				If OBJECT_ID('tempdb..#Temp_Platforms') Is Not Null
				Begin
					Drop Table #Temp_Platforms
				End
				If OBJECT_ID('tempdb..#Acq_Country') Is Not Null
				Begin
					Drop Table #Acq_Country
				End
				If OBJECT_ID('tempdb..#Temp_Country') Is Not Null
				Begin
					Drop Table #Temp_Country
				End				
				If OBJECT_ID('tempdb..#Temp_Acq_Platform') Is Not Null
				Begin
					Drop Table #Temp_Acq_Platform
				End
				If OBJECT_ID('tempdb..#Temp_Acq_Country') Is Not Null
				Begin
					Drop Table #Temp_Acq_Country
				End
				If OBJECT_ID('tempdb..#NA_Country') Is Not Null
				Begin
					Drop Table #NA_Country
				End				
				If OBJECT_ID('tempdb..#Temp_Subtitling') Is Not Null
				Begin
					Drop Table #Temp_Subtitling
				End
				If OBJECT_ID('tempdb..#Temp_Acq_Subtitling') Is Not Null
				Begin
					Drop Table #Temp_Acq_Subtitling
				End
				If OBJECT_ID('tempdb..#Acq_Sub') Is Not Null
				Begin
					Drop Table #Acq_Sub
				End				
				If OBJECT_ID('tempdb..#NA_Subtitling') Is Not Null
				Begin
					Drop Table #NA_Subtitling
				End
				If OBJECT_ID('tempdb..#Temp_Dubbing') Is Not Null
				Begin
					Drop Table #Temp_Dubbing
				End
				If OBJECT_ID('tempdb..#Temp_NA_Title') Is Not Null
				Begin
					Drop Table #Temp_NA_Title
				End
				If OBJECT_ID('tempdb..#Acq_Dub') Is Not Null
				Begin
					Drop Table #Acq_Dub
				End
				If OBJECT_ID('tempdb..#Acq_Deal_Rights') Is Not Null
				Begin
					Drop Table #Acq_Deal_Rights
				End
				If OBJECT_ID('tempdb..#Min_Right_Start_Date') Is Not Null
				Begin
					Drop Table #Min_Right_Start_Date
				End
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Subtitling') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Subtitling
				End
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Dubbing') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Dubbing
				End
				
				If OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') Is Not Null
				Begin
					Drop Table #Syn_Rights_Code_Lang
				End	
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Title') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Title
				End	
				
				 If OBJECT_ID('tempdb..#Syn_Deal_Rights_Platform') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Platform 
				End	
				If OBJECT_ID('tempdb..#Syn_Deal_Rights') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights
				End	
				 If OBJECT_ID('tempdb..#Syn_Deal_Rights_Territory') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Territory
				End	
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Subtitling') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Subtitling
				End	
				If OBJECT_ID('tempdb..#Syn_Deal_Rights_Dubbing') Is Not Null
				Begin
					Drop Table #Syn_Deal_Rights_Dubbing
				End	
				If OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') Is Not Null
				Begin
					Drop Table #Syn_Rights_Code_Lang
				End	
				If OBJECT_ID('tempdb..#Syn_RIGHTS_NEW') Is Not Null
				Begin
					Drop Table #Syn_RIGHTS_NEW
				End	

				IF OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL
					DROP TABLE #TempPromoter

				IF OBJECT_ID('TEMPDB..#Dup_Records_Language') IS NOT NULL
					DROP TABLE #Dup_Records_Language

				IF OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL
					DROP TABLE #TempPromoter

				IF OBJECT_ID('TEMPDB..#AcqPromoter') IS NOT NULL
					DROP TABLE #AcqPromoter

				IF OBJECT_ID('TEMPDB..#TempAcqPromoter_TL') IS NOT NULL
					DROP TABLE #TempAcqPromoter_TL

				IF OBJECT_ID('TEMPDB..#TempPromoter_TL') IS NOT NULL
					DROP TABLE #TempPromoter_TL

				IF OBJECT_ID('TEMPDB..#NA_Promoter_TL') IS NOT NULL
					DROP TABLE #NA_Promoter_TL

				IF OBJECT_ID('TEMPDB..#TempAcqPromoter_Sub') IS NOT NULL
					DROP TABLE #TempAcqPromoter_Sub

				IF OBJECT_ID('TEMPDB..#TempPromoter_Sub') IS NOT NULL
					DROP TABLE #TempPromoter_Sub

				IF OBJECT_ID('TEMPDB..#NA_Promoter_Sub') IS NOT NULL
					DROP TABLE #NA_Promoter_Sub

				IF OBJECT_ID('TEMPDB..#TempAcqPromoter_Dub') IS NOT NULL
					DROP TABLE #TempAcqPromoter_Dub

				IF OBJECT_ID('TEMPDB..#TempPromoter_Dub') IS NOT NULL
					DROP TABLE #TempPromoter_Dub

				IF OBJECT_ID('TEMPDB..#NA_Promoter_Dub') IS NOT NULL
					DROP TABLE #NA_Promoter_Dub
			End

			Begin /* Create Temp Tables*/
				CREATE Table #ApprovedAcqData
				(
					ID Int IDENTITY(1,1),
					Title_Code Int,	
					Episode_No Int,	
					Platform_Code Int,
					Right_Type  CHAR(1),
					Right_Start_Date DATETIME,
					Right_End_Date DATETIME,
					Is_Title_Language_Right CHAR(1),
					Country_Code Int,
					Terrirory_Type CHAR(1),
					Is_exclusive CHAR(1),
					Subtitling_Language_Code Int,
					Dubbing_Language_Code Int,
					Data_From CHAR(1),
					Is_Available CHAR(1),
					Error_Description NVARCHAR(MAX)
				)

				CREATE Table #TempCombination
				(
					ID Int IDENTITY(1,1),
					Agreement_No Varchar(1000),
					Title_Code Int,	
					Episode_From Int,
					Episode_To Int,
					Platform_Code Int,
					Right_Type  CHAR(1),
					Right_Start_Date DATETIME,
					Right_End_Date DATETIME,
					Is_Title_Language_Right CHAR(1),
					Country_Code Int,
					Terrirory_Type CHAR(1),
					Is_exclusive CHAR(1),
					Subtitling_Language_Code Int,
					Dubbing_Language_Code Int,
					Promoter_Group_Code		INT,
					Promoter_Remarks_Code	INT,
					Data_From CHAR(1),
					Is_Available CHAR(1),
					Error_Description NVARCHAR(MAX),
					Sum_of Int,
					Partition_Of Int
				)

				CREATE Table #TempCombination_Session
				(
					ID Int IDENTITY(1,1),
					Agreement_No Varchar(1000),
					Title_Code Int,	
					Episode_From Int,
					Episode_To Int,
					Platform_Code Int,
					Right_Type  CHAR(1),
					Right_Start_Date DATETIME,
					Right_End_Date DATETIME,
					Is_Title_Language_Right CHAR(1),
					Country_Code Int,
					Terrirory_Type CHAR(1),
					Is_exclusive CHAR(1),
					Subtitling_Language_Code Int,
					Dubbing_Language_Code Int,
					Promoter_Group_Code		INT,
					Promoter_Remarks_Code	INT,
					Data_From CHAR(1),
					Is_Available CHAR(1),
					Error_Description NVARCHAR(MAX),
					Sum_of Int,
					Partition_Of Int,
					MessageUpadated CHAR(1) DEFAULT('N')
				)

				Create Table #Temp_Tit_Right
				(
					Agreement_No Varchar(1000),
					Acq_Deal_Rights_Code Int,
					Title_Code Int,
					Episode_From Int,
					Episode_To Int,
					Platform_Code Int, 
					Right_Type Char(1), 
					Actual_Right_Start_Date DateTime,
					Actual_Right_End_Date DateTime,
					Is_Title_Language_Right Char(1), 
					Country_Code Int, 
					Territory_Type Char(1), 
					Is_Exclusive Char(1),
					Subtitling_Cnt Int,
					Dubbing_Cnt Int,
					Sum_of Int,
					Partition_Of Int
				)

				CREATE Table #Temp_Episode_No
				(
					Episode_No Int
				)

				CREATE Table #Deal_Right_Title_WithEpsNo
				(
					Deal_Rights_Code Int,
					Title_Code Int,
					Episode_No Int,
				)

				CREATE Table #Dup_Records_Language
				(
					[id]						INT,
					[Title_Code]				INT,
					[Platform_Code]				INT,
					[Territory_Code]			INT,
					[Country_Code]				INT,
					[Right_Start_Date]			DATETIME,
					[Right_End_Date]			DATETIME,
					[Right_Type]				VARCHAR (50),
					[Territory_Type]			CHAR (1),
					[Is_Sub_License]			CHAR (1),
					[Is_Title_Language_Right]	CHAR (1),
					[Subtitling_Language]		INT,
					[Dubbing_Language]			INT,
					[Promoter_Group_Code]		INT,
					[Promoter_Remarks_Code]		INT,
					[Deal_Code]					INT,
					[Deal_Rights_Code]			INT,
					[Deal_Pushback_Code]		INT,
					[Agreement_No]				VARCHAR (MAX),
					[ErrorMSG]					VARCHAR (MAX),
					[Episode_From]				INT,
					[Episode_To]				INT,
					[IsPushback]				CHAR (1)      
				)

			End

			Declare @RC Int
			Declare @Deal_Rights_Title Deal_Rights_Title
			Declare @Deal_Rights_Platform Deal_Rights_Platform
			Declare @Deal_Rights_Territory Deal_Rights_Territory
			Declare @Deal_Rights_Subtitling Deal_Rights_Subtitling
			Declare @Deal_Rights_Dubbing Deal_Rights_Dubbing
			Declare @CallFrom char(2)='SR'
			Declare @Debug char(1)='T'
			Declare @Syn_Deal_Code Int = 0

			CREATE TABLE #TempPromoter(
				Promoter_Group_Code		INT,
				Promoter_Remarks_Code	INT,
				Promoter_Parent_Code    INT
			)

			Select @CallFrom = Case When IsNull(Is_Pushback, 'N') = 'N' Then 'SR' Else 'SP' End  From Syn_Deal_Rights  
			Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			Insert InTo @Deal_Rights_Title(Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
			Select  Syn_Deal_Rights_Code, Title_Code, Episode_From, Episode_To
			From Syn_Deal_Rights_Title 
			Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code --And Title_Code = @Title_Code_Cur

			Insert InTo @Deal_Rights_Platform(Deal_Rights_Code,Platform_Code)
			Select  Syn_Deal_Rights_Code, Platform_Code
			From Syn_Deal_Rights_Platform
			Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code;

			Insert InTo @Deal_Rights_Territory(Deal_Rights_Code, Country_Code)
			Select Syn_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code
			From (
				Select Syn_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type 
				From Syn_Deal_Rights_Territory  
				Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As srter
			Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code

			Insert InTo @Deal_Rights_Subtitling(Deal_Rights_Code, Subtitling_Code)
			Select Syn_Deal_Rights_Code, Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
			From (
				Select Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type
				From Syn_Deal_Rights_Subtitling
				Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As srlan
			Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code

			Insert InTo @Deal_Rights_Dubbing(Deal_Rights_Code, Dubbing_Code)
			Select Syn_Deal_Rights_Code, Case When srlan.Language_Type = 'G' Then lgd.Language_Code Else srlan.Language_Code End Language_Code
			From (
				Select Syn_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type
				From Syn_Deal_Rights_Dubbing
				Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As srlan
			Left Join Language_Group_Details lgd On srlan.Language_Group_Code = lgd.Language_Group_Code

			INSERT INTO #TempPromoter(Promoter_Group_Code, Promoter_Remarks_Code,  Promoter_Parent_Code)
			SELECT DISTINCT PG.PRomoter_Group_Code, SDRPR.Promoter_Remarks_Code, PG.Parent_Group_Code   FROM Syn_Deal_Rights_Promoter SDRP
			INNER JOIN Syn_Deal_Rights_Promoter_Group SDRPG ON SDRPG.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			INNER JOIN Syn_Deal_Rights_Promoter_Remarks SDRPR ON SDRPR.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			inner  JOIN Promoter_Group PG ON PG.Parent_Group_Code = SDRPG.Promoter_Group_Code
			WHERE SDRP.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			UNION
			--INSERT INTO #TempPromoter(Promoter_Group_Code, Promoter_Remarks_Code)
			SELECT DISTINCT SDRPG.Promoter_Group_Code, SDRPR.Promoter_Remarks_Code, PG.Parent_Group_Code  FROM Syn_Deal_Rights_Promoter SDRP
			INNER JOIN Syn_Deal_Rights_Promoter_Group SDRPG ON SDRPG.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			INNER JOIN Syn_Deal_Rights_Promoter_Remarks SDRPR ON SDRPR.Syn_Deal_Rights_Promoter_Code = SDRP.Syn_Deal_Rights_Promoter_Code
			INNER JOIN Promoter_Group PG ON PG.Promoter_Group_Code = SDRPG.Promoter_Group_Code
			WHERE SDRP.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			delete from #TempPromoter
			where Promoter_Parent_Code IN(select Promoter_Group_Code from #TempPromoter)

			Declare @Right_Start_Date DATETIME,
				@Right_End_Date DATETIME,
				@Right_Type CHAR(1),
				@Is_Exclusive CHAR(1),
				@Is_Title_Language_Right CHAR(1),
				@Is_Sub_License CHAR(1),
				@Is_Tentative CHAR(1),
				@Sub_License_Code Int,
				@Deal_Rights_Code Int,
				@Deal_Pushback_Code Int,
				@Deal_Code Int,
				@Title_Code Int,
				@Platform_Code Int,
				@Is_Theatrical_Right CHAR(1),
				@Is_Error Char(1) = 'N'

			-- Assign Values To Local Variable 
			Select 
				@Deal_Code=dr.Syn_Deal_Code,
				@Deal_Rights_Code = Syn_Deal_Rights_Code, 
				@Deal_Pushback_Code = Case When @CallFrom = 'SP' Then dr.Syn_Deal_Rights_Code Else 0 End,
				@Right_Start_Date=dr.Right_Start_Date,
				@Right_End_Date=dr.Right_End_Date,
				@Right_Type=dr.Right_Type,
				@Is_Exclusive=dr.Is_Exclusive,
				@Is_Tentative=dr.Is_Tentative,
				@Is_Sub_License=dr.Is_Sub_License,
				@Sub_License_Code=dr.Sub_License_Code,
				@Is_Title_Language_Right=dr.Is_Title_Language_Right,	
				@Title_Code=0,
				@Platform_Code=0,
				@Is_Theatrical_Right=IsNull(dr.Is_Theatrical_Right,'N')
			From Syn_Deal_Rights dr Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			-- Start Abhay's code 
			Truncate Table #Temp_Episode_No
			Truncate Table #Deal_Right_Title_WithEpsNo

			Declare @StartNum Int, @EndNum Int
			Select @StartNum = MIN(Episode_FROM), @EndNum = MAX(Episode_To) From @Deal_Rights_Title;
			
			With gen As (
				Select @StartNum As num Union All
				Select num+1 From gen Where num + 1 <= @EndNum
			)

			Insert InTo #Temp_Episode_No
			Select * From gen
			Option (maxrecursion 10000)

			Insert InTo #Deal_Right_Title_WithEpsNo(Deal_Rights_Code, Title_Code, Episode_No)
			Select Deal_Rights_Code,Title_Code, Episode_No 
			From (
				Select Distinct t.Deal_Rights_Code,t.Title_Code, a.Episode_No 
				From #Temp_Episode_No A 
				Cross Apply @Deal_Rights_Title T 
				Where A.Episode_No Between T.Episode_FROM And T.Episode_To
			) As B 
			-- End Abhay's code
		
			Declare @Count_SubTitle Int = 0, @Count_Dub Int = 0
			Delete From @Deal_Rights_Subtitling Where Subtitling_Code = 0
			Delete From @Deal_Rights_Dubbing Where Dubbing_Code = 0

			If((Select COUNT(IsNull(Subtitling_Code,0)) From @Deal_Rights_Subtitling)>0)
			Begin
				Set @Count_SubTitle = 1
			End
			If((Select COUNT(IsNull(Dubbing_Code,0)) From @Deal_Rights_Dubbing)>0)
			Begin
				Set @Count_Dub = 1
			End
		
			Select ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,
					Is_Exclusive, ADR.Acq_Deal_Code, AD.Agreement_No,
					(Select Count(*) From Acq_Deal_Rights_Subtitling a Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) SubCnt, 
					(Select Count(*) From Acq_Deal_Rights_Dubbing a Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) DubCnt,
				   	Sum(                        
						Case 
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
							When (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
							When (@Right_Start_Date < ADR.Actual_Right_Start_Date) And (@Right_End_Date > ADR.Actual_Right_End_Date)
								Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date))
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
							Else 0 
						End
					)Sum_of,
					Sum(
						Case 
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
							When (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
							When (@Right_Start_Date < ADR.Actual_Right_Start_Date) And (@Right_End_Date > ADR.Actual_Right_End_Date)
								Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
							Else 0 
						End
					)
					OVER(
						PARTITION BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code
					) Partition_Of
					InTo #Acq_Deal_Rights
			From Acq_Deal_Rights ADR
			Inner Join Acq_Deal AD On ADR.Acq_Deal_Code = ad.Acq_Deal_Code And IsNull(AD.Deal_Workflow_Status,'') = 'A'
			Where 
			ADR.Acq_Deal_Code Is Not Null
			And ADR.Is_Sub_License='Y'
			And ADR.Is_Tentative IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Tentative,','))
			--And ADR.Is_Tentative='N'
			And
			(
				(
					ADR.Right_Type ='Y' AND
					(
						(CONVERT(DATETIME, @Right_Start_Date, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) And Convert(DATETIME, ADR.Right_End_Date, 103)) OR
						(CONVERT(DATETIME, @Right_End_Date, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) And CONVERT(DATETIME, ADR.Right_End_Date, 103)) OR
						(CONVERT(DATETIME, ADR.Right_Start_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103)) OR
						(CONVERT(DATETIME, ADR.Right_End_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103))
					)
				)OR(ADR.Right_Type ='U'  OR ADR.Right_Type ='M')
			) AND (    
				(ADR.Is_Title_Language_Right = @Is_Title_Language_Right) OR 
				(@Is_Title_Language_Right <> 'Y' And ADR.Is_Title_Language_Right = 'Y') OR 
				(@Is_Title_Language_Right = 'Y' And ADR.Is_Title_Language_Right = 'N')
			) AND (
				(@Is_Exclusive = 'Y' And IsNull(ADR.Is_exclusive,'')='Y') OR @Is_Exclusive = 'N'
			) 
			GROUP BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code, AD.Agreement_No
			Begin ----------------- CHECK TITLE WITH EPISODE EXISTS OR NOT

				Select Distinct ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To, ADR.SubCnt, ADR.DubCnt,
								ADR.Sum_of, ADR.Partition_Of
				InTo #Acq_Titles_With_Rights
				From #Acq_Deal_Rights ADR
				Inner Join dbo.Acq_Deal_Rights_Title ADRT On ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
				Inner Join @Deal_Rights_Title drt On ADRT.Title_Code = drt.Title_Code And (
					(drt.Episode_From Between ADRT.Episode_From And ADRT.Episode_To)
					Or
					(drt.Episode_To Between ADRT.Episode_From And ADRT.Episode_To)
					Or
					(ADRT.Episode_From Between drt.Episode_From And drt.Episode_To)
					Or
					(ADRT.Episode_To Between drt.Episode_From And drt.Episode_To)
				)
				Select Distinct Title_Code, Episode_From, Episode_To InTo #Acq_Titles From #Acq_Titles_With_Rights

				Select Title_Code, Episode_No InTo #Acq_Avail_Title_Eps
				From (
					Select Distinct t.Title_Code, a.Episode_No 
					From #Temp_Episode_No A 
					Cross Apply #Acq_Titles T 
					Where A.Episode_No Between T.Episode_FROM And T.Episode_To
				) As B 

				Select ROW_NUMBER() Over(Order By Title_Code, Episode_No Asc) RowId, * InTo #Title_Not_Acquire From #Deal_Right_Title_WithEpsNo deps
				Where deps.Episode_No Not In (
					Select Episode_No From #Acq_Avail_Title_Eps aeps Where deps.Title_Code = aeps.Title_Code
				)

				Drop Table #Acq_Avail_Title_Eps
				
				Create Table #Temp_NA_Title(
					Title_Code Int,
					Episode_From Int,
					Episode_To Int,
					Status Char(1)
				)

				Declare @Cur_Title_code Int = 0, @Cur_Episode_No Int = 0, @Prev_Title_Code Int = 0, @Prev_Episode_No Int
				Declare CUS_EPS Cursor For 
					Select Title_code, Episode_No From #Title_Not_Acquire Order By Title_code Asc, Episode_No  Asc
				Open CUS_EPS
				Fetch Next From CUS_EPS InTo @Cur_Title_code, @Cur_Episode_No
				While(@@FETCH_STATUS = 0)
				Begin
	
					If(@Cur_Title_code <> @Prev_Title_Code)
					Begin

						If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Prev_Title_Code)
						Begin
							Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Prev_Title_Code
						End

						Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
						Select @Cur_Title_code, @Cur_Episode_No, 'U'
						Set @Prev_Title_Code = @Cur_Title_code
					End
					Else If(@Cur_Title_code = @Prev_Title_Code And @Cur_Episode_No <> (@Prev_Episode_No + 1))
					Begin
						If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Cur_Title_code)
						Begin
							Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Cur_Title_code
						End
		
						Insert InTo #Temp_NA_Title(Title_Code, Episode_From, Status)
						Select @Cur_Title_code, @Cur_Episode_No, 'U'
					End
	
					Set @Prev_Episode_No = @Cur_Episode_No

					Fetch Next From CUS_EPS InTo @Cur_Title_code, @Cur_Episode_No
				End
				Close CUS_EPS
				Deallocate CUS_EPS

				Drop Table #Title_Not_Acquire

				If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Prev_Title_Code)
				Begin
					Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Prev_Title_Code
				End

				If Exists(Select Top 1 * From #Temp_NA_Title)
				Begin
					Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
																Right_Type, Is_Sub_Licence, Is_Title_Language_Right, Country_Name, Subtitling_Language, 
																Dubbing_Language, Agreement_No, ErrorMsg, Episode_From, Episode_To, Inserted_On,IsPushback)
					Select @Syn_Deal_Rights_Code, t.Title_Name, 'NA', Null, Null, 
							'NA', 'NA', 'NA', 'NA', 'NA', 
							'NA', 'NA', 'Title not acquired', Episode_From, Episode_To, GETDATE(), Null
					From #Temp_NA_Title tnt
					Inner Join Title t On tnt.Title_Code = t.Title_Code

					Drop Table #Temp_NA_Title

					Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					Set @Is_Error = 'Y'
				End
				--Else
				--Begin
				--	Update Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				--End

			End ------------------------------ END

			Begin ----------------- CHECK PLATFORM And TITLE & EPISODE EXISTS OR NOT

				Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRP.Platform_Code
				InTo #Temp_Platforms
				From #Acq_Titles DRT
				Inner Join @Deal_Rights_Platform DRP On 1 = 1

				Drop Table #Acq_Titles

				Select art.*, adrp.Platform_Code InTo #Temp_Acq_Platform From #Acq_Titles_With_Rights art
				Inner Join Acq_Deal_Rights_Platform adrp On adrp.Acq_Deal_Rights_Code = art.Acq_Deal_Rights_Code
				Inner Join @Deal_Rights_Platform drp On adrp.Platform_Code = drp.Platform_Code

				Drop Table #Acq_Titles_With_Rights

				Delete From #Temp_Acq_Platform Where Platform_Code Not In (Select Platform_Code From #Temp_Platforms)

				Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRT.Platform_Code InTo #NA_Platforms
				From #Temp_Platforms DRT
				Where DRT.Platform_Code Not In (
					Select ap.Platform_Code From #Temp_Acq_Platform ap
					Where DRT.Title_Code = ap.Title_Code And DRT.Episode_From = ap.Episode_From And DRT.Episode_To = ap.Episode_To
				)

				Delete From #Temp_Platforms Where #Temp_Platforms.Platform_Code In (
					Select np.Platform_Code From #NA_Platforms np
					Where np.Title_Code = #Temp_Platforms.Title_Code And np.Episode_From = #Temp_Platforms.Episode_From And np.Episode_To = #Temp_Platforms.Episode_To
				)

				Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
										 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, 0, '', 
					   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Platform not acquired', @Is_Title_Language_Right 
				From #NA_Platforms np

				Drop Table #NA_Platforms

			End ------------------------------ END
						
			Begin ----------------- CHECK COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT
			
				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tc.Country_Code InTo #Temp_Country
				From #Temp_Platforms tp
				Inner Join @Deal_Rights_Territory TC On 1 = 1

				Drop Table #Temp_Platforms

				Declare @Thetrical_Platform_Code Int = 0, @Domestic_Country Int = 0
				Select @Thetrical_Platform_Code = Cast(Parameter_Value As Int) From System_Parameter_New Where Parameter_Name = 'THEATRICAL_PLATFORM_CODE'
				Select @Domestic_Country = Cast(Parameter_Value As Int) From System_Parameter_New Where Parameter_Name = 'INDIA_COUNTRY_CODE'

				If Exists(Select Top 1 * From #Temp_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country)
				Begin
				
					Insert InTo #Temp_Country
					Select tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, c.Country_Code
					From (
						Select * From #Temp_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country
					) As tp Inner Join Country c On c.Parent_Country_Code = tp.Country_Code

					Delete From #Temp_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country

				End
		

				Select Acq_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code InTo #Acq_Country
				From (
					Select Acq_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type 
					From Acq_Deal_Rights_Territory  
					Where Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code from #Acq_Deal_Rights)
				) srter
				Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code


				Select tap.*, adc.Country_Code InTo #Temp_Acq_Country From #Temp_Acq_Platform tap
				Inner Join #Acq_Country adc On tap.Acq_Deal_Rights_Code = adc.Acq_Deal_Rights_Code

				Drop Table #Acq_Country
				Drop Table #Temp_Acq_Platform

				If Exists(Select Top 1 * From #Temp_Acq_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country)
				Begin
				
					Insert InTo #Temp_Acq_Country(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Sum_of, partition_of)
					Select tp.Acq_Deal_Rights_Code, tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, c.Country_Code,tp.Sum_of, tp.partition_of
					From (
						Select * From #Temp_Acq_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country
					) As tp Inner Join Country c On c.Parent_Country_Code = tp.Country_Code

					Delete From #Temp_Acq_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country

				End
			
				Delete From #Temp_Acq_Country Where Country_Code Not In (Select Country_Code From #Temp_Country)

				Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code InTo #NA_Country
				From #Temp_Country DRC
				Where DRC.Country_Code Not In (
					Select ac.Country_Code From #Temp_Acq_Country ac
					Where DRC.Title_Code = ac.Title_Code And DRC.Episode_From = ac.Episode_From And DRC.Episode_To = ac.Episode_To And DRC.Platform_Code = ac.Platform_Code
				)

				Delete From #Temp_Country Where #Temp_Country.Country_Code In (
					Select np.Country_Code From #NA_Country np
					Where np.Title_Code = #Temp_Country.Title_Code And np.Episode_From = #Temp_Country.Episode_From 
						  And np.Episode_To = #Temp_Country.Episode_To And np.Platform_Code = #Temp_Country.Platform_Code
				)
			
				Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
										 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
					   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Region not acquired', @Is_Title_Language_Right 
				From #NA_Country np

				Drop Table #NA_Country

				If(@Is_Title_Language_Right = 'Y')
				Begin
					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
														 Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
														 Data_From, Is_Available, Error_Description,
														 Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
						T.Country_Code, 'I', @Is_Exclusive, 0, 0,
						'S', 'N', 'Session',
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End Sum_of,
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End partition_of
					From #Temp_Country T
				End

				
				INSERT INTO #TempCombination
				(
					Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
					Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
					Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
				)
				SELECT DISTINCT ADR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, ADR.Right_Type, 
					ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right, ac.Country_Code, 'I', ADR.Is_Exclusive, 
					0, 0, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
				FROM #Temp_Acq_Country ac 
				Inner Join #Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code= ac.Acq_Deal_Rights_Code
				Where ADR.Is_Title_Language_Right = 'Y'
			End ------------------------------ END

			Begin ----------------- CHECK SUBTITLING And COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT
				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Subtitling_Code
				InTo #Temp_Subtitling
				From #Temp_Country tp
				Inner Join @Deal_Rights_Subtitling ts On 1 = 1

				If Exists(Select Top 1 * From @Deal_Rights_Subtitling)
				Begin

					Select Acq_Deal_Rights_Code, Case When sub.Language_Type = 'G' Then lgd.Language_Code Else sub.Language_Code End Language_Code 
					InTo #Acq_Sub From (
						Select Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code 
						From Acq_Deal_Rights_Subtitling adrs 
						Where Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code from #Acq_Deal_Rights)
					)As sub
					Left Join Language_Group_Details lgd On sub.Language_Group_Code = lgd.Language_Group_Code 

					Delete From #Acq_Sub Where Language_Code Not In (Select Subtitling_Code From @Deal_Rights_Subtitling)

					Select tac.*, adrs.Language_Code InTo #Temp_Acq_Subtitling From #Temp_Acq_Country tac
					Inner Join #Acq_Sub adrs On tac.Acq_Deal_Rights_Code = adrs.Acq_Deal_Rights_Code 

					Drop Table #Acq_Sub
					
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Subtitling_Code InTo #NA_Subtitling
					From #Temp_Subtitling DRC
					Where DRC.Subtitling_Code Not In (
						Select asub.Language_Code From #Temp_Acq_Subtitling asub
						Where DRC.Title_Code = asub.Title_Code And DRC.Episode_From = asub.Episode_From And DRC.Episode_To = asub.Episode_To 
						And DRC.Platform_Code = asub.Platform_Code And DRC.Country_Code = asub.Country_Code
					)
					
					Delete From #Temp_Subtitling Where #Temp_Subtitling.Subtitling_Code In (
						Select asub.Subtitling_Code From #NA_Subtitling asub
						Where #Temp_Subtitling.Title_Code = asub.Title_Code And #Temp_Subtitling.Episode_From = asub.Episode_From And #Temp_Subtitling.Episode_To = asub.Episode_To 
						And #Temp_Subtitling.Platform_Code = asub.Platform_Code And #Temp_Subtitling.Country_Code = asub.Country_Code
					)

					Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Subtitling Language not acquired', @Is_Title_Language_Right, Subtitling_Code, 0
					From #NA_Subtitling nsub
					
					Drop Table #NA_Subtitling

					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
														 Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
														 Data_From, Is_Available, Error_Description,
														 Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
						T.Country_Code, 'I', @Is_Exclusive, Subtitling_Code, 0,
						'S', 'N', 'Session',
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End Sum_of,
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End partition_of
					From #Temp_Subtitling T

					INSERT INTO #TempCombination
					(
						Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
						Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
						Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
					)
					SELECT DISTINCT ADR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, ADR.Right_Type, 
						ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right, ac.Country_Code, 'I', ADR.Is_Exclusive, 
						Language_Code, 0, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
					FROM #Temp_Acq_Subtitling ac 
					Inner Join #Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code= ac.Acq_Deal_Rights_Code
				End
				Else
				Begin
					Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Subtitling Language not acquired', @Is_Title_Language_Right, Subtitling_Code, 0
					From #Temp_Subtitling nsub

				End
			End ------------------------------ END
				
			Begin ----------------- CHECK DUBBING And COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT

				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Dubbing_Code
				InTo #Temp_Dubbing
				From #Temp_Country tp
				Inner Join @Deal_Rights_Dubbing ts On 1 = 1

				If Exists(Select Top 1 * From @Deal_Rights_Dubbing)
				Begin

					Select Acq_Deal_Rights_Code, Case When dub.Language_Type = 'G' Then lgd.Language_Code Else dub.Language_Code End Language_Code InTo #Acq_Dub
					From (
						Select Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code 
						From Acq_Deal_Rights_Dubbing
						Where Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code from #Acq_Deal_Rights)
					)As dub
					Left Join Language_Group_Details lgd On dub.Language_Group_Code = lgd.Language_Group_Code 
					
					Delete From #Acq_Dub Where Language_Code Not In (Select Dubbing_Code From @Deal_Rights_Dubbing)

					Select tac.*, adrs.Language_Code InTo #Temp_Acq_Dubbing From #Temp_Acq_Country tac
					Inner Join #Acq_Dub adrs On tac.Acq_Deal_Rights_Code = adrs.Acq_Deal_Rights_Code 

					Drop Table #Acq_Dub
					
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Dubbing_Code InTo #NA_Dubbing
					From #Temp_Dubbing DRC
					Where DRC.Dubbing_Code Not In (
						Select adub.Language_Code From #Temp_Acq_Dubbing adub
						Where DRC.Title_Code = adub.Title_Code And DRC.Episode_From = adub.Episode_From And DRC.Episode_To = adub.Episode_To 
						And DRC.Platform_Code = adub.Platform_Code And DRC.Country_Code = adub.Country_Code
					)

					Delete From #Temp_Dubbing Where #Temp_Dubbing.Dubbing_Code In (
						Select adub.Dubbing_Code From #NA_Dubbing adub
						Where #Temp_Dubbing.Title_Code = adub.Title_Code And #Temp_Dubbing.Episode_From = adub.Episode_From And #Temp_Dubbing.Episode_To = adub.Episode_To 
						And #Temp_Dubbing.Platform_Code = adub.Platform_Code And #Temp_Dubbing.Country_Code = adub.Country_Code
					)
					
					
					Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Dubbing Language not acquired', @Is_Title_Language_Right, 0, Dubbing_Code
					From #NA_Dubbing nsub
					
					Drop Table #NA_Dubbing

					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
														 Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
														 Data_From, Is_Available, Error_Description,
														 Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, @Is_Title_Language_Right,
						T.Country_Code, 'I', @Is_Exclusive, 0, Dubbing_Code,
						'S', 'N', 'Session',
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End Sum_of,
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End partition_of
					From #Temp_Dubbing T

					INSERT INTO #TempCombination
					(
						Agreement_No, Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, 
						Right_Start_Date, Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
						Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, Error_Description,SUM_of,partition_of
					)
					SELECT DISTINCT ADR.Agreement_No, ac.Title_Code, ac.Episode_From, ac.Episode_To, ac.Platform_Code, ADR.Right_Type, 
						ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right, ac.Country_Code, 'I', ADR.Is_Exclusive, 
						0, ac.Language_Code, 'T', 'N', 'View Data', ac.SUM_of, ac.partition_of
					FROM #Temp_Acq_Dubbing ac 
					Inner Join #Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code= ac.Acq_Deal_Rights_Code
				End
				Else
				Begin
				
					Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						   @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Dubbing Language not acquired', @Is_Title_Language_Right, 0, Dubbing_Code
					From #Temp_Dubbing nsub

				End
			End ------------------------------ END
			
			IF(OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL)
			BEGIN /*Check Promoter with Subtitle / Dubbing, Country, Platform, Title and Episode*/
				IF EXISTS (SELECT TOP 1 * FROM #TempPromoter)
				BEGIN

					
					select a.Acq_Deal_Rights_Code, a.Promoter_Group_Code, a.Promoter_Remarks_Code, a.Is_Title_Language_Right, a.SelectedInSyn
					into #AcqPromoter from (
					SELECT ADRP.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code, PG.Promoter_Group_Code AS Promoter_Group_Code, ADRPR.Promoter_Remarks_Code AS Promoter_Remarks_Code, 
					ISNULL(ADR.Is_Title_Language_Right, 'N') AS Is_Title_Language_Right, 'N' AS SelectedInSyn 
					FROM Acq_Deal_Rights ADR
					INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
					INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					INNER JOIN Promoter_Group PG ON PG.Parent_Group_Code = ADRPG.Promoter_Group_Code 
					WHERE ADRP.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code from #Acq_Deal_Rights)
					UNION
					SELECT ADRP.Acq_Deal_Rights_Code AS Acq_Deal_Rights_Code, ADRPG.Promoter_Group_Code AS Promoter_Group_Code, ADRPR.Promoter_Remarks_Code  AS Promoter_Remarks_Code, 
					ISNULL(ADR.Is_Title_Language_Right, 'N') AS Is_Title_Language_Right, 'N' AS SelectedInSyn 
					FROM Acq_Deal_Rights ADR
					INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
					INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					WHERE ADRP.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code from #Acq_Deal_Rights)
					) as a

					--SELECT ADRP.Acq_Deal_Rights_Code, PG.Promoter_Group_Code, ADRPR.Promoter_Remarks_Code, 
					--ISNULL(ADR.Is_Title_Language_Right, 'N') AS Is_Title_Language_Right, 'N' AS SelectedInSyn 
					--INTO #AcqPromoter FROM Acq_Deal_Rights ADR
					--INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
					--INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					--INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
					--INNER JOIN Promoter_Group PG ON PG.Parent_Group_Code = ADRPG.Promoter_Group_Code 
					--WHERE ADRP.Acq_Deal_Rights_Code In (SELECT Acq_Deal_Rights_Code from #Acq_Deal_Rights)

					UPDATE AP SET AP.SelectedInSyn = 'Y' FROM #AcqPromoter AP
					INNER JOIN #TempPromoter SP ON AP.Promoter_Group_Code = SP.Promoter_Group_Code AND AP.Promoter_Remarks_Code = SP.Promoter_Remarks_Code

					DELETE FROM #AcqPromoter WHERE SelectedInSyn <> 'Y'

					/* Start Validation For Promoter with Title Language*/
					IF(@Is_Title_Language_Right = 'Y')
					BEGIN
						SELECT TAC.*, AP.Is_Title_Language_Right, AP.Promoter_Group_Code, AP.Promoter_Remarks_Code 
						INTO #TempAcqPromoter_TL FROM #Temp_Acq_Country TAC
						INNER JOIN #AcqPromoter AP ON AP.Acq_Deal_Rights_Code = TAC.Acq_Deal_Rights_Code --AND AP.Is_Title_Language_Right = 'Y'

						SELECT DISTINCT TC.Title_Code, TC.Episode_From, TC.Episode_To, TC.Platform_Code, TC.Country_Code,
						TP.Promoter_Group_Code, TP.Promoter_Remarks_Code
						INTO #TempPromoter_TL FROM #Temp_Country TC
						INNER JOIN #TempPromoter TP ON 1 = 1


						IF(OBJECT_ID('TEMPDB..#TempPromoter_TL') IS NOT NULL)
						BEGIN
							SELECT DISTINCT TP.Title_Code, TP.Episode_From, TP.Episode_To, TP.Platform_Code, TP.Country_Code,
							TP.Promoter_Group_Code, TP.Promoter_Remarks_Code INTO #NA_Promoter_TL
							FROM #TempPromoter_TL TP WHERE
							CAST(TP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TP.Promoter_Remarks_Code AS VARCHAR) NOT IN (
								SELECT CAST(TAP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TAP.Promoter_Remarks_Code AS VARCHAR)
							FROM #TempAcqPromoter_TL TAP
							WHERE TAP.Title_Code = TP.Title_Code AND TAP.Episode_From = TP.Episode_From 
								AND TAP.Episode_To = TP.Episode_To AND TAP.Platform_Code = TP.Platform_Code AND TAP.Country_Code = TP.Country_Code --AND TAP.Is_Title_Language_Right = 'Y'
							)
						END
						
						IF(OBJECT_ID('TEMPDB..#NA_Promoter_TL') IS NOT NULL)
						BEGIN
							INSERT INTO #Dup_Records_Language(
								Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
								Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, 
								Subtitling_Language, Dubbing_Language, Promoter_Group_Code, Promoter_Remarks_Code
							)
							SELECT '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
								'', @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Promoter combination not acquired', @Is_Title_Language_Right, 
								0, 0, Promoter_Group_Code, Promoter_Remarks_Code
							FROM #NA_Promoter_TL NPT
						END
					
					END
					/* End Validation For Promoter with Title Language*/
					IF(OBJECT_ID('TEMPDB..#Temp_Subtitling') IS NOT NULL AND OBJECT_ID('TEMPDB..#Temp_Acq_Subtitling') IS NOT NULL) 
					BEGIN 
						/* Start Validation For Promoter with SubTitling*/
						SELECT TAS.*, AP.Promoter_Group_Code, AP.Promoter_Remarks_Code INTO #TempAcqPromoter_Sub
						FROM #Temp_Acq_Subtitling TAS
						INNER JOIN #AcqPromoter AP ON AP.Acq_Deal_Rights_Code = TAS.Acq_Deal_Rights_Code 

						SELECT DISTINCT TS.Title_Code, TS.Episode_From, TS.Episode_To, TS.Platform_Code, TS.Country_Code, TS.Subtitling_Code,
						TP.Promoter_Group_Code, TP.Promoter_Remarks_Code
						INTO #TempPromoter_Sub FROM #Temp_Subtitling TS
						INNER JOIN #TempPromoter TP ON 1 = 1


						IF(OBJECT_ID('TEMPDB..#TempPromoter_Sub') IS NOT NULL)
						BEGIN
							SELECT DISTINCT TP.Title_Code, TP.Episode_From, TP.Episode_To, TP.Platform_Code, TP.Country_Code, TP.Subtitling_Code, 
							TP.Promoter_Group_Code, TP.Promoter_Remarks_Code INTO #NA_Promoter_Sub 
							FROM #TempPromoter_Sub TP WHERE 
							CAST(TP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TP.Promoter_Remarks_Code AS VARCHAR) NOT IN (
								SELECT CAST(TAP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TAP.Promoter_Remarks_Code AS VARCHAR) 
								FROM #TempAcqPromoter_Sub TAP 
								WHERE TAP.Title_Code = TP.Title_Code AND TAP.Episode_From = TP.Episode_From AND TAP.Episode_To = TP.Episode_To 
								AND TAP.Platform_Code = TP.Platform_Code AND TAP.Country_Code = TP.Country_Code AND TAP.Language_Code = TP.Subtitling_Code
							)
							
							IF(OBJECT_ID('TEMPDB..#NA_Promoter_Sub') IS NOT NULL)
							BEGIN
								Insert InTo #Dup_Records_Language(
									Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
									Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, 
									Subtitling_Language, Dubbing_Language, Promoter_Group_Code, Promoter_Remarks_Code
								)
								Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
									'', @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Promoter combination not acquired', @Is_Title_Language_Right, 
									Subtitling_Code, 0, Promoter_Group_Code, Promoter_Remarks_Code
								From #NA_Promoter_Sub NPS
							END
						END
							
					END /* End Validation For Promoter with SubTitling*/
					IF(OBJECT_ID('TEMPDB..#Temp_Dubbing') IS NOT NULL AND OBJECT_ID('TEMPDB..#Temp_Acq_Dubbing') IS NOT NULL) 
					BEGIN 
						/* Start Validation For Promoter with Dubbing*/
						SELECT TAD.*, AP.Promoter_Group_Code, AP.Promoter_Remarks_Code INTO #TempAcqPromoter_Dub
						FROM #Temp_Acq_Dubbing TAD
						INNER JOIN #AcqPromoter AP ON AP.Acq_Deal_Rights_Code = TAD.Acq_Deal_Rights_Code

						SELECT DISTINCT TD.Title_Code, TD.Episode_From, TD.Episode_To, TD.Platform_Code, TD.Country_Code, TD.Dubbing_Code,
						TP.Promoter_Group_Code, TP.Promoter_Remarks_Code
						INTO #TempPromoter_Dub FROM #Temp_Dubbing TD
						INNER JOIN #TempPromoter TP ON 1 = 1

						IF(OBJECT_ID('TEMPDB..#TempPromoter_Dub') IS NOT NULL)
						BEGIN
							SELECT DISTINCT TP.Title_Code, TP.Episode_From, TP.Episode_To, TP.Platform_Code, TP.Country_Code, TP.Dubbing_Code,  
							TP.Promoter_Group_Code, TP.Promoter_Remarks_Code INTO #NA_Promoter_Dub 
							FROM #TempPromoter_Dub TP WHERE 
							CAST(TP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TP.Promoter_Remarks_Code AS VARCHAR) NOT IN (
								SELECT CAST(TAP.Promoter_Group_Code AS VARCHAR) + '~' + CAST(TAP.Promoter_Remarks_Code AS VARCHAR) FROM #TempAcqPromoter_Dub TAP 
								WHERE TAP.Title_Code = TP.Title_Code AND TAP.Episode_From = TP.Episode_From AND TAP.Episode_To = TP.Episode_To 
								AND TAP.Platform_Code = TP.Platform_Code AND TAP.Country_Code = TP.Country_Code AND TAP.Language_Code = TP.Dubbing_Code
							)
							IF(OBJECT_ID('TEMPDB..#NA_Promoter_Dub') IS NOT NULL)
							BEGIN
							
								Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
									Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, 
									Subtitling_Language, Dubbing_Language, Promoter_Group_Code, Promoter_Remarks_Code)
								Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
									'', @Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Promoter combination not acquired', @Is_Title_Language_Right, 
									0, Dubbing_Code, Promoter_Group_Code, Promoter_Remarks_Code
								From #NA_Promoter_Dub NPD

								--DELETE TP FROM #TempPromoter_Dub TP
								--INNER JOIN #NA_Promoter_Dub NTP ON NTP.Title_Code = TP.Title_Code AND NTP.Episode_From = TP.Episode_From AND NTP.Episode_To = TP.Episode_To 
								--AND NTP.Platform_Code = TP.Platform_Code AND NTP.Country_Code = TP.Country_Code AND NTP.Dubbing_Code = TP.Dubbing_Code
								--AND NTP.Promoter_Group_Code = TP.Promoter_Group_Code AND NTP.Promoter_Remarks_Code = TP.Promoter_Remarks_Code
							END
						END
						
					END
					/* End Validation For Promoter with Dubbing*/
				END
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Country') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Country
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Acq_Subtitling') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Acq_Subtitling
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Acq_Dubbing') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Acq_Dubbing
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Subtitling') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Subtitling
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Dubbing') IS NOT NULL)
			BEGIN
				DROP TABLE #Temp_Dubbing
			END
			
			IF(OBJECT_ID('TEMPDB..#TempPromoter') IS NOT NULL)
			BEGIN
				DROP TABLE #TempPromoter
			END
			IF(OBJECT_ID('TEMPDB..#AcqPromoter') IS NOT NULL)
			BEGIN
				DROP TABLE #AcqPromoter
			END
			IF(OBJECT_ID('TEMPDB..#TempAcqPromoter_TL') IS NOT NULL)
			BEGIN
				DROP TABLE #TempAcqPromoter_TL
			END
			IF(OBJECT_ID('TEMPDB..#TempPromoter_TL') IS NOT NULL)
			BEGIN
				DROP TABLE #TempPromoter_TL
			END
			IF(OBJECT_ID('TEMPDB..#NA_Promoter_TL') IS NOT NULL)
			BEGIN
				DROP TABLE #NA_Promoter_TL
			END
			IF(OBJECT_ID('TEMPDB..#TempAcqPromoter_Sub') IS NOT NULL)
			BEGIN
				DROP TABLE #TempAcqPromoter_Sub
			END
			IF(OBJECT_ID('TEMPDB..#TempPromoter_Sub') IS NOT NULL)
			BEGIN
				DROP TABLE #TempPromoter_Sub
			END
			IF(OBJECT_ID('TEMPDB..#NA_Promoter_Sub') IS NOT NULL)
			BEGIN
				DROP TABLE #NA_Promoter_Sub
			END
			IF(OBJECT_ID('TEMPDB..#TempAcqPromoter_Dub') IS NOT NULL)
			BEGIN
				DROP TABLE #TempAcqPromoter_Dub
			END
			IF(OBJECT_ID('TEMPDB..#TempPromoter_Dub') IS NOT NULL)
			BEGIN
				DROP TABLE #TempPromoter_Dub
			END
			IF(OBJECT_ID('TEMPDB..#NA_Promoter_Dub') IS NOT NULL)
			BEGIN
				DROP TABLE #NA_Promoter_Dub
			END

			IF(OBJECT_ID('TEMPDB..#Temp_Acq_Country') IS NOT NULL)
			BEGIN
				Drop Table #Temp_Acq_Country
			END
			IF(OBJECT_ID('TEMPDB..#Temp_Episode_No') IS NOT NULL)
			BEGIN
				Drop Table #Temp_Episode_No
			END
			IF(OBJECT_ID('TEMPDB..#Deal_Right_Title_WithEpsNo') IS NOT NULL)
			BEGIN
				Drop Table #Deal_Right_Title_WithEpsNo
			END
			IF(OBJECT_ID('TEMPDB..#Acq_Deal_Rights') IS NOT NULL)
			BEGIN
				Drop Table #Acq_Deal_Rights
			END

			UPDATE b SET b.Sum_of = (
				SELECT SUM(c.Sum_of) FROM(
					SELECT DISTINCT a.Title_Code, a.Episode_From, a.Episode_To, a.Platform_Code, a.Country_Code, a.Subtitling_Language_Code, 
					a.Dubbing_Language_Code, a.Promoter_Group_Code, a.Promoter_Remarks_Code, a.Sum_of FROM #TempCombination AS a
				) AS c WHERE c.Title_Code = b.Title_Code And c.Episode_From = b.Episode_From And c.Episode_To = b.Episode_To AND
				c.Platform_Code = b.Platform_Code And c.Country_Code = b.Country_Code And c.Subtitling_Language_Code = b.Subtitling_Language_Code AND 
				c.Dubbing_Language_Code = b.Dubbing_Language_Code AND ISNULL(c.Promoter_Group_Code,0) = ISNULL(b.Promoter_Group_Code,0) AND
				ISNULL(c.Promoter_Remarks_Code,0) = ISNULL(b.Promoter_Remarks_Code,0)
							 
			) From #TempCombination b			

			CREATE TABLE #Min_Right_Start_Date
			(
				Title_Code INT,
				Min_Start_Date DateTime
			)
			
			INSERT INTO #Min_Right_Start_Date
			SELECT T1.Title_Code,MIN(T1.Right_Start_Date) FROM  #TempCombination T1
			GROUP BY T1.Title_Code
			
			IF(@Right_Type ='U' AND EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination WHERE Right_Type='U') AND NOT EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination WHERE Right_Type='Y'))
			BEGIN				
				DELETE T1 				
				FROM #TempCombination T1 
				INNER JOIN #Min_Right_Start_Date MRSD ON T1.Title_Code = MRSD.Title_Code
				WHERE CONVERT(DATETIME, @Right_Start_Date, 103) < CONVERT(DATETIME, IsNull(T1.Right_Start_Date,''), 103)				
			END

			UPDATE t2 Set t2.Is_Available = 'Y'
			FROM #TempCombination_Session t2 
			LEFT join #Min_Right_Start_Date MRSD on T2.Title_Code = MRSD.Title_Code
			Inner Join #TempCombination t1 On 
			T1.Title_Code = T2.Title_Code And 
			T1.Episode_From = T2.Episode_From And 
			T1.Episode_To = T2.Episode_To And 
			T1.Platform_Code = T2.Platform_Code And 
			T1.Country_Code= T2.Country_Code And 
			T1.Subtitling_Language_Code = T2.Subtitling_Language_Code And 
			T1.Dubbing_Language_Code = T2.Dubbing_Language_Code  
			AND
			ISNULL(T1.Promoter_Group_Code,'') = ISNULL(T2.Promoter_Group_Code,'') And 
			ISNULL(T1.Promoter_Remarks_Code,'') = ISNULL(T2.Promoter_Remarks_Code,'')
			And 
			(
				(
					(t1.sum_of = (Case When T2.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  Else 0 End)) OR
					(
						(T1.Right_Type = 'U' OR T2.Right_Type = 'U') AND
						(CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, IsNull(MRSD.MIN_Start_DATE,t1.Right_Start_Date), 103))
					)
				)OR
				(t1.Partition_Of = (Case When T2.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  Else 0 End))
			)AND 
			(
				((T1.Right_Type <> 'Y'  AND T1.Right_Type <> 'M') AND T2.Right_Type = 'U') OR
				((T1.Right_Type = 'Y' OR T1.Right_Type = 'M') AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M')) OR
				(T1.Right_Type = 'U' AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M'))
			)
			DROP TABLE #Min_Right_Start_Date

			Update TCS Set TCS.Error_Description = (
				Case 
					When (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code
					) = 0 Then 'TITLE_MISMATCH' Else '' 
				End + 
				Case 
					When (
						Select Count(*) From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
					) = 0 Then 'PLATFORM_MISMATCH' Else '' 
				End +
				Case 
					When (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code 
						AND TC.Platform_Code = TCS.Platform_Code AND TC.Country_Code = TCS.Country_Code
					) = 0 Then 'COUNTRY_MISMATCH' Else '' 
				End +
				Case 
					When TCS.Is_Title_Language_Right = 'Y' AND TCS.Subtitling_Language_Code = 0 AND TCS.Dubbing_Language_Code = 0 AND (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
						And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = 0 And 0 = TCS.Dubbing_Language_Code 
						And TCS.Is_Title_Language_Right = TC.Is_Title_Language_Right
					) = 0 Then 'TITLE_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When TCS.Dubbing_Language_Code > 0 AND (
						Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
						And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = 0 
						And TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code
					) = 0 Then 'DUBBING_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When TCS.Subtitling_Language_Code > 0 And (Select Count(*) Title_Code From #TempCombination TC 
								Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
									  And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
									  And 0 = TCS.Dubbing_Language_Code) = 0 
					Then 'SUBTITLING_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When (Select Count(*) Title_Code From #TempCombination TC Where TCS.Title_Code = TC.Title_Code And TC.Platform_Code = TCS.Platform_Code
						And TC.Country_Code = TCS.Country_Code And TCS.Subtitling_Language_Code = TC.Subtitling_Language_Code
						And TC.Dubbing_Language_Code = TCS.Dubbing_Language_Code And (
							( 
								(TCS.sum_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  ELSE 0 END))OR
								(
									(TCS.Right_Type = 'U' OR TC.Right_Type = 'U') AND
									(CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, ISNULL(TCS.Right_Start_Date,'') , 103))
								)
							)OR
							(TCS.partition_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  ELSE 0 END))           
						)
					) = 0 Then 'RIGHT_PERIOD' Else '' 
				End
			) FROM #TempCombination_Session TCS
			Where Is_Available='N'
			
			--Select Error_Description, * From #TempCombination_Session Where Title_Code = 5159 And Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired') Where Is_Available='N'
			
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_MISMATCHPLATFORM_MISMATCH', 'Title not acquired') Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'COUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Region not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'SUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'DUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired')Where Is_Available='N'
			UPDATE #TempCombination_Session Set Error_Description = Replace(Error_Description, 'TITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired')Where Is_Available='N'

			UPDATE #TempCombination_Session Set Error_Description = ' Rights period mismatch' Where Is_Available='N' And Error_Description = ''

			Insert InTo #Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
											 Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
			)
			Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
					--Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, 'Rights Period Mismatch', Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
					Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, Error_Description, Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
			From #TempCombination_Session nsub Where Is_Available='N'


			Declare @Deal_Type_Code Int = 0, @Deal_Type Varchar(20) = '', @Syn_Error CHAR(1) = 'N'
			Select @Deal_Type_Code = Deal_Type_Code From Syn_Deal Where Syn_Deal_Code = @Deal_Code
			Select @Deal_Type = [dbo].[UFN_GetDealTypeCondition](@Deal_Type_Code)
			
			--IF(ISNULL(@Is_Autopush, 'N') = 'Y')
			--BEGIN
			--	EXEC  [dbo].[USP_Syn_Autopush_Rights_Validation] @Syn_Deal_Rights_Code, @Syn_Error OUTPUT
			--END
			
			--SELECT @Syn_Error 

			If Exists(Select Top 1 * From #Dup_Records_Language)
			Begin

				Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
															Right_Type, 
															Is_Sub_Licence, 
															Is_Title_Language_Right, 
															Country_Name, 
															Subtitling_Language, 
															Dubbing_Language, 
															Agreement_No, 
															Promoter_Group_Name,
															Promoter_Remark_DESC,
															ErrorMsg, Episode_From, Episode_To, Inserted_On, IsPushback)
				Select @Syn_Deal_Rights_Code, Title_Name, abcd.Platform_Hiearachy Platform_Name, Right_Start_Date as Right_Start_Date, Right_End_Date as Right_End_Date,
					CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
					CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
					CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
					Country_Name,
					CASE WHEN IsNull(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
					CASE WHEN IsNull(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
					Agreement_No, Promoter_Group_Name, Promoter_Remark_Desc, 
					IsNull(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, Getdate(), 'N'
				From(
					Select *,
					STUFF
					(
						(
						Select ', ' + C.Country_Name From Country C 
						Where c.Country_Code In(
							Select Distinct Country_Code From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						) --And C.Country_Code in (select distinct Country_Code from #Deal_Rights_Territory)
						FOR XML PATH('')), 1, 1, ''
					) as Country_Name,
					STUFF
					(
						(
						Select ',' + CAST(P.Platform_Code as Varchar) 
						From Platform p Where p.Platform_Code In
						(
							Select Distinct Platform_Code From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)
						FOR XML PATH('')), 1, 1, ''
					) as Platform_Code,
					STUFF
					(
						(
						Select ', ' + l.Language_Name From Language l 
						Where l.Language_Code In(
							Select Distinct Subtitling_Language From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)
						FOR XML PATH('')), 1, 1, ''
					) as Subtitling_Language,
					STUFF
					(
						(
						Select ', ' + l.Language_Name From Language l 
						Where l.Language_Code In(
							Select Distinct Dubbing_Language From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)
						FOR XML PATH('')), 1, 1, ''
					) as Dubbing_Language,
					STUFF
					(
						(
						Select ', ' + t.Agreement_No From (
							Select Distinct Agreement_No From #Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						) As t
						FOR XML PATH('')), 1, 1, ''
					) as Agreement_No
					From (
						Select T.Title_Code,
							DBO.UFN_GetTitleNameInFormat(@Deal_Type, T.Title_Name, Episode_From, Episode_To) AS Title_Name,
							ADR.Right_Start_Date, ADR.Right_End_Date,
							Is_Sub_License, Is_Title_Language_Right, ADR.ErrorMSG, Right_Type, Episode_From, Episode_To,
							PG.Hierarchy_Name AS Promoter_Group_Name , PR.Promoter_Remark_Desc
						from (
							Select Distinct Title_Code, Episode_From, Episode_To, Right_Start_Date, Right_End_Date, Is_Sub_License,
								Is_Title_Language_Right, ErrorMSG, Right_Type, Promoter_Group_Code, Promoter_Remarks_Code
							From #Dup_Records_Language
						) ADR
						INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
						LEFT JOIN Promoter_Remarks PR ON PR.Promoter_Remarks_Code = ADR.Promoter_Remarks_Code
						LEFT JOIN Promoter_Group PG ON PG.Promoter_Group_Code = ADR.Promoter_Group_Code
					) as a
				) as MainOutput
				Cross Apply
				(
					Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
				) as abcd

				Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

				Set @Is_Error = 'Y'
			End
			--Else If(@Is_Error = 'N')
			--Begin
			--	UPDATE Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			--End
			
			IF(@Syn_Error = 'Y' OR @Is_Error = 'Y')
			BEGIN
				Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			END
			--ELSE
			--BEGIN
			--	Update Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			--END

			Drop Table #TempCombination
			Drop Table #TempCombination_Session
			
			Begin  ------------------------ SYNDICATION DUPLICATION VALIDATION

	
				Create Table #Syn_Deal_Rights_Subtitling
				(
					Syn_Deal_Rights_Code int 
					,Language_Type varchar(100)
					,Language_Group_Code int 
					,Language_Code int
				)
			
				Create Table #Syn_Deal_Rights_Dubbing
				(
					Syn_Deal_Rights_Code int 
					,Language_Type varchar(100)
					,Language_Group_Code int 
					,Language_Code int
				)

				Create Table #Syn_Rights_Code_Lang
				(
					Deal_Rights_Code int
				)

				Select SDR.Syn_Deal_Rights_Code, SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Right_Type, SDR.Is_Title_Language_Right, SDR.Syn_Deal_Code,
						(Select Count(*) From Syn_Deal_Rights_Subtitling a Where a.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) Sub_Cnt,
						(Select Count(*) From Syn_Deal_Rights_Dubbing a Where a.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) Dub_Cnt, 
						Is_Sub_License, Is_Exclusive, Is_Pushback
						InTo #Syn_Deal_Rights
				From Syn_Deal_Rights SDR
				inner join Syn_Deal SD ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code
				Where SD.Deal_Workflow_Status NOT IN ('AR') AND
				(
					(
						SDR.Right_Type ='Y'
						And
						(
							(
								CONVERT(DATETIME, @Right_Start_Date, 103)  BETWEEN
								CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) And Convert(DATETIME, SDR.Actual_Right_End_Date, 103)
							)
							Or
							(
								CONVERT(DATETIME, @Right_End_Date, 103)   BETWEEN 
								CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) And CONVERT(DATETIME, SDR.Actual_Right_End_Date, 103)
							)
							Or
							(
								CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) BETWEEN
								CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103)
							)
							And
							(
								CONVERT(DATETIME, SDR.Actual_Right_End_Date, 103) BETWEEN 
								CONVERT(DATETIME, @Right_Start_Date, 103) And CONVERT(DATETIME, @Right_End_Date, 103)
							)
						)
					)
					Or
					(
						(SDR.Right_Type ='U'  And @Right_Type='U')	
						Or
						(
							(SDR.Right_Type ='U' And @Right_Type='Y')
							And
							(					
								CONVERT(DATETIME, @Right_End_Date, 103) >= CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103)				
							)
						)
						Or
						(
							(SDR.Right_Type ='Y'  And @Right_Type='U')					
							And
							(
								CONVERT(DATETIME, @Right_Start_Date, 103)  BETWEEN 
								CONVERT(DATETIME, SDR.Actual_Right_Start_Date, 103) And Convert(DATETIME, SDR.Actual_Right_End_Date, 103)
							)
						)
					)	
				)
				And
				(
					(
						@CallFrom = 'SP' AND (
							IsNull(Is_Pushback, 'N') = 'N' OR (SDR.Syn_Deal_Code = @Deal_Code And @IS_PUSH_BACK_SAME_DEAL = 'Y')
						)
					)
					Or
					(
						(@CallFrom = 'SR')
						And 
						(
							(ISNULL(Is_Exclusive,'N') = 'Y' And @Is_Exclusive ='N')
							Or ((ISNULL(Is_Exclusive,'N') = 'N' Or ISNULL(Is_Exclusive,'N') = 'Y') And @Is_Exclusive ='Y')
							Or SDR.Syn_Deal_Code = @Deal_Code
						)
					)
				)
				And SDR.Syn_Deal_Rights_Code <> @Deal_Rights_Code

				Begin ----------------- CHECK FOR TITLES

					Select SDR.Syn_Deal_Rights_Code
							,SDRT.Title_Code
							,SDRT.Episode_From
							,SDRT.Episode_To 
					InTo #Syn_Deal_Rights_Title 
					From #Syn_Deal_Rights SDR 
					Inner Join Syn_Deal_Rights_Title SDRT on SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
					Where Title_Code in (
						Select Title_Code From @Deal_Rights_Title inTitle
						Where 
							(inTitle.Episode_From Between SDRT.Episode_From And SDRT.Episode_To) 
						Or	(inTitle.Episode_To Between SDRT.Episode_From And SDRT.Episode_To) 
						Or	(SDRT.Episode_From Between inTitle.Episode_From And inTitle.Episode_To) 
						Or  (SDRT.Episode_To Between inTitle.Episode_From And inTitle.Episode_To)
					)

					Delete From #Syn_Deal_Rights Where Syn_Deal_Rights_Code Not In (
						Select Syn_Deal_Rights_Code From #Syn_Deal_Rights_Title
					)
				END ----------------- END

				Begin ----------------- CHECK FOR PLATFORMS
				
					Select DISTINCT SDR.Syn_Deal_Rights_Code 
							,SDRP.Platform_Code 
							into #Syn_Deal_Rights_Platform 
					From #Syn_Deal_Rights_Title SDR 
					Inner Join Syn_Deal_Rights_Platform SDRP on SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					Where Platform_Code in (Select Platform_Code From @Deal_Rights_Platform)

					
					Delete From #Syn_Deal_Rights_Title Where Syn_Deal_Rights_Code not in (
						Select Syn_Deal_Rights_Code From #Syn_Deal_Rights_Platform
					)

					Delete From #Syn_Deal_Rights Where Syn_Deal_Rights_Code not in (
						Select Syn_Deal_Rights_Code From #Syn_Deal_Rights_Title
					)

				End ----------------- END
				
				Begin ----------------- CHECK FOR COUNTRY
				
					select a.Syn_Deal_Rights_Code, a.Country_Code into #Syn_Deal_Rights_Territory 
					From (
						Select SDR.Syn_Deal_Rights_Code, Case When SDRT.Territory_Type = 'I' Then SDRT.Country_Code Else TD.Country_Code End Country_Code
						from #Syn_Deal_Rights SDR 
						Inner Join Syn_Deal_Rights_Territory SDRT on SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
						Left Join Territory_Details TD On SDRT.Territory_Code = TD.Territory_Code
					) As a	
					Inner Join @Deal_Rights_Territory DRT On a.Country_Code = DRT.Country_Code
					
					delete from #Syn_Deal_Rights_Platform where Syn_Deal_Rights_Code not in (
						select Syn_Deal_Rights_Code from #Syn_Deal_Rights_Territory
					)
					delete from #Syn_Deal_Rights_Title where Syn_Deal_Rights_Code not in (
						select Syn_Deal_Rights_Code from #Syn_Deal_Rights_Platform
					)

					delete from #Syn_Deal_Rights where Syn_Deal_Rights_Code not in (
						select Syn_Deal_Rights_Code from #Syn_Deal_Rights_Title
					)
		
				End ----------------- END
				
				Begin ----------------- CHECK FOR SUBTITLING
				
					IF((SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM @Deal_Rights_Subtitling)>0)
					BEGIN

						insert into #Syn_Deal_Rights_Subtitling(Syn_Deal_Rights_Code,Language_Type, Language_Group_Code,Language_Code)
						Select Syn_Deal_Rights_Code, a.Language_Type, a.Language_Group_Code, Language_Code From (
							select SDR.Syn_Deal_Rights_Code,SDRS.Language_Type,SDRS.Language_Group_Code,
								   Case When SDRS.Language_Type = 'L' Then SDRS.Language_Code  Else LGD.Language_Code End Language_Code
							From #Syn_Deal_Rights SDR 
							Inner Join Syn_Deal_Rights_Subtitling SDRS on SDRS.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
							Left Join Language_Group_Details LGD On SDRS.Language_Group_Code = LGD.Language_Group_Code
						) as a
						Inner Join @Deal_Rights_Subtitling DRS ON DRS.Subtitling_Code=a.Language_Code

					END
					
				End ----------------- END
		
				Begin ----------------- CHECK FOR DUBBING
				
					IF((SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM @Deal_Rights_Dubbing)>0)
					BEGIN
						insert into #Syn_Deal_Rights_Dubbing(Syn_Deal_Rights_Code,Language_Type ,Language_Group_Code,Language_Code)
						Select Syn_Deal_Rights_Code,a.Language_Type, a.Language_Group_Code, Language_Code 
						From (
							select SDR.Syn_Deal_Rights_Code,SDRD.Language_Type,SDRD.Language_Group_Code, 
								   Case When SDRD.Language_Type = 'L' Then SDRD.Language_Code Else LGD.Language_Code End Language_Code
							From #Syn_Deal_Rights SDR
							Inner Join Syn_Deal_Rights_Dubbing SDRD on SDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
							Left Join Language_Group_Details LGD On SDRD.Language_Group_Code = LGD.Language_Group_Code
						) as a
						Inner Join @Deal_Rights_Dubbing DRD ON DRD.Dubbing_Code=a.Language_Code

					END

				End ----------------- END

				IF(
					(SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM @Deal_Rights_Subtitling) = 0 AND 
					(SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM @Deal_Rights_Dubbing) = 0
				)
				BEGIN
					DELETE  FROM #Syn_Deal_Rights WHERE Is_Title_Language_Right = 'N'
				END
				ELSE 
				BEGIN
					INSERT INTO #Syn_Rights_Code_Lang
					SELECT Distinct R.Syn_Deal_Rights_Code FROM #Syn_Deal_Rights R
					WHERE (R.Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y')
				
					INSERT INTO #Syn_Rights_Code_Lang
					SELECT Distinct Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Subtitling 
					where (ISnull(Language_Code,0) <> 0 OR Isnull(Language_Group_Code,0) <> 0)
				
					INSERT INTO #Syn_Rights_Code_Lang	
					SELECT Distinct Syn_Deal_Rights_Code FROM #Syn_Deal_Rights_Dubbing 
					where (ISnull(Language_Code,0) <> 0 OR Isnull(Language_Group_Code,0) <> 0)

					DELETE FROM #Syn_Deal_Rights
					WHERE Syn_Deal_Rights_Code NOT IN(SELECT Deal_Rights_Code FROM #Syn_Rights_Code_Lang)
			
				END
				
				delete from #Syn_Deal_Rights_Title where Syn_Deal_Rights_Code not in (
					select Syn_Deal_Rights_Code from #Syn_Deal_Rights
				)
				delete from #Syn_Deal_Rights_Territory where Syn_Deal_Rights_Code not in (
					select Syn_Deal_Rights_Code from #Syn_Deal_Rights
				)
				delete from #Syn_Deal_Rights_Platform where Syn_Deal_Rights_Code not in (
					select Syn_Deal_Rights_Code from #Syn_Deal_Rights
				)
		
				SELECT SDR.*, SDRT.Title_Code, SDRT.Episode_From, SDRT.Episode_To, SDRP.Platform_Code
				INTO #Syn_Rights_New
				FROM #Syn_Deal_Rights SDR
				INNER JOIN #Syn_Deal_Rights_Title SDRT ON SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code
				INNER JOIN #Syn_Deal_Rights_Platform SDRP ON SDR.Syn_Deal_Rights_Code = SDRP.Syn_Deal_Rights_Code
				
				If Exists(Select Top 1 * From #Syn_Rights_New)
				Begin
					Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
															Right_Type, 
															Is_Sub_Licence, 
															Is_Title_Language_Right, 
															Country_Name, 
															Subtitling_Language, 
															Dubbing_Language, 
															Agreement_No, 
															ErrorMsg, Episode_From, Episode_To, Inserted_On, 
															IsPushback)
					Select @Syn_Deal_Rights_Code, Title_Name, abcd.Platform_Hiearachy Platform_Name, Actual_Right_Start_Date, Actual_Right_End_Date,
						CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
						CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
						CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
						Country_Name,
						CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
						CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
						Agreement_No, ISNULL(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, GetDate(), 
						Case When ISNULL(Is_Pushback,'N') = 'N' Then 'Rights' Else 'Pushback' End As Is_Pushback
					From(
						Select *,
						STUFF
						(
							(
							Select ', ' + C.Country_Name From Country C 
							Where c.Country_Code In(
								Select t.Country_Code From #Syn_Deal_Rights_Territory t 
								Where t.Syn_Deal_Rights_Code In (
									Select adrn.Syn_Deal_Rights_Code From #Syn_Rights_New adrn Where 
										a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
										and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
										and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
										and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Country_Name,
						STUFF
						(
							(
							Select ',' + CAST(P.Platform_Code as Varchar) 
							From Platform p Where p.Platform_Code In
							(
								Select adrn.Platform_Code 
								FROM #Syn_Rights_New adrn 
								WHERE a.Title_Code = adrn.Title_Code
								AND adrn.Platform_Code = p.Platform_Code
								AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
								and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
								and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
								and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
							)
							FOR XML PATH('')), 1, 1, ''
						) as Platform_Code,
						STUFF
						(
							(
							Select ', ' + l.Language_Name From Language l 
							Where l.Language_Code In(
								Select t.Language_Code From #Syn_Deal_Rights_Subtitling t 
								Where t.Syn_Deal_Rights_Code In (
									Select adrn.Syn_Deal_Rights_Code From #Syn_Rights_New adrn 
									Where a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
										and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
										and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
										and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Subtitling_Language,
						STUFF
						(
							(
							Select ', ' + l.Language_Name From Language l 
							Where l.Language_Code In(
								Select t.Language_Code From #Syn_Deal_Rights_Dubbing t Where t.Syn_Deal_Rights_Code In (
									Select adrn.Syn_Deal_Rights_Code From #Syn_Rights_New adrn 
									Where a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
										AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
										And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
										and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
										and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
										and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
								)
							)
							FOR XML PATH('')), 1, 1, ''
						) as Dubbing_Language,
						STUFF
						(
							(
							Select ', ' + t.Agreement_No From Syn_Deal t
							Where t.Deal_Workflow_Status NOT IN ('AR') AND t.Syn_Deal_Code In (
								Select adrn.Syn_Deal_Code From #Syn_Rights_New adrn
								Where a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date
									AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
									And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
									and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
									and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
									and isnull(a.Is_Pushback,'')=isnull(adrn.Is_Pushback,'')
							)
							FOR XML PATH('')), 1, 1, ''
						) as Agreement_No
						From (
							Select T.Title_Code,
								DBO.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name,
								ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date,
								Is_Sub_License, Is_Title_Language_Right, 
								Case 
									WHEN @Deal_Code <> ADR.Syn_Deal_Code THEN  'Combination already Syndicated'
									ELSE 'Combination conflicts with other Rights'
								END AS ErrorMSG, 
								Right_Type, Episode_From, Episode_To, Is_Pushback
							from #Syn_Rights_New ADR
							INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
							Group By T.Title_Code, T.Title_Name, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Sub_License,
								Is_Title_Language_Right, Right_Type, Episode_From, Episode_To, Deal_Type_Code, ADR.Syn_Deal_Code, Is_Pushback
						) as a
					) as MainOutput
					Cross Apply
					(
						SELECT * FROM [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
					) as abcd

					Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
					SET @Is_Error = 'Y'
				End
				--Else If(@Is_Error = 'N')
				--Begin
				--	Update Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				--End

				/*Checking of error in two procedures*/
				IF(@Syn_Error = 'Y' OR @Is_Error = 'Y')
				BEGIN
				Print 'Rights Status = Error'
					Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				END
				ELSE
				BEGIN
				Print 'Rights Status = Correct'
					Update Syn_Deal_Rights Set Right_Status = 'C' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
				END
				/*END*/
				--Select Cast('ad' As Int)

				Drop Table #Syn_Rights_New
				Drop Table #Syn_Deal_Rights
				Drop Table #Syn_Deal_Rights_Title
				Drop Table #Syn_Deal_Rights_Platform
				Drop Table #Syn_Deal_Rights_Territory
				Drop Table #Syn_Deal_Rights_Subtitling
				Drop Table #Syn_Deal_Rights_Dubbing
				Drop Table #Syn_Rights_Code_Lang

			End  ------------------------ End
			-----------------------------INSERTION  OF Error in UTO_ExcepitionLog and Trigger Mail to Dev team Table-------------------------------------
			IF EXISTS(SELECT * FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND  Right_Status = 'E')
			BEGIN
				SELECT @Agreement_No = SD.Agreement_No FROM Syn_Deal_Rights SDR
				INNER JOIN Syn_Deal SD ON SDR.Syn_Deal_Code = SD.Syn_Deal_Code
				WHERE SD.Deal_Workflow_Status NOT IN ('AR') AND SDR.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

				SET @Sql = 'There is an error occured while validating a syndication rights. Syndication Agreement No : '+ @Agreement_No 

				INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
				SELECT GETDATE(),null,null,'USP_Validate_Rights_Duplication_UDT_Syn',@Sql,'NA','NA','DB' 
				FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND  Right_Status = 'E'

				SELECT @DB_Name = DB_NAME()
				EXEC [dbo].[USP_SendMail_Page_Crashed] 'SysDB User', @DB_Name,'RU','USP_Validate_Rights_Duplication_UDT_Syn','AN','VN',@sql,'DB','IP','FR','TI'
			END

		End Try
		Begin Catch
			Delete From Syn_Deal_Rights_Error_Details Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			Insert InTo Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Name, Platform_Name, Right_Start_Date, Right_End_Date, 
														Right_Type, Is_Sub_Licence, Is_Title_Language_Right, Country_Name, Subtitling_Language, 
														Dubbing_Language, Agreement_No, ErrorMsg, Episode_From, Episode_To, Inserted_On,IsPushback)
			Select @Syn_Deal_Rights_Code, 'ERROR IN SYN RIGHTS VALIDATION PROCESS', 'ERROR IN SYN RIGHTS VALIDATION PROCESS', Null, Null, 
					Null, Null, Null, 'ERROR IN SYN RIGHTS VALIDATION PROCESS', 'ERROR IN SYN RIGHTS VALIDATION PROCESS', 
					ERROR_MESSAGE(), ERROR_MESSAGE(), 'ERROR IN SYN RIGHTS VALIDATION PROCESS PLEASE CONTACT ADMINISTRATOR', Null, Null, GETDATE(),''

			Update Syn_Deal_Rights Set Right_Status = 'E' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			SELECT @Agreement_No = SD.Agreement_No FROM Syn_Deal_Rights SDR
			INNER JOIN Syn_Deal SD ON SDR.Syn_Deal_Code = SD.Syn_Deal_Code
			WHERE SD.Deal_Workflow_Status NOT IN ('AR') AND SDR.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 
			 

			SET @Sql = 'There is an error occured while validating a syndication rights. Syndication Agreement No : '+ @Agreement_No + ERROR_MESSAGE()
			INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
			SELECT GETDATE(),null,null,'USP_Validate_Rights_Duplication_UDT_Syn',@Sql,'NA','NA','DB' 
			FROM Syn_Deal_Rights WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code 

			SELECT @DB_Name = DB_NAME()
			EXEC [dbo].[USP_SendMail_Page_Crashed] 'SysDB User', @DB_Name,'RU','USP_Validate_Rights_Duplication_UDT_Syn','AN','VN',@sql ,'DB','IP','FR','TI'

			Declare @UTO_Email_Id Varchar(1000) = ''
			Select @UTO_Email_Id = Parameter_Value From System_Parameter_New Where Parameter_Name = 'UTO_Email_Id'

			DECLARE @DatabaseEmail_Profile varchar(200), @EmailBody NVARCHAR(max) = ''
			SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
			
		End Catch

		Update Syn_Deal_Rights_Process_Validation Set Status = 'D' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
	End

	IF OBJECT_ID('tempdb..#Acq_Avail_Title_Eps') IS NOT NULL DROP TABLE #Acq_Avail_Title_Eps
	IF OBJECT_ID('tempdb..#Acq_Country') IS NOT NULL DROP TABLE #Acq_Country
	IF OBJECT_ID('tempdb..#Acq_Deal_Rights') IS NOT NULL DROP TABLE #Acq_Deal_Rights
	IF OBJECT_ID('tempdb..#Acq_Dub') IS NOT NULL DROP TABLE #Acq_Dub
	IF OBJECT_ID('tempdb..#Acq_Sub') IS NOT NULL DROP TABLE #Acq_Sub
	IF OBJECT_ID('tempdb..#Acq_Titles') IS NOT NULL DROP TABLE #Acq_Titles
	IF OBJECT_ID('tempdb..#Acq_Titles_With_Rights') IS NOT NULL DROP TABLE #Acq_Titles_With_Rights
	IF OBJECT_ID('tempdb..#AcqPromoter') IS NOT NULL DROP TABLE #AcqPromoter
	IF OBJECT_ID('tempdb..#ApprovedAcqData') IS NOT NULL DROP TABLE #ApprovedAcqData
	IF OBJECT_ID('tempdb..#Deal_Right_Title_WithEpsNo') IS NOT NULL DROP TABLE #Deal_Right_Title_WithEpsNo
	IF OBJECT_ID('tempdb..#Deal_Rights_Territory') IS NOT NULL DROP TABLE #Deal_Rights_Territory
	IF OBJECT_ID('tempdb..#Dup_Records_Language') IS NOT NULL DROP TABLE #Dup_Records_Language
	IF OBJECT_ID('tempdb..#Min_Right_Start_Date') IS NOT NULL DROP TABLE #Min_Right_Start_Date
	IF OBJECT_ID('tempdb..#NA_Country') IS NOT NULL DROP TABLE #NA_Country
	IF OBJECT_ID('tempdb..#NA_Dubbing') IS NOT NULL DROP TABLE #NA_Dubbing
	IF OBJECT_ID('tempdb..#NA_Platforms') IS NOT NULL DROP TABLE #NA_Platforms
	IF OBJECT_ID('tempdb..#NA_Promoter_Dub') IS NOT NULL DROP TABLE #NA_Promoter_Dub
	IF OBJECT_ID('tempdb..#NA_Promoter_Sub') IS NOT NULL DROP TABLE #NA_Promoter_Sub
	IF OBJECT_ID('tempdb..#NA_Promoter_TL') IS NOT NULL DROP TABLE #NA_Promoter_TL
	IF OBJECT_ID('tempdb..#NA_Subtitling') IS NOT NULL DROP TABLE #NA_Subtitling
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights') IS NOT NULL DROP TABLE #Syn_Deal_Rights
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Dubbing') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Dubbing
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Platform') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Platform
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Subtitling') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Subtitling
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Territory') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Territory
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Title') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Title
	IF OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') IS NOT NULL DROP TABLE #Syn_Rights_Code_Lang
	IF OBJECT_ID('tempdb..#Syn_Rights_New') IS NOT NULL DROP TABLE #Syn_Rights_New
	IF OBJECT_ID('tempdb..#Temp_Acq_Country') IS NOT NULL DROP TABLE #Temp_Acq_Country
	IF OBJECT_ID('tempdb..#Temp_Acq_Dubbing') IS NOT NULL DROP TABLE #Temp_Acq_Dubbing
	IF OBJECT_ID('tempdb..#Temp_Acq_Platform') IS NOT NULL DROP TABLE #Temp_Acq_Platform
	IF OBJECT_ID('tempdb..#Temp_Acq_Subtitling') IS NOT NULL DROP TABLE #Temp_Acq_Subtitling
	IF OBJECT_ID('tempdb..#Temp_Country') IS NOT NULL DROP TABLE #Temp_Country
	IF OBJECT_ID('tempdb..#Temp_Dubbing') IS NOT NULL DROP TABLE #Temp_Dubbing
	IF OBJECT_ID('tempdb..#Temp_Episode_No') IS NOT NULL DROP TABLE #Temp_Episode_No
	IF OBJECT_ID('tempdb..#Temp_Exceptions') IS NOT NULL DROP TABLE #Temp_Exceptions
	IF OBJECT_ID('tempdb..#Temp_NA_Title') IS NOT NULL DROP TABLE #Temp_NA_Title
	IF OBJECT_ID('tempdb..#Temp_Platforms') IS NOT NULL DROP TABLE #Temp_Platforms
	IF OBJECT_ID('tempdb..#Temp_Subtitling') IS NOT NULL DROP TABLE #Temp_Subtitling
	IF OBJECT_ID('tempdb..#Temp_Syn_Dup_Records') IS NOT NULL DROP TABLE #Temp_Syn_Dup_Records
	IF OBJECT_ID('tempdb..#Temp_Tit_Right') IS NOT NULL DROP TABLE #Temp_Tit_Right
	IF OBJECT_ID('tempdb..#TempAcqPromoter_Dub') IS NOT NULL DROP TABLE #TempAcqPromoter_Dub
	IF OBJECT_ID('tempdb..#TempAcqPromoter_Sub') IS NOT NULL DROP TABLE #TempAcqPromoter_Sub
	IF OBJECT_ID('tempdb..#TempAcqPromoter_TL') IS NOT NULL DROP TABLE #TempAcqPromoter_TL
	IF OBJECT_ID('tempdb..#TempCombination') IS NOT NULL DROP TABLE #TempCombination
	IF OBJECT_ID('tempdb..#TempCombination_Session') IS NOT NULL DROP TABLE #TempCombination_Session
	IF OBJECT_ID('tempdb..#TempPromoter') IS NOT NULL DROP TABLE #TempPromoter
	IF OBJECT_ID('tempdb..#TempPromoter_Dub') IS NOT NULL DROP TABLE #TempPromoter_Dub
	IF OBJECT_ID('tempdb..#TempPromoter_Sub') IS NOT NULL DROP TABLE #TempPromoter_Sub
	IF OBJECT_ID('tempdb..#TempPromoter_TL') IS NOT NULL DROP TABLE #TempPromoter_TL
	IF OBJECT_ID('tempdb..#Title_Not_Acquire') IS NOT NULL DROP TABLE #Title_Not_Acquire

End
GO
PRINT N'Altering [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES]...';


GO
ALTER Procedure [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES]
	@Title_Codes Varchar(1000),
	@Platform_Codes Varchar(MAX),
	@Platform_Type Varchar(10),   ----- PL / TPL / ''
	@Region_Type Varchar(10),	----- T / C / THC / THT
	@Subtitling_Type Varchar(10),	------ SL / SG / ''
	@Dubbing_Type Varchar(10),	------ DL / DG / ''
	@Syn_Deal_Code Int
As
-- =============================================
-- Author:		Bhavesh Desai/Sagar Mahajan/Abhaysingh N. Rajpurohit/Adesh Arote
-- Create date:	16 Oct 2014
-- Description:	Get Distinct DATA of Titles that are approved
-- =============================================
Begin
		Declare @SubTitle_Lang_Code Varchar(MAX),@Dubb_Lang_Code Varchar(MAX),@Parent_Country_Code Int,@Is_Domestic_Territory CHAR(1)
		Set @SubTitle_Lang_Code =''
		Set @Dubb_Lang_Code =''
		Set @Parent_Country_Code=0
		Set @Is_Domestic_Territory= 'N'  -- Y If (Theatrical + India) Else 'N'
		Set NOCOUNT ON;
		Set FMTONLY OFF;
-- =============================================Delete Temp Tables =============================================

	If OBJECT_ID('tempdb..#Deal_Rights_Lang') IS NOT NULL
	Begin
		Drop Table #Deal_Rights_Lang   
	End
-- =============================================CREATE Temp Tables =============================================
		Declare @Deal_Rights_Title  Table 
		(
			Title_Code Int,
			Episode_FROM Int,
			Episode_To Int
		)
-- ============================================= -- ============================================= 
	Declare @Selected_Deal_Type_Code Int ,@Deal_Type_Condition Varchar(MAX) = ''
	DECLARE @Is_Acq_Syn_CoExclusive CHAR(1) = 'N', @Tentative VARCHAR(100) = 'N'
	Declare @TitCnt Int = 0
	Select Top 1 @Selected_Deal_Type_Code = Deal_Type_Code From Syn_Deal Where Syn_Deal_Code = @Syn_Deal_Code
	Select @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	Select @Is_Acq_Syn_CoExclusive = Parameter_Value From System_Parameter_New Where Parameter_Name = 'Is_Acq_Syn_CoExclusive'
		
	IF(@Is_Acq_Syn_CoExclusive = 'Y')
		SELECT @Tentative = 'N,Y'

	If(@Deal_Type_Condition = 'DEAL_PROGRAM')
	Begin
		INSERT InTo @Deal_Rights_Title(Title_Code, Episode_FROM, Episode_To)
		Select Title_Code, Episode_FROM, Episode_End_To From Syn_Deal_Movie 
		Where Syn_Deal_Movie_Code IN (Select number From dbo.fn_Split_withdelemiter(@Title_Codes,',')) And Syn_Deal_Code = @Syn_Deal_Code
	End
	Else
	Begin
		INSERT InTo @Deal_Rights_Title(Title_Code, Episode_FROM, Episode_To)
		Select Title_Code, Episode_FROM, Episode_End_To From Syn_Deal_Movie 
		Where Title_Code IN (Select number From dbo.fn_Split_withdelemiter(@Title_Codes,',')) And Syn_Deal_Code = @Syn_Deal_Code
	End
		
	Declare @Required_Codes Varchar(max) = '' ,@Total_Title_Count  Int = 0
	Select @Total_Title_Count += (Episode_To - Episode_FROM) + 1 From @Deal_Rights_Title
	--Here PL Means 'Platform' 
	-- Here 'TPL' - 'Platform Applicable For Demestic Territory(Theatrical Platform)'
	If(@Platform_Type = 'PL' Or @Platform_Type = 'TPL')
	Begin
			
		Select @TitCnt = Count(Distinct Title_Code) From @Deal_Rights_Title

		Select Distinct adrt.Acq_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_FROM, adrt.Episode_To 
		InTo #AcquiredTitles 
		From Acq_Deal_Rights_Title adrt
		Inner Join Acq_Deal_Rights adr ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code 
			--And ADR.Is_Theatrical_Right = Case When @Region_Type = 'TPL' Then 'Y' Else 'N' End
		Inner Join Acq_Deal ad ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
			And IsNull(AD.Deal_Workflow_Status,'')='A' And ADR.Is_Sub_License='Y'
			--And IsNull(ADR.Is_Tentative, 'N')='N'
			AND  IsNull(ADR.Is_Tentative, 'N') IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Tentative,','))
			And ADR.Actual_Right_Start_Date IS NOT NULL
		Inner Join @Deal_Rights_Title drt ON drt.Title_Code = adrt.Title_Code And 
		(
			drt.Episode_FROM Between adrt.Episode_FROM And adrt.Episode_To Or 
			drt.Episode_To Between adrt.Episode_FROM And adrt.Episode_To Or 
			adrt.Episode_FROM Between drt.Episode_FROM And drt.Episode_To Or 
			adrt.Episode_To Between drt.Episode_FROM And drt.Episode_To
		)
		where
		 ad.Deal_Workflow_Status NOT IN ('AR', 'WA')
			
		Select @Total_Title_Count = Count(Distinct Title_Code) From #AcquiredTitles

		If(@TitCnt = @Total_Title_Count)
		Begin
			Select 
				@Total_Title_Count = Count(*) 
			From
			(
				Select Title_Code, Episode_FROM, Episode_To From #AcquiredTitles Group By Title_Code, Episode_FROM, Episode_To
			) As a

			--Select @Total_Title_Count
			Select @Required_Codes = ''
			If(@Platform_Type = 'PL')
			Begin
				Select 
					@Required_Codes = @Required_Codes + Platform_Code + ','
				From 
				(
					Select Distinct Cast(adr.Title_Code As Varchar) + '-' + Cast(adr.Episode_FROM As Varchar) + '-' + Cast(adr.Episode_To As Varchar) As Title_Code_With_Episode,
					IsNull(Cast(adrp.Platform_Code As Varchar), '') As Platform_Code 
					From #AcquiredTitles adr 
					Inner Join Acq_Deal_Rights_Platform adrp ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code					
				)  As TEMP
				Group By TEMP.Platform_Code
				Having Count( Distinct TEMP.Title_Code_With_Episode) = @Total_Title_Count
			End
			Else If(@Platform_Type = 'TPL')
			Begin
				Select 
					@Required_Codes = @Required_Codes + Platform_Code + ','
				From 
				(
					Select Distinct 
					Cast(adr.Title_Code As Varchar) + '-' + Cast(adr.Episode_FROM As Varchar) + '-' + Cast(adr.Episode_To As Varchar) As Title_Code_With_Episode,
					IsNull(Cast(adrp.Platform_Code As Varchar), '') As Platform_Code 
					From #AcquiredTitles adr 
					Inner Join Acq_Deal_Rights_Platform adrp ON adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
					Inner Join Platform P ON adrp.Platform_Code = P.Platform_Code And Applicable_For_Demestic_Territory = 'Y'
				)  As TEMP
				Group By TEMP.Platform_Code
				Having Count( Distinct TEMP.Title_Code_With_Episode) = @Total_Title_Count
			End
			Set @Required_Codes = Substring(@Required_Codes, 0, Len(@Required_Codes))
		End
		Else
		Begin
			Set @Required_Codes = ''
		End			
		Drop Table #AcquiredTitles			
	End
	Else
	Begin
		Declare @PlatformCnt Int = 0--, @CountryCnt Int = 0			
		Select @TitCnt = Count(Distinct Title_Code) From @Deal_Rights_Title

		Select Distinct adrt.Acq_Deal_Rights_Code, adrt.Title_Code, adrt.Episode_FROM, adrt.Episode_To,adr.Is_Theatrical_Right 
		InTo #AcquiredTitlesNew
		From Acq_Deal_Rights_Title adrt
		Inner Join Acq_Deal_Rights adr ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		Inner Join Acq_Deal ad ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
					And IsNull(AD.Deal_Workflow_Status,'')='A' And ADR.Is_Sub_License='Y'
					--And IsNull(ADR.Is_Tentative, 'N')='N' 
					AND  IsNull(ADR.Is_Tentative, 'N') IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Tentative,','))
					And ADR.Actual_Right_Start_Date IS NOT NULL
					And ((@Region_Type Not In ('THC', 'THT') And ADR.Is_Theatrical_Right = 'N') Or @Region_Type In ('THC', 'THT'))
		Inner Join @Deal_Rights_Title drt ON drt.Title_Code = adrt.Title_Code And 
		(
			drt.Episode_FROM Between adrt.Episode_FROM And adrt.Episode_To Or 
			drt.Episode_To Between adrt.Episode_FROM And adrt.Episode_To Or 
			adrt.Episode_FROM Between drt.Episode_FROM And drt.Episode_To Or 
			adrt.Episode_To Between drt.Episode_FROM And drt.Episode_To
		)
		where 
		 AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 

		Select @Total_Title_Count = Count(Distinct Title_Code) From #AcquiredTitlesNew

		If(@TitCnt = @Total_Title_Count)
		Begin

			Select @PlatformCnt = Count(*) From dbo.fn_Split_withdelemiter(@Platform_Codes,',') plat Where IsNull(number, '') Not In ('', '0')

			--Select Acq_Deal_Rights_Code, Platform_Code, 0 As Rights_Cnt InTo #Rights_Platform From dbo.Acq_Deal_Rights_Platform Where 
			--	Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code From #AcquiredTitlesNew)
			--	And Platform_Code In(Select Number From dbo.fn_Split_withdelemiter(@Platform_Codes,','))
			--Group By Acq_Deal_Rights_Code, Platform_Code

			Select DISTINCT adrp.Acq_Deal_Rights_Code, Platform_Code, atn.Title_Code, atn.Episode_From, atn.Episode_To, 0 As Rights_Cnt 
			InTo #Rights_Platform
			From dbo.Acq_Deal_Rights_Platform adrp
			Inner Join #AcquiredTitlesNew atn On atn.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
			And adrp.Platform_Code In(Select Number From dbo.fn_Split_withdelemiter(@Platform_Codes,','))
			
			Declare @Total_Platform_Cnt Int = 0, @Thetrical_Platform_Code Int = 0, @Is_Theatrical Char(1) = 'N'--, @Thetrical_Platform_Code Int = 0
			Select @Total_Platform_Cnt = Count(*) From dbo.fn_Split_withdelemiter(@Platform_Codes,',') plat
			
			--Update u1 Set u1.Rights_Cnt = u2.cnt From #Rights_Platform u1 
			--Inner Join(
			--	Select Count(*) cnt, Acq_Deal_Rights_Code From #Rights_Platform Group By Acq_Deal_Rights_Code
			--) u2 On u1.Acq_Deal_Rights_Code = u2.Acq_Deal_Rights_Code

			Update u1 Set u1.Rights_Cnt = u2.cnt From #Rights_Platform u1 
			Inner Join(
				Select Count(*) cnt, Title_Code, Episode_From, Episode_To From (
					Select Platform_Code, Title_Code, Episode_From, Episode_To From #Rights_Platform Group By Title_Code, Episode_From, Episode_To
					,Platform_Code
					--, Acq_Deal_Rights_Code
				) As a Group By Title_Code, Episode_From, Episode_To
			) u2 On u1.Title_Code = u2.Title_Code And u1.Episode_From = u2.Episode_From And u1.Episode_To = u2.Episode_To
			
			Delete From #Rights_Platform Where Rights_Cnt <> @Total_Platform_Cnt

			If Exists(Select Top 1 * From #Rights_Platform)
			Begin

				Select @Thetrical_Platform_Code = Cast(Parameter_Value As Int) From System_Parameter_New Where Parameter_Name = 'THEATRICAL_PLATFORM_CODE'
				If((Select Count(*) From dbo.fn_Split_withdelemiter(@Platform_Codes,',') plat Where IsNull(number, '0') = Cast(@Thetrical_Platform_Code As Varchar)) > 0)
				Begin
					Set @Is_Theatrical = 'Y'
				End

				Select Acq_Deal_Rights_Code, Case When arter.Territory_Type = 'G' Then td.Country_Code Else arter.Country_Code End Country_Code
				InTo #Rights_Country
				From (
					Select * From Acq_Deal_Rights_Territory Where Acq_Deal_Rights_Code In (
						Select rc.Acq_Deal_Rights_Code From #Rights_Platform rc
					)
				) arter
				Left Join Territory_Details td On arter.Territory_Code = td.Territory_Code
				
				If(@Region_Type = 'THC' Or @Region_Type = 'THT')
				Begin
					Delete From #Rights_Country Where Country_Code Not In (
						Select Country_Code From Country Where Is_Theatrical_Territory = 'Y' Or Is_Domestic_Territory = 'Y'
					)
					
					Insert InTo #Rights_Country
					Select rc.Acq_Deal_Rights_Code, c.Country_Code From #Rights_Country rc 
					Inner Join Country c On rc.Country_Code = c.Parent_Country_Code And c.Is_Theatrical_Territory = 'Y' And c.Is_Active = 'Y' 
					
					Delete From #Rights_Country Where Country_Code In (
						Select Country_Code From Country Where Is_Domestic_Territory = 'Y' --Or Is_Domestic_Territory = 'N'
					)
				End
				
				If(@Is_Theatrical = 'Y')	-- And @Total_Platform_Cnt > 1
				Begin
					Delete From #Rights_Country Where Country_Code In (
						Select Country_Code From Country Where Is_Domestic_Territory = 'Y'
					)
				End

				Declare @Platform_Cnt Int = 0, @Country_Cnt Int = 0, @Title_Cnt Int = 0

				Select @Title_Cnt = Count(*) From (
					Select Distinct Title_Code, Episode_From, Episode_To From #AcquiredTitlesNew
				) As a

				Select @Platform_Cnt = Count(Distinct Platform_Code) From #Rights_Platform
				
				--Select * From #Rights_Country

				-------------------- Check for common countries in title

				Select Distinct rcon.Acq_Deal_Rights_Code, rtit.Title_Code, rtit.Episode_From, rtit.Episode_To, rcon.Country_Code, 0 As Country_Cnt InTo #Rights_Title_Country 
				From #Rights_Country rcon
				Inner Join #AcquiredTitlesNew rtit On rcon.Acq_Deal_Rights_Code = rtit.Acq_Deal_Rights_Code

				Drop Table #Rights_Country

				Update u1 Set u1.Country_Cnt = u2.cnt From #Rights_Title_Country u1 
				Inner Join(
					Select Count(*) cnt, a.Country_Code From (
						Select Distinct utc.Country_Code, utc.Title_Code, utc.Episode_From, utc.Episode_To From #Rights_Title_Country utc
					) As a Group By a.Country_Code
				) u2 On u1.Country_Code = u2.Country_Code
								
				Delete From #Rights_Title_Country Where Country_Cnt <> @Title_Cnt
				
				--Select * From #Rights_Title_Country

				-------------------- End

				Select Distinct Acq_Deal_Rights_Code, Country_Code InTo #Rights_Country_New From #Rights_Title_Country
				Drop Table #Rights_Title_Country

				-------------------- Check for common countries in Platform

				Select Distinct rcon.Acq_Deal_Rights_Code, rp.Platform_Code, rcon.Country_Code, 0 As Country_Cnt InTo #Rights_Platform_Country 
				From #Rights_Country_New rcon
				Inner Join #Rights_Platform rp On rcon.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
				Drop Table #Rights_Country_New

				Update u1 Set u1.Country_Cnt = u2.cnt From #Rights_Platform_Country u1 
				Inner Join(
					Select Count(*) cnt, a.Country_Code From (
						Select Distinct rpc.Country_Code, rpc.Platform_Code From #Rights_Platform_Country rpc
					) As a Group By a.Country_Code
				) u2 On u1.Country_Code = u2.Country_Code
				
				--Select @Platform_Cnt, * From #Rights_Platform_Country
				Delete From #Rights_Platform_Country Where Country_Cnt <> @Platform_Cnt
				

				-------------------- End

				Select Distinct Acq_Deal_Rights_Code, Country_Code InTo #Rights_Country_Final From #Rights_Platform_Country
				Drop Table #Rights_Platform_Country

				If Exists(Select Top 1 * From #Rights_Country_Final)
				Begin
				
					Select @Country_Cnt = Count(Distinct Country_Code) From #Rights_Country_Final

					--------------------- Subtitling
					Set @SubTitle_Lang_Code = '0'
					If(@Subtitling_Type In ('SL', 'SG'))
					Begin

						Select Acq_Deal_Rights_Code, Case When ars.Language_Type = 'G' Then lgd.Language_Code Else ars.Language_Code End Language_Code
						InTo #Rights_Subtitling
						From (
							Select * From Acq_Deal_Rights_Subtitling Where Acq_Deal_Rights_Code In (
								Select rp.Acq_Deal_Rights_Code From #Rights_Platform rp
							)
						) ars
						Left Join Language_Group_Details lgd On ars.Language_Group_Code = lgd.Language_Group_Code
						
						--Select * From #Rights_Subtitling

						---------------------- Check subtitling for Title

						Select Distinct rsub.Acq_Deal_Rights_Code, rtit.Title_Code, rtit.Episode_From, rtit.Episode_To, rsub.Language_Code, 0 As Title_Cnt 
						InTo #Rights_Title_Subtitling
						From #Rights_Subtitling rsub
						Inner Join #AcquiredTitlesNew rtit On rsub.Acq_Deal_Rights_Code = rtit.Acq_Deal_Rights_Code

						Drop Table #Rights_Subtitling

						Update u1 Set u1.Title_Cnt = u2.cnt From #Rights_Title_Subtitling u1 
						Inner Join(
							Select Count(*) cnt, a.Language_Code From (
								Select Distinct utc.Language_Code, utc.Title_Code, utc.Episode_From, utc.Episode_To From #Rights_Title_Subtitling utc
							) As a Group By a.Language_Code
						) u2 On u1.Language_Code = u2.Language_Code
								
						Delete From #Rights_Title_Subtitling Where Title_Cnt <> @Title_Cnt
						
						--Select * From #Rights_Title_Subtitling

						---------------------- End
						
						Select Distinct Acq_Deal_Rights_Code, Language_Code InTo #Rights_Title_Subtitling_New From #Rights_Title_Subtitling
						Drop Table #Rights_Title_Subtitling

						-------------------- Check Subtitling for Platform

						Select Distinct rsub.Acq_Deal_Rights_Code, rp.Platform_Code, rsub.Language_Code, 0 As Platform_Cnt InTo #Rights_Platform_Subtitling 
						From #Rights_Title_Subtitling_New rsub
						Inner Join #Rights_Platform rp On rsub.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
						Drop Table #Rights_Title_Subtitling_New

						Update u1 Set u1.Platform_Cnt = u2.cnt From #Rights_Platform_Subtitling u1 
						Inner Join(
							Select Count(*) cnt, a.Language_Code From (
								Select Distinct ups.Language_Code, ups.Platform_Code From #Rights_Platform_Subtitling ups
							) a Group By a.Language_Code
						) u2 On u1.Language_Code = u2.Language_Code
				
						--Select * From #Rights_Platform_Subtitling

						Delete From #Rights_Platform_Subtitling Where Platform_Cnt <> @Platform_Cnt

						--Select * From #Rights_Platform_Subtitling
				
						-------------------- End
						
						--Select Distinct Acq_Deal_Rights_Code, Language_Code InTo #Rights_Platform_Subtitling_New From #Rights_Platform_Subtitling
						--Drop Table #Rights_Platform_Subtitling

						---------------------- Check subtitling for Country
						
						--Select Distinct rsub.Acq_Deal_Rights_Code, rp.Country_Code, rsub.Language_Code, 0 As Country_Cnt InTo #Rights_Country_Subtitling 
						--From #Rights_Platform_Subtitling_New rsub
						--Inner Join #Rights_Country_Final rp On rsub.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
						--Drop Table #Rights_Platform_Subtitling_New

						--Update u1 Set u1.Country_Cnt = u2.cnt From #Rights_Country_Subtitling u1 
						--Inner Join(
						--	Select Count(*) cnt, a.Language_Code From (
						--		Select Distinct ucs.Country_Code, ucs.Language_Code From #Rights_Country_Subtitling ucs
						--	) a Group By a.Language_Code
						--) u2 On u1.Language_Code = u2.Language_Code
				
						--Delete From #Rights_Country_Subtitling Where Country_Cnt <> @Country_Cnt
				
						---------------------- End
						
						--Select Distinct Language_Code InTo #Rights_Subs From #Rights_Country_Subtitling
						--Drop Table #Rights_Country_Subtitling
						Select Distinct Language_Code InTo #Rights_Subs From #Rights_Platform_Subtitling
						Drop Table #Rights_Platform_Subtitling

						If(@Subtitling_Type = 'SG')
						Begin

							Select @SubTitle_Lang_Code = @SubTitle_Lang_Code + ',' + Cast(td1.Language_Group_Code As Varchar(10)) From (
								Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details Where Language_Code In (
									Select Language_Code From #Rights_Subs
								) Group By Language_Group_Code
							) As td1
							Inner Join (
								Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details Group By Language_Group_Code
							) As td2 On td1.Language_Group_Code = td2.Language_Group_Code And td1.LanguageCnt = td2.LanguageCnt
						
						End
						Else
						Begin
							Select @SubTitle_Lang_Code = @SubTitle_Lang_Code + ',' + Cast(Language_Code As Varchar(10)) From #Rights_Subs
						End

					End

					-------------------- End

					-------------------- Dubbing
					Set @Dubb_Lang_Code = '0'
					If(@Dubbing_Type In ('DL', 'DG'))
					Begin

						Select Acq_Deal_Rights_Code, Case When ard.Language_Type = 'G' Then lgd.Language_Code Else ard.Language_Code End Language_Code, 0 As Platform_Cnt, 0 As Country_Cnt
						InTo #Rights_Dubbing
						From (
							Select * From Acq_Deal_Rights_Dubbing Where Acq_Deal_Rights_Code In (
								Select rp.Acq_Deal_Rights_Code From #Rights_Platform rp
							)
						) ard
						Left Join Language_Group_Details lgd On ard.Language_Group_Code = lgd.Language_Group_Code
						
						--Select * From #Rights_Dubbing
						
						---------------------- Check Dubbing for Title

						Select Distinct rsub.Acq_Deal_Rights_Code, rtit.Title_Code, rtit.Episode_From, rtit.Episode_To, rsub.Language_Code, 0 As Title_Cnt 
						InTo #Rights_Title_Dubbing
						From #Rights_Dubbing rsub
						Inner Join #AcquiredTitlesNew rtit On rsub.Acq_Deal_Rights_Code = rtit.Acq_Deal_Rights_Code

						Drop Table #Rights_Dubbing

						Update u1 Set u1.Title_Cnt = u2.cnt From #Rights_Title_Dubbing u1 
						Inner Join(
							Select Count(*) cnt, a.Language_Code From (
								Select Distinct utc.Language_Code, utc.Title_Code, utc.Episode_From, utc.Episode_To From #Rights_Title_Dubbing utc
							) As a Group By a.Language_Code
						) u2 On u1.Language_Code = u2.Language_Code
								
						Delete From #Rights_Title_Dubbing Where Title_Cnt <> @Title_Cnt
						
						--Select * From #Rights_Title_Dubbing

						---------------------- End
						
						Select Distinct Acq_Deal_Rights_Code, Language_Code InTo #Rights_Title_Dubbing_New From #Rights_Title_Dubbing
						Drop Table #Rights_Title_Dubbing

						-------------------- Check for common countries in Platform

						Select Distinct rsub.Acq_Deal_Rights_Code, rp.Platform_Code, rsub.Language_Code, 0 As Platform_Cnt InTo #Rights_Platform_Dubbing 
						From #Rights_Title_Dubbing_New rsub
						Inner Join #Rights_Platform rp On rsub.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
						Drop Table #Rights_Title_Dubbing_New

						Update u1 Set u1.Platform_Cnt = u2.cnt From #Rights_Platform_Dubbing u1 
						Inner Join(
							Select Count(*) cnt, a.Language_Code From (
								Select Distinct upd.Language_Code, upd.Platform_Code From #Rights_Platform_Dubbing upd
							) a Group By a.Language_Code
						) u2 On u1.Language_Code = u2.Language_Code
				
						Delete From #Rights_Platform_Dubbing Where Platform_Cnt <> @Platform_Cnt

						--Select * From #Rights_Platform_Dubbing
				
						-------------------- End
						
						--Select Distinct Acq_Deal_Rights_Code, Language_Code InTo #Rights_Platform_Dubbing_New From #Rights_Platform_Dubbing
						--Drop Table #Rights_Platform_Dubbing

						---------------------- Check Dubbing for Country
						
						--Select Distinct rsub.Acq_Deal_Rights_Code, rp.Country_Code, rsub.Language_Code, 0 As Country_Cnt InTo #Rights_Country_Dubbing 
						--From #Rights_Platform_Dubbing_New rsub
						--Inner Join #Rights_Country_Final rp On rsub.Acq_Deal_Rights_Code = rp.Acq_Deal_Rights_Code
				
						--Drop Table #Rights_Platform_Dubbing_New

						--Update u1 Set u1.Country_Cnt = u2.cnt From #Rights_Country_Dubbing u1 
						--Inner Join(
						--	Select Count(*) cnt, a.Language_Code From (
						--		Select Distinct rcd.Language_Code, rcd.Country_Code From #Rights_Country_Dubbing rcd
						--	) a Group By a.Language_Code
						--) u2 On u1.Language_Code = u2.Language_Code
				
						--Delete From #Rights_Country_Dubbing Where Country_Cnt <> @Country_Cnt

						--Select * From #Rights_Country_Dubbing
				
						---------------------- End
						
						--Select Distinct Language_Code InTo #Rights_Dubs From #Rights_Country_Dubbing
						--Drop Table #Rights_Country_Dubbing
						Select Distinct Language_Code InTo #Rights_Dubs From #Rights_Platform_Dubbing
						Drop Table #Rights_Platform_Dubbing

						
						--Select * From #Rights_Dubs

						If(@Dubbing_Type = 'DG')
						Begin

							Select @Dubb_Lang_Code = @Dubb_Lang_Code + ',' + Cast(td1.Language_Group_Code As Varchar(10)) From (
								Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details Where Language_Code In (
									Select Language_Code From #Rights_Dubs
								) Group By Language_Group_Code
							) As td1
							Inner Join (
								Select Language_Group_Code, Count(Language_Code) As LanguageCnt From Language_Group_Details Group By Language_Group_Code
							) As td2 On td1.Language_Group_Code = td2.Language_Group_Code And td1.LanguageCnt = td2.LanguageCnt
						
						End
						Else
						Begin
							Select @Dubb_Lang_Code = @Dubb_Lang_Code + ',' + Cast(Language_Code As Varchar(10)) From #Rights_Dubs
						End

					End
					-------------------- End
					
					Set @Required_Codes = '0'

					If(@Region_Type = 'THT' Or @Region_Type = 'T')
					Begin

						Select @Required_Codes = @Required_Codes + ',' + Cast(td1.Territory_Code As Varchar(10)) From (
						--Select Cast(td1.Territory_Code As Varchar(10)) From (
							Select Territory_Code, Count(Country_Code) As CountryCnt From Territory_Details Where Country_Code In (
								Select Distinct Country_Code From #Rights_Country_Final
							) Group By Territory_Code
						) As td1
						Inner Join (
							Select Territory_Code, Count(Country_Code) As CountryCnt From Territory_Details Group By Territory_Code
						) As td2 On td1.Territory_Code = td2.Territory_Code And td1.CountryCnt = td2.CountryCnt
						
					End
					Else
					Begin
						Select @Required_Codes = @Required_Codes + ',' + Cast(Country_Code As Varchar(10)) From (
							Select Distinct Country_Code From #Rights_Country_Final
						) As con
					End

				End
				
				Drop Table #Rights_Platform
				Drop Table #Rights_Country_Final
				If OBJECT_ID('tempdb..#Rights_Subs') IS NOT NULL
					Drop Table #Rights_Subs
				If OBJECT_ID('tempdb..#Rights_Dubs') IS NOT NULL
				Drop Table #Rights_Dubs

			End
			If OBJECT_ID('tempdb..#AcquiredTitlesNew') IS NOT NULL
				Drop Table #AcquiredTitlesNew

			--Select Distinct ADR.Acq_Deal_Rights_Code, ADR.Title_Code, ADR.Episode_FROM, ADR.Episode_To, ADRP.Platform_Code, 
			--CASE WHEN @Region_Type <> 'T' And @Region_Type <> 'THT' 
			--		THEN  ADRTr.Country_Code
			--		Else CASE WHEN IsNull(ADRTr.Territory_Code,0) = 0 And @Is_Domestic_Territory ='Y' THEN  ADRTr.Country_Code Else ADRTr.Territory_Code  End
			--End As Territory_Code, ADRTr.Territory_Type InTo #Temp_Tit_Right
			--From #AcquiredTitlesNew ADR
			--Inner Join dbo.Acq_Deal_Rights_Platform ADRP WITH (INDEX(IX_Acq_Deal_Rights_Platform_Platform)) ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
			--Inner Join dbo.fn_Split_withdelemiter(@Platform_Codes,',') plat ON plat.number = ADRP.Platform_Code
			--Inner Join Acq_Deal_Rights_Territory ADRTr ON ADR.Acq_Deal_Rights_Code=ADRTr.Acq_Deal_Rights_Code				
			--And (((Territory_Type=@Territory_Type And @Territory_Type = 'G') Or (@Territory_Type = 'I')) Or @Is_Domestic_Territory = 'Y')				
			
			--Declare @InValidComb Char(1) = 'N'
			----If(@Is_Domestic_Territory = 'Y') --Check India is avail Or not
			----Begin
			----	If((Select  Count(T.Territory_Code) From #Temp_Tit_Right T Where t.Territory_Code in(Select Country_Code From Country C Where C.Is_Domestic_Territory = 'Y')) <= 0)
			----	Begin						
			----		Set @InValidComb = 'Y'
			----	End
			----End

			--If(@InValidComb = 'N')
			--Begin

			--	Delete From #Temp_Tit_Right 
			--	Where Platform_Code Not IN 
			--	(
			--		Select Platform_Code
			--		From #Temp_Tit_Right
			--		Group By Platform_Code
			--		Having Count(Distinct Cast(Title_Code As Varchar) + '-' + Cast(Episode_FROM As Varchar) + '-' + Cast(Episode_To As Varchar)) = @Total_Title_Count
			--	)
			
			--	Select 
			--		@PlatformCnt = Count(Distinct Platform_Code) 
			--	From #Temp_Tit_Right
			
			--	Delete From #Temp_Tit_Right 
			--	Where Territory_Code Not IN 
			--	(
			--		Select Territory_Code
			--		From #Temp_Tit_Right
			--		Group By Territory_Code
			--		Having Count(Distinct Cast(Title_Code As Varchar) + '-' + Cast(Episode_FROM As Varchar) + '-' + Cast(Episode_To As Varchar)) = @Total_Title_Count And
			--			   Count(Distinct Platform_Code) = @PlatformCnt
			--	)
			
			--	Select @CountryCnt = Count(Distinct Territory_Code) From #Temp_Tit_Right
			--	Set @Required_Codes = '0'
			--	If(@CountryCnt > 0)
			--	Begin
			--			If(@Region_Type = 'THC' And @Is_Domestic_Territory = 'Y')
			--			Begin
			--				Select @Required_Codes = @Required_Codes + ',' + Cast(C.Country_Code As Varchar(10))
			--				From Country C Where  1 =1
			--				And Is_Theatrical_Territory = 'Y' And IsNull(C.Parent_Country_Code,0) > 0
			--			End
			--			Else If(@Region_Type = 'THT' And @Is_Domestic_Territory = 'Y')
			--			Begin
			--				Select @Required_Codes = @Required_Codes + ',' + Cast(T.Territory_Code As Varchar(10)) 							
			--				From Territory T Where  1 =1 
			--				And Is_Thetrical = 'Y' And Is_Active = 'Y'
			--			End
			--			Else
			--			Begin											
			--				Select 
			--					@Required_Codes = @Required_Codes + +',' + Cast(Territory_Code As Varchar(10)) From 
			--					(
			--						Select Distinct Territory_Code 
			--						From #Temp_Tit_Right T							
			--						Group By Title_Code, Episode_FROM, Episode_To, Territory_Code
			--					) As a
			--			End
			--	End	
				
			--	Set @SubTitle_Lang_Code = '0'
			--	Set @Dubb_Lang_Code = '0'

			--	If(@Required_Codes<>'0')
			--	Begin 				
			--		Select Distinct 
			--			 (Cast(ADR.Title_Code As Varchar) + '-' + Cast(Episode_FROM As Varchar) + '-' + Cast(Episode_To As Varchar)) As Title_Code_With_Episode, 
			--			ADR.Platform_Code, ADR.Territory_Code,
			--			Case When ADRS.Language_Type = 'G' Then lgd.Language_Code Else ADRS.Language_Code End Language_Code
			--			--ADRS.Language_Code
			--		InTo #Temp_SUbTit
			--		From dbo.Acq_Deal_Rights_Subtitling ADRS
			--		Inner Join #Temp_Tit_Right ADR ON ADR.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code
			--		Left Join Language_Group_Details lgd On ADRS.Language_Group_Code = lgd.Language_Group_Code

			--		Select Distinct 
			--			(Cast(ADR.Title_Code As Varchar) + '-' + Cast(Episode_FROM As Varchar) + '-' + Cast(Episode_To As Varchar)) As Title_Code_With_Episode, 
			--			ADR.Platform_Code, ADR.Territory_Code,
			--			Case When ADRD.Language_Type = 'G' Then lgd.Language_Code Else ADRD.Language_Code End Language_Code
			--			--, ADRD.Language_Code
			--		InTo #Temp_Dubbing
			--		From dbo.Acq_Deal_Rights_Dubbing ADRD
			--		Inner Join #Temp_Tit_Right ADR ON ADR.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code
			--		Left Join Language_Group_Details lgd On ADRD.Language_Group_Code = lgd.Language_Group_Code

			--		Select 
			--			@SubTitle_Lang_Code = @SubTitle_Lang_Code + ',' + Cast(Language_Code As Varchar(10))
			--		From #Temp_SUbTit ADR
			--		Group By Language_Code
			--		Having Count(Distinct Title_Code_With_Episode) = @Total_Title_Count And
			--			   Count(Distinct Platform_Code) = @PlatformCnt 							

			--		Select 
			--			@Dubb_Lang_Code = @Dubb_Lang_Code + ',' + Cast(Language_Code As Varchar(10))
			--		From #Temp_Dubbing ADR
			--		Group By Language_Code
			--		Having Count(Distinct Title_Code_With_Episode) = @Total_Title_Count And
			--			   Count(Distinct Platform_Code) = @PlatformCnt 
			--	End
			--End
			--Drop Table #Temp_Tit_Right
			--If OBJECT_ID('tempdb..#Temp_SUbTit') IS NOT NULL
			--	Drop Table #Temp_SUbTit
			--If OBJECT_ID('tempdb..#Temp_Dubbing') IS NOT NULL
			--Drop Table #Temp_Dubbing

		End
	End
	Select @Required_Codes As RequiredCodes,@SubTitle_Lang_Code As SubTitle_Lang_Code,@Dubb_Lang_Code As Dubb_Lang_Code

	IF OBJECT_ID('tempdb..#AcquiredTitles') IS NOT NULL DROP TABLE #AcquiredTitles
	IF OBJECT_ID('tempdb..#AcquiredTitlesNew') IS NOT NULL DROP TABLE #AcquiredTitlesNew
	IF OBJECT_ID('tempdb..#Deal_Rights_Lang') IS NOT NULL DROP TABLE #Deal_Rights_Lang
	IF OBJECT_ID('tempdb..#Rights_Country') IS NOT NULL DROP TABLE #Rights_Country
	IF OBJECT_ID('tempdb..#Rights_Country_Dubbing') IS NOT NULL DROP TABLE #Rights_Country_Dubbing
	IF OBJECT_ID('tempdb..#Rights_Country_Final') IS NOT NULL DROP TABLE #Rights_Country_Final
	IF OBJECT_ID('tempdb..#Rights_Country_New') IS NOT NULL DROP TABLE #Rights_Country_New
	IF OBJECT_ID('tempdb..#Rights_Country_Subtitling') IS NOT NULL DROP TABLE #Rights_Country_Subtitling
	IF OBJECT_ID('tempdb..#Rights_Dubbing') IS NOT NULL DROP TABLE #Rights_Dubbing
	IF OBJECT_ID('tempdb..#Rights_Dubs') IS NOT NULL DROP TABLE #Rights_Dubs
	IF OBJECT_ID('tempdb..#Rights_Platform') IS NOT NULL DROP TABLE #Rights_Platform
	IF OBJECT_ID('tempdb..#Rights_Platform_Country') IS NOT NULL DROP TABLE #Rights_Platform_Country
	IF OBJECT_ID('tempdb..#Rights_Platform_Dubbing') IS NOT NULL DROP TABLE #Rights_Platform_Dubbing
	IF OBJECT_ID('tempdb..#Rights_Platform_Dubbing_New') IS NOT NULL DROP TABLE #Rights_Platform_Dubbing_New
	IF OBJECT_ID('tempdb..#Rights_Platform_Subtitling') IS NOT NULL DROP TABLE #Rights_Platform_Subtitling
	IF OBJECT_ID('tempdb..#Rights_Platform_Subtitling_New') IS NOT NULL DROP TABLE #Rights_Platform_Subtitling_New
	IF OBJECT_ID('tempdb..#Rights_Subs') IS NOT NULL DROP TABLE #Rights_Subs
	IF OBJECT_ID('tempdb..#Rights_Subtitling') IS NOT NULL DROP TABLE #Rights_Subtitling
	IF OBJECT_ID('tempdb..#Rights_Title_Country') IS NOT NULL DROP TABLE #Rights_Title_Country
	IF OBJECT_ID('tempdb..#Rights_Title_Dubbing') IS NOT NULL DROP TABLE #Rights_Title_Dubbing
	IF OBJECT_ID('tempdb..#Rights_Title_Dubbing_New') IS NOT NULL DROP TABLE #Rights_Title_Dubbing_New
	IF OBJECT_ID('tempdb..#Rights_Title_Subtitling') IS NOT NULL DROP TABLE #Rights_Title_Subtitling
	IF OBJECT_ID('tempdb..#Rights_Title_Subtitling_New') IS NOT NULL DROP TABLE #Rights_Title_Subtitling_New
	IF OBJECT_ID('tempdb..#Temp_Dubbing') IS NOT NULL DROP TABLE #Temp_Dubbing
	IF OBJECT_ID('tempdb..#Temp_SUbTit') IS NOT NULL DROP TABLE #Temp_SUbTit
	IF OBJECT_ID('tempdb..#Temp_Tit_Right') IS NOT NULL DROP TABLE #Temp_Tit_Right
End

/*

EXEC USP_GET_DATA_FOR_APPROVED_TITLES '6948','','','','','PL',120

EXEC USP_GET_DATA_FOR_APPROVED_TITLES '6948','103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,12,120,121,122,123,124,125,126,127,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,21,210,211,212,213,214,215,216,217,218,219,22,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258,259,260,261,263,264,265,269,27,270,271,272,273,274,28,29,31,32,33,34,35,36,37,38,39,40,41,42,43,45,46,47,49,55,56,57,58,59,60,61,62,63,67,68,69,73,74,75,76,77,78,79,80,86,87,88,89,9,90,93,96','','','','C',120

*/
GO
PRINT N'Altering [dbo].[USP_RollBack_Acq_Deal]...';


GO
ALTER PROCEDURE [dbo].[USP_RollBack_Acq_Deal]
	@Acq_Deal_Code INT,  
	@User_Code INT ,
	@Is_Edit_WO_Approval CHAR(1)='N'
AS  
-- =============================================  
-- Author:  Khan Faisal  
-- Create date: 10 Oct, 2014  
-- Description: Will restore Acquisition deal to its last approved state  
-- Rollback BVTransaction Pavitar 20141127  
-- Last update by : Akshay Rane
-- Last Change : Added One column in AT_Acq_Deal_Cost_Costtype_Episode (Per_Eps_Amount)
-- =============================================  
BEGIN  
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	
	--DECLARE
	--@Acq_Deal_Code INT = 17611,  
	--@User_Code INT = 143,
	--@Is_Edit_WO_Approval CHAR(1)='N'

	DECLARE @Parameter_Name VARCHAR(500)
	SELECT @Parameter_Name=Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Edit_WO_Approval_Tabs'

	IF(OBJECT_ID('TEMPDB..#Edit_WO_Approval') IS NOT NULL)
		DROP TABLE #Edit_WO_Approval

	IF(OBJECT_ID('TEMPDB..#TitleContentCodes') IS NOT NULL)
		DROP TABLE #TitleContentCodes

	CREATE TABLE #Edit_WO_Approval(Tab_Name VARCHAR(10))

	INSERT INTO #Edit_WO_Approval(Tab_Name)	
	SELECT number FROM dbo.[fn_Split_withdelemiter](@Parameter_Name,',') WHERE number!=''
 
	BEGIN TRY  
	BEGIN TRAN  
		/******************************** Holding identity of AT_Acq_Deal *****************************************/   
		DECLARE @AT_Acq_Deal_Code INT,@Version_Code INT
		SET @AT_Acq_Deal_Code = 0  
    
		SELECT TOP 1 @AT_Acq_Deal_Code = ISNULL(AT_Acq_Deal_Code, 0) FROM AT_Acq_Deal WHERE Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY CAST(Version AS INT) DESC
		  
		IF(@Is_Edit_WO_Approval='N')
		BEGIN
		/******************************** UDdate Acq_Deal *****************************************/   
			UPDATE Acq_Deal  
			SET   
			Acq_Deal.Agreement_No = AtAD.Agreement_No,  Acq_Deal.Version = AtAD.Version,  Acq_Deal.Agreement_Date = AtAD.Agreement_Date,   
			Acq_Deal.Deal_Desc = AtAD.Deal_Desc, Acq_Deal.Deal_Type_Code = AtAD.Deal_Type_Code, Acq_Deal.Year_Type = AtAD.Year_Type,   
			Acq_Deal.Entity_Code = AtAD.Entity_Code, Acq_Deal.Is_Master_Deal = AtAD.Is_Master_Deal, Acq_Deal.Category_Code = AtAD.Category_Code,   
			Acq_Deal.Vendor_Code = AtAD.Vendor_Code, Acq_Deal.Vendor_Contacts_Code = AtAD.Vendor_Contacts_Code, Acq_Deal.Currency_Code = AtAD.Currency_Code,   
			Acq_Deal.Exchange_Rate = AtAD.Exchange_Rate, Acq_Deal.Ref_No = AtAD.Ref_No, Acq_Deal.Attach_Workflow = AtAD.Attach_Workflow,   
			Acq_Deal.Deal_Workflow_Status = AtAD.Deal_Workflow_Status, Acq_Deal.Parent_Deal_Code = AtAD.Parent_Deal_Code, Acq_Deal.Work_Flow_Code = AtAD.Work_Flow_Code,   
			Acq_Deal.Amendment_Date = AtAD.Amendment_Date, Acq_Deal.Is_Released = AtAD.Is_Released, Acq_Deal.Release_On = AtAD.Release_On, Acq_Deal.Release_By = AtAD.Release_By,   
			Acq_Deal.Is_Completed = AtAD.Is_Completed, Acq_Deal.Is_Active = AtAD.Is_Active, Acq_Deal.Content_Type = AtAD.Content_Type, Acq_Deal.Payment_Terms_Conditions = AtAD.Payment_Terms_Conditions,   
			Acq_Deal.Status = AtAD.Status, Acq_Deal.Is_Auto_Generated = AtAD.Is_Auto_Generated, Acq_Deal.Is_Migrated = AtAD.Is_Migrated, Acq_Deal.Cost_Center_Id = AtAD.Cost_Center_Id,   
			Acq_Deal.Master_Deal_Movie_Code_ToLink = AtAD.Master_Deal_Movie_Code_ToLink, Acq_Deal.BudgetWise_Costing_Applicable = AtAD.BudgetWise_Costing_Applicable,   
			Acq_Deal.Validate_CostWith_Budget = AtAD.Validate_CostWith_Budget, Acq_Deal.Deal_Tag_Code = AtAD.Deal_Tag_Code,   
			Acq_Deal.Business_Unit_Code = AtAD.Business_Unit_Code, Acq_Deal.Ref_BMS_Code = AtAD.Ref_BMS_Code,   
			Acq_Deal.Remarks = AtAD.Remarks, Acq_Deal.Rights_Remarks = AtAD.Rights_Remarks, Acq_Deal.Payment_Remarks = AtAD.Payment_Remarks,   
			Acq_Deal.Inserted_By = AtAD.Inserted_By, Acq_Deal.Inserted_On = AtAD.Inserted_On, Acq_Deal.Last_Updated_Time = GETDATE(),   
			Acq_Deal.Last_Action_By = @User_Code, Acq_Deal.Lock_Time = NULL,  
			Acq_Deal.All_Channel = AtAD.All_Channel,ACq_Deal.Role_Code = AtAD.Role_Code,  
			Acq_Deal.Channel_Cluster_Code = AtAd.Channel_Cluster_Code,
			Acq_Deal.Is_Auto_Push =  AtAD.Is_Auto_Push,
			Acq_Deal.Deal_Segment_Code = AtAD.Deal_Segment_Code,
			Acq_Deal.Revenue_Vertical_Code = AtAD.Revenue_Vertical_Code,
			Acq_Deal.Confirming_Party = AtAD.Confirming_Party
			FROM AT_Acq_Deal AtAD   
			WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code AND Acq_Deal.Acq_Deal_Code = @Acq_Deal_Code  
     
			/******************************** Delete from Acq_Deal_Licensor *****************************************/   
			DELETE ADL FROM Acq_Deal_Licensor ADL WHERE ADL.Acq_Deal_Code = @Acq_Deal_Code  
  
			/******************************** Insert/Update Acq_Deal_Licensor *****************************************/   
			INSERT INTO Acq_Deal_Licensor(Acq_Deal_Code, Vendor_Code)  
			SELECT @Acq_Deal_Code, Vendor_Code  
			FROM AT_Acq_Deal_Licensor WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  

			SELECT DISTINCT TCM2.Title_Content_Code, COUNT(DISTINCT TCM2.Acq_Deal_Movie_Code) AS DealMovieCount INTO #TitleContentCodes FROM Acq_Deal_Movie ADM 
			INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code AND ADM.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Title_Content_Mapping TCM2 ON TCM2.Title_Content_Code = TCM.Title_Content_Code
			GROUP BY TCM2.Title_Content_Code
			
			/* Delete from Title_Content_Mapping */  	   
			DELETE TCM FROM Acq_Deal_Movie ADM 
			INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
			WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code  

			/* Delete from Acq_Deal_Movie */  
			DELETE ADM FROM Acq_Deal_Movie ADM WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code  
        
			/******************************** Insert/Update Acq_Deal_Movie *****************************************/   
     
			Set IDENTITY_INSERT Acq_Deal_Movie On  
  
			INSERT INTO Acq_Deal_Movie(  
			Acq_Deal_Movie_Code, Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From,   
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Duration_Restriction)  
			SELECT Acq_Deal_Movie_Code, @Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From,   
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, GETDATE(), @User_Code, Episode_End_To,Duration_Restriction  
			FROM AT_Acq_Deal_Movie WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code And Acq_Deal_Movie_Code Is Not Null  
     
			Set IDENTITY_INSERT Acq_Deal_Movie Off  
  
			INSERT INTO Acq_Deal_Movie(  
			Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From,   
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To)  
			SELECT @Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From,   
			Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, GETDATE(), @User_Code, Episode_End_To  
			FROM AT_Acq_Deal_Movie WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code And Acq_Deal_Movie_Code Is Null  
	

			DECLARE @tblErrorMessage AS TABLE(
				ErrorMessage NVARCHAR(MAX)
			)

			INSERT INTO @tblErrorMessage
			EXEC [dbo].[USP_Generate_Title_Content] @Acq_Deal_Code, '', @User_Code

			DECLARE @errMsg NVARCHAR(MAX) = ''
			SELECT TOP 1 @errMsg = ErrorMessage FROM @tblErrorMessage

			IF(ISNULL(@errMsg, '') <> '')
			BEGIN
				RAISERROR (@errMsg, -- Message text.
					16, -- Severity.
					1 -- State.
				);
			END
			

			DELETE TC FROM #TitleContentCodes TC WHERE DealMovieCount > 1 OR 
			Title_Content_Code IN (
				SELECT TCM.Title_Content_Code FROM Acq_Deal_Movie ADM 
				INNER JOIN Title_Content_Mapping TCM ON TCM.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
				WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code 
			)

			DELETE FROM Content_Status_History WHERE Title_Content_Code IN (SELECT  Title_Content_Code FROM #TitleContentCodes)
			DELETE FROM Title_Content_Version WHERE Title_Content_Code IN (SELECT  Title_Content_Code FROM #TitleContentCodes)
			DELETE FROM Content_Channel_Run WHERE Title_Content_Code IN (SELECT  Title_Content_Code FROM #TitleContentCodes) 
			DELETE FROM Title_Content WHERE Title_Content_Code IN (SELECT  Title_Content_Code FROM #TitleContentCodes)

			/******************************** Delete from Acq_Deal_Rights *****************************************/   
     
			/* Delete from Acq_Deal_Rights_Title_Eps */  
			DELETE ADRHT FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Title_Eps ADRHT ON ADRHT.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code  
  
			/* Delete from Acq_Deal_Rights_Title */  
			DELETE ADRT FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Title ADRT   
			ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Platform */  
			DELETE ADRP FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Platform ADRP  
			ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
      
			/* Delete from Acq_Deal_Rights_Territory */  
			DELETE ADRT FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Territory ADRT  
			ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Subtitling */   
			DELETE ADRS FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Subtitling ADRS  
			ON ADRS.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Dubbing */   
			DELETE ADRD FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Dubbing ADRD  
			ON ADRD.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback_Dubbing */  
			DELETE ADRHD FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Holdback_Dubbing ADRHD ON ADRHD.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback_Platform */  
			DELETE ADRHP FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRHP ON ADRHP.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback_Subtitling */   
			DELETE ADRHS FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Holdback_Subtitling ADRHS ON ADRHS.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback_Territory */  
			DELETE ADRHT FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code  
  
			/* Delete from Acq_Deal_Rights_Holdback */  
			DELETE ADRH FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Holdback ADRH  
			ON ADRH.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Rights_Blackout_Dubbing */  
			DELETE ADRBD FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Blackout_Dubbing ADRBD ON ADRBD.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code  
  
			/* Delete from Acq_Deal_Rights_Blackout_Platform */   
			DELETE ADRBP FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Blackout_Platform ADRBP ON ADRBP.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code  
  
			/* Delete from Acq_Deal_Rights_Blackout_Subtitling */   
			DELETE ADRBS FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Blackout_Subtitling ADRBS ON ADRBS.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code  
  
			/* Delete from Acq_Deal_Rights_Blackout_Territory */   
			DELETE ADRBT FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Blackout_Territory ADRBT ON ADRBT.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code     
  
			/* Delete from Acq_Deal_Rights_Blackout */  
			DELETE ADRB FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Blackout ADRB  
			ON ADRB.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  

			
			/* Delete from Acq_Deal_Rights_Promtoer_Group */   
			DELETE ADRPG FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code     
  

  	/* Delete from Acq_Deal_Rights_Promoter_Remarks */   
			DELETE ADRPR FROM Acq_Deal_Rights ADR   
			INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code  
			   
			   /* Delete from Acq_Deal_Rights_Promoter */  
			   		DELETE ADRP FROM Acq_Deal_Rights ADR INNER JOIN Acq_Deal_Rights_Promoter ADRP 
			ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  

				/******************************** Delete from Syn_Acq_Mapping *****************************************/   
				DELETE SAM FROM Syn_Acq_Mapping SAM WHERE SAM.Deal_Code = @Acq_Deal_Code AND SAM.Deal_Rights_Code IN 
				(SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code = @Acq_Deal_Code)  

			/* Delete from Acq_Deal_Rights */  
			DELETE ADR FROM Acq_Deal_Rights ADR WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code    
  
			print '@Acq_Deal_Code = '+ CAST(@Acq_Deal_Code AS VARCHAR(MAX)) +' @AT_Acq_Deal_Code = '+  CAST(@AT_Acq_Deal_Code AS VARCHAR(MAX))
			/******************************** Insert into Acq_Deal_Rights *****************************************/   
			DECLARE @Acq_Deal_Rights_Code INT  
			SET @Acq_Deal_Rights_Code = 0  
  
			DECLARE @AT_Acq_Deal_Rights_Code INT, @Is_Exclusive CHAR(1), @Is_Title_Language_Right CHAR(1), @Is_Sub_License CHAR(1), @Sub_License_Code INT,
			@Is_Theatrical_Right CHAR(1), @Right_Type CHAR(1), @Original_Right_Type CHAR(1), @Is_Tentative CHAR(1), @Term varchar(12), 
			@Right_Start_Date DATETIME, @Right_End_Date DATETIME, @Milestone_Type_Code INT, @Milestone_No_Of_Unit INT, @Milestone_Unit_Type INT, 
			@Is_ROFR CHAR(1), @ROFR_Date DATETIME, @Restriction_Remarks NVARCHAR(4000), @Effective_Start_Date DATETIME,  
			@Actual_Right_Start_Date DATETIME, @Actual_Right_End_Date DATETIME, @Acq_Deal_Rights_Old_Code INT, @Acq_Deal_Rights_New_Code INT, @ROFR_Code INT,
			@Inserted_By INT, @Inserted_On DATETIME, @Last_Updated_Time DATETIME, @Last_Action_By INT ,@Promoter_Flag CHAR(1)
			  
     
			DECLARE rights_cursor CURSOR FOR   
			SELECT AT_Acq_Deal_Rights_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
			Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, 
			Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
			Inserted_By, Inserted_On, GETDATE(), @User_Code, Acq_Deal_Rights_Code ,ROFR_Code,Promoter_Flag  
			FROM AT_Acq_Deal_Rights WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
     
			OPEN rights_cursor  
  
			FETCH NEXT FROM rights_cursor   
			INTO @AT_Acq_Deal_Rights_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, @Is_Theatrical_Right, 
			@Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, @Milestone_No_Of_Unit, 
			@Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, @Actual_Right_Start_Date, @Actual_Right_End_Date, 
			@Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, @Acq_Deal_Rights_Old_Code, @ROFR_Code,@Promoter_Flag 
     
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				If(IsNull(@Acq_Deal_Rights_Old_Code, 0) = 0)  
				Begin  
					INSERT INTO Acq_Deal_Rights
					(
						Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, 
						Is_Theatrical_Right, Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, 
						Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, 
						Actual_Right_Start_Date, Actual_Right_End_Date, ROFR_Code, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Is_Verified,Promoter_Flag, Right_Status
					)
					VALUES
					(
						@Acq_Deal_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, 
						@Is_Theatrical_Right, @Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, 
						@Milestone_Type_Code, @Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, 
						@Actual_Right_Start_Date, @Actual_Right_End_Date, @ROFR_Code, @Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, 'Y',@Promoter_Flag, 'C'
					)  

					SELECT @Acq_Deal_Rights_Code = IDENT_CURRENT('Acq_Deal_Rights')  
				End  
				Else  
				Begin  
					Set IDENTITY_INSERT [Acq_Deal_Rights] ON  
					INSERT INTO Acq_Deal_Rights
					(
						Acq_Deal_Rights_Code, Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code,   
						Is_Theatrical_Right, Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, 
						Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, 
						Actual_Right_Start_Date, Actual_Right_End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Is_Verified, ROFR_Code
						,Promoter_Flag
					)  
					VALUES
					(
						@Acq_Deal_Rights_Old_Code, @Acq_Deal_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code,   
						@Is_Theatrical_Right, @Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, 
						@Milestone_Type_Code, @Milestone_No_Of_Unit, @Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, 
						@Actual_Right_Start_Date, @Actual_Right_End_Date, @Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, 'Y', @ROFR_Code
						,@Promoter_Flag
					)  

					Set IDENTITY_INSERT [Acq_Deal_Rights] OFF  
					SELECT @Acq_Deal_Rights_Code = @Acq_Deal_Rights_Old_Code  
				End  

				print '@Acq_Deal_Rights_Code = ' +cast( @Acq_Deal_Rights_Code as varchar(max)) + ' @AT_Acq_Deal_Rights_Code = ' +cast( @AT_Acq_Deal_Rights_Code as varchar(max)) + ' @Acq_Deal_Rights_Old_Code = ' +cast( @Acq_Deal_Rights_Old_Code as varchar(max))
				Update AT_Acq_Deal_Rights Set Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code Where AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
				--Commented by akshay
				--Update Syn_Acq_Mapping Set Deal_Rights_Code = @Acq_Deal_Rights_Code Where Deal_Rights_Code = @Acq_Deal_Rights_Old_Code  

  				/******************************** Insert Syn_Acq_Mapping *****************************************/   
				Set IDENTITY_INSERT [Syn_Acq_Mapping] ON  
				PRINT 'IDENTITY_INSERT [Syn_Acq_Mapping] ON  '
				PRINT '@AT_Acq_Deal_Code = ' + CAST(@AT_Acq_Deal_Code AS NVARCHAR(MAX))


				DELETE FROM  
				 Syn_Acq_Mapping  
				WHERE Syn_Acq_Mapping_Code in ( 	
					SELECT  Syn_Acq_Mapping_Code
					FROM AT_Syn_Acq_Mapping  
					WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code 
					AND Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights WHERE  AT_Acq_Deal_Code = @AT_Acq_Deal_Code )
				)


				INSERT INTO Syn_Acq_Mapping( Syn_Acq_Mapping_Code,  Syn_Deal_Code,  Syn_Deal_Movie_Code,  Syn_Deal_Rights_Code,  Deal_Code,  Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date )
				SELECT  Syn_Acq_Mapping_Code,  Syn_Deal_Code,  Syn_Deal_Movie_Code,  Syn_Deal_Rights_Code,  @Acq_Deal_Code,  Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
				FROM AT_Syn_Acq_Mapping  
				WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code 
				AND Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM AT_Acq_Deal_Rights WHERE  AT_Acq_Deal_Code = @AT_Acq_Deal_Code )



				PRINT 'IDENTITY_INSERT [Syn_Acq_Mapping] OFF  '
				Set IDENTITY_INSERT [Syn_Acq_Mapping] OFF
				/**************** Insert into Acq_Deal_Rights_Title ****************/   
  
				INSERT INTO Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)  
				SELECT @Acq_Deal_Rights_Code, AtADRT.Title_Code, AtADRT.Episode_From, AtADRT.Episode_To  
				From AT_Acq_Deal_Rights_Title AtADRT WHERE AtADRT.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Title_Eps ****************/   

				INSERT INTO Acq_Deal_Rights_Title_Eps (Acq_Deal_Rights_Title_Code, EPS_No)  
				SELECT ADRT.Acq_Deal_Rights_Title_Code, AtADRTE.EPS_No  
				FROM AT_Acq_Deal_Rights_Title_EPS AtADRTE  
				INNER JOIN AT_Acq_Deal_Rights_Title AtADRT ON AtADRTE.AT_Acq_Deal_Rights_Title_Code = AtADRT.AT_Acq_Deal_Rights_Title_Code  
				INNER JOIN Acq_Deal_Rights_Title ADRT ON   
				CAST(ISNULL(AtADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRT.Episode_To, '') AS VARCHAR)  
				=  
				CAST(ISNULL(ADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_From, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_To, '') AS VARCHAR)  
				WHERE AtADRT.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Platform ****************/  
  
				INSERT INTO Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code)   
				SELECT @Acq_Deal_Rights_Code, AtADRP.Platform_Code  
				From AT_Acq_Deal_Rights_Platform AtADRP WHERE AtADRP.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
    
				/**************** Insert into Acq_Deal_Rights_Territory ****************/   
  
				INSERT INTO Acq_Deal_Rights_Territory (Acq_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code)   
				SELECT @Acq_Deal_Rights_Code, AtADRT.Territory_Code, AtADRT.Territory_Type, AtADRT.Country_Code  
				From AT_Acq_Deal_Rights_Territory AtADRT WHERE AtADRT.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Subtitling ****************/   
  
				INSERT INTO Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)   
				SELECT @Acq_Deal_Rights_Code, AtADRS.Language_Code, AtADRS.Language_Group_Code, AtADRS.Language_Type  
				From AT_Acq_Deal_Rights_Subtitling AtADRS WHERE AtADRS.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Dubbing ****************/   
     
				INSERT INTO Acq_Deal_Rights_Dubbing (Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type)   
				SELECT @Acq_Deal_Rights_Code, AtADRD.Language_Code, AtADRD.Language_Group_Code, AtADRD.Language_Type  
				From AT_Acq_Deal_Rights_Dubbing AtADRD WHERE AtADRD.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
      
  				/**************** Insert into Acq_Deal_Rights_Holdback ****************/   
  
				INSERT INTO Acq_Deal_Rights_Holdback (Acq_Deal_Rights_Code,   
				Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units,   
				Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right)  
				SELECT @Acq_Deal_Rights_Code,   
				AtADRH.Holdback_Type, AtADRH.HB_Run_After_Release_No, AtADRH.HB_Run_After_Release_Units,   
				AtADRH.Holdback_On_Platform_Code, AtADRH.Holdback_Release_Date, AtADRH.Holdback_Comment, AtADRH.Is_Title_Language_Right  
				FROM AT_Acq_Deal_Rights_Holdback AtADRH WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Holdback_Dubbing ********/   
  
				INSERT INTO Acq_Deal_Rights_Holdback_Dubbing ( Acq_Deal_Rights_Holdback_Code, Language_Code)  
				SELECT ADRH.Acq_Deal_Rights_Holdback_Code, AtADRHD.Language_Code  
				FROM AT_Acq_Deal_Rights_Holdback_Dubbing AtADRHD  
				INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRHD.AT_Acq_Deal_Rights_Holdback_Code = AtADRH.AT_Acq_Deal_Rights_Holdback_Code  
				INNER JOIN Acq_Deal_Rights_Holdback ADRH ON  
				CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')   
				=  
				CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '')   
				WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Holdback_Platform ********/   
  
				INSERT INTO Acq_Deal_Rights_Holdback_Platform (Acq_Deal_Rights_Holdback_Code, Platform_Code)  
				SELECT ADRH.Acq_Deal_Rights_Holdback_Code, AtADRHP.Platform_Code  
				FROM AT_Acq_Deal_Rights_Holdback_Platform AtADRHP  
				INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRHP.AT_Acq_Deal_Rights_Holdback_Code = AtADRH.AT_Acq_Deal_Rights_Holdback_Code  
				INNER JOIN Acq_Deal_Rights_Holdback ADRH ON  
				CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')   
				=  
				CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '')   
				WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Holdback_Subtitling ********/   
  
				INSERT INTO Acq_Deal_Rights_Holdback_Subtitling (Acq_Deal_Rights_Holdback_Code, Language_Code)  
				SELECT ADRH.Acq_Deal_Rights_Holdback_Code, AtADRHS.Language_Code  
				FROM AT_Acq_Deal_Rights_Holdback_Subtitling AtADRHS  
				INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRHS.AT_Acq_Deal_Rights_Holdback_Code = AtADRH.AT_Acq_Deal_Rights_Holdback_Code  
				INNER JOIN Acq_Deal_Rights_Holdback ADRH ON  
				CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')   
				=  
				CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '')   
				WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Holdback_Territory ********/   
       
				INSERT INTO Acq_Deal_Rights_Holdback_Territory (  
				Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code)  
				SELECT  
				ADRH.Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code  
				FROM AT_Acq_Deal_Rights_Holdback_Territory AtADRHT  
				INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRHT.AT_Acq_Deal_Rights_Holdback_Code = AtADRH.AT_Acq_Deal_Rights_Holdback_Code  
				INNER JOIN Acq_Deal_Rights_Holdback ADRH ON   
				CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')   
				=  
				CAST(ISNULL(AtADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(AtADRH.HB_Run_After_Release_Units, '') + '~' +  
				ISNULL(AtADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(AtADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(AtADRH.Holdback_Type, '') + '~' + ISNULL(AtADRH.Is_Title_Language_Right, '')   
				WHERE AtADRH.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRH.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/**************** Insert into Acq_Deal_Rights_Blackout ****************/   
     
				INSERT INTO Acq_Deal_Rights_Blackout (  
				Acq_Deal_Rights_Code, Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Rights_Code, AtADRB.Start_Date, AtADRB.End_Date, AtADRB.Inserted_By, AtADRB.Inserted_On, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Rights_Blackout AtADRB WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Blackout_Dubbing ********/   
  
				INSERT INTO Acq_Deal_Rights_Blackout_Dubbing (Acq_Deal_Rights_Blackout_Code, Language_Code)  
				SELECT ADRB.Acq_Deal_Rights_Blackout_Code, AtADRBD.Language_Code  
				FROM AT_Acq_Deal_Rights_Blackout_Dubbing AtADRBD  
				INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRBD.AT_Acq_Deal_Rights_Blackout_Code = AtADRB.AT_Acq_Deal_Rights_Blackout_Code  
				INNER JOIN Acq_Deal_Rights_Blackout ADRB ON   
				CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  
				WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Blackout_Platform ********/   
  
				INSERT INTO Acq_Deal_Rights_Blackout_Platform (Acq_Deal_Rights_Blackout_Code, Platform_Code)  
				SELECT ADRB.Acq_Deal_Rights_Blackout_Code, AtADRBP.Platform_Code  
				FROM AT_Acq_Deal_Rights_Blackout_Platform AtADRBP  
				INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRBP.AT_Acq_Deal_Rights_Blackout_Code = AtADRB.AT_Acq_Deal_Rights_Blackout_Code  
				INNER JOIN Acq_Deal_Rights_Blackout ADRB ON   
				CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)  
				=  
				CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)   
				WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Blackout_Subtitling ********/  

				INSERT INTO Acq_Deal_Rights_Blackout_Subtitling(Acq_Deal_Rights_Blackout_Code, Language_Code)  
				SELECT ADRB.Acq_Deal_Rights_Blackout_Code, AtADRBS.Language_Code  
				FROM AT_Acq_Deal_Rights_Blackout_Subtitling AtADRBS  
				INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRBS.AT_Acq_Deal_Rights_Blackout_Code = AtADRB.AT_Acq_Deal_Rights_Blackout_Code  
				INNER JOIN Acq_Deal_Rights_Blackout ADRB ON  
				CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)   
				WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  
  
				/******** Insert into Acq_Deal_Rights_Blackout_Territory ********/      

				INSERT INTO Acq_Deal_Rights_Blackout_Territory(Acq_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type)  
				SELECT ADRB.Acq_Deal_Rights_Blackout_Code, AtADRBT.Country_Code, AtADRBT.Territory_Code, AtADRBT.Territory_Type  
				FROM AT_Acq_Deal_Rights_Blackout_Territory AtADRBT  
				INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRBT.AT_Acq_Deal_Rights_Blackout_Code = AtADRB.AT_Acq_Deal_Rights_Blackout_Code  
				INNER JOIN Acq_Deal_Rights_Blackout ADRB ON  
				CAST(ISNULL(ADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(ADRB.Inserted_On, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADRB.Start_Date, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.End_Date, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADRB.Inserted_By, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADRB.Inserted_On, '') AS VARCHAR)  
				WHERE AtADRB.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code And ADRB.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code  


  /**************** Insert into Acq_Deal_Rights_Promoter ****************/   
     
				INSERT INTO Acq_Deal_Rights_Promoter (  
				Acq_Deal_Rights_Code,  Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Rights_Code, AtADRP.Inserted_By, AtADRP.Inserted_On, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Rights_Promoter AtADRP WHERE AtADRP.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code  

					/******** Insert into Acq_Deal_Rights_Promoter_Group ********/   

     
		 INSERT INTO Acq_Deal_Rights_Promoter_Group( Acq_Deal_Rights_Promoter_Code, Promoter_Group_Code)
                      SELECT ADRPNew.Acq_Deal_Rights_Promoter_Code, ADRPG.Promoter_Group_Code
                      FROM (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From AT_Acq_Deal_Rights_Promoter
						Where AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code
					  ) ADRP
                      INNER JOIN AT_Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.AT_Acq_Deal_Rights_Promoter_Code = ADRP.AT_Acq_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From Acq_Deal_Rights_Promoter
						Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId

				/******** Insert into Acq_Deal_Rights_Promoter_Remarks ********/   
  
				 INSERT INTO Acq_Deal_Rights_Promoter_Remarks( Acq_Deal_Rights_Promoter_Code, Promoter_Remarks_Code)
                      SELECT ADRPNew.Acq_Deal_Rights_Promoter_Code, ADRPR.Promoter_Remarks_Code
                      FROM (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From AT_Acq_Deal_Rights_Promoter
						Where AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code
					  ) ADRP
                      INNER JOIN AT_Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.AT_Acq_Deal_Rights_Promoter_Code = ADRP.AT_Acq_Deal_Rights_Promoter_Code
					  INNER JOIN (
						Select Row_Number() over(order by Acq_Deal_Rights_Promoter_Code Asc) RowId, * From Acq_Deal_Rights_Promoter
						Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  ) As ADRPNew On ADRP.RowId = ADRPNew.RowId

				FETCH NEXT FROM rights_cursor   
				INTO @AT_Acq_Deal_Rights_Code, @Is_Exclusive, @Is_Title_Language_Right, @Is_Sub_License, @Sub_License_Code, @Is_Theatrical_Right, 
				@Right_Type, @Original_Right_Type, @Is_Tentative, @Term, @Right_Start_Date, @Right_End_Date, @Milestone_Type_Code, @Milestone_No_Of_Unit, 
				@Milestone_Unit_Type, @Is_ROFR, @ROFR_Date, @Restriction_Remarks, @Effective_Start_Date, @Actual_Right_Start_Date, @Actual_Right_End_Date, 
				@Inserted_By, @Inserted_On, @Last_Updated_Time, @Last_Action_By, @Acq_Deal_Rights_Old_Code, @ROFR_Code,@Promoter_Flag  
		   END  
			CLOSE rights_cursor;  
			DEALLOCATE rights_cursor;  
	
			/******************************** Delete from Acq_Deal_Pushback *****************************************/   
			/* Delete from Acq_Deal_Pushback_Dubbing */  
			DELETE ADPD FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Dubbing ADPD  
			ON ADPD.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback_Platform */  
			DELETE ADPP FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Platform ADPP  
			ON ADPP.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback_Subtitling */  
			DELETE ADPS FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Subtitling ADPS  
			ON ADPS.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback_Territory */  
			DELETE ADPT FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Territory ADPT  
			ON ADPT.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback_Title */  
			DELETE ADPT FROM Acq_Deal_Pushback ADP INNER JOIN Acq_Deal_Pushback_Title ADPT  
			ON ADPT.Acq_Deal_Pushback_Code = ADp.Acq_Deal_Pushback_Code AND ADP.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Pushback */  
			DELETE FROM Acq_Deal_Pushback where Acq_Deal_Code = @Acq_Deal_Code  
  
			--Declare cursor for Pushback  
			Declare @AT_Acq_Deal_Pushback_Code INT, @P_Right_Type CHAR(1), @P_Is_Tentative CHAR(1), @P_Term varchar(12),@P_Right_Start_Date DATETIME,  
			@Acq_Deal_Pushback_Old_Code INT = 0,@P_Right_End_Date DATETIME, @P_Milestone_Type_Code INT, @P_Milestone_No_Of_Unit INT,  
			@P_Milestone_Unit_Type INT, @P_Is_Title_Language_Right CHAR(1),  
			@P_Remarks NVARCHAR(4000), @P_Inserted_By INT, @P_Inserted_On DATETIME, @P_Last_Updated_Time DATETIME, @P_Last_Action_By INT  
  
			DECLARE @Acq_Deal_Pushback_Code INT = 0  
			DECLARE pushback_cursor CURSOR FOR   
			SELECT AT_Acq_Deal_Pushback_Code,Acq_Deal_Pushback_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit,   
			Milestone_Unit_Type, Is_Title_Language_Right, Remarks, Inserted_By, Inserted_On, GETDATE(), @User_Code  
			FROM AT_Acq_Deal_Pushback WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN pushback_cursor  
  
			FETCH NEXT FROM pushback_cursor   
			INTO @AT_Acq_Deal_Pushback_Code,@Acq_Deal_Pushback_Old_Code, @P_Right_Type , @P_Is_Tentative , @P_Term ,@P_Right_Start_Date ,   
			@P_Right_End_Date, @P_Milestone_Type_Code,@P_Milestone_No_Of_Unit,@P_Milestone_Unit_Type, @P_Is_Title_Language_Right,@P_Remarks,  
			@P_Inserted_By,@P_Inserted_On,@P_Last_Updated_Time, @P_Last_Action_By  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Pushback *****************************************/   
				IF(IsNull(@Acq_Deal_Pushback_Old_Code, 0) = 0)  
				BEGIN       
					INSERT INTO Acq_Deal_Pushback(Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit,   
					Milestone_Unit_Type, Is_Title_Language_Right, Remarks, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)
					VALUES(@Acq_Deal_Code, @P_Right_Type, @P_Is_Tentative, @P_Term, @P_Right_Start_Date, @P_Right_End_Date, @P_Milestone_Type_Code, @P_Milestone_No_Of_Unit,   
					@P_Milestone_Unit_Type, @P_Is_Title_Language_Right, @P_Remarks, @P_Inserted_By, @P_Inserted_On, @P_Last_Updated_Time, @P_Last_Action_By)        
					SELECT @Acq_Deal_Pushback_Code = IDENT_CURRENT('Acq_Deal_Pushback')  
					UPDATE AT_Acq_Deal_Pushback SET Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code WHERE AT_Acq_Deal_Pushback_Code  = @AT_Acq_Deal_Pushback_Code   
				END  
				ELSE  
				BEGIN
					SET IDENTITY_INSERT [Acq_Deal_Pushback] ON                  
					INSERT INTO Acq_Deal_Pushback(Acq_Deal_Pushback_Code, Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date,Right_End_Date,  
					Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_Title_Language_Right, Remarks,  
					Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By)  
					VALUES(  
					@Acq_Deal_Pushback_Old_Code,@Acq_Deal_Code, @P_Right_Type, @P_Is_Tentative, @P_Term, @P_Right_Start_Date, @P_Right_End_Date,  
					@P_Milestone_Type_Code, @P_Milestone_No_Of_Unit, @P_Milestone_Unit_Type, @P_Is_Title_Language_Right, @P_Remarks,  
					@P_Inserted_By, @P_Inserted_On, @P_Last_Updated_Time, @P_Last_Action_By)              
					SET IDENTITY_INSERT [Acq_Deal_Pushback] OFF  
					SELECT @Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Old_Code  
				END       
  
				/**************** Insert into Acq_Deal_Pushback_Dubbing ****************/   
  
				INSERT INTO Acq_Deal_Pushback_Dubbing(  
				Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPD.Language_Type, ADPD.Language_Code, ADPD.Language_Group_Code  
				FROM AT_Acq_Deal_Pushback_Dubbing ADPD WHERE ADPD.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				/**************** Insert into Acq_Deal_Pushback_Platform ****************/   
  
				INSERT INTO Acq_Deal_Pushback_Platform(  
				Acq_Deal_Pushback_Code, Platform_Code)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPP.Platform_Code  
				FROM AT_Acq_Deal_Pushback_Platform ADPP WHERE ADPP.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				/**************** Insert into Acq_Deal_Pushback_Subtitling ****************/   
  
				INSERT INTO Acq_Deal_Pushback_Subtitling(  
				Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPS.Language_Type, ADPS.Language_Code, ADPS.Language_Group_Code  
				FROM AT_Acq_Deal_Pushback_Subtitling ADPS WHERE ADPS.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				/**************** Insert into Acq_Deal_Pushback_Territory ****************/   
				INSERT INTO Acq_Deal_Pushback_Territory(  
				Acq_Deal_Pushback_Code, Territory_Type, Country_Code, Territory_Code)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPT.Territory_Type, ADPT.Country_Code, ADPT.Territory_Code  
				FROM AT_Acq_Deal_Pushback_Territory ADPT WHERE ADPT.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				/**************** Insert into Acq_Deal_Pushback_Title ****************/   
  
				INSERT INTO Acq_Deal_Pushback_Title(  
				Acq_Deal_Pushback_Code, Title_Code, Episode_From, Episode_To)  
				SELECT   
				@Acq_Deal_Pushback_Code, ADPT.Title_Code, ADPT.Episode_From, ADPT.Episode_To  
				FROM AT_Acq_Deal_Pushback_Title ADPT WHERE ADPT.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code  
  
				FETCH NEXT FROM pushback_cursor   
				INTO @AT_Acq_Deal_Pushback_Code,@Acq_Deal_Pushback_Old_Code, @P_Right_Type , @P_Is_Tentative , @P_Term ,@P_Right_Start_Date ,  
				@P_Right_End_Date, @P_Milestone_Type_Code, @P_Milestone_No_Of_Unit,@P_Milestone_Unit_Type, @P_Is_Title_Language_Right,@P_Remarks,@P_Inserted_By,@P_Inserted_On,@P_Last_Updated_Time, @P_Last_Action_By  
			END  
			CLOSE pushback_cursor  
			DEALLOCATE pushback_cursor  
    
			/******************************** Delete from Acq_Deal_Ancillary *****************************************/  
			/* Delete from Acq_Deal_Ancillary_Platform_Medium */   
			DELETE ADAPM FROM Acq_Deal_Ancillary ADA   
			INNER JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Ancillary_Platform_Medium ADAPM ON ADAPM.Acq_Deal_Ancillary_Platform_Code = ADAp.Acq_Deal_Ancillary_Platform_Code  
  
			/* Delete from Acq_Deal_Ancillary_Platform */  
			DELETE ADAP FROM Acq_Deal_Ancillary ADA INNER JOIN Acq_Deal_Ancillary_Platform ADAP  
			ON ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Ancillary_Title */  
			DELETE ADAT FROM Acq_Deal_Ancillary ADA INNER JOIN Acq_Deal_Ancillary_Title ADAT  
			ON ADAT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Ancillary */  
			DELETE FROM Acq_Deal_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code  
  
			--Declare cursor form ancillary  
  
			DECLARE @Acq_Deal_Ancillary_Code INT = 0,@Acq_Deal_Ancillary_Old_Code INT = 0  
			DECLARE @AT_Acq_Deal_Ancillary_Code INT,@Ancillary_Type_code INT, @Duration numeric, @Day numeric, @A_Remarks NVARCHAR(4000), @Group_No INT, @Catch_Up_From CHAR(1)  
			DECLARE ancillary_cursor CURSOR  
			FOR SELECT DISTINCT AT_Acq_Deal_Ancillary_Code,Acq_Deal_Ancillary_Code, Ancillary_Type_code, Duration, Day, Remarks, Group_No, Catch_Up_From  
			FROM AT_Acq_Deal_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code      
  
			OPEN ancillary_cursor FETCH NEXT FROM ancillary_cursor  
			INTO @AT_Acq_Deal_Ancillary_Code,@Acq_Deal_Ancillary_Old_Code,@Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No, @Catch_Up_From     
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into AT_Acq_Deal_Ancillary *****************************************/   
				IF(ISNULL(@Acq_Deal_Ancillary_Old_Code, 0) = 0)  
				BEGIN       
					INSERT INTO Acq_Deal_Ancillary(Acq_Deal_Code, Ancillary_Type_code, Duration, [Day], Remarks, Group_No, Catch_Up_From)
					VALUES  (@Acq_Deal_Code, @Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No, @Catch_Up_From)  
					SELECT @Acq_Deal_Ancillary_Code = IDENT_CURRENT('Acq_Deal_Ancillary')  
					UPDATE AT_Acq_Deal_Ancillary SET Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code   
					WHERE AT_Acq_Deal_Ancillary_Code  = @AT_Acq_Deal_Ancillary_Code AND AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Ancillary] ON            
					INSERT INTO Acq_Deal_Ancillary(Acq_Deal_Ancillary_Code,Acq_Deal_Code, Ancillary_Type_code, Duration, [Day], Remarks, Group_No, Catch_Up_From)  
					VALUES(@Acq_Deal_Ancillary_Old_Code,@Acq_Deal_Code, @Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No, @Catch_Up_From)  
					SET IDENTITY_INSERT [Acq_Deal_Ancillary] OFF        
					SELECT @Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Old_Code  
				END       
				/**************** Insert into Acq_Deal_Ancillary_Platform ****************/   
  
				INSERT INTO Acq_Deal_Ancillary_Platform (Acq_Deal_Ancillary_Code, Ancillary_Platform_code, Platform_Code)  
				SELECT @Acq_Deal_Ancillary_Code, AtADAP.Ancillary_Platform_code,  AtADAP.Platform_Code 
				FROM AT_Acq_Deal_Ancillary_Platform AtADAP WHERE AtADAP.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code  
  
				/******** Insert into Acq_Deal_Ancillary_Platform_Medium ********/   
     
				INSERT INTO Acq_Deal_Ancillary_Platform_Medium(Acq_Deal_Ancillary_Platform_Code, Ancillary_Platform_Medium_Code)  
				SELECT ADAP.Acq_Deal_Ancillary_Platform_Code, AtADAPM.Ancillary_Platform_Medium_Code  
				FROM AT_Acq_Deal_Ancillary_Platform_Medium AtADAPM  
				INNER JOIN AT_Acq_Deal_Ancillary_Platform AtADAP ON AtADAPM.AT_Acq_Deal_Ancillary_Platform_Code = AtADAP.AT_Acq_Deal_Ancillary_Platform_Code  
				INNER JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Ancillary_Platform_code = AtADAP.Ancillary_Platform_code  
				WHERE AtADAP.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code  
				AND ADAP.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code
  
				/**************** Insert into Acq_Deal_Ancillary_Title ****************/   
  
				INSERT INTO Acq_Deal_Ancillary_Title (Acq_Deal_Ancillary_Code, Title_Code, Episode_From, Episode_To)  
				SELECT @Acq_Deal_Ancillary_Code, AtADAT.Title_Code, AtADAT.Episode_From, AtADAT.Episode_To  
				FROM AT_Acq_Deal_Ancillary_Title AtADAT WHERE AtADAT.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code  
  
				FETCH NEXT FROM ancillary_cursor  
				INTO @AT_Acq_Deal_Ancillary_Code,@Acq_Deal_Ancillary_Old_Code,@Ancillary_Type_code, @Duration, @Day, @A_Remarks, @Group_No, @Catch_Up_From 
			END  
			CLOSE ancillary_cursor  
			DEALLOCATE ancillary_cursor  
	   END
		IF(@Is_Edit_WO_Approval='N' OR EXISTS(SELECT * FROM #Edit_WO_Approval WHERE Tab_Name='RU'))
		BEGIN
			/******************************** Delete from Acq_Deal_Run *****************************************/   
			/* Delete from Acq_Deal_Run_Channel */  
			DELETE ADRC FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Channel ADRC  
			ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Repeat_On_Day */  
			DELETE ADRRD FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Repeat_On_Day ADRRD  
			ON ADRRD.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Title */   
			DELETE ADRT FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Title ADRT  
			ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Yearwise_Run_Week */   
			DELETE ADRYRW FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Yearwise_Run_Week ADRYRW  
			ON ADRYRW.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Yearwise_Run */   
			DELETE ADRYR FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR  
			ON ADRYR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run_Shows */  
			DELETE ADRS FROM Acq_Deal_Run ADR INNER JOIN Acq_Deal_Run_Shows ADRS  
			ON ADRS.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code   
			  
			--/* Delete from Content_Channel_Run */  
			DELETE CCR FROM Acq_Deal_Run ADR INNER JOIN Content_Channel_Run CCR  
			ON CCR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Run */  
			DELETE FROM Acq_Deal_Run WHERE Acq_Deal_Code = @Acq_Deal_Code  
  
			--Declare run cursor  
			Declare @Acq_Deal_Run_Code INT = 0,@Acq_Deal_Run_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Run_Code INT, @Run_Type CHAR(1), @No_Of_Runs INT, @No_Of_Runs_Sched INT, @No_Of_AsRuns INT, @Is_Yearwise_Definition CHAR(1),  
			@Is_Rule_Right CHAR(1), @Right_Rule_Code INT, @Repeat_Within_Days_Hrs CHAR(1), @No_Of_Days_Hrs INT, @Is_Channel_Definition_Rights CHAR(1),  
			@Primary_Channel_Code INT, @Run_Definition_Type CHAR, @Run_Definition_Group_Code INT, @All_Channel varchar(1), @Prime_Start_Time time,@Prime_End_Time time,  
			@Off_Prime_Start_Time time, @Off_Prime_End_Time time, @Time_Lag_Simulcast time, @Prime_Run INT, @Off_Prime_Run INT, @Prime_Time_Provisional_Run_Count INT,  
			@Prime_Time_AsRun_Count INT,@Prime_Time_Balance_Count INT,@Off_Prime_Time_Provisional_Run_Count INT,@Off_Prime_Time_AsRun_Count INT,  
			@Off_Prime_Time_Balance_Count INT , @Syndication_Runs INT, @Inserted_Run_By INT,@Inserted_Run_On DATETIME,@Last_action_Run_By INT,@Last_updated_Run_Time DATETIME, @channel_Code Varchar(2), @Channel_Category_Code INT

			IF(@Is_Edit_WO_Approval='N')
			BEGIN
				SELECT TOP 1 @Version_Code = ISNULL(Acq_Deal_Tab_Version_Code, 0) FROM Acq_Deal_Tab_Version WHERE Acq_Deal_Code = @Acq_Deal_Code 
				ORDER BY Acq_Deal_Tab_Version_Code DESC
			END
			ELSE
			BEGIN
				SELECT @Version_Code = ISNULL(Acq_Deal_Tab_Version_Code, 0) FROM (SELECT row_number() OVER (ORDER BY Acq_Deal_Tab_Version_Code DESC) r, * FROM Acq_Deal_Tab_Version where Acq_Deal_Code = @Acq_Deal_Code) q
				WHERE r = 2
			END

			DECLARE run_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Run_Code,Acq_Deal_Run_Code, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code,   
			Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights, Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,  
			All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,  
			Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count
			,Off_Prime_Time_Balance_Count ,Syndication_Runs ,Inserted_By ,Inserted_On ,Last_action_By ,Last_updated_Time, Channel_Type, Channel_Category_Code 
			FROM AT_Acq_Deal_Run WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  AND Acq_Deal_Tab_Version_Code=@Version_Code
  
			OPEN run_cursor  
			FETCH NEXT FROM run_cursor  
			INTO @AT_Acq_Deal_Run_Code,@Acq_Deal_Run_Old_Code, @Run_Type, @No_Of_Runs, @No_Of_Runs_Sched, @No_Of_AsRuns, @Is_Yearwise_Definition, @Is_Rule_Right, @Right_Rule_Code,   
			@Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @Is_Channel_Definition_Rights, @Primary_Channel_Code, @Run_Definition_Type, @Run_Definition_Group_Code,  
			@All_Channel, @Prime_Start_Time, @Prime_End_Time, @Off_Prime_Start_Time, @Off_Prime_End_Time, @Time_Lag_Simulcast, @Prime_Run, @Off_Prime_Run,  
			@Prime_Time_Provisional_Run_Count,@Prime_Time_AsRun_Count,@Prime_Time_Balance_Count,@Off_Prime_Time_Provisional_Run_Count,@Off_Prime_Time_AsRun_Count
			,@Off_Prime_Time_Balance_Count, @Syndication_Runs,@Inserted_Run_By,@Inserted_Run_On,@Last_action_Run_By,@Last_updated_Run_Time, @channel_Code, @Channel_Category_Code
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Run *****************************************/   
				IF(IsNull(@Acq_Deal_Run_Old_Code, 0) = 0)  
				BEGIN       
					INSERT INTO Acq_Deal_Run (Acq_Deal_Code, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code,   
					Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights,Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,  
					All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,  
					Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,
					Off_Prime_Time_AsRun_Count,Off_Prime_Time_Balance_Count, Syndication_Runs,Inserted_By ,Inserted_On ,Last_action_By ,Last_updated_Time, Channel_Type, Channel_Category_Code )
					VALUES(@Acq_Deal_Code, @Run_Type, @No_Of_Runs, 0, @No_Of_AsRuns, @Is_Yearwise_Definition, @Is_Rule_Right, @Right_Rule_Code,   
					@Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @Is_Channel_Definition_Rights,@Primary_Channel_Code, @Run_Definition_Type, @Run_Definition_Group_Code,  
					@All_Channel, @Prime_Start_Time, @Prime_End_Time, @Off_Prime_Start_Time, @Off_Prime_End_Time, @Time_Lag_Simulcast, @Prime_Run, @Off_Prime_Run,  
					0,@Prime_Time_AsRun_Count,@Prime_Run,0,
					@Off_Prime_Time_AsRun_Count,@Off_Prime_Run, @Syndication_Runs,@Inserted_Run_By,@Inserted_Run_On,@Last_action_Run_By,@Last_updated_Run_Time, @channel_Code, @Channel_Category_Code)  
					SELECT @Acq_Deal_Run_Old_Code = IDENT_CURRENT('Acq_Deal_Run')  
					UPDATE AT_Acq_Deal_Run SET Acq_Deal_Run_Code = @Acq_Deal_Run_Code WHERE AT_Acq_Deal_Run_Code  = @AT_Acq_Deal_Run_Code AND Acq_Deal_Tab_Version_Code=@Version_Code   
				END  
				ELSE  
				BEGIN       
					SET IDENTITY_INSERT [Acq_Deal_Run] ON            
					INSERT INTO Acq_Deal_Run  
					(  
					Acq_Deal_Run_Code,Acq_Deal_Code, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code,   
					Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights,Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,  
					All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,  
					Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,  
					Off_Prime_Time_AsRun_Count,Off_Prime_Time_Balance_Count, Syndication_Runs, Inserted_By, Inserted_On ,Last_action_By ,Last_updated_Time, Channel_Type, Channel_Category_Code
					)  
					VALUES  
					(  
					@Acq_Deal_Run_Old_Code,@Acq_Deal_Code, @Run_Type, @No_Of_Runs, 0, @No_Of_AsRuns, @Is_Yearwise_Definition, @Is_Rule_Right, @Right_Rule_Code,   
					@Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @Is_Channel_Definition_Rights,@Primary_Channel_Code, @Run_Definition_Type, @Run_Definition_Group_Code,  
					@All_Channel, @Prime_Start_Time, @Prime_End_Time, @Off_Prime_Start_Time, @Off_Prime_End_Time, @Time_Lag_Simulcast, @Prime_Run, @Off_Prime_Run,  
					0,@Prime_Time_AsRun_Count,@Prime_Run,0,@Off_Prime_Time_AsRun_Count,@Off_Prime_Run, @Syndication_Runs 
					,@Inserted_Run_By,@Inserted_Run_On,@Last_action_Run_By,@Last_updated_Run_Time, @channel_Code, @Channel_Category_Code
					)  
					SET IDENTITY_INSERT [Acq_Deal_Run] OFF       
					SELECT @Acq_Deal_Run_Code = @Acq_Deal_Run_Old_Code  
				END     
				/**************** Insert into Acq_Deal_Run_Channel ****************/   
  
				INSERT INTO Acq_Deal_Run_Channel (  
				Acq_Deal_Run_Code, Channel_Code, Min_Runs, Max_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Do_Not_Consume_Rights,   
				Is_Primary, Inserted_By, Inserted_On, Last_action_By, Last_updated_Time)  
				SELECT  
				@Acq_Deal_Run_Code, AtADRC.Channel_Code, AtADRC.Min_Runs, AtADRC.Max_Runs, 0, AtADRC.No_Of_AsRuns, AtADRC.Do_Not_Consume_Rights,   
				AtADRC.Is_Primary, AtADRC.Inserted_By, AtADRC.Inserted_On, @User_Code, GETDATE()  
				FROM AT_Acq_Deal_Run_Channel AtADRC WHERE AtADRC.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
				/**************** Insert into Acq_Deal_Run_Repeat_On_Day ****************/   
     
				INSERT INTO Acq_Deal_Run_Repeat_On_Day (Acq_Deal_Run_Code, Day_Code)  
				SELECT @Acq_Deal_Run_Code, AtADRRD.Day_Code  
				FROM AT_Acq_Deal_Run_Repeat_On_Day AtADRRD WHERE AtADRRD.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
				/**************** Insert into Acq_Deal_Run_Shows ****************/   
				INSERT INTO Acq_Deal_Run_Shows(Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,Acq_Deal_Movie_Code,Inserted_By,Inserted_On)  
				SELECT DISTINCT  @Acq_Deal_Run_Code,AtADRS.Data_For,AtADRS.Title_Code,AtADRS.Episode_From,AtADRS.Episode_To,ADM.Acq_Deal_Movie_Code,AtADRS.Inserted_By,AtADRS.Inserted_On  
				FROM AT_Acq_Deal_Run_Shows AtADRS   
				INNER JOIN Acq_Deal_Movie ADM ON  
				(AtADRS.Title_Code = ADM.Title_Code OR ISNULL(AtADRS.Title_Code,0) = 0)   
				AND (AtADRS.Episode_From = ADM.Episode_Starts_From OR ISNULL(AtADRS.Episode_From,0) = 0)   
				AND (AtADRS.Episode_To = ADM.Episode_End_To OR ISNULL(AtADRS.Episode_To,0) = 0)  
				WHERE AtADRS.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code   
				-- AND ADM.Acq_Deal_Code = @Acq_Deal_Code  
   
				/**************** Insert into Acq_Deal_Run_Title ****************/   
  
				INSERT INTO Acq_Deal_Run_Title (Acq_Deal_Run_Code, Title_Code, Episode_From, Episode_To)  
				SELECT @Acq_Deal_Run_Code, AtADRT.Title_Code, AtADRT.Episode_From, AtADRT.Episode_To  
				FROM AT_Acq_Deal_Run_Title AtADRT        
				WHERE AtADRT.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
				/**************** Insert into Acq_Deal_Run_Yearwise_Run ****************/   
  
				INSERT INTO Acq_Deal_Run_Yearwise_Run (   
				Acq_Deal_Run_Code, Start_Date, End_Date, No_Of_Runs, No_Of_Runs_Sched,   
				No_Of_AsRuns, Inserted_By, Inserted_On, Last_action_By, Last_updated_Time,Year_No)  
				SELECT   
				@Acq_Deal_Run_Code, AtADRYR.Start_Date, AtADRYR.End_Date, AtADRYR.No_Of_Runs, 0,   
				AtADRYR.No_Of_AsRuns, AtADRYR.Inserted_By, AtADRYR.Inserted_On, @User_Code, GETDATE(), AtADRYR.Year_No  
				FROM AT_Acq_Deal_Run_Yearwise_Run AtADRYR WHERE AtADRYR.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
				/******** Insert into Acq_Deal_Run_Yearwise_Run_Week ********/   
				INSERT INTO Acq_Deal_Run_Yearwise_Run_Week (   
				Acq_Deal_Run_Yearwise_Run_Code, Acq_Deal_Run_Code, Start_Week_Date, End_Week_Date, Is_Preferred,   
				Inserted_By, Inserted_On, Last_action_By, Last_updated_Time)  
				SELECT   
				ADRYR.Acq_Deal_Run_Yearwise_Run_Code, @Acq_Deal_Run_Code,   
				AtADRYRW.Start_Week_Date, AtADRYRW.End_Week_Date, AtADRYRW.Is_Preferred,   
				AtADRYRW.Inserted_By, AtADRYRW.Inserted_On, @User_Code, GETDATE()  
				FROM AT_Acq_Deal_Run_Yearwise_Run AtADRYR INNER JOIN AT_Acq_Deal_Run_Yearwise_Run_Week AtADRYRW ON AtADRYRW.AT_Acq_Deal_Run_Yearwise_Run_Code = AtADRYR.AT_Acq_Deal_Run_Yearwise_Run_Code  
				INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR ON  
				CAST(ISNULL(ADRYR.Start_Date, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRYR.End_Date, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(ADRYR.No_Of_Runs, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRYR.No_Of_Runs_Sched, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(ADRYR.No_Of_AsRuns, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRYR.Inserted_By, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(ADRYR.Inserted_On, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADRYR.Start_Date, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRYR.End_Date, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(AtADRYR.No_Of_Runs, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRYR.No_Of_Runs_Sched, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(AtADRYR.No_Of_AsRuns, '') AS VARCHAR) + '~' +  CAST(ISNULL(AtADRYR.Inserted_By, '') AS VARCHAR) + '~' +   
				CAST(ISNULL(AtADRYR.Inserted_On, '') AS VARCHAR)  
				WHERE AtADRYR.AT_Acq_Deal_Run_Code = @AT_Acq_Deal_Run_Code  
  
			FETCH NEXT FROM run_cursor  
			INTO @AT_Acq_Deal_Run_Code,@Acq_Deal_Run_Old_Code, @Run_Type, @No_Of_Runs, @No_Of_Runs_Sched, @No_Of_AsRuns, @Is_Yearwise_Definition, @Is_Rule_Right, @Right_Rule_Code,   
			@Repeat_Within_Days_Hrs, @No_Of_Days_Hrs, @Is_Channel_Definition_Rights, @Primary_Channel_Code, @Run_Definition_Type, @Run_Definition_Group_Code,  
			@All_Channel, @Prime_Start_Time, @Prime_End_Time, @Off_Prime_Start_Time, @Off_Prime_End_Time, @Time_Lag_Simulcast, @Prime_Run, @Off_Prime_Run,  
			@Prime_Time_Provisional_Run_Count,@Prime_Time_AsRun_Count,@Prime_Time_Balance_Count,@Off_Prime_Time_Provisional_Run_Count,@Off_Prime_Time_AsRun_Count
			,@Off_Prime_Time_Balance_Count, @Syndication_Runs,@Inserted_Run_By,@Inserted_Run_On,@Last_action_Run_By,@Last_updated_Run_Time, @channel_Code, @Channel_Category_Code
			END  
			CLOSE run_cursor  
			DEALLOCATE run_cursor  
		END
		IF(@Is_Edit_WO_Approval='N' OR EXISTS(SELECT * FROM #Edit_WO_Approval WHERE Tab_Name='CO'))
		BEGIN
			/******************************** Delete from Acq_Deal_Cost *****************************************/   
			/* Delete from Acq_Deal_Cost_Additional_Exp */  
			DELETE ADCAE FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Additional_Exp ADCAE  
			ON ADCAE.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Cost_Commission */  
			DELETE ADCC FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Commission ADCC  
			ON ADCC.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code   
  
			/* Delete from Acq_Deal_Cost_Costtype_Episode */  
			DELETE ADCCTE FROM Acq_Deal_Cost ADC   
			INNER JOIN Acq_Deal_Cost_Costtype ADCCT ON ADCCT.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
			INNER JOIN Acq_Deal_Cost_Costtype_Episode ADCCTE ON ADCCTE.Acq_Deal_Cost_Costtype_Code = ADCCT.Acq_Deal_Cost_Costtype_Code  
  
			/* Delete from Acq_Deal_Cost_Costtype */  
			DELETE ADCCT FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Costtype ADCCT  
			ON ADCCT.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Cost_Title */  
			DELETE ADCT FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Title ADCT  
			ON ADCT.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Cost_Variable_Cost */  
			DELETE ADCVC FROM Acq_Deal_Cost ADC INNER JOIN Acq_Deal_Cost_Variable_Cost ADCVC  
			ON ADCVC.Acq_Deal_Cost_Code = ADc.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Cost */  
			DELETE FROM Acq_Deal_Cost WHERE Acq_Deal_Code = @Acq_Deal_Code  
     
			--Declare cost cursor  
			Declare @Acq_Deal_Cost_Code INT = 0,@Acq_Deal_Cost_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Cost_Code INT, @Currency_Code INT, @Currency_Exchange_Rate decimal, @Deal_Cost decimal, @Deal_Cost_Per_Episode decimal,  
			@Cost_Center_Id INT,@Additional_Cost decimal, @Catchup_Cost decimal, @Variable_Cost_Type CHAR,@Variable_Cost_Sharing_Type CHAR, @Royalty_Recoupment_Code INT, @C_Inserted_On DATETIME,@C_Inserted_By INT,  
			@C_Last_Updated_Time DATETIME, @C_Last_Action_By INT,@Incentive CHAR,@C_Remarks NVARCHAR(4000)  
  
			
			DECLARE cost_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Cost_Code,Acq_Deal_Cost_Code, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, Catchup_Cost,   
			Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By, Last_Updated_Time,Last_Action_By,Incentive,Remarks  
			FROM AT_Acq_Deal_Cost WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code AND Acq_Deal_Tab_Version_Code=@Version_Code
  
			OPEN cost_cursor  
			FETCH NEXT FROM cost_cursor  
			INTO @AT_Acq_Deal_Cost_Code,@Acq_Deal_Cost_Old_Code, @Currency_Code, @Currency_Exchange_Rate, @Deal_Cost, @Deal_Cost_Per_Episode, @Cost_Center_Id,  
			@Additional_Cost, @Catchup_Cost, @Variable_Cost_Type, @Variable_Cost_Sharing_Type, @Royalty_Recoupment_Code, @C_Inserted_On,@C_Inserted_By,  
			@C_Last_Updated_Time, @C_Last_Action_By,@Incentive,@C_Remarks  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Cost *****************************************/   
				IF(IsNull(@Acq_Deal_Cost_Old_Code, 0) = 0)  
				BEGIN              
					INSERT INTO Acq_Deal_Cost(Acq_Deal_Code,Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id,  
					Additional_Cost, Catchup_Cost, Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By,  
					Last_Updated_Time, Last_Action_By, Incentive, Remarks)
					VALUES(@Acq_Deal_Code,@Currency_Code, @Currency_Exchange_Rate, @Deal_Cost, @Deal_Cost_Per_Episode, @Cost_Center_Id,  
					@Additional_Cost, @Catchup_Cost, @Variable_Cost_Type, @Variable_Cost_Sharing_Type, @Royalty_Recoupment_Code, @C_Inserted_On,@C_Inserted_By,  
					@C_Last_Updated_Time, @C_Last_Action_By,@Incentive,@C_Remarks)  
					SELECT @Acq_Deal_Cost_Code = IDENT_CURRENT('Acq_Deal_Cost')  
					UPDATE AT_Acq_Deal_Cost SET Acq_Deal_Cost_Code = @Acq_Deal_Cost_Code WHERE AT_Acq_Deal_Cost_Code  = @AT_Acq_Deal_Cost_Code  AND Acq_Deal_Tab_Version_Code=@Version_Code     
				END  
				ELSE  
					BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Cost] ON        
					INSERT INTO Acq_Deal_Cost (  
					Acq_Deal_Cost_Code ,Acq_Deal_Code,Currency_Code,Currency_Exchange_Rate, Deal_Cost,Deal_Cost_Per_Episode,Cost_Center_Id,  
					Additional_Cost, Catchup_Cost,Variable_Cost_Type,Variable_Cost_Sharing_Type,Royalty_Recoupment_Code,Inserted_On,Inserted_By,  
					Last_Updated_Time,Last_Action_By,Incentive,Remarks  
					)  
					VALUES  
					(  
					@Acq_Deal_Cost_Old_Code,@Acq_Deal_Code,@Currency_Code, @Currency_Exchange_Rate, @Deal_Cost, @Deal_Cost_Per_Episode, @Cost_Center_Id,  
					@Additional_Cost, @Catchup_Cost, @Variable_Cost_Type, @Variable_Cost_Sharing_Type, @Royalty_Recoupment_Code, @C_Inserted_On,@C_Inserted_By,  
					@C_Last_Updated_Time, @C_Last_Action_By,@Incentive,@C_Remarks  
					)  
					SET IDENTITY_INSERT [Acq_Deal_Cost] OFF       
					SELECT @Acq_Deal_Cost_Code = @Acq_Deal_Cost_Old_Code  
				END  
         
				/**************** Insert into Acq_Deal_Cost_Additional_Exp ****************/  
     
				INSERT INTO Acq_Deal_Cost_Additional_Exp (  
				Acq_Deal_Cost_Code, Additional_Expense_Code, Amount, Min_Max, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Cost_Code, AtADCAE.Additional_Expense_Code, AtADCAE.Amount, AtADCAE.Min_Max,   
				AtADCAE.Inserted_On, AtADCAE.Inserted_By, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Cost_Additional_Exp AtADCAE WHERE AtADCAE.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/**************** Insert into Acq_Deal_Cost_Commission ****************/   
  
				INSERT INTO Acq_Deal_Cost_Commission (  
				Acq_Deal_Cost_Code, Cost_Type_Code, Royalty_Commission_Code, Entity_Code, Vendor_Code, Type, Commission_Type, Percentage, Amount)  
				SELECT   
				@Acq_Deal_Cost_Code, AtADCC.Cost_Type_Code, AtADCC.Royalty_Commission_Code, AtADCC.Entity_Code,  
				AtADCC.Vendor_Code, AtADCC.Type, AtADCC.Commission_Type, AtADCC.Percentage, AtADCC.Amount  
				FROM AT_Acq_Deal_Cost_Commission AtADCC WHERE AtADCC.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/**************** Insert into Acq_Deal_Cost_Title ****************/   
  
				INSERT INTO Acq_Deal_Cost_Title (Acq_Deal_Cost_Code, Title_Code, Episode_From, Episode_To)  
				SELECT @Acq_Deal_Cost_Code, AtADCT.Title_Code, AtADCT.Episode_From, AtADCT.Episode_To  
				FROM AT_Acq_Deal_Cost_Title AtADCT WHERE AtADCT.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/**************** Insert into Acq_Deal_Cost_Variable_Cost ****************/  
     
				INSERT INTO Acq_Deal_Cost_Variable_Cost (  
				Acq_Deal_Cost_Code, Entity_Code, Vendor_Code, Percentage, Amount,   
				Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Cost_Code, AtADCVC.Entity_Code, AtADCVC.Vendor_Code, AtADCVC.Percentage, AtADCVC.Amount,   
				AtADCVC.Inserted_On, AtADCVC.Inserted_By, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Cost_Variable_Cost AtADCVC WHERE AtADCVC.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/**************** Insert into Acq_Deal_Cost_Costtype ****************/   
  
				INSERT INTO Acq_Deal_Cost_Costtype (  
				Acq_Deal_Cost_Code, Cost_Type_Code, Amount, Consumed_Amount, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)  
				SELECT   
				@Acq_Deal_Cost_Code,   
				AtADCC.Cost_Type_Code, AtADCC.Amount, AtADCC.Consumed_Amount, AtADCC.Inserted_On, AtADCC.Inserted_By, GETDATE(), @User_Code  
				FROM AT_Acq_Deal_Cost_Costtype AtADCC WHERE AtADCC.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
  
				/******** Insert into Acq_Deal_Cost_Costtype_Episode ********/   
  
				INSERT INTO Acq_Deal_Cost_Costtype_Episode (  
				Acq_Deal_Cost_Costtype_Code, Episode_From, Episode_To, Amount_Type, Amount, Percentage, Remarks,Per_Eps_Amount)  
				SELECT   
				ADCC.Acq_Deal_Cost_Costtype_Code,  
				AtADCCE.Episode_From, AtADCCE.Episode_To, AtADCCE.Amount_Type, AtADCCE.Amount, AtADCCE.Percentage, AtADCCE.Remarks ,AtADCCE.Per_Eps_Amount 
				FROM AT_Acq_Deal_Cost_Costtype_Episode AtADCCE INNER JOIN AT_Acq_Deal_Cost_Costtype AtADCC ON AtADCCE.AT_Acq_Deal_Cost_Costtype_Code = AtADCC.AT_Acq_Deal_Cost_Costtype_Code  
				AND AtADCC.AT_Acq_Deal_Cost_Code = @AT_Acq_Deal_Cost_Code  
				INNER JOIN Acq_Deal_Cost_Costtype ADCC ON ADCC.Acq_Deal_Cost_Code = @Acq_Deal_Cost_Code AND  
				CAST(ISNULL(ADCC.Cost_Type_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(ADCC.Amount, 0) AS VARCHAR) + '~' +  
				CAST(ISNULL(ADCC.Consumed_Amount, 0) AS VARCHAR) + '~' + CAST(ISNULL(ADCC.Inserted_On, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(ADCC.Inserted_By, '') AS VARCHAR)   
				=  
				CAST(ISNULL(AtADCC.Cost_Type_Code, '') AS VARCHAR) + '~' + CAST(ISNULL(AtADCC.Amount, 0) AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADCC.Consumed_Amount, 0) AS VARCHAR) + '~' + CAST(ISNULL(AtADCC.Inserted_On, '') AS VARCHAR) + '~' +  
				CAST(ISNULL(AtADCC.Inserted_By, '') AS VARCHAR)  
  
				FETCH NEXT FROM cost_cursor  
				INTO @AT_Acq_Deal_Cost_Code,@Acq_Deal_Cost_Old_Code, @Currency_Code, @Currency_Exchange_Rate, @Deal_Cost, @Deal_Cost_Per_Episode, @Cost_Center_Id,  
				@Additional_Cost, @Catchup_Cost, @Variable_Cost_Type, @Variable_Cost_Sharing_Type, @Royalty_Recoupment_Code, @C_Inserted_On,@C_Inserted_By,  
				@C_Last_Updated_Time, @C_Last_Action_By,@Incentive,@C_Remarks  
			END  
			CLOSE cost_cursor  
			DEALLOCATE cost_cursor
	   END
		IF(@Is_Edit_WO_Approval='N')
		BEGIN
			/******************************** Delete from Acq_Deal_Sport *****************************************/   
			/* Delete from Acq_Deal_Sport_Broadcast */  
			DELETE ADSB FROM Acq_Deal_Sport ADS INNER JOIN Acq_Deal_Sport_Broadcast ADSB  
			ON ADSB.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code AND ADS.Acq_Deal_Code = @Acq_Deal_Code  
			/* Delete from Acq_Deal_Sport_Platform */  
			DELETE ADSP FROM Acq_Deal_Sport ADS INNER JOIN Acq_Deal_Sport_Platform ADSP  
			ON ADSP.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code AND ADS.Acq_Deal_Code = @Acq_Deal_Code  
			/* Delete from Acq_Deal_Sport_Title */  
			DELETE ADST FROM Acq_Deal_Sport ADS INNER JOIN Acq_Deal_Sport_Title ADST  
			ON ADST.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code AND ADS.Acq_Deal_Code = @Acq_Deal_Code  
			/* Delete from Acq_Deal_Sport_Language*/  
			DELETE ADSL FROM Acq_Deal_Sport ADS INNER JOIN Acq_Deal_Sport_Language ADSL  
			ON ADSL.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code AND ADS.Acq_Deal_Code = @Acq_Deal_Code  
			/* Delete from Acq_Deal_Sport */  
			DELETE FROM Acq_Deal_Sport WHERE Acq_Deal_Code = @Acq_Deal_Code  
			--Declare sport cursor  
			Declare @Acq_Deal_Sport_Code INT = 0,@Acq_Deal_Sport_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Sport_Code INT, @Content_Delivery varchar, @Obligation_Broadcast varchar, @Deferred_Live varchar, @Deferred_Live_Duration varchar,  
			@Tape_Delayed varchar, @Tape_Delayed_Duration varchar, @Standalone_Transmission varchar,@Standalone_Substantial varchar, @Simulcast_Transmission varchar,  
			@Simulcast_Substantial varchar, @File_Name varchar, @Sys_File_Name varchar,@Remarks NVARCHAR(4000), @S_Inserted_On DATETIME, @S_Inserted_By INT,   
			@S_Last_Updated_Time DATETIME,@S_Last_Action_By INT,@MBO_Note NVARCHAR(4000)
  
			DECLARE sport_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Sport_Code,Acq_Deal_Sport_Code , Content_Delivery, Obligation_Broadcast, Deferred_Live, Deferred_Live_Duration,Tape_Delayed, Tape_Delayed_Duration,  
			Standalone_Transmission,Standalone_Substantial, Simulcast_Transmission, Simulcast_Substantial,[File_Name],Sys_File_Name,Remarks, Inserted_On, Inserted_By, Last_Updated_Time,Last_Action_By,MBO_Note  
			FROM AT_Acq_Deal_Sport WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN sport_cursor  
			FETCH NEXT FROM sport_cursor  
			INTO @AT_Acq_Deal_Sport_Code,@Acq_Deal_Sport_Old_Code  , @Content_Delivery, @Obligation_Broadcast, @Deferred_Live , @Deferred_Live_Duration,@Tape_Delayed, @Tape_Delayed_Duration,  
			@Standalone_Transmission ,@Standalone_Substantial, @Simulcast_Transmission,@Simulcast_Substantial , @File_Name, @Sys_File_Name,@Remarks, @S_Inserted_On,  
			@S_Inserted_By,@S_Last_Updated_Time,@S_Last_Action_By,@MBO_Note  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Cost *****************************************/   
				IF(IsNull(@Acq_Deal_Sport_Old_Code, 0) = 0)  
				BEGIN                 
					INSERT INTO Acq_Deal_Sport (Acq_Deal_Code,Content_Delivery, Obligation_Broadcast, Deferred_Live, Deferred_Live_Duration, Tape_Delayed,
					Tape_Delayed_Duration, Standalone_Transmission, Standalone_Substantial, Simulcast_Transmission, Simulcast_Substantial, [File_Name], Sys_File_Name,
					Remarks, Inserted_By, Inserted_On,Last_Updated_Time,Last_Action_By, MBO_Note)
					VALUES(@Acq_Deal_Code,@Content_Delivery, @Obligation_Broadcast, @Deferred_Live , @Deferred_Live_Duration,@Tape_Delayed, 
					@Tape_Delayed_Duration,  @Standalone_Transmission ,@Standalone_Substantial, @Simulcast_Transmission,@Simulcast_Substantial , @File_Name, @Sys_File_Name,
					@Remarks, @S_Inserted_By,  @S_Inserted_On,@S_Last_Updated_Time,@S_Last_Action_By,@MBO_Note)
					SELECT @Acq_Deal_Sport_Code = IDENT_CURRENT('Acq_Deal_Sport')  
  
					UPDATE AT_Acq_Deal_Sport SET Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code WHERE AT_Acq_Deal_Sport_Code  = @AT_Acq_Deal_Sport_Code   
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Sport] ON         
					INSERT INTO Acq_Deal_Sport   
					(  
					Acq_Deal_Sport_Code,Acq_Deal_Code,Content_Delivery, Obligation_Broadcast, Deferred_Live , Deferred_Live_Duration,Tape_Delayed,   
					Tape_Delayed_Duration,Standalone_Transmission ,Standalone_Substantial, Simulcast_Transmission,  
					Simulcast_Substantial , [File_Name], Sys_File_Name,Remarks,Inserted_By,  
					Inserted_On,Last_Updated_Time,Last_Action_By,MBO_Note  
					)  
					VALUES(  
					@Acq_Deal_Sport_Old_Code,@Acq_Deal_Code,@Content_Delivery, @Obligation_Broadcast, @Deferred_Live , @Deferred_Live_Duration,@Tape_Delayed, @Tape_Delayed_Duration,  
					@Standalone_Transmission ,@Standalone_Substantial, @Simulcast_Transmission,@Simulcast_Substantial , @File_Name, @Sys_File_Name,@Remarks, @S_Inserted_By,  
					@S_Inserted_On,@S_Last_Updated_Time,@S_Last_Action_By,@MBO_Note)  
					SET IDENTITY_INSERT [Acq_Deal_Sport] OFF  
					SELECT @Acq_Deal_Sport_Code = @Acq_Deal_Sport_Old_Code  
				END  
				/**************** Insert into Acq_Deal_Sport_Broadcast ****************/   
  
				INSERT INTO Acq_Deal_Sport_Broadcast(  
				Acq_Deal_Sport_Code,Broadcast_Mode_Code,[Type])  
				SELECT   
				@Acq_Deal_Sport_Code,ADSB.Broadcast_Mode_Code,ADSB.[Type]  
				FROM AT_Acq_Deal_Sport_Broadcast ADSB WHERE ADSB.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code  
  
				/**************** Insert into Acq_Deal_Sport_Platform ****************/   
  
				INSERT INTO Acq_Deal_Sport_Platform(  
				Acq_Deal_Sport_Code,Platform_Code,[Type])  
				SELECT   
				@Acq_Deal_Sport_Code,ADSP.Platform_Code,ADSP.[Type]  
				FROM AT_Acq_Deal_Sport_Platform ADSP WHERE ADSP.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code  
  
				/**************** Insert into Acq_Deal_Sport_Title ****************/   
  
				INSERT INTO Acq_Deal_Sport_Title(  
				Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To)  
				SELECT   
				@Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To  
				FROM AT_Acq_Deal_Sport_Title ADST WHERE ADST.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code  
  
				/**************** Insert into Acq_Deal_Sport_Language ****************/   
  
				INSERT INTO Acq_Deal_Sport_Language(  
				Acq_Deal_Sport_Code,Language_Type,Language_Code,Language_Group_Code,Flag)  
				SELECT   
				@Acq_Deal_Sport_Code,Language_Type,Language_Code,Language_Group_Code,Flag  
				FROM AT_Acq_Deal_Sport_Language ADST WHERE ADST.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code  
  
				FETCH NEXT FROM sport_cursor  
				INTO @AT_Acq_Deal_Sport_Code,@Acq_Deal_Sport_Old_Code , @Content_Delivery, @Obligation_Broadcast, @Deferred_Live , @Deferred_Live_Duration,@Tape_Delayed, @Tape_Delayed_Duration,  
				@Standalone_Transmission ,@Standalone_Substantial, @Simulcast_Transmission,@Simulcast_Substantial , @File_Name, @Sys_File_Name,@Remarks, @S_Inserted_On,  
				@S_Inserted_By,@S_Last_Updated_Time,@S_Last_Action_By,@MBO_Note  
			END  
			CLOSE sport_cursor  
			DEALLOCATE sport_cursor  
			/******************************** Delete from Acq_Deal_Sport_Ancillary *****************************************/        
			/* Delete from Acq_Deal_Sport_Ancillary_Broadcast */  
			DELETE ADSAB FROM Acq_Deal_Sport_Ancillary ADSA INNER JOIN Acq_Deal_Sport_Ancillary_Broadcast ADSAB  
			ON ADSAB.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code AND ADSA.Acq_Deal_Code = @Acq_Deal_Code    

			/* Delete from Acq_Deal_Sport_Ancillary_Source */  
			DELETE ADSAS FROM Acq_Deal_Sport_Ancillary ADSA INNER JOIN Acq_Deal_Sport_Ancillary_Source ADSAS  
			ON ADSAS.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code AND ADSA.Acq_Deal_Code = @Acq_Deal_Code    

			/* Delete from Acq_Deal_Sport_Ancillary_Title */  
			DELETE ADSAT FROM Acq_Deal_Sport_Ancillary ADSA INNER JOIN Acq_Deal_Sport_Ancillary_Title ADSAT  
			ON ADSAT.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code AND ADSA.Acq_Deal_Code = @Acq_Deal_Code    

			/* Delete from Acq_Deal_Sport_Ancillary */  
			DELETE FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code         

			--Declare sport ancillary cursor  
			Declare @Acq_Deal_Sport_Ancillary_Code INT = 0,@Acq_Deal_Sport_Ancillary_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Sport_Ancillary_Code INT,@Ancillary_For CHAR, @Sport_Ancillary_Type_Code INT,@SA_Obligation_Broadcast CHAR,@Broadcast_Window INT,  
			@Broadcast_Periodicity_Code INT,@Sport_Ancillary_Periodicity_Code INT,@SA_Duration time,@No_Of_Promos INT,@SA_Prime_Start_Time time,@SA_Prime_End_Time time,  
			@Prime_Durartion time,@Prime_No_of_Promos INT, @SA_Off_Prime_Start_Time time,@SA_Off_Prime_End_Time time,@Off_Prime_Durartion time,@Off_Prime_No_of_Promos INT,  
			@SA_Remarks NVARCHAR(4000)  
			DECLARE sport_anci_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Sport_Ancillary_Code,Acq_Deal_Sport_Ancillary_Code,Ancillary_For, Sport_Ancillary_Type_Code,Obligation_Broadcast,Broadcast_Window,Broadcast_Periodicity_Code,  
			Sport_Ancillary_Periodicity_Code,Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos, Off_Prime_Start_Time,  
			Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks  
			FROM AT_Acq_Deal_Sport_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN sport_anci_cursor  
			FETCH NEXT FROM sport_anci_cursor  
			INTO @AT_Acq_Deal_Sport_Ancillary_Code,@Acq_Deal_Sport_Ancillary_Code,@Ancillary_For, @Sport_Ancillary_Type_Code ,@SA_Obligation_Broadcast ,@Broadcast_Window ,@Broadcast_Periodicity_Code,  
			@Sport_Ancillary_Periodicity_Code ,@SA_Duration ,@No_Of_Promos ,@SA_Prime_Start_Time ,@SA_Prime_End_Time ,@Prime_Durartion ,@Prime_No_of_Promos ,  
			@SA_Off_Prime_Start_Time,@SA_Off_Prime_End_Time,@Off_Prime_Durartion,@Off_Prime_No_of_Promos,@SA_Remarks    
			WHILE @@FETCH_STATUS = 0  
			BEGIN  
				/******************************** Insert into Acq_Deal_Sport_Ancillary *****************************************/   
				IF(IsNull(@Acq_Deal_Sport_Ancillary_Old_Code, 0) = 0)  
				BEGIN                 
					INSERT INTO Acq_Deal_Sport_Ancillary(Acq_Deal_Code,Ancillary_For, Sport_Ancillary_Type_Code, Obligation_Broadcast, Broadcast_Window,  
					Broadcast_Periodicity_Code, Sport_Ancillary_Periodicity_Code, Duration, No_Of_Promos,  
					Prime_Start_Time, Prime_End_Time, Prime_Durartion, Prime_No_of_Promos, 
					Off_Prime_Start_Time, Off_Prime_End_Time, Off_Prime_Durartion, Off_Prime_No_of_Promos, Remarks)
					VALUES  
					(@Acq_Deal_Code,@Ancillary_For, @Sport_Ancillary_Type_Code ,@SA_Obligation_Broadcast ,@Broadcast_Window ,  
					@Broadcast_Periodicity_Code,@Sport_Ancillary_Periodicity_Code ,@SA_Duration ,@No_Of_Promos,  
					@SA_Prime_Start_Time ,@SA_Prime_End_Time,@Prime_Durartion ,@Prime_No_of_Promos ,  
					@SA_Off_Prime_Start_Time,@SA_Off_Prime_End_Time,@Off_Prime_Durartion,@Off_Prime_No_of_Promos,@SA_Remarks)  
					SELECT @Acq_Deal_Sport_Ancillary_Code = IDENT_CURRENT('Acq_Deal_Sport_Ancillary')  
					UPDATE AT_Acq_Deal_Sport_Ancillary SET Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code WHERE AT_Acq_Deal_Sport_Ancillary_Code  = @AT_Acq_Deal_Sport_Ancillary_Code  
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Ancillary] ON                  
					INSERT INTO Acq_Deal_Sport_Ancillary (Acq_Deal_Code,Ancillary_For, Sport_Ancillary_Type_Code ,Obligation_Broadcast ,Broadcast_Window ,  
					Broadcast_Periodicity_Code,Sport_Ancillary_Periodicity_Code ,Duration ,No_Of_Promos,  
					Prime_Start_Time ,Prime_End_Time,Prime_Durartion ,Prime_No_of_Promos ,  
					Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks)  
					VALUES  
					(@Acq_Deal_Code,@Ancillary_For, @Sport_Ancillary_Type_Code ,@SA_Obligation_Broadcast ,@Broadcast_Window ,  
					@Broadcast_Periodicity_Code,@Sport_Ancillary_Periodicity_Code ,@SA_Duration ,@No_Of_Promos,  
					@SA_Prime_Start_Time ,@SA_Prime_End_Time,@Prime_Durartion ,@Prime_No_of_Promos ,  
					@SA_Off_Prime_Start_Time,@SA_Off_Prime_End_Time,@Off_Prime_Durartion,@Off_Prime_No_of_Promos,@SA_Remarks)  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Ancillary] OFF  
					SELECT @Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Old_Code  
				END  
				/**************** Insert into Acq_Deal_Sport_Ancillary_Broadcast ****************/   
  
				INSERT INTO Acq_Deal_Sport_Ancillary_Broadcast(  
				Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Broadcast_Code)  
				SELECT   
				@Acq_Deal_Sport_Ancillary_Code,ADSAB.Sport_Ancillary_Broadcast_Code  
				FROM AT_Acq_Deal_Sport_Ancillary_Broadcast ADSAB WHERE ADSAB.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code  
  
				/**************** Insert into Acq_Deal_Sport_Ancillary_Source ****************/   
  
				INSERT INTO Acq_Deal_Sport_Ancillary_Source(  
				Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Source_Code)  
				SELECT   
				@Acq_Deal_Sport_Ancillary_Code,ADSAS.Sport_Ancillary_Source_Code  
				FROM AT_Acq_Deal_Sport_Ancillary_Source ADSAS WHERE ADSAS.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code  
  
				/**************** Insert into Acq_Deal_Sport_Ancillary_Title ****************/   
  
				INSERT INTO Acq_Deal_Sport_Ancillary_Title(  
				Acq_Deal_Sport_Ancillary_Code,Title_Code,Episode_From,Episode_To)  
				SELECT   
				@Acq_Deal_Sport_Ancillary_Code,ADSAT.Title_Code,ADSAT.Episode_From,ADSAT.Episode_To  
				FROM AT_Acq_Deal_Sport_Ancillary_Title ADSAT WHERE ADSAT.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code  

				FETCH NEXT FROM sport_anci_cursor  
				INTO @AT_Acq_Deal_Sport_Ancillary_Code,@Acq_Deal_Sport_Ancillary_Code,@Ancillary_For, @Sport_Ancillary_Type_Code ,@SA_Obligation_Broadcast ,@Broadcast_Window ,@Broadcast_Periodicity_Code,  
				@Sport_Ancillary_Periodicity_Code ,@SA_Duration ,@No_Of_Promos ,@SA_Prime_Start_Time ,@SA_Prime_End_Time ,@Prime_Durartion ,@Prime_No_of_Promos ,  
				@SA_Off_Prime_Start_Time,@SA_Off_Prime_End_Time,@Off_Prime_Durartion,@Off_Prime_No_of_Promos,@SA_Remarks  
			END  
			CLOSE sport_anci_cursor  
			DEALLOCATE sport_anci_cursor  
  
			/******************************** Delete from Acq_Deal_Sport_Monetisation_Ancillary *****************************************/   
     
			/* Delete from Acq_Deal_Sport_Monetisation_Ancillary_Type */  
			DELETE ADSMAT FROM Acq_Deal_Sport_Monetisation_Ancillary ADSMA INNER JOIN Acq_Deal_Sport_Monetisation_Ancillary_Type ADSMAT  
			ON ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code AND ADSMA.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Sport_Monetisation_Ancillary_Type */  
			DELETE ADSMAT FROM Acq_Deal_Sport_Monetisation_Ancillary ADSMA INNER JOIN Acq_Deal_Sport_Monetisation_Ancillary_Title ADSMAT  
			ON ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code AND ADSMA.Acq_Deal_Code = @Acq_Deal_Code  
  
			/* Delete from Acq_Deal_Sport_Monetisation_Ancillary */  
			DELETE FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code  
  
  
			--Declare sport ancillary monetisation cursor  
			Declare @Acq_Deal_Sport_Monetisation_Ancillary_Code INT = 0,@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code INT,@Appoint_Title_Sponsor CHAR, @Appoint_Broadcast_Sponsor CHAR, @SM_Remarks NVARCHAR(4000)
  
			DECLARE sport_mone_anci_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,Acq_Deal_Sport_Monetisation_Ancillary_Code,Appoint_Title_Sponsor, Appoint_Broadcast_Sponsor, Remarks  
			FROM AT_Acq_Deal_Sport_Monetisation_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN sport_mone_anci_cursor  
			FETCH NEXT FROM sport_mone_anci_cursor  
			INTO @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code,@Appoint_Title_Sponsor, @Appoint_Broadcast_Sponsor, @SM_Remarks  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN       
				/******************************** Insert into Acq_Deal_Sport_Monetisation_Ancillary *****************************************/   
				IF(ISNULL(@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code, 0) = 0)  
				BEGIN   
					INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary(Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks)
					VALUES(@Acq_Deal_Code,@Appoint_Title_Sponsor, @Appoint_Broadcast_Sponsor, @SM_Remarks)  
        
					SELECT @Acq_Deal_Sport_Monetisation_Ancillary_Code = IDENT_CURRENT('Acq_Deal_Sport_Monetisation_Ancillary')               
        
					UPDATE AT_Acq_Deal_Sport_Monetisation_Ancillary SET Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code   
					WHERE AT_Acq_Deal_Sport_Monetisation_Ancillary_Code  = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code  
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Monetisation_Ancillary] ON                  
					INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary(
					Acq_Deal_Sport_Monetisation_Ancillary_Code,Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks)  
					VALUES(@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code,@Acq_Deal_Code,@Appoint_Title_Sponsor, @Appoint_Broadcast_Sponsor, @SM_Remarks)  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Monetisation_Ancillary] OFF  
        
					SELECT @Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Old_Code  
				END     
  
				/**************** Insert into Acq_Deal_Sport_Monetisation_Ancillary_Title ****************/   
  
				INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary_Title(  
				Acq_Deal_Sport_Monetisation_Ancillary_Code,Title_Code,Episode_From,Episode_To)  
				SELECT   
				@Acq_Deal_Sport_Monetisation_Ancillary_Code,ADSMAT.Title_Code,ADSMAT.Episode_From,ADSMAT.Episode_To  
				FROM AT_Acq_Deal_Sport_Monetisation_Ancillary_Title ADSMAT WHERE ADSMAT.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code  
  
				/**************** Insert into Acq_Deal_Sport_Monetisation_Ancillary_Type ****************/   
  
				INSERT INTO Acq_Deal_Sport_Monetisation_Ancillary_Type(  
				Acq_Deal_Sport_Monetisation_Ancillary_Code,Monetisation_Type_Code,Monetisation_Rights)  
				SELECT   
				@Acq_Deal_Sport_Monetisation_Ancillary_Code,ADSMAT.Monetisation_Type_Code,ADSMAT.Monetisation_Rights  
				FROM AT_Acq_Deal_Sport_Monetisation_Ancillary_Type ADSMAT WHERE ADSMAT.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code  

				FETCH NEXT FROM sport_mone_anci_cursor  
				INTO @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,@Acq_Deal_Sport_Monetisation_Ancillary_Old_Code,@Appoint_Title_Sponsor, @Appoint_Broadcast_Sponsor, @SM_Remarks  
			END  
			CLOSE sport_mone_anci_cursor  
			DEALLOCATE sport_mone_anci_cursor  
  
			/******************************** Delete from Acq_Deal_Sport_Sales_Ancillary *****************************************/   
			/* Delete from Acq_Deal_Sport_Sales_Ancillary_Sponsor */  
			DELETE ADSSAS FROM Acq_Deal_Sport_Sales_Ancillary ADSSA INNER JOIN Acq_Deal_Sport_Sales_Ancillary_Sponsor ADSSAS  
			ON ADSSAS.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code AND ADSSA.Acq_Deal_Code = @Acq_Deal_Code   
			/* Delete from Acq_Deal_Sport_Sales_Ancillary_Title */  
			DELETE ADSSAT FROM Acq_Deal_Sport_Sales_Ancillary ADSSA INNER JOIN Acq_Deal_Sport_Sales_Ancillary_Title ADSSAT  
			ON ADSSAT.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code AND ADSSA.Acq_Deal_Code = @Acq_Deal_Code    
			/* Delete from Acq_Deal_Sport_Sales_Ancillary */  
			DELETE FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code    
			--Declare sport ancillary Sales cursor  
			Declare @Acq_Deal_Sport_Sales_Ancillary_Code INT = 0,@Acq_Deal_Sport_Sales_Ancillary_Old_Code INT = 0  
			Declare @AT_Acq_Deal_Sport_Sales_Ancillary_Code INT,@FRO_Given_Title_Sponsor CHAR,@FRO_Given_Official_Sponsor CHAR,@Title_FRO_No_of_Days INT,  
			@Title_FRO_Validity INT,@Price_Protection_Title_Sponsor CHAR,@Price_Protection_Official_Sponsor CHAR,@Last_Matching_Rights_Title_Sponsor CHAR,  
			@Last_Matching_Rights_Official_Sponsor CHAR,@Title_Last_Matching_Rights_Validity INT,@SS_Remarks NVARCHAR(4000),@Official_FRO_No_of_Days INT,  
			@Official_FRO_Validity INT,@Official_Last_Matching_Rights_Validity INT  
			DECLARE sport_sales_anci_cursor CURSOR FOR  
			SELECT AT_Acq_Deal_Sport_Sales_Ancillary_Code,Acq_Deal_Sport_Sales_Ancillary_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,  
			Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,  
			Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity  
			FROM AT_Acq_Deal_Sport_Sales_Ancillary WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
  
			OPEN sport_sales_anci_cursor  
			FETCH NEXT FROM sport_sales_anci_cursor  
			INTO @AT_Acq_Deal_Sport_Sales_Ancillary_Code,@Acq_Deal_Sport_Sales_Ancillary_Old_Code,@FRO_Given_Title_Sponsor,@FRO_Given_Official_Sponsor,@Title_FRO_No_of_Days,@Title_FRO_Validity ,  
			@Price_Protection_Title_Sponsor,@Price_Protection_Official_Sponsor,@Last_Matching_Rights_Title_Sponsor,@Last_Matching_Rights_Official_Sponsor,  
			@Title_Last_Matching_Rights_Validity,@SS_Remarks,@Official_FRO_No_of_Days,@Official_FRO_Validity,@Official_Last_Matching_Rights_Validity  
  
			WHILE @@FETCH_STATUS = 0  
			BEGIN       
				/******************************** Insert into Acq_Deal_Sport_Monetisation_Ancillary *****************************************/   
				IF(ISNULL(@Acq_Deal_Sport_Sales_Ancillary_Old_Code, 0) = 0)  
				BEGIN                 
					INSERT INTO Acq_Deal_Sport_Sales_Ancillary (
					Acq_Deal_Code, FRO_Given_Title_Sponsor, FRO_Given_Official_Sponsor, Title_FRO_No_of_Days, Title_FRO_Validity,  
					Price_Protection_Title_Sponsor, Price_Protection_Official_Sponsor, Last_Matching_Rights_Title_Sponsor,  
					Last_Matching_Rights_Official_Sponsor, Title_Last_Matching_Rights_Validity, Remarks, Official_FRO_No_of_Days,  
					Official_FRO_Validity, Official_Last_Matching_Rights_Validity)
					VALUES(@Acq_Deal_Code,@FRO_Given_Title_Sponsor,@FRO_Given_Official_Sponsor,@Title_FRO_No_of_Days,@Title_FRO_Validity ,  
					@Price_Protection_Title_Sponsor,@Price_Protection_Official_Sponsor,@Last_Matching_Rights_Title_Sponsor,  
					@Last_Matching_Rights_Official_Sponsor,@Title_Last_Matching_Rights_Validity,@SS_Remarks,@Official_FRO_No_of_Days,  
					@Official_FRO_Validity,@Official_Last_Matching_Rights_Validity)  

					SELECT @Acq_Deal_Sport_Sales_Ancillary_Code = IDENT_CURRENT('Acq_Deal_Sport_Sales_Ancillary')  
  
					UPDATE AT_Acq_Deal_Sport_Sales_Ancillary SET Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code   
					WHERE AT_Acq_Deal_Sport_Sales_Ancillary_Code  = @AT_Acq_Deal_Sport_Sales_Ancillary_Code  
				END  
				ELSE  
				BEGIN  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Sales_Ancillary] ON  
					INSERT INTO Acq_Deal_Sport_Sales_Ancillary(
					Acq_Deal_Sport_Sales_Ancillary_Code ,Acq_Deal_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,  
					Title_FRO_Validity ,Price_Protection_Title_Sponsor,Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,  
					Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,Remarks,Official_FRO_No_of_Days,  
					Official_FRO_Validity,Official_Last_Matching_Rights_Validity)  
					VALUES(@Acq_Deal_Sport_Sales_Ancillary_Old_Code,@Acq_Deal_Code,@FRO_Given_Title_Sponsor,@FRO_Given_Official_Sponsor,  
					@Title_FRO_No_of_Days,@Title_FRO_Validity ,@Price_Protection_Title_Sponsor,@Price_Protection_Official_Sponsor,  
					@Last_Matching_Rights_Title_Sponsor,@Last_Matching_Rights_Official_Sponsor,@Title_Last_Matching_Rights_Validity,  
					@SS_Remarks,@Official_FRO_No_of_Days,@Official_FRO_Validity,@Official_Last_Matching_Rights_Validity)  
					SET IDENTITY_INSERT [Acq_Deal_Sport_Sales_Ancillary] OFF  
					SELECT @Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Old_Code  
				END       
  
				/**************** Insert into Acq_Deal_Sport_Sales_Ancillary_Title ****************/   
  
				INSERT INTO Acq_Deal_Sport_Sales_Ancillary_Title(  
				Acq_Deal_Sport_Sales_Ancillary_Code,Title_Code,Episode_From,Episode_To)  
				SELECT   
				@Acq_Deal_Sport_Sales_Ancillary_Code,ADSSAT.Title_Code,ADSSAT.Episode_From,ADSSAT.Episode_To  
				FROM AT_Acq_Deal_Sport_Sales_Ancillary_Title ADSSAT WHERE ADSSAT.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code  
  
				/**************** Insert into Acq_Deal_Sport_Sales_Ancillary_Sponsor ****************/   
  
				INSERT INTO Acq_Deal_Sport_Sales_Ancillary_Sponsor(Acq_Deal_Sport_Sales_Ancillary_Code,Sponsor_Code,Sponsor_Type)  
				SELECT @Acq_Deal_Sport_Sales_Ancillary_Code,ADSSAS.Sponsor_Code,ADSSAS.Sponsor_Type  
				FROM AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor ADSSAS 
				WHERE ADSSAS.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code  
  
  
				FETCH NEXT FROM sport_sales_anci_cursor  
				INTO @AT_Acq_Deal_Sport_Sales_Ancillary_Code,@Acq_Deal_Sport_Sales_Ancillary_Old_Code,@FRO_Given_Title_Sponsor,@FRO_Given_Official_Sponsor,@Title_FRO_No_of_Days,@Title_FRO_Validity ,  
				@Price_Protection_Title_Sponsor,@Price_Protection_Official_Sponsor,@Last_Matching_Rights_Title_Sponsor,@Last_Matching_Rights_Official_Sponsor,  
				@Title_Last_Matching_Rights_Validity,@SS_Remarks,@Official_FRO_No_of_Days,@Official_FRO_Validity,@Official_Last_Matching_Rights_Validity  
			END  
			CLOSE sport_sales_anci_cursor  
			DEALLOCATE sport_sales_anci_cursor  
  
			/******************************** Delete from Acq_Deal_Payment_Terms *****************************************/  
			DELETE FROM Acq_Deal_Payment_Terms WHERE Acq_Deal_Code = @Acq_Deal_Code  
			/******************************** Insert into Acq_Deal_Payment_Terms *****************************************/     
			INSERT INTO Acq_Deal_Payment_Terms  
			(  
				Acq_Deal_Code, Cost_Type_Code, Payment_Term_Code, Days_After, [Percentage], Amount, Due_Date, Inserted_On,   
				Inserted_By, Last_Updated_Time, Last_Action_By  
			)  
			SELECT  
				@Acq_Deal_Code, Cost_Type_Code, Payment_Term_Code, Days_After, [Percentage], Amount, Due_Date,   
				Inserted_On, Inserted_By, GETDATE(), @User_Code  
			FROM AT_Acq_Deal_Payment_Terms WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Payment_Terms_Code,0) = 0  
     
			SET IDENTITY_INSERT [Acq_Deal_Payment_Terms] ON                     
			INSERT INTO Acq_Deal_Payment_Terms (
			Acq_Deal_Payment_Terms_Code,Acq_Deal_Code, Cost_Type_Code, Payment_Term_Code, Days_After, Percentage, Amount, Due_Date,   
			Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)  
			SELECT Acq_Deal_Payment_Terms_Code,@Acq_Deal_Code, Cost_Type_Code, Payment_Term_Code, Days_After, Percentage, Amount, Due_Date, Inserted_On, Inserted_By, GETDATE(), @User_Code  
			FROM AT_Acq_Deal_Payment_Terms WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code     
			AND ISNULL(Acq_Deal_Payment_Terms_Code,0) > 0  
			SET IDENTITY_INSERT [Acq_Deal_Payment_Terms] OFF     
     
			/******************************** Delete from  Acq_Deal_Attachment *****************************************/   
			DELETE FROM Acq_Deal_Attachment WHERE Acq_Deal_Code = @Acq_Deal_Code  
			DECLARE @Acq_Deal_Attachment_Code INT = 0  
			/******************************** Insert into Acq_Deal_Attachment *****************************************/   
			INSERT INTO Acq_Deal_Attachment(
			Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To)  
			SELECT @Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To  
			FROM AT_Acq_Deal_Attachment WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Attachment_Code,0) = 0  
  
			SET IDENTITY_INSERT [Acq_Deal_Attachment] ON                     
			INSERT INTO Acq_Deal_Attachment(
			Acq_Deal_Attachment_Code,Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code,   
			Episode_From, Episode_To)  
			SELECT Acq_Deal_Attachment_Code,@Acq_Deal_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name,   
			Document_Type_Code, Episode_From, Episode_To  
			FROM AT_Acq_Deal_Attachment WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code    
			AND ISNULL(Acq_Deal_Attachment_Code,0) > 0  
			SET IDENTITY_INSERT [Acq_Deal_Attachment] OFF   
     
			/******************************** Delete from Acq_Deal_Material *****************************************/   
			DELETE FROM Acq_Deal_Material WHERE Acq_Deal_Code = @Acq_Deal_Code  
			/******************************** Insert into Acq_Deal_Material *****************************************/         
			INSERT INTO Acq_Deal_Material(  
			Acq_Deal_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time,   
			Last_Updated_Time, Last_Action_By, Episode_From, Episode_To)  
			SELECT @Acq_Deal_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time,   
			GETDATE(), @User_Code, Episode_From, Episode_To  
			FROM AT_Acq_Deal_Material WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Material_Code,0) = 0  
  
			SET IDENTITY_INSERT [Acq_Deal_Material] ON                     
			INSERT INTO Acq_Deal_Material(  
			Acq_Deal_Material_Code,Acq_Deal_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time,   
			Last_Updated_Time, Last_Action_By, Episode_From, Episode_To)  
			SELECT Acq_Deal_Material_Code,@Acq_Deal_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On,   
			Inserted_By, Lock_Time, GETDATE(), @User_Code, Episode_From, Episode_To  
			FROM AT_Acq_Deal_Material WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code      
			AND ISNULL(Acq_Deal_Material_Code,0) > 0  
			SET IDENTITY_INSERT [Acq_Deal_Material] OFF      
 
			/******************************** Delete from Acq_Deal_Budget *****************************************/   
			DELETE FROM Acq_Deal_Budget WHERE Acq_Deal_Code = @Acq_Deal_Code  
     
			/******************************** Insert into Acq_Deal_Budget *****************************************/   
			INSERT INTO Acq_Deal_Budget(
			Acq_Deal_Code, Title_Code, Episode_From, Episode_To,SAP_WBS_Code)  
			SELECT @Acq_Deal_Code, Title_Code, Episode_From, Episode_To, SAP_WBS_Code  
			FROM AT_Acq_Deal_Budget WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Budget_Code,0) = 0  
  
			SET IDENTITY_INSERT [Acq_Deal_Budget] ON                     
			INSERT INTO Acq_Deal_Budget(
			Acq_Deal_Budget_Code,Acq_Deal_Code, Title_Code, Episode_From, Episode_To,SAP_WBS_Code)  
			SELECT Acq_Deal_Budget_Code,@Acq_Deal_Code, Title_Code, Episode_From, Episode_To, SAP_WBS_Code  
			FROM AT_Acq_Deal_Budget WHERE AT_Acq_Deal_Code = @AT_Acq_Deal_Code  
			AND ISNULL(Acq_Deal_Budget_Code,0) > 0  
			SET IDENTITY_INSERT [Acq_Deal_Budget] OFF      
			/***********************************************************************************************/  
			--Drop Table #TempRights  
		END

		COMMIT 
		  
		SELECT 'S' Flag, 'Success' Msg ,0
		UPDATE
			DP
		SET 
			DP.Record_Status = 'D',
			DP.Porcess_End = GETDATE() ,
			DP.Version_No = AD.Version
		FROM
			Acq_Deal AS AD INNER JOIN Deal_Process AS DP ON AD.Acq_Deal_Code = DP.Deal_Code
		WHERE 
			DP.Deal_Code = @Acq_Deal_Code And DP.Record_Status  = 'W' AND DP.Module_Code = 30

	END TRY  
	BEGIN CATCH  
		ROLLBACK  

		SELECT 'E' Flag, ERROR_MESSAGE() as Msg,ERROR_LINE() AS ErrorLine  
		Update Deal_Process Set Record_Status  = 'E', Porcess_End = GETDATE(), Error_Messages = ERROR_MESSAGE() WHERE Deal_Code = @Acq_Deal_Code And Record_Status  = 'W'  AND Module_Code = 30
		------INSERTION OF ERROR---------------------------------------------------------------------
		INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
		SELECT GETDATE(),null,null,'USP_RollBack_Acq_Deal','Acq_Deal_Code : '+CAST(@Acq_Deal_Code AS VARCHAR)+' '+'in error state','NA',ERROR_MESSAGE(),'DB' 
		FROM Deal_Process Where Deal_Code = @Acq_Deal_Code And Record_Status  = 'W'  AND Module_Code = 30
		
		
		DECLARE  @sql NVARCHAR(MAX),@DB_Name VARCHAR(1000);
		SELECT @sql = CAST(@Acq_Deal_Code AS VARCHAR) +' '+'Records are in pending state for AcqDeal' +' '+ ERROR_MESSAGE()
		SELECT @DB_Name = DB_NAME()
		EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin',@DB_Name,'RU','USP_RollBack_Acq_Deal','AN','VN',@sql ,'DB','IP','FR','TI'
		
	END CATCH
END
GO
PRINT N'Altering [dbo].[USP_SendMail_Intimation_New]...';


GO
ALTER PROCEDURE [dbo].[USP_SendMail_Intimation_New]
	@RecordCode INT,
	@module_workflow_detail_code INT,
	@module_code INT,
	@RedirectToApprovalList VARCHAR(100),
	@AutoLoginUser VARCHAR(100),
	@Is_Error CHAR(1) OUTPUT
AS  
-- =============================================  
-- Author:  Dadasaheb G. Karande  
-- Create date: 03-FEB-2011  
-- Description: To Send mail to a Last All approver after the Aquisition Or Syndication deal   
--    is approve from user  
-- =============================================  
BEGIN  

	--DECLARE 
	--@RecordCode INT =21617,
	--@module_workflow_detail_code INT = 37243,
	--@module_code INT = 30,
	--@RedirectToApprovalList VARCHAR(100)='',
	--@AutoLoginUser VARCHAR(100) = 203,
	--@Is_Error CHAR(1) = 'N'

	SET NOCOUNT ON; 
	SET @Is_Error='N'  

	IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

	BEGIN TRY
		DECLARE @Approved_by VARCHAR(MAX) SET @Approved_by=''
		DECLARE @cur_first_name NVARCHAR(500)
		DECLARE @cur_security_group_name NVARCHAR(500)
		DECLARE @cur_email_id VARCHAR(500)
		DECLARE @cur_security_group_code VARCHAR(500)
		DECLARE @cur_user_code INT
		DECLARE @cur_next_level_group INT

		DECLARE @DealType VARCHAR(100) = ''
		DECLARE @DealNo VARCHAR(500) = 0
		DECLARE @body1 NVARCHAR(MAX) = ''
		DECLARE @MailSubjectCr NVARCHAR(500)  
		DECLARE @CC VARCHAR(MAX) = ''  
		DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)  
		DECLARE @BU_Code Int = 0
		DECLARE  @DefaultSiteUrl_Param NVARCHAR(500) = ''
		DECLARE @DefaultSiteUrl VARCHAR(500) SET @DefaultSiteUrl = ''  
		DECLARE @Email_Config_Code INT
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='AIN'

		SELECT @Approved_by = --ISNULL(U.First_Name,'') + ' ' + ISNULL(U.Middle_Name,'') + ' ' + ISNULL(U.Last_Name,'') 
		ISNULL(UPPER(LEFT(U.First_Name,1))+LOWER(SUBSTRING(U.First_Name,2,LEN(U.First_Name))), '') 
		+ ' ' + ISNULL(UPPER(LEFT(U.Middle_Name,1))+LOWER(SUBSTRING(U.Middle_Name,2,LEN(U.Middle_Name))), '') 
		+ ' ' + ISNULL(UPPER(LEFT(U.Last_Name,1))+LOWER(SUBSTRING(U.Last_Name,2,LEN(U.Last_Name))), '') 
		+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
		FROM Users U  
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U.Security_Group_Code  
		WHERE Users_Code   = @AutoLoginUser 

		SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param --// SET A FLAG FOR SEND MAIL TO INDIVIDUAL PERSON OR SECURITY GROUP //--  

		IF(@module_code = 30)
		BEGIN
			SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Acquisition'
			FROM Acq_Deal WHERE Acq_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 35)
		BEGIN
			SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Syndication'
			FROM Syn_Deal  WHERE Syn_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 163)
		BEGIN
			SELECT @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Music'
			FROM Music_Deal  WHERE Music_Deal_Code = @RecordCode 
		END

		DECLARE 
			@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', @Primary_Licensor NVARCHAR(MAX) = '', 
			@Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0 ,@BU_Name VARCHAR(MAX) = ''

		DECLARE @Created_By  VARCHAR(MAX) = '',
				@Creation_Date  VARCHAR(MAX) = '',
				@Last_Actioned_By  VARCHAR(MAX) = '',
				@Last_Actioned_Date  VARCHAR(MAX) = ''

		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) FROM System_Parameter_New 
			WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106),
					@Deal_Desc = Deal_Desc, @Primary_Licensor = V.Vendor_Name, @BU_Name = BU.Business_Unit_Name,
					@Created_By = ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') ,-- U1.Login_Name ,
					@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
					@Last_Actioned_By =ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') ,-- U2.Login_Name ,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = AD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = AD.Last_Action_By
				WHERE Acq_Deal_Code = @RecordCode

			
				SELECT @Title_Count = COUNT(DISTINCT Title_Code) FROM Acq_Deal_Movie where Acq_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM
						INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
						WHERE Acq_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 35)
			BEGIN
				PRINT 'Syndication Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name,
					@Created_By =  ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') ,
					@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
					@Last_Actioned_By = ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') ,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = SD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = SD.Last_Action_By
				WHERE Syn_Deal_Code = @RecordCode
			
				SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Syn_Deal_Movie where Syn_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Syn_Deal_Movie SDM
						INNER JOIN Title T ON SDM.Title_Code = T.Title_Code
						WHERE Syn_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 163)
			BEGIN
				PRINT 'Music Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name,@BU_Name = BU.Business_Unit_Name
				FROM Music_Deal MD
					INNER JOIN Vendor V ON MD.Primary_Vendor_Code = V.Vendor_Code
					INNER JOIN Music_Label ML ON ML.Music_Label_Code = MD.Music_Label_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = MD.Business_Unit_Code
				WHERE Music_Deal_Code = @RecordCode
			END
		END
  
		/* CHECK THAT DEAL IS APPROVED THROUGH ALL WORKFLOW LEVEL OR NOT */
		DECLARE @Is_Deal_Approved INT  = 0  
		SELECT @Is_Deal_Approved = COUNT(*) FROM Module_Workflow_Detail MWD 
		WHERE  Module_Workflow_Detail_Code IN (  
			SELECT Module_Workflow_Detail_Code FROM Module_Workflow_Detail 
			WHERE Record_Code = @RecordCode  AND Module_Code = @module_code  AND Is_Done = 'N'  
		)
   
		/* GET NEXT APPROVAL NAME */
		DECLARE @NextApprovalName NVARCHAR(500) = ''  
		SELECT @NextApprovalName = Security_Group_Name FROM Security_Group   
		WHERE Security_Group_Code IN (
			SELECT ISNULL(Next_Level_Group, 0) FROM Module_Workflow_Detail WHERE Module_Workflow_Detail_Code = @module_workflow_detail_code
		)    
    
		/* SELECT SITE URL */
		DECLARE @DefaultSiteUrlHold VARCHAR(500)
		SELECT  @DefaultSiteUrl_Param = DefaultSiteUrl , @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param  

		IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

		CREATE TABLE #TempCursorOnRej (
			Email_id NVARCHAR(500),
			First_name NVARCHAR(MAX),
			Security_group_name NVARCHAR(500),
			Next_level_group INT,
			Security_group_code INT,
			User_code INT 
		)

		IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
		BEGIN
			INSERT INTO #TempCursorOnRej(Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code)
			SELECT DISTINCT U1.Email_Id, 
			ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') 
			+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
			SG.Security_Group_Name, 
			MWD.Next_Level_Group, 
			U1.Security_Group_Code, 
			U1.Users_Code 
			FROM Module_Workflow_Detail MWD 
			INNER JOIN Users U1 ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
			INNER JOIN Users_Business_Unit UBU ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
			WHERE MWD.Is_Done = 'Y' AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode 
				  AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code
		END
		ELSE
		BEGIN
			INSERT INTO #TempCursorOnRej(Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code)
			SELECT DISTINCT U1.Email_Id, 
			ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
			+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') 
			+ '   ('+ ISNULL(SG.Security_Group_Name,'') + ')',
			SG.Security_Group_Name, 
			MWD.Next_Level_Group, 
			U1.Security_Group_Code, 
			U1.Users_Code 
			FROM Module_Workflow_Detail MWD 
			INNER JOIN Users U1 ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
			INNER JOIN Users_Business_Unit UBU ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
			WHERE MWD.Is_Done = 'Y' AND MWD.Module_Code = @module_code AND MWD.Record_Code = @RecordCode 
				  AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code
		END

		/* CURSOR START */
		DECLARE cur_on_rejection CURSOR KEYSET FOR 
		SELECT Email_id, First_name, Security_group_name, Next_level_group, Security_group_code, User_code FROM #TempCursorOnRej
		OPEN cur_on_rejection  
		FETCH NEXT FROM cur_on_rejection INTO @cur_email_id, @cur_first_name, @cur_security_group_name, @cur_next_level_group, @cur_security_group_code, @cur_user_code  
		WHILE (@@fetch_status <> -1)  
		BEGIN  
			IF (@@fetch_status <> -2)  
			BEGIN  
				SELECT @DefaultSiteUrl  = @DefaultSiteUrlHold

				IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
				BEGIN
					SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=Y&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=A'
				
					select @body1 = template_desc FROM Email_template WHERE Template_For='AR'
					SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
					set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
					set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
					set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
					set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
					SET @body1 = REPLACE(@body1,'{approved_by}',@Approved_by) 
					
					IF (@RedirectToApprovalList = 'WA')
					BEGIN
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Sent For Archive' 
						SET @body1 = REPLACE(@body1,'{archive_by}',' Sent For Archive by') 
					END
					ELSE IF @RedirectToApprovalList = 'AR'
					BEGIN
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Archived' 
						SET @body1 = REPLACE(@body1,'{archive_by}',' Approved For Archived by') 
					END
					ELSE IF @RedirectToApprovalList = 'A'
					BEGIN
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is Rejected For Archive' 
						SET @body1 = REPLACE(@body1,'{archive_by}',' Rejected For Archive by') 
					END
				END
				ELSE
				BEGIN
					SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=A'

					IF(@Is_Deal_Approved > 0)  /* IF DEAL IS NOT APPROVED BY ALL WORKFLOW */
					BEGIN  
						print '1'
						--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) + 
						--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
						select @body1 = template_desc FROM Email_template WHERE Template_For='I'
						SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
						set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
						set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
						set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
						set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
						SET @body1 = REPLACE(@body1, '{next_approval}',@NextApprovalName) 		
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is sent for approve to next approval'   
					END  
					ELSE IF(@Is_Deal_Approved = 0) /* IF DEAL APPROVED BY ALL WORKFLOW */
					BEGIN  
						print '2'
						--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) + 
						--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
						select @body1 = template_desc FROM Email_template WHERE Template_For='D'
						SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
						set @body1 = REPLACE(@body1,'{deal_no}',@DealNo)  
						set @body1 = REPLACE(@body1,'{deal_type}',@DealType)  
						set @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
						set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)  
						SET @body1 = REPLACE(@body1,'{approved_by}',@Approved_by) 
						SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is approved'   
					END  
				END

				DECLARE @Email_Table NVARCHAR(MAX) = '' , @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'

				SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

				IF(@Is_RU_Content_Category = 'Y')
					SET  @BU_CC= 'Content Category'

				IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
					SET @Email_Table = '
					<table class="tblFormat" style="width:100%">    
						<tr>      
							<th align="center" width="14%" class="tblHead">Agreement No.</th>      
							<th align="center" width="14%" class="tblHead">Agreement Date</th>      
							<th align="center" width="19%" class="tblHead">Deal Description</th>      
							<th align="center" width="19%" class="tblHead">Primary Licensor</th>      
							<th align="center" width="25%" class="tblHead">Title(s)</th>  
							<th align="center" width="10%" class="tblHead">'+@BU_CC+'</th>
						</tr>     
						<tr>      
							<td align="center" class="tblData">{Agreement_No}</td>      
							<td align="center" class="tblData">{Agreement_Date}</td>      
							<td align="center" class="tblData">{Deal_Desc}</td>      
							<td align="center" class="tblData">{Primary_Licensor}</td>      
							<td align="center" class="tblData">{Titles}</td>     
							<td align="center" class="tblData">{BU_Name}</td>     
						</tr>   
					</table>'
				END
				ELSE
				BEGIN 
					SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>
										<th align="center" width="10%" class="tblHead">Agreement No.</th>    
										<th align="center" width="10%" class="tblHead">Agreement Date</th> 
										<th align="center" width="10%" class="tblHead">Created By</th> 
										<th align="center" width="10%" class="tblHead">Creation Date</th> 
										<th align="center" width="10%" class="tblHead">Deal Description</th> 
										<th align="center" width="10%" class="tblHead">Primary Licensor</th>   
										<th align="center" width="10%" class="tblHead">Title(s)</th>
										<th align="center" width="10%" class="tblHead">'+@BU_CC+'</th>
										<th align="center" width="10%" class="tblHead">Last Actioned By</th>
										<th align="center" width="10%" class="tblHead">Last Actioned Date</th>
						 </tr>  
						 <tr>
										<td align="center" class="tblData">{Agreement_No}</td>   
										<td align="center" class="tblData">{Agreement_Date}</td>    
										<td align="center" class="tblData">{Created_By}</td>    
										<td align="center" class="tblData">{Creation_Date}</td>    
										<td align="center" class="tblData">{Deal_Desc}</td>    
										<td align="center" class="tblData">{Primary_Licensor}</td>   
										<td align="center" class="tblData">{Titles}</td> 
										<td align="center" class="tblData">{BU_Name}</td> 
										<td align="center" class="tblData">{Last_Actioned_By}</td> 
										<td align="center" class="tblData">{Last_Actioned_Date}</td> 
						</tr>  
					</table>'
				END


				print @DefaultSiteUrl
				IF (@RedirectToApprovalList = 'WA' OR @RedirectToApprovalList = 'AR' OR @RedirectToApprovalList = 'A')
				BEGIN
					SET @body1 = replace(@body1,'{Agreement_No}',@Agreement_No)  
					SET @body1 = REPLACE(@body1,'{Agreement_Date}',@Agreement_Date)  
					SET @body1 = REPLACE(@body1,'{Deal_Desc}',@Deal_Desc)  
					SET @body1 = replace(@body1,'{Primary_Licensor}',@Primary_Licensor)  
					SET @body1 = replace(@body1,'{Titles}',@Titles)  
					SET @body1 = replace(@body1,'{BU_Name}',@BU_Name)
					SET @CC=''  
					--SET @body1 = replace(@body1,'{table}',@Email_Table)
				END
				ELSE
				BEGIN
					SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
					SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
					SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
					SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
					SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
					SET @Email_Table = replace(@Email_Table,'{BU_Name}',@BU_Name)

					IF(@module_code <> 163 AND @Is_RU_Content_Category = 'Y')
					BEGIN
						SET @Email_Table = REPLACE(@Email_Table,'{Created_By}',@Created_By)  
						SET @Email_Table = REPLACE(@Email_Table,'{Creation_Date}',@Creation_Date)  
						SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}', @Last_Actioned_By)
						SET @Email_Table = replace(@Email_Table,'{Last_Actioned_Date}', @Last_Actioned_Date)
					END

					SET @CC=''  
					SET @body1 = replace(@body1,'{table}',@Email_Table)
				END

				DECLARE @DatabaseEmail_Profile varchar(200)	= ''
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile  
				,@recipients =  @cur_email_id    
				,@copy_recipients = @CC  
				,@subject = @MailSubjectCr  
				,@body = @body1,@body_format = 'HTML';    

				IF (@RedirectToApprovalList = 'WA')
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Waiting for Archive', @Cur_email_id
				ELSE IF (@RedirectToApprovalList = 'AR')
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Archived', @Cur_email_id
				ELSE IF (@RedirectToApprovalList = 'A')
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Rejected For Archive', @Cur_email_id
				ELSE
					INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
					SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Send for Approval', @Cur_email_id
				
			END  
			FETCH NEXT FROM cur_on_rejection INTO @cur_email_id, @cur_first_name, @cur_security_group_name, 
			@cur_next_level_group ,@cur_security_group_code ,@cur_user_code  
		END
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
		/* CURSOR END */

    	IF OBJECT_ID('tempdb..#TempCursorOnRej') IS NOT NULL DROP TABLE #TempCursorOnRej

		SET @Is_Error='N'
	END TRY  	
	BEGIN CATCH  
		SET @Is_Error='Y'  
		PRINT ERROR_MESSAGE()   
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
   
		 INSERT INTO ERRORON_SENDMAIL_FOR_WORKFLOW   
		 SELECT  
			 ERROR_NUMBER() AS ERRORNUMBER,  
			 ERROR_SEVERITY() AS ERRORSEVERITY,    
			 ERROR_STATE() AS ERRORSTATE,  
			 ERROR_PROCEDURE() AS ERRORPROCEDURE,  
			 ERROR_LINE() AS ERRORLINE,  
			 ERROR_MESSAGE() AS ERRORMESSAGE;  
	END CATCH
END

--change script
--select  template_desc FROM Email_template WHERE Template_For='D'
--<html>   <head>    <style>     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }     
--td.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      
--font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      
--font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }          
--#divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear &nbsp;{login_name},<br /><br />
--The {deal_type} Deal No: <b>{deal_no}</b> is approved.<br /><br />     Please <a href='{link}' target='_blank'><b>click here</b>
--</a> for more details.<br /><br /><br />    </div>    
--<table class="tblFormat" >     <tr>      
--<th align="center" width="15%" class="tblHead"><b>Agreement No.<b></th>      
--<th align="center" width="15%" class="tblHead"><b>Agreement Date<b></th>      
--<th align="center" width="20%" class="tblHead"><b>Deal Description<b></th>      
--<th align="center" width="20%" class="tblHead"><b>Primary Licensor<b></th>      
--<th align="center" width="30%" class="tblHead"><b>Title(s)<b></th>     </tr>     
--<tr>      <td align="center" class="tblData">{Agreement_No}</td>      
--<td align="center" class="tblData">{Agreement_Date}</td>      
--<td align="center" class="tblData">{Deal_Desc}</td>      
--<td align="center" class="tblData">{Primary_Licensor}</td>      
--<td align="center" class="tblData">{Titles}</td>     </tr>    </table>    
--<br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>


--select  template_desc FROM Email_template WHERE Template_For='D'
--UPDATE Email_template SET template_desc=
--'<html><head><style>table.tblFormat{border:1px solid black;border-collapse:collapse;} th.tblHead{border:1px solid black;color: #ffffff ;background-color: #585858;      font-family:verdana; font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     } #divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear &nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is approved.<br /><br />     Please <a href=''{link}'' target=''_blank''><b>click here</b></a> for more details.<br /><br /><br />    </div>{table} <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>'
--WHERE Template_For='D'

--select template_desc FROM Email_template WHERE Template_For='I'

--<html>   <head>    <style type="text/css">     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }     
--td.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      
--font-size:12px;     }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      
--font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }          
--#divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear &nbsp;{login_name},<br /><br />    
-- The {deal_type} Deal No: <b>{deal_no}</b> is sent to {next_approval} for approval.<br /><br />     Please <a href='{link}' target='_blank'>
-- <b>click here</b></a> for more details.<br /><br /><br /><br />    </div>    
 
-- <table class="tblFormat" >     <tr>      
-- <td align="center" width="15%" class="tblHead"><b>Agreement No.<b></td>      
-- <td align="center" width="15%" class="tblHead"><b>Agreement Date<b></td>      
-- <td align="center" width="20%" class="tblHead"><b>Deal Description<b></td>      
-- <td align="center" width="20%" class="tblHead"><b>Primary Licensor<b></td>      
-- <td align="center" width="30%" class="tblHead"><b>Title(s)<b></td>     </tr>     
-- <tr>      
-- <td align="center" class="tblData">{Agreement_No}</td>      
-- <td align="center" class="tblData">{Agreement_Date}</td>      
-- <td align="center" class="tblData">{Deal_Desc}</td>      
-- <td align="center" class="tblData">{Primary_Licensor}</td>      
-- <td align="center" class="tblData">{Titles}</td>     </tr>    </table>    
 
-- <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>

--UPDATE Email_template SET template_desc =
--'<html><head><style type="text/css">table.tblFormat{border:1px solid black;border-collapse:collapse;}th.tblHead{border:1px solid black;color: #ffffff ;background-color: #585858;font-family:verdana;font-size:12px; font-weight:bold}td.tblData{border:1px solid black;vertical-align:top;font-family:verdana;font-size:12px;}.textFont{color: black ;font-family:verdana;font-size:12px;}#divFooter{color: gray;}</style></head><body><div class="textFont">Dear &nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is sent to {next_approval} for approval.<br /><br />Please <a href=''{link}'' target=''_blank''> <b>click here</b></a> for more details.<br /><br /><br /><br />    </div> {table}  <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU</div></body></html>'
--WHERE Template_For='I'
--change script
GO
PRINT N'Altering [dbo].[USP_SendMail_On_Rejection]...';


GO
ALTER Procedure [dbo].[USP_SendMail_On_Rejection]   
	 @RecordCode INT,
	 @module_workflow_detail_code INT,
	 @module_code INT,
	 @RedirectToApprovalList VARCHAR(100),
	 @AutoLoginUser VARCHAR(100),
	 @Login_User INT,
	 @Is_Error CHAR(1) OUTPUT  
AS  
-- =============================================  
-- Author:		<Adesh P Arote>
-- Create date: 02-FEB-2011
-- Description: SEND MAIL TO ALL LAST APPROVER IF DEAL IS REJECT FORM ANY USER  
-- =============================================  
BEGIN  

--DECLARE 
--	 @RecordCode INT = 21617,
--	 @module_workflow_detail_code INT = 37243,
--	 @module_code INT = 30,
--	 @RedirectToApprovalList VARCHAR(100) ='N',
--	 @AutoLoginUser VARCHAR(100) ='',
--	 @Login_User INT=136,
--	 @Is_Error CHAR(1)='N'  

	SET @Is_Error='N'  
	BEGIN TRY  
		DECLARE @Rejected_by NVARCHAR(500) SET @Rejected_by=''  
		DECLARE @cur_first_name NVARCHAR(500)  
		DECLARE @cur_security_group_name NVARCHAR(500)   
		DECLARE @cur_email_id NVARCHAR(500)   
		DECLARE @cur_security_group_code VARCHAR(500)   
		DECLARE @cur_user_code INT  
		DECLARE @DealType VARCHAR(100)   
		DECLARE @DealNo VARCHAR(500) SET @DealNo=0  
		DECLARE @body1 NVARCHAR(MAX)  SET @body1 =''  
		DECLARE @MailSubjectCr NVARCHAR(500)  
		DECLARE @CC NVARCHAR(MAX)SET @CC =''  
		DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)
	    DECLARE	@DefaultSiteUrl_Param  NVARCHAR(500) = ''
		DECLARE @DefaultSiteUrl NVARCHAR(500) SET @DefaultSiteUrl = ''  
		DECLARE @BUCode INT = 0 
		DECLARE @Email_Table NVARCHAR(MAX) = ''
		DECLARE @Email_Config_Code INT
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='ARJ'
 
		SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param  
  
		SELECT @Rejected_by = ISNULL(U.First_Name,'') + ' ' + ISNULL(U.Middle_Name,'') + ' ' + ISNULL(U.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')'  
		FROM Users U  
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U.Security_Group_Code  
		WHERE Users_Code   = @Login_User 

		IF(@module_code = 30)
		BEGIN
			SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Acquisition'
			FROM Acq_Deal WHERE Acq_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 35)
		BEGIN
			SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Syndication'
			FROM Syn_Deal  WHERE Syn_Deal_Code = @RecordCode 
		END
		ELSE IF(@module_code = 163)
		BEGIN
			SELECT @DealNo = Agreement_No, @BUCode = Business_Unit_Code, @DealType = 'Music'
			FROM Music_Deal  WHERE Music_Deal_Code = @RecordCode 
		END

		DECLARE 
			@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', 
			@Primary_Licensor NVARCHAR(MAX) = '', @Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0, @BU_Name VARCHAR(MAX) = ''

		DECLARE @Created_By  VARCHAR(MAX) = '',
				@Creation_Date  VARCHAR(MAX) = '',
				@Last_Actioned_By  VARCHAR(MAX) = '',
				@Last_Actioned_Date  VARCHAR(MAX) = ''


		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) FROM System_Parameter_New WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No,
					@Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Desc,
					@Primary_Licensor = V.Vendor_Name,
					@BU_Name = BU.Business_Unit_Name,
					@Created_By =ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') ,
					@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
					@Last_Actioned_By = ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') ,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = AD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = AD.Last_Action_By
				WHERE Acq_Deal_Code = @RecordCode

				SELECT @Title_Count =  COUNT(distinct Title_Code) FROM Acq_Deal_Movie where Acq_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM
						INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
						WHERE Acq_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 35)
			BEGIN
				PRINT 'Syndication Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(varchar(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name,
					@Created_By = ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') ,
					@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
					@Last_Actioned_By =ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') ,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = SD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = SD.Last_Action_By
				WHERE Syn_Deal_Code = @RecordCode

				SELECT @Title_Count =  COUNT(distinct Title_Code) FROM Syn_Deal_Movie where Syn_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Syn_Deal_Movie SDM
						INNER JOIN Title T ON SDM.Title_Code = T.Title_Code
						WHERE Syn_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 163)
			BEGIN
				PRINT 'Music Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name, @BU_Name =BU.Business_Unit_Name
				FROM Music_Deal MD
					INNER JOIN Vendor V ON MD.Primary_Vendor_Code = V.Vendor_Code
					INNER JOIN Music_Label ML ON ML.Music_Label_Code = MD.Music_Label_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = MD.Business_Unit_Code
				WHERE Music_Deal_Code = @RecordCode
			END
		END
   
		DECLARE @DefaultSiteUrlHold NVARCHAR(500), @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'
		SELECT @DefaultSiteUrl_Param = DefaultSiteUrl, @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param  
		SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is rejected'   

		SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

		IF(@Is_RU_Content_Category = 'Y')
			SET  @BU_CC= 'Content Category'

		/* CURSOR START */
		
		DECLARE cur_on_rejection CURSOR KEYSET FOR 
		SELECT DISTINCT ISNULL(U1.First_Name,'') + ' ' + ISNULL(U1.Middle_Name,'') + ' ' + ISNULL(U1.Last_Name,'') + '   ('+ ISNULL(SG.Security_Group_Name,'') + ')', 
			SG.Security_Group_Name, U1.Email_Id, U1.Security_Group_Code, U1.Users_Code  
		FROM Module_Workflow_Detail MWD 
			INNER JOIN Users U1 ON U1.Security_Group_Code = MWD.Group_Code AND U1.Is_Active = 'Y'
			INNER JOIN Users_Business_Unit UBU ON U1.Users_Code = UBU.Users_Code AND UBU.Business_Unit_Code IN (@BUCode)
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
		WHERE MWD.Module_Code = @module_code 
			AND MWD.Record_Code = @RecordCode 
			AND MWD.Module_Workflow_Detail_Code < @module_workflow_detail_code


		OPEN cur_on_rejection  
		FETCH NEXT FROM cur_on_rejection INTO @cur_first_name, @cur_security_group_name, @cur_email_id, @cur_security_group_code, @cur_user_code  
		WHILE (@@fetch_status <> -1)  
		BEGIN  
			IF (@@fetch_status <> -2)  
			BEGIN  
				SELECT @DefaultSiteUrl = @DefaultSiteUrlHold
				--SELECT @DefaultSiteUrl = @DefaultSiteUrl + '/Login.aspx?RedirectToApproval=Y&UserCode=' + CAST(@cur_user_code AS VARCHAR(500)) +
				--'&ModuleCode=' + CAST(@module_code AS VARCHAR(500))
				SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=R'
		
				IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
				SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>     
										<td align="center" width="14%" class="tblHead">Agreement No.</td>    
										<td align="center" width="14%" class="tblHead">Agreement Date</td>   
										<td align="center" width="19%" class="tblHead">Deal Description</td> 
										<td align="center" width="19%" class="tblHead">Primary Licensor</td>   
										<td align="center" width="25%" class="tblHead">Title(s)</td>
										<td align="center" width="10%" class="tblHead">'+@BU_CC+'</td>
						 </tr>  
						 <tr>
										<td align="center" class="tblData">{Agreement_No}</td>   
										<td align="center" class="tblData">{Agreement_Date}</td>     
										<td align="center" class="tblData">{Deal_Desc}</td>    
										<td align="center" class="tblData">{Primary_Licensor}</td>   
										<td align="center" class="tblData">{Titles}</td> 
										<td align="center" class="tblData">{BU_Name}</td> 
						</tr>  
					</table>'
				END
				ELSE
				BEGIN 
				SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>
										<td align="center" width="10%" class="tblHead">Agreement No.</td>    
										<td align="center" width="10%" class="tblHead">Agreement Date</td> 
										<td align="center" width="10%" class="tblHead">Created By</td> 
										<td align="center" width="10%" class="tblHead">Creation Date</td> 
										<td align="center" width="10%" class="tblHead">Deal Description</td> 
										<td align="center" width="10%" class="tblHead">Primary Licensor</td>   
										<td align="center" width="10%" class="tblHead">Title(s)</td>
										<td align="center" width="10%" class="tblHead">'+@BU_CC+'</td>
										<td align="center" width="10%" class="tblHead">Last Actioned By</td>
										<td align="center" width="10%" class="tblHead">Last Actioned Date</td>
						 </tr>  
						 <tr>
										<td align="center" class="tblData">{Agreement_No}</td>   
										<td align="center" class="tblData">{Agreement_Date}</td>    
										<td align="center" class="tblData">{Created_By}</td>    
										<td align="center" class="tblData">{Creation_Date}</td>    
										<td align="center" class="tblData">{Deal_Desc}</td>    
										<td align="center" class="tblData">{Primary_Licensor}</td>   
										<td align="center" class="tblData">{Titles}</td> 
										<td align="center" class="tblData">{BU_Name}</td> 
										<td align="center" class="tblData">{Last_Actioned_By}</td> 
										<td align="center" class="tblData">{Last_Actioned_Date}</td> 
						</tr>  
					</table>'
				END

				SELECT @body1 = template_desc FROM Email_Template WHERE Template_For='R'
				PRINT @DealNo  
				--REPLACE ALL THE PARAMETER VALUE  
				SET @body1 = replace(@body1,'{login_name}',@cur_first_name)  
				SET @body1 = replace(@body1,'{deal_no}',@DealNo)  
				SET @body1 = replace(@body1,'{deal_type}',@DealType)  
				SET @body1 = replace(@body1,'{link}',@DefaultSiteUrl)  
				SET @body1 = replace(@body1,'{rejected_by}',@Rejected_by) 
				 
				SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
				SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
				SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
				SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
				SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
				SET @Email_Table = replace(@Email_Table,'{BU_Name}', @BU_Name)
			
				IF(@module_code <> 163 AND @Is_RU_Content_Category = 'Y')
				BEGIN
					SET @Email_Table = REPLACE(@Email_Table,'{Created_By}',@Created_By)  
					SET @Email_Table = REPLACE(@Email_Table,'{Creation_Date}',@Creation_Date)  
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}', @Last_Actioned_By)
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_Date}', @Last_Actioned_Date)
				END

				SET @CC = ''  
				SET @body1 = replace(@body1,'{table}',@Email_Table)
				--IF(@Is_Mail_Send_To_Group='Y')  
				--BEGIN  
				--	SELECT @CC = @CC + ';' + Email_Id FROM Users WHERE security_group_code IN (@cur_security_group_code)   
				--	AND Users_Code NOT IN (@cur_user_code)  
				--END
  
				DECLARE @DatabaseEmail_Profile varchar(200)	= ''
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile, 
				@recipients =  @cur_email_id, 
				@copy_recipients = @CC, 
				@subject = @MailSubjectCr, 
				@body = @body1,@body_format = 'HTML';

				INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
				SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Send for Approval', @Cur_email_id
			END  
			FETCH NEXT FROM cur_on_rejection INTO @cur_first_name, @cur_security_group_name, @cur_email_id, @cur_security_group_code, @cur_user_code  
		END  
  
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
		/* CURSOR END */
    
		SET @Is_Error='N'  
	END TRY  
	BEGIN CATCH		
		SET @Is_Error='Y'
		PRINT ERROR_MESSAGE()   
		CLOSE cur_on_rejection  
		DEALLOCATE cur_on_rejection  
   
		INSERT INTO ERRORON_SENDMAIL_FOR_WORKFLOW   
		SELECT  
			ERROR_NUMBER() AS ERRORNUMBER,  
			ERROR_SEVERITY() AS ERRORSEVERITY,    
			ERROR_STATE() AS ERRORSTATE,  
			ERROR_PROCEDURE() AS ERRORPROCEDURE,  
			ERROR_LINE() AS ERRORLINE,  
			ERROR_MESSAGE() AS ERRORMESSAGE;  
	END CATCH  
END  

--SELECT template_desc FROM Email_Template WHERE Template_For='R'  
--<html><head><style type="text/css">table.tblFormat{border:1px solid black;border-collapse:collapse;}td.tblHead{border:1px solid black;
--color: #ffffff ;background-color: #585858;font-family:verdana;font-size:12px;}td.tblData{border:1px solid black;vertical-align:top;
--font-family:verdana;font-size:12px;}.textFont{color: black ;font-family:verdana;font-size:12px;}#divFooter{color: gray;}</style></head>
--<body><div class="textFont">Dear&nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is rejected by <b>{rejected_by}</b>.
--<br /><br />     Please <a href='{link}' target='_blank'><b>click here</b></a> for more details.<br /><br /><br /><br />
--</div>   
-- <table class="tblFormat" >     <tr>      
-- <td align="center" width="15%" class="tblHead"><b>Agreement No.<b></td>
-- <td align="center" width="15%" class="tblHead"><b>Agreement Date<b></td>
-- <td align="center" width="20%" class="tblHead"><b>Deal Description<b></td>
-- <td align="center" width="20%" class="tblHead"><b>Primary Licensor<b></td>
-- <td align="center" width="30%" class="tblHead"><b>Title(s)<b></td>     </tr>     
-- <tr>
-- <td align="center" class="tblData">{Agreement_No}</td>
-- <td align="center" class="tblData">{Agreement_Date}</td>
-- <td align="center" class="tblData">{Deal_Desc}</td>
-- <td align="center" class="tblData">{Primary_Licensor}</td>
-- <td align="center" class="tblData">{Titles}</td>     </tr>    </table>    
 
-- <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>

-- UPDATE Email_Template SET template_desc =
-- '<html><head><style type="text/css">table.tblFormat{border:1px solid black;border-collapse:collapse;}th.tblHead{border:1px solid black;color: #ffffff ;background-color: #585858;font-family:verdana;font-size:12px;font-weight:bold}td.tblData{border:1px solid black;vertical-align:top;font-family:verdana;font-size:12px;}.textFont{color: black ;font-family:verdana;font-size:12px;}#divFooter{color: gray;}</style></head><body><div class="textFont">Dear&nbsp;{login_name},<br /><br />The {deal_type} Deal No: <b>{deal_no}</b> is rejected by <b>{rejected_by}</b>.<br /><br />     Please <a href=''{link}'' target=''_blank''><b>click here</b></a> for more details.<br /><br /><br /><br /></div> {table} <br /><br /><br /><br />    <div id="divFooter" class="textFont">     This email is generated by RightsU    </div>   </body>  </html>'
--WHERE Template_For='R'
GO
PRINT N'Altering [dbo].[USP_SendMail_To_NextApprover_New]...';


GO
ALTER PROCEDURE [dbo].[USP_SendMail_To_NextApprover_New]
(
	@RecordCode Int=3
	,@Module_code Int=30
	,@RedirectToApprovalList Varchar(100)='N'
	,@AutoLoginUser Varchar(100)=143
	,@Is_Error Char(1) 	Output
)
AS
BEGIN	
	--declare
	--@RecordCode Int=21617
	--,@Module_code Int=30
	--,@RedirectToApprovalList Varchar(100)='N'
	--,@AutoLoginUser Varchar(100)=143
	--,@Is_Error Char(1) ='N'

	SET NOCOUNT ON;
	--DECLARE @Module_code INT --//--This  is a module code for Acquisition Deal	
	--SET @Module_code =30
	-- =============================================
	-- Declare and using a KEYSET cursor
	-- =============================================
	SET @Is_Error = 'N'
	BEGIN TRY

		DECLARE @Cur_first_name NVARCHAR(500)
		DECLARE @Cur_security_group_name NVARCHAR(500) 
		DECLARE @Cur_email_id NVARCHAR(500) 
		DECLARE @Cur_security_group_code NVARCHAR(500) 
		DECLARE @Cur_user_code INT

		DECLARE @DealType VARCHAR(100) 
		DECLARE @DealNo VARCHAR(500) = 0
		DECLARE @body1 NVARCHAR(MAX) = ''
		DECLARE @MailSubjectCr NVARCHAR(500)
		DECLARE @CC NVARCHAR(MAX) = ''
		DECLARE @Is_Mail_Send_To_Group AS VARCHAR(1)
		DECLARE @DefaultSiteUrl_Param NVARCHAR(500) = ''
		DECLARE @DefaultSiteUrl NVARCHAR(500) = ''
		DECLARE @BU_Code Int = 0
		DECLARE @Email_Table NVARCHAR(MAX) = ''
		DECLARE @Email_Config_Code INT
		DECLARE @Acq_Deal_Rights_Code varchar(max)=''
		DECLARE @Promoter_Count int
		DECLARE @Promoter_Message varchar(max) =''
		SELECT @Email_Config_Code=Email_Config_Code FROM Email_Config WHERE [Key]='SFA'

		SELECT @Is_Mail_Send_To_Group=ISNULL(Is_Mail_Send_To_Group,'N') FROM System_Param	--// FLAG FOR SEND MAIL TO INDIVIDUAL PERSON ON GROUP //--

		SET @DealType = ''
		IF(@Module_code = 30)
		BEGIN
			SELECT TOP 1  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Acquisition'
			FROM Acq_Deal WHERE Acq_Deal_Code = @RecordCode
			SELECT @Acq_Deal_Rights_Code   =  @Acq_Deal_Rights_Code + CAST(acq_deal_rights_Code AS varchar)+ ', '  FROM acq_deal_Rights WHERE Acq_Deal_Code = @RecordCode
			select @Promoter_Count = count(*) from Acq_Deal_Rights_Promoter where Acq_Deal_Rights_Code in (SELECT number FROM fn_Split_withdelemiter(@Acq_Deal_Rights_Code,',')) 
			IF(@Promoter_Count > 0)
			BEGIN
			 SET @Promoter_Message = 'Self Utilization Group details are  added for the deal'
			END
			ELSE
			BEGIN
			SET @Promoter_Message = 'Self Utilization Group details are not added for the deal'
			END

		END
		ELSE IF(@Module_code = 35)
		BEGIN
			SELECT  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Syndication'
			FROM Syn_Deal WHERE Syn_Deal_Code = @RecordCode
		END
		ELSE IF(@Module_code = 163)
		BEGIN
			SELECT  @DealNo = Agreement_No, @BU_Code = Business_Unit_Code, @DealType = 'Music'
			FROM Music_Deal WHERE Music_Deal_Code = @RecordCode
		END

		DECLARE 
		@Agreement_No VARCHAR(MAX) = '', @Agreement_Date VARCHAR(MAX) = '', @Deal_Desc NVARCHAR(MAX) = '', 
		@Primary_Licensor NVARCHAR(MAX) = '', @Titles NVARCHAR(MAX) = '', @Max_Titles_In_Approval_Mail INT = 0, @Title_Count INT = 0,@BU_Name VARCHAR(MAX) = ''

		DECLARE @Created_By  VARCHAR(MAX) = '',
				@Creation_Date  VARCHAR(MAX) = '',
				@Last_Actioned_By  VARCHAR(MAX) = '',
				@Last_Actioned_Date  VARCHAR(MAX) = ''

		IF(@RecordCode > 0)
		BEGIN
			SELECT TOP 1 @Max_Titles_In_Approval_Mail = CAST(Parameter_Value AS INT) 
			FROM System_Parameter_New WHERE Parameter_Name = 'Max_Titles_In_Approval_Mail'

			IF(@Module_code = 30)
			BEGIN
				PRINT 'Acquisition Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Desc, @Primary_Licensor = V.Vendor_Name,@BU_Name = BU.Business_Unit_Name,
					@Created_By = ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') ,
					@Creation_Date = CONVERT(VARCHAR(15), ad.Inserted_On, 106),
					@Last_Actioned_By =ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') ,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), ad.Last_Updated_Time, 106)
				FROM Acq_Deal AD
					INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = AD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = AD.Last_Action_By
				WHERE Acq_Deal_Code = @RecordCode
			
				SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Acq_Deal_Movie where Acq_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT  @Titles += CASE  WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Acq_Deal_Movie ADM
						INNER JOIN Title T ON ADM.Title_Code = T.Title_Code
						WHERE Acq_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@Module_code = 35)
			BEGIN
				PRINT 'Syndication Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = Deal_Description, @Primary_Licensor = V.Vendor_Name, @BU_Name = BU.Business_Unit_Name,
					@Created_By = ISNULL(UPPER(LEFT(U1.First_Name,1))+LOWER(SUBSTRING(U1.First_Name,2,LEN(U1.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Middle_Name,1))+LOWER(SUBSTRING(U1.Middle_Name,2,LEN(U1.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U1.Last_Name,1))+LOWER(SUBSTRING(U1.Last_Name,2,LEN(U1.Last_Name))), '') ,
					@Creation_Date = CONVERT(VARCHAR(15), SD.Inserted_On, 106),
					@Last_Actioned_By =ISNULL(UPPER(LEFT(U2.First_Name,1))+LOWER(SUBSTRING(U2.First_Name,2,LEN(U2.First_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Middle_Name,1))+LOWER(SUBSTRING(U2.Middle_Name,2,LEN(U2.Middle_Name))), '') 
								+ ' ' + ISNULL(UPPER(LEFT(U2.Last_Name,1))+LOWER(SUBSTRING(U2.Last_Name,2,LEN(U2.Last_Name))), '') ,
					@Last_Actioned_Date = CONVERT(VARCHAR(15), SD.Last_Updated_Time, 106)
				FROM Syn_Deal SD
					INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
					LEFT JOIN Users U1 ON U1.Users_Code = SD.Inserted_By
					LEFT JOIN Users U2 ON U2.Users_Code = SD.Last_Action_By
				WHERE Syn_Deal_Code = @RecordCode

				SELECT @Title_Count =  COUNT(DISTINCT Title_Code) FROM Syn_Deal_Movie where Syn_Deal_Code = @RecordCode
				IF( @Title_Count > @Max_Titles_In_Approval_Mail)
				BEGIN
					SET @Titles =  CAST(@Title_Count AS VARCHAR) + ' title(s)'
				END
				ELSE
				BEGIN
					SELECT @Titles += CASE WHEN @Titles != ''  THEN  ', '+ Title_Name ELSE Title_Name END
					FROM (
						SELECT DISTINCT T.Title_Name FROM Syn_Deal_Movie SDM
						INNER JOIN Title T ON SDM.Title_Code = T.Title_Code
						WHERE Syn_Deal_Code = @RecordCode
					) AS A
				END
			END
			ELSE IF(@module_code = 163)
			BEGIN
				PRINT 'Music Deal Module'
				SELECT TOP 1 
					@Agreement_No = Agreement_No, @Agreement_Date = CONVERT(VARCHAR(15), Agreement_Date, 106), 
					@Deal_Desc = [Description], @Primary_Licensor = V.Vendor_Name, @Titles = ML.Music_Label_Name,@BU_Name = BU.Business_Unit_Name
				FROM Music_Deal MD
					INNER JOIN Vendor V ON MD.Primary_Vendor_Code = V.Vendor_Code
					INNER JOIN Music_Label ML ON ML.Music_Label_Code = MD.Music_Label_Code
					INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = MD.Business_Unit_Code
				WHERE Music_Deal_Code = @RecordCode
			END
		END
	
		/* SELECT SITE URL */
		DECLARE @DefaultSiteUrlHold NVARCHAR(500) ,  @Is_RU_Content_Category CHAR(1), @BU_CC NVARCHAR(MAX) = 'Business Unit'
		SELECT @DefaultSiteUrl_Param = DefaultSiteUrl, @DefaultSiteUrlHold = DefaultSiteUrl FROM System_Param
		SET @MailSubjectCr = @DealType + ' Deal - (' + @DealNo + ') is waiting for approval' 

		SELECT @Is_RU_Content_Category = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_RU_Content_Category'

		IF(@Is_RU_Content_Category = 'Y')
			SET  @BU_CC= 'Content Category'

		--@Primary_User_Code is nothing by group code 
		/* TO SEND EMAIL TO INDIVIDUAL USER */
		DECLARE @Primary_User_Code INT = 0
		SELECT TOP 1 @Primary_User_Code = Group_Code  
		FROM Module_Workflow_Detail 
		WHERE Is_Done = 'N' AND Module_Code = @Module_code AND Record_Code = @RecordCode 
		ORDER BY Module_Workflow_Detail_Code

		/* CURSOR START */
		DECLARE Cur_On_Rejection CURSOR KEYSET FOR 
		SELECT DISTINCT U2.Email_Id ,ISNULL(U2.First_Name,'') + ' ' + ISNULL(U2.Middle_Name,'') + ' ' + ISNULL(U2.Last_Name,'') + 
		'   ('+ ISNULL(SG.Security_Group_Name,'') + ')', SG.Security_Group_Name, U2.Security_Group_Code, U2.Users_Code 
		FROM Users U1
			INNER JOIN Users_Business_Unit UBU ON UBU.Business_Unit_Code IN (@BU_Code)
			INNER JOIN Users U2 ON U1.Security_Group_Code = U2.Security_Group_Code AND UBU.Users_Code = U2.Users_Code
			INNER JOIN Security_Group SG ON SG.Security_Group_Code = U1.Security_Group_Code
		WHERE U1.Security_Group_Code = @Primary_User_Code AND U1.Is_Active = 'Y' AND U2.Is_Active = 'Y'


		OPEN Cur_On_Rejection
		FETCH NEXT FROM Cur_On_Rejection INTO @Cur_email_id,@Cur_first_name,@Cur_security_group_name,@Cur_security_group_code,@Cur_user_code
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
				
				SELECT @DefaultSiteUrl = @DefaultSiteUrl_Param + '?Action=' + @RedirectToApprovalList + '&Code=' + cast(@RecordCode as varchar(50)) + '&Type=' + CAST(@module_code AS VARCHAR(500)) + '&Req=SA'
				
				IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
					SET @Email_Table =	'<table class="tblFormat" >
					<tr>
						<td align="center" width="12%" class="tblHead">Agreement No.</td>      
						<td align="center" width="12%" class="tblHead">Agreement Date</td>      
						<td align="center" width="17%" class="tblHead">Deal Description</td>      
						<td align="center" width="12%" class="tblHead">Primary Licensor</td>      
						<td align="center" width="20%" class="tblHead">Title(s)</td>
						<td align="center" width="12%"  class="tblHead">'+@BU_CC+'</td>
					'
				END
				ELSE
				BEGIN 
					SET @Email_Table =	
					'<table class="tblFormat" style="width:100%"> 
						 <tr>
							<td align="center" width="9%" class="tblHead">Agreement No.</td>    
							<td align="center" width="9%" class="tblHead">Agreement Date</td> 
							<td align="center" width="9%" class="tblHead">Created By</td> 
							<td align="center" width="9%" class="tblHead">Creation Date</td> 
							<td align="center" width="9%" class="tblHead">Deal Description</td> 
							<td align="center" width="9%" class="tblHead">Primary Licensor</td>   
							<td align="center" width="9%" class="tblHead">Title(s)</td>
							<td align="center" width="9%" class="tblHead">'+@BU_CC+'</td>
							<td align="center" width="9%" class="tblHead">Last Actioned By</td>
							<td align="center" width="9%" class="tblHead">Last Actioned Date</td>
					'
				END


			   IF(@DealType = 'Acquisition')
			   BEGIN
					SET @Email_Table += '<td align="center" width="10%" class="tblHead">Self Utilization</td>'
			   END   

			   SET @Email_Table += '</tr>'
			   
			   IF(@module_code = 163 OR @Is_RU_Content_Category <> 'Y')
				BEGIN
				 SET @Email_Table += '<tr>      
						<td align="center" class="tblData">{Agreement_No}</td>     
						<td align="center" class="tblData">{Agreement_Date}</td>     
						<td align="center" class="tblData">{Deal_Desc}</td>     
						<td align="center" class="tblData">{Primary_Licensor}</td>  
						<td align="center" class="tblData">{Titles}</td>
						<td align="center" class="tblData">{BU_Name}</td>
				'
				END
				ELSE
				BEGIN
					 SET @Email_Table += ' <tr>
						<td align="center" class="tblData">{Agreement_No}</td>   
						<td align="center" class="tblData">{Agreement_Date}</td>    
						<td align="center" class="tblData">{Created_By}</td>    
						<td align="center" class="tblData">{Creation_Date}</td>    
						<td align="center" class="tblData">{Deal_Desc}</td>    
						<td align="center" class="tblData">{Primary_Licensor}</td>   
						<td align="center" class="tblData">{Titles}</td> 
						<td align="center" class="tblData">{BU_Name}</td> 
						<td align="center" class="tblData">{Last_Actioned_By}</td> 
						<td align="center" class="tblData">{Last_Actioned_Date}</td> 
					'
				END
			   IF(@DealType = 'Acquisition')
			   BEGIN
					SET @Email_Table += '<td align="center" class="tblData">{Promoter}</td>'
				END   
			
			SET @Email_Table += '</tr></table>'

				
				--REPLACE ALL THE PARAMETER VALUE
				SELECT @body1 = template_desc FROM Email_Template WHERE Template_For='A' 
				SET @body1 = replace(@body1,'{login_name}',@Cur_first_name)
				SET @body1 = replace(@body1,'{deal_no}',@DealNo)
				SET @body1 = replace(@body1,'{deal_type}',@DealType)
				set @body1 = replace(@body1,'{click here}',@DefaultSiteUrl)
				SET @body1 = replace(@body1,'{link}',@DefaultSiteUrl)

				SET @Email_Table = replace(@Email_Table,'{Agreement_No}',@Agreement_No)  
				SET @Email_Table = REPLACE(@Email_Table,'{Agreement_Date}',@Agreement_Date)  
				SET @Email_Table = REPLACE(@Email_Table,'{Deal_Desc}',@Deal_Desc)  
				SET @Email_Table = replace(@Email_Table,'{Primary_Licensor}',@Primary_Licensor)  
				SET @Email_Table = replace(@Email_Table,'{Titles}',@Titles)  
				SET @Email_Table = replace(@Email_Table,'{BU_Name}',@BU_Name)  
				IF(@DealType = 'Acquisition')
				BEGIN
					SET @Email_Table = replace(@Email_Table,'{Promoter}',@Promoter_Message)  
				END   

				IF(@module_code <> 163 AND @Is_RU_Content_Category = 'Y')
				BEGIN
					SET @Email_Table = REPLACE(@Email_Table,'{Created_By}',@Created_By)  
					SET @Email_Table = REPLACE(@Email_Table,'{Creation_Date}',@Creation_Date)  
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_By}', @Last_Actioned_By)
					SET @Email_Table = replace(@Email_Table,'{Last_Actioned_Date}', @Last_Actioned_Date)
				END

				SET @CC = ''
				--IF(@Is_Mail_Send_To_Group='Y')
				--BEGIN
				--	SELECT @CC = @CC + ';' + email_id FROM Users U
				--	INNER JOIN Users_Business_Unit UBU ON U.Users_Code =UBU.Users_Code AND 
				--	UBU.Business_Unit_Code IN (@BU_Code)
				--	WHERE security_group_code IN (@Cur_security_group_code) 
				--	AND UBU.Users_Code NOT IN(@Cur_user_code)
				--END
				
				SET @body1 = replace(@body1,'{table}',@Email_Table)

				DECLARE @DatabaseEmail_Profile varchar(200)	
				SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
				
				EXEC msdb.dbo.sp_send_dbmail @profile_name = @DatabaseEmail_Profile,
				@Recipients =  @Cur_email_id,
				@Copy_recipients = @CC,
				@subject = @MailSubjectCr,
				@body = @body1,@body_format = 'HTML';  

				INSERT INTO Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id)
				SELECT @Email_Config_Code, GETDATE(), 'N', @Email_Table, @Cur_user_code, 'Send for Approval', @Cur_email_id

				--select @body1

			END
			FETCH NEXT FROM Cur_On_Rejection INTO @Cur_email_id,@Cur_first_name,@Cur_security_group_name,@Cur_security_group_code,@Cur_user_code
		END

		CLOSE Cur_On_Rejection
		DEALLOCATE Cur_On_Rejection
		/* CURSOR END */
					 --select @DefaultSiteUrl
		SET @Is_Error='N'
	END TRY
	BEGIN CATCH
		SET @Is_Error='Y'
		CLOSE Cur_On_Rejection
		DEALLOCATE Cur_On_Rejection

		INSERT INTO	ERRORON_SENDMAIL_FOR_WORKFLOW 
		SELECT 
			ERROR_NUMBER() AS ERRORNUMBER,
			ERROR_SEVERITY() AS ERRORSEVERITY,		
			ERROR_STATE() AS ERRORSTATE,
			ERROR_PROCEDURE() AS ERRORPROCEDURE,
			ERROR_LINE() AS ERRORLINE,
			ERROR_MESSAGE() AS ERRORMESSAGE;
	END CATCH							
END



--update Email_Template SET template_desc =
--'<html>   <head>    <style>     table.tblFormat     {      border:1px solid black;      border-collapse:collapse;     }    
-- th.tblHead     {      border:1px solid black;        color: #ffffff ;       background-color: #585858;      font-family:verdana;      
-- font-size:12px; font-weight:bold    }     td.tblData     {      border:1px solid black;       vertical-align:top;      font-family:verdana;      
-- font-size:12px;     }          .textFont     {      color: black ;       font-family:verdana;      font-size:12px;     }    
--       #divFooter     {      color: gray;     }    </style>   </head>   <body>    <div class="textFont">     Dear&nbsp;{login_name},<br />
--	   <br />     The {deal_type} Deal No: <b>{deal_no}</b> is waiting for approval.<br /><br />   
--	     Please <a href=''{link}'' target=''_blank''><b>click here</b></a> to approve {deal_type} deal<br /><br />    </div>    
--		 {table}
--		 <br /><br /><br /><br /> 
--				     <div id="divFooter" class="textFont">    
--					  This email is generated by RightsU    </div>   </body>  </html>' WHERE Template_For='A'
GO
PRINT N'Altering [dbo].[USP_UPDATE_ACQ_DEAL]...';


GO


ALTER PROCEDURE [dbo].[USP_UPDATE_ACQ_DEAL]
(
 @Acq_Deal_Code INT
,@Version varchar(50)
,@Agreement_Date datetime
,@Deal_Desc NVARCHAR(1000)
,@Deal_Type_Code int
,@Year_Type char(2) 
,@Entity_Code int
,@Is_Master_Deal char(1)
,@Category_Code int
,@Vendor_Code int
,@Vendor_Contacts_Code int
,@Currency_Code int
,@Exchange_Rate numeric(10,3)
,@Ref_No NVARCHAR(100)
,@Attach_Workflow char(1)
,@Deal_Workflow_Status varchar(50)
,@Parent_Deal_Code int
,@Work_Flow_Code int
,@Amendment_Date datetime
,@Is_Released char(1)
,@Release_On datetime
,@Release_By int
,@Is_Completed char(1)
,@Is_Active char(1)
,@Content_Type char(2)
,@Payment_Terms_Conditions NVARCHAR(4000)
,@Status char(1)
,@Is_Auto_Generated char(1)
,@Is_Migrated char(1)
,@Cost_Center_Id int
,@Master_Deal_Movie_Code_ToLink int
,@BudgetWise_Costing_Applicable varchar(2)
,@Validate_CostWith_Budget varchar(2)
,@Deal_Tag_Code int
,@Business_Unit_Code int
,@Ref_BMS_Code varchar(100)
,@Remarks NVARCHAR(4000)
,@Rights_Remarks NVARCHAR(4000)
,@Payment_Remarks NVARCHAR(4000)
,@Inserted_By int
,@Inserted_On datetime
,@Last_Updated_Time datetime
,@Last_Action_By int
,@Lock_Time datetime
,@Role_Code Int
,@Channel_Cluster_Code Int
,@Is_Auto_Push CHAR(1)
,@Deal_Segment_Code INT
,@Revenue_Vertical_Code INT
,@Confirming_Party NVARCHAR(MAX)
)
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 08-October-2014
-- Description:	Updates Acq Deal Call From EF Table Mapping
-- =============================================
BEGIN

UPDATE [Acq_Deal]
   SET [Version] = @Version
      ,[Agreement_Date] = @Agreement_Date
      ,[Deal_Desc] = @Deal_Desc
      ,[Deal_Type_Code] = @Deal_Type_Code
      ,[Year_Type] = @Year_Type
      ,[Entity_Code] = @Entity_Code
      ,[Is_Master_Deal] = @Is_Master_Deal
      ,[Category_Code] = @Category_Code
      ,[Vendor_Code] = @Vendor_Code
      ,[Vendor_Contacts_Code] = @Vendor_Contacts_Code
      ,[Currency_Code] = @Currency_Code
      ,[Exchange_Rate] = @Exchange_Rate
      ,[Ref_No] = @Ref_No
      ,[Attach_Workflow] = @Attach_Workflow
      ,[Deal_Workflow_Status] = @Deal_Workflow_Status
      ,[Parent_Deal_Code] = @Parent_Deal_Code
      ,[Work_Flow_Code] = @Work_Flow_Code
      ,[Amendment_Date] = @Amendment_Date
      ,[Is_Released] = @Is_Released
      ,[Release_On] = @Release_On
      ,[Release_By] = @Release_By
      ,[Is_Completed] = @Is_Completed
      ,[Is_Active] = @Is_Active
      ,[Content_Type] = @Content_Type
      ,[Payment_Terms_Conditions] = @Payment_Terms_Conditions
      ,[Status] = @Status
      ,[Is_Auto_Generated] = @Is_Auto_Generated
      ,[Is_Migrated] = @Is_Migrated
      ,[Cost_Center_Id] = @Cost_Center_Id
      ,[Master_Deal_Movie_Code_ToLink] = @Master_Deal_Movie_Code_ToLink
      ,[BudgetWise_Costing_Applicable] = @BudgetWise_Costing_Applicable
      ,[Validate_CostWith_Budget] = @Validate_CostWith_Budget
      ,[Deal_Tag_Code] = @Deal_Tag_Code
      ,[Business_Unit_Code] = @Business_Unit_Code
      ,[Ref_BMS_Code] = @Ref_BMS_Code
      ,[Remarks] = @Remarks
      ,[Rights_Remarks] = @Rights_Remarks
      ,[Payment_Remarks] = @Payment_Remarks
      ,[Inserted_By] = @Inserted_By
      ,[Inserted_On] = @Inserted_On
      ,[Last_Updated_Time] = @Last_Updated_Time
      ,[Last_Action_By] = @Last_Action_By
      ,[Lock_Time] = @Lock_Time
	  ,[Role_Code] = @Role_Code
	  ,[Channel_Cluster_Code] = @Channel_Cluster_Code
	  ,[Is_Auto_Push] = @Is_Auto_Push
	  ,[Deal_Segment_Code] = @Deal_Segment_Code
	  ,[Revenue_Vertical_Code] = @Revenue_Vertical_Code
	  ,[Confirming_Party] = @Confirming_Party
 WHERE Acq_Deal_Code = @Acq_Deal_Code

END
GO
PRINT N'Altering [dbo].[USP_Validate_Rights_Duplication_UDT]...';


GO



ALTER PROCEDURE [dbo].[USP_Validate_Rights_Duplication_UDT]
(
	@Deal_Rights Deal_Rights READONLY,
	@Deal_Rights_Title Deal_Rights_Title  READONLY,
	@Deal_Rights_Platform Deal_Rights_Platform READONLY,
	@Deal_Rights_Territory Deal_Rights_Territory READONLY,
	@Deal_Rights_Subtitling Deal_Rights_Subtitling READONLY,
	@Deal_Rights_Dubbing Deal_Rights_Dubbing READONLY,
	@CallFrom CHAR(2)='AR',	
	@Debug CHAR(1)='N'
)
As
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 21-October-2014
-- Description:	Checks If User is trying to enter a Duplicate Deal
-- =============================================
Begin
   SET NOCOUNT ON
   DECLARE @RC int 
   
   
   IF(UPPER(@CallFrom)='AR' OR UPPER(@CallFrom)='AP')
   BEGIN
		If(UPPER(@CallFrom)='AR')
		Begin
			EXECUTE @RC = [USP_Validate_Rights_Duplication_UDT_ACQ] 
			 @Deal_Rights
			,@Deal_Rights_Title
			,@Deal_Rights_Platform
			,@Deal_Rights_Territory
			,@Deal_Rights_Subtitling
			,@Deal_Rights_Dubbing
			,@CallFrom
			,@Debug
			,0
		End
  END
 --  ELSE
	--BEGIN
	--	--IF(UPPER(@CallFrom)='SR')
	--	----BEGIN
	--	--EXECUTE @RC = [USP_Syn_Rights_Not_Acquire_And_Duplicate] 
	--	--   @Deal_Rights
	--	--  ,@Deal_Rights_Title
	--	--  ,@Deal_Rights_Platform
	--	--  ,@Deal_Rights_Territory
	--	--  ,@Deal_Rights_Subtitling
	--	--  ,@Deal_Rights_Dubbing
	--	--  ,@CallFrom
	--	--  ,@Debug	  
	--  -- EXECUTE @RC = [USP_Validate_Rights_Duplication_UDT_Syn] 
	--  -- @Deal_Rights
	--  --,@Deal_Rights_Title
	--  --,@Deal_Rights_Platform
	--  --,@Deal_Rights_Territory
	--  --,@Deal_Rights_Subtitling
	--  --,@Deal_Rights_Dubbing
	--  --,@CallFrom
	--  --,@Debug

	  
 -- END
  
End
GO
PRINT N'Altering [dbo].[USP_Check_Autopush_Ammend_Acq]...';


GO
ALTER PROC [dbo].[USP_Check_Autopush_Ammend_Acq]
(
	@AcqDealCode INT
)
AS
BEGIN
	DECLARE
		--@AcqDealCode INT = 25003, 
	    @StatusFlag CHAR(10) = '',
		@ISERROR CHAR(1),
		@NewSynDealCode_S INT
		IF EXISTS(SELECT TOP 1 SecondaryDataCode FROM AcqPreReqMappingData WHERE PrimaryDataCode = @AcqDealCode)
		BEGIN
			SELECT TOP 1 @NewSynDealCode_S = PrimaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEAL' AND SecondaryDataCode = @AcqDealCode
			SELECT @StatusFlag = Deal_Workflow_Status FROM RightsU_Plus_Testing.dbo.Syn_Deal Where Syn_Deal_Code =  @NewSynDealCode_S
			IF EXISTS(SELECT TOP 1  PrimaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEAL' AND SecondaryDataCode = @AcqDealCode)
			BEGIN
				IF(@StatusFlag = 'A')
					BEGIN
						SET @ISERROR = 'N'
					END
					ELSE
					BEGIN
						SET @ISERROR = 'Y'
					END
			END
			ELSE
			BEGIN
				SET @ISERROR = 'N'
			END
			END
		ELSE
		BEGIN
			PRINT 'NO VALIDATION'
			SET @ISERROR = 'N'
		END
			Select @ISERROR
		--Return @ISERROR
END
GO
PRINT N'Altering [dbo].[USP_Check_Autopush_Ammend_Syn]...';


GO
ALTER PROC [dbo].[USP_Check_Autopush_Ammend_Syn]
(
	@SynDealCode INT
)
AS
BEGIN
	DECLARE
		--@syndealcode INT = 2861, 
	    @StatusFlag CHAR(10) = '',
	    @IsAutoPush CHAR(1) = '',
		@ISERROR CHAR(1),
		@NewAcqDealCode_S INT

		SELECT TOP 1 @NewAcqDealCode_S = SecondaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEAL' AND PrimaryDataCode = @SynDealCode
		SELECT @StatusFlag = Deal_Workflow_Status FROM RightsU_Plus_Testing.dbo.Acq_Deal Where Acq_Deal_Code =  @NewAcqDealCode_S
	    SELECT @IsAutoPush = Is_Auto_Push FROM RightsU_Plus_Testing.dbo.Acq_Deal Where Acq_Deal_Code =  @NewAcqDealCode_S

	IF EXISTS(SELECT TOP 1  SecondaryDataCode FROM RightsU_Plus_Testing.dbo.AcqPreReqMappingData MD WHERE MD.MappingFor = 'ACQDEAL' AND PrimaryDataCode = @SynDealCode)
	BEGIN
		IF(@StatusFlag = 'A')
		BEGIN
			SET @ISERROR = 'N'
		END
		ELSE
		BEGIN
			SET @ISERROR = 'Y'
		END
	END
	ELSE
	BEGIN
		SET @ISERROR = 'N'
	END
			Select @ISERROR
			--SELECT @StatusFlag
			--SELECT @IsAutoPush
			--Return @ISERROR
END
GO
PRINT N'Altering [dbo].[USP_Syndication_Deal_List_Report]...';


GO
ALTER Procedure [dbo].[USP_Syndication_Deal_List_Report]
(
	@Agreement_No Varchar(100), 
	@Start_Date Varchar(30), 
	@End_Date Varchar(30), 
	@Deal_Tag_Code Int, 
	@Title_Codes Varchar(100), 
	@Business_Unit_code VARCHAR(100), 
	@Is_Pushback Varchar(100),
	@IS_Expired Varchar(100),
	@IS_Theatrical varchar(100),
	@SysLanguageCode INT,
	@DealSegment INT,
	@TypeOfFilm INT
)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date:	18 Feb 2015
-- Description:	Get Syndication Deal List Report Data
-- =============================================
BEGIN
	--DECLARE   
	--@Agreement_No Varchar(100)
	--, @Is_Master_Deal Varchar(2)
	--, @Start_Date Varchar(30)
	--, @End_Date Varchar(30)
	--, @Deal_Tag_Code Int
	--, @Title_Codes Varchar(100)
	--, @Business_Unit_code INT
	--, @Is_Pushback Varchar(100)
	--, @IS_Expired Varchar(100)
	--, @IS_Theatrical varchar(100)
	--, @SysLanguageCode INT
	--, @DealSegment INT
	--,@TypeOfFilm INT 
	
	--SET @Agreement_No = ''
	--SET @Start_Date= ''
	--SET @End_Date = ''
	--SET @Deal_Tag_Code = 0
	--SET @Title_Codes = ''
	--SET @Business_Unit_code = 1
	--SET @Is_Pushback = 'N'
	--SET @IS_Expired  = 'Y'
	--SET @IS_Theatrical='N'
	--SET @SysLanguageCode = 1
	--SET @DealSegment = 0
	--SET @TypeOfFilm = 3
	
	if CHARINDEX(',',@Business_Unit_code) > 0
	begin
	   set @Business_Unit_code = 0
	end
      
	DECLARE
	@Col_Head01 NVARCHAR(MAX) = '',  
	@Col_Head02 NVARCHAR(MAX) = '',  
	@Col_Head03 NVARCHAR(MAX) = '',
	@Col_Head04 NVARCHAR(MAX) = '', 
	@Col_Head05 NVARCHAR(MAX) = '', 
	@Col_Head06 NVARCHAR(MAX) = '', 
	@Col_Head07 NVARCHAR(MAX) = '', 
	@Col_Head08 NVARCHAR(MAX) = '', 
	@Col_Head09 NVARCHAR(MAX) = '', 
	@Col_Head10 NVARCHAR(MAX) = '', 
	@Col_Head11 NVARCHAR(MAX) = '', 
	@Col_Head12 NVARCHAR(MAX) = '', 
	@Col_Head13 NVARCHAR(MAX) = '', 
	@Col_Head14 NVARCHAR(MAX) = '', 
	@Col_Head15 NVARCHAR(MAX) = '', 
	@Col_Head16 NVARCHAR(MAX) = '', 
	@Col_Head17 NVARCHAR(MAX) = '', 
	@Col_Head18 NVARCHAR(MAX) = '', 
	@Col_Head19 NVARCHAR(MAX) = '', 
	@Col_Head20 NVARCHAR(MAX) = '', 
	@Col_Head21 NVARCHAR(MAX) = '', 
	@Col_Head22 NVARCHAR(MAX) = '', 
	@Col_Head23 NVARCHAR(MAX) = '', 
	@Col_Head24 NVARCHAR(MAX) = '', 
	@Col_Head25 NVARCHAR(MAX) = '', 
	@Col_Head26 NVARCHAR(MAX) = '', 
	@Col_Head27 NVARCHAR(MAX) = '', 
	@Col_Head28 NVARCHAR(MAX) = '', 
	@Col_Head29 NVARCHAR(MAX) = '', 
	@Col_Head30 NVARCHAR(MAX) = '', 
	@Col_Head31 NVARCHAR(MAX) = '', 
	@Col_Head32 NVARCHAR(MAX) = '', 
	@Col_Head33 NVARCHAR(MAX) = '', 
	@Col_Head34 NVARCHAR(MAX) = '', 
	@Col_Head35 NVARCHAR(MAX) = '', 
	@Col_Head36 NVARCHAR(MAX) = '', 
	@Col_Head37 NVARCHAR(MAX) = '', 
	@Col_Head38 NVARCHAR(MAX) = '',
	@Col_Head39 NVARCHAR(MAX) = '',
	@Col_Head40 NVARCHAR(MAX) = '',
	@Col_Head41 NVARCHAR(MAX) = '',
	@Col_Head42 NVARCHAR(MAX) = '',
	@Col_Head43 NVARCHAR(MAX) = '',
	@Col_Head44 NVARCHAR(MAX) = '',
	@Col_Head45 NVARCHAR(MAX) = '',
	@Col_Head46 NVARCHAR(MAX) = '',
	@Col_Head47 NVARCHAR(MAX) = '',
	@Col_Head48 NVARCHAR(MAX) = '',
	@Col_Head49 NVARCHAR(MAX) = '',
	@Col_Head50 NVARCHAR(MAX) = '',
	@Col_Head51 NVARCHAR(MAX) = ''

	BEGIN
		IF OBJECT_ID('tempdb..#TEMP_Syndication_Deal_List_Report') IS NOT NULL
		DROP TABLE #TEMP_Syndication_Deal_List_Report

		IF OBJECT_ID('tempdb..#TempSynDealListReport') IS NOT NULL
		DROP TABLE #TempSynDealListReport

		IF OBJECT_ID('tempdb..#AncData') IS NOT NULL
		DROP TABLE #AncData
		
		IF OBJECT_ID('tempdb..#RightTable') IS NOT NULL
		DROP TABLE #RightTable
		
		IF OBJECT_ID('tempdb..#PlatformTable') IS NOT NULL
		DROP TABLE #PlatformTable

		IF OBJECT_ID('tempdb..#RegionTable') IS NOT NULL
		DROP TABLE #RegionTable

		IF OBJECT_ID('tempdb..#LangTable') IS NOT NULL
		DROP TABLE #LangTable

		IF OBJECT_ID('tempdb..#RegionSubDubTable') IS NOT NULL
		DROP TABLE #RegionSubDubTable
		
		IF OBJECT_ID('tempdb..#TitleTable') IS NOT NULL
		DROP TABLE #TitleTable

		IF OBJECT_ID('tempdb..#DealTitleTable') IS NOT NULL
		DROP TABLE #DealTitleTable
	END

	BEGIN
		CREATE TABLE #RightTable(
			Syn_Deal_Code INT,
			Syn_Deal_Rights_Code INT,
			Platform_Codes NVARCHAR(MAX),
			Region_Codes NVARCHAR(MAX),
			SL_Codes NVARCHAR(MAX),
			DB_Codes NVARCHAR(MAX),
			Platform_Names NVARCHAR(MAX),
			Region_Name NVARCHAR(MAX),
			Subtitle NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			RunType NVARCHAR(MAX),
			RGType VARCHAR(10),
			SLType VARCHAR(10),
			DBType VARCHAR(10),
			Run_Type VARCHAR(100)
		)
		CREATE TABLE #PlatformTable(
			Platform_Codes NVARCHAR(MAX),
			Platform_Names NVARCHAR(MAX)
		)
		CREATE TABLE #RegionTable(
			Region_Codes NVARCHAR(MAX),
			Region_Names NVARCHAR(MAX),
			Region_Type NVARCHAR(10)
		)
		CREATE TABLE #LangTable(
			Lang_Codes NVARCHAR(MAX),
			Lang_Names NVARCHAR(MAX),
			Lang_Type NVARCHAR(10)
		)		
		CREATE TABLE #TitleTable(
			Title_Code INT,
			Eps_From INT,
			Eps_To INT,
			Director NVARCHAR(MAX),
			StarCast NVARCHAR(MAX),
			Genre NVARCHAR(MAX)
		)
		CREATE TABLE #DealTitleTable(
			Syn_Deal_Code INT,
			Title_Code INT,
			Eps_From INT,
			Eps_To INT,
			Run_Type VARCHAR(10)
		)
		CREATE TABLE #TEMP_Syndication_Deal_List_Report(
			Syn_Deal_Right_Code VARCHAR(100),
			Business_Unit_Name NVARCHAR(MAX),
			Title_Code INT,
			Title_Name NVARCHAR(MAX),
			Episode_From INT,
			Episode_To INT,
			Deal_Type_Code INT,
			Director NVARCHAR(MAX),
			Star_Cast NVARCHAR(MAX),
			Genre NVARCHAR(MAX),
			Title_Language NVARCHAR(MAX),
			year_of_production INT,
			Syn_Deal_code INT,
			Agreement_No VARCHAR(MAX),
			Deal_Description NVARCHAR(MAX),
			Reference_No NVARCHAR(MAX),
			Agreement_Date DATETIME,
			Deal_Tag_Code INT,
			Deal_Tag_Description NVARCHAR(MAX),
			Party NVARCHAR(MAX),
			Party_Master NVARCHAR(MAX),
			Platform_Name NVARCHAR(MAX),
			Right_Start_Date DATETIME, 
			Right_End_Date DATETIME,
			Is_Title_Language_Right CHAR(1),
			Country_Territory_Name NVARCHAR(MAX),
			Is_Exclusive CHAR(1),
			Subtitling NVARCHAR(MAX),
			Dubbing NVARCHAR(MAX),
			Sub_Licencing VARCHAR(MAX),
			Is_Tentative CHAR(1),
			Is_ROFR CHAR(1),
			First_Refusal_Date DATETIME,
			Restriction_Remarks NVARCHAR(MAX),
			Holdback_Platform NVARCHAR(MAX),
			Holdback_Rights NVARCHAR(MAX),
			Blackout NVARCHAR(MAX),
			General_Remark NVARCHAR(MAX),
			Rights_Remarks NVARCHAR(MAX),
			Payment_Remarks NVARCHAR(MAX),
			Right_Type VARCHAR(MAX),
			Right_Term VARCHAR(MAX),
			Deal_Workflow_Status VARCHAR(MAX),
			Is_Pushback CHAR(1),
			Run_Type CHAR(9),
			Is_Attachment CHAR(3),
			[Program_Name] NVARCHAR(MAX),
			Promtoer_Group NVARCHAR(MAX),
			Promtoer_Remarks NVARCHAR(MAX),
			Deal_Segment NVARCHAR(MAX),
			Revenue_Vertical NVARCHAR(MAX),
			Category_Name VARCHAR(MAX),
			Columns_Value_Code INT
			
		)
	END

	DECLARE @IsDealSegment VARCHAR(100), @IsRevenueVertical VARCHAR(100), @IsTypeOfFilm VARCHAR(MAX), @Columns_Code INT
	SELECT @IsDealSegment = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Deal_Segment' 
	SELECT @IsRevenueVertical = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Gen_Revenue_Vertical' 
	SELECT @IsTypeOfFilm = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_AcqSyn_Type_Of_Film' 
	SELECT @Columns_Code = Columns_Code FROM Extended_Columns WHERE UPPER(Columns_Name) = 'TYPE OF FILM'

	BEGIN
		INSERT INTO #TEMP_Syndication_Deal_List_Report
		(
			Syn_Deal_Right_Code
			,Business_Unit_Name
			,Title_Code
			,Title_Name
			,Episode_From,Episode_To,Deal_Type_Code
			,Director, Star_Cast ,Genre
			, Title_Language, year_of_production, Syn_Deal_code 
			,Deal_Description, Reference_No, Agreement_No, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party, Party_Master
			,Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right
			,Country_Territory_Name
			,Is_Exclusive
			,Subtitling
			,Dubbing
			,Sub_Licencing
			,Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks
			,Holdback_Platform
			,Holdback_Rights 
			,Blackout
			,General_Remark, Rights_Remarks, Payment_Remarks, Right_Type
			,Right_Term
			,Deal_Workflow_Status
			,Is_Pushback
			,Run_Type
			,Is_Attachment
			,[Program_Name]
			,Promtoer_Group
			,Promtoer_Remarks
			,Category_Name
			,Columns_Value_Code
		)
		SELECT 
			SDR.Syn_Deal_Rights_Code
			,BU.Business_Unit_Name
			,T.Title_Code
			,T.Title_Name
			,CAST(SDRT.Episode_From AS INT),SDRT.Episode_To,SD.Deal_Type_Code 
			--, dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) Director
			--, dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) Star_Cast
			--, dbo.UFN_Get_Title_Genre(t.title_code) Genre
			,'' AS Director
			,'' AS Star_Cast
			,'' AS Genre
			, ISNULL(L.language_name, '') AS Title_Language, t.year_of_production, SD.Syn_Deal_Code
			, SD.Deal_Description, SD.Ref_No, SD.Agreement_No, CAST(SD.Agreement_Date as date), SD.Deal_Tag_Code, TG.Deal_Tag_Description, V.Vendor_Name,PG.Party_Group_Name
			--, [dbo].[UFN_Get_Platform_Name](SDR.Syn_Deal_Rights_Code, 'SR') Platform_Name
			,'' AS Platform_Name
			, CAST(SDR.Right_Start_Date as date), CAST(SDR.Right_End_Date as date), SDR.Is_Title_Language_Right
			--,CASE (DBO.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, '',''))
			--	WHEN '' THEN DBO.UFN_Get_Rights_Territory(SDR.Syn_Deal_Rights_Code, '')
			--	ELSE DBO.UFN_Get_Rights_Country(SDR.Syn_Deal_Rights_Code, '','')
			-- END AS  Country_Territory_Name
			,'' AS  Country_Territory_Name
			,SDR.Is_Exclusive AS Is_Exclusive
			--, DBO.UFN_Get_Rights_Subtitling(SDR.Syn_Deal_Rights_Code, '') Subtitling
			--,DBO.UFN_Get_Rights_Dubbing(SDR.Syn_Deal_Rights_Code, '') Dubbing
			,'' AS Subtitling
			,'' AS Dubbing
			,CASE LTRIM(RTRIM(SDR.Is_Sub_License))
				WHEN 'Y' THEN SL.Sub_License_Name
				ELSE 'No Sub Licensing'
			 END SubLicencing
			, SDR.Is_Tentative, SDR.Is_ROFR, SDR.ROFR_Date AS First_Refusal_Date, SDR.Restriction_Remarks AS Restriction_Remarks
			, [dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](SDR.Syn_Deal_Rights_Code, 'SR','P') Holdback_Platform
			, [dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](SDR.Syn_Deal_Rights_Code, 'SR','R') Holdback_Right
			--, [dbo].[UFN_Get_Blackout_Period](SDR.Syn_Deal_Rights_Code, 'SR') Blackout
			--,'' as Holdback_Platform
			--,'' as Holdback_Right
			,'' as Blackout
			, SD.Remarks AS General_Remark, SD.Rights_Remarks AS Rights_Remarks, SD.Payment_Terms_Conditions AS Payment_Remarks, SDR.Right_Type
			, CASE SDR.Right_Type
				WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](SDR.Right_Start_Date, Right_End_Date, Term) 
				WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
				WHEN 'U' THEN 'Perpetuity'
			 END Right_Term
			,CASE UPPER(LTRIM(RTRIM(ISNULL(SD.Deal_Workflow_Status, '')))) 
				WHEN 'N' THEN 'Created'
				WHEN 'W' THEN 'Sent for authorization'
				WHEN 'A' THEN 'Approved' 
				WHEN 'R' THEN 'Declined'
				WHEN 'AM' THEN 'Amended'
				ELSE Deal_Workflow_Status 
			 END AS Deal_Workflow_Status
			,ISNULL(SDR.Is_Pushback, 'N')
			, '' AS Run_Type --[dbo].[UFN_Get_Run_Type] (SD.Syn_Deal_Code,@Title_Codes) AS Run_Type
			,CASE WHEN (SELECT count(*) FROM Syn_Deal_Attachment SDT WHERE SDT.Syn_Deal_Code = SD.Syn_Deal_Code) > 0 THEN 'Yes'
					   ELSE 'No'
			 END AS Is_Attachment
			, P.Program_Name as Program_Name
			, dBO.UFN_Get_Rights_Promoter_Group_Remarks(SDR.Syn_Deal_Rights_Code,'P','S') as Promoter_Group_Name
			, dBO.UFN_Get_Rights_Promoter_Group_Remarks(SDR.Syn_Deal_Rights_Code,'R','S') as Promoter_Remarks_Name
			, C.Category_Name AS Category_Name,MEC.Columns_Value_Code
		FROM Syn_Deal SD
			INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = SD.Business_Unit_Code
			INNER JOIN Syn_Deal_Rights SDR ON SD.Syn_Deal_Code = SDR.Syn_Deal_Code AND ISNULL(SDR.Right_Status, '') = 'C'
			INNER JOIN Syn_Deal_Rights_Process_Validation SDRTV ON SDRTV.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code AND LTRIM(RTRIM(SDRTV.Status)) = 'D'
			INNER JOIN Syn_Deal_Rights_Title SDRT On SDR.Syn_Deal_Rights_Code = SDRT.Syn_Deal_Rights_Code 
			INNER JOIN Vendor V ON SD.Vendor_Code = V.Vendor_Code
			LEFT JOIN Party_Group PG ON V.Party_Group_Code = PG.Party_Group_Code
			LEFT JOIN Sub_License SL ON SDR.Sub_License_Code = SL.Sub_License_Code
			INNER JOIN Deal_Tag TG On SD.Deal_Tag_Code = TG.Deal_Tag_Code
			INNER JOIN Title T On SDRT.Title_Code = T.title_code
			LEFT JOIN Program P on T.Program_Code = P.Program_Code
			LEFT JOIN Language L on T.Title_Language_Code = L.language_code
			INNER JOIN Category C ON SD.Category_Code = C.Category_Code
			LEFT JOIN Map_Extended_columns MEC ON MEC.Record_Code = T.Title_Code AND MEC.Columns_Code = @Columns_Code
		WHERE  
			((@IS_Theatrical = 'Y' AND @IS_Theatrical = SDR.Is_Theatrical_Right) OR (@IS_Theatrical <> 'Y')) AND 
			--sdr.Is_Theatrical_Right = @IS_Theatrical  And
			(ISNULL(CONVERT(datetime,SDR.Right_Start_Date,1) , '') >= CONVERT(datetime,@Start_Date,1) OR CONVERT(datetime,@Start_Date,1) = '')		
			AND (ISNULL(CONVERT(datetime,SDR.Right_End_Date,1), '') <= CONVERT(datetime,@End_Date,1) OR CONVERT(datetime,@End_Date,1) = '')
			AND SD.Agreement_No like '%' + @Agreement_No + '%' 
			AND (ISNULL(SDR.Is_Pushback, 'N') = @Is_Pushback OR @Is_Pushback = '')
			AND (SD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
			--AND(@Business_Unit_code = '' OR SD.Business_Unit_Code in(select number from fn_Split_withdelemiter(@Title_Codes,',')))
			AND (SD.Business_Unit_Code = CAST(@Business_Unit_code AS INT) OR CAST(@Business_Unit_code AS INT) = 0)
			AND (@Title_Codes = '' OR SDRT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Codes,',')))
			AND (SDR.Syn_Deal_Rights_Code In 
			(SELECT SDRP.Syn_Deal_Rights_Code FROM Syn_Deal_Rights_Platform SDRP 
			Inner Join [Platform] P ON SDRP.Platform_Code = P.Platform_Code AND P.Applicable_For_Demestic_Territory = @IS_Theatrical 
			AND @IS_Theatrical = 'Y'
			) OR @IS_Theatrical = 'N')
			AND (@IS_Expired ='Y' OR (ISNULL(CONVERT(datetime,SDR.Right_End_Date,1), GETDATE()) >= GETDATE() AND @IS_Expired ='N'))
	END

	BEGIN
		INSERT INTO #RightTable(Syn_Deal_Code,Syn_Deal_Rights_Code,Platform_Codes,Platform_Names,Region_Name,Subtitle,Dubbing,RunType)
		SELECT Syn_Deal_Code,Syn_Deal_Right_Code,null,null,null,null,null,null  FROM #TEMP_Syndication_Deal_List_Report

		INSERT INTO #TitleTable(Title_Code,Eps_From,Eps_To,Director,StarCast,Genre)
		Select DISTINCT Title_Code,Episode_From,Episode_To,null,null,null FROM #TEMP_Syndication_Deal_List_Report

		INSERT INTO #DealTitleTable(Syn_Deal_Code,Title_Code,Eps_From,Eps_To,Run_Type)
		SELECT DISTINCT Syn_Deal_code,Title_Code,Episode_From,Episode_To,null FROM #TEMP_Syndication_Deal_List_Report
	END


	
	BEGIN
		IF(@IsDealSegment = 'Y' )
		BEGIN
			DELETE tsdlr FROM #TEMP_Syndication_Deal_List_Report tsdlr
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = tsdlr.Syn_Deal_Code
			WHERE AD.Deal_Segment_Code <> @DealSegment AND @DealSegment > 0

			UPDATE tadlr
			SET Deal_Segment = DS.Deal_Segment_Name
			FROM #TEMP_Syndication_Deal_List_Report tadlr
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = tadlr.Syn_Deal_Code
			INNER JOIN Deal_Segment DS ON DS.Deal_Segment_Code = AD.Deal_Segment_Code

		END

		IF(@IsRevenueVertical = 'Y')
		BEGIN
			UPDATE tadlr
			SET Revenue_Vertical = DS.Revenue_Vertical_Name
			FROM #TEMP_Syndication_Deal_List_Report tadlr
			INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = tadlr.Syn_Deal_Code
			INNER JOIN Revenue_Vertical DS ON DS.Revenue_Vertical_Code = AD.Revenue_Vertical_Code
		END

		IF(@IsTypeOfFilm = 'Y' AND @TypeOfFilm > 0)
		BEGIN
			DELETE FROM #TEMP_Syndication_Deal_List_Report
			WHERE (Columns_Value_Code <> @TypeOfFilm ) OR Columns_Value_Code IS NULL
		END
		
		
		PRINT 'Director, StartCast Insert and update for Primary Rights'
			
		UPDATE TT SET TT.Director = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 1),TT.StarCast = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 2),TT.Genre = dbo.UFN_Get_Title_Genre(TT.TItle_Code)  
		FROM #TitleTable TT
	
		UPDATE TADLR SET TADLR.Director = TT.Director,TADLR.Star_Cast = TT.StarCast,TADLR.Genre = TT.Genre
		FROM #TEMP_Syndication_Deal_List_Report TADLR
		INNER JOIN #TitleTable TT ON TADLR.Title_Code = TT.Title_Code AND TADLR.Episode_From = TT.Eps_From AND TADLR.Episode_To = Eps_To
	
		PRINT 'Platform Insert and update for Primary Rights'
		
		UPDATE RT SET RT.Platform_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(AADRP.Platform_Code AS NVARCHAR(MAX)) from  Syn_Deal_Rights_Platform AADRP 
		WHERE  AADRP.Syn_Deal_Rights_Code = RT.Syn_Deal_Rights_Code  --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
	
		INSERT INTO #PlatformTable(Platform_Codes,Platform_Names)
		SELECT DISTINCT Platform_Codes,Platform_Names FROM #RightTable
		
		UPDATE PT SET PT.Platform_Names = a.Platform_Hierarchy
		from #PlatformTable PT
		CROSS APPLY  [dbo].[UFN_Get_Platform_Hierarchy_WithNo](Platform_Codes) a
		WHERE Platform_Codes IS NOT NULL
	
		UPDATE RT SET RT.Platform_Names = PT.Platform_Names
		FROM #RightTable RT
		INNER JOIN #PlatformTable PT ON RT.Platform_Codes = PT.Platform_Codes
	
		UPDATE TADLR SET TADLR.Platform_Name = RT.Platform_Names
		FROM #TEMP_Syndication_Deal_List_Report TADLR 
		INNER JOIN #RightTable RT ON TADLR.Syn_Deal_Right_Code = RT.Syn_Deal_Rights_Code
	
		PRINT 'Region,Subtitle,Dubbing Insert and update for Primary Rights'
	
		UPDATE RT SET RT.Region_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRP.Country_Code IS NULL THEN AADRP.Territory_Code ELSE AADRP.Country_Code END AS NVARCHAR(MAX))
		from  Syn_Deal_Rights_Territory AADRP 
		WHERE RT.Syn_Deal_Rights_Code = AADRP.Syn_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
	
		UPDATE RT SET RT.RGType = ADRT.Territory_Type
		FROM #RightTable RT 
		INNER JOIN Syn_Deal_Rights_Territory ADRT ON RT.Syn_Deal_Rights_Code = ADRT.Syn_Deal_Rights_Code 

		UPDATE RT SET RT.SL_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRS.Language_Code IS NULL THEN AADRS.Language_Group_Code ELSE AADRS.Language_Code END AS NVARCHAR(MAX))
		from  Syn_Deal_Rights_Subtitling AADRS 
		WHERE RT.Syn_Deal_Rights_Code = AADRS.Syn_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,''),
		RT.DB_Codes =
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRD.Language_Code IS NULL THEN AADRD.Language_Group_Code ELSE AADRD.Language_Code END AS NVARCHAR(MAX))
		from  Syn_Deal_Rights_Dubbing AADRD 
		WHERE RT.Syn_Deal_Rights_Code = AADRD.Syn_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
	
		UPDATE RT SET RT.SLType = ADRS.Language_Type
		FROM #RightTable RT 
		INNER JOIN Syn_Deal_Rights_Subtitling ADRS ON RT.Syn_Deal_Rights_Code = ADRS.Syn_Deal_Rights_Code 
	
		UPDATE RT SET RT.DBType = ADRD.Language_Type
		FROM #RightTable RT 
		INNER JOIN Syn_Deal_Rights_Dubbing ADRD ON RT.Syn_Deal_Rights_Code = ADRD.Syn_Deal_Rights_Code 
	
		INSERT INTO #RegionTable(Region_Codes,Region_Names,Region_Type)
		SELECT DISTINCT Region_Codes,NULL,RGType FROM #RightTable
	
		INSERT INTO #LangTable(Lang_Codes,Lang_Names,Lang_Type)
		SELECT DISTINCT SL_Codes,NULL,SLType FROM #RightTable
		UNION
		SELECT DISTINCT DB_Codes,NULL,DBType FROM #RightTable
	
		UPDATE RT SET RT.Region_Names = CT.Criteria_Name FROM #RegionTable RT
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](RT.Region_Codes,RT.Region_Type,'RG') CT
	
		UPDATE LTB SET LTB.Lang_Names = LT.Criteria_Name FROM #LangTable LTB
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](LTB.Lang_Codes,LTB.Lang_Type,'SL') LT
	
		UPDATE RT SET RT.Region_Name = RTG.Region_Names FROM #RightTable RT
		INNER JOIN #RegionTable RTG ON RT.Region_Codes = RTG.Region_Codes AND RT.RGType = RTG.Region_Type
	
		UPDATE RT SET RT.Subtitle = LTG.Lang_Names FROM #RightTable RT
		INNER JOIN #LangTable LTG ON RT.SL_Codes = LTG.Lang_Codes AND RT.SLType = LTG.Lang_Type
	
		UPDATE RT SET RT.Dubbing = LTG.Lang_Names FROM #RightTable RT
		INNER JOIN #LangTable LTG ON RT.DB_Codes = LTG.Lang_Codes AND RT.DBType = LTG.Lang_Type
	
		UPDATE TADLR SET TADLR.Country_Territory_Name = RT.Region_Name
		,TADLR.Subtitling = ISNULL(RT.Subtitle,''),TADLR.Dubbing = ISNULL(RT.Dubbing,'') FROM #TEMP_Syndication_Deal_List_Report TADLR
		INNER JOIN #RightTable RT ON TADLR.Syn_Deal_Right_Code = RT.Syn_Deal_Rights_Code
		
	
	END

	BEGIN
		SELECT DISTINCT 
		DBO.UFN_GetTitleNameInFormat( dbo.UFN_GetDealTypeCondition(TEMP_SDLR.Deal_Type_Code), TEMP_SDLR.Title_Name, TEMP_SDLR.Episode_From, TEMP_SDLR.Episode_To) AS Title_Name,
		TEMP_SDLR.Director AS Director,
		TEMP_SDLR.Star_Cast AS Star_Cast,
		TEMP_SDLR.Genre AS Genre,
		TEMP_SDLR.Title_Language AS Title_Language,
		TEMP_SDLR.year_of_production AS Year_Of_Production,
		TEMP_SDLR.Agreement_No AS Agreement_No, 
		TEMP_SDLR.Deal_Description AS Deal_Description, 
		TEMP_SDLR.Reference_No AS Reference_No, 
		TEMP_SDLR.Agreement_Date AS Agreement_Date, TEMP_SDLR.Deal_Tag_Description AS Deal_Tag_Description, 
		TEMP_SDLR.Deal_Segment,
		TEMP_SDLR.Revenue_Vertical,
		TEMP_SDLR.Party AS Party, TEMP_SDLR.Party_Master AS Party_Master,
		CASE WHEN Is_PushBack = 'N' THEN TEMP_SDLR.Platform_Name ELSE '--' END AS Platform_Name, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_Start_Date ELSE NULL END AS Rights_Start_Date, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_End_Date ELSE NULL END AS Rights_End_Date, 
		TEMP_SDLR.Is_Title_Language_Right,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Country_Territory_Name ELSE '--' END AS Country_Territory_Name,
		TEMP_SDLR.Is_Exclusive AS Is_Exclusive, 
		CASE LTRIM(RTRIM(TEMP_SDLR.Subtitling)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_SDLR.Subtitling)) END AS Subtitling, 
		CASE LTRIM(RTRIM(TEMP_SDLR.Dubbing)) WHEN '' THEN 'No' ELSE LTRIM(RTRIM(TEMP_SDLR.Dubbing)) END AS Dubbing, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Sub_Licencing ELSE '--' END AS Sub_Licencing,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Is_Tentative ELSE '--' END AS Is_Tentative,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' AND TEMP_SDLR.Is_ROFR = 'Y' THEN TEMP_SDLR.First_Refusal_Date ELSE NULL END AS First_Refusal_Date,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Restriction_Remarks ELSE '--' END AS Restriction_Remarks,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Holdback_Platform ELSE '--' END AS Holdback_Platform,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Holdback_Rights ELSE '--' END AS Holdback_Rights,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Blackout ELSE '--' END AS Blackout,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.General_Remark ELSE '--' END AS General_Remark,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Rights_Remarks ELSE '--' END AS Rights_Remarks,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Payment_Remarks ELSE '--' END AS Payment_Remarks,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_Type ELSE '--' END AS Right_Type,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'N' THEN TEMP_SDLR.Right_Term ELSE '--' END AS Term,
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Is_Tentative ELSE '--' END AS Pushback_Is_Tentative, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Platform_Name ELSE '--' END AS Pushback_Platform_Name, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Right_Start_Date ELSE NULL END AS Pushback_Start_Date, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Right_End_Date ELSE NULL END AS Pushback_End_Date, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Country_Territory_Name ELSE '--' END AS Pushback_Country_Name, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Restriction_Remarks ELSE '--' END AS Pushback_Remark, 
		CASE WHEN TEMP_SDLR.Is_PushBack = 'Y' THEN TEMP_SDLR.Right_Term ELSE '--' END AS Pushback_Term,
		TEMP_SDLR.Deal_Workflow_Status AS Deal_Workflow_Status, 
		TEMP_SDLR.Is_PushBack AS Is_PushBack,
		TEMP_SDLR.Run_Type AS Run_Type,
		TEMP_SDLR.Is_Attachment AS Is_Attachment,
		TEMP_SDLR.[Program_Name] AS [Program_Name],
		(SELECT Deal_Type_Name FROM Deal_Type AS DT WHERE DT.Deal_Type_Code=TEMP_SDLR.Deal_Type_Code) AS Deal_Type,
		TEMP_SDLR.Promtoer_Group AS Promoter_Group_Name,
		TEMP_SDLR.Promtoer_Remarks AS Promoter_Remarks_Name,
		TEMP_SDLR.Category_Name,
		TEMP_SDLR.Business_Unit_Name
		INTO #TempSynDealListReport
		FROM #TEMP_Syndication_Deal_List_Report TEMP_SDLR
		ORDER BY TEMP_SDLR.Agreement_No, TEMP_SDLR.Is_Pushback
	END

	BEGIN
		SELECT 
			@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'ReferenceNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'AgreementDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'Party' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'Program' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'Director' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			@Col_Head11 = CASE WHEN  SM.Message_Key = 'starCast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			@Col_Head12 = CASE WHEN  SM.Message_Key = 'Genres' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			@Col_Head13 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			@Col_Head14 = CASE WHEN  SM.Message_Key = 'ReleaseYear' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
			@Col_Head15 = CASE WHEN  SM.Message_Key = 'Platform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			@Col_Head16 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
			@Col_Head17 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			@Col_Head18 = CASE WHEN  SM.Message_Key = 'Tentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			@Col_Head19 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			@Col_Head20 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			@Col_Head21 = CASE WHEN  SM.Message_Key = 'Exclusive' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
			@Col_Head22 = CASE WHEN  SM.Message_Key = 'TitleLanguageRight' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
			@Col_Head23 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
			@Col_Head24 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END,
			@Col_Head25 = CASE WHEN  SM.Message_Key = 'Sublicensing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head25 END,
			@Col_Head26 = CASE WHEN  SM.Message_Key = 'ROFR' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head26 END,
			@Col_Head27 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head27 END,
			@Col_Head28 = CASE WHEN  SM.Message_Key = 'RightsHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head28 END,
			@Col_Head29 = CASE WHEN  SM.Message_Key = 'RightsHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head29 END,
			@Col_Head30 = CASE WHEN  SM.Message_Key = 'Blackout' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head30 END,
			@Col_Head31 = CASE WHEN  SM.Message_Key = 'RightsRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head31 END,
			@Col_Head32 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head32 END,
 			@Col_Head33 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head33 END,
			@Col_Head34 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head34 END,
			@Col_Head35 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head35 END,
			@Col_Head36 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTerm' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head36 END,
			@Col_Head37 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackCountry' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head37 END,
			@Col_Head38 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head38 END,
			@Col_Head39 = CASE WHEN  SM.Message_Key = 'GeneralRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head39 END,
			@Col_Head40 = CASE WHEN  SM.Message_Key = 'Paymenttermsconditions' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head40 END,
			@Col_Head41 = CASE WHEN  SM.Message_Key = 'WorkflowStatus' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head41 END,
			@Col_Head42 = CASE WHEN  SM.Message_Key = 'RunType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head42 END,
			@Col_Head43 = CASE WHEN  SM.Message_Key = 'Attachment' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head43 END,
			@Col_Head44 = CASE WHEN  SM.Message_Key = 'SelfUtilizationGroup' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head44 END,
			@Col_Head45 = CASE WHEN  SM.Message_Key = 'SelfUtilizationRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head45 END,
			@Col_Head47 = CASE WHEN  SM.Message_Key = 'PartyMasterName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head47 END,
			@Col_Head48 = 'Deal Segment',
			@Col_Head49 = CASE WHEN  SM.Message_Key = 'CategoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head49 END,
			@Col_Head50 = 'Revenue Vertical',
			@Col_Head51 = 'Business Unit Name'

		 FROM System_Message SM  
		 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
		 AND SM.Message_Key IN ('AgreementNo','TitleType','DealDescription','ReferenceNo','AgreementDate','Status','Party','PartyMasterName','Program','Title','Director','starCast','Genres','TitleLanguage','ReleaseYear','Platform','RightStartDate','RightEndDate',
		 'Tentative','Term','Region','Exclusive','TitleLanguageRight','Subtitling','Dubbing','Sublicensing','ROFR','RestrictionRemarks','RightsHoldbackPlatform','RightsHoldbackRemark','Blackout','RightsRemark','ReverseHoldbackPlatform','ReverseHoldbackStartDate'
		 ,'ReverseHoldbackEndDate','ReverseHoldbackTentative','ReverseHoldbackTerm','ReverseHoldbackCountry','ReverseHoldbackRemark','GeneralRemarks','Paymenttermsconditions','WorkflowStatus','RunType','Attachment','SelfUtilizationGroup','SelfUtilizationRemarks','CategoryName')  
		 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  

		 IF EXISTS(SELECT TOP 1 * FROM #TempSynDealListReport)
		 BEGIN
			 SELECT 
					 [Agreement_No] , [Business Unit Name],
					 [Title Type], [Deal Description], [Reference No], [Agreement Date], [Status], [Deal Segment], [Revenue Vertical], [Party],[Party_Master], [Program], [Title], [Director]
					 , [Star Cast],[Genre], [Title Language], [Release Year], [Platform], [Rights Start Date], [Rights End Date], [Tentative], [Pushback], [Term], [Region], [Exclusive], [Title Language Right],
					 [Subtitling], [Dubbing], [Sub Licensing], [ROFR], [Restriction Remark], [Rights Holdback Platform], [Rights Holdback Remarks], [Blackout], [Rights Remarks],
					 [Reverse Holdback Platform], [Reverse Holdback Start Date], [Reverse Holdback End Date], [Reverse Holdback Tentative], [Reverse Holdback Term], [Reverse Holdback Country],
					 [Reverse Holdback Remarks], [General Remark], [Payment terms & Conditions], [Workflow status], [Run Type], [Attachment], [Self Utilization Group], [Self Utilization Remarks],[Category_Name]
				FROM (
			 SELECT
					sorter = 1,
					CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], CAST(Business_Unit_Name AS VARCHAR(100))  AS [Business Unit Name] ,
					CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No],
					--CONVERT(VARCHAR(30),[Agreement_Date],103) As [Agreement Date],
					CONVERT(DATE, [Agreement_Date], 103) As [Agreement Date],
					CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status],
					CAST([Deal_Segment] AS NVARCHAR(MAX)) As [Deal Segment], CAST([Revenue_Vertical] AS NVARCHAR(MAX)) As [Revenue Vertical]
					, CAST([Party] AS NVARCHAR(MAX)) As [Party],CAST([Party_Master] AS NVARCHAR(MAX)) As [Party_Master], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
					CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(DATE,[Rights_Start_Date],103) AS [Rights Start Date], 
					CONVERT(DATE,[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
					CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CONVERT(DATE,[First_Refusal_Date] , 103) As [ROFR],
					CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
					CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], Convert(DATE,[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(DATE,[Pushback_End_Date],103) As [Reverse Holdback End Date],
					CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
					CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
					CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks], CAST([Category_Name] AS NVARCHAR(MAX)) AS [Category_Name]
				From #TempSynDealListReport
				UNION ALL
					SELECT CAST(0 AS Varchar(100)), @Col_Head01, @Col_Head51, 
					@Col_Head02, @Col_Head03, @Col_Head04, GETDATE() , @Col_Head06, @Col_Head48, @Col_Head50, @Col_Head07,@Col_Head47, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11
					, @Col_Head12, @Col_Head13, @Col_Head14, @Col_Head15,  GETDATE(), GETDATE(), @Col_Head18, 'Pushback', @Col_Head19, @Col_Head20, @Col_Head21, @Col_Head22, @Col_Head23, @Col_Head24, @Col_Head25, GETDATE()
					, @Col_Head27, @Col_Head28, @Col_Head29, @Col_Head30, @Col_Head31, @Col_Head32, GETDATE(), GETDATE(), @Col_Head35, @Col_Head36, @Col_Head37, @Col_Head38, @Col_Head39, @Col_Head40
					, @Col_Head41, @Col_Head42, @Col_Head43, @Col_Head44, @Col_Head45,@Col_Head49
				) X   
			ORDER BY Sorter
		END
		ELSE
		BEGIN
			SELECT * FROM #TempSynDealListReport
		END

	END
END
GO
PRINT N'Altering [dbo].[USP_Title_Import_Utility_Schedule]...';


GO
ALTER PROCEDURE USP_Title_Import_Utility_Schedule
AS
BEGIN
	DECLARE @DM_Master_Import_Code INT = 0

	DECLARE db_cursor CURSOR FOR 
	select DM_Master_Import_Code FROM DM_Master_Import WHERE FILE_Type = 'T' AND Status in ('N','I')

	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @DM_Master_Import_Code
	
	WHILE @@FETCH_STATUS = 0  
	BEGIN 	
		EXEC USP_Title_Import_Utility_PIII @DM_Master_Import_Code
		FETCH NEXT FROM db_cursor INTO @DM_Master_Import_Code
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor 
END
GO
PRINT N'Altering [dbo].[USP_Title_List]...';


GO
ALTER PROCEDURE [dbo].[USP_Title_List]      
(       
--DECLARE      
    @Deal_Type_code int ,      
    @TitleName NVARCHAR(2000), 
	@OriginalTitleName NVARCHAR(MAX) ,    
    @BUCode INT,      
    @PageNo INT,      
    @RecordCount Int out,      
    @IsPaging Varchar(2),      
    @PageSize Int,      
 @AdvanceSearch NVARCHAR(max),  
 @ExactMatch varchar(max) = ''  
)      
AS      
--DECLARE  
-- @Deal_Type_code int ,      
--    @TitleName NVARCHAR(2000),  
--	@OriginalTitleName NVARCHAR(MAX),    
--    @BUCode INT,      
--    @PageNo INT,      
--    @RecordCount Int ,      
--    @IsPaging Varchar(2),      
--    @PageSize Int,      
-- @AdvanceSearch NVARCHAR(max),  
-- @ExactMatch varchar(max) = ''  
  
--set @Deal_Type_code = 1  
--Set @OriginalTitleName =''    
--set @TitleName = ''      
--set @PageNo =  1      
--set  @RecordCount = 10      
--set @IsPaging = 'Y'      
--set @PageSize = 100 
--SET @AdvanceSearch = ''  
--SET @ExactMatch = ''      
  
BEGIN        
    
 DECLARE @Condition NVARCHAR(MAX) = ' AND ISNULL(T.Reference_Key,'''') = '''' AND  ISNULL(T.Reference_Flag,'''') = '''' '      
 DECLARE @delimt NVARCHAR(2) = N'﹐'      
      
    if(@TitleName != '')      
        set @Condition  += ' AND T.Title_code in (select Title_Code from Title where Title_Name IN (SELECT number FROM fn_Split_withdelemiter(N'''+@TitleName+''', N'''+ @delimt +''') where number != ''''))'      
     print @Condition  
         
		 IF(@OriginalTitleName != '')      
        SET @Condition  += ' AND T.Title_code in (select Title_Code FROM Title WHERE Original_Title IN (SELECT number FROM fn_Split_withdelemiter(N'''+@OriginalTitleName+''', N'''+ @delimt +''') WHERE number != '''')) '      
  

    if (@Deal_Type_code > 0)      
        set @Condition  += ' AND DT.Deal_Type_code in('+ cast(@Deal_Type_code as varchar)+')'      
    --else if (@Deal_Type_code > 0 AND @TitleName = '')      
    --    set @Condition  += ' AND DT.Deal_Type_Name  LIKE ''%'+ ISNULL(@TitleName,'') + '%'''      
      
    IF(@AdvanceSearch ='')  
  SET @AdvanceSearch =''  
  
        set @Condition  += ' '      
    if(@PageNo = 0)      
        Set @PageNo = 1      
      
 IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
    Create Table #Temp(      
        Id Int Identity(1,1),      
        RowId Varchar(200),  
  Title_Name  Varchar(200),  
  Language_Name  Varchar(200),  
  Sort varchar(10),  
  Row_Num Int,  
  Last_Updated_Time datetime  
    );      
      
    Declare @SqlPageNo NVARCHAR(MAX)      
        
    set @SqlPageNo = '      
            WITH Y AS (      
                            Select distinct X.Title_Code,X.Title_Name,X.Language_Name,X.Last_UpDated_Time From      
                            (      
                                select * from (      
                                    select distinct Title_Code, T.Original_Title, T.Title_Name, T.Title_Code_Id, T.Synopsis, T.Original_Language_Code, T.Title_Language_Code      
                                            ,T.Year_Of_Production,P.Program_Name, T.Duration_In_Min, T.Deal_Type_Code, T.Grade_Code, T.Reference_Key, T.Reference_Flag, T.Is_Active      
                                            ,T.Inserted_By, T.Inserted_On, T.Last_UpDated_Time, T.Last_Action_By, T.Lock_Time, T.Title_Image, L.Language_Name   
                                            from Title T      
                                            INNER join Deal_Type DT on DT.Deal_Type_Code = T.Deal_Type_Code  
           INNER join Language L on T.Title_Language_Code = L.Language_Code  
		   LEFT JOIN MAP_Extended_Columns MEC ON T.Title_Code = MEC.Record_Code
		   LEFT JOIN  Extended_Columns_Value ECV ON MEC.Columns_Code = ECV.Columns_Code
           LEFT JOIN Program P ON T.Program_Code = P.Program_Code  
                                            where 1=1       
                                            '+ @Condition +'  '+@AdvanceSearch+'  
                                      )as XYZ Where 1 = 1      
                             )as X      
                        )      
        Insert InTo #Temp Select Title_Code,Title_Name,Language_Name,''1'','' '',Last_UpDated_Time From Y'      
         
    --PRINT (@SqlPageNo)      
    EXEC (@SqlPageNo)      
    --select * from #Temp  
 Set @ExactMatch = '%'+@ExactMatch+'%'  
 Update #Temp Set Sort = '0' Where Title_name like @ExactMatch OR Language_Name like @ExactMatch  
  
    delete from T From #Temp T Inner Join  
 (  
  Select ROW_NUMBER()Over(Partition By RowId Order By Sort asc) RowNum, Id, RowId, Sort From #Temp  
 )a On T.Id = a.Id and a.RowNum <> 1  
 Select @RecordCount = Count(distinct (RowId )) From #Temp     
     Update a   
  Set a.Row_Num = b.Row_Num  
  From #Temp a  
  Inner Join (  
   --Select Rank() over(order by Sort Asc, Last_Updated_Time desc, ID ASC) Row_Num, ID From #Temp  
   Select dense_Rank() over(order by Sort Asc, Last_Updated_Time desc, RowId ASC) Row_Num, ID From #Temp  
  ) As b On a.Id = b.Id  
 --select * from #Temp order by Row_Num   
  
    If(@IsPaging = 'Y')      
    Begin         
        Delete From #Temp Where Row_Num < (((@PageNo - 1) * @PageSize) + 1) Or Row_Num > @PageNo * @PageSize     
    End         
     -- select * from #Temp order by Row_Num    
    --Select @RecordCount = Count(*) From #Temp      
         
         
    Declare @Sql_1  NVARCHAR(MAX) ,@Sql_2 NVARCHAR(MAX)      
    Set @Sql_1 = '      
        SELECT Title_Name, Original_Title, Title_Code, Language_Name, Year_Of_Production, Program_Name, CountryName, Original_Language, TalentName, Producer, Director, Title_Image      
    ,Is_Active, Deal_Type_Code, Deal_Type_Name, Synopsis, Genre      
        FROM (      
            select distinct T.Title_Name,T.Original_Title,T.Title_Code,T.Synopsis ,L.Language_Name , OL.Language_Name AS ''Original_Language''    
           ,T.Year_Of_Production,p.Program_Name      
           ,REVERSE(stuff(reverse(stuff(      
                        (         
                            select cast(C.Country_Name  as NVARCHAR(MAX)) + '', '' from Title_Country TC      
                            inner join Country C on C.Country_Code = TC.Country_Code      
                            where TC.Title_Code = T.Title_Code      
                            FOR XML PATH(''''), root(''CountryName''), type      
     ).value(''/CountryName[1]'',''Nvarchar(max)''      
                        ),2,0, ''''      
                    )      
           ),1,2,'''')) as CountryName      
           ,REVERSE(stuff(reverse(  stuff(      
                        (         
                            select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
                            inner join Role R on R.Role_Code = TT.Role_Code      
                            inner join Talent Tal on tal.talent_Code = TT.Talent_code      
                            where TT.Title_Code = T.Title_Code AND R.Role_Code in (2)      
      
                            FOR XML PATH(''''), root(''TalentName''), type      
     ).value(''/TalentName[1]'',''NVARCHAR(max)''      
                        ),1,0, ''''      
                    )      
           ),1,2,'''')) as TalentName      
            ,REVERSE(stuff(reverse(  stuff(      
                        (         
                            select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
                            inner join Role R on R.Role_Code = TT.Role_Code      
                            inner join Talent Tal on tal.talent_Code = TT.Talent_code      
                            where TT.Title_Code = T.Title_Code AND R.Role_Code in (4)      
      
                            FOR XML PATH(''''), root(''Producer''), type      
     ).value(''/Producer[1]'',''NVARCHAR(max)''      
                        ),1,0, ''''      
                    )      
           ),1,2,'''')) as Producer      
           ,REVERSE(stuff(reverse(  stuff(      
                        (         
                            select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
                            inner join Role R on R.Role_Code = TT.Role_Code      
                            inner join Talent Tal on tal.talent_Code = TT.Talent_code      
                            where TT.Title_Code = T.Title_Code AND R.Role_Code in (1)      
      
                            FOR XML PATH(''''), root(''Director''), type      
     ).value(''/Director[1]'',''NVARCHAR(max)''      
                        ),1,0, ''''      
                    )      
           ),1,2,'''')) as Director      
           , [dbo].[UFN_Get_Title_Genre](T.Title_Code) as Genre, ISNULL(T.Title_Image,'' '') As Title_Image, T.Last_UpDated_Time, T.Inserted_On      
           ,Case When T.Is_Active=''Y'' then ''Active'' Else ''Deactive'' END AS Is_Active, T.Deal_Type_Code, DT.Deal_Type_Name, Tmp.Row_Num   '
	SET @Sql_2 ='	        
    from Title T      
    INNER join Deal_Type DT on DT.Deal_Type_Code = T.Deal_Type_Code     
    LEFT join [Language] L on T.Title_Language_Code  = L.Language_Code   
	LEFT join [Language] OL on T.Original_Language_Code  = OL.Language_Code    
	LEFT JOIN MAP_Extended_Columns MEC ON T.Title_Code = MEC.Record_Code
	LEFT JOIN  Extended_Columns_Value ECV ON MEC.Columns_Code = ECV.Columns_Code
    LEFT join Title_Country TC on T.Title_Code = TC.Title_Code   
 INNER JOIN #Temp Tmp on T.Title_Code = Tmp.RowId    
 left join Program P on T.Program_code = P.Program_Code   
      where 1=1  '+ @Condition +'  '+@AdvanceSearch+'    
          ) tbl  
        WHERE tbl.Title_Code in (Select RowId From #Temp)      
        ORDER BY tbl.Row_Num
    '      
 --order by ISNULL(tbl.Last_UpDated_Time,tbl.Inserted_On) DESC      
    --PRINT @Sql      
	--Select @Condition
    Exec(@Sql_1 + @Sql_2)      
    --Drop Table #Temp      
  
    --SELECT Title_Name ,      
    --          Original_Title      
    --            ,Title_Code      
    --            ,'asfsafsaf' as Language_Name      
    --          ,Year_Of_Production      
    --            ,'asfgsdhsfdhj' as CountryName      
    --            ,'asfgasgfhfgjfgjkghkgkgk' as TalentName      
    --          ,'jhsdgjhgdf' as Producer      
    --   ,'asfgasgfhfgjfgjkghkgkgk' as Director      
    --            ,Title_Image      
    --            ,Is_Active      
    --            ,Deal_Type_Code      
    --          ,Synopsis      
    --            ,'asadsd' as Genre      
    --            from Titlea      
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp         

END

--declare @RC INT 
--EXEC USP_Title_List 0,'','',0,1,@RC,'Y',100,'',''
GO
PRINT N'Altering [dbo].[USPMHGetRequestDetails]...';


GO
ALTER PROCEDURE [dbo].[USPMHGetRequestDetails]
@RequestCode NVARCHAR(MAX),
@RequestTypeCode INT,
@IsCueSheet CHAR = 'N'
AS
BEGIN
	--DECLARE
	--@RequestCode NVARCHAR(MAX) = 10049,
	--@RequestTypeCode INT = 1,
	--@IsCueSheet CHAR = 'N'

	IF OBJECT_ID('tempdb..#tempCueSheet') IS NOT NULL DROP TABLE #tempCueSheet

	IF(@RequestTypeCode = 1)
		BEGIN
		IF(@IsCueSheet = 'Y')
			BEGIN

				Select COUNT(*) AS Cnt, TitleCode,MusicTitleCode, ma.Music_Album_Name INTO #tempCueSheet
				from MHCuesheetsong mcs
				INNER JOIN Music_Title mt ON mt.Music_Title_Code = mcs.MusicTitleCode
				INNER JOIN Music_Album ma ON ma.Music_Album_Code = mt.Music_Album_Code
				GROUP BY TitleCode,MusicTitleCode, ma.Music_Album_Name

				SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') 
				--+ ' ('+CAST(ISNULL(tcs.Cnt, 0) AS NVARCHAR) +')' 
				AS RequestedMusicTitle, 
				CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
					 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
					 ELSE 'Pending' END AS IsValid,
					 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,ISNULL(MR.SpecialInstruction,'') AS SpecialInstruction, ISNULL(MR.Remarks,'') AS ProductionHouseRemarks,ISNULL(tcs.Cnt, 0) AS SongUsedCount
				FROM MHRequestDetails MRD
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
				LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
				LEFT  JOIN #tempCueSheet tcs ON tcs.MusicTitleCode = mrd.MusicTitleCode AND tcs.TitleCode = mr.TitleCode
				WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',','))) AND MRD.IsApprove = 'Y'
			END
		ELSE
			BEGIN
				SELECT ISNULL(MRD.MusicTitleCode,'') AS MusicTitleCode,ISNULL(MT.Music_Title_Name,'') AS RequestedMusicTitle, 
				CASE WHEN MRD.IsValid = 'N' THEN 'Invalid' 
					 WHEN MRD.IsValid = 'Y' THEN 'Valid'	
					 ELSE 'Pending' END AS IsValid,
					 ISNULL(ML.Music_Label_Name,'') AS LabelName,MA.Music_Album_Name AS MusicMovieAlbum,
				CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
					 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
					 ELSE 'Reject' END AS IsApprove,ISNULL(MRD.Remarks,'') AS Remarks,MR.MHRequestCode,MR.TitleCode,ISNULL(T.Title_Name,'') AS Title_Name,MR.EpisodeFrom,MR.EpisodeTo,ISNULL(MR.SpecialInstruction,'') AS SpecialInstruction, ISNULL(MR.Remarks,'') AS ProductionHouseRemarks
				FROM MHRequestDetails MRD
				INNER JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
				LEFT JOIN Music_Title_Label MTL ON MTL.Music_Title_Code = MRD.MusicTitleCode AND MTL.Effective_To IS NULL
				LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MTL.Music_Label_Code
				LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
				INNER JOIN MHRequest MR ON MR.MHRequestCode = MRD.MHRequestCode
				LEFT JOIN Title T ON T.Title_Code = MR.TitleCode
				WHERE (MRD.MHRequestCode IN (select number from dbo.fn_Split_withdelemiter('' + ISNULL(@RequestCode, '') +'',',')))
			END
			
		END
	ELSE IF(@RequestTypeCode = 2)
		BEGIN
			SELECT ISNULL(MRD.MusicTrackName,'') AS RequestedMusicTitleName,ISNULL(MT.Music_Title_Name,'') AS ApprovedMusicTitleName,ISNULL(ML.Music_Label_Name,'') AS MusicLabelName,ISNULL(MA.Music_Album_Name,'') AS MusicMovieAlbumName,
			CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
				WHEN MRD.CreateMap = 'M' THEN 'Map' 
				 ELSE 'Pending' END AS CreateMap,
			ISNULL(MRD.Remarks,'') AS Remarks,
			CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
				 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
				 ELSE 'Reject' END AS IsApprove,
				 ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.Singers,'')),'') AS Singers,ISNULL([dbo].[UFNGetTalentList](ISNULL(MRD.StarCasts,'')),'') AS StarCasts
			FROM MHRequestDetails MRD
			LEFT JOIN Music_Title MT ON MT.Music_Title_Code = MRD.MusicTitleCode
			LEFT JOIN Music_Label ML ON ML.Music_Label_Code = MRD.MusicLabelCode
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode 
			WHERE MRD.MHRequestCode = @RequestCode
		END
	ELSE
		BEGIN
			SELECT ISNULL(MRD.TitleName,'') AS RequestedMovieAlbumName,ISNULL(MA.Music_Album_Name,'') AS ApprovedMovieAlbumName,
			CASE WHEN MRD.MovieAlbum = 'A' THEN 'Album' 
				 ELSE 'Movie' END AS MovieAlbum,
			CASE WHEN MRD.CreateMap = 'C' THEN 'Create' 
				WHEN MRD.CreateMap = 'M' THEN 'Map' 
				 ELSE 'Pending' END AS CreateMap,
				 ISNULL(MRD.Remarks,'') AS Remarks,
			CASE WHEN MRD.IsApprove = 'P' THEN 'Pending'
				 WHEN MRD.IsApprove = 'Y' THEN 'Approve'
				 ELSE 'Reject' END AS IsApprove
			FROM MHRequestDetails MRD 
			LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MRD.MovieAlbumCode
			WHERE MRD.MHRequestCode = @RequestCode
		END

		IF OBJECT_ID('tempdb..#tempCueSheet') IS NOT NULL DROP TABLE #tempCueSheet
END
GO
PRINT N'Creating [dbo].[USP_Validate_Delay_Rights_Duplication_Acq]...';


GO
CREATE PROCEDURE USP_Validate_Delay_Rights_Duplication_Acq
AS
-- =============================================
-- Author:		Akshay Rane
-- Create DATE: 19-Februrary-2021
-- Description:	
-- =============================================
BEGIN
   SET NOCOUNT ON

   IF OBJECT_ID('tempdb..#Tmp_Validate_Rights_Duplication') IS NOT NULL 
		DROP TABLE #Tmp_Validate_Rights_Duplication

	IF OBJECT_ID('tempdb..#Tmp_Linear_Title_Status') IS NOT NULL 
		DROP TABLE #Tmp_Linear_Title_Status

   DECLARE 
   	@Deal_Rights Deal_Rights ,
	@Deal_Rights_Title Deal_Rights_Title  ,
	@Deal_Rights_Platform Deal_Rights_Platform ,
	@Deal_Rights_Territory Deal_Rights_Territory ,
	@Deal_Rights_Subtitling Deal_Rights_Subtitling ,
	@Deal_Rights_Dubbing Deal_Rights_Dubbing 

	CREATE TABLE #Tmp_Linear_Title_Status
	(
		Id INT IDENTITY(1,1),
		Title_Name NVARCHAR(MAX),
		Title_Added NVARCHAR(MAX),
		Runs_Added NVARCHAR(MAX)
	)

	CREATE TABLE #Tmp_Validate_Rights_Duplication
	(
		Acq_Deal_Rights_Code INT,
		Title_Name NVARCHAR(MAX),
		Platform_Name NVARCHAR(MAX),
		Right_Start_Date DATETIME,
		Right_End_Date DATETIME,
		Right_Type NVARCHAR(MAX),
		Is_Sub_License NVARCHAR(MAX),
		Is_Title_Language_Right NVARCHAR(MAX),
		Country_Name NVARCHAR(MAX),
		Subtitling_Language NVARCHAR(MAX),
		Dubbing_Language NVARCHAR(MAX),
		Agreement_No NVARCHAR(MAX),
		ErrorMSG NVARCHAR(MAX),
		Episode_From INT,
		Episode_To INT
	)

   	DECLARE @Acq_Deal_Rights_Code INT = 0, @Deal_Rights_Process_Code INT = 0, @ErrorCount INT = 0, @Deal_Code INT = 0
	DECLARE @RunPending INT, @RightsPending INT ,@DealCompleteFlag NVARCHAR(MAX)=''

	SELECT @DealCompleteFlag = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Deal_Complete_Flag'
	SET  @DealCompleteFlag = REPLACE(@DealCompleteFlag,' ','')

	DECLARE db_cursor CURSOR FOR 
	SELECT DISTINCT Deal_Rights_Code, Deal_Rights_Process_Code, Deal_Code FROM Deal_Rights_Process WHERE Record_Status = 'P' AND ISNULL(Rights_Bulk_Update_Code , 0) = 0

	OPEN db_cursor  
	FETCH NEXT FROM db_cursor INTO @Acq_Deal_Rights_Code, @Deal_Rights_Process_Code, @Deal_Code
	
	WHILE @@FETCH_STATUS = 0  
	BEGIN 	
		SELECT  @ErrorCount = 0, @RunPending = 0, @RightsPending = 0

		DELETE FROM #Tmp_Linear_Title_Status
		DELETE FROM Acq_Deal_Rights_Error_Details WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

		INSERT INTO @Deal_Rights (
			Deal_Rights_Code, Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, Right_Type,Is_Tentative,
			Term, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, Restriction_Remarks, Right_Start_Date, Right_End_Date
			)
		SELECT 
			0,Acq_Deal_Code,Is_Exclusive,Is_Title_Language_Right,Is_Sub_License,Sub_License_Code,Is_Theatrical_Right,Right_Type,Is_Tentative,
			Term,Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type,Is_ROFR,ROFR_Date,Restriction_Remarks,Right_Start_Date, Right_End_Date
		FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Title (Deal_Rights_Code,Title_Code,Episode_From,Episode_To )
		SELECT 0,Title_Code,Episode_From,Episode_To
		FROM Acq_Deal_Rights_Title WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Platform (Deal_Rights_Code, Platform_Code)
		SELECT 0, Platform_Code FROM Acq_Deal_Rights_Platform WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Territory (Deal_Rights_Code, Territory_Type, Territory_Code, Country_Code)
		SELECT 0, Territory_Type, Territory_Code, Country_Code
		FROM Acq_Deal_Rights_Territory WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Subtitling (Deal_Rights_Code, Language_Type, Language_Group_Code, Subtitling_Code)
		SELECT 0, Language_Type, Language_Group_Code, Language_Code
		FROM Acq_Deal_Rights_Subtitling WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		INSERT INTO @Deal_Rights_Dubbing (Deal_Rights_Code, Language_Type, Language_Group_Code, Dubbing_Code)
		SELECT 0, Language_Type, Language_Group_Code, Language_Code
		FROM Acq_Deal_Rights_Dubbing WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
		------------------------------------
		IF((SELECT COUNT(*) From Deal_Rights_Process WHERE ISNULL(Rights_Bulk_Update_Code , 0) = 0 AND Record_Status = 'W') = 0)
		BEGIN

			UPDATE Deal_Rights_Process SET Record_Status = 'W', Process_Start = GETDATE(), Porcess_End = NULL, Error_Messages= NULL WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code
			UPDATE Acq_Deal_Rights SET Right_Status = 'W' WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

			BEGIN TRY
			BEGIN TRANSACTION 
				INSERT INTO #Tmp_Validate_Rights_Duplication
				(
					Title_Name, Platform_Name ,Right_Start_Date ,Right_End_Date ,Right_Type ,Is_Sub_License ,Is_Title_Language_Right ,
					Country_Name ,Subtitling_Language ,Dubbing_Language , Agreement_No , ErrorMSG ,Episode_From ,Episode_To 
				)
				EXECUTE USP_Validate_Rights_Duplication_UDT_ACQ
					 @Deal_Rights ,@Deal_Rights_Title ,@Deal_Rights_Platform ,@Deal_Rights_Territory ,@Deal_Rights_Subtitling ,@Deal_Rights_Dubbing ,'AR','N',@Deal_Rights_Process_Code
			COMMIT
			END TRY
			BEGIN CATCH
					ROLLBACK

				IF((SELECT Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_Acq_rights_delay_validation') = 'Y')
				BEGIN
					 UPDATE Deal_Rights_Process SET Porcess_End = GETDATE(), Error_Messages = ERROR_MESSAGE(), Record_Status = 'E'
					 WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code AND Record_Status = 'W'

					 UPDATE Acq_Deal_Rights set Right_Status = 'E' WHERE Acq_Deal_Rights_Code = (SELECT Deal_Rights_Code FROM Deal_Rights_Process WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code)
				 END

			END CATCH
			
			SELECT @ErrorCount = COUNT(*) FROM #Tmp_Validate_Rights_Duplication

			IF (@ErrorCount = 0)
			BEGIN
					IF(SELECT Record_Status FROM Deal_Rights_Process  WHERE Deal_Rights_Process_Code = @Deal_Rights_Process_Code ) <> 'E'
					BEGIN
						UPDATE Deal_Rights_Process SET Record_Status = 'D', Porcess_End = GETDATE() WHERE Record_Status = 'W' AND Deal_Rights_Process_Code = @Deal_Rights_Process_Code
						UPDATE Acq_Deal_Rights SET Right_Status = 'C' WHERE Right_Status = 'W' AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
						--Check Linear Status
						BEGIN

							INSERT INTO #Tmp_Linear_Title_Status (Title_Name, Title_Added, Runs_Added)
							EXEC USP_List_Acq_Linear_Title_Status @Deal_Code

							SELECT @RunPending = COUNT(*) FROM #Tmp_Linear_Title_Status WHERE Title_Added = 'Yes~'
							SELECT @RightsPending =  COUNT(*) FROM #Tmp_Linear_Title_Status WHERE Title_Added = 'No'
							SELECT @RunPending = CASE WHEN @DealCompleteFlag = 'R,R' OR @DealCompleteFlag = 'R,R,C' THEN @RunPending ELSE 0 END

							UPDATE Acq_Deal SET Deal_Workflow_Status = 
							CASE WHEN @RunPending > 0 AND @RightsPending > 0 THEN 'RR' 
								 WHEN @RunPending > 0 AND @RightsPending = 0 THEN 'RP' 
								 ELSE 'N' END
							WHERE  Acq_Deal_Code = @Deal_Code 

						END
					END
			END
			ELSE IF (@ErrorCount > 0)
			BEGIN
				
				 UPDATE #Tmp_Validate_Rights_Duplication SET Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
				 
				 INSERT INTO Acq_Deal_Rights_Error_Details
				 (
				 	 Acq_Deal_Rights_Code, Title_Name, Platform_Name ,Right_Start_Date ,Right_End_Date ,Right_Type ,Is_Sub_License ,Is_Title_Language_Right ,
				 	Country_Name ,Subtitling_Language ,Dubbing_Language , Agreement_No , ErrorMSG ,Episode_From ,Episode_To, Is_Updated , Inserted_On 
				 )
				 SELECT DISTINCT  Acq_Deal_Rights_Code, Title_Name, Platform_Name ,Right_Start_Date ,Right_End_Date ,Right_Type ,Is_Sub_License ,Is_Title_Language_Right ,
				 	Country_Name ,Subtitling_Language ,Dubbing_Language , Agreement_No , ErrorMSG ,Episode_From ,Episode_To,'N', GETDATE() 
				 FROM #Tmp_Validate_Rights_Duplication

				 UPDATE Deal_Rights_Process SET Record_Status = 'E', Porcess_End = GETDATE() WHERE Record_Status = 'W' AND Deal_Rights_Process_Code = @Deal_Rights_Process_Code
				 UPDATE Acq_Deal_Rights SET Right_Status = 'E' WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code 
			END		
		END

		FETCH NEXT FROM db_cursor INTO @Acq_Deal_Rights_Code, @Deal_Rights_Process_Code, @Deal_Code
	END 

	CLOSE db_cursor  
	DEALLOCATE db_cursor 
END


--select * from @Deal_Rights 
--select * from @Deal_Rights_Title 
--select * from @Deal_Rights_Platform
--select * from @Deal_Rights_Territory 
--select * from @Deal_Rights_Subtitling
--select * from @Deal_Rights_Dubbing 
--select * from Deal_Rights_Process
GO
PRINT N'Altering [dbo].[USP_Assign_Workflow]...';


GO
ALTER  PROCEDURE [dbo].[USP_Assign_Workflow](
	@Record_Code Int,
	@Module_Code Int,
	@Login_User Int, 
	@Remarks_Approval NVARCHAR(MAX)  = Null
)
AS
BEGIN	
--DECLARE
--	@Record_Code Int =  19606,
--	@Module_Code Int = 30,
--	@Login_User Int = 136,
--	@Remarks_Approval NVARCHAR(MAX)  = 'ok'

	SET FMTONLY OFF	

	DECLARE 
			@BU_Code INT = 0, @Remarks NVARCHAR(MAX) = '', @Is_Email_Required VARCHAR(5) = '', @Error_Desc NVARCHAR(1000) = '',
			@Created_By INT= 0, @Created_Date DATETIME = '' ,@Last_Action_By INT = 0, @Last_Updated_Date DATETIME = '',@Version_No INT=1

	DECLARE @Waiting_Archive CHAR(2) = NULL, @AgreementNo NVARCHAR(MAX) = ''


	SELECT @Is_Email_Required = ISNULL(Is_Email_Required, 'N') FROM System_Param
			IF(@Module_Code = 30)
			BEGIN
				SELECT 
				@Version_No=CAST  ([Version] as INT)
				FROM Acq_Deal WHERE Acq_Deal_Code = @Record_Code
			END
			ELSE IF(@Module_Code = 35)
			BEGIN
				SELECT 
				@Version_No=CAST  ([Version] as INT)
				FROM Syn_Deal WHERE Syn_Deal_Code = @Record_Code
			END
			ELSE IF(@Module_Code = 163)
			BEGIN
				SELECT 
				@Version_No=CAST  ([Version] as INT)
				FROM Music_Deal WHERE Music_Deal_Code = @Record_Code
			END

	IF(@Module_Code = 30)
	BEGIN
		SELECT 
			@BU_Code = Business_Unit_Code, @Remarks = Remarks, 
			@Created_By = Inserted_By, @Created_Date = Inserted_On,
			@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
		FROM Acq_Deal WHERE Acq_Deal_Code = @Record_Code
	END
	ELSE IF(@Module_Code = 35)
	BEGIN
		SELECT 
			@BU_Code = Business_Unit_Code, @Remarks = Remarks,
			@Created_By = Inserted_By, @Created_Date = Inserted_On,
			@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
		FROM Syn_Deal WHERE Syn_Deal_Code = @Record_Code
	END
	ELSE IF(@Module_Code = 154)
	BEGIN
		SELECT DISTINCT
			@Remarks = MST.Remarks, @BU_Code = AD.Business_Unit_Code,
			@Created_By=MST.Inserted_By,@Created_Date=MST.Inserted_On
		FROM Music_Schedule_Transaction AS MST
			INNER JOIN BV_Schedule_Transaction AS BST ON BST.BV_Schedule_Transaction_Code= MST.BV_Schedule_Transaction_Code
			--INNER JOIN Acq_Deal_Movie AS ADM ON ADM.Acq_Deal_Movie_Code = BST.Deal_Movie_Code
			INNER JOIN Content_Channel_Run CCR ON CCR.Content_Channel_Run_Code = BST.Content_Channel_Run_Code
			INNER JOIN Acq_Deal AS AD ON AD.Acq_Deal_Code = CCR.Acq_Deal_Code
		WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND MST.Music_Schedule_Transaction_Code=@Record_Code
	END
	ELSE IF(@Module_Code = 163)
	BEGIN
		SELECT 
			@BU_Code = Business_Unit_Code, @Remarks = Remarks,
			@Created_By = Inserted_By, @Created_Date = Inserted_On,
			@Last_Action_By = ISNULL(Last_Action_By, 0), @Last_Updated_Date = ISNULL(Last_Updated_Time, '') 
		FROM Music_Deal WHERE Music_Deal_Code = @Record_Code
	END

	CREATE TABLE #Temp
	(
		Id INT IDENTITY(1, 1),
		Module_Code INT,
		Record_Code INT,
		Group_Code INT,
		Primary_User_Code INT,
		Role_Level INT,
		Is_Done VARCHAR(10) DEFAULT 'N'
	)

	INSERT INTO #Temp
	SELECT @Module_Code, @Record_Code, Security_Group_Code, Users_Code, 0, 'Y' FROM Users WHERE Users_Code = @Login_User

	INSERT INTO #Temp
	SELECT 
		@Module_Code, @Record_Code, Group_Code, (SELECT TOP 1 U.Users_Code FROM Users U WHERE U.Security_Group_Code = Group_Code), 
		ROW_NUMBER() OVER(ORDER BY Group_Level), 'N'
	FROM Workflow_Module_Role 
	WHERE Workflow_Module_Code IN (
		SELECT Workflow_Module_Code FROM Workflow_Module 
		WHERE Module_Code = @Module_Code And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
		AND CAST(GETDATE() AS DATE) BETWEEN Effective_Start_Date AND ISNULL(System_End_Date, GETDATE())
	)

	-- CHECKING IF REMARKS APROVAL STARTS WITH 'WA~'
	IF (SELECT COUNT(*) FROM DBO.fn_Split_withdelemiter(@Remarks_Approval, '~')) > 1
		SELECT top 1 @Waiting_Archive = number FROM DBO.fn_Split_withdelemiter(@Remarks_Approval, '~')
	
	IF(ISNULL(@Waiting_Archive,'') = 'WA' OR ISNULL(@Waiting_Archive,'') = 'AR' )
	BEGIN
		

		--Create level wise rows in MWD
		DELETE FROM Module_Workflow_Detail WHERE Module_Code = @Module_Code And Record_Code = @Record_Code

		INSERT INTO Module_Workflow_Detail
		(
			Module_Code, Record_Code, Group_Code, Primary_User_Code, Role_Level, Is_Done, Next_Level_Group, Entry_Date
		)

		SELECT T1.Module_Code, T1.Record_Code, T1.Group_Code, T1.Primary_User_Code, T1.Id - 1, T1.Is_Done, T2.Group_Code, GETDATE() Entry_Date
		FROM #Temp T1
		LEFT OUTER JOIN #Temp T2 ON T1.Id + 1 = T2.Id

		DECLARE @Is_Active CHAR(1) = 'Y'

		DECLARE @Is_Error1 CHAR(1), @Module_Workflow_Detail_Code INT = 0

		DECLARE @IsZeroLevel INT = 0
		SELECT @IsZeroLevel = COUNT(*) FROM #Temp

		DECLARE @Workflow_Code_AR_WA INT = 0
		SELECT @Workflow_Code_AR_WA = Workflow_Code FROM Workflow_Module 
		WHERE Module_Code = @Module_Code And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
		AND CAST(GETDATE() AS DATE) BETWEEN Effective_Start_Date AND ISNULL(System_End_Date, GETDATE())
		
		IF(@IsZeroLevel = 1)
		BEGIN
			IF(@Workflow_Code_AR_WA = 0)
					SET @Workflow_Code_AR_WA = Null

			IF @Waiting_Archive = 'AR'
					SET @Is_Active = 'N' 

			INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
			SELECT @Module_Code, @Record_Code, @Waiting_Archive, @Login_User, GETDATE(), RIGHT(@Remarks_Approval, LEN(@Remarks_Approval) - 3),@Version_No

			IF(@Module_Code = 30)
			BEGIN
					UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA ,Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code

					SELECT @AgreementNo = Agreement_No FROM Acq_Deal  WHERE Acq_Deal_Code = @Record_Code

					UPDATE AD SET AD.Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() FROM Acq_Deal AD WHERE AD.Agreement_No LIKE '%'+@AgreementNo+'%' AND AD.Is_Master_Deal = 'N'
				
					SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail WHERE Record_Code = @Record_Code and Module_Code = 30

					INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
					SELECT @Record_Code, 'A', 'P', GETDATE(), 'N', NULL

				END
			IF(@Module_Code = 35)
			BEGIN
					UPDATE Syn_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA, Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE()
					WHERE Syn_Deal_Code = @Record_Code

					SELECT @AgreementNo = Agreement_No FROM Syn_Deal  WHERE Syn_Deal_Code = @Record_Code

				
					SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail WHERE Record_Code = @Record_Code and Module_Code = 35
					
					DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Code = @Record_Code

					INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
					SELECT DISTINCT Syn_Deal_Code, 'S', 'P', GETDATE(), 'D', Syn_Deal_Rights_Code FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @Record_Code

		
				END
		END
		ELSE 
		BEGIN
			--INSERT INTO MSH TABLE
			INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
			SELECT @Module_Code, @Record_Code, @Waiting_Archive, @Login_User, GETDATE(), RIGHT(@Remarks_Approval, LEN(@Remarks_Approval) - 3),@Version_No

			--UPDATE DEAL WORKFLOW STATUS OF ACQ DEAL TABLE
		
			IF @Module_Code = 30
			BEGIN
					UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA, Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code
					SELECT @AgreementNo = Agreement_No FROM Acq_Deal  WHERE Acq_Deal_Code = @Record_Code
					UPDATE AD SET Work_Flow_Code = @Workflow_Code_AR_WA, AD.Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() FROM Acq_Deal AD WHERE AD.Agreement_No LIKE '%'+@AgreementNo+'%' AND AD.Is_Master_Deal = 'N'
					SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail WHERE Record_Code = @Record_Code and Module_Code = 30
				END
			ELSE IF @Module_Code = 35
			BEGIN
					UPDATE Syn_Deal SET Work_Flow_Code = @Workflow_Code_AR_WA, Deal_Workflow_Status = @Waiting_Archive, Is_Active = @Is_Active, Last_Updated_Time = GETDATE() WHERE Syn_Deal_Code = @Record_Code
					SELECT @AgreementNo = Agreement_No FROM Syn_Deal  WHERE Syn_Deal_Code = @Record_Code
					SELECT  @Module_Workflow_Detail_Code = MAX(Module_Workflow_Detail_Code) FROM Module_Workflow_Detail WHERE Record_Code = @Record_Code and Module_Code = 35
			
				END
		END

		EXEC USP_SendMail_Intimation_New  @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, @Waiting_Archive, @Login_User , @Is_Error1 Out

		SELECT 'N' Is_Error	
	END
	ELSE
	BEGIN
		BEGIN TRY	
			BEGIN TRAN				

			DELETE FROM Module_Workflow_Detail WHERE Module_Code = @Module_Code And Record_Code = @Record_Code

			INSERT INTO Module_Workflow_Detail
			(
				Module_Code, Record_Code, Group_Code, Primary_User_Code, Role_Level, Is_Done, Next_Level_Group, Entry_Date
			)

			SELECT T1.Module_Code, T1.Record_Code, T1.Group_Code, T1.Primary_User_Code, T1.Id - 1, T1.Is_Done, T2.Group_Code, GETDATE() Entry_Date
			FROM #Temp T1
			LEFT OUTER JOIN #Temp T2 ON T1.Id + 1 = T2.Id

			IF(@Module_Code IN (30, 35, 163))
			BEGIN
				DECLARE @Status VARCHAR(2) = '', @Module_Status_History_Code INT = 0		
				SELECT TOP 1 @Status  = ISNULL([Status],''), @Module_Status_History_Code = ISNULL(Record_Code, 0)
				FROM Module_Status_History 
				WHERE Record_Code = @Record_Code AND Module_Code = @Module_Code
				ORDER BY Status_Changed_On DESC
	
				IF(@Module_Status_History_Code = 0)
				BEGIN
					INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
					SELECT @Module_Code, @Record_Code, 'C', @Created_By, @Created_Date, @Remarks,@Version_No
				END
				ELSE IF(@Status  = 'A')
				BEGIN
					INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
					SELECT @Module_Code, @Record_Code, 'AM', @Last_Action_By, @Last_Updated_Date, @Remarks,@Version_No
				END		
				ELSE IF(@Status  = 'R')
				BEGIN
					INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
					SELECT @Module_Code, @Record_Code, 'E', @Last_Action_By, @Last_Updated_Date, @Remarks,@Version_No
				END	
			END

			DECLARE @Cnt INT = 0
			SELECT @Cnt = COUNT(*) FROM #Temp

			DECLARE @Workflow_Code INT = 0
			SELECT @Workflow_Code = Workflow_Code FROM Workflow_Module 
			WHERE Module_Code = @Module_Code And (Business_Unit_Code = @BU_Code Or @BU_Code < 1)
			AND CAST(GETDATE() AS DATE) BETWEEN Effective_Start_Date AND ISNULL(System_End_Date, GETDATE())
		
			DECLARE @Is_Error CHAR(1) =''
			IF(@Cnt = 1)
			BEGIN
				IF(@Workflow_Code = 0)
					SET @Workflow_Code = Null
		
				IF(@Module_Code = 30)
				BEGIN
					UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'A'--, Last_Updated_Time = GETDATE()
					WHERE Acq_Deal_Code = @Record_Code													
					--EXEC DBO.USP_Generate_Title_Content @Record_Code, '', @Login_User

					INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,30, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)
					--EXEC DBO.USP_AT_Acq_Deal @Record_Code, @Is_Error 		
					SET @Is_Error = 'Y'		
				END
				ELSE IF(@Module_Code = 35)
				BEGIN
					Update Syn_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'A'--, Last_Updated_Time = GETDATE() 
					WHERE Syn_Deal_Code = @Record_Code
					--EXEC DBO.USP_AT_Syn_Deal @Record_Code, @Is_Error OUT

					INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,35, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)

					DECLARE @StatusFlag VARCHAR(1), @ErrMessage VARCHAR(1)
					--EXEC DBO.USP_AutoPushAcqDeal @Record_Code, @Login_User, @StatusFlag OUT, @ErrMessage OUT
				END	
				ELSE IF(@Module_Code = 163)
				BEGIN
					Update Music_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'A', Last_Updated_Time = GETDATE() 
					WHERE Music_Deal_Code = @Record_Code
					EXEC DBO.USP_AT_Music_Deal @Record_Code, @Is_Error OUT
				END	

				IF(@Module_Code IN (30, 35, 163))
				BEGIN    
					INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)    
					SELECT @Module_Code, @Record_Code, 'A', @Login_User, GetDate(), @Remarks_Approval ,@Version_No 
					SET @Is_Error = 'N'    
				END   

				IF(@Module_Code = 154)
				BEGIN
					UPDATE Music_Schedule_Transaction SET Workflow_Status = 'A' 
					WHERE Music_Schedule_Transaction_Code = @Record_Code

					INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)
					SELECT @Module_Code, @Record_Code, 'A', @Login_User, GetDate(), @Remarks,@Version_No
					SET @Is_Error = 'N'	
				END
			END
			ELSE
			BEGIN
				IF(@Module_Code = 30)
				BEGIN
					UPDATE Acq_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'W' WHERE Acq_Deal_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 35)
				BEGIN
					UPDATE Syn_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'W' WHERE Syn_Deal_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 154)
				BEGIN
					UPDATE Music_Schedule_Transaction SET Workflow_Status = 'W' WHERE Music_Schedule_Transaction_Code = @Record_Code
				END
				ELSE IF(@Module_Code = 163)
				BEGIN
					UPDATE Music_Deal SET Work_Flow_Code = @Workflow_Code, Deal_Workflow_Status = 'W' WHERE Music_Deal_Code = @Record_Code
				END

				IF(@Module_Code IN (30, 35, 163))
				BEGIN    
					INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)    
					Select @Module_Code, @Record_Code, 'W', @Login_User, GetDate(), @Remarks_Approval ,@Version_No 
					SET @Is_Error = 'N'    
				END    
    
				IF(@Module_Code = 154)    
				BEGIN
					UPDATE Music_Schedule_Transaction SET Workflow_Status = 'W' 
					WHERE Music_Schedule_Transaction_Code = @Record_Code    
    
					INSERT INTO Module_Status_History( Module_Code, Record_Code, Status, Status_Changed_By, Status_Changed_On, Remarks,Version_No)    
					SELECT @Module_Code, @Record_Code, 'W', @Login_User, GetDate(), @Remarks,@Version_No 
					SET @Is_Error = 'N'     
				END
				IF(@Is_Email_Required = 'Y')
					EXEC DBO.USP_SendMail_To_NextApprover_New @Record_Code, @Module_Code, 'Y', 'Y', @Is_Error 
			END		
			SELECT CAST(@Cnt AS VARCHAR) + '~' + ISNULL(@Is_Error, '') Is_Error		
			DROP TABLE #Temp
			COMMIT
		END TRY
		BEGIN CATCH				
			ROLLBACK;
			SET @Is_Error = 'Y'
			DECLARE @ErrorMessage NVARCHAR(4000),@Error_Line NVARCHAR(4000)		
			SELECT @ErrorMessage  = ERROR_MESSAGE() ,@Error_Line = ERROR_LINE() 		
			SELECT  @ErrorMessage + ' ' + @Error_Line + '~' + ISNULL(@Is_Error, '') Is_Error
		END CATCH	
	END

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
END
GO
PRINT N'Altering [dbo].[USP_AT_Acq_Deal]...';


GO
ALTER PROCEDURE [dbo].[USP_AT_Acq_Deal]
(
	@Acq_Deal_Code INT, @Is_Error Varchar(1) Output, @Is_Edit_WO_Approval CHAR(1)='N'
)
AS
-- =============================================
-- Author:		Khan Faisal
-- Create date: 07 Oct, 2014
-- Description:	Archieve an acquisition deal
-- Last update by : Akshay Rane
-- Last Change : Added One column in AT_Acq_Deal_Cost_Costtype_Episode (Per_Eps_Amount)
-- =============================================
BEGIN
	DECLARE @Parameter_Name VARCHAR(500), @Process_User INT, @Title_Code VARCHAR(4000)
	DECLARE @Acq_Deal_Tab_Version_Code INT
	SELECT @Parameter_Name=Parameter_Value FROM System_Parameter_New WHERE Parameter_Name='Edit_WO_Approval_Tabs'
	CREATE TABLE #Edit_WO_Approval(Tab_Name VARCHAR(10))

	INSERT INTO #Edit_WO_Approval(Tab_Name)	
	SELECT number FROM dbo.[fn_Split_withdelemiter](@Parameter_Name,',') WHERE number!=''

	SET NOCOUNT ON 
	
	UPDATE BMS_Schedule_Process_Data_Temp SET Record_Status = 'P' WHERE Acq_Deal_Code = @Acq_Deal_Code AND ISNULL(Is_Deal_Approved,'') = 'N'

	Select @Process_User = User_Code From Deal_PRocess Where Deal_Code = @Acq_Deal_Code AND Record_Status = 'W'
	SELECT @Title_Code =
	STUFF((
		SELECT DISTINCT  ', ' + (CAST(Title_Code AS VARCHAR)) FROM Acq_Deal_Movie
		where Acq_Deal_Code = @Acq_Deal_Code 
		FOR XML PATH('')), 1, 1, ''
	) 
	--SELECT @Title_Code = Title_Code FROM Acq_Deal_Movie where Acq_Deal_Code = @Acq_Deal_Code 
	EXEC DBO.USP_Generate_Title_Content @Acq_Deal_Code, @Title_Code, @Process_User

	IF(@Is_Edit_WO_Approval='N')
    BEGIN
	IF((SELECT COUNT(Acq_Deal_Code) FROM Acq_Deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Acq_Deal_Code AND Is_Master_Deal = 'Y' And (Cast([Version] As float) = 1 OR Acq_Deal_Code IN(SELECT Acq_Deal_Code FROM BMS_Deal))) > 0)
	BEGIN
		--EXEC USP_BMS_Deal_Data_Generation @Acq_Deal_Code
		INSERT INTO BMS_Process_Deals( [Acq_Deal_Code], [Record_Status],[Created_On],[Process_Start],[Process_End])
		SELECT @Acq_Deal_Code ,'P',GETDATE(),NULL,NULL
	END

	IF((SELECT COUNT(Acq_Deal_Code) FROM Acq_Deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Acq_Deal_Code AND Is_Master_Deal = 'Y' ) > 0)
	BEGIN
		INSERT INTO Integration_Deal( [Acq_Deal_Code], [Record_Status],[Created_On],[Process_Start],[Process_End])
		SELECT @Acq_Deal_Code ,'P',GETDATE(),NULL,NULL
	END

	UPDATE Acq_Deal_Movie SET Is_Closed = 'Y' WHERE Is_Closed = 'X' AND Acq_Deal_Code = @Acq_Deal_Code

	IF((SELECT COUNT(Record_Code) FROM Module_Status_History WHERE Record_Code = @Acq_Deal_Code AND Module_Code = 30  AND [Status] = 'AM') > 0)
	BEGIN
	--	EXEC [dbo].[USP_Avail_Acq_Cache]  @Acq_Deal_Code ,'Y'
		INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend)
		VALUES(@Acq_Deal_Code, 'A', 'P', GETDATE(), 'Y')
	END
	ELSE	
	BEGIN
	--	EXEC USP_Avail_Acq_Cache @Acq_Deal_Code,'N'
		INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend)
		VALUES(@Acq_Deal_Code, 'A', 'P', GETDATE(), 'N')
				
	END

	--EXEC USP_Generate_Acq_Rights_Title_Eps @Acq_Deal_Code

	/******************************** Insert into AT_Acq_Deal *****************************************/ 
	INSERT INTO AT_Acq_Deal (
		Acq_Deal_Code, Agreement_No, Version, Agreement_Date, Deal_Desc, Deal_Type_Code, Year_Type, Entity_Code, Is_Master_Deal, 
		Category_Code, Vendor_Code, Vendor_Contacts_Code, Currency_Code, Exchange_Rate, Ref_No, Attach_Workflow, Deal_Workflow_Status, 
		Parent_Deal_Code, Work_Flow_Code, Amendment_Date, Is_Released, Release_On, Release_By, Is_Completed, Is_Active, Content_Type, 
		Payment_Terms_Conditions, Status, Is_Auto_Generated, Is_Migrated, Cost_Center_Id, Master_Deal_Movie_Code_ToLink, BudgetWise_Costing_Applicable, 
		Validate_CostWith_Budget, Deal_Tag_Code, Business_Unit_Code, Ref_BMS_Code, Remarks, Rights_Remarks, Payment_Remarks, Inserted_By, 
		Inserted_On, Last_Updated_Time, Last_Action_By, Deal_Complete_Flag, All_Channel,Role_Code, Channel_Cluster_Code, Is_Auto_Push, Deal_Segment_Code, Revenue_Vertical_Code, Confirming_Party)
	SELECT Acq_Deal_Code, Agreement_No, Version, Agreement_Date, Deal_Desc, Deal_Type_Code, Year_Type, Entity_Code, Is_Master_Deal,
		Category_Code, Vendor_Code, Vendor_Contacts_Code, Currency_Code, Exchange_Rate, Ref_No, Attach_Workflow, Deal_Workflow_Status,
		Parent_Deal_Code, Work_Flow_Code, Amendment_Date, Is_Released, Release_On, Release_By, Is_Completed, Is_Active, Content_Type,
		Payment_Terms_Conditions, Status, Is_Auto_Generated, Is_Migrated, Cost_Center_Id, Master_Deal_Movie_Code_ToLink, BudgetWise_Costing_Applicable,
		Validate_CostWith_Budget, Deal_Tag_Code, Business_Unit_Code, Ref_BMS_Code, Remarks, Rights_Remarks, Payment_Remarks, Inserted_By,
		Inserted_On, Last_Updated_Time, Last_Action_By, Deal_Complete_Flag, All_Channel,Role_Code, Channel_Cluster_Code, Is_Auto_Push, Deal_Segment_Code, Revenue_Vertical_Code, Confirming_Party
	FROM Acq_Deal WHERE Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Acq_Deal_Code 
			
	/******************************** Holding identity of AT_Acq_Deal *****************************************/ 
	DECLARE @CurrIdent_AT_Acq_Deal INT
	SET @CurrIdent_AT_Acq_Deal = 0
	SELECT @CurrIdent_AT_Acq_Deal = IDENT_CURRENT('AT_Acq_Deal')


	/******************************** Insert into AT_Syn_Acq_Mapping *****************************************/ 
	INSERT INTO AT_Syn_Acq_Mapping( Syn_Acq_Mapping_Code, Syn_Deal_Code, Syn_Deal_Movie_Code, Syn_Deal_Rights_Code, AT_Acq_Deal_Code, Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date)
	SELECT  Syn_Acq_Mapping_Code,  Syn_Deal_Code,  Syn_Deal_Movie_Code,  Syn_Deal_Rights_Code,  @CurrIdent_AT_Acq_Deal,  Deal_Movie_Code, Deal_Rights_Code, Right_Start_Date, Right_End_Date 
	FROM Syn_Acq_Mapping  
	WHERE Deal_Code = @Acq_Deal_Code 
	AND Deal_Rights_Code IN (SELECT Acq_Deal_Rights_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Code = @Acq_Deal_Code)

	/******************************** Insert into AT_Acq_Deal_Licensor *****************************************/ 
	INSERT INTO AT_Acq_Deal_Licensor(AT_Acq_Deal_Code, Vendor_Code,Acq_Deal_Licensor_Code)
	SELECT @CurrIdent_AT_Acq_Deal, Vendor_Code , Acq_Deal_Licensor_Code
	FROM Acq_Deal_Licensor WHERE Acq_Deal_Code = @Acq_Deal_Code

	/******************************** Insert into AT_Acq_Deal_Movie *****************************************/ 
	INSERT INTO AT_Acq_Deal_Movie(
		AT_Acq_Deal_Code, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From, 
		Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Acq_Deal_Movie_Code,Duration_Restriction)
	SELECT @CurrIdent_AT_Acq_Deal, Title_Code, No_Of_Episodes, Notes, No_Of_Files, Is_Closed, Title_Type, Amort_Type, Episode_Starts_From, 
		Closing_Remarks, Movie_Closed_Date, Remark, Ref_BMS_Movie_Code, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By, Episode_End_To,Acq_Deal_Movie_Code,Duration_Restriction
	FROM Acq_Deal_Movie WHERE Acq_Deal_Code = @Acq_Deal_Code

	--Create Temp table for Deal Movie

	CREATE TABLE #TEMPDealMovie(	
		AT_Acq_Deal_Movie_Code INT,
		Acq_Deal_Movie_Code INT
	)

	/******************************** Insert into AT_Acq_Deal_Rights *****************************************/ 
	DECLARE @AT_Acq_Deal_Rights_Code INT
	SET @AT_Acq_Deal_Rights_Code = 0

	INSERT INTO AT_Acq_Deal_Rights (AT_Acq_Deal_Code, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
		Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
		Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date,
		Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Code, ROFR_Code, Promoter_Flag)
	SELECT @CurrIdent_AT_Acq_Deal, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, Sub_License_Code, Is_Theatrical_Right, 
		Right_Type, Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type, 
		Is_ROFR, ROFR_Date, Restriction_Remarks, Effective_Start_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
		Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Code, ROFR_Code, Promoter_Flag
	FROM Acq_Deal_Rights WHERE Acq_Deal_Code = @Acq_Deal_Code

	-------------------Insert for AT_Acq_Deal_Rights_Title ---------------------

	INSERT INTO AT_Acq_Deal_Rights_Title (AT_Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To,Acq_Deal_Rights_Title_Code)
	SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To,ADRT.Acq_Deal_Rights_Title_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal  AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code

	-------------------Insert for AT_Acq_Deal_Rights_Title_Eps -----------------

	INSERT INTO AT_Acq_Deal_Rights_Title_Eps (
		AT_Acq_Deal_Rights_Title_Code, EPS_No,Acq_Deal_Rights_Title_EPS_Code)
	SELECT
		AtADRT.AT_Acq_Deal_Rights_Title_Code, ADRTE.EPS_No,Acq_Deal_Rights_Title_EPS_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Title ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Title_EPS ADRTE ON ADRTE.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		Inner Join AT_Acq_Deal_Rights_Title AtADRT On AtADR.AT_Acq_Deal_Rights_Code = AtADRT.AT_Acq_Deal_Rights_Code 
		AND AtADRT.Acq_Deal_Rights_Title_Code = ADRT.Acq_Deal_Rights_Title_Code


	-------------------Insert for AT_Acq_Deal_Rights_Platform -------------------

	INSERT INTO AT_Acq_Deal_Rights_Platform (AT_Acq_Deal_Rights_Code, Platform_Code,Acq_Deal_Rights_Platform_Code)	
	SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRP.Platform_Code,Acq_Deal_Rights_Platform_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code

	------------------Check and Do Mass Territory Update-------------------------
			
	DECLARE @Acq_Deal_Rights_Code INT = 0,@Territory_Code INT = 0
			
	DECLARE rights_Territory_Cursor CURSOR FOR
	Select distinct adr.Acq_Deal_Rights_Code,adrt.Territory_Code from Acq_Deal_Rights adr INNER JOIN 
	Acq_Deal_Rights_Territory adrt ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
	Where adrt.Territory_Type = 'G' AND adr.Acq_Deal_Code = @Acq_Deal_Code
			
	OPEN rights_Territory_Cursor

	FETCH NEXT FROM rights_Territory_Cursor INTO @Acq_Deal_Rights_Code,@Territory_Code

	WHILE @@FETCH_STATUS = 0
	BEGIN
		INSERT INTO Acq_Deal_Rights_Territory(Acq_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code)
		Select @Acq_Deal_Rights_Code,'G', Country_Code,Territory_Code 
		FROM Territory_Details where Territory_Code = @Territory_Code AND Country_Code not in 
		(Select Country_Code from Acq_Deal_Rights_Territory
		Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and Territory_Code = @Territory_Code)
				
		FETCH NEXT FROM rights_Territory_Cursor INTO @Acq_Deal_Rights_Code,@Territory_Code
	END

	CLOSE rights_Territory_Cursor;
	DEALLOCATE rights_Territory_Cursor;
			
	-------------------Insert for AT_Acq_Deal_Rights_Territory ----------------------

	INSERT INTO AT_Acq_Deal_Rights_Territory (AT_Acq_Deal_Rights_Code, Territory_Code, Territory_Type, Country_Code , Acq_Deal_Rights_Territory_Code)	
	SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRT.Territory_Code, ADRT.Territory_Type, ADRT.Country_Code , Acq_Deal_Rights_Territory_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Territory ADRT ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code =  @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
			
	--------------------Insert for AT_Acq_Deal_Rights_Subtitling ----------------------

	INSERT INTO AT_Acq_Deal_Rights_Subtitling (AT_Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type ,Acq_Deal_Rights_Subtitling_Code)	
	SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRS.Language_Code, ADRS.Language_Group_Code, ADRS.Language_Type,Acq_Deal_Rights_Subtitling_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Subtitling ADRS ON ADR.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
			
	--------------------Insert for AT_Acq_Deal_Rights_Dubbing -------------------------

	INSERT INTO AT_Acq_Deal_Rights_Dubbing (AT_Acq_Deal_Rights_Code, Language_Code, Language_Group_Code, Language_Type,Acq_Deal_Rights_Dubbing_Code)	
	SELECT AtADR.AT_Acq_Deal_Rights_Code, ADRD.Language_Code, ADRD.Language_Group_Code, ADRD.Language_Type,Acq_Deal_Rights_Dubbing_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Dubbing ADRD ON ADR.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
			
	--------------------Insert for AT_Acq_Deal_Rights_Holdback -------------------------

	INSERT INTO AT_Acq_Deal_Rights_Holdback (AT_Acq_Deal_Rights_Code, 
		Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
		Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right,Acq_Deal_Rights_Holdback_Code)
	SELECT AtADR.AT_Acq_Deal_Rights_Code, 
		ADRH.Holdback_Type, ADRH.HB_Run_After_Release_No, ADRH.HB_Run_After_Release_Units, 
		ADRH.Holdback_On_Platform_Code, ADRH.Holdback_Release_Date, ADRH.Holdback_Comment, ADRH.Is_Title_Language_Right,Acq_Deal_Rights_Holdback_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
	---------------------Insert for AT_Acq_Deal_Rights_Holdback_Dubbing ------------------

	INSERT INTO AT_Acq_Deal_Rights_Holdback_Dubbing (
		AT_Acq_Deal_Rights_Holdback_Code, Language_Code,Acq_Deal_Rights_Holdback_Dubbing_Code)
	SELECT
		AtADRH.AT_Acq_Deal_Rights_Holdback_Code, ADRHD.Language_Code,ADRHD.Acq_Deal_Rights_Holdback_Dubbing_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Dubbing ADRHD ON ADRHD.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRH.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
				
	---------------------Insert for AT_Acq_Deal_Rights_Holdback_Platform ------------------

	INSERT INTO AT_Acq_Deal_Rights_Holdback_Platform (
		AT_Acq_Deal_Rights_Holdback_Code, Platform_Code,Acq_Deal_Rights_Holdback_Platform_Code)
	SELECT
		AtADRH.AT_Acq_Deal_Rights_Holdback_Code, ADRHP.Platform_Code,ADRHP.Acq_Deal_Rights_Holdback_Platform_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Platform ADRHP ON ADRHP.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRH.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
				
	---------------------Insert for AT_Acq_Deal_Rights_Holdback_Subtitling ----------------------

	INSERT INTO AT_Acq_Deal_Rights_Holdback_Subtitling (
		AT_Acq_Deal_Rights_Holdback_Code, Language_Code, Acq_Deal_Rights_Holdback_Subtitling_Code)
	SELECT
		AtADRH.AT_Acq_Deal_Rights_Holdback_Code, ADRHS.Language_Code,ADRHS.Acq_Deal_Rights_Holdback_Subtitling_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Subtitling ADRHS ON ADRHS.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRH.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
				
			
	----------------------Insert for AT_Acq_Deal_Rights_Holdback_Territory -----------------------

	INSERT INTO AT_Acq_Deal_Rights_Holdback_Territory (
		AT_Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code,Acq_Deal_Rights_Holdback_Territory_Code)
	SELECT
		AtADRH.AT_Acq_Deal_Rights_Holdback_Code, Territory_Type, Country_Code, Territory_Code, Acq_Deal_Rights_Holdback_Territory_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADR.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT ON ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Holdback AtADRH ON AtADRH.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRH.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code
			
	----------------------Insert for AT_Acq_Deal_Rights_Blackout ----------------------------------

	INSERT INTO AT_Acq_Deal_Rights_Blackout (
		AT_Acq_Deal_Rights_Code, 
		Start_Date, End_Date, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Blackout_Code)
	SELECT 
		AtADR.AT_Acq_Deal_Rights_Code, 
		ADRB.Start_Date, ADRB.End_Date, ADRB.Inserted_By, ADRB.Inserted_On, ADRB.Last_Updated_Time, ADRB.Last_Action_By,ADRB.Acq_Deal_Rights_Blackout_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
	-----------------------Insert for AT_Acq_Deal_Rights_Blackout_Dubbing --------------------------

	INSERT INTO AT_Acq_Deal_Rights_Blackout_Dubbing (
		AT_Acq_Deal_Rights_Blackout_Code, Language_Code, Acq_Deal_Rights_Blackout_Dubbing_Code)
	SELECT
		AtADRB.AT_Acq_Deal_Rights_Blackout_Code, ADRBD.Language_Code, ADRBD.Acq_Deal_Rights_Blackout_Dubbing_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Blackout_Dubbing ADRBD ON ADRBD.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRB.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
			
	------------------------Insert for AT_Acq_Deal_Rights_Blackout_Platform ------------------------

	INSERT INTO AT_Acq_Deal_Rights_Blackout_Platform (
		AT_Acq_Deal_Rights_Blackout_Code, Platform_Code, Acq_Deal_Rights_Blackout_Platform_Code)
	SELECT
		AtADRB.AT_Acq_Deal_Rights_Blackout_Code, ADRBP.Platform_Code, ADRBP.Acq_Deal_Rights_Blackout_Platform_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Blackout_Platform ADRBP ON ADRBP.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRB.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code


	------------------------Insert for AT_Acq_Deal_Rights_Blackout_Subtitling -----------------------

	INSERT INTO AT_Acq_Deal_Rights_Blackout_Subtitling(
		AT_Acq_Deal_Rights_Blackout_Code, Language_Code, Acq_Deal_Rights_Blackout_Subtitling_Code)
	SELECT
		AtADRB.AT_Acq_Deal_Rights_Blackout_Code, ADRBS.Language_Code, ADRBS.Acq_Deal_Rights_Blackout_Subtitling_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Blackout_Subtitling ADRBS ON ADRBS.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRB.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
			
	--------------------------Insert for AT_Acq_Deal_Rights_Blackout_Territory ------------------------

	INSERT INTO AT_Acq_Deal_Rights_Blackout_Territory(
		AT_Acq_Deal_Rights_Blackout_Code, Country_Code, Territory_Code, Territory_Type, Acq_Deal_Rights_Blackout_Territory_Code)
	SELECT
		AtADRB.AT_Acq_Deal_Rights_Blackout_Code, ADRBT.Country_Code, ADRBT.Territory_Code, ADRBT.Territory_Type, ADRBT.Acq_Deal_Rights_Blackout_Territory_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Blackout ADRB ON ADR.Acq_Deal_Rights_Code = ADRB.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Blackout_Territory ADRBT ON ADRBT.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Blackout AtADRB ON AtADRB.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRB.Acq_Deal_Rights_Blackout_Code = ADRB.Acq_Deal_Rights_Blackout_Code

		----------------------Insert for AT_Acq_Deal_Rights_Promoter ----------------------------------

	INSERT INTO AT_Acq_Deal_Rights_Promoter (
		AT_Acq_Deal_Rights_Code, 
		Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Rights_Promoter_Code)
	SELECT 
		AtADR.AT_Acq_Deal_Rights_Code, 
		 ADRP.Inserted_By, ADRP.Inserted_On, ADRP.Last_Updated_Time, ADRP.Last_Action_By,ADRP.Acq_Deal_Rights_Promoter_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			
			-----------------------Insert for AT_Acq_Deal_Rights_Promoter_Group --------------------------

	INSERT INTO AT_Acq_Deal_Rights_Promoter_Group (
		AT_Acq_Deal_Rights_Promoter_Code, Promoter_Group_Code, Acq_Deal_Rights_Promoter_Group_Code)
	SELECT
		AtADRP.AT_Acq_Deal_Rights_Promoter_Code, ADRPG.Promoter_Group_Code, ADRPG.Acq_Deal_Rights_Promoter_Group_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Promoter_Group ADRPG ON ADRPG.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Promoter AtADRP ON AtADRP.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRP.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code

			-----------------------Insert for AT_Acq_Deal_Rights_Promoter_Remarks --------------------------

	INSERT INTO AT_Acq_Deal_Rights_Promoter_Remarks (
		AT_Acq_Deal_Rights_Promoter_Code, Promoter_Remarks_Code, Acq_Deal_Rights_Promoter_Remarks_Code)
	SELECT
		AtADRP.AT_Acq_Deal_Rights_Promoter_Code, ADRPR.Promoter_Remarks_Code, ADRPR.Acq_Deal_Rights_Promoter_Remarks_Code
	FROM Acq_Deal_Rights ADR
		INNER JOIN Acq_Deal_Rights_Promoter ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code and ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Promoter_Remarks ADRPR ON ADRPR.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code
		INNER JOIN AT_Acq_Deal_Rights AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
		INNER JOIN AT_Acq_Deal_Rights_Promoter AtADRP ON AtADRP.AT_Acq_Deal_Rights_Code = AtADR.AT_Acq_Deal_Rights_Code AND AtADRP.Acq_Deal_Rights_Promoter_Code = ADRP.Acq_Deal_Rights_Promoter_Code

	---------------------------Insert for AT_Acq_Deal_Pushback ------------------------------------------

	INSERT INTO AT_Acq_Deal_Pushback(AT_Acq_Deal_Code, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, 
			Milestone_Unit_Type, Is_Title_Language_Right, Remarks, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, Acq_Deal_Pushback_Code)
	SELECT @CurrIdent_AT_Acq_Deal, Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Milestone_Type_Code, Milestone_No_Of_Unit, 
		Milestone_Unit_Type, Is_Title_Language_Right, Remarks, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By , Acq_Deal_Pushback_Code
	FROM Acq_Deal_Pushback WHERE Acq_Deal_Code = @Acq_Deal_Code

	---------------------------Insert for AT_Acq_Deal_Pushback_Dubbing -----------------------------------

	INSERT INTO AT_Acq_Deal_Pushback_Dubbing(
		AT_Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code, Acq_Deal_Pushback_Dubbing_Code)
	SELECT 
		AtADP.AT_Acq_Deal_Pushback_Code, ADPD.Language_Type, ADPD.Language_Code, ADPD.Language_Group_Code, ADPD.Acq_Deal_Pushback_Dubbing_Code
	FROM Acq_Deal_Pushback ADP
		INNER JOIN Acq_Deal_Pushback_Dubbing ADPD ON ADPD.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Pushback AtADP ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
				
	---------------------------Insert for AT_Acq_Deal_Pushback_Platform ----------------------------------

	INSERT INTO AT_Acq_Deal_Pushback_Platform(
		AT_Acq_Deal_Pushback_Code, Platform_Code,Acq_Deal_Pushback_Platform_Code)
	SELECT 
		AtADP.AT_Acq_Deal_Pushback_Code, ADPP.Platform_Code, ADPP.Acq_Deal_Pushback_Platform_Code
	FROM Acq_Deal_Pushback ADP
		INNER JOIN Acq_Deal_Pushback_Platform ADPP ON ADPP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Pushback AtADP ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
			
	----------------------------Insert for AT_Acq_Deal_Pushback_Subtitling --------------------------------

	INSERT INTO AT_Acq_Deal_Pushback_Subtitling(
		AT_Acq_Deal_Pushback_Code, Language_Type, Language_Code, Language_Group_Code, Acq_Deal_Pushback_Subtitling_Code)
	SELECT 
		AtADP.AT_Acq_Deal_Pushback_Code, ADPS.Language_Type, ADPS.Language_Code, ADPS.Language_Group_Code, ADPS.Acq_Deal_Pushback_Subtitling_Code
	FROM Acq_Deal_Pushback ADP
		INNER JOIN Acq_Deal_Pushback_Subtitling ADPS ON ADPS.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Pushback AtADP ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
			
	-----------------------------Insert for AT_Acq_Deal_Pushback_Territory ---------------------------------

	INSERT INTO AT_Acq_Deal_Pushback_Territory(
		AT_Acq_Deal_Pushback_Code, Territory_Type, Country_Code, Territory_Code, Acq_Deal_Pushback_Territory_Code)
	SELECT 
		AtADP.AT_Acq_Deal_Pushback_Code, ADPT.Territory_Type, ADPT.Country_Code, ADPT.Territory_Code, ADPT.Acq_Deal_Pushback_Territory_Code
	FROM Acq_Deal_Pushback ADP
		INNER JOIN Acq_Deal_Pushback_Territory ADPT ON ADPT.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Pushback AtADP ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
			
	------------------------------Insert for AT_Acq_Deal_Pushback_Title -------------------------------------

	INSERT INTO AT_Acq_Deal_Pushback_Title(
		AT_Acq_Deal_Pushback_Code, Title_Code, Episode_From, Episode_To, Acq_Deal_Pushback_Title_Code)
	SELECT 
		AtADP.AT_Acq_Deal_Pushback_Code, ADPT.Title_Code, ADPT.Episode_From, ADPT.Episode_To,ADPT.Acq_Deal_Pushback_Title_Code
	FROM Acq_Deal_Pushback ADP
		INNER JOIN Acq_Deal_Pushback_Title ADPT ON ADPT.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code  and ADP.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Pushback AtADP ON AtADP.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADP.Acq_Deal_Pushback_Code = ADP.Acq_Deal_Pushback_Code
	
	/******************************** Insert into AT_Acq_Deal_Ancillary *****************************************/ 
	INSERT INTO AT_Acq_Deal_Ancillary (
		AT_Acq_Deal_Code, Ancillary_Type_code, Duration, Day, Remarks, Group_No, Acq_Deal_Ancillary_Code,Catch_Up_From)
	SELECT @CurrIdent_AT_Acq_Deal, Ancillary_Type_code, Duration, Day, Remarks, Group_No, Acq_Deal_Ancillary_Code, Catch_Up_From
		FROM Acq_Deal_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code
			
	/******************************** Insert into AT_Acq_Deal_Ancillary_Platform *****************************************/ 

	INSERT INTO AT_Acq_Deal_Ancillary_Platform (
		AT_Acq_Deal_Ancillary_Code, Ancillary_Platform_code, Acq_Deal_Ancillary_Platform_Code, Platform_Code)
	SELECT AtADA.AT_Acq_Deal_Ancillary_Code, ADAP.Ancillary_Platform_code, ADAP.Acq_Deal_Ancillary_Platform_Code, ADAP.Platform_Code
	FROM Acq_Deal_Ancillary ADA
		INNER JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Ancillary AtADA ON AtADA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADA.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code

	/******************************** Insert into AT_Acq_Deal_Ancillary_Platform_Medium *****************************************/ 

	INSERT INTO AT_Acq_Deal_Ancillary_Platform_Medium(
		AT_Acq_Deal_Ancillary_Platform_Code, Ancillary_Platform_Medium_Code, Acq_Deal_Ancillary_Platform_Medium_Code)
	SELECT AtADAP.AT_Acq_Deal_Ancillary_Platform_Code, ADAPM.Ancillary_Platform_Medium_Code,ADAPM.Acq_Deal_Ancillary_Platform_Medium_Code
	FROM Acq_Deal_Ancillary ADA
		INNER JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code  and ADA.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN Acq_Deal_Ancillary_Platform_Medium ADAPM ON ADAPM.Acq_Deal_Ancillary_Platform_Code = ADAP.Acq_Deal_Ancillary_Platform_Code
		INNER JOIN AT_Acq_Deal_Ancillary AtADA ON AtADA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADA.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
		INNER JOIN AT_Acq_Deal_Ancillary_Platform AtADAP ON AtADAP.AT_Acq_Deal_Ancillary_Code = AtADA.AT_Acq_Deal_Ancillary_Code
			AND AtADAP.AT_Acq_Deal_Ancillary_Code = AtADA.AT_Acq_Deal_Ancillary_Code
			AND	AtADAP.Ancillary_Platform_code = ADAP.Ancillary_Platform_code

	/******************************** Insert into AT_Acq_Deal_Ancillary_Title *****************************************/ 

	INSERT INTO AT_Acq_Deal_Ancillary_Title (
		AT_Acq_Deal_Ancillary_Code, Title_Code, Episode_From, Episode_To, Acq_Deal_Ancillary_Title_Code)
	SELECT AtADA.AT_Acq_Deal_Ancillary_Code, ADAT.Title_Code, ADAT.Episode_From, ADAT.Episode_To , ADAT.Acq_Deal_Ancillary_Title_Code
	FROM Acq_Deal_Ancillary ADA
		INNER JOIN Acq_Deal_Ancillary_Title ADAT ON ADAT.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code AND ADA.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Ancillary AtADA ON AtADA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADA.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
END

	IF(@Is_Edit_WO_Approval='N' OR EXISTS(SELECT * FROM #Edit_WO_Approval WHERE Tab_Name='RU'))
    BEGIN   
	/******************************** Insert into AT_Acq_Deal_Run *****************************************/ 
	
		IF(@Is_Edit_WO_Approval='Y')
		BEGIN
		SET @CurrIdent_AT_Acq_Deal=(Select TOP 1 AT_Acq_Deal_Code from AT_Acq_Deal Where Acq_Deal_Code=@Acq_Deal_Code ORDER BY AT_Acq_Deal_Code DESC)
		END
		Select TOP 1 @Acq_Deal_Tab_Version_Code=Acq_Deal_Tab_Version_Code from Acq_Deal_Tab_Version Where Acq_Deal_Code=@Acq_Deal_Code ORDER BY Acq_Deal_Tab_Version_Code DESC
		
		INSERT INTO AT_Acq_Deal_Run(
			AT_Acq_Deal_Code, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code, 
			Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights, Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,
			All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,
			Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count,
			Off_Prime_Time_Balance_Count,Acq_Deal_Run_Code,Acq_Deal_Tab_Version_Code,Syndication_Runs,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time, Channel_Type, Channel_Category_Code)
		SELECT @CurrIdent_AT_Acq_Deal, Run_Type, No_Of_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Is_Yearwise_Definition, Is_Rule_Right, Right_Rule_Code, 
			Repeat_Within_Days_Hrs, No_Of_Days_Hrs, Is_Channel_Definition_Rights, Primary_Channel_Code, Run_Definition_Type, Run_Definition_Group_Code,
			All_Channel, Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run,
			Prime_Time_Provisional_Run_Count,Prime_Time_AsRun_Count,Prime_Time_Balance_Count,Off_Prime_Time_Provisional_Run_Count,Off_Prime_Time_AsRun_Count,
			Off_Prime_Time_Balance_Count,Acq_Deal_Run_Code,@Acq_Deal_Tab_Version_Code,Syndication_Runs,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time,
			Channel_Type, Channel_Category_Code
		FROM Acq_Deal_Run WHERE Acq_Deal_Code = @Acq_Deal_Code
			
		/******************************** Insert into AT_Acq_Deal_Run_Channel *****************************************/ 
			 
		INSERT INTO AT_Acq_Deal_Run_Channel (
			AT_Acq_Deal_Run_Code, Channel_Code, Min_Runs, Max_Runs, No_Of_Runs_Sched, No_Of_AsRuns, Do_Not_Consume_Rights, 
			Is_Primary, Inserted_By, Inserted_On, Last_action_By, Last_updated_Time, Acq_Deal_Run_Channel_Code)
		SELECT 
			AtADR.AT_Acq_Deal_Run_Code, ADRC.Channel_Code, ADRC.Min_Runs, ADRC.Max_Runs, ADRC.No_Of_Runs_Sched, ADRC.No_Of_AsRuns, ADRC.Do_Not_Consume_Rights, 
			ADRC.Is_Primary, ADRC.Inserted_By, ADRC.Inserted_On, ADRC.Last_action_By, ADRC.Last_updated_Time, ADRC.Acq_Deal_Run_Channel_Code
		FROM Acq_Deal_Run ADR
			INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Run AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			
		/******************************** Insert into AT_Acq_Deal_Run_Repeat_On_Day *****************************************/ 

		INSERT INTO AT_Acq_Deal_Run_Repeat_On_Day (AT_Acq_Deal_Run_Code, Day_Code, Acq_Deal_Run_Repeat_On_Day_Code)
		SELECT AtADR.AT_Acq_Deal_Run_Code, ADRRD.Day_Code , ADRRD.Acq_Deal_Run_Repeat_On_Day_Code
		FROM Acq_Deal_Run ADR
			INNER JOIN Acq_Deal_Run_Repeat_On_Day ADRRD ON ADRRD.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Run AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code

		/******************************** Insert into AT_Acq_Deal_Run_Shows *****************************************/ 			
		CREATE TABLE #Temp_Shows
		(
			AT_Acq_Deal_Run_Code INT,
			Data_For CHAR(1),
			Title_Code INT,
			Episode_From INT,
			Episode_To INT,
			Inserted_By INT,
			Inserted_On DATETIME,				
			Acq_Deal_Run_Shows_Code INT,
			Acq_Deal_Movie_Code INT,
			AT_Acq_Deal_Movie_Code INT
		)
		INSERT INTO #Temp_Shows(
			AT_Acq_Deal_Run_Code,
			Acq_Deal_Movie_Code,
			Data_For,
			Title_Code,
			Episode_From,
			Episode_To,
			Inserted_By,
			Inserted_On,
			Acq_Deal_Run_Shows_Code
		)
		SELECT DISTINCT AtADR.AT_Acq_Deal_Run_Code,ADRS.Acq_Deal_Movie_Code,ADRS.Data_For,ADRS.Title_Code,ADRS.Episode_From,ADRS.Episode_To,ADRS.Inserted_By,ADRS.Inserted_On,ADRS.Acq_Deal_Run_Shows_Code
		FROM Acq_Deal_Run ADR
		INNER JOIN Acq_Deal_Run_Shows ADRS ON ADRS.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
		INNER JOIN AT_Acq_Deal_Run AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code						

		UPDATE T SET T.AT_Acq_Deal_Movie_Code = ATADM.AT_Acq_Deal_Movie_Code
		FROM #Temp_Shows T
		INNER JOIN AT_Acq_Deal_Movie ATADM ON T.Acq_Deal_Movie_Code = ATADM.Acq_Deal_Movie_Code

		INSERT INTO AT_Acq_Deal_Run_Shows(AT_Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,
			AT_Acq_Deal_Movie_Code,Inserted_By,Inserted_On,Acq_Deal_Run_Shows_Code)
		SELECT AT_Acq_Deal_Run_Code,Data_For,Title_Code,Episode_From,Episode_To,
		AT_Acq_Deal_Movie_Code,Inserted_By,Inserted_On,Acq_Deal_Run_Shows_Code
		FROM #Temp_Shows T

		DROP TABLE #Temp_Shows

		/******************************** Insert into AT_Acq_Deal_Run_Title *****************************************/ 

		INSERT INTO AT_Acq_Deal_Run_Title (AT_Acq_Deal_Run_Code, Title_Code, Episode_From, Episode_To, Acq_Deal_Run_Title_Code)
		SELECT AtADR.AT_Acq_Deal_Run_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To, ADRT.Acq_Deal_Run_Title_Code
		FROM Acq_Deal_Run ADR
			INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Run AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			
		/******************************** Insert into AT_Acq_Deal_Run_Yearwise_Run *****************************************/ 

		INSERT INTO AT_Acq_Deal_Run_Yearwise_Run ( 
			AT_Acq_Deal_Run_Code, Start_Date, End_Date, No_Of_Runs, No_Of_Runs_Sched, 
			No_Of_AsRuns, Inserted_By, Inserted_On, Last_action_By, Last_updated_Time, Acq_Deal_Run_Yearwise_Run_Code)
		SELECT 
			AtADR.AT_Acq_Deal_Run_Code, ADRYR.Start_Date, ADRYR.End_Date, ADRYR.No_Of_Runs, ADRYR.No_Of_Runs_Sched, 
			ADRYR.No_Of_AsRuns, ADRYR.Inserted_By, ADRYR.Inserted_On, ADRYR.Last_action_By, ADRYR.Last_updated_Time,ADRYR.Acq_Deal_Run_Yearwise_Run_Code
		FROM Acq_Deal_Run ADR
			INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR ON ADRYR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Run AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			
		/******************************** Insert into AT_Acq_Deal_Run_Yearwise_Run_Week *****************************************/ 

		INSERT INTO AT_Acq_Deal_Run_Yearwise_Run_Week ( 
			AT_Acq_Deal_Run_Yearwise_Run_Code, AT_Acq_Deal_Run_Code, Start_Week_Date, End_Week_Date, Is_Preferred, 
			Inserted_By, Inserted_On, Last_action_By, Last_updated_Time, Acq_Deal_Run_Yearwise_Run_Week_Code)
		SELECT 
			AtADRYR.AT_Acq_Deal_Run_Yearwise_Run_Code, AtADR.AT_Acq_Deal_Run_Code, 
			ADRYRW.Start_Week_Date, ADRYRW.End_Week_Date, ADRYRW.Is_Preferred, ADRYRW.Inserted_By, ADRYRW.Inserted_On, 
			ADRYRW.Last_action_By, ADRYRW.Last_updated_Time, ADRYRW.Acq_Deal_Run_Yearwise_Run_Week_Code
		FROM Acq_Deal_Run ADR
			INNER JOIN Acq_Deal_Run_Yearwise_Run ADRYR ON ADRYR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADR.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Run_Yearwise_Run_Week ADRYRW ON ADRYRW.Acq_Deal_Run_Yearwise_Run_Code = ADRYR.Acq_Deal_Run_Yearwise_Run_Code
			INNER JOIN AT_Acq_Deal_Run AtADR ON AtADR.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADR.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
			INNER JOIN AT_Acq_Deal_Run_Yearwise_Run AtADRYR ON AtADRYR.AT_Acq_Deal_Run_Code = AtADR.AT_Acq_Deal_Run_Code AND
			AtADRYR.Acq_Deal_Run_Yearwise_Run_Code = ADRYR.Acq_Deal_Run_Yearwise_Run_Code
			END
			IF(@Is_Edit_WO_Approval='N' OR EXISTS(SELECT * FROM #Edit_WO_Approval WHERE Tab_Name='CO'))
    BEGIN 
		/******************************** Insert into Acq_Deal_Cost *****************************************/ 
		
		INSERT INTO AT_Acq_Deal_Cost(
			AT_Acq_Deal_Code, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, Catchup_Cost, 
			Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By,Incentive,Remarks, Acq_Deal_Cost_Code,Acq_Deal_Tab_Version_Code)
		SELECT @CurrIdent_AT_Acq_Deal, Currency_Code, Currency_Exchange_Rate, Deal_Cost, Deal_Cost_Per_Episode, Cost_Center_Id, Additional_Cost, Catchup_Cost, 
			Variable_Cost_Type, Variable_Cost_Sharing_Type, Royalty_Recoupment_Code, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By,Incentive,Remarks, Acq_Deal_Cost_Code,@Acq_Deal_Tab_Version_Code
		FROM Acq_Deal_Cost WHERE Acq_Deal_Code = @Acq_Deal_Code

			
		/**************** Insert into AT_Acq_Deal_Cost_Additional_Exp ****************/ 

		INSERT INTO AT_Acq_Deal_Cost_Additional_Exp (
			AT_Acq_Deal_Cost_Code, Additional_Expense_Code, Amount, Min_Max, 
			Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Acq_Deal_Cost_Additional_Exp_Code)
		SELECT 
			AtADC.AT_Acq_Deal_Cost_Code, ADCAE.Additional_Expense_Code, ADCAE.Amount, ADCAE.Min_Max, 
			ADCAE.Inserted_On, ADCAE.Inserted_By, ADCAE.Last_Updated_Time, ADCAE.Last_Action_By, ADCAE.Acq_Deal_Cost_Additional_Exp_Code
		FROM Acq_Deal_Cost ADC
			INNER JOIN Acq_Deal_Cost_Additional_Exp ADCAE ON ADCAE.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Cost AtADC ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
		/**************** Insert into AT_Acq_Deal_Cost_Commission ****************/ 

		INSERT INTO AT_Acq_Deal_Cost_Commission (
			AT_Acq_Deal_Cost_Code, Cost_Type_Code, Royalty_Commission_Code, Entity_Code,
			Vendor_Code, Type, Commission_Type, Percentage, Amount)
		SELECT 
			AtADC.AT_Acq_Deal_Cost_Code, ADCC.Cost_Type_Code, ADCC.Royalty_Commission_Code, ADCC.Entity_Code,
			ADCC.Vendor_Code, ADCC.Type, ADCC.Commission_Type, ADCC.Percentage, ADCC.Amount
		FROM Acq_Deal_Cost ADC
			INNER JOIN Acq_Deal_Cost_Commission ADCC ON ADCC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Cost AtADC ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
		/**************** Insert into AT_Acq_Deal_Cost_Title ****************/
						 
		INSERT INTO AT_Acq_Deal_Cost_Title (AT_Acq_Deal_Cost_Code, Title_Code, Episode_From, Episode_To, Acq_Deal_Cost_Title_Code)
		SELECT 
			AtADC.AT_Acq_Deal_Cost_Code, ADCT.Title_Code, ADCT.Episode_From, ADCT.Episode_To, ADCT.Acq_Deal_Cost_Title_Code
		FROM Acq_Deal_Cost ADC
			INNER JOIN Acq_Deal_Cost_Title ADCT ON ADCT.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Cost AtADC ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
		/**************** Insert into AT_Acq_Deal_Cost_Variable_Cost ****************/

		INSERT INTO AT_Acq_Deal_Cost_Variable_Cost (
			AT_Acq_Deal_Cost_Code, Entity_Code, Vendor_Code, Percentage, Amount, 
			Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Acq_Deal_Cost_Variable_Cost_Code)
		SELECT 
			AtADC.AT_Acq_Deal_Cost_Code, ADCVC.Entity_Code, ADCVC.Vendor_Code, ADCVC.Percentage, ADCVC.Amount, 
			ADCVC.Inserted_On, ADCVC.Inserted_By, ADCVC.Last_Updated_Time, ADCVC.Last_Action_By, ADCVC.Acq_Deal_Cost_Variable_Cost_Code
		FROM Acq_Deal_Cost ADC
			INNER JOIN Acq_Deal_Cost_Variable_Cost ADCVC ON ADCVC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Cost AtADC ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
		/**************** Insert into AT_Acq_Deal_Cost_Costtype ****************/ 
			
		INSERT INTO AT_Acq_Deal_Cost_Costtype (
			AT_Acq_Deal_Cost_Code, Cost_Type_Code, Amount, Consumed_Amount, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Acq_Deal_Cost_Costtype_Code)
		SELECT 
			AtADC.AT_Acq_Deal_Cost_Code, 
			ADCC.Cost_Type_Code, ADCC.Amount, ADCC.Consumed_Amount, ADCC.Inserted_On, ADCC.Inserted_By, ADCC.Last_Updated_Time, ADCC.Last_Action_By, ADCC.Acq_Deal_Cost_Costtype_Code
		FROM Acq_Deal_Cost ADC
			INNER JOIN Acq_Deal_Cost_Costtype ADCC ON ADCC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN AT_Acq_Deal_Cost AtADC ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			
		/******** Insert into AT_Acq_Deal_Cost_Costtype_Episode ********/ 

		INSERT INTO AT_Acq_Deal_Cost_Costtype_Episode (
			AT_Acq_Deal_Cost_Costtype_Code, Episode_From, Episode_To, Amount_Type, Amount, Percentage, Remarks, Acq_Deal_Cost_Costtype_Episode_Code,Per_Eps_Amount)
		SELECT 
			AtADCC.AT_Acq_Deal_Cost_Costtype_Code,
			ADCCE.Episode_From, ADCCE.Episode_To, ADCCE.Amount_Type, ADCCE.Amount, ADCCE.Percentage, ADCCE.Remarks, ADCCE.Acq_Deal_Cost_Costtype_Episode_Code
			,ADCCE.Per_Eps_Amount
		FROM Acq_Deal_Cost ADC
			INNER JOIN Acq_Deal_Cost_Costtype ADCC ON ADCC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code AND ADC.Acq_Deal_Code = @Acq_Deal_Code
			INNER JOIN Acq_Deal_Cost_Costtype_Episode ADCCE ON ADCCE.Acq_Deal_Cost_Costtype_Code = ADCC.Acq_Deal_Cost_Costtype_Code
			INNER JOIN AT_Acq_Deal_Cost AtADC ON AtADC.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND AtADC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
			INNER JOIN AT_Acq_Deal_Cost_Costtype AtADCC ON AtADCC.AT_Acq_Deal_Cost_Code = AtADC.AT_Acq_Deal_Cost_Code AND AtADCC.Acq_Deal_Cost_Costtype_Code = ADCC.Acq_Deal_Cost_Costtype_Code

		/******** Insert into AT_Acq_Deal_Tab_Version****************/
		INSERT INTO AT_Acq_Deal_Tab_Version(Acq_Deal_Tab_Version_Code,[Version],Remarks,Acq_Deal_Code,Inserted_On,Approved_On,Approved_By)
		SELECT Acq_Deal_Tab_Version_Code,[Version],Remarks,Acq_Deal_Code,Inserted_On,Approved_On,Approved_By FROM Acq_Deal_Tab_Version
		
	END

	IF(@Is_Edit_WO_Approval='N')
	BEGIN
		/******************************** Insert into AT_Acq_Deal_Sport *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport(
			AT_Acq_Deal_Code, Content_Delivery, Obligation_Broadcast, Deferred_Live, Deferred_Live_Duration,Tape_Delayed, Tape_Delayed_Duration, Standalone_Transmission,Standalone_Substantial,Simulcast_Transmission,Simulcast_Substantial, 
			[File_Name], Sys_File_Name, Remarks, Inserted_By, Inserted_On, Last_Updated_Time, Last_Action_By, MBO_Note, Acq_Deal_Sport_Code)
		SELECT @CurrIdent_AT_Acq_Deal,Content_Delivery,Obligation_Broadcast,Deferred_Live,Deferred_Live_Duration,Tape_Delayed,Tape_Delayed_Duration,Standalone_Transmission,Standalone_Substantial,Simulcast_Transmission,Simulcast_Substantial,
				[File_Name],Sys_File_Name,Remarks,Inserted_By,Inserted_On,Last_Updated_Time,Last_Action_By, MBO_Note, Acq_Deal_Sport_Code
		FROM Acq_Deal_Sport WHERE Acq_Deal_Code = @Acq_Deal_Code


		/**************** Insert into AT_Acq_Deal_Sport_Broadcast ****************/ 

		INSERT INTO AT_Acq_Deal_Sport_Broadcast(
			AT_Acq_Deal_Sport_Code,Broadcast_Mode_Code,[Type], Acq_Deal_Sport_Broadcast_Code)
		SELECT 
			AtADS.AT_Acq_Deal_Sport_Code,ADSB.Broadcast_Mode_Code,ADSB.[Type], ADSB.Acq_Deal_Sport_Broadcast_Code
		FROM Acq_Deal_Sport_Broadcast ADSB INNER JOIN Acq_Deal_Sport ADS ON ADSB.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code
			INNER JOIN AT_Acq_Deal_Sport AtADS ON AtADS.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADS.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADS.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code

		/**************** Insert into AT_Acq_Deal_Sport_Platform ****************/ 

		INSERT INTO AT_Acq_Deal_Sport_Platform(
			AT_Acq_Deal_Sport_Code,Platform_Code,[Type], Acq_Deal_Sport_Platform_Code)
		SELECT 
			AtADS.AT_Acq_Deal_Sport_Code,ADSP.Platform_Code,ADSP.[Type], ADSP.Acq_Deal_Sport_Platform_Code
		FROM Acq_Deal_Sport_Platform ADSP INNER JOIN Acq_Deal_Sport ADS ON ADSP.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code
			INNER JOIN AT_Acq_Deal_Sport AtADS ON AtADS.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADS.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADS.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code

		/**************** Insert into AT_Acq_Deal_Sport_Title ****************/ 

		INSERT INTO AT_Acq_Deal_Sport_Title(
			AT_Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To, Acq_Deal_Sport_Title_Code)
		SELECT 
			AtADS.AT_Acq_Deal_Sport_Code,Title_Code,Episode_From,Episode_To,ADST.Acq_Deal_Sport_Title_Code
		FROM Acq_Deal_Sport_Title ADST INNER JOIN Acq_Deal_Sport ADS ON ADST.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code
			INNER JOIN AT_Acq_Deal_Sport AtADS ON AtADS.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADS.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADS.Acq_Deal_Sport_Code = ADS.Acq_Deal_Sport_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Ancillary *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Ancillary(
			AT_Acq_Deal_Code, Ancillary_For, Sport_Ancillary_Type_Code, Obligation_Broadcast, Broadcast_Window,Broadcast_Periodicity_Code, Sport_Ancillary_Periodicity_Code,
			Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos,Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks,Acq_Deal_Sport_Ancillary_Code)
		SELECT @CurrIdent_AT_Acq_Deal,Ancillary_For, Sport_Ancillary_Type_Code, Obligation_Broadcast, Broadcast_Window,Broadcast_Periodicity_Code, Sport_Ancillary_Periodicity_Code,
			Duration,No_Of_Promos,Prime_Start_Time,Prime_End_Time,Prime_Durartion,Prime_No_of_Promos,Off_Prime_Start_Time,Off_Prime_End_Time,Off_Prime_Durartion,Off_Prime_No_of_Promos,Remarks,Acq_Deal_Sport_Ancillary_Code
		FROM Acq_Deal_Sport_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Ancillary_Broadcast *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Ancillary_Broadcast(
			AT_Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Broadcast_Code,Acq_Deal_Sport_Ancillary_Broadcast_Code)
		SELECT 
			AtADSA.AT_Acq_Deal_Sport_Ancillary_Code,ADSAB.Sport_Ancillary_Broadcast_Code,ADSAB.Acq_Deal_Sport_Ancillary_Broadcast_Code
		FROM Acq_Deal_Sport_Ancillary_Broadcast ADSAB INNER JOIN Acq_Deal_Sport_Ancillary ADSA ON ADSAB.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code
			INNER JOIN AT_Acq_Deal_Sport_Ancillary AtADSA ON AtADSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSA.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADSA.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Ancillary_Source *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Ancillary_Source(
			AT_Acq_Deal_Sport_Ancillary_Code,Sport_Ancillary_Source_Code,Acq_Deal_Sport_Ancillary_Source_Code)
		SELECT 
			AtADSA.AT_Acq_Deal_Sport_Ancillary_Code,ADSAS.Sport_Ancillary_Source_Code,ADSAS.Acq_Deal_Sport_Ancillary_Source_Code
		FROM Acq_Deal_Sport_Ancillary_Source ADSAS INNER JOIN Acq_Deal_Sport_Ancillary ADSA ON ADSAS.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code
			INNER JOIN AT_Acq_Deal_Sport_Ancillary AtADSA ON AtADSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSA.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADSA.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Ancillary_Title *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Ancillary_Title(
			AT_Acq_Deal_Sport_Ancillary_Code,Title_Code,Episode_From,Episode_To,Acq_Deal_Sport_Ancillary_Title_Code)
		SELECT 
			AtADSA.AT_Acq_Deal_Sport_Ancillary_Code,ADSAT.Title_Code,ADSAT.Episode_From,ADSAT.Episode_To,ADSAT.Acq_Deal_Sport_Ancillary_Title_Code
		FROM Acq_Deal_Sport_Ancillary_Title ADSAT INNER JOIN Acq_Deal_Sport_Ancillary ADSA ON ADSAT.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code
			INNER JOIN AT_Acq_Deal_Sport_Ancillary AtADSA ON AtADSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSA.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADSA.Acq_Deal_Sport_Ancillary_Code = ADSA.Acq_Deal_Sport_Ancillary_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Monetisation_Ancillary *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Monetisation_Ancillary(
			AT_Acq_Deal_Code,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks,Acq_Deal_Sport_Monetisation_Ancillary_Code)
		SELECT @CurrIdent_AT_Acq_Deal,Appoint_Title_Sponsor,Appoint_Broadcast_Sponsor,Remarks,Acq_Deal_Sport_Monetisation_Ancillary_Code
		FROM Acq_Deal_Sport_Monetisation_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Monetisation_Ancillary_Title *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Monetisation_Ancillary_Title(
			AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,Title_Code,Episode_From,Episode_To,Acq_Deal_Sport_Monetisation_Ancillary_Title_Code)
		SELECT 
			AtADSMA.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,ADSMAT.Title_Code,ADSMAT.Episode_From,ADSMAT.Episode_To,ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Title_Code
		FROM Acq_Deal_Sport_Monetisation_Ancillary_Title ADSMAT INNER JOIN Acq_Deal_Sport_Monetisation_Ancillary ADSMA ON ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code
			INNER JOIN AT_Acq_Deal_Sport_Monetisation_Ancillary AtADSMA ON AtADSMA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSMA.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Monetisation_Ancillary_Type *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Monetisation_Ancillary_Type(
			AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,Monetisation_Type_Code,Monetisation_Rights,Acq_Deal_Sport_Monetisation_Ancillary_Type_Code)
		SELECT 
			AtADSMA.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,ADSMAT.Monetisation_Type_Code,ADSMAT.Monetisation_Rights,ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Type_Code
		FROM Acq_Deal_Sport_Monetisation_Ancillary_Type ADSMAT INNER JOIN Acq_Deal_Sport_Monetisation_Ancillary ADSMA ON ADSMAT.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code
			INNER JOIN AT_Acq_Deal_Sport_Monetisation_Ancillary AtADSMA ON AtADSMA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSMA.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code = ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Sales_Ancillary *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Sales_Ancillary(
			AT_Acq_Deal_Code,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,
			Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,
			Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity,Acq_Deal_Sport_Sales_Ancillary_Code)
		SELECT @CurrIdent_AT_Acq_Deal,FRO_Given_Title_Sponsor,FRO_Given_Official_Sponsor,Title_FRO_No_of_Days,Title_FRO_Validity,Price_Protection_Title_Sponsor,
			Price_Protection_Official_Sponsor,Last_Matching_Rights_Title_Sponsor,Last_Matching_Rights_Official_Sponsor,Title_Last_Matching_Rights_Validity,
			Remarks,Official_FRO_No_of_Days,Official_FRO_Validity,Official_Last_Matching_Rights_Validity,Acq_Deal_Sport_Sales_Ancillary_Code
		FROM Acq_Deal_Sport_Sales_Ancillary WHERE Acq_Deal_Code = @Acq_Deal_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Sales_Ancillary_Title *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Sales_Ancillary_Title(
			AT_Acq_Deal_Sport_Sales_Ancillary_Code,Title_Code,Episode_From,Episode_To,Acq_Deal_Sport_Sales_Ancillary_Title_Code)
		SELECT 
			AtADSSA.AT_Acq_Deal_Sport_Sales_Ancillary_Code,ADSSAT.Title_Code,ADSSAT.Episode_From,ADSSAT.Episode_To,ADSSAT.Acq_Deal_Sport_Sales_Ancillary_Title_Code
		FROM Acq_Deal_Sport_Sales_Ancillary_Title ADSSAT INNER JOIN Acq_Deal_Sport_Sales_Ancillary ADSSA ON ADSSAT.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code
			INNER JOIN AT_Acq_Deal_Sport_Sales_Ancillary AtADSSA ON AtADSSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSSA.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADSSA.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code

		/******************************** Insert into AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor *****************************************/ 

		INSERT INTO AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor(
			AT_Acq_Deal_Sport_Sales_Ancillary_Code,Sponsor_Code,Sponsor_Type,Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code)
		SELECT 
			AtADSSA.AT_Acq_Deal_Sport_Sales_Ancillary_Code,ADSSAS.Sponsor_Code,ADSSAS.Sponsor_Type,ADSSAS.Acq_Deal_Sport_Sales_Ancillary_Sponsor_Code
		FROM Acq_Deal_Sport_Sales_Ancillary_Sponsor ADSSAS INNER JOIN Acq_Deal_Sport_Sales_Ancillary ADSSA ON ADSSAS.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code
			INNER JOIN AT_Acq_Deal_Sport_Sales_Ancillary AtADSSA ON AtADSSA.AT_Acq_Deal_Code = @CurrIdent_AT_Acq_Deal AND ADSSA.Acq_Deal_Code = @Acq_Deal_Code AND 
			AtADSSA.Acq_Deal_Sport_Sales_Ancillary_Code = ADSSA.Acq_Deal_Sport_Sales_Ancillary_Code

			
		/******************************** Insert into Acq_Deal_Payment_Terms *****************************************/ 
		INSERT INTO AT_Acq_Deal_Payment_Terms
			(AT_Acq_Deal_Code,Acq_Deal_Payment_Terms_Code, Cost_Type_Code, Payment_Term_Code, Days_After, Percentage, Amount, Due_Date, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
		SELECT @CurrIdent_AT_Acq_Deal,Acq_Deal_Payment_Terms_Code, Cost_Type_Code, Payment_Term_Code, Days_After, Percentage, Amount, Due_Date, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By
			FROM Acq_Deal_Payment_Terms WHERE Acq_Deal_Code = @Acq_Deal_Code
			
			
		/******************************** Insert into Acq_Deal_Attachment *****************************************/ 
		INSERT INTO AT_Acq_Deal_Attachment 
			(AT_Acq_Deal_Code,Acq_Deal_Attachment_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To)
		SELECT @CurrIdent_AT_Acq_Deal,Acq_Deal_Attachment_Code, Title_Code, Attachment_Title, Attachment_File_Name, System_File_Name, Document_Type_Code, Episode_From, Episode_To
			FROM Acq_Deal_Attachment WHERE Acq_Deal_Code =  @Acq_Deal_Code
			
			
		/******************************** Insert into AT_Acq_Deal_Material *****************************************/ 
		INSERT INTO AT_Acq_Deal_Material (
			AT_Acq_Deal_Code,Acq_Deal_Material_Code , Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time, Last_Updated_Time, Last_Action_By, Episode_From, Episode_To)
		SELECT @CurrIdent_AT_Acq_Deal,Acq_Deal_Material_Code, Title_Code, Material_Medium_Code, Material_Type_Code, Quantity, Inserted_On, Inserted_By, Lock_Time, Last_Updated_Time, Last_Action_By, Episode_From, Episode_To
			FROM Acq_Deal_Material WHERE Acq_Deal_Code = @Acq_Deal_Code

		/******************************** Insert into AT_Acq_Deal_Budget *****************************************/ 
		INSERT INTO AT_Acq_Deal_Budget(
			AT_Acq_Deal_Code, Title_Code, Episode_From, Episode_To, SAP_WBS_Code , Acq_Deal_Budget_Code)
		SELECT @CurrIdent_AT_Acq_Deal, Title_Code, Episode_From, Episode_To, SAP_WBS_Code, Acq_Deal_Budget_Code
			FROM Acq_Deal_Budget WHERE Acq_Deal_Code = @Acq_Deal_Code
	END	
	Set @Is_Error = 'N'		

	IF OBJECT_ID('tempdb..#Edit_WO_Approval') IS NOT NULL DROP TABLE #Edit_WO_Approval
	IF OBJECT_ID('tempdb..#Temp_Shows') IS NOT NULL DROP TABLE #Temp_Shows
	IF OBJECT_ID('tempdb..#TEMPDealMovie') IS NOT NULL DROP TABLE #TEMPDealMovie
END
GO
PRINT N'Altering [dbo].[USP_Process_Workflow]...';


GO
ALTER PROC [dbo].[USP_Process_Workflow]
(
	@Module_Code Int,
	@Record_Code Int,
	@Login_User Int,
	@User_Action VARCHAR(2),
	@Remarks NVARCHAR(MAX)
)
As
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION;		

		DECLARE 
		@Next_Level_Group Int = 0, @Module_Workflow_Detail_Code Int = 0, @Role_Level Int = 0, @Is_Email_Required Varchar(5) = '', 
		@Is_Error Varchar(10) = 'N',@Version_No INT = 1

			IF(@Module_Code = 30)
			BEGIN
				SELECT 
				@Version_No=CAST  ([Version] as INT)
				FROM Acq_Deal WHERE Acq_Deal_Code = @Record_Code
			END
			ELSE IF(@Module_Code = 35)
			BEGIN
				SELECT 
				@Version_No=CAST  ([Version] as INT)
				FROM Syn_Deal WHERE Syn_Deal_Code = @Record_Code
			END
			ELSE IF(@Module_Code = 163)
			BEGIN
				SELECT 
				@Version_No=CAST  ([Version] as INT)
				FROM Music_Deal WHERE Music_Deal_Code = @Record_Code
			END


		SELECT @Is_Email_Required = ISNULL(Is_Email_Required, 'N') FROM System_Param

		SELECT TOP 1 @Next_Level_Group = ISNULL(Next_Level_Group, 0), @Module_Workflow_Detail_Code = Module_Workflow_Detail_Code, @Role_Level = Role_Level
		FROM Module_Workflow_Detail WHERE Module_Code = @Module_Code AND Record_Code = @Record_Code And Is_Done = 'N' 
		ORDER By Role_Level

		IF (@User_Action != 'RO')
		BEGIN
			Update Module_Workflow_Detail Set Is_Done = 'Y' Where Module_Workflow_Detail_Code = @Module_Workflow_Detail_Code
		END

		IF (@User_Action != 'AR')
		BEGIN
			INSERT INTO Module_Status_History(Module_Code, Record_Code, [Status], Status_Changed_By, Status_Changed_On, Remarks, Version_No)
			SELECT @Module_Code, @Record_Code, @User_Action, @Login_User, GetDate(), @Remarks,@Version_No
		END

		IF(@User_Action = 'R')
		BEGIN
			IF(@Module_Code = 30)
				UPDATE Acq_Deal SET Deal_Workflow_Status = @User_Action--, Last_Updated_Time = GETDATE() 
				WHERE Acq_Deal_Code = @Record_Code
			ELSE IF(@Module_Code = 35)
				UPDATE Syn_Deal SET Deal_Workflow_Status = @User_Action--, Last_Updated_Time = GETDATE() 
				WHERE Syn_Deal_Code = @Record_Code
			ELSE IF(@Module_Code = 154)
				UPDATE Music_Schedule_Transaction Set Workflow_Status = @User_Action WHERE Music_Schedule_Transaction_Code = @Record_Code
			ELSE IF(@Module_Code = 163)
				UPDATE Music_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() WHERE Music_Deal_Code = @Record_Code

			DELETE FROM Module_Workflow_Detail Where Module_Code = @Module_Code And Record_Code = @Record_Code And Is_Done = 'N'

			IF(@Is_Email_Required = 'Y')
				EXEC USP_SendMail_On_Rejection @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, 'Y', 'Y',@Login_User, @Is_Error OUT
		END
		ELSE IF(@User_Action = 'RO')
		BEGIN
			IF(@Module_Code = 30)
			BEGIN
				UPDATE Acq_Deal Set Deal_Workflow_Status = 'A' WHERE Acq_Deal_Code = @Record_Code

				INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,30, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)
				--EXEC DBO.USP_AT_Acq_Deal @Record_Code, @Is_Error OUT

				Update Acq_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE(),
				[Version] =  REPLICATE('0', 6 - LEN(CONVERT(VARCHAR(50),(CONVERT(FLOAT,[Version]) + 0.1)))) + 
					CONVERT(VARCHAR(50), (CONVERT(FLOAT,[Version]) + 0.1) )
				WHERE Acq_Deal_Code = @Record_Code
			END
			ELSE IF(@Module_Code = 35)
			BEGIN
				UPDATE Syn_Deal SET Deal_Workflow_Status = 'A' WHERE Syn_Deal_Code = @Record_Code

				--EXEC DBO.USP_AT_Syn_Deal @Record_Code, @Is_Error OUT
				INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,35, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)

				Update Syn_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE(), 
				[Version] =  REPLICATE('0', 6 - LEN(CONVERT(VARCHAR(50),(CONVERT(FLOAT,[Version]) + 0.1)))) + 
					CONVERT(VARCHAR(50), (CONVERT(FLOAT,[Version]) + 0.1) )
				WHERE Syn_Deal_Code = @Record_Code
			END
			ELSE IF(@Module_Code = 163)
			BEGIN
				UPDATE Music_Deal SET Deal_Workflow_Status = 'A' WHERE Music_Deal_Code = @Record_Code

				EXEC DBO.USP_AT_Music_Deal @Record_Code, @Is_Error OUT

				Update Music_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE(), 
				[Version] =  REPLICATE('0', 6 - LEN(CONVERT(VARCHAR(50),(CONVERT(FLOAT,[Version]) + 0.1)))) + 
					CONVERT(VARCHAR(50), (CONVERT(FLOAT,[Version]) + 0.1) )
				WHERE Music_Deal_Code = @Record_Code
			END
		END
		ELSE IF(@User_Action = 'AR')
		BEGIN
			IF(@Next_Level_Group = 0)
				SET @User_Action = 'AR'
			ELSE
				SET @User_Action = 'WA'
	
			INSERT INTO Module_Status_History(Module_Code, Record_Code, [Status], Status_Changed_By, Status_Changed_On, Remarks,Version_No)
			SELECT @Module_Code, @Record_Code, @User_Action, @Login_User, GetDate(), @Remarks, @Version_No

			IF(@Module_Code = 30)
			BEGIN
				DECLARE @AgreementNo NVARCHAR(MAX)
				UPDATE Acq_Deal SET Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() WHERE Acq_Deal_Code = @Record_Code

				SELECT @AgreementNo = Agreement_No FROM Acq_Deal  WHERE Acq_Deal_Code = @Record_Code

				UPDATE AD SET AD.Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() 
				FROM Acq_Deal AD 
				WHERE AD.Agreement_No LIKE '%'+@AgreementNo+'%' AND AD.Is_Master_Deal = 'N'

				IF @User_Action = 'AR'
				BEGIN
				
					INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
					SELECT @Record_Code, 'A', 'P', GETDATE(), 'N', NULL

				END

			END
			IF(@Module_Code = 35)
			BEGIN
				UPDATE Syn_Deal Set Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() Where Syn_Deal_Code = @Record_Code

				IF @User_Action = 'AR'
				BEGIN
					
					DELETE FROM Syn_Acq_Mapping WHERE Syn_Deal_Code = @Record_Code

					INSERT INTO Approved_Deal(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
					SELECT DISTINCT Syn_Deal_Code, 'S', 'P', GETDATE(), 'D', Syn_Deal_Rights_Code FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @Record_Code

				END
			END
			
			IF(@Is_Email_Required = 'Y')
			BEGIN
				EXEC USP_SendMail_To_NextApprover_New @Record_Code, @Module_Code, 'Y', 'Y', @Is_Error Out
				EXEC USP_SendMail_Intimation_New @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, 'Y', @Login_User, @Is_Error Out
			END

		END 
		ELSE
		BEGIN
			IF(@Next_Level_Group = 0)
				SET @User_Action = 'A'
			ELSE
				SET @User_Action = 'W'

			IF(@Module_Code = 30)
			BEGIN
			DECLARE @Version VARCHAR(15)
				Update Acq_Deal Set Deal_Workflow_Status = @User_Action--, Last_Updated_Time = GETDATE()
				Where Acq_Deal_Code = @Record_Code
				SELECT @Version=[Version] from Acq_Deal WHERE Acq_Deal_Code=@Record_Code
				IF(@User_Action = 'A')
				BEGIN
					INSERT INTO Acq_Deal_Tab_Version([Version],Remarks,Acq_Deal_Code,Inserted_On,Inserted_By,Approved_On,Approved_By)
					VALUES(@Version,'',@Record_Code,GETDATE(),@Login_User,GETDATE(),@Login_User)
				END
			END
			ELSE IF(@Module_Code = 35)
				UPDATE Syn_Deal Set Deal_Workflow_Status = @User_Action--, Last_Updated_Time = GETDATE()
				Where Syn_Deal_Code = @Record_Code
			ELSE IF(@Module_Code = 154)
				UPDATE Music_Schedule_Transaction Set Workflow_Status = @User_Action Where Music_Schedule_Transaction_Code = @Record_Code
			ELSE IF(@Module_Code = 163)
				UPDATE Music_Deal Set Deal_Workflow_Status = @User_Action, Last_Updated_Time = GETDATE() Where Music_Deal_Code = @Record_Code

			IF(@Next_Level_Group = 0)
			BEGIN
				IF(@Module_Code = 30)
				BEGIN
					UPDATE Acq_Deal_Movie SET Is_Closed = 'Y' WHERE Is_Closed = 'X' AND Acq_Deal_Code = @Record_Code
					--EXEC DBO.USP_Generate_Title_Content @Record_Code, '', @Login_User

					INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,30, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)

					--EXEC DBO.USP_AT_Acq_Deal @Record_Code, @Is_Error OUT
				END
				ELSE IF(@Module_Code = 35)
				BEGIN
					--EXEC DBO.USP_AT_Syn_Deal @Record_Code, @Is_Error OUT
					INSERT INTO Deal_Process(Deal_Code, Module_Code, EditWithoutApproval, [Action], Inserted_On, Process_Start, Porcess_End, User_Code) 
					VALUES (@Record_Code,35, 'N', 'A',GETDATE(),NULL,NULL,@Login_User)


					DECLARE @StatusFlag VARCHAR(1), @ErrMessage VARCHAR(1)
					--EXEC DBO.USP_AutoPushAcqDeal @Record_Code, @Login_User, @StatusFlag OUT, @ErrMessage OUT
				END
				ELSE IF(@Module_Code = 154)
					UPDATE Music_Schedule_Transaction Set Workflow_Status = @User_Action Where Music_Schedule_Transaction_Code = @Record_Code
				ELSE IF(@Module_Code = 163)
					EXEC DBO.USP_AT_Music_Deal @Record_Code, @Is_Error OUT
			END
			IF(@Is_Email_Required = 'Y')
			BEGIN
				EXEC USP_SendMail_To_NextApprover_New @Record_Code, @Module_Code, 'Y', 'Y', @Is_Error Out
				EXEC USP_SendMail_Intimation_New @Record_Code, @Module_Workflow_Detail_Code, @Module_Code, 'Y', @Login_User, @Is_Error Out
			END
		END
		SELECT @Is_Error Is_Error
		COMMIT TRANSACTION;		
	END TRY
	BEGIN CATCH				
		ROLLBACK TRANSACTION;
		SET @Is_Error = 'Y'
		DECLARE @ErrorMessage NVARCHAR(4000), @Error_Line NVARCHAR(4000)		
		SELECT @ErrorMessage  = ERROR_MESSAGE() ,@Error_Line = ERROR_LINE() 		
			SELECT  @ErrorMessage + ' ' + @Error_Line + '~' + IsNull(@Is_Error, '') AS  Is_Error
	END CATCH
END
GO
PRINT N'Altering [dbo].[USP_Deal_Rights_Process]...';


GO
ALTER Procedure [dbo].[USP_Deal_Rights_Process]
AS
BEGIN
	SET NOCOUNT ON
	DECLARE @Deal_Code INT, @User_Code INT, @Rights_Bulk_Update_Code INT
	DECLARE @IsValid CHAR(1), @DRPL_Code INT = 0

	BEGIN TRY
		DECLARE db_DRPcursor CURSOR FOR 
		SELECT DISTINCT Deal_Code, User_Code, Rights_Bulk_Update_Code FROM Deal_Rights_Process WHERE Record_Status = 'P' AND ISNULL(Rights_Bulk_Update_Code , 0) > 0

		OPEN db_DRPcursor  
		FETCH NEXT FROM db_DRPcursor INTO @Deal_Code, @User_Code, @Rights_Bulk_Update_Code

		WHILE @@FETCH_STATUS = 0  
		BEGIN  
			
			INSERT INTO Deal_Rights_Process_Log (Deal_Code, Rights_Bulk_Update_Code , Record_Status, Description, Created_Date)
			SELECT @Deal_Code,@Rights_Bulk_Update_Code,'P','Before Calling USP_Acq_Bulk_Update_Process Store Procedure.', GETDATE()

			SELECT @DRPL_Code =  CAST(SCOPE_IDENTITY() AS INT)

			SET @IsValid = 'N'
			EXEC USP_Acq_Bulk_Update_Process @Deal_Code, @User_Code, @Rights_Bulk_Update_Code,@DRPL_Code, @IsValid OUTPUT
			--UPDATE ERROR MESSAGE TO DEAL_RIGHTS_PROCESS WHERE STATE IS WORKING

			FETCH NEXT FROM db_DRPcursor INTO @Deal_Code, @User_Code, @Rights_Bulk_Update_Code
		END 

		CLOSE db_DRPcursor  
		DEALLOCATE db_DRPcursor 
	END TRY
	BEGIN CATCH
		CLOSE db_DRPcursor  
		DEALLOCATE db_DRPcursor 
		SELECT ERROR_MESSAGE()
	END CATCH
END
GO
PRINT N'Refreshing [dbo].[USP_Get_Unutilized_Run]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Unutilized_Run]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Acq_Syn_Status]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Acq_Syn_Status]';


GO
PRINT N'Refreshing [dbo].[USP_List_Acq_Ancillary]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Acq_Ancillary]';


GO
PRINT N'Refreshing [dbo].[USP_Report_AcqSyn_Expiry]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Report_AcqSyn_Expiry]';


GO
PRINT N'Refreshing [dbo].[USP_Report_PlatformWise_Acquisition_Neo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Report_PlatformWise_Acquisition_Neo]';


GO
PRINT N'Refreshing [dbo].[USP_Cost_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Cost_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_General_Delete_For_Title]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_General_Delete_For_Title]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Termination_Title_Data]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Termination_Title_Data]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Close_Movie__Scheduled_Run]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Close_Movie__Scheduled_Run]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Run]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Run]';


GO
PRINT N'Refreshing [dbo].[USP_GET_TITLE_FOR_RUN]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_GET_TITLE_FOR_RUN]';


GO
PRINT N'Refreshing [dbo].[Usp_Deal_Pending_Execution_Mail]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Usp_Deal_Pending_Execution_Mail]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_List_Runs]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_List_Runs]';


GO
PRINT N'Refreshing [dbo].[USP_List_Approval_Acq_Syn]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Approval_Acq_Syn]';


GO
PRINT N'Refreshing [dbo].[USP_List_Assign_Music]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Assign_Music]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Version_History_Syn]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Version_History_Syn]';


GO
PRINT N'Refreshing [dbo].[USP_Query_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Query_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Deal_Ancillary_Adv_Report_New]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Deal_Ancillary_Adv_Report_New]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Deal_Ancillary_Adv_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Deal_Ancillary_Adv_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Send_Mail_WBS_Linked_Titles]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Send_Mail_WBS_Linked_Titles]';


GO
PRINT N'Refreshing [dbo].[USP_Populate_Music]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Populate_Music]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_YEARWISE_RIGHT_FOR_RUN]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_YEARWISE_RIGHT_FOR_RUN]';


GO
PRINT N'Refreshing [dbo].[USP_Title_Deal_Info]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Title_Deal_Info]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_And_Save_Assigned_Music_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_And_Save_Assigned_Music_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Deal_Title_Platform_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Deal_Title_Platform_Report]';


GO
PRINT N'Refreshing [dbo].[USP_List_Acq_Budget]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Acq_Budget]';


GO
PRINT N'Refreshing [dbo].[USP_Integration_Generate_XML]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Integration_Generate_XML]';


GO
PRINT N'Refreshing [dbo].[USP_Populate_Master_Deal_Titles]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Populate_Master_Deal_Titles]';


GO
PRINT N'Refreshing [dbo].[USP_List_Acq_Deal_Status]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Acq_Deal_Status]';


GO
PRINT N'Refreshing [dbo].[USP_Add_ACQ_Milestone]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Add_ACQ_Milestone]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rights_Duplication_UDT_Syn_New]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rights_Duplication_UDT_Syn_New]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Data_Restriction_Remark_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Data_Restriction_Remark_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Import_SubDeal_Insert]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Import_SubDeal_Insert]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Ancillary_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Ancillary_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Integration_Deal_Data_Generation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Integration_Deal_Data_Generation]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Platform_Run_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Platform_Run_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_RightsU_Health_Checkup]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_RightsU_Health_Checkup]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Version_History]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Version_History]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Migrate_Syndication]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Migrate_Syndication]';


GO
PRINT N'Refreshing [dbo].[USP_Workflow_Reminder_Mail]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Workflow_Reminder_Mail]';


GO
PRINT N'Refreshing [dbo].[USP_CostSubReport]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_CostSubReport]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_SDM_Title]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_SDM_Title]';


GO
PRINT N'Refreshing [dbo].[USP_ChannelWiseConsumption]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_ChannelWiseConsumption]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Run_Expiry_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Run_Expiry_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Syn_Pending_Appr]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Syn_Pending_Appr]';


GO
PRINT N'Refreshing [dbo].[USP_Ancillary_Validate]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Ancillary_Validate]';


GO
PRINT N'Refreshing [dbo].[USP_Attachment_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Attachment_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Audit_Log_Report_for_Territory_and_Language_Group]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Audit_Log_Report_for_Territory_and_Language_Group]';


GO
PRINT N'Refreshing [dbo].[USP_Bind_Title_Platform_Tree_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Bind_Title_Platform_Tree_Report]';


GO
PRINT N'Refreshing [dbo].[USP_BMS_Deal_Data_Generation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_BMS_Deal_Data_Generation]';


GO
PRINT N'Refreshing [dbo].[USP_BMS_DM_Mapped_Unmapped_Deals]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_BMS_DM_Mapped_Unmapped_Deals]';


GO
PRINT N'Refreshing [dbo].[USP_BMS_Update_Key_Deal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_BMS_Update_Key_Deal]';


GO
PRINT N'Refreshing [dbo].[USP_BV_Deal_Data_Generation_bkp16Oct2015]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_BV_Deal_Data_Generation_bkp16Oct2015]';


GO
PRINT N'Refreshing [dbo].[USP_ChannelWiseConsumption_Yearwise_Sub]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_ChannelWiseConsumption_Yearwise_Sub]';


GO
PRINT N'Refreshing [dbo].[USP_Check_Acq_Deal_Status_For_Syn]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Check_Acq_Deal_Status_For_Syn]';


GO
PRINT N'Refreshing [dbo].[USP_Check_Workflow]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Check_Workflow]';


GO
PRINT N'Refreshing [dbo].[USP_Content_Channel_Run_Data_Generation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Content_Channel_Run_Data_Generation]';


GO
PRINT N'Refreshing [dbo].[USP_Dashboard_AcqSyn_Expiry]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Dashboard_AcqSyn_Expiry]';


GO
PRINT N'Refreshing [dbo].[USP_Deal_Approval_Email]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Deal_Approval_Email]';


GO
PRINT N'Refreshing [dbo].[USP_Deal_Expiry_Email]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Deal_Expiry_Email]';


GO
PRINT N'Refreshing [dbo].[USP_DealReport_Filter]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DealReport_Filter]';


GO
PRINT N'Refreshing [dbo].[USP_DealWorkFlow_Status_Pending_Reports]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DealWorkFlow_Status_Pending_Reports]';


GO
PRINT N'Refreshing [dbo].[USP_DELETE_ACQ_DEAL]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DELETE_ACQ_DEAL]';


GO
PRINT N'Refreshing [dbo].[USP_DELETE_Deal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DELETE_Deal]';


GO
PRINT N'Refreshing [dbo].[USP_Edit_Without_Approval]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Edit_Without_Approval]';


GO
PRINT N'Refreshing [dbo].[USP_Email_Pending_Execution]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Email_Pending_Execution]';


GO
PRINT N'Refreshing [dbo].[usp_Episodic_Cost_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Episodic_Cost_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Generate_Mass_Territory_Update]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Generate_Mass_Territory_Update]';


GO
PRINT N'Refreshing [dbo].[USP_Generate_Title_Content]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Generate_Title_Content]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Acq_PreReq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Acq_PreReq]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Acq_Rights_Details_Codes]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Acq_Rights_Details_Codes]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Avail_Titles]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Avail_Titles]';


GO
PRINT N'Refreshing [dbo].[USP_Get_BUWise_Title]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_BUWise_Title]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Content_Cost]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Content_Cost]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Dashboard_Data]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Dashboard_Data]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Dashboard_Detail]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Dashboard_Detail]';


GO
PRINT N'Refreshing [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK]';


GO
PRINT N'Refreshing [dbo].[USP_Get_PlatformCodes_For_Ancillary]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_PlatformCodes_For_Ancillary]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Release_Content_List]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Release_Content_List]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_PreReq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_PreReq]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_WBS_Data]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_WBS_Data]';


GO
PRINT N'Refreshing [dbo].[USP_GetContentsRightData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_GetContentsRightData]';


GO
PRINT N'Refreshing [dbo].[USP_Import_SubDeal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Import_SubDeal]';


GO
PRINT N'Refreshing [dbo].[USP_Insert_Acq_Deal_Movie_Contents]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Insert_Acq_Deal_Movie_Contents]';


GO
PRINT N'Refreshing [dbo].[USP_Insert_Language_Deal_Log]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Insert_Language_Deal_Log]';


GO
PRINT N'Refreshing [dbo].[USP_Integration_SDM_Generate_XML]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Integration_SDM_Generate_XML]';


GO
PRINT N'Refreshing [dbo].[USP_Last_Month_Utilization_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Last_Month_Utilization_Report]';


GO
PRINT N'Refreshing [dbo].[USP_List_Acq	_Linear_Title_Status]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Acq	_Linear_Title_Status]';


GO
PRINT N'Refreshing [dbo].[USP_List_Acq_Linear_Title_Status]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Acq_Linear_Title_Status]';


GO
PRINT N'Refreshing [dbo].[USP_Music_Usage_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Music_Usage_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Populate_Titles]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Populate_Titles]';


GO
PRINT N'Refreshing [dbo].[USP_RunUtilizationReport]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_RunUtilizationReport]';


GO
PRINT N'Refreshing [dbo].[USP_Schedule_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Schedule_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Schedule_Revert_Count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Schedule_Revert_Count]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_SendException_Userwise_Email]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_SendException_Userwise_Email]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Validate_TempBVSche_S1]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Validate_TempBVSche_S1]';


GO
PRINT N'Refreshing [dbo].[USP_Search_Run_Shows]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Search_Run_Shows]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Acq_Mapping]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Acq_Mapping]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_RIGHT_FOR_RUN]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_RIGHT_FOR_RUN]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rollback]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rollback]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Syn_Right_Title_With_Acq_On_Edit]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Syn_Right_Title_With_Acq_On_Edit]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Title_Talent_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Title_Talent_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_VALIDATE_TITLES_FOR_YEARWISE_RUN]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_VALIDATE_TITLES_FOR_YEARWISE_RUN]';


GO
PRINT N'Refreshing [dbo].[USPAuditTrailReportList]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPAuditTrailReportList]';


GO
PRINT N'Refreshing [dbo].[USPGetDashBoardNeoData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPGetDashBoardNeoData]';


GO
PRINT N'Refreshing [dbo].[USPITCuratedNewReportCriteria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITCuratedNewReportCriteria]';


GO
PRINT N'Refreshing [dbo].[USPITCuratedPreview]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITCuratedPreview]';


GO
PRINT N'Refreshing [dbo].[USPITGetAssetsData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetAssetsData]';


GO
PRINT N'Refreshing [dbo].[USPITGetGenreWiseTitle]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetGenreWiseTitle]';


GO
PRINT N'Refreshing [dbo].[USPITGetLicensorWiseTitle]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetLicensorWiseTitle]';


GO
PRINT N'Refreshing [dbo].[USPMHGetMusicLabel]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPMHGetMusicLabel]';


GO
PRINT N'Refreshing [dbo].[USPMHShowNameList]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPMHShowNameList]';


GO
PRINT N'Refreshing [dbo].[USPPopulateTitleForMapping]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPPopulateTitleForMapping]';


GO
PRINT N'Refreshing [dbo].[USPRUR_VALIDATE_Content]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPRUR_VALIDATE_Content]';


GO
PRINT N'Refreshing [dbo].[USP_BMS_Schedule_Rollback_Runs]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_BMS_Schedule_Rollback_Runs]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Show_Episode_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Show_Episode_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Email_Notification]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Email_Notification]';


GO
PRINT N'Refreshing [dbo].[USP_INSERT_SAP_WBS_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_INSERT_SAP_WBS_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Email_Run_Expiry]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Email_Run_Expiry]';


GO
PRINT N'Refreshing [dbo].[USP_Deal_Expiry_Email_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Deal_Expiry_Email_Schedule]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Bind_listbox_Bulk_Update]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Bind_listbox_Bulk_Update]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Bulk_Populate]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Bulk_Populate]';


GO
PRINT N'Refreshing [dbo].[USP_Email_Run_Utilization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Email_Run_Utilization]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_RUN_SAVE_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_RUN_SAVE_Process]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Execute_Package_FolderWise]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Execute_Package_FolderWise]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_SendException_Email]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_SendException_Email]';


GO
PRINT N'Refreshing [dbo].[USP_DELETE_Syn_DEAL]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DELETE_Syn_DEAL]';


GO
PRINT N'Refreshing [dbo].[USP_RollBack_Syn_Deal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_RollBack_Syn_Deal]';


GO
PRINT N'Refreshing [dbo].[USPMHSearchMusicTrack]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPMHSearchMusicTrack]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_FileError]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_FileError]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_PkgExecutionFail]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_PkgExecutionFail]';


GO
PRINT N'Refreshing [dbo].[USP_DELETE_AT_ACQ_Deal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DELETE_AT_ACQ_Deal]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Bulk_Update_Validation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Bulk_Update_Validation]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Bulk_Update_Final]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Bulk_Update_Final]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Bulk_Update_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Bulk_Update_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Deal_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Deal_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Mass_Territory_Update_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Mass_Territory_Update_Schedule]';


GO
PRINT N'Refreshing [dbo].[USP_MIGRATE_TO_NEW]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_MIGRATE_TO_NEW]';


GO
PRINT N'Refreshing [dbo].[USP_MIGRATE_TO_NEW_Main]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_MIGRATE_TO_NEW_Main]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Termination_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Termination_UDT]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Validate_Temp_BV_Sche]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Validate_Temp_BV_Sche]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_ReProcess]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_ReProcess]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Termination_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Termination_UDT]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Mapped_titles]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Mapped_titles]';


GO
PRINT N'Update complete.';


GO
