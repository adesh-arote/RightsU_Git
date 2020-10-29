
--ALTER Procedure [dbo].[USP_Acquition_Deal_List_Report](
--	@Agreement_No VARCHAR(100), 
--	@Is_Master_Deal VARCHAR(2), 
--	@Start_Date VARCHAR(30), 
--	@End_Date VARCHAR(30), 
--	@Deal_Tag_Code Int, 
--	@Title_Name NVARCHAR(100), 
--	@Business_Unit_code VARCHAR(100), 
--	@Is_Pushback VARCHAR(100), 
--	@SysLanguageCode INT,
--	@IncludeAncillary CHAR(1),
--	@Deal_Type_Code VARCHAR(10)
--	)
--As

-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date:	18 Feb 2015
-- Description:	Get Acquisition Deal List Report Data
-- =============================================
--select * from title where Title_Name= 'GSD Program 4'
--select Business_Unit_Code from Acq_Deal where Agreement_No =  'A-2019-00199'
DECLARE
@Agreement_No VARCHAR(100) = '',--'A-2020-00234',--'A-2020-00241'
@Is_Master_Deal VARCHAR(2) = 'Y', 
@Start_Date VARCHAR(30) ='' , 
@End_Date VARCHAR(30) = '', 
@Deal_Tag_Code INT = 0, 
@Title_Name NVARCHAR(100) = '', --34091,6329
@Business_Unit_code VARCHAR(1000) = '9',
@Is_Pushback VARCHAR(100) = 'N', 
@SysLanguageCode INT = 1,
@IncludeAncillary CHAR(1) = 'Y',
@Deal_Type_Code VARCHAR(10) = '1'

--DROP TABLE TestAcqDealNew
--TRUNCATE TABLE TestAcqDealNew
--CREATE TABLE TestAcqDealNew(Agreement_No VARCHAR(100),Is_Master_Deal VARCHAR(2),Start_Date VARCHAR(30),End_Date VARCHAR(30),Deal_Tag_Code INT, 
--Title_Name NVARCHAR(100),Business_Unit_code VARCHAR(1000),Is_Pushback VARCHAR(100),SysLanguageCode INT,IncludeAncillary CHAR(1),Deal_Type_Code VARCHAR(10))
--INSERT INTO TestAcqDealNew(Agreement_No,Is_Master_Deal,Start_Date,End_Date,Deal_Tag_Code,Title_Name,Business_Unit_code,Is_Pushback,SysLanguageCode,IncludeAncillary,Deal_Type_Code)
--SELECT @Agreement_No,@Is_Master_Deal,@Start_Date,@End_Date,@Deal_Tag_Code,@Title_Name,@Business_Unit_code,@Is_Pushback,@SysLanguageCode,@IncludeAncillary,@Deal_Type_Code 
--EXEC USP_Acquition_Deal_List_Report 'A-2019-00151','','31-Oct-2019','','0','','1','N',1,'Y'
--EXEC USP_Acquition_Deal_List_Report 'A-2017-00002', '', '', '', '', '', '','N'
--Select * from TestAcqDealNew
BEGIN
	IF(@Deal_Type_Code = '11')
	BEGIN
		SELECT	@Deal_Type_Code = '11,22,32'
	END
DECLARE @Deal_Type VARCHAR(30) = ''
SELECT @Deal_Type = Deal_Type_Name FROM Deal_Type WHERE Deal_Type_Code = CAST(@Deal_Type_Code AS INT)

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
@Col_Head52 NVARCHAR(MAX) = '',
@Col_Head53 NVARCHAR(MAX) = '',
@Col_Head54 NVARCHAR(MAX) = '',
@Col_Head56 NVARCHAR(MAX) = '',
@Col_Head57 NVARCHAR(MAX) = '',
@Col_Head58 NVARCHAR(MAX) = '',
@Col_Head59 NVARCHAR(MAX) = '',
@Col_Head60 NVARCHAR(MAX) = '',
@Col_Head61 NVARCHAR(MAX) = '',
@Col_Head62 NVARCHAR(MAX) = '',
@Col_Head63 NVARCHAR(MAX) = '',
@Col_Head64 NVARCHAR(MAX) = '',
@Col_Head65 NVARCHAR(MAX) = '',
@Col_Head66 NVARCHAR(MAX) = '',
@Col_Head67 NVARCHAR(MAX) = '',
@Col_Head68 NVARCHAR(MAX) = '',
@Col_Head69 NVARCHAR(MAX) = '',
@Col_Head70 NVARCHAR(MAX) = '',
@Col_Head71 NVARCHAR(MAX) = '',
@Col_Head72 NVARCHAR(MAX) = '',
@Col_Head73 NVARCHAR(MAX) = '',
@Col_Head74 NVARCHAR(MAX) = '',
@Col_Head75 NVARCHAR(MAX) = '',
@Col_Head76 NVARCHAR(MAX) = '',
@Col_Head77 NVARCHAR(MAX) = '',
@Col_Head78 NVARCHAR(MAX) = '',
@Col_Head79 NVARCHAR(MAX) = '',
@Col_Head80 NVARCHAR(MAX) = '',
@Col_Head81 NVARCHAR(MAX) = '',
@Col_Head82 NVARCHAR(MAX) = '',
@Col_Head83 NVARCHAR(MAX) = '',
@Col_Head84 NVARCHAR(MAX) = '',
@Col_Head85 NVARCHAR(MAX) = '',
@Col_Head86 NVARCHAR(MAX) = '',
@Col_Head87 NVARCHAR(MAX) = '',
@Col_Head88 NVARCHAR(MAX) = '',
@Col_Head89 NVARCHAR(MAX) = '',
@Col_Head90 NVARCHAR(MAX) = '',
@Col_Head91 NVARCHAR(MAX) = '',
@Col_Head92 NVARCHAR(MAX) = '',
@Col_Head93 NVARCHAR(MAX) = '',
@Col_Head94 NVARCHAR(MAX) = '',
@Col_Head95 NVARCHAR(MAX) = '',
@Col_Head96 NVARCHAR(MAX) = '',
@Col_Head97 NVARCHAR(MAX) = '',
@Col_Head98 NVARCHAR(MAX) = '',
@Col_Head99 NVARCHAR(MAX) = '',
@Col_Head100 NVARCHAR(MAX) = '',
@Col_Head101 NVARCHAR(MAX) = '',  
@Col_Head102 NVARCHAR(MAX) = '',  
@Col_Head103 NVARCHAR(MAX) = '',
@Col_Head104 NVARCHAR(MAX) = '', 
@Col_Head105 NVARCHAR(MAX) = '', 
@Col_Head106 NVARCHAR(MAX) = '', 
@Col_Head107 NVARCHAR(MAX) = '', 
@Col_Head108 NVARCHAR(MAX) = '', 
@Col_Head109 NVARCHAR(MAX) = '', 
@Col_Head110 NVARCHAR(MAX) = '', 
@Col_Head111 NVARCHAR(MAX) = '', 
@Col_Head112 NVARCHAR(MAX) = '', 
@Col_Head113 NVARCHAR(MAX) = '', 
@Col_Head114 NVARCHAR(MAX) = '', 
@Col_Head115 NVARCHAR(MAX) = '', 
@Col_Head116 NVARCHAR(MAX) = '', 
@Col_Head117 NVARCHAR(MAX) = '', 
@Col_Head118 NVARCHAR(MAX) = '', 
@Col_Head119 NVARCHAR(MAX) = '', 
@Col_Head120 NVARCHAR(MAX) = '', 
@Col_Head121 NVARCHAR(MAX) = '', 
@Col_Head122 NVARCHAR(MAX) = '', 
@Col_Head123 NVARCHAR(MAX) = '', 
@Col_Head124 NVARCHAR(MAX) = '', 
@Col_Head125 NVARCHAR(MAX) = '', 
@Col_Head126 NVARCHAR(MAX) = '', 
@Col_Head127 NVARCHAR(MAX) = '', 
@Col_Head128 NVARCHAR(MAX) = '', 
@Col_Head129 NVARCHAR(MAX) = '', 
@Col_Head130 NVARCHAR(MAX) = '', 
@Col_Head131 NVARCHAR(MAX) = '', 
@Col_Head132 NVARCHAR(MAX) = '', 
@Col_Head133 NVARCHAR(MAX) = '', 
@Col_Head134 NVARCHAR(MAX) = '', 
@Col_Head135 NVARCHAR(MAX) = '', 
@Col_Head136 NVARCHAR(MAX) = '', 
@Col_Head137 NVARCHAR(MAX) = '', 
@Col_Head138 NVARCHAR(MAX) = '',
@Col_Head139 NVARCHAR(MAX) = '',
@Col_Head140 NVARCHAR(MAX) = '',
@Col_Head141 NVARCHAR(MAX) = '',
@Col_Head142 NVARCHAR(MAX) = '',
@Col_Head143 NVARCHAR(MAX) = '',
@Col_Head144 NVARCHAR(MAX) = '',
@Col_Head145 NVARCHAR(MAX) = '',
@Col_Head146 NVARCHAR(MAX) = '',
@Col_Head148 NVARCHAR(MAX) = '',
@Col_Head149 NVARCHAR(MAX) = '',
@Col_Head150 NVARCHAR(MAX) = '',
@Col_Head151 NVARCHAR(MAX) = '',
@Col_Head152 NVARCHAR(MAX) = '',
@Col_Head153 NVARCHAR(MAX) = '',
@Col_Head154 NVARCHAR(MAX) = '',
@Col_Head156 NVARCHAR(MAX) = '',
@Col_Head157 NVARCHAR(MAX) = '',
@Col_Head158 NVARCHAR(MAX) = '',
@Col_Head159 NVARCHAR(MAX) = '',
@Col_Head160 NVARCHAR(MAX) = '',
@Col_Head161 NVARCHAR(MAX) = '',
@Col_Head162 NVARCHAR(MAX) = '',
@Col_Head163 NVARCHAR(MAX) = '',
@Col_Head164 NVARCHAR(MAX) = '',
@Col_Head165 NVARCHAR(MAX) = '',
@Col_Head166 NVARCHAR(MAX) = '',
@Col_Head167 NVARCHAR(MAX) = '',
@Col_Head168 NVARCHAR(MAX) = '',
@Col_Head169 NVARCHAR(MAX) = '',
@Col_Head170 NVARCHAR(MAX) = '',
@AncCol_Head1 NVARCHAR(MAX) = '',  
@AncCol_Head2 NVARCHAR(MAX) = '',  
@AncCol_Head3 NVARCHAR(MAX) = '',
@AncCol_Head4 NVARCHAR(MAX) = '', 
@AncCol_Head5 NVARCHAR(MAX) = '', 
@AncCol_Head6 NVARCHAR(MAX) = '', 
@AncCol_Head7 NVARCHAR(MAX) = '', 
@AncCol_Head8 NVARCHAR(MAX) = '', 
@AncCol_Head9 NVARCHAR(MAX) = '', 
@AncCol_Head10 NVARCHAR(MAX) = '', 
@AncCol_Head11 NVARCHAR(MAX) = '', 
@AncCol_Head12 NVARCHAR(MAX) = '', 
@AncCol_Head13 NVARCHAR(MAX) = '', 
@AncCol_Head14 NVARCHAR(MAX) = '', 
@AncCol_Head15 NVARCHAR(MAX) = '', 
@AncCol_Head16 NVARCHAR(MAX) = '', 
@AncCol_Head17 NVARCHAR(MAX) = '', 
@AncCol_Head18 NVARCHAR(MAX) = '', 
@AncCol_Head19 NVARCHAR(MAX) = '', 
@AncCol_Head20 NVARCHAR(MAX) = '', 
@AncCol_Head21 NVARCHAR(MAX) = '', 
@AncCol_Head22 NVARCHAR(MAX) = '', 
@AncCol_Head23 NVARCHAR(MAX) = '', 
@AncCol_Head24 NVARCHAR(MAX) = '', 
@AncCol_Head25 NVARCHAR(MAX) = '', 
@AncCol_Head26 NVARCHAR(MAX) = '', 
@AncCol_Head27 NVARCHAR(MAX) = '', 
@AncCol_Head28 NVARCHAR(MAX) = '', 
@AncCol_Head29 NVARCHAR(MAX) = '', 
@AncCol_Head30 NVARCHAR(MAX) = '', 
@AncCol_Head31 NVARCHAR(MAX) = '', 
@AncCol_Head32 NVARCHAR(MAX) = '', 
@AncCol_Head33 NVARCHAR(MAX) = '', 
@AncCol_Head34 NVARCHAR(MAX) = '', 
@AncCol_Head35 NVARCHAR(MAX) = '', 
@AncCol_Head36 NVARCHAR(MAX) = '', 
@AncCol_Head37 NVARCHAR(MAX) = '', 
@AncCol_Head38 NVARCHAR(MAX) = '',
@AncCol_Head39 NVARCHAR(MAX) = '',
@AncCol_Head40 NVARCHAR(MAX) = '',
@AncCol_Head41 NVARCHAR(MAX) = '',
@AncCol_Head42 NVARCHAR(MAX) = '',
@AncCol_Head43 NVARCHAR(MAX) = '',
@AncCol_Head44 NVARCHAR(MAX) = '',
@AncCol_Head45 NVARCHAR(MAX) = '',
@AncCol_Head46 NVARCHAR(MAX) = '',
@AncCol_Head47 NVARCHAR(MAX) = '',
@AncCol_Head48 NVARCHAR(MAX) = '',
@AncCol_Head49 NVARCHAR(MAX) = '',
@AncCol_Head50 NVARCHAR(MAX) = '',
@AncCol_Head51 NVARCHAR(MAX) = '',
@AncCol_Head52 NVARCHAR(MAX) = '',
@AncCol_Head53 NVARCHAR(MAX) = '',
@AncCol_Head54 NVARCHAR(MAX) = '',
@AncCol_Head55 NVARCHAR(MAX) = '',
@AncCol_Head56 NVARCHAR(MAX) = '',
@AncCol_Head57 NVARCHAR(MAX) = '',
@AncCol_Head58 NVARCHAR(MAX) = '',
@AncCol_Head59 NVARCHAR(MAX) = '',
@AncCol_Head60 NVARCHAR(MAX) = '',
@AncCol_Head61 NVARCHAR(MAX) = '',
@AncCol_Head62 NVARCHAR(MAX) = '',
@AncCol_Head63 NVARCHAR(MAX) = '',
@AncCol_Head64 NVARCHAR(MAX) = '',
@AncCol_Head65 NVARCHAR(MAX) = '',
@AncCol_Head66 NVARCHAR(MAX) = '',
@AncCol_Head67 NVARCHAR(MAX) = '',
@AncCol_Head68 NVARCHAR(MAX) = '',
@AncCol_Head69 NVARCHAR(MAX) = '',
@AncCol_Head70 NVARCHAR(MAX) = '',
@AncCol_Head71 NVARCHAR(MAX) = '',
@AncCol_Head72 NVARCHAR(MAX) = '',
@AncCol_Head73 NVARCHAR(MAX) = '',
@AncCol_Head74 NVARCHAR(MAX) = '',
@AncCol_Head75 NVARCHAR(MAX) = '',
@AncCol_Head76 NVARCHAR(MAX) = '',
@AncCol_Head77 NVARCHAR(MAX) = '',
@AncCol_Head78 NVARCHAR(MAX) = '',
@AncCol_Head79 NVARCHAR(MAX) = '',
@AncCol_Head80 NVARCHAR(MAX) = '',
@AncCol_Head81 NVARCHAR(MAX) = '',
@AncCol_Head82 NVARCHAR(MAX) = '',
@AncCol_Head83 NVARCHAR(MAX) = '',
@AncCol_Head84 NVARCHAR(MAX) = '',
@AncCol_Head85 NVARCHAR(MAX) = '',
@AncCol_Head86 NVARCHAR(MAX) = '',
@AncCol_Head87 NVARCHAR(MAX) = '',
@AncCol_Head88 NVARCHAR(MAX) = '',
@AncCol_Head89 NVARCHAR(MAX) = '',
@AncCol_Head90 NVARCHAR(MAX) = '',
@AncCol_Head91 NVARCHAR(MAX) = '',
@AncCol_Head92 NVARCHAR(MAX) = '',
@AncCol_Head93 NVARCHAR(MAX) = '',
@AncCol_Head94 NVARCHAR(MAX) = '',
@AncCol_Head95 NVARCHAR(MAX) = '',
@AncCol_Head96 NVARCHAR(MAX) = '',
@AncCol_Head97 NVARCHAR(MAX) = '',
@AncCol_Head98 NVARCHAR(MAX) = '',
@AncCol_Head99 NVARCHAR(MAX) = '',
@AncCol_Head100 NVARCHAR(MAX) = ''

END

	IF OBJECT_ID('tempdb..#TempAcqDealListReport') IS NOT NULL
	DROP TABLE #TempAcqDealListReport

	IF OBJECT_ID('tempdb..#AncData') IS NOT NULL
	DROP TABLE #AncData

	IF OBJECT_ID('tempdb..#TEMP_Acquition_Deal_List_Report') IS NOT NULL
	DROP TABLE #TEMP_Acquition_Deal_List_Report
	
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


	CREATE TABLE #RightTable(
		Acq_Deal_Code INT,
		Acq_Deal_Rights_Code INT,
		Platform_Codes NVARCHAR(MAX),
		Region_Codes NVARCHAR(MAX),
		SL_Codes NVARCHAR(MAX),
		DB_Codes NVARCHAR(MAX),
		Platform_Names NVARCHAR(MAX),
		Region_Name NVARCHAR(MAX),
		Subtitle NVARCHAR(MAX),
		Dubbing NVARCHAR(MAX),
		RunType NVARCHAR(MAX),
		PA_Right_Type VARCHAR(10),
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
		--SL_Lang_Codes NVARCHAR(MAX),
		--DB_Lang_Codes NVARCHAR(MAX),
		--SL_Lang_Names NVARCHAR(MAX),
		--DB_Lang_Names NVARCHAR(MAX),
		--SL_Lang_Type NVARCHAR(10),
		--DB_Lang_Type NVARCHAR(10)
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
			PA_Right_Type VARCHAR(100),
			Business_Unit_Code INT,
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
			Platform_Name VARCHAR(MAX),
			Right_Start_Date DATETIME, 
			Right_End_Date DATETIME,
			Is_Title_Language_Right CHAR(1),
			Country_Territory_Name NVARCHAR(MAX),
			Is_Exclusive VARCHAR(20),
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
			Right_Status VARCHAR(MAX),
			TC_QC VARCHAR(10),
			Is_Under_Production VARCHAR(5),
			Business_Unit_Name VARCHAR(500),
			Column_51 NVARCHAR(MAX),
			Column_52 NVARCHAR(MAX),
			Column_53 NVARCHAR(MAX),
			Column_54 NVARCHAR(MAX),
			Column_55 NVARCHAR(MAX),
			Column_56 NVARCHAR(MAX),
			Column_57 NVARCHAR(MAX),
			Column_58 NVARCHAR(MAX),
			Column_59 NVARCHAR(MAX),
			Column_60 NVARCHAR(MAX),
			Column_61 NVARCHAR(MAX),
			Column_62 NVARCHAR(MAX),
			Column_63 NVARCHAR(MAX),
			Column_64 NVARCHAR(MAX),
			Column_65 NVARCHAR(MAX),
			Column_66 NVARCHAR(MAX),
			Column_67 NVARCHAR(MAX),
			Column_68 NVARCHAR(MAX),
			Column_69 NVARCHAR(MAX),
			Column_70 NVARCHAR(MAX),
			Column_71 NVARCHAR(MAX),
			Column_72 NVARCHAR(MAX),
			Column_73 NVARCHAR(MAX),
			Column_74 NVARCHAR(MAX),
			Column_75 NVARCHAR(MAX),
			Column_76 NVARCHAR(MAX),
			Column_77 NVARCHAR(MAX),
			Column_78 NVARCHAR(MAX),
			Column_79 NVARCHAR(MAX),
			Column_80 NVARCHAR(MAX),
			Column_81 NVARCHAR(MAX),
			Column_82 NVARCHAR(MAX),
			Column_83 NVARCHAR(MAX),
			Column_84 NVARCHAR(MAX),
			Column_85 NVARCHAR(MAX),
			Column_86 NVARCHAR(MAX),
			Column_87 NVARCHAR(MAX),
			Column_88 NVARCHAR(MAX),
			Column_89 NVARCHAR(MAX),
			Column_90 NVARCHAR(MAX),
			Column_91 NVARCHAR(MAX),
			Column_92 NVARCHAR(MAX),
			Column_93 NVARCHAR(MAX),
			Column_94 NVARCHAR(MAX),
			Column_95 NVARCHAR(MAX),
			Column_96 NVARCHAR(MAX),
			Column_97 NVARCHAR(MAX),
			Column_98 NVARCHAR(MAX),
			Column_99 NVARCHAR(MAX),
			Column_100 NVARCHAR(MAX),
			Column_101 NVARCHAR(MAX),
			Column_102 NVARCHAR(MAX),
			Column_103 NVARCHAR(MAX),
			Column_104 NVARCHAR(MAX),
			Column_105 NVARCHAR(MAX),
			Column_106 NVARCHAR(MAX),
			Column_107 NVARCHAR(MAX),
			Column_108 NVARCHAR(MAX),
			Column_109 NVARCHAR(MAX),
			Column_110 NVARCHAR(MAX),
			Column_111 NVARCHAR(MAX),
			Column_112 NVARCHAR(MAX),
			Column_113 NVARCHAR(MAX),
			Column_114 NVARCHAR(MAX),
			Column_115 NVARCHAR(MAX),
			Column_116 NVARCHAR(MAX),
			Column_117 NVARCHAR(MAX),
			Column_118 NVARCHAR(MAX),
			Column_119 NVARCHAR(MAX),
			Column_120 NVARCHAR(MAX),
			Column_121 NVARCHAR(MAX),
			Column_122 NVARCHAR(MAX),
			Column_123 NVARCHAR(MAX),
			Column_124 NVARCHAR(MAX),
			Column_125 NVARCHAR(MAX),
			Column_126 NVARCHAR(MAX),
			Column_127 NVARCHAR(MAX),
			Column_128 NVARCHAR(MAX),
			Column_129 NVARCHAR(MAX),
			Column_130 NVARCHAR(MAX),
			Column_131 NVARCHAR(MAX),
			Column_132 NVARCHAR(MAX),
			Column_133 NVARCHAR(MAX),
			Column_134 NVARCHAR(MAX),
			Column_135 NVARCHAR(MAX),
			Column_136 NVARCHAR(MAX),
			Column_137 NVARCHAR(MAX),
			Column_138 NVARCHAR(MAX),
			Column_139 NVARCHAR(MAX),
			Column_140 NVARCHAR(MAX),
			Column_141 NVARCHAR(MAX),
			Column_142 NVARCHAR(MAX),
			Column_143 NVARCHAR(MAX),
			Column_144 NVARCHAR(MAX),
			Column_145 NVARCHAR(MAX),
			Column_146 NVARCHAR(MAX),
			Column_147 NVARCHAR(MAX),
			Column_148 NVARCHAR(MAX),
			Column_149 NVARCHAR(MAX),
			Column_150 NVARCHAR(MAX),
			Column_151 NVARCHAR(MAX),
			Column_152 NVARCHAR(MAX),
			Column_153 NVARCHAR(MAX),
			Column_154 NVARCHAR(MAX),
			Column_155 NVARCHAR(MAX),
			Column_156 NVARCHAR(MAX),
			Column_157 NVARCHAR(MAX),
			Column_158 NVARCHAR(MAX),
			Column_159 NVARCHAR(MAX),
			Column_160 NVARCHAR(MAX),
			Column_161 NVARCHAR(MAX),
			Column_162 NVARCHAR(MAX),
			Column_163 NVARCHAR(MAX),
			Column_164 NVARCHAR(MAX),
			Column_165 NVARCHAR(MAX),
			Column_166 NVARCHAR(MAX),
			Column_167 NVARCHAR(MAX),
			Column_168 NVARCHAR(MAX),
			Column_169 NVARCHAR(MAX),
			Column_170 NVARCHAR(MAX)
		)
	
	--IF(@Is_Pushback != 'Y' )
		BEGIN
			PRINT 'Select all data of Right'
			-- Tnsert Right in #TEMP_Acquition_Deal_List_Report table ---
			INSERT INTO #TEMP_Acquition_Deal_List_Report
			(
				Acq_Deal_Right_Code, PA_Right_Type,
				Business_Unit_Code,
				TItle_Code,
				Title_Name
				,Episode_From,Episode_To,Deal_Type_Code
				,Director, Star_Cast
				,Genre, Title_Language, year_of_production, Acq_Deal_code 
				,Deal_Description, Reference_No, Agreement_No, Is_Master_Deal, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party
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
				,Right_Status
				,TC_QC
				,Is_Under_Production
				,Business_Unit_Name
			)
	
			Select 
			ADR.Acq_Deal_Rights_Code, ADR.PA_Right_Type,
			AD.Business_Unit_Code,
			T.Title_Code,
			T.Title_Name
			,CAST(ADRT.Episode_From AS INT)
			,ADRT.Episode_To,AD.Deal_Type_Code 
			,--dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) 
			'' Director, 
			--dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) 
			'' Star_Cast
			,--dbo.UFN_Get_Title_Genre(t.title_code) 
			''Genre
			,ISNULL(L.language_name, '') AS Title_Language,
			t.year_of_production, AD.Acq_Deal_Code
			,AD.Deal_Desc, AD.Ref_No, AD.Agreement_No, AD.Is_Master_Deal, CAST(AD.Agreement_Date as date), AD.Deal_Tag_Code, TG.Deal_Tag_Description, V.Vendor_Name
			,--[dbo].[UFN_Get_Platform_Name](ADR.Acq_Deal_Rights_Code, 'AR') 
			'' AS Platform_Name, 
			ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Is_Title_Language_Right
			--,CASE (DBO.UFN_Get_Rights_Country(ADR.Acq_Deal_Rights_Code, 'A',''))
			--	WHEN '' THEN DBO.UFN_Get_Rights_Territory(ADR.Acq_Deal_Rights_Code, 'A')
			--	ELSE DBO.UFN_Get_Rights_Country(ADR.Acq_Deal_Rights_Code, 'A','')
			--	END 
				,'' AS  Country_Territory_Name
			,CASE 
				WHEN ADR.Is_Exclusive = 'Y' THEN 'Exclusive'
				WHEN ADR.Is_Exclusive = 'N' THEN 'Non-Exclusive'
				ELSE 'Co-Exclusive'
			 END AS Is_Exclusive, 
			 --DBO.UFN_Get_Rights_Subtitling(ADR.Acq_Deal_Rights_Code, 'A') 
			 '' Subtitling
			,--DBO.UFN_Get_Rights_Dubbing(ADR.Acq_Deal_Rights_Code, 'A') 
			'' Dubbing
			,CASE LTRIM(RTRIM(ADR.Is_Sub_License))
				WHEN 'Y' THEN SL.Sub_License_Name
				ELSE 'No Sub Licensing'
			END SubLicencing
			,ADR.Is_Tentative, ADR.Is_ROFR, ADR.ROFR_Date AS First_Refusal_Date, ADR.Restriction_Remarks AS Restriction_Remarks, 
			--[dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](ADR.Acq_Deal_Rights_Code, 'AR','P') 
			'' Holdback_Platform,
			--[dbo].[UFN_Get_Holdback_Platform_Name_With_Comments](ADR.Acq_Deal_Rights_Code, 'AR','R') 
			'' Holdback_Right,  
			''--[dbo].[UFN_Get_Blackout_Period](ADR.Acq_Deal_Rights_Code, 'AR') 
			Blackout,
			AD.Remarks AS General_Remark, AD.Rights_Remarks AS Rights_Remarks, AD.Payment_Terms_Conditions AS Payment_Remarks, ADR.Right_Type,
			CASE ADR.Right_Type
				WHEN 'Y' THEN [dbo].[UFN_Get_Rights_Term](ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, Term) 
				WHEN 'M' THEN [dbo].[UFN_Get_Rights_Milestone](Milestone_Type_Code, Milestone_No_Of_Unit, Milestone_Unit_Type)
				WHEN 'U' THEN 'Perpetuity'
			End Right_Term,
			CASE UPPER(LTRIM(RTRIM(ISNULL(AD.Deal_Workflow_Status, '')))) 
				WHEN 'N' THEN 'Created'
				WHEN 'W' THEN 'Sent for authorization'
				WHEN 'A' THEN 'Approved' 
				WHEN 'R' THEN 'Declined'
				WHEN 'AM' THEN 'Amended'
				WHEN 'RP' THEN 'Runs Pending'
				ELSE Deal_Workflow_Status 
			END AS Deal_Workflow_Status,
			'N' as Is_Pushback, AD.Master_Deal_Movie_Code_ToLink
			,--[dbo].[UFN_Get_Run_Type] (AD.Acq_Deal_Code, ADR.Acq_Deal_Rights_Code ,@Title_Name) 
			'' AS Run_Type,
			CASE WHEN (SELECT count(*) FROM Acq_Deal_Attachment ADT WHERE ADT.Acq_Deal_Code = AD.Acq_Deal_Code) > 0 THEN 'Yes'
						ELSE 'No'
			END AS Is_Attachment,
			P.Program_Name as Program_Name,
			''
				as Promoter_Group_Name,
				''
				as Promoter_Remarks_Name,
			CASE UPPER(LTRIM(RTRIM(ISNULL(ADM.Due_Diligence, '')))) 
				WHEN 'N' THEN 'No'
				WHEN 'Y' THEN 'Yes'
				ELSE 'No' 
			END AS Due_Diligence,
			CASE ADR.Right_Status
				 WHEN 'W' THEN 'Inprocess' 
				 WHEN 'P' THEN 'Pending'
				 WHEN 'C' THEN 'Validation completed without Error'
				 WHEN 'E' THEN 'Validation completed with error' 
			 END AS Right_Status,
			CASE WHEN (ADR.Right_Type = 'M' AND ADR.Milestone_Unit_Type = 4) THEN 'No' 
				WHEN (ADR.Right_Type = 'Y' AND ADR.Milestone_Unit_Type = 1) THEN 'Yes'
				WHEN (ADR.Right_Type = 'Y' AND ADR.Milestone_Unit_Type = 3) THEN 'NA'
				ELSE 'NA' END AS TC_QC,
			--CASE WHEN ADR.Is_Under_Production = 'Y' THEN 'Yes' ELSE 'No' END AS Is_Under_Production,
			BU.Business_Unit_Name
			From Acq_Deal AD
			INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code AND ADR.PA_Right_Type = 'PR'
			INNER JOIN Acq_Deal_Rights_Title ADRT On ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
			INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
			LEFT JOIN Sub_License SL ON ADR.Sub_License_Code = SL.Sub_License_Code
			INNER JOIN Deal_Tag TG On AD.Deal_Tag_Code = TG.Deal_Tag_Code
			INNER JOIN Title T On ADRT.Title_Code = T.title_code
			LEFT JOIN Program P on T.Program_Code = P.Program_Code
			LEFT JOIN Language L on T.Title_Language_Code = L.language_code
			LEFT JOIN Acq_Deal_Movie ADM on ADRT.Title_Code = ADM.Title_Code AND ADRT.Episode_From = ADM.Episode_Starts_From AND ADRT.Episode_To = ADM.Episode_End_To AND ADM.Acq_Deal_Code = AD.Acq_Deal_Code
			INNER JOIN Business_Unit BU ON BU.Business_Unit_Code = AD.Business_Unit_Code
			WHERE  
			AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
			AD.Deal_Type_Code IN(select number from fn_Split_withdelemiter(@Deal_Type_Code,','))  AND
			--AD.Deal_Type_Code = @Deal_Type_Code AND
			(((ISNULL(CONVERT(date,ADR.Actual_Right_Start_Date ,103),'') >= CONVERT(date,@Start_Date,103)  OR @Start_Date = '' )AND (ISNULL(CONVERT(date,ADR.Actual_Right_Start_Date,103),'') <= CONVERT(date,@End_Date,103) OR @End_Date = '' ))
			AND ((CONVERT(date,ISNULL(ADR.Actual_Right_End_Date,'9999-12-31'),103) <=  CONVERT(date,@End_Date,103) OR @End_Date = '') AND (CONVERT(date,ISNULL(ADR.Actual_Right_End_Date,'9999-12-31'),103)>= CONVERT(date,@Start_Date,103) OR @Start_Date = '' )))
			AND AD.Agreement_No like '%' + @Agreement_No + '%' 
			AND (AD.Is_Master_Deal = @Is_Master_Deal Or @Is_Master_Deal = '')
			AND (AD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
			--AND (AD.Business_Unit_Code = CAST(@Business_Unit_code AS INT) OR CAST(@Business_Unit_code AS INT) = 0)
			AND (AD.Business_Unit_Code IN (select number from fn_Split_withdelemiter(@Business_Unit_code,','))
			AND (@Title_Name = '' OR ADRT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Name,',')))
			OR ad.Master_Deal_Movie_Code_ToLink IN (SELECT admT.Acq_Deal_Movie_Code FROM Acq_Deal_Movie admT where admT.Title_Code IN (select number from fn_Split_withdelemiter(@Title_Name,','))
			)
			)

			
			PRINT 'END'
		END
		
		INSERT INTO #RightTable(Acq_Deal_Code,Acq_Deal_Rights_Code,Platform_Codes,Platform_Names,Region_Name,Subtitle,Dubbing,RunType,PA_Right_Type)
		SELECT Acq_Deal_Code,Acq_Deal_Right_Code,null,null,null,null,null,null,PA_Right_Type  FROM #TEMP_Acquition_Deal_List_Report

		INSERT INTO #TitleTable(Title_Code,Eps_From,Eps_To,Director,StarCast,Genre)
		Select DISTINCT Title_Code,Episode_From,Episode_To,null,null,null FROM #TEMP_Acquition_Deal_List_Report

		INSERT INTO #DealTitleTable(Acq_Deal_Code,Title_Code,Eps_From,Eps_To,Run_Type)
		SELECT DISTINCT Acq_Deal_code,Title_Code,Episode_From,Episode_To,null FROM #TEMP_Acquition_Deal_List_Report
		

---------Director, StartCast Insert and update for Primary Rights-----------------------------------------------------------------------------------------------------------------------------
		
		UPDATE TT SET TT.Director = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 1),TT.StarCast = dbo.UFN_Get_Title_Metadata_By_Role_Code(TT.Title_Code, 2),TT.Genre = dbo.UFN_Get_Title_Genre(TT.TItle_Code)  
		FROM #TitleTable TT

		UPDATE TADLR SET TADLR.Director = TT.Director,TADLR.Star_Cast = TT.StarCast,TADLR.Genre = TT.Genre
		FROM #TEMP_Acquition_Deal_List_Report TADLR
		INNER JOIN #TitleTable TT ON TADLR.Title_Code = TT.Title_Code AND TADLR.Episode_From = TT.Eps_From AND TADLR.Episode_To = Eps_To

---------Director, StartCast Insert and update for Primary Rights-----------------------------------------------------------------------------------------------------------------------------

---------Platform Insert and update for Primary Rights-----------------------------------------------------------------------------------------------------------------------------	

		UPDATE RT SET RT.Platform_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(AADRP.Platform_Code AS NVARCHAR(MAX)) from  Acq_Deal_Rights_Platform AADRP 
		WHERE RT.Acq_Deal_Rights_Code = AADRP.Acq_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
		WHERE PA_Right_Type = 'PR' 
		
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
		WHERE TADLR.PA_Right_Type = 'PR' 

		IF(@IncludeAncillary = 'Y')
		BEGIN
			UPDATE RT SET RT.Platform_Codes = 
			STUFF((Select DISTINCT ',' +  CAST(AADRA.Platform_Code AS NVARCHAR(MAX)) from  Acq_Deal_Rights_Ancillary AADRA
			WHERE RT.Acq_Deal_Rights_Code = AADRA.Acq_Deal_Rights_Code --order by AADRP.Platform_Code ASC
			           FOR XML PATH('')),1,1,'')
			FROM #RightTable RT 
			WHERE PA_Right_Type = 'AR' 

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
			WHERE TADLR.PA_Right_Type = 'AR' 
		END


---------Platform Insert and update for Primary Rights-----------------------------------------------------------------------------------------------------------------------------

---------Region,Subtitle,Dubbing Insert and update for Primary Rights-----------------------------------------------------------------------------------------------------------------------------

		UPDATE RT SET RT.Region_Codes = 
		STUFF((Select DISTINCT ',' +  CAST(CASE WHEN AADRP.Country_Code IS NULL THEN AADRP.Territory_Code ELSE AADRP.Country_Code END AS NVARCHAR(MAX))
		from  Acq_Deal_Rights_Territory AADRP 
		WHERE RT.Acq_Deal_Rights_Code = AADRP.Acq_Deal_Rights_Code --order by AADRP.Platform_Code ASC
		           FOR XML PATH('')),1,1,'')
		FROM #RightTable RT 
		WHERE PA_Right_Type = 'PR' 

		UPDATE RT SET RT.RGType = ADRT.Territory_Type
		FROM #RightTable RT 
		INNER JOIN Acq_Deal_Rights_Territory ADRT ON RT.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 
		WHERE PA_Right_Type = 'PR'

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
		WHERE PA_Right_Type = 'PR' 

		UPDATE RT SET RT.SLType = ADRS.Language_Type
		FROM #RightTable RT 
		INNER JOIN Acq_Deal_Rights_Subtitling ADRS ON RT.Acq_Deal_Rights_Code = ADRS.Acq_Deal_Rights_Code 
		WHERE PA_Right_Type = 'PR'

		UPDATE RT SET RT.DBType = ADRD.Language_Type
		FROM #RightTable RT 
		INNER JOIN Acq_Deal_Rights_Dubbing ADRD ON RT.Acq_Deal_Rights_Code = ADRD.Acq_Deal_Rights_Code 
		WHERE PA_Right_Type = 'PR'

		INSERT INTO #RegionTable(Region_Codes,Region_Names,Region_Type)
		SELECT DISTINCT Region_Codes,NULL,RGType FROM #RightTable

		--INSERT INTO #LangTable(SL_Lang_Codes,DB_Lang_Codes,SL_Lang_Names,DB_Lang_Names,SL_Lang_Type,DB_Lang_Type)
		--SELECT DISTINCT SL_Codes,DB_Codes,NULL,NULL,SLType ,DBType FROM #RightTable

		INSERT INTO #LangTable(Lang_Codes,Lang_Names,Lang_Type)
		SELECT DISTINCT SL_Codes,NULL,SLType FROM #RightTable
		UNION
		SELECT DISTINCT DB_Codes,NULL,DBType FROM #RightTable

		UPDATE RT SET RT.Region_Names = CT.Criteria_Name FROM #RegionTable RT
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](RT.Region_Codes,RT.Region_Type,'RG') CT

		UPDATE LTB SET LTB.Lang_Names = LT.Criteria_Name FROM #LangTable LTB
		CROSS APPLY [UFN_Get_PR_Rights_Criteria](LTB.Lang_Codes,LTB.Lang_Type,'SL') LT

		--UPDATE LTB SET LTB.DB_Lang_Names = LT.Criteria_Name FROM #LangTable LTB
		--CROSS APPLY [UFN_Get_PR_Rights_Criteria](LTB.DB_Lang_Codes,LTB.DB_Lang_Type,'DB') LT

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


			
		--UPDATE RT SET RT.Region_Name =  CASE (DBO.UFN_Get_Rights_Country(RT.Acq_Deal_Rights_Code, 'A',''))
		--		WHEN '' THEN DBO.UFN_Get_Rights_Territory(RT.Acq_Deal_Rights_Code, 'A')
		--		ELSE DBO.UFN_Get_Rights_Country(RT.Acq_Deal_Rights_Code, 'A','')
		--		END,
		--RT.Subtitle = DBO.UFN_Get_Rights_Subtitling(RT.Acq_Deal_Rights_Code, 'A'), 		
		--RT.Dubbing = DBO.UFN_Get_Rights_Dubbing(RT.Acq_Deal_Rights_Code, 'A')  ,
		--RT.RunType = [dbo].[UFN_Get_Run_Type] (RT.Acq_Deal_Code, RT.Acq_Deal_Rights_Code ,@Title_Name) 		 
		--FROM #RightTable RT
		--WHERE RT.PA_Right_Type = 'PR'

		--UPDATE TADLR SET TADLR.Country_Territory_Name = RT.Region_Name,TADLR.Subtitling = RT.Subtitle,TADLR.Dubbing =  RT.Dubbing,TADLR.Run_Type = RT.RunType
		--FROM #TEMP_Acquition_Deal_List_Report TADLR 
		--INNER JOIN #RightTable RT ON TADLR.Acq_Deal_Right_Code = RT.Acq_Deal_Rights_Code


---------Region,Subtitle,Dubbing Insert and update for Primary Rights-----------------------------------------------------------------------------------------------------------------------------

--select * from #TEMP_Acquition_Deal_List_Report; -- where PA_Right_Type = 'AR'-- contains all 170 columns 
--select * from Acq_Deal where Agreement_No = 'A-2019-00151'
--select * from Acq_Deal where Acq_Deal_Code IN(15536,15534,15534,15543,15543)

	IF(@Is_Pushback != 'N' )
	BEGIN
		---- Tnsert Right in #TEMP_Acquition_Deal_List_Report table ---
		INSERT INTO #TEMP_Acquition_Deal_List_Report
		(
			Title_Name 
			,Episode_From,Episode_To,Deal_Type_Code
			,Director, Star_Cast, 
			Genre, Title_Language, year_of_production, Acq_Deal_code, Deal_Description, Reference_No, 
			Agreement_No, Is_Master_Deal, Agreement_Date, Deal_Tag_Code, Deal_Tag_Description, Party,
			Platform_Name, Right_Start_Date, Right_End_Date, Is_Title_Language_Right, 
			Country_Territory_Name, Is_Exclusive, 
			Subtitling, Dubbing, Sub_Licencing, 
			Is_Tentative, Is_ROFR, First_Refusal_Date, Restriction_Remarks, 
			Holdback_Platform,Holdback_Rights
			,Blackout, 
			General_Remark, Rights_Remarks, Payment_Remarks, 
			Right_Type, Right_Term,
			Deal_Workflow_Status, Is_Pushback, Master_Deal_Movie_Code_ToLink, Run_Type,Is_Attachment,[Program_Name],
			Due_Diligence,Right_Status,TC_QC,Is_Under_Production,Business_Unit_Name
		)
		Select T.Title_Name,
		CAST(ADPT.Episode_From AS INT),ADPT.Episode_To,AD.Deal_Type_Code,
		dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 1) Director, dbo.UFN_Get_Title_Metadata_By_Role_Code(T.Title_Code, 2) Star_Cast,
		dbo.UFN_Get_Title_Genre(t.title_code) Genre, ISNULL(L.language_name, '') AS Title_Language, t.year_of_production, AD.Acq_Deal_Code, AD.Deal_Desc, AD.Ref_No,
		AD.Agreement_No, AD.Is_Master_Deal, CAST(AD.Agreement_Date as date), ad.Deal_Tag_Code, tg.Deal_Tag_Description, V.Vendor_Name, 
		[dbo].[UFN_Get_Platform_Name](ADP.Acq_Deal_Pushback_Code, 'AP') Platform_Name, ADP.Right_Start_Date, ADP.Right_End_Date, ADP.Is_Title_Language_Right, 
		DBO.UFN_Get_Rights_Country(ADP.Acq_Deal_Pushback_Code, 'p','')
		AS  Country_Territory_Name,
		'' Is_Exclusive,
		DBO.UFN_Get_Rights_Subtitling(ADP.Acq_Deal_Pushback_Code, 'P') Subtitling, DBO.UFN_Get_Rights_Dubbing(ADP.Acq_Deal_Pushback_Code, 'P') Dubbing,
		'' SubLicencing, ADP.Is_Tentative, 'N' Is_ROFR, NULL First_Refusal_Date, '' Restriction_Remarks, 
		'' Holdback_Platform,'' Holdback_Rights, 
		'' Blackout, '' General_Remark ,ADP.Remarks Rights_Remarks,
		'' Payment_Remarks, ADP.Right_Type,
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
			WHEN 'RP' THEN 'Runs Pending'
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
		END AS Due_Diligence
		,'','','',''
		
		FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Pushback ADP On AD.Acq_Deal_Code = ADP.Acq_Deal_Code
		INNER JOIN Acq_Deal_Pushback_Title ADPT On ADP.Acq_Deal_Pushback_Code = ADPT.Acq_Deal_Pushback_Code 
		INNER JOIN Vendor V ON AD.Vendor_Code = V.Vendor_Code
		INNER JOIN Deal_Tag TG On AD.Deal_Tag_Code = TG.Deal_Tag_Code
		INNER JOIN Title T On ADPT.Title_Code = T.title_code
		LEFT JOIN Program P on T.Program_Code = P.Program_Code
		LEFT JOIN Language L on T.Title_Language_Code = L.language_code
		LEFT JOIN Acq_Deal_Movie ADM on ADPT.Title_Code = ADM.Title_Code AND ADPT.Episode_From = ADM.Episode_Starts_From AND ADPT.Episode_To = ADM.Episode_End_To AND ADM.Acq_Deal_Code = AD.Acq_Deal_Code
		WHERE  
		AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
		(((ISNULL(CONVERT(date,ADP.Right_Start_Date,103),'') >= CONVERT(date,@Start_Date,103)OR @Start_Date = ''  )AND (ISNULL(CONVERT(date,ADP.Right_Start_Date,103),'') <= CONVERT(date,@End_Date,103)OR @End_Date = ''))
		AND ((CONVERT(date,ISNULL(ADP.Right_End_Date,'9999-12-31'),103)<=  CONVERT(date,@End_Date,103) OR @End_Date = ''  ) AND (CONVERT(date,ISNULL(ADP.Right_End_Date,'9999-12-31'),103) >= CONVERT(date,@Start_Date,103)OR @Start_Date = ''  )))
		AND AD.Agreement_No like '%' + @Agreement_No + '%' 
		AND (AD.Is_Master_Deal = @Is_Master_Deal Or @Is_Master_Deal = '')
		AND (AD.Deal_Tag_Code = @Deal_Tag_Code OR @Deal_Tag_Code = 0) 
		AND (AD.Business_Unit_Code = CAST(@Business_Unit_code AS INT)OR CAST(@Business_Unit_code AS INT) = 0)
		AND (@Title_Name = '' OR ADPT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Name,',')))
	END

PRINT 'Select distinct from #TEMP_Acquition_Deal_List_Report TEMP_ADLR'
--Select Is_PushBack, Right_End_Date from #TEMP_Acquition_Deal_List_Report

	BEGIN
	SELECT DISTINCT 
	TEMP_ADLR.Acq_Deal_Right_Code AS Acq_Deal_Right_Code, 
	TEMP_ADLR.PA_Right_Type AS PA_Right_Type,
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
	TEMP_ADLR.Party AS Party, 
	CASE WHEN Is_PushBack = 'N' THEN TEMP_ADLR.Platform_Name ELSE '--' END AS Platform_Name, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_Start_Date ELSE NULL END AS Rights_Start_Date, 
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Right_End_Date ELSE NULL END AS Rights_End_Date, 
	TEMP_ADLR.Is_Title_Language_Right,
	CASE WHEN TEMP_ADLR.Is_PushBack = 'N' THEN TEMP_ADLR.Country_Territory_Name ELSE '--' END AS Country_Territory_Name,
	--CASE 
	--	WHEN TEMP_ADLR.Is_Exclusive = 'Y' THEN 'Exclusive'
	--	WHEN TEMP_ADLR.Is_Exclusive = 'N' THEN 'Non-Exclusive'
	--	ELSE 'Co-Exclusive'
	--END AS 
	Is_Exclusive, 
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
	TEMP_ADLR.Right_Status,
	TEMP_ADLR.TC_QC,
	TEMP_ADLR.Is_Under_Production,
	TEMP_ADLR.Business_Unit_Name
	--,TEMP_ADLR.Column_51,TEMP_ADLR.Column_52,TEMP_ADLR.Column_53,TEMP_ADLR.Column_54,TEMP_ADLR.Column_55,TEMP_ADLR.Column_56,TEMP_ADLR.Column_57,TEMP_ADLR.Column_58,
	--TEMP_ADLR.Column_59,TEMP_ADLR.Column_60,TEMP_ADLR.Column_61,TEMP_ADLR.Column_62,TEMP_ADLR.Column_63,TEMP_ADLR.Column_64,TEMP_ADLR.Column_65,TEMP_ADLR.Column_66,TEMP_ADLR.Column_67
	INTO #TempAcqDealListReport
	FROM #TEMP_Acquition_Deal_List_Report TEMP_ADLR
	LEFT JOIN Acq_Deal_Movie ADM ON TEMP_ADLR.Master_Deal_Movie_Code_ToLink = ADM.Acq_Deal_Movie_Code
	--LEFT JOIN Title T on ADM.Title_Code = T.Title_Code
	ORDER BY TEMP_ADLR.Agreement_No, TEMP_ADLR.Is_Pushback


	--Select * from #TempAcqDealListReport
	
	END

	PRINT 'Select column values as per system language in variables from @Col_Head01 to @Col_Head51'

	BEGIN
	SELECT 
	@Col_Head01 = 'AcqDealRightCode',
	@Col_Head02 = 'PARightType',
	@Col_Head03 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
	@Col_Head04 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
	@Col_Head05 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
	@Col_Head06 = CASE WHEN  SM.Message_Key = 'ReferenceNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
	@Col_Head07 = CASE WHEN  SM.Message_Key = 'DealType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
	@Col_Head08 = CASE WHEN  SM.Message_Key = 'AgreementDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
	@Col_Head09 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
	@Col_Head10 = CASE WHEN  SM.Message_Key = 'Party' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
	@Col_Head11 = CASE WHEN  SM.Message_Key = 'Program' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
	@Col_Head12 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
	@Col_Head13 = CASE WHEN  SM.Message_Key = 'Director' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
	@Col_Head14 = CASE WHEN  SM.Message_Key = 'starCast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
	@Col_Head15 = CASE WHEN  SM.Message_Key = 'Genres' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
	@Col_Head16 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
	@Col_Head17 = CASE WHEN  SM.Message_Key = 'ReleaseYear' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
	@Col_Head18 = CASE WHEN  SM.Message_Key = 'Platform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
	@Col_Head19 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
	@Col_Head20 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
	@Col_Head21 = CASE WHEN  SM.Message_Key = 'Tentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
	@Col_Head22 = CASE WHEN  SM.Message_Key = 'Pushback' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
	@Col_Head23 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
	@Col_Head24 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END,
	@Col_Head25 = CASE WHEN  SM.Message_Key = 'Exclusive' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head25 END,
	@Col_Head26 = CASE WHEN  SM.Message_Key = 'TitleLanguageRight' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head26 END,
	@Col_Head27 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head27 END,
	@Col_Head28 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head28 END,
	@Col_Head29 = CASE WHEN  SM.Message_Key = 'Sublicensing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head29 END,
	@Col_Head30 = CASE WHEN  SM.Message_Key = 'ROFR' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head30 END,
	@Col_Head31 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head31 END,
	@Col_Head32 = CASE WHEN  SM.Message_Key = 'RightsHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head32 END,
	@Col_Head33 = CASE WHEN  SM.Message_Key = 'RightsHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head33 END,
	@Col_Head34 = CASE WHEN  SM.Message_Key = 'Blackout' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head34 END,
	@Col_Head35 = CASE WHEN  SM.Message_Key = 'RightsRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head35 END,
	@Col_Head36 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head36 END,
	@Col_Head37 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head37 END,
	@Col_Head38 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head38 END,
	@Col_Head39 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head39 END,
	@Col_Head40 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackTerm' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head40 END,
	@Col_Head41 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackCountry' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head41 END,
	@Col_Head42 = CASE WHEN  SM.Message_Key = 'ReverseHoldbackRemark' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head42 END,
	@Col_Head43 = CASE WHEN  SM.Message_Key = 'GeneralRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head43 END,
	@Col_Head44 = CASE WHEN  SM.Message_Key = 'Paymenttermsconditions' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head44 END,
	@Col_Head45 = CASE WHEN  SM.Message_Key = 'WorkflowStatus' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head45 END,
	@Col_Head46 = CASE WHEN  SM.Message_Key = 'RunType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head46 END,
	@Col_Head47 = CASE WHEN  SM.Message_Key = 'Attachment' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head47 END,
	@Col_Head48 = CASE WHEN  SM.Message_Key = 'SelfUtilizationGroup' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head48 END,
	@Col_Head49 = CASE WHEN  SM.Message_Key = 'SelfUtilizationRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head49 END,
	@Col_Head50 = CASE WHEN  SM.Message_Key = 'DueDiligence' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head50 END,
	@Col_Head51 = CASE WHEN  SM.Message_Key = 'RightStatus' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head51 END
	FROM System_Message SM  
	INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
	AND SM.Message_Key IN ('Acq_Deal_Right_Code','PA_Right_Type','AgreementNo','TitleType','DealDescription','ReferenceNo','DealType','AgreementDate','Status','Party','Program','Title','Director','starCast','Genres','TitleLanguage','ReleaseYear','Platform','RightStartDate','RightEndDate',
	'Tentative','Pushback','Term','Region','Exclusive','TitleLanguageRight','Subtitling','Dubbing','Sublicensing','ROFR','RestrictionRemarks','RightsHoldbackPlatform','RightsHoldbackRemark','Blackout','RightsRemark','ReverseHoldbackPlatform','ReverseHoldbackStartDate'
	,'ReverseHoldbackEndDate','ReverseHoldbackTentative','ReverseHoldbackTerm','ReverseHoldbackCountry','ReverseHoldbackRemark','GeneralRemarks','Paymenttermsconditions','WorkflowStatus','RunType','Attachment','SelfUtilizationGroup','SelfUtilizationRemarks','DueDiligence','RightStatus')  
	INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
	--select * from System_Message where Message_Key like '%Push%'
	END

	
		IF(@IncludeAncillary = 'N')
		BEGIN
			IF EXISTS(SELECT TOP 1 * FROM #TempAcqDealListReport)
				BEGIN
					SELECT 
						[Acq_Deal_Right_Code], [PA_Right_Type],
						 [Agreement_No] ,
						 [Title Type], [Deal Description], [Reference No], [Deal Type]
						 , [Agreement Date], [Status], [Party], [Program], [Title], [Director]
						 , [Star Cast],[Genre], [Title Language], [Release Year], [Platform], [Rights Start Date], [Rights End Date], [Tentative], [Pushback], [Term], [Region], [Exclusive], [Title Language Right],
						 [Subtitling], [Dubbing], [Sub Licensing], [ROFR], [Restriction Remark], [Rights Holdback Platform], [Rights Holdback Remarks], [Blackout], [Rights Remarks],
						 [Reverse Holdback Platform], [Reverse Holdback Start Date], [Reverse Holdback End Date], [Reverse Holdback Tentative], [Reverse Holdback Term], [Reverse Holdback Country],
						 [Reverse Holdback Remarks], [General Remark], [Payment terms & Conditions], [Workflow status], [Run Type], [Attachment], [Self Utilization Group], [Self Utilization Remarks], [Due Diligence],[Right Status],[TC_QC],[Is_Under_Production],[Business_Unit_Name]
					FROM (
					SELECT
						sorter = 1,  
						CAST(Acq_Deal_Right_Code AS VARCHAR(100)) AS [Acq_Deal_Right_Code],
						CAST(PA_Right_Type AS VARCHAR(100))  AS [PA_Right_Type],
						CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], 
						CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No], CAST([Is_Master_Deal] AS NVARCHAR(MAX)) As [Deal Type],
						CONVERT(VARCHAR(12),[Agreement_Date],103) As [Agreement Date], CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status], CAST([Party] AS NVARCHAR(MAX)) As [Party], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
						CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(VARCHAR(12),[Rights_Start_Date],103) AS [Rights Start Date], 
						CONVERT(VARCHAR(12),[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
						CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CAST([First_Refusal_Date] AS NVARCHAR(MAX)) As [ROFR],
						CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
						CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], CONVERT(VARCHAR(12),[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(VARCHAR(12),[Pushback_End_Date],103) As [Reverse Holdback End Date],
						CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
						CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
						CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks],  CAST([Due_Diligence] AS NVARCHAR(MAX)) As [Due Diligence],CAST([Right_Status] AS NVARCHAR(MAX)) As [Right Status],CAST([TC_QC] AS NVARCHAR(MAX)) As [TC_QC],CAST([Is_Under_Production] AS NVARCHAR(MAX)) As [Is_Under_Production],
						CAST([Business_Unit_Name] AS NVARCHAR(MAX)) As [Business_Unit_Name]
					From #TempAcqDealListReport WHERE	PA_Right_Type IN('PR')
					UNION ALL
						SELECT CAST(0 AS Varchar(100)),
						@Col_Head01, 
						@Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11
						, @Col_Head12, @Col_Head13, @Col_Head14, @Col_Head15,  @Col_Head16, @Col_Head17, @Col_Head18, @Col_Head19, @Col_Head20, @Col_Head21, @Col_Head22, @Col_Head23, @Col_Head24, @Col_Head25, @Col_Head26
						, @Col_Head27, @Col_Head28, @Col_Head29, @Col_Head30, @Col_Head31, @Col_Head32, @Col_Head33, @Col_Head34, @Col_Head35, @Col_Head36, @Col_Head37, @Col_Head38, @Col_Head39, @Col_Head40
						, @Col_Head41, @Col_Head42, @Col_Head43, @Col_Head44, @Col_Head45, @Col_Head46, @Col_Head47,@Col_Head48,@Col_Head49,@Col_Head50,@Col_Head51,@Col_Head52,@Col_Head53, @Col_Head54
					) X  
					ORDER BY Sorter
				END
				ELSE 
				BEGIN
					SELECT * FROM #TempAcqDealListReport
				END
		END
		ELSE
		BEGIN
		IF EXISTS(SELECT TOP 1 * FROM #TempAcqDealListReport)
		BEGIN
			IF(UPPER(@Deal_Type) = 'SPORTS')
			BEGIN
				SELECT 
					[Acq_Deal_Right_Code], [PA_Right_Type],
					 [Agreement_No] ,
					 [Title Type], [Deal Description], [Reference No], [Deal Type]
					 , [Agreement Date], [Status], [Party], [Program], [Title], [Director]
					 , [Star Cast],[Genre], [Title Language], [Release Year], [Platform], [Rights Start Date], [Rights End Date], [Tentative], [Pushback], [Term], [Region], [Exclusive], [Title Language Right],
					 [Subtitling], [Dubbing], [Sub Licensing], [ROFR], [Restriction Remark], [Rights Holdback Platform], [Rights Holdback Remarks], [Blackout], [Rights Remarks],
					 [Reverse Holdback Platform], [Reverse Holdback Start Date], [Reverse Holdback End Date], [Reverse Holdback Tentative], [Reverse Holdback Term], [Reverse Holdback Country],
					 [Reverse Holdback Remarks], [General Remark], [Payment terms & Conditions], [Workflow status], [Run Type], [Attachment], [Self Utilization Group], [Self Utilization Remarks], [Due Diligence],[Right Status],[TC_QC],[Is_Under_Production],[Business_Unit_Name]
					 ,[Col_Head51],[Col_Head52],[Col_Head53],[Col_Head54],[Col_Head55],[Col_Head56],[Col_Head57],[Col_Head58],[Col_Head59],[Col_Head60],[Col_Head61],[Col_Head62],
					 [Col_Head63],[Col_Head64],[Col_Head65],[Col_Head66],[Col_Head67],[Col_Head68],[Col_Head69],[Col_Head70],[Col_Head71],[Col_Head72],[Col_Head73],[Col_Head74],
					 [Col_Head75],[Col_Head76],[Col_Head77],[Col_Head78],[Col_Head79],[Col_Head80],[Col_Head81],[Col_Head82],[Col_Head83],[Col_Head84],[Col_Head85],[Col_Head86],
					 [Col_Head87],[Col_Head88],[Col_Head89],[Col_Head90],[Col_Head91],[Col_Head92],[Col_Head93],[Col_Head94],[Col_Head95],[Col_Head96],[Col_Head97],[Col_Head98],
					 [Col_Head99],[Col_Head100],[Col_Head101],[Col_Head102],[Col_Head103],[Col_Head104],[Col_Head105],[Col_Head106],[Col_Head107],[Col_Head108],[Col_Head109],[Col_Head110],
					 [Col_Head111],[Col_Head112],[Col_Head113],[Col_Head114],[Col_Head115],[Col_Head116],[Col_Head117],[Col_Head118],[Col_Head119],[Col_Head120],[Col_Head121],[Col_Head122],
					 [Col_Head123],[Col_Head124],[Col_Head125],[Col_Head126],[Col_Head127],[Col_Head128],[Col_Head129],[Col_Head130],[Col_Head131]
				FROM (
				SELECT
					sorter = 1,  
					CAST(Acq_Deal_Right_Code AS VARCHAR(100)) AS [Acq_Deal_Right_Code],
					CAST(PA_Right_Type AS VARCHAR(100))  AS [PA_Right_Type],
					CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], 
					CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No], CAST([Is_Master_Deal] AS NVARCHAR(MAX)) As [Deal Type],
					CONVERT(VARCHAR(12),[Agreement_Date],103) As [Agreement Date], CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status], CAST([Party] AS NVARCHAR(MAX)) As [Party], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
					CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(VARCHAR(12),[Rights_Start_Date],103) AS [Rights Start Date], 
					CONVERT(VARCHAR(12),[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
					CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CAST([First_Refusal_Date] AS NVARCHAR(MAX)) As [ROFR],
					CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
					CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], CONVERT(VARCHAR(12),[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(VARCHAR(12),[Pushback_End_Date],103) As [Reverse Holdback End Date],
					CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
					CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
					CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks],  CAST([Due_Diligence] AS NVARCHAR(MAX)) As [Due Diligence],CAST([Right_Status] AS NVARCHAR(MAX)) As [Right Status],CAST([TC_QC] AS NVARCHAR(MAX)) As [TC_QC],CAST([Is_Under_Production] AS NVARCHAR(MAX)) As [Is_Under_Production],
					CAST([Business_Unit_Name] AS NVARCHAR(MAX)) As [Business_Unit_Name],null as Col_Head51,null as Col_Head52,null as Col_Head53,null as Col_Head54,null AS Col_Head55,
					null Col_Head56,null as Col_Head57,null as Col_Head58,null as Col_Head59,null as Col_Head60,null as Col_Head61,null as Col_Head62,null as Col_Head63,null as Col_Head64,
					null as Col_Head65,null Col_Head66,null as Col_Head67,null as Col_Head68,null as Col_Head69,null as Col_Head70,null as Col_Head71,null as Col_Head72,null as Col_Head73,
					null as Col_Head74, null as Col_Head75,null as Col_Head76,null as Col_Head77,null as Col_Head78,null as Col_Head79,null as Col_Head80,null as Col_Head81,null as Col_Head82,null as Col_Head83,null as Col_Head84,null as Col_Head85,null as Col_Head86,
					 null as Col_Head87,null as Col_Head88,null as Col_Head89,null as Col_Head90,null as Col_Head91,null as Col_Head92,null as Col_Head93,null as Col_Head94,null as Col_Head95,null as Col_Head96,null as Col_Head97,null as Col_Head98,
					 null as Col_Head99,null as Col_Head100,null as Col_Head101,null as Col_Head102,null as Col_Head103,null as Col_Head104,null as Col_Head105,null as Col_Head106,null as Col_Head107,null as Col_Head108,null as Col_Head109,null as Col_Head110,
					 null as Col_Head111,null as Col_Head112,null as Col_Head113,null as Col_Head114,null as Col_Head115,null as Col_Head116,null as Col_Head117,null as Col_Head118,null as Col_Head119,null as Col_Head120,null as Col_Head121,null as Col_Head122,
					 null as Col_Head123,null as Col_Head124,null as Col_Head125,null as Col_Head126,null as Col_Head127,null as Col_Head128,null as Col_Head129,null as Col_Head130,null as Col_Head131
				From #TempAcqDealListReport TADLR  WHERE	PA_Right_Type IN('PR')
				UNION ALL
				SELECT
					sorter = 1,  
					CAST(Acq_Deal_Right_Code AS VARCHAR(100)) AS [Acq_Deal_Right_Code],
					CAST(PA_Right_Type AS VARCHAR(100))  AS [PA_Right_Type],
					CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], 
					CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No], CAST([Is_Master_Deal] AS NVARCHAR(MAX)) As [Deal Type],
					CONVERT(VARCHAR(12),[Agreement_Date],103) As [Agreement Date], CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status], CAST([Party] AS NVARCHAR(MAX)) As [Party], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
					CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(VARCHAR(12),[Rights_Start_Date],103) AS [Rights Start Date], 
					CONVERT(VARCHAR(12),[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
					CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CAST([First_Refusal_Date] AS NVARCHAR(MAX)) As [ROFR],
					CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
					CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], CONVERT(VARCHAR(12),[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(VARCHAR(12),[Pushback_End_Date],103) As [Reverse Holdback End Date],
					CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
					CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
					CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks],  CAST([Due_Diligence] AS NVARCHAR(MAX)) As [Due Diligence],CAST([Right_Status] AS NVARCHAR(MAX)) As [Right Status],CAST([TC_QC] AS NVARCHAR(MAX)) As [TC_QC],CAST([Is_Under_Production] AS NVARCHAR(MAX)) As [Is_Under_Production],
					CAST([Business_Unit_Name] AS NVARCHAR(MAX)) As [Business_Unit_Name],AD.Col_Head51,AD.Col_Head52,AD.Col_Head53,AD.Col_Head54,AD.Col_Head55,AD.Col_Head56,AD.Col_Head57,AD.Col_Head58,AD.Col_Head59,AD.Col_Head60,
					AD.Col_Head61,AD.Col_Head62,AD.Col_Head63,AD.Col_Head64,AD.Col_Head65,AD.Col_Head66,AD.Col_Head67,AD.Col_Head68,AD.Col_Head69,AD.Col_Head70,AD.Col_Head71,AD.Col_Head72,AD.Col_Head73,
					AD.Col_Head74, AD.Col_Head75,AD.Col_Head76,AD.Col_Head77,AD.Col_Head78,AD.Col_Head79,AD.Col_Head80,AD.Col_Head81,AD.Col_Head82,AD.Col_Head83,AD.Col_Head84,AD.Col_Head85,AD.Col_Head86,
					 AD.Col_Head87,AD.Col_Head88,AD.Col_Head89,AD.Col_Head90,AD.Col_Head91,AD.Col_Head92,AD.Col_Head93,AD.Col_Head94,AD.Col_Head95,AD.Col_Head96,AD.Col_Head97,AD.Col_Head98,
					 AD.Col_Head99,AD.Col_Head100,AD.Col_Head101,AD.Col_Head102,AD.Col_Head103,AD.Col_Head104,AD.Col_Head105,AD.Col_Head106,AD.Col_Head107,AD.Col_Head108,AD.Col_Head109,AD.Col_Head110,
					 AD.Col_Head111,AD.Col_Head112,AD.Col_Head113,AD.Col_Head114,AD.Col_Head115,AD.Col_Head116,AD.Col_Head117,AD.Col_Head118,AD.Col_Head119,AD.Col_Head120,AD.Col_Head121,AD.Col_Head122,
					 AD.Col_Head123,AD.Col_Head124,AD.Col_Head125,AD.Col_Head126,AD.Col_Head127,AD.Col_Head128,AD.Col_Head129,AD.Col_Head130,AD.Col_Head131
				From #TempAcqDealListReport TADLR  
				LEFT JOIN #AncData AD ON TADLR.Acq_Deal_Right_Code = AD.Acq_Deal_Rights_Code
				WHERE PA_Right_Type IN('AR')
				UNION ALL
					SELECT CAST(0 AS Varchar(100)),
					@Col_Head01, 
					@Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11
					, @Col_Head12, @Col_Head13, @Col_Head14, @Col_Head15,  @Col_Head16, @Col_Head17, @Col_Head18, @Col_Head19, @Col_Head20, @Col_Head21, @Col_Head22, @Col_Head23, @Col_Head24, @Col_Head25, @Col_Head26
					, @Col_Head27, @Col_Head28, @Col_Head29, @Col_Head30, @Col_Head31, @Col_Head32, @Col_Head33, @Col_Head34, @Col_Head35, @Col_Head36, @Col_Head37, @Col_Head38, @Col_Head39, @Col_Head40
					, @Col_Head41, @Col_Head42, @Col_Head43, @Col_Head44, @Col_Head45, @Col_Head46, @Col_Head47,@Col_Head48,@Col_Head49,@Col_Head50,@Col_Head51,@Col_Head52,@Col_Head53, @Col_Head54,
					@AncCol_Head1,@AncCol_Head2,@AncCol_Head3,@AncCol_Head4,@AncCol_Head5,@AncCol_Head6,@AncCol_Head7,@AncCol_Head8,@AncCol_Head9,@AncCol_Head10,@AncCol_Head11,@AncCol_Head12,
					@AncCol_Head13,@AncCol_Head14,@AncCol_Head15,@AncCol_Head16,@AncCol_Head17, @AncCol_Head18 , @AncCol_Head19 , @AncCol_Head20 , @AncCol_Head21 , @AncCol_Head22 ,
					@AncCol_Head23 , @AncCol_Head24 , @AncCol_Head25 , @AncCol_Head26 , @AncCol_Head27 , @AncCol_Head28 , @AncCol_Head29 , @AncCol_Head30 , @AncCol_Head31 , @AncCol_Head32 ,
					@AncCol_Head33 , @AncCol_Head34 , @AncCol_Head35 , @AncCol_Head36 , @AncCol_Head37 , 
					@AncCol_Head38 ,@AncCol_Head39 ,@AncCol_Head40 ,@AncCol_Head41 ,@AncCol_Head42 ,@AncCol_Head43 ,@AncCol_Head44 ,@AncCol_Head45 ,@AncCol_Head46 ,@AncCol_Head47 ,@AncCol_Head48 ,
					@AncCol_Head49 ,@AncCol_Head50 ,@AncCol_Head51 ,@AncCol_Head52 ,@AncCol_Head53 ,@AncCol_Head54 ,@AncCol_Head55,@AncCol_Head56 ,@AncCol_Head57 ,@AncCol_Head58 ,@AncCol_Head59 ,
					@AncCol_Head60 ,@AncCol_Head61 ,@AncCol_Head62 ,@AncCol_Head63 ,@AncCol_Head64 ,@AncCol_Head65 ,@AncCol_Head66 ,@AncCol_Head67 ,@AncCol_Head68 ,@AncCol_Head69 ,
					@AncCol_Head70 ,@AncCol_Head71 ,@AncCol_Head72 ,@AncCol_Head73 ,@AncCol_Head74 ,@AncCol_Head75 ,@AncCol_Head76 ,@AncCol_Head77 ,@AncCol_Head78 ,@AncCol_Head79 ,
					@AncCol_Head80 ,@AncCol_Head81 
				) X  
				ORDER BY Sorter
			END
			ELSE
			BEGIN
				SELECT 
					[Acq_Deal_Right_Code], [PA_Right_Type],
					 [Agreement_No] ,
					 [Title Type], [Deal Description], [Reference No], [Deal Type]
					 , [Agreement Date], [Status], [Party], [Program], [Title], [Director]
					 , [Star Cast],[Genre], [Title Language], [Release Year], [Platform], [Rights Start Date], [Rights End Date], [Tentative], [Pushback], [Term], [Region], [Exclusive], [Title Language Right],
					 [Subtitling], [Dubbing], [Sub Licensing], [ROFR], [Restriction Remark], [Rights Holdback Platform], [Rights Holdback Remarks], [Blackout], [Rights Remarks],
					 [Reverse Holdback Platform], [Reverse Holdback Start Date], [Reverse Holdback End Date], [Reverse Holdback Tentative], [Reverse Holdback Term], [Reverse Holdback Country],
					 [Reverse Holdback Remarks], [General Remark], [Payment terms & Conditions], [Workflow status], [Run Type], [Attachment], [Self Utilization Group], [Self Utilization Remarks], [Due Diligence],[Right Status],[TC_QC],[Is_Under_Production],[Business_Unit_Name]
					 ,[Col_Head51],[Col_Head52],[Col_Head53],[Col_Head54],[Col_Head55],[Col_Head56],[Col_Head57],[Col_Head58],[Col_Head59],[Col_Head60],
					[Col_Head61],[Col_Head62],[Col_Head63],[Col_Head64],[Col_Head65],[Col_Head66],[Col_Head67]
				FROM (
				SELECT
					sorter = 1,  
					CAST(Acq_Deal_Right_Code AS VARCHAR(100)) AS [Acq_Deal_Right_Code],
					CAST(PA_Right_Type AS VARCHAR(100))  AS [PA_Right_Type],
					CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], 
					CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No], CAST([Is_Master_Deal] AS NVARCHAR(MAX)) As [Deal Type],
					CONVERT(VARCHAR(12),[Agreement_Date],103) As [Agreement Date], CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status], CAST([Party] AS NVARCHAR(MAX)) As [Party], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
					CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(VARCHAR(12),[Rights_Start_Date],103) AS [Rights Start Date], 
					CONVERT(VARCHAR(12),[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
					CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CAST([First_Refusal_Date] AS NVARCHAR(MAX)) As [ROFR],
					CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
					CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], CONVERT(VARCHAR(12),[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(VARCHAR(12),[Pushback_End_Date],103) As [Reverse Holdback End Date],
					CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
					CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
					CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks],  CAST([Due_Diligence] AS NVARCHAR(MAX)) As [Due Diligence],CAST([Right_Status] AS NVARCHAR(MAX)) As [Right Status],CAST([TC_QC] AS NVARCHAR(MAX)) As [TC_QC],CAST([Is_Under_Production] AS NVARCHAR(MAX)) As [Is_Under_Production],
					CAST([Business_Unit_Name] AS NVARCHAR(MAX)) As [Business_Unit_Name],null as Col_Head51,null as Col_Head52,null as Col_Head53,null as Col_Head54,null AS Col_Head55,
					null Col_Head56,null as Col_Head57,null as Col_Head58,null as Col_Head59,null as Col_Head60,null as Col_Head61,null as Col_Head62,null as Col_Head63,null as Col_Head64,
					null as Col_Head65,null Col_Head66,null as Col_Head67
				From #TempAcqDealListReport TADLR  WHERE	PA_Right_Type IN('PR')
				UNION ALL
				SELECT
					sorter = 1,  
					CAST(Acq_Deal_Right_Code AS VARCHAR(100)) AS [Acq_Deal_Right_Code],
					CAST(PA_Right_Type AS VARCHAR(100))  AS [PA_Right_Type],
					CAST(Agreement_No AS VARCHAR(100))  AS [Agreement_No], 
					CAST([Deal_Type] AS NVARCHAR(MAX)) As [Title Type], CAST([Deal_Description] AS NVARCHAR(MAX)) As [Deal Description], CAST([Reference_No] AS NVARCHAR(MAX)) As [Reference No], CAST([Is_Master_Deal] AS NVARCHAR(MAX)) As [Deal Type],
					CONVERT(VARCHAR(12),[Agreement_Date],103) As [Agreement Date], CAST([Deal_Tag_Description] AS NVARCHAR(MAX)) AS [Status], CAST([Party] AS NVARCHAR(MAX)) As [Party], CAST([Program_Name] AS NVARCHAR(MAX)) As [Program], CAST([Title_Name] AS NVARCHAR(MAX)) As [Title], CAST([Director] AS NVARCHAR(MAX)) As [Director],
					CAST([Star_Cast] AS NVARCHAR(MAX)) As [Star Cast], CAST([Genre] AS NVARCHAR(MAX)) As [Genre], CAST([Title_Language] AS NVARCHAR(MAX)) As [Title Language], CAST([Year_Of_Production] AS varchar(Max))As [Release Year], CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform], CONVERT(VARCHAR(12),[Rights_Start_Date],103) AS [Rights Start Date], 
					CONVERT(VARCHAR(12),[Rights_End_Date],103)  As [Rights End Date], CAST([Is_Tentative] AS NVARCHAR(MAX)) As [Tentative], CAST([Is_PushBack] AS NVARCHAR(MAX)) As [Pushback], CAST([Term] AS NVARCHAR(MAX)) As [Term], CAST([Country_Territory_Name] AS NVARCHAR(MAX)) As [Region], CAST([Is_Exclusive] AS NVARCHAR(MAX)) As [Exclusive], 
					CAST([Is_Title_Language_Right] AS NVARCHAR(MAX)) As [Title Language Right], CAST([Subtitling] AS NVARCHAR(MAX)) As [Subtitling], CAST([Dubbing] AS NVARCHAR(MAX)) As [Dubbing], CAST([Sub_Licencing] AS NVARCHAR(MAX)) As [Sub Licensing], CAST([First_Refusal_Date] AS NVARCHAR(MAX)) As [ROFR],
					CAST([Restriction_Remarks] AS NVARCHAR(MAX)) AS [Restriction Remark], CAST([Holdback_Platform] AS NVARCHAR(MAX)) AS [Rights Holdback Platform], CAST([Holdback_Rights] AS NVARCHAR(MAX)) As [Rights Holdback Remarks],CAST([Blackout] AS NVARCHAR(MAX)) As [Blackout],
					CAST([Rights_Remarks] AS NVARCHAR(MAX)) As [Rights Remarks], CAST([Pushback_Platform_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Platform], CONVERT(VARCHAR(12),[Pushback_Start_Date],103) As [Reverse Holdback Start Date], CONVERT(VARCHAR(12),[Pushback_End_Date],103) As [Reverse Holdback End Date],
					CAST([Pushback_Is_Tentative] AS NVARCHAR(MAX)) AS [Reverse Holdback Tentative], CAST([Pushback_Term] AS NVARCHAR(MAX)) As [Reverse Holdback Term], CAST([Pushback_Country_Name] AS NVARCHAR(MAX)) As [Reverse Holdback Country], CAST([Pushback_Remark] AS NVARCHAR(MAX)) As [Reverse Holdback Remarks],
					CAST([General_Remark] AS NVARCHAR(MAX)) As [General Remark], CAST([Payment_Remarks] AS NVARCHAR(MAX)) As [Payment terms & Conditions], CAST([Deal_Workflow_Status] AS NVARCHAR(MAX))  As [Workflow status], CAST([Run_Type] AS NVARCHAR(MAX)) As [Run Type], CAST([Is_Attachment] AS NVARCHAR(MAX)) As [Attachment],
					CAST([Promoter_Group_Name] AS NVARCHAR(MAX)) As[Self Utilization Group], CAST([Promoter_Remarks_Name] AS NVARCHAR(MAX)) As [Self Utilization Remarks],  CAST([Due_Diligence] AS NVARCHAR(MAX)) As [Due Diligence],CAST([Right_Status] AS NVARCHAR(MAX)) As [Right Status],CAST([TC_QC] AS NVARCHAR(MAX)) As [TC_QC],CAST([Is_Under_Production] AS NVARCHAR(MAX)) As [Is_Under_Production],
					CAST([Business_Unit_Name] AS NVARCHAR(MAX)) As [Business_Unit_Name],AD.Col_Head51,AD.Col_Head52,AD.Col_Head53,AD.Col_Head54,AD.Col_Head55,AD.Col_Head56,AD.Col_Head57,AD.Col_Head58,AD.Col_Head59,AD.Col_Head60,
					AD.Col_Head61,AD.Col_Head62,AD.Col_Head63,AD.Col_Head64,AD.Col_Head65,AD.Col_Head66,AD.Col_Head67
				From #TempAcqDealListReport TADLR  
				LEFT JOIN #AncData AD ON TADLR.Acq_Deal_Right_Code = AD.Acq_Deal_Rights_Code
				WHERE	PA_Right_Type IN('AR')
				UNION ALL
					SELECT CAST(0 AS Varchar(100)),
					@Col_Head01, 
					@Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11
					, @Col_Head12, @Col_Head13, @Col_Head14, @Col_Head15,  @Col_Head16, @Col_Head17, @Col_Head18, @Col_Head19, @Col_Head20, @Col_Head21, @Col_Head22, @Col_Head23, @Col_Head24, @Col_Head25, @Col_Head26
					, @Col_Head27, @Col_Head28, @Col_Head29, @Col_Head30, @Col_Head31, @Col_Head32, @Col_Head33, @Col_Head34, @Col_Head35, @Col_Head36, @Col_Head37, @Col_Head38, @Col_Head39, @Col_Head40
					, @Col_Head41, @Col_Head42, @Col_Head43, @Col_Head44, @Col_Head45, @Col_Head46, @Col_Head47,@Col_Head48,@Col_Head49,@Col_Head50,@Col_Head51,@Col_Head52,@Col_Head53, @Col_Head54,@AncCol_Head1,@AncCol_Head2,
					@AncCol_Head3,@AncCol_Head4,@AncCol_Head5,@AncCol_Head6,@AncCol_Head7,@AncCol_Head8,@AncCol_Head9,@AncCol_Head10,@AncCol_Head11,@AncCol_Head12,@AncCol_Head13,@AncCol_Head14,@AncCol_Head15,@AncCol_Head16,@AncCol_Head17
				) X  
				ORDER BY Sorter
			END

				DROP TABLE #AncData
		END
		ELSE 
		BEGIN
			SELECT * FROM #TempAcqDealListReport
		END

		
	END