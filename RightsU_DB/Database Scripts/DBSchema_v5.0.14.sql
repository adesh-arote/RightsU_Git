PRINT N'Dropping [dbo].[FK_Supplementary_Config_Supplementary]...';


GO
ALTER TABLE [dbo].[Supplementary_Config] DROP CONSTRAINT [FK_Supplementary_Config_Supplementary];


GO
PRINT N'Dropping [dbo].[FK_Supplementary_Config_Supplementary_Tab]...';


GO
ALTER TABLE [dbo].[Supplementary_Config] DROP CONSTRAINT [FK_Supplementary_Config_Supplementary_Tab];


GO
PRINT N'Dropping [dbo].[CueSheetSongsUDT]...';


GO
DROP TYPE [dbo].[CueSheetSongsUDT];


GO
PRINT N'Creating [dbo].[CueSheetSongsUDT]...';


GO
CREATE TYPE [dbo].[CueSheetSongsUDT] AS TABLE (
    [SrNo]           NVARCHAR (100) NULL,
    [Show Name]      NVARCHAR (100) NULL,
    [Episode]        NVARCHAR (10)  NULL,
    [Music Track]    NVARCHAR (100) NULL,
    [Movie/Album]    NVARCHAR (100) NULL,
    [Usage Type]     NVARCHAR (100) NULL,
    [TC IN]          NVARCHAR (100) NULL,
    [TC IN Frame]    NVARCHAR (100) NULL,
    [TC OUT]         NVARCHAR (100) NULL,
    [TC OUT Frame]   NVARCHAR (50)  NULL,
    [Duration]       NVARCHAR (100) NULL,
    [Duration Frame] NVARCHAR (100) NULL);


GO
PRINT N'Altering [dbo].[Report_Column_Setup_IT]...';


GO
ALTER TABLE [dbo].[Report_Column_Setup_IT] ALTER COLUMN [Alternate_Config_Code] NVARCHAR (50) NULL;

ALTER TABLE [dbo].[Report_Column_Setup_IT] ALTER COLUMN [Max_Length] NVARCHAR (50) NULL;


GO
PRINT N'Starting rebuilding table [dbo].[Supplementary]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Supplementary] (
    [Supplementary_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Supplementary_Name] NVARCHAR (200) NULL,
    [Is_Active]          CHAR (1)       NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Supplementary1] PRIMARY KEY CLUSTERED ([Supplementary_Code] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Supplementary])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Supplementary] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Supplementary] ([Supplementary_Code], [Supplementary_Name], [Is_Active])
        SELECT   [Supplementary_Code],
                 [Supplementary_Name],
                 [Is_Active]
        FROM     [dbo].[Supplementary]
        ORDER BY [Supplementary_Code] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Supplementary] OFF;
    END

DROP TABLE [dbo].[Supplementary];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Supplementary]', N'Supplementary';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Supplementary1]', N'PK_Supplementary', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[Supplementary_Config]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Supplementary_Config] (
    [Supplementary_Config_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Supplementary_Code]        INT             NULL,
    [Supplementary_Tab_Code]    INT             NULL,
    [Page_Group]                NVARCHAR (50)   NULL,
    [Label_Name]                NVARCHAR (200)  NULL,
    [Control_Type]              NVARCHAR (50)   NULL,
    [Is_Mandatory]              CHAR (1)        NULL,
    [Is_Multiselect]            CHAR (1)        NULL,
    [Max_Length]                INT             NULL,
    [Page_Control_Order]        INT             NULL,
    [Control_Field_Order]       INT             NULL,
    [Default_Values]            NVARCHAR (1000) NULL,
    [View_Name]                 VARCHAR (100)   NULL,
    [Text_Field]                VARCHAR (100)   NULL,
    [Value_Field]               VARCHAR (100)   NULL,
    [Whr_Criteria]              VARCHAR (100)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Supplementary_Config1] PRIMARY KEY CLUSTERED ([Supplementary_Config_Code] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Supplementary_Config])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Supplementary_Config] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Supplementary_Config] ([Supplementary_Config_Code], [Supplementary_Code], [Supplementary_Tab_Code], [Page_Group], [Label_Name], [Control_Type], [Is_Mandatory], [Is_Multiselect], [Max_Length], [Page_Control_Order], [Control_Field_Order], [Default_Values], [View_Name], [Text_Field], [Value_Field], [Whr_Criteria])
        SELECT   [Supplementary_Config_Code],
                 [Supplementary_Code],
                 [Supplementary_Tab_Code],
                 [Page_Group],
                 [Label_Name],
                 [Control_Type],
                 [Is_Mandatory],
                 [Is_Multiselect],
                 [Max_Length],
                 [Page_Control_Order],
                 [Control_Field_Order],
                 [Default_Values],
                 [View_Name],
                 [Text_Field],
                 [Value_Field],
                 [Whr_Criteria]
        FROM     [dbo].[Supplementary_Config]
        ORDER BY [Supplementary_Config_Code] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Supplementary_Config] OFF;
    END

DROP TABLE [dbo].[Supplementary_Config];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Supplementary_Config]', N'Supplementary_Config';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Supplementary_Config1]', N'PK_Supplementary_Config', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[Supplementary_Tab]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Supplementary_Tab] (
    [Supplementary_Tab_Code]        INT            IDENTITY (1, 1) NOT NULL,
    [Short_Name]                    NVARCHAR (20)  NULL,
    [Supplementary_Tab_Description] NVARCHAR (100) NULL,
    [Order_No]                      INT            NULL,
    [Tab_Type]                      VARCHAR (2)    NULL,
    [EditWindowType]                VARCHAR (10)   NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Supplementary_Tab1] PRIMARY KEY CLUSTERED ([Supplementary_Tab_Code] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Supplementary_Tab])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Supplementary_Tab] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Supplementary_Tab] ([Supplementary_Tab_Code], [Short_Name], [Supplementary_Tab_Description], [Order_No], [Tab_Type])
        SELECT   [Supplementary_Tab_Code],
                 [Short_Name],
                 [Supplementary_Tab_Description],
                 [Order_No],
                 [Tab_Type]
        FROM     [dbo].[Supplementary_Tab]
        ORDER BY [Supplementary_Tab_Code] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Supplementary_Tab] OFF;
    END

DROP TABLE [dbo].[Supplementary_Tab];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Supplementary_Tab]', N'Supplementary_Tab';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Supplementary_Tab1]', N'PK_Supplementary_Tab', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[Acq_Deal_Supplementary]...';


GO
CREATE TABLE [dbo].[Acq_Deal_Supplementary] (
    [Acq_Deal_Supplementary_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]               INT           NULL,
    [Title_code]                  INT           NULL,
    [Episode_From]                INT           NULL,
    [Episode_To]                  INT           NULL,
    [Remarks]                     VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Acq_Deal_Supplementary] PRIMARY KEY CLUSTERED ([Acq_Deal_Supplementary_Code] ASC)
);


GO
PRINT N'Creating [dbo].[Acq_Deal_Supplementary_detail]...';


GO
CREATE TABLE [dbo].[Acq_Deal_Supplementary_detail] (
    [Acq_Deal_Supplementary_Detail_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Supplementary_Code]        INT            NULL,
    [Supplementary_Tab_Code]             INT            NULL,
    [Supplementary_Config_Code]          INT            NULL,
    [Supplementary_Data_Code]            VARCHAR (1000) NULL,
    [User_Value]                         VARCHAR (MAX)  NULL,
    [Row_Num]                            INT            NULL,
    CONSTRAINT [PK_Acq_Deal_Supplementary_detail] PRIMARY KEY CLUSTERED ([Acq_Deal_Supplementary_Detail_Code] ASC)
);


GO
PRINT N'Creating [dbo].[FK_Supplementary_Config_Supplementary]...';


GO
ALTER TABLE [dbo].[Supplementary_Config] WITH NOCHECK
    ADD CONSTRAINT [FK_Supplementary_Config_Supplementary] FOREIGN KEY ([Supplementary_Code]) REFERENCES [dbo].[Supplementary] ([Supplementary_Code]);


GO
PRINT N'Creating [dbo].[FK_Supplementary_Config_Supplementary_Tab]...';


GO
ALTER TABLE [dbo].[Supplementary_Config] WITH NOCHECK
    ADD CONSTRAINT [FK_Supplementary_Config_Supplementary_Tab] FOREIGN KEY ([Supplementary_Tab_Code]) REFERENCES [dbo].[Supplementary_Tab] ([Supplementary_Tab_Code]);


GO
PRINT N'Creating [dbo].[FK_Acq_Deal_Supplementary_detail_Acq_Deal_Supplementary]...';


GO
ALTER TABLE [dbo].[Acq_Deal_Supplementary_detail] WITH NOCHECK
    ADD CONSTRAINT [FK_Acq_Deal_Supplementary_detail_Acq_Deal_Supplementary] FOREIGN KEY ([Acq_Deal_Supplementary_Code]) REFERENCES [dbo].[Acq_Deal_Supplementary] ([Acq_Deal_Supplementary_Code]);


GO
PRINT N'Altering [dbo].[System_Parameter_New]...';


GO
ALTER VIEW [dbo].[System_Parameter_New]
AS
SELECT Id ,Parameter_Name ,Parameter_Value ,Inserted_On,Inserted_By ,Lock_Time ,Last_Updated_Time ,Last_Action_By ,Channel_Code ,[Type] ,IsActive ,[Description] ,IS_System_Admin ,Client_Name
FROM System_Parameter
WHERE Client_Name = (SELECT TOP 1 Parameter_Value FROM System_Parameter WHERE Parameter_Name = 'Client_Name' AND Client_Name = 'VMP')
GO
PRINT N'Creating [dbo].[UFN_GetTitleName_Syn]...';


GO

CREATE FUNCTION [dbo].[UFN_GetTitleName_Syn]
(	
	@Acq_DealAncillary_Code INT,
	@Title_Codes VARCHAR(MAX),
	@Deal_Type VARCHAR(30)
)
RETURNS NVARCHAR(MAX)       
AS      
BEGIN       	
	DECLARE @TitleName NVARCHAR(MAX)
	SET @TitleName=''

	SELECT @TitleName = Stuff ((
		SELECT DISTINCT ', '+  Title_Name FROM	(
			SELECT	dbo.UFN_GetTitleNameInFormat(@Deal_Type, ISNULL(T.Title_Name,''), ADAT.Episode_From, ADAT.Episode_To) AS Title_Name
			FROM Title T 
			INNER JOIN Syn_Deal_Ancillary_Title ADAT ON ADAT.Title_Code = T.Title_Code AND ADAT.Syn_Deal_Ancillary_Code = @Acq_DealAncillary_Code
			WHERE 1= 1 AND (
				ISNULL(@Title_Codes,'')<>'' AND ADAT.Title_Code IN (Select Number FROM fn_Split_withdelemiter(@Title_Codes,',')) OR 
				ISNULL(@Title_Codes,'')=''
			)			
		) AS temp FOR XML PATH('')), 1, 1, '')
	SELECT @TitleName = REPLACE(@TitleName, '&amp;', '&')
	RETURN @TitleName
END
GO
PRINT N'Altering [dbo].[USP_Acq_Deal_Rights_Holdback_Release]...';


GO
ALTER PROCEDURE [dbo].[USP_Acq_Deal_Rights_Holdback_Release]
(
	@AcqDealRightHoldbackCode varchar(100)
)
AS
	BEGIN
	  Declare @Loglavel int;
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Deal_Rights_Holdback_Release]', 'Step 1', 0, 'Started Procedure', 0, ''
	SELECT DISTINCT T.Title_Name As Title, P.Platform_Name As Platform, cou.Country_Name As Region,
	REPLACE(CONVERT(CHAR(11), TR.Release_Date, 106),' ','-') AS Release_Date, REPLACE(CONVERT(Char(11),
	 CASE 
	 WHEN ADRH.HB_Run_After_Release_Units = 1 THEN DATEADD(DAY,ADRH.HB_Run_After_Release_No,Tr.Release_Date) 
	  WHEN ADRH.HB_Run_After_Release_Units = 2 THEN DATEADD(WEEK,ADRH.HB_Run_After_Release_No,Tr.Release_Date) 
	   WHEN ADRH.HB_Run_After_Release_Units = 3 THEN DATEADD(MONTH,ADRH.HB_Run_After_Release_No,Tr.Release_Date)
	   ELSE   DATEADD(YEAR,ADRH.HB_Run_After_Release_No,Tr.Release_Date)
	 enD,106),' ','-')
	  As  Holdback_Release_Date
	from Acq_Deal_Rights_Holdback ADRH 
	INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADRH.Acq_Deal_Rights_Code
	INNER JOIN Title_Release TR ON TR.Title_Code = ADRT.Title_Code
	INNER JOIN Title_Release_Platforms TRP ON TRP.Platform_Code = ADRH.Holdback_On_Platform_Code AND Tr.Title_Release_Code = TRP.Title_Release_Code
	INNER JOIN Title_Release_Region TRR ON TRR.Title_Release_Code = TR.Title_Release_Code
	INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT ON  ADRHT.Acq_Deal_Rights_Holdback_Code = ADRH.Acq_Deal_Rights_Holdback_Code 
	INNER JOIN Country cou on cou.Country_Code = ADRHT.Country_Code
	INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code
	INNER JOIN Platform P ON P.Platform_Code = ADRH.Holdback_On_Platform_Code
	where ADRH.Acq_Deal_Rights_Holdback_Code = @AcqDealRightHoldbackCode AND ADRH.Holdback_Type = 'R' 
	and ((TR.Release_Type = 'C'  AND ADRHT.Country_Code in (TRR.Country_Code)) OR 
	((Tr.Release_Type = 'T' OR Tr.Release_Type = 'W') AND ADRHT.Country_Code in (SELECT td.Country_Code FROm Territory_Details td where td.Territory_Code in (trr.Territory_Code))
	))
	
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Deal_Rights_Holdback_Release]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
	END
GO
PRINT N'Altering [dbo].[USP_BV_Title_Mapping_Shows]...';


GO
ALTER PROCEDURE [dbo].[USP_BV_Title_Mapping_Shows]
	@BV_HouseID_Data_Code VARCHAR(500)
AS
BEGIN
Declare @Loglavel int;
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_BV_Title_Mapping_Shows]', 'Step 1', 0, 'Started Procedure', 0, ''
	CREATE TABLE #TempBv(
		bv_Title VARCHAR(1000),
		Title_Content_Code INT,
		Title_Code INT
	)

	INSERT INTO #TempBv(bv_Title, Title_Content_Code, Title_Code)
	SELECT BV_Title, Title_Content_Code, Title_Code FROM BV_HouseId_Data
	WHERE BV_HouseId_Data_Code IN (SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@BV_HouseID_Data_Code, ',') WHERE NUMBER <> '')

	SELECT DISTINCT(B.BV_HouseId_Data_Code), TC.Title_Content_Code, TC.Title_Code, B.Program_Episode_ID
	INTO #TEMP_BVDATA
	FROM BV_HouseId_Data B
	INNER JOIN Title_Content TC ON RIGHT('0000' + CAST(TC.Episode_No AS VARCHAR(10)), 4) = RIGHT('0000' + CAST(B.Episode_No AS VARCHAR(10)), 4)
	INNER JOIN #TempBv tmpBV ON TC.Title_Code = tmpBV.Title_Code
	AND B.BV_Title COLLATE SQL_Latin1_General_CP1_CI_AS = tmpBV.bv_Title COLLATE SQL_Latin1_General_CP1_CI_AS
	WHERE B.Is_Mapped = 'N'

	UPDATE TC
	SET TC.Ref_BMS_Content_Code = TB.Program_Episode_ID
	FROM Title_Content TC
	INNER JOIN #TEMP_BVDATA TB ON TB.Title_Content_Code = TC.Title_Content_Code

	UPDATE B
	SET B.Title_Code = TB.Title_Code, B.Title_Content_Code = TB.Title_Content_Code, B.Is_Mapped = 'Y'
	FROM BV_HouseId_Data B
	INNER JOIN #TEMP_BVDATA TB ON TB.BV_HouseId_Data_Code = B.BV_HouseId_Data_Code
	WHERE B.Is_Mapped = 'N'

	IF OBJECT_ID('tempdb..#TEMP_BVDATA') IS NOT NULL DROP TABLE #TEMP_BVDATA
	IF OBJECT_ID('tempdb..#TempBv') IS NOT NULL DROP TABLE #TempBv

if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_BV_Title_Mapping_Shows]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO
PRINT N'Altering [dbo].[USP_GetContentsMusicData]...';


GO
ALTER PROC [dbo].[USP_GetContentsMusicData]  
(  
	@Title_Content_Code BIGINT
)  
AS  
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create date: 11 January 2017
-- Description:	Get Content Music data
-- =============================================
BEGIN  
Declare @Loglavel int
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsMusicData]', 'Step 1', 0, 'Started Procedure', 0, ''
	SELECT MT.Music_Title_Name, COALESCE(MA.Music_Album_Name, MT.Movie_Album, '') AS Movie_Album, ML.Music_Label_Name, V.Version_Name [Version], V.Version_Code, 
	CONVERT(VARCHAR,CML.[From],108) + ':' +  RIGHT('00' + CAST(ISNULL(CML.From_Frame, 0) AS VARCHAR), 2) [From],  
	CONVERT(VARCHAR,CML.[To],108) + ':' + RIGHT('00' + CAST(ISNULL(CML.To_Frame, 0) as VARCHAR), 2) [To],  
	CONVERT(VARCHAR,CML.[Duration],108) + ':' +RIGHT('00' +  CAST(ISNULL(CML.Duration_Frame, 0) as VARCHAR), 2) [Duration]
	FROM Title_Content TC
	INNER JOIN Content_Music_Link CML ON CML.Title_Content_Code = TC.Title_Content_Code
	INNER JOIN Title_Content_Version TCV ON TCV.Title_Content_Version_Code = CML.Title_Content_Version_Code
	INNER JOIN [Version] V ON V.Version_Code = TCV.Version_Code
	INNER JOIN Music_Title MT ON MT.Music_Title_Code = CML.Music_Title_Code
	INNER JOIN Music_Title_Label MTL ON MT.Music_Title_Code = MTL.Music_Title_Code  
		AND MTL.Effective_To IS NULL
	INNER JOIN Music_Label ML ON MTL.Music_Label_Code = ML.Music_Label_Code  
	LEFT JOIN Music_Type MTY ON MTY.Music_Type_Code = MT.Music_Type_Code  
	LEFT JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code
	WHERE TC.Title_Content_Code = @Title_Content_Code
	 
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsMusicData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO
PRINT N'Altering [dbo].[USP_GetContentsRightData]...';


GO
ALTER PROC [dbo].[USP_GetContentsRightData]
(
	@Title_Content_Code BIGINT
)
As
/*==============================================
Author:			Abhaysingh N. Rajpurohit
Create date:	11 Jan 2017
Description:	Get Content Deal data
===============================================*/

BEGIN
Declare @Loglavel int
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsRightData]', 'Step 1', 0, 'Started Procedure', 0, ''
	DECLARE   @Title_Code INT
	IF(OBJECT_ID('TEMPDB..#PlatformForRun') IS NOT NULL)
		DROP TABLE #PlatformForRun

	IF(OBJECT_ID('TEMPDB..#TempRun') IS NOT NULL)
		DROP TABLE #TempRun

	SELECT Platform_Code INTO #PlatformForRun FROM [Platform] WHERE ISNULL(Is_No_Of_Run, 'N') = 'Y'
	SELECT Acq_Deal_Code,Runs_Type_Desc,Yearwise_Definition,Scheduled_Run,Channel_Names,Deal_Type INTO #TempRun
	 From(
	SELECT ADR.Acq_Deal_Code,
	CASE 
		WHEN ADR.Run_Type = 'U' THEN 'Unlimited' 
		ELSE 'Limited' + '(' + CAST(ADR.No_Of_Runs AS VARCHAR) + ')' 
	END AS Runs_Type_Desc,
	CASE 
		WHEN ADR.Is_Yearwise_Definition = 'Y' THEN 'Yes' 
		ELSE 'No' 
	END [Yearwise_Definition],
	ADR.No_Of_Runs_Sched AS Scheduled_Run,
	STUFF((
		SELECT  DISTINCT ',' + C.Channel_Name
        FROM Acq_Deal_Run_Channel ADRC
		INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code	
        WHERE  ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
        FOR XML PATH('')
	), 1, 1, '') AS Channel_Names,
	'A' AS Deal_Type
	FROM Title_Content TC
	INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Title_Code = TC.Title_Code AND TC.Episode_No BETWEEN ADRT.Episode_From AND ADRT.Episode_To
	INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code
	WHERE TC.Title_Content_Code = @Title_Content_Code
	UNION
	SELECT PDT.Provisional_Deal_Code,
	CASE 
		WHEN PDR.Run_Type = 'U' THEN 'Unlimited' 
		ELSE 'Limited' + '(' + CAST(PDR.No_Of_Runs AS VARCHAR) + ')' 
	END AS Runs_Type_Desc,
	CASE 
		WHEN PDR.Run_Type = 'U' THEN 'Unlimited' 
		ELSE 'Limited' + '(' + CAST(PDR.No_Of_Runs AS VARCHAR) + ')' 
	END AS [Yearwise_Definition],
	PDR.No_Of_Runs AS Scheduled_Run,
	STUFF((
		SELECT  DISTINCT ',' + C.Channel_Name
        FROM Provisional_Deal_Run_Channel PDRC
		INNER JOIN Channel C ON C.Channel_Code = PDRC.Channel_Code	
        WHERE  PDRC.Provisional_Deal_Run_Code = PDR.Provisional_Deal_Run_Code
        FOR XML PATH('')
	), 1, 1, '') AS Channel_Names,
	'P' AS Deal_Type
	FROM Title_Content TC
	INNER JOIN Provisional_Deal_Title PDT ON PDT.Title_Code = TC.Title_Code AND TC.Episode_No BETWEEN PDT.Episode_From AND PDT.Episode_To
	INNER JOIN Provisional_Deal_Run PDR ON PDR.Provisional_Deal_Title_Code = PDT.Provisional_Deal_Title_Code
	WHERE TC.Title_Content_Code = @Title_Content_Code
	) B
	
	IF NOT EXISTS(SELECT TOP 1 * FROM #TempRun)
	BEGIN

		INSERT INTO #TempRun(Acq_Deal_Code, Deal_Type)
		SELECT DISTINCT adm.Acq_Deal_Code, 'A' FROM Title_Content_Mapping tcm
		INNER JOIN Acq_Deal_Movie adm ON tcm.Acq_Deal_Movie_Code = adm.Acq_Deal_Movie_Code
		WHERE tcm.Title_Content_Code = @Title_Content_Code

	END

	--Select @Title_Code = Title_Code From Title_Content where Title_Content_Code = @Title_Content_Code
	--Print @Title_Code
	--IF EXISTS(Select Title_Code From Acq_Deal_Movie where Title_Code = @Title_Code)
	--BEGIN
	SELECT DISTINCT AD.Agreement_No, AD.Deal_Desc, AD.Agreement_Date, V.Vendor_Name AS Licensor,
	CASE 
		WHEN A.Right_Type != 'U' THEN REPLACE(CONVERT(VARCHAR(11),A.Actual_Right_Start_Date,106), ' ', '-') + ' To ' + 
			REPLACE(Convert(VARCHAR(11),A.Actual_Right_End_Date,106), ' ', '-')
		WHEN Right_Type = 'U' THEN 'Perpetuity From ' + REPLACE(Convert(VARCHAR(11),A.Actual_Right_Start_Date,106), ' ', '-')
	END AS Rights_Period,
	ISNULL(RUN.Runs_Type_Desc, 'NA') AS Runs_Type_Desc,
	ISNULL(RUN.Scheduled_Run, 0) AS Scheduled_Run,
	ISNULL(RUN.Yearwise_Definition, 'NA') AS Yearwise_Definition,
	ISNULL(RUN.Channel_Names, 'NA') AS Channel_Names
	FROM Title_Content TC 
	INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Movie_Code = TCM.Acq_Deal_Movie_Code 
	INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	LEFT JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
	INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
	LEFT JOIN 
	(
		SELECT ADR.Acq_Deal_Code, ADRC.Title_Code, ADRC.Episode_From , ADRC.Episode_To, Adr.Actual_Right_Start_Date , 
		Adr.Actual_Right_End_Date, adr.Right_Type FROM 
		Acq_Deal_Rights_Title ADRC 
		INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = ADRC.Acq_Deal_Rights_Code 
		INNER JOIN Acq_Deal_Rights_Platform ADRP ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code 
			AND ADRP.Platform_Code IN (SELECT Platform_Code FROM #PlatformForRun)
	) AS A ON A.Title_Code = TC.Title_Code AND TC.Episode_No BETWEEN A.Episode_From AND A.Episode_To
	AND A.Acq_Deal_Code = Ad.Acq_Deal_Code
	LEFT  JOIN #TempRun RUN ON RUN.Acq_Deal_Code = A.Acq_Deal_Code AND RUN.Deal_Type = 'A'
	WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND TC.Title_Content_Code = @Title_Content_Code
	--END
	UNION
	SELECT DISTINCT PD.Agreement_No, PD.Deal_Desc, PD.Agreement_Date, V.Vendor_Name AS Licensor,
	REPLACE(CONVERT(VARCHAR(11),PDRC.Right_Start_Date,106), ' ', '-') + ' To ' + 
			REPLACE(Convert(VARCHAR(11),PDRC.Right_End_Date,106), ' ', '-')	AS Rights_Period,
	RUN.Runs_Type_Desc,
	RUN.Scheduled_Run,
	RUN.Yearwise_Definition,
	RUN.Channel_Names
	FROM  #TempRun RUN,Title_Content TC 
	INNER JOIN Title_Content_Mapping TCM ON TCM.Title_Content_Code = TC.Title_Content_Code
	INNER JOIN Provisional_Deal_Title PDT ON PDT.Provisional_Deal_Title_Code = TCM.Provisional_Deal_Title_Code 
	INNER JOIN Provisional_Deal PD ON PD.Provisional_Deal_Code = PDT.Provisional_Deal_Code
	INNER JOIN Provisional_Deal_Licensor PDL ON PD.Provisional_Deal_Code = PDL.Provisional_Deal_Code
	INNER JOIN Provisional_Deal_Run PDR ON PDR.Provisional_Deal_Title_Code = PDT.Provisional_Deal_Title_Code
	INNER JOIN Provisional_Deal_Run_Channel PDRC ON PDRC.Provisional_Deal_Run_Code = PDR.Provisional_Deal_Run_Code
	INNER JOIN Vendor V ON V.Vendor_Code = PDL.Vendor_Code
	WHERE TC.Title_Content_Code = @Title_Content_Code AND RUN.Deal_Type = 'P' 

	IF OBJECT_ID('tempdb..#PlatformForRun') IS NOT NULL DROP TABLE #PlatformForRun
	IF OBJECT_ID('tempdb..#TempRun') IS NOT NULL DROP TABLE #TempRun
	 
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_GetContentsRightData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO
PRINT N'Altering [dbo].[usp_GetUserEMail_Body]...';


GO





ALTER PROCEDURE [dbo].[usp_GetUserEMail_Body]         
   @User_Name NVARCHAR(100)
   ,@First_Name NVARCHAR(100)
   ,@Last_Name NVARCHAR(100)          
 , @Pass_Word varchar(100)        
 , @IsLDAP_Required varchar(20)        
 , @Site_Address NVARCHAR(200)       
 , @System_Name NVARCHAR(100)      
 , @Status varchar(200)      
 ,@cur_email_id  NVARCHAR(250)
AS        
BEGIN        
 -- SET NOCOUNT ON added to prevent extra result sets from        
 -- interfering with SELECT statements.        
 SET NOCOUNT ON;        
          
BEGIN    
Declare @Loglavel int
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[usp_GetUserEMail_Body]', 'Step 1', 0, 'Started Procedure', 0, '' 
--DECLARE
--   @User_Name NVARCHAR(100) = 'stefan'
-- , @First_Name NVARCHAR(100)  = 'stefan'
-- , @Last_Name NVARCHAR(100)  = 'Gaikwad'         
-- , @Pass_Word varchar(100)  = 's12345'       
-- , @IsLDAP_Required varchar(20)='N'        
-- , @Site_Address NVARCHAR(200)    ='http://192.168.0.114/RIGHTSU_Plus/'   
-- , @System_Name NVARCHAR(100)    ='U-To'  
-- , @Status varchar(200) ='NP'
-- , @cur_email_id  NVARCHAR(250) = 'stefan@uto.in'

    DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT  
	DECLARE @Email_Config_Code INT
    DECLARE @body  NVARCHAR(MAX)  SET @body  = ''       
    DECLARE @body1 NVARCHAR(1000) SET @body1 = ''        
    DECLARE @body2 NVARCHAR(1000) SET @body2 = ''       
    DEclare @body3 NVARCHAR(1000) SET @body2 = ''           
    
	SELECT @Email_Config_Code= Email_Config_Code FROM Email_Config WHERE [Key]='UCFP'

    --//--------------- SELECT AND SET A PARTICULAR TEMPLATE ---------------//--        
          
                /* ========== PASSWORD CHANGED =============== */      
                print @Status
    IF(@Status = 'PC' )      
    BEGIN      
          
   SELECT @body1 = Template_Desc FROM Email_template WHERE Template_For='EB1'       
         
   IF (@IsLDAP_Required = 'N')      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'EB2'       
    END       
   ELSE      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'EB3'      
             
    END      
   END      
         
   SELECT @body3 = Template_Desc FROM Email_template WHERE Template_For='EB4'       
         
     END      
           
               /* ========== END PASSWORD CHANGED =============== */      
           
               /* ==========  NEW USER CREATED  =============== */      
     IF(@Status = 'NUC')      
     BEGIN        
   SELECT @body1 = Template_Desc FROM Email_template WHERE Template_For='UB1'       
      
   IF (@IsLDAP_Required = 'N')      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'UB2'       
    END       
   ELSE      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'UB3'      
             
    END      
          
   SELECT @body3 = Template_Desc FROM Email_template WHERE Template_For='UB4'       
         
     END      
             /* ==========  NEW USER CREATED  =============== */   
               
             /* ========== FORGOT PASSWORD  ================= */    
   IF(@Status = 'FP')      
   BEGIN        
   SELECT @body1 = Template_Desc FROM Email_template WHERE Template_For='FB1'       
      
   IF (@IsLDAP_Required = 'N')      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'FB2'       
    END       
   ELSE      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'FB3'      
    END      
          
   SELECT @body3 = Template_Desc FROM Email_template WHERE Template_For='FB4'       
         
  END   
  
  IF(@Status = 'NP')      
   BEGIN        
   SELECT @body1 = Template_Desc FROM Email_template WHERE Template_For='FB1'       
      
   IF (@IsLDAP_Required = 'N')      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'FB2'       
    END       
   ELSE      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'FB3'      
    END      
          
   SELECT @body3 = Template_Desc FROM Email_template WHERE Template_For='FB4'       
         
  END   
               
             /* ========== FORGOT PASSWORD  ================= */    
                   
     SELECT @body = @body1 + @body2 + @body3        
           
     --REPLACE ALL THE PARAMETER VALUE        
     SET @body = REPLACE(@body,'{username}',@User_Name)
     SET @body = REPLACE(@body,'{first_name}',@First_Name)
     SET @body = REPLACE(@body,'{last_name}',@Last_Name)
     SET @body = REPLACE(@body,'{password}',@Pass_Word)        
     SET @body = REPLACE(@body,'{isLDAPAuthReqd}',@IsLDAP_Required)        
     SET @body = REPLACE(@body,'{SiteAddress}',@Site_Address)        
     SET @body = REPLACE(@body,'{system_admin}',@System_Name)        
	 IF(@Status = 'NP')     
	   SET @body = REPLACE(@body,'{regenerated}','generated') 
	 ELSE IF(@Status = 'FP')     
		SET @body = REPLACE(@body,'{regenerated}','regenerated') 

     print @User_Name
     print @First_Name
     print @Last_Name
     print @Pass_Word
     print @IsLDAP_Required
     print @Site_Address
     print @System_Name
           
     --SELECT @body      
     
     ------------Send E-Mail----------
     declare @DefaultSiteUrl NVARCHAR(500) = ''
     DECLARE @DatabaseEmail_Profile varchar(200)	
	 --SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
	 SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'

	 declare @MailSubjectCr NVARCHAR(250) = ''
	 IF(@Status = 'FP') 
		BEGIN
		SET @MailSubjectCr = 'RightsU - New password for the system RightsU'
		END
	 ELSE IF(@Status = 'NUC') 
		BEGIN
			SET @MailSubjectCr = 'RightsU - New user created'
		END
	 ELSE IF(@Status = 'NP') 
		BEGIN
			SET @MailSubjectCr = 'RightsU - New user created'
		END
	 
	--EXEC msdb.dbo.sp_send_dbmail 
	--@profile_name = @DatabaseEmail_Profile,
	--@recipients =  @cur_email_id,
	--@subject = @MailSubjectCr,
	--@body = @body, 
	--@body_format = 'HTML'; 

	INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_User_Mail_Id, [Subject])
	SELECT @Email_Config_Code, @body, ISNULL(@cur_email_id ,''),  @MailSubjectCr


	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT
    ------Send E-Mail END     
	 
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[usp_GetUserEMail_Body]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''    
END
GO
PRINT N'Altering [dbo].[USP_List_Acq_Ancillary]...';


GO
ALTER PROCEDURE [dbo].[USP_List_Acq_Ancillary]
	@Acq_Deal_Code INT
AS
---- =============================================
---- Author:		Sagar Mahajan / Abhaysingh N. Rajpurohit
---- Create DATE: 08-October-2014
---- Description:	AcqDeal ANCIL List
---- Last Updated By : Akshay Rane
---- Updated On:  02-Mar-2018
---- =============================================
BEGIN
Declare @Loglavel int
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_List_Acq_Ancillary]', 'Step 1', 0, 'Started Procedure', 0, ''
	IF(OBJECT_ID('TEMPDB..#Temp_Medium') IS NOT NULL)    
		DROP TABLE #Temp_Medium  
	IF(OBJECT_ID('TEMPDB..#Temp_Medium_Adv') IS NOT NULL)    
		DROP TABLE #Temp_Medium_Adv 

	--DECLARE @Acq_Deal_Code INT = 25032

	DECLARE @System_Parameter_New CHAR(1) = 'N'
	SELECT @System_Parameter_New = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_Ancillary_Advanced' 

	DECLARE @Deal_Type VARCHAR(30) = '' 
	SELECT @Deal_Type =dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code) 
	FROM Acq_Deal AD WHERE AD.Acq_Deal_Code = @Acq_Deal_Code

	IF(@System_Parameter_New <> 'N')
	BEGIN

		Select ADAP.Acq_Deal_Ancillary_Code , ADAP.Platform_Code --, AM.Ancillary_Medium_Name
		INTO #Temp_Medium_Adv
		from Acq_Deal_Ancillary ADA
		LEFT Join Acq_Deal_Ancillary_Platform ADAP On ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
		WHERE ADA.Acq_Deal_Code = @Acq_Deal_Code  and ADAP.Ancillary_Platform_Code IS NULL

		SELECT DISTINCT ADA.Acq_Deal_Ancillary_Code
		, dbo.UFN_GetTitleName(ADA.Acq_Deal_Ancillary_Code,'',@Deal_Type) as TitleName
		, AT.Ancillary_Type_Code,AT.Ancillary_Type_Name
		, ADA.Duration,ADA.Day,ADA.Remarks
		, (Stuff ((
			Select Distinct ', '+ ISNULL(P.Platform_Name,'') from  #Temp_Medium_Adv TV 
			INNER JOIN [PLATFORM] P ON P.Platform_Code = TV.Platform_Code
			WHERE TV.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code 
			FOR XML PATH('')) , 1, 1, '')
		) as Platform_Name
		, '' as Ancillary_Medium_Name
		FROM Acq_Deal_Ancillary ADA 	
		INNER JOIN Ancillary_Type AT ON ADA.Ancillary_Type_code = AT.Ancillary_Type_code	
		LEFT JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Acq_Deal_Ancillary_Code=ADA.Acq_Deal_Ancillary_Code
		--Inner Join Ancillary_Platform AP ON ADAP.Ancillary_Platform_code= AP.Ancillary_Platform_code AND AT.Ancillary_Type_Code = ADA.Ancillary_Type_code
		WHERE ADA.Acq_Deal_Code = @Acq_Deal_Code and ADAP.Ancillary_Platform_Code IS NULL

	END
	ELSE
	BEGIN

		Select ADAP.Acq_Deal_Ancillary_Platform_Code, AM.Ancillary_Medium_Name
		INTO #Temp_Medium
		from Acq_Deal_Ancillary ADA
		Inner Join Acq_Deal_Ancillary_Platform ADAP On ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
		Inner Join Acq_Deal_Ancillary_Platform_Medium ADAPM ON ADAPM.Acq_Deal_Ancillary_Platform_Code = ADAP.Acq_Deal_Ancillary_Platform_Code
		Inner join Ancillary_Platform_Medium APM ON ADAPM.Ancillary_Platform_Medium_Code = APM.Ancillary_Platform_Medium_Code
		INNER JOIN Ancillary_Medium AM ON APM.Ancillary_Medium_Code = AM.Ancillary_Medium_Code 
		WHERE ADA.Acq_Deal_Code = @Acq_Deal_Code

		SELECT DISTINCT ADA.Acq_Deal_Ancillary_Code
		, dbo.UFN_GetTitleName(ADA.Acq_Deal_Ancillary_Code,'',@Deal_Type) as TitleName
		, AT.Ancillary_Type_Code,AT.Ancillary_Type_Name
		, ADA.Duration,ADA.Day,ADA.Remarks,AP.Platform_Name
		, (Stuff ((
			Select Distinct ', '+ ISNULL(TM.Ancillary_Medium_Name,'') from  #Temp_Medium TM 
			WHERE TM.Acq_Deal_Ancillary_Platform_Code = ADAP.Acq_Deal_Ancillary_Platform_Code               
			FOR XML PATH('')) , 1, 1, '')
		) as Ancillary_Medium_Name
		FROM Acq_Deal_Ancillary ADA 	
		INNER JOIN Ancillary_Type AT ON ADA.Ancillary_Type_code = AT.Ancillary_Type_code	
		INNER JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Acq_Deal_Ancillary_Code=ADA.Acq_Deal_Ancillary_Code
		Inner Join Ancillary_Platform AP ON ADAP.Ancillary_Platform_code= AP.Ancillary_Platform_code AND AT.Ancillary_Type_Code = ADA.Ancillary_Type_code
		WHERE ADA.Acq_Deal_Code = @Acq_Deal_Code

	END

	IF OBJECT_ID('tempdb..#Temp_Medium') IS NOT NULL DROP TABLE #Temp_Medium
	IF OBJECT_ID('tempdb..#Temp_Medium_Adv') IS NOT NULL DROP TABLE #Temp_Medium_Adv
 
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_List_Acq_Ancillary]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO
PRINT N'Altering [dbo].[USP_List_Syn_Ancillary]...';


GO
ALTER PROCEDURE [dbo].[USP_List_Syn_Ancillary]
	@Syn_Deal_Code INT
AS
---- =============================================
---- Author:		Rahul Kembhavi
---- Create DATE: 12-April-2022
---- Description:	SynDeal ANCIL List
---- Last Updated By : Rahul Kembhavi
---- Updated On:  12-April-2022
---- =============================================
BEGIN
Declare @Loglavel int
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_List_Acq_Ancillary]', 'Step 1', 0, 'Started Procedure', 0, ''
	IF(OBJECT_ID('TEMPDB..#Temp_Medium') IS NOT NULL)    
		DROP TABLE #Temp_Medium  
	IF(OBJECT_ID('TEMPDB..#Temp_Medium_Adv') IS NOT NULL)    
		DROP TABLE #Temp_Medium_Adv 

	--DECLARE @Syn_Deal_Code INT = 25032

	DECLARE @System_Parameter_New CHAR(1) = 'N'
	SELECT @System_Parameter_New = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_Ancillary_Advanced' 

	DECLARE @Deal_Type VARCHAR(30) = '' 
	SELECT @Deal_Type =dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code) 
	FROM Syn_Deal AD WHERE AD.Syn_Deal_Code = @Syn_Deal_Code

	IF(@System_Parameter_New <> 'N')
	BEGIN

		Select ADAP.Syn_Deal_Ancillary_Code , ADAP.Ancillary_Platform_code --, AM.Ancillary_Medium_Name
		INTO #Temp_Medium_Adv
		from Syn_Deal_Ancillary ADA
		LEFT Join Syn_Deal_Ancillary_Platform ADAP On ADAP.Syn_Deal_Ancillary_Code = ADA.Syn_Deal_Ancillary_Code
		WHERE ADA.Syn_Deal_Code = @Syn_Deal_Code  and ADAP.Ancillary_Platform_Code IS NULL

		SELECT DISTINCT ADA.Syn_Deal_Ancillary_Code
		, dbo.UFN_GetTitleName_Syn(ADA.Syn_Deal_Ancillary_Code,'',@Deal_Type) as TitleName
		, AT.Ancillary_Type_Code,AT.Ancillary_Type_Name
		, ISNULL(CAST(ADA.Duration AS INT),0) AS Duration,ISNULL(CAST(ADA.Day AS INT), 0) AS ADay,ADA.Remarks
		, ISNULL((Stuff ((
			Select Distinct ', '+ ISNULL(P.Platform_Name,'') from  #Temp_Medium_Adv TV 
			INNER JOIN [PLATFORM] P ON P.Platform_Code = TV.Ancillary_Platform_code
			WHERE TV.Syn_Deal_Ancillary_Code = ADA.Syn_Deal_Ancillary_Code 
			FOR XML PATH('')) , 1, 1, '')
		),'NA') as Platform_Name
		, '' as Ancillary_Medium_Name
		FROM Syn_Deal_Ancillary ADA 	
		INNER JOIN Ancillary_Type AT ON ADA.Ancillary_Type_code = AT.Ancillary_Type_code	
		LEFT JOIN Syn_Deal_Ancillary_Platform ADAP ON ADAP.Syn_Deal_Ancillary_Code=ADA.Syn_Deal_Ancillary_Code
		--Inner Join Ancillary_Platform AP ON ADAP.Ancillary_Platform_code= AP.Ancillary_Platform_code AND AT.Ancillary_Type_Code = ADA.Ancillary_Type_code
		WHERE ADA.Syn_Deal_Code = @Syn_Deal_Code and ADAP.Ancillary_Platform_Code IS NULL

	END
	ELSE
	BEGIN

		Select ADAP.Syn_Deal_Ancillary_Platform_Code, AM.Ancillary_Medium_Name
		INTO #Temp_Medium
		from Syn_Deal_Ancillary ADA
		Inner Join Syn_Deal_Ancillary_Platform ADAP On ADAP.Syn_Deal_Ancillary_Code = ADA.Syn_Deal_Ancillary_Code
		Inner Join Syn_Deal_Ancillary_Platform_Medium ADAPM ON ADAPM.Syn_Deal_Ancillary_Platform_Code = ADAP.Syn_Deal_Ancillary_Platform_Code
		Inner join Ancillary_Platform_Medium APM ON ADAPM.Ancillary_Platform_Medium_Code = APM.Ancillary_Platform_Medium_Code
		INNER JOIN Ancillary_Medium AM ON APM.Ancillary_Medium_Code = AM.Ancillary_Medium_Code 
		WHERE ADA.Syn_Deal_Code = @Syn_Deal_Code

		SELECT DISTINCT ADA.Syn_Deal_Ancillary_Code
		, dbo.UFN_GetTitleName_Syn(ADA.Syn_Deal_Ancillary_Code,'',@Deal_Type) as TitleName
		, AT.Ancillary_Type_Code,AT.Ancillary_Type_Name
		, ADA.Duration,ADA.Day AS ADay,ADA.Remarks,AP.Platform_Name
		, (Stuff ((
			Select Distinct ', '+ ISNULL(TM.Ancillary_Medium_Name,'') from  #Temp_Medium TM 
			WHERE TM.Syn_Deal_Ancillary_Platform_Code = ADAP.Syn_Deal_Ancillary_Platform_Code               
			FOR XML PATH('')) , 1, 1, '')
		) as Ancillary_Medium_Name
		FROM Syn_Deal_Ancillary ADA 	
		INNER JOIN Ancillary_Type AT ON ADA.Ancillary_Type_code = AT.Ancillary_Type_code	
		INNER JOIN Syn_Deal_Ancillary_Platform ADAP ON ADAP.Syn_Deal_Ancillary_Code=ADA.Syn_Deal_Ancillary_Code
		Inner Join Ancillary_Platform AP ON ADAP.Ancillary_Platform_code= AP.Ancillary_Platform_code AND AT.Ancillary_Type_Code = ADA.Ancillary_Type_code
		WHERE ADA.Syn_Deal_Code = @Syn_Deal_Code

	END

	IF OBJECT_ID('tempdb..#Temp_Medium') IS NOT NULL DROP TABLE #Temp_Medium
	IF OBJECT_ID('tempdb..#Temp_Medium_Adv') IS NOT NULL DROP TABLE #Temp_Medium_Adv
 
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_List_Acq_Ancillary]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO
PRINT N'Altering [dbo].[USP_Reports_Header_Data]...';


GO



ALTER PROCEDURE [dbo].[USP_Reports_Header_Data]
	@Module_Code INT,    
	@SysLanguageCode INT ,
	@CallFrom CHAR(1)
AS     
BEGIN  
Declare @Loglavel int
if(@Loglavel<2)Exec [USPLogSQLSteps] '[USP_Reports_Header_Data]', 'Step 1', 0, 'Started Procedure', 0, ''
IF OBJECT_ID('TEMPDB..#TempHeaderData') IS NOT NULL
	DROP TABLE #TempHeaderData
DECLARE 
	--@Module_Code INT = 108,    
	--@SysLanguageCode INT = 1,
	--@CallFrom CHAR(1) = 'H',


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
	@Col_Head32	NVARCHAR(MAX) = '',
	@Col_Head33	NVARCHAR(MAX) = '',
	@Col_Head34	NVARCHAR(MAX) = '',
	@Col_Head35	NVARCHAR(MAX) = '',
	@Col_Head36	NVARCHAR(MAX) = '',
	@Col_Head37	NVARCHAR(MAX) = '',
	@Col_Head38	NVARCHAR(MAX) = '',
	@Col_Head39	NVARCHAR(MAX) = '',
	@Col_Head40	NVARCHAR(MAX) = '',
	@Col_Head41	NVARCHAR(MAX) = '',
	@Col_Head42	NVARCHAR(MAX) = '',
	@Col_Head43	NVARCHAR(MAX) = '',
	@Col_Head44	NVARCHAR(MAX) = '',
	@Col_Head45	NVARCHAR(MAX) = '',
	@Col_Head46	NVARCHAR(MAX) = ''
	
	CREATE TABLE #TempHeaderData(
	    Col_Head1 NVARCHAR(MAX),
	    Col_Head2 NVARCHAR(MAX),
	    Col_Head3 NVARCHAR(MAX),
	    Col_Head4 NVARCHAR(MAX),
	    Col_Head5 NVARCHAR(MAX),
		Col_Head6 NVARCHAR(MAX),
	    Col_Head7 NVARCHAR(MAX),
	    Col_Head8 NVARCHAR(MAX),
	    Col_Head9 NVARCHAR(MAX),
	    Col_Head10 NVARCHAR(MAX),
		Col_Head11 NVARCHAR(MAX),
		Col_Head12 NVARCHAR(MAX),
	    Col_Head13 NVARCHAR(MAX),
	    Col_Head14 NVARCHAR(MAX),
	    Col_Head15 NVARCHAR(MAX),
		Col_Head16 NVARCHAR(MAX),
	    Col_Head17 NVARCHAR(MAX),
	    Col_Head18 NVARCHAR(MAX),
	    Col_Head19 NVARCHAR(MAX),
	    Col_Head20 NVARCHAR(MAX),
		Col_Head21 NVARCHAR(MAX),
	    Col_Head22 NVARCHAR(MAX),
	    Col_Head23 NVARCHAR(MAX),
	    Col_Head24 NVARCHAR(MAX),
	    Col_Head25 NVARCHAR(MAX),
		Col_Head26 NVARCHAR(MAX),
		Col_Head27 NVARCHAR(MAX),
	    Col_Head28 NVARCHAR(MAX),
	    Col_Head29 NVARCHAR(MAX),
	    Col_Head30 NVARCHAR(MAX),
		Col_Head31 NVARCHAR(MAX),
		Col_Head32 NVARCHAR(MAX),
		Col_Head33 NVARCHAR(MAX),
		Col_Head34 NVARCHAR(MAX),
		Col_Head35 NVARCHAR(MAX),
		Col_Head36 NVARCHAR(MAX),
		Col_Head37 NVARCHAR(MAX),
		Col_Head38 NVARCHAR(MAX),
		Col_Head39 NVARCHAR(MAX),
		Col_Head40 NVARCHAR(MAX),
		Col_Head41 NVARCHAR(MAX),
		Col_Head42 NVARCHAR(MAX),
		Col_Head43 NVARCHAR(MAX),
		Col_Head44 NVARCHAR(MAX),
		Col_Head45 NVARCHAR(MAX),
		Col_Head46 NVARCHAR(MAX)
	)

	----START MUSIC ASSIGNMENT ACTIVITY REPORT--------------------------
	IF(@Module_Code = 161)
	BEGIN
		IF(@CallFrom = 'H')
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Date' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'Day' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('Date','Day')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2)           
			 SELECT @Col_Head01,@Col_Head02
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'UserName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'FromDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'ToDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('UserName','FromDate','ToDate','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05
		END
	END
	----END MUSIC ASSIGNMENT ACTIVITY REPORT----------------------------

	----START CONTENT WISE MUSIC USAGE RREPORT--------------------------
	IF(@Module_Code = 158)
	BEGIN
		IF(@CallFrom = 'H')
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Content' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('Content','Version')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2)           
			 SELECT @Col_Head01,@Col_Head02
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Content' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AiringFromDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'AiringToDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('Content','AiringFromDate','AiringToDate','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05
		END
	END
	----END CONTENT WISE MUSIC USAGE RREPORT----------------------------

	----START CHANNELWISE MUSIC CONSUMPTION-----------------------------
	IF(@Module_Code = 168)
	BEGIN
		IF(@CallFrom = 'H')
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'ChannelName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'Content' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Total' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('ChannelName','MusicLabel','Content','Total')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3,Col_Head4)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Channels' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'Contents' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'AiringDateFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'AiringDateTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('Channels','MusicLabel','Contents','AiringDateFrom','AiringDateTo','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5,Col_Head6,Col_Head7)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07
		END
	END
	----END CHANNELWISE MUSIC CONSUMPTION-------------------------------

	----START LABELWISE MUSIC CONSUMPTION REPORT------------------------
	IF(@Module_Code = 157)
	BEGIN
		IF(@CallFrom = 'S')
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'ContentList' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'ConsumptionFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'ConsumptionTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END 
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('MusicLabel', 'ContentList', 'ConsumptionFrom', 'ConsumptionTo','CreatedBy', 'CreatedOn')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06
		END
	END
	----END LABELWISE MUSIC CONSUMPTION REPORT--------------------------

	----START EPISODIC COST REPORT--------------------------------------
	IF(@Module_Code = 173)
	BEGIN
		IF(@CallFrom = 'H')
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'CostType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'SubTotal' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('TitleName','AgreementNo','CostType','SubTotal')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3,Col_Head4)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'EpisodeFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'EpisodeTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('BusinessUnit','TitleType','AgreementNo','TitleName','EpisodeFrom','EpisodeTo','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5,Col_Head6,Col_Head7,Col_Head8)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08
		END
	END
	----END EPISODIC COST REPORT----------------------------------------

	----START ATTACHMENT REPORT-----------------------------------------
	IF(@Module_Code = 172)
	BEGIN
		IF(@CallFrom = 'S')
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'Titles' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'DocumentName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'BusinessUnitNames' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'Type' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END 
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('AgreementNo', 'Titles', 'DocumentName', 'BusinessUnitNames','Type','CreatedBy', 'CreatedOn')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07
		END
	END
	----END ATTACHMENT REPORT-------------------------------------------

	----START MUSIC EXCEPTION REPORT------------------------------------
	IF(@Module_Code = 159)
	BEGIN
		IF(@CallFrom = 'S')
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'Type' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'Channel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'EpisodeFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'EpisodeTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'FromDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'ToDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'Content' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END 
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('Type', 'MusicLabel', 'Channel', 'EpisodeFrom','EpisodeTo','FromDate','ToDate','Content','CreatedBy', 'CreatedOn')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9,Col_Head10)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10
		END
	END
	----END MUSIC EXCEPTION REPORT--------------------------------------

	----START MUSIC AIRING REPORT---------------------------------------
	IF(@Module_Code = 167)
	BEGIN
		IF(@CallFrom = 'H')
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'MusicTrack' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'Program' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'Content' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'EpisodeNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'AiringDateTime' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,  
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'TCIn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'TCOut' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,  
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Duration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'Channels' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,  
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'MusicAlbum' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,  
			 @Col_Head12 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('MusicTrack','Program','Content','EpisodeNo','Version','AiringDateTime','TCIn','TCOut','Duration','Channels','MusicAlbum','MusicLabel')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9, Col_Head10, Col_Head11, Col_Head12)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11, @Col_Head12
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Contents' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicTrack' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'Channels' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'EpisodeFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'EpisodeTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'DateFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'DateTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('Contents','MusicTrack','Channels','EpisodeFrom','EpisodeTo','DateFrom','DateTo','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5,Col_Head6,Col_Head7,Col_Head8,Col_Head9)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09
		END
	END
	----END MUSIC AIRING REPORT-----------------------------------------

	----START RUN EXCEPTION REPORT--------------------------------------
	IF(@Module_Code = 97)
	BEGIN
		IF(@CallFrom = 'H')
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'EnglishTitle' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'ProgramTitle' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'LogDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'HouseIds' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'Channel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'Exceptions' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(@Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('EnglishTitle','ProgramTitle','LogDate','HouseIds','Channel','Exceptions')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Titles' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'ReportType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'StartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'EndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'ShowAll' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('Titles','ReportType','StartDate','EndDate','TitleType','ShowAll','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5,Col_Head6,Col_Head7,Col_Head8)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08
		END
	END
	----END RUN EXCEPTION REPORT----------------------------------------

	----START ACQUSITION DEAL LIST REPORT--------------------------------------
	IF(@Module_Code = 108)
	BEGIN
		IF(@CallFrom = 'S')
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'StartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'EndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,  
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'MasterDeal' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'SubDeal' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'LicensorHB' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			@Col_Head11 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			@Col_Head12 = CASE WHEN  SM.Message_Key = 'Rights' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('AgreementNo', 'Title', 'StartDate', 'EndDate', 'BusinessUnit', 'Status', 'MasterDeal', 'SubDeal', 'LicensorHB', 'CreatedBy', 'CreatedOn','Rights')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9, Col_Head10, Col_Head11, Col_Head12)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11, @Col_Head12 
		END
		ELSE
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
				@Col_Head46 = CASE WHEN  SM.Message_Key = 'SelfUtilizationRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head46 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
			 AND SM.Message_Key IN ('AgreementNo','TitleType','DealDescription','ReferenceNo','DealType','AgreementDate','Status','Party','Program','Title','Director','starCast','Genres','TitleLanguage','ReleaseYear','Platform','RightStartDate','RightEndDate',
			 'Tentative','Term','Region','Exclusive','TitleLanguageRight','Subtitling','Dubbing','Sublicensing','ROFR','RestrictionRemarks','RightsHoldbackPlatform','RightsHoldbackRemark','Blackout','RightsRemark','ReverseHoldbackPlatform','ReverseHoldbackStartDate'
			 ,'ReverseHoldbackEndDate','ReverseHoldbackTentative','ReverseHoldbackTerm','ReverseHoldbackCountry','ReverseHoldbackRemark','GeneralRemarks','Paymenttermsconditions','WorkflowStatus','RunType','Attachment','SelfUtilizationGroup','SelfUtilizationRemarks')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9, Col_Head10, Col_Head11,Col_Head12,Col_Head13,Col_Head14,Col_Head15,Col_Head16,Col_Head17,Col_Head18,Col_Head19,Col_Head20,Col_Head21,Col_Head22,Col_Head23,Col_Head24,Col_Head25,Col_Head26,Col_Head27,Col_Head28,Col_Head29,Col_Head30,Col_Head31,Col_Head32,Col_Head33,Col_Head34,Col_Head35,Col_Head36,Col_Head37,Col_Head38,Col_Head39,Col_Head40,Col_Head41,Col_Head42,Col_Head43,Col_Head44,Col_Head45,Col_Head46)
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11,@Col_Head12,@Col_Head13,@Col_Head14,@Col_Head15,@Col_Head16,@Col_Head17,@Col_Head18,@Col_Head19,@Col_Head20,@Col_Head21,@Col_Head22,@Col_Head23,@Col_Head24,@Col_Head25,@Col_Head26,@Col_Head27,@Col_Head28,@Col_Head29,@Col_Head30,@Col_Head31,@Col_Head32,@Col_Head33,@Col_Head34,@Col_Head35,@Col_Head36,@Col_Head37,@Col_Head38,@Col_Head39,@Col_Head40,@Col_Head41,@Col_Head42,@Col_Head43,@Col_Head44,@Col_Head45,@Col_Head46
		END
	END
	----END ACQUSITION DEAL LIST REPORT--------------------------------------

	----START P&A RIGHTS REPORT--------------------------------------
	IF(@Module_Code = 111)
	BEGIN
	IF(@CallFrom = 'S')
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('AgreementNo', 'BusinessUnit', 'Title', 'CreatedBy', 'CreatedOn')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05
		END
		ELSE IF(@CallFrom = 'A') ----ADV ANCILLARY HEADER
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'AncillaryType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'Durationsec' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'PeriodDay' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'Remarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('AgreementNo', 'Title', 'TitleType', 'AncillaryType', 'Durationsec','PeriodDay','Remarks')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07
		END
		ELSE IF(@CallFrom = 'H') -------ADV ANCILLARY SHEET HEADER
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'SelectedPlatforms' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('BusinessUnit', 'Title', 'SelectedPlatforms', 'CreatedBy', 'CreatedOn')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05
		END
	END
	----END P&ARIGHTS REPORT--------------------------------------

	----START DEAL EXPIRY REPORT--------------------------------------
	IF(@Module_Code = 128)
	BEGIN
		IF(@CallFrom = 'S')
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'SelectedPlatforms' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'ExpiringInDay' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'ExpiryFor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'IncludeDomestic' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,  
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'IncludeSubDeals' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('Title', 'SelectedPlatforms', 'Region', 'ExpiringInDay', 'ExpiryFor','IncludeDomestic', 'IncludeSubDeals', 'BusinessUnit', 'CreatedBy', 'CreatedOn')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9, Col_Head10)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10
		END
	END
	----END DEAL EXPIRY REPORT--------------------------------------

	----START MUSIC DEAL LIST REPORT--------------------------------------
	IF(@Module_Code = 174)
	BEGIN
		IF(@CallFrom = 'S')
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'StartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'EndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'ExpireDeals' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('AgreementNo', 'MusicLabel', 'StartDate', 'EndDate', 'ExpireDeals', 'CreatedBy', 'CreatedOn')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07
		END
		ELSE
		BEGIN
		Select
			@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'AgreementDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'Description' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'Licensee' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'Licensor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'StartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'EndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'Platform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'TrackLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			@Col_Head11 = CASE WHEN  SM.Message_Key = 'DurationRestrictionHHMM' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			@Col_Head12 = CASE WHEN  SM.Message_Key = 'Noofsongs' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			@Col_Head13 = CASE WHEN  SM.Message_Key = 'ChannelCategory' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			@Col_Head14 = CASE WHEN  SM.Message_Key = 'Channel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
			@Col_Head15 = CASE WHEN  SM.Message_Key = 'ChannelType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			@Col_Head16 = CASE WHEN  SM.Message_Key = 'AgreementCost' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
			@Col_Head17 = CASE WHEN  SM.Message_Key = 'RightRule' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			@Col_Head18 = CASE WHEN  SM.Message_Key = 'LinkedShow' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			@Col_Head19 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			@Col_Head20 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			@Col_Head21 = CASE WHEN  SM.Message_Key = 'ReferenceNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
			@Col_Head22 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END
		FROM System_Message SM  
		INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
		AND SM.Message_Key IN ('AgreementNo','AgreementDate','MusicLabel','Description','Licensee','Licensor','StartDate','EndDate','Platform','TrackLanguage',
		'DurationRestrictionHHMM','Noofsongs','ChannelCategory','Channel','ChannelType','AgreementCost','RightRule','LinkedShow','BusinessUnit','RestrictionRemarks','ReferenceNo', 'Status')  
		INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
		END
		INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9, Col_Head10, Col_Head11,Col_Head12,Col_Head13,Col_Head14,Col_Head15,Col_Head16,Col_Head17,Col_Head18,Col_Head19,Col_Head20,Col_Head21,Col_Head22)
		SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11,@Col_Head12,@Col_Head13,@Col_Head14,@Col_Head15,@Col_Head16,@Col_Head17,@Col_Head18,@Col_Head19,@Col_Head20,@Col_Head21,@Col_Head22

	END
	----END MUSIC DEAL LIST REPORT--------------------------------------

	----START MUSIC TRACK ACTIVITY REPORT--------------------------------------
	IF(@Module_Code = 164)
	BEGIN
		IF(@CallFrom = 'S')
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'UserName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'FromDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'ToDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('UserName', 'FromDate', 'ToDate', 'CreatedBy', 'CreatedOn')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05
		END
	END
	----END MUSIC TRACK ACTIVITY REPORT--------------------------------------

	----START SYNDICATION DEAL LIST REPORT AND THEATRICAL SYNDICATION REPROT--------------------------------------
	IF(@Module_Code = 109 OR @Module_Code = 165)
	BEGIN
		IF(@CallFrom = 'S')
		BEGIN
			SELECT   
	 		@Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			@Col_Head02 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			@Col_Head03 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			@Col_Head04 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			@Col_Head05 = CASE WHEN  SM.Message_Key = 'StartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			@Col_Head06 = CASE WHEN  SM.Message_Key = 'EndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,  
			@Col_Head07 = CASE WHEN  SM.Message_Key = 'LicensorHB' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			@Col_Head08 = CASE WHEN  SM.Message_Key = 'IncludeExpiredDeals' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			@Col_Head09 = CASE WHEN  SM.Message_Key = 'Theatrical' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			@Col_Head10 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			@Col_Head11 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			@Col_Head12 = CASE WHEN  SM.Message_Key = 'Rights' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			AND SM.Message_Key IN ('AgreementNo', 'Title', 'BusinessUnit', 'Status', 'StartDate', 'EndDate', 'LicensorHB', 'IncludeExpiredDeals', 'Theatrical', 'CreatedBy', 'CreatedOn', 'Rights')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9, Col_Head10, Col_Head11, Col_Head12)           
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11, @Col_Head12 
		END
		ELSE
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
				@Col_Head45 = CASE WHEN  SM.Message_Key = 'SelfUtilizationRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head45 END
			FROM System_Message SM  
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
			AND SM.Message_Key IN ('AgreementNo','TitleType','DealDescription','ReferenceNo','AgreementDate','Status','Party','Program','Title','Director','starCast','Genres','TitleLanguage','ReleaseYear','Platform','RightStartDate','RightEndDate',
			'Tentative','Term','Region','Exclusive','TitleLanguageRight','Subtitling','Dubbing','Sublicensing','ROFR','RestrictionRemarks','RightsHoldbackPlatform','RightsHoldbackRemark','Blackout','RightsRemark','ReverseHoldbackPlatform','ReverseHoldbackStartDate'
			,'ReverseHoldbackEndDate','ReverseHoldbackTentative','ReverseHoldbackTerm','ReverseHoldbackCountry','ReverseHoldbackRemark','GeneralRemarks','Paymenttermsconditions','WorkflowStatus','RunType','Attachment','SelfUtilizationGroup','SelfUtilizationRemarks')  
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
			INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9, Col_Head10, Col_Head11,Col_Head12,Col_Head13,Col_Head14,Col_Head15,Col_Head16,Col_Head17,Col_Head18,Col_Head19,Col_Head20,Col_Head21,Col_Head22,Col_Head23,Col_Head24,Col_Head25,Col_Head26,Col_Head27,Col_Head28,Col_Head29,Col_Head30,Col_Head31,Col_Head32,Col_Head33,Col_Head34,Col_Head35,Col_Head36,Col_Head37,Col_Head38,Col_Head39,Col_Head40,Col_Head41,Col_Head42,Col_Head43,Col_Head44,Col_Head45)
			SELECT @Col_Head01, @Col_Head02, @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08, @Col_Head09, @Col_Head10, @Col_Head11,@Col_Head12,@Col_Head13,@Col_Head14,@Col_Head15,@Col_Head16,@Col_Head17,@Col_Head18,@Col_Head19,@Col_Head20,@Col_Head21,@Col_Head22,@Col_Head23,@Col_Head24,@Col_Head25,@Col_Head26,@Col_Head27,@Col_Head28,@Col_Head29,@Col_Head30,@Col_Head31,@Col_Head32,@Col_Head33,@Col_Head34,@Col_Head35,@Col_Head36,@Col_Head37,@Col_Head38,@Col_Head39,@Col_Head40,@Col_Head41,@Col_Head42,@Col_Head43,@Col_Head44,@Col_Head45	END
	END
	----END SYNDICATION DEAL LIST REPORT AND THEATRICAL SYNDICATION REPROT--------------------------------------
	
	----START PLATFORMWISE ACQUISITION REPORT AND DIGITAL TITLE REPORT--------------------------
	IF(@Module_Code = 119 OR @Module_Code = 124)
	BEGIN
	IF(@CallFrom = 'H')
		BEGIN
			IF(@Module_Code = 124)
			BEGIN
				 SELECT   
	 			 @Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
				 @Col_Head02 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
				 @Col_Head03 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
				 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
				 @Col_Head05 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
				 @Col_Head06 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
				 @Col_Head07 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
				 @Col_Head08 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
				 @Col_Head09 = CASE WHEN  SM.Message_Key = 'SubtitlingLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
				 @Col_Head10 = CASE WHEN  SM.Message_Key = 'DubbingLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
				 @Col_Head11 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END
				 FROM System_Message SM  
				 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
				 AND SM.Message_Key IN ('AgreementNo','DealDescription','Title','Term','RightStartDate','RightEndDate','TitleLanguage','Region','SubtitlingLanguage','DubbingLanguage','RestrictionRemarks')  
				 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
				 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, Col_Head11)           
				 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10, @Col_Head11
			END
			ELSE IF(@Module_Code = 119)
			BEGIN
				 SELECT   
	 			 @Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
				 @Col_Head02 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
				 @Col_Head03 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
				 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
				 @Col_Head05 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
				 @Col_Head06 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
				 @Col_Head07 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
				 @Col_Head08 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
				 @Col_Head09 = CASE WHEN  SM.Message_Key = 'SubtitlingLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
				 @Col_Head10 = CASE WHEN  SM.Message_Key = 'DubbingLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
				 @Col_Head11 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
				 @Col_Head12 = CASE WHEN  SM.Message_Key = 'DueDiligence' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END
				 FROM System_Message SM  
				 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
				 AND SM.Message_Key IN ('AgreementNo','DealDescription','Title','Term','RightStartDate','RightEndDate','TitleLanguage','Region','SubtitlingLanguage','DubbingLanguage','RestrictionRemarks', 'DueDiligence')  
				 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
				 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, Col_Head11, Col_Head12)           
				 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10, @Col_Head11, @Col_Head12
			END
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'SelectedPlatforms' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'IncludeExpiredDeals' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'IncludeSubDeals' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('BusinessUnit','Title','SelectedPlatforms','IncludeExpiredDeals','IncludeSubDeals','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9, Col_Head10, Col_Head11)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05, @Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10, @Col_Head11
		END
	END
	----END PLATFORMWISE ACQUISITION REPORT AND DIGITAL TITLE REPORT--------------------------

	----START SYNDICATION SALES REPORT--------------------------------------
	IF(@Module_Code = 131)
	BEGIN
	IF(@CallFrom = 'H')
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AgreementDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'Subtitlinglanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'Dubbinglanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			 @Col_Head12 = CASE WHEN  SM.Message_Key = 'Revenue' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			 @Col_Head13 = CASE WHEN  SM.Message_Key = 'DealStatus' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)
			 AND SM.Message_Key IN ('AgreementNo','AgreementDate','DealDescription','Title','Term','RightStartDate','RightEndDate','TitleLanguage','Region','Subtitlinglanguage','Dubbinglanguage','Revenue','DealStatus')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, Col_Head11, Col_Head12, Col_Head13)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10, @Col_Head11, @Col_Head12, @Col_Head13
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'SelectedPlatforms' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'StartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'EndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'IncludeExpiredDeals' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'DomesticTerritory' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END

			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('Title','BusinessUnit','SelectedPlatforms','Region','StartDate','EndDate','IncludeExpiredDeals','DomesticTerritory','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8, Col_Head9, Col_Head10)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05, @Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10
		END
	END
	----END SYNDICATION SALES REPORT--------------------------------------

	----START PLATFORMWISE SYNDICATION REPORT--------------------------------------
	IF(@Module_Code = 133)
	BEGIN
	IF(@CallFrom = 'H')
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'StartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'EndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'TitleLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'Region' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('AgreementNo','DealDescription','TitleName','Term','StartDate','EndDate','TitleLanguage','Region','Subtitling','Dubbing','RestrictionRemarks')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, Col_Head11)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10, @Col_Head11
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'SelectedPlatforms' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'IncludeExpiredDeals' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('BusinessUnit','Title','SelectedPlatforms','IncludeExpiredDeals','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05, @Col_Head06
		END
	END
	----END PLATFORMWISE SYNDICATION REPORT--------------------------------------

	----START COST AND REVENUE REPORT-----------------------------
	IF(@Module_Code = 166 OR @Module_Code = 171)
	BEGIN
	IF(@CallFrom = 'H')
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Party' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'Currency' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'CostTypeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('AgreementNo','TitleName','TitleType','Party','Currency','CostTypeName','RightStartDate','RightEndDate','Term')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09
		END
		ELSE 
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'Title' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'StartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'EndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'Module' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'IncludeExpiredDeals' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('AgreementNo','Title','StartDate','EndDate','Module', 'IncludeExpiredDeals', 'CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4, Col_Head5, Col_Head6, Col_Head7, Col_Head8)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04,@Col_Head05, @Col_Head06, @Col_Head07, @Col_Head08
		END
	END
	----END COST AND REVENUE REPORT-----------------------------
	
	----START SYNDICATION DEAL VERSION HISTORY REPORT--------------------------------------
	IF(@Module_Code = 105)
	BEGIN
	IF(@CallFrom = 'G')    ---GENERAL TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'DealDescription' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'DealTypeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'EntityName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'ExchangeRate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'CategoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'VendorName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'ContactName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'CurrencyName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'RoleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			 @Col_Head12 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			 @Col_Head13 = CASE WHEN  SM.Message_Key = 'ChannelClusterName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			 @Col_Head14 = CASE WHEN  SM.Message_Key = 'DealTitle' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,  
			 @Col_Head15 = CASE WHEN  SM.Message_Key = 'Rights' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			 @Col_Head16 = CASE WHEN  SM.Message_Key = 'ReverseHB' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,  
			 @Col_Head17 = CASE WHEN  SM.Message_Key = 'PaymentTerms' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			 @Col_Head18 = CASE WHEN  SM.Message_Key = 'Attachment' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,  
			 @Col_Head19 = CASE WHEN  SM.Message_Key = 'Material' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			 @Col_Head20 = CASE WHEN  SM.Message_Key = 'Ancillary' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,  
			 @Col_Head21 = CASE WHEN  SM.Message_Key = 'SportsRights' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
			 @Col_Head22 = CASE WHEN  SM.Message_Key = 'SportsAncillaryProgramming' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,  
			 @Col_Head23 = CASE WHEN  SM.Message_Key = 'SportsAncillaryMarketing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
			 @Col_Head24 = CASE WHEN  SM.Message_Key = 'SportsAncillaryFCTCommitments' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END,
			 @Col_Head25 = CASE WHEN  SM.Message_Key = 'SportsAncillarySales' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head25 END,
			 @Col_Head26 = CASE WHEN  SM.Message_Key = 'SportsMonetisationTypes' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head26 END,
			 @Col_Head27 = CASE WHEN  SM.Message_Key = 'Budget' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head27 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AgreementNo','DealDescription','DealTypeName','EntityName','ExchangeRate','CategoryName','VendorName','ContactName','CurrencyName','RoleName','InsertedBy','ChannelClusterName',
			 'DealTitle','Rights','ReverseHB','PaymentTerms','Attachment','Material','Ancillary','SportsRights','SportsAncillaryProgramming','SportsAncillaryMarketing','SportsAncillaryFCTCommitments','SportsAncillarySales','SportsMonetisationTypes',
			 'Budget')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, Col_Head11, Col_Head12, Col_Head13,
			 Col_Head14, Col_Head15,Col_Head16, Col_Head17,Col_Head18, Col_Head19,Col_Head20, Col_Head21,Col_Head22, Col_Head23, Col_Head24, Col_Head25, Col_Head26, Col_Head27)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10, @Col_Head11, @Col_Head12, @Col_Head13,
			 @Col_Head14, @Col_Head15, @Col_Head16,@Col_Head17,@Col_Head18,@Col_Head19,@Col_Head20,@Col_Head21,@Col_Head22,@Col_Head23, @Col_Head24, @Col_Head25, @Col_Head25, @Col_Head27
		END
		ELSE IF(@CallFrom = 'D')    ---DEAL TITLE TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'EpisodeStartsFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'EpsiodeEndTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'Notes' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'TitleType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'ClosingRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'MovieClosedDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','TitleName','EpisodeStartsFrom','EpsiodeEndTo','Notes','TitleType','ClosingRemarks','MovieClosedDate','Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10
		END
		ELSE IF(@CallFrom = 'R')    ---Rights TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealRightsCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'PlatformName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'CountryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'TerritoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'IsExclusive' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'IsTitleLanguageRight' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'IsSubLicense' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			 @Col_Head12 = CASE WHEN  SM.Message_Key = 'SubLicenseName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			 @Col_Head13 = CASE WHEN  SM.Message_Key = 'IsTheatricalRight' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			 @Col_Head14 = CASE WHEN  SM.Message_Key = 'RightType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
			 @Col_Head15 = CASE WHEN  SM.Message_Key = 'IsTentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			 @Col_Head16 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
			 @Col_Head17 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			 @Col_Head18 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			 @Col_Head19 = CASE WHEN  SM.Message_Key = 'MilestoneTypeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			 @Col_Head20 = CASE WHEN  SM.Message_Key = 'MilestoneNoofUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			 @Col_Head21 = CASE WHEN  SM.Message_Key = 'MilestoneUnitType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
			 @Col_Head22 = CASE WHEN  SM.Message_Key = 'IsROFR' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
			 @Col_Head23 = CASE WHEN  SM.Message_Key = 'ROFRDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
			 @Col_Head24 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END,
			 @Col_Head25 = CASE WHEN  SM.Message_Key = 'EffectiveStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head25 END,
			 @Col_Head26 = CASE WHEN  SM.Message_Key = 'ROFRType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head26 END,
			 @Col_Head27 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head27 END,
			 @Col_Head28 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head28 END

			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealRightsCode','TitleName','PlatformName','CountryName','TerritoryName','Subtitling','Dubbing','IsExclusive','IsTitleLanguageRight',
			 'IsSubLicense','SubLicenseName','IsTheatricalRight','RightType','IsTentative','Term','RightStartDate','RightEndDate','MilestoneTypeName','MilestoneUnitType',
			 'IsROFR','ROFRDate','RestrictionRemarks','EffectiveStartDate','ROFRType','Status','InsertedBy','MilestoneNoofUnit')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, col_Head11,
			 Col_Head12, Col_Head13,Col_Head14, Col_Head15,Col_Head16, Col_Head17,Col_Head18, Col_Head19,Col_Head20, Col_Head21, col_Head22,
			 Col_Head23, Col_Head24,Col_Head25, Col_Head26,Col_Head27, Col_Head28)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10,
			 @Col_Head11, @Col_Head12, @Col_Head13,@Col_Head14,@Col_Head15,@Col_Head16,@Col_Head17,@Col_Head18,@Col_Head19,@Col_Head20,
			 @Col_Head21, @Col_Head22, @Col_Head23,@Col_Head24,@Col_Head25,@Col_Head26,@Col_Head27,@Col_Head28
		END
		ELSE IF(@CallFrom = 'H')    ---REVERSE HOLDBACK TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealPushbackCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'PlatformName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'CountryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'TerritoryName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'Subtitling' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'Dubbing' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'IsTitleLanguageRight' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'RightType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'IsTentative' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			 @Col_Head12 = CASE WHEN  SM.Message_Key = 'Term' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			 @Col_Head13 = CASE WHEN  SM.Message_Key = 'RightStartDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			 @Col_Head14 = CASE WHEN  SM.Message_Key = 'RightEndDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
			 @Col_Head15 = CASE WHEN  SM.Message_Key = 'MilestoneTypeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			 @Col_Head16 = CASE WHEN  SM.Message_Key = 'MilestoneNoofUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
			 @Col_Head17 = CASE WHEN  SM.Message_Key = 'MilestoneUnitType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			 @Col_Head18 = CASE WHEN  SM.Message_Key = 'RestrictionRemarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			 @Col_Head19 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			 @Col_Head20 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			 @Col_Head21 = CASE WHEN  SM.Message_Key = 'SynDealRightsCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealPushbackCode','TitleName','PlatformName','CountryName','TerritoryName','Subtitling','Dubbing','IsTitleLanguageRight',
			 'RightType','IsTentative','Term','RightStartDate','RightEndDate','MilestoneTypeName','MilestoneUnitType','MilestoneNoofUnit','SynDealRightsCode',
			 'RestrictionRemarks','Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, col_Head11,
			 Col_Head12, Col_Head13,Col_Head14, Col_Head15,Col_Head16, Col_Head17,Col_Head18, Col_Head19,Col_Head20, Col_Head21)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10,
			 @Col_Head11, @Col_Head12, @Col_Head13,@Col_Head14,@Col_Head15,@Col_Head16,@Col_Head17,@Col_Head18,@Col_Head19,@Col_Head20, @Col_Head21
		END
		ELSE IF(@CallFrom = 'P')    ---PAYMENT TERM TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealPaymentTermCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'CostType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'PaymentTerm' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'DaysAfter' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'Percentage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'Amount' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'DueDate' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealPaymentTermCode','CostType','PaymentTerm','DaysAfter','Percentage','Amount','DueDate','Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10
		END
		ELSE IF(@CallFrom = 'A')    ---ATTACHMENT TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealAttachmentCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'AttachmentName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'AttachmentFileName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'SystemFileName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'DocumentType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'EpisodeFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'EpisodeTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,  
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealAttachmentCode','TitleName','AttachmentName','AttachmentFileName','systemFileName','DocumentType','EpisodeFrom', 'EpisodeTo', 'Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, Col_Head11)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10, @Col_Head11
		END
		ELSE IF(@CallFrom = 'M')    ---MATERIAL TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealMaterialCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'MaterialMedium' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'MaterialType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'Quantity' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'EpisodeFrom' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'EpisodeTo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealMaterialCode','TitleName','MaterialMedium','MaterialType','Quantity','EpisodeFrom','EpisodeTo','Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10
		END
		ELSE IF(@CallFrom = 'N')    ---ANCILLARY TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealAncillaryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'AncillaryType' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'AncillaryPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'AncillaryPlatformMedium' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'Duration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'Day' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Remarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,  
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealAncillaryCode','TitleName','AncillaryType','AncillaryPlatform','AncillaryPlatformMedium','Duration','Day', 'Remarks', 'Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, Col_Head11)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10, @Col_Head11
		END
		ELSE IF(@CallFrom = 'S')    ---SPORTS RIGHT TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealSportCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'ContentDelivery' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'ContentDeliveryBroadcastNames' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'ObligationBroadcast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'ObligationBroadcastNames' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'DeferredLive' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'DeferredLiveDuration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'TapeDelayed' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'TapeDelayedDuration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			 @Col_Head12 = CASE WHEN  SM.Message_Key = 'StandaloneTransmission' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
			 @Col_Head13 = CASE WHEN  SM.Message_Key = 'StandaloneSubstantial' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			 @Col_Head14 = CASE WHEN  SM.Message_Key = 'StandaloneDigitalPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
			 @Col_Head15 = CASE WHEN  SM.Message_Key = 'SimulcastTransmission' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			 @Col_Head16 = CASE WHEN  SM.Message_Key = 'SimulcastSubstantial' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
			 @Col_Head17 = CASE WHEN  SM.Message_Key = 'SimulcastDigitalPlatform' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			 @Col_Head18 = CASE WHEN  SM.Message_Key = 'LanguageName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			 @Col_Head19 = CASE WHEN  SM.Message_Key = 'LanguageGroupName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,
			 @Col_Head20 = CASE WHEN  SM.Message_Key = 'FileName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			 @Col_Head21 = CASE WHEN  SM.Message_Key = 'SysFileName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,
			 @Col_Head22 = CASE WHEN  SM.Message_Key = 'MTOCriticalNotes' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
			 @Col_Head23 = CASE WHEN  SM.Message_Key = 'MBOCriticalNotes' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END,
			 @Col_Head24 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head24 END,
			 @Col_Head25 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head25 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealSportCode','TitleName','ContentDelivery','ContentDeliveryBroadcastNames','ObligationBroadcast','ObligationBroadcastNames','DeferredLive','DeferredLiveDuration','TapeDelayed',
			 'TapeDelayedDuration','StandaloneTransmission','StandaloneSubstantial','StandaloneDigitalPlatform','LanguageName','LanguageGroupName','FileName','SysFileName','MTOCriticalNotes','MBOCriticalNotes',
			 'Status','InsertedBy','SimulcastTransmission','SimulcastSubstantial','SimulcastDigitalPlatform')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10, col_Head11,
			 Col_Head12, Col_Head13,Col_Head14, Col_Head15,Col_Head16, Col_Head17,Col_Head18, Col_Head19,Col_Head20, Col_Head21, col_Head22,
			 Col_Head23, Col_Head24,Col_Head25)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10,
			 @Col_Head11, @Col_Head12, @Col_Head13,@Col_Head14,@Col_Head15,@Col_Head16,@Col_Head17,@Col_Head18,@Col_Head19,@Col_Head20,
			 @Col_Head21, @Col_Head22, @Col_Head23,@Col_Head24,@Col_Head25
		END
		ELSE IF(@CallFrom = 'I')    ---SPORT ANCILLARY PROGRAMMING TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealSportAncillaryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Type' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'ObligationBroadcast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'WhenToBroadcastNames' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'BroadcastWindow' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'BroadcastPeriodicity' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Periodicity' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'Duration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'Source' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			 @Col_Head12 = CASE WHEN  SM.Message_Key = 'Remarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,  
			 @Col_Head13 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			 @Col_Head14 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END
	         FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealSportAncillaryCode','TitleName','Type','ObligationBroadcast','WhenToBroadcastNames','BroadcastWindow','BroadcastPeriodicity','Periodicity','Duration'
			 ,'Source','Remarks','Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10,
			 Col_Head11, Col_Head12,Col_Head13, Col_Head14)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10,
			 @Col_Head11, @Col_Head12, @Col_Head13,@Col_Head14
		END
		ELSE IF(@CallFrom = 'T')    ---SPORT ANCILLARY MARKETING TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealSportAncillaryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Type' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'ObligationBroadcast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'WhenToBroadcastNames' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'BroadcastWindow' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'BroadcastPeriodicity' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'Periodicity' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,  
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'Duration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'NoOfPromos' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			 @Col_Head12 = CASE WHEN  SM.Message_Key = 'PrimeStartTime' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,  
			 @Col_Head13 = CASE WHEN  SM.Message_Key = 'PrimeEndTime' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			 @Col_Head14 = CASE WHEN  SM.Message_Key = 'PrimeDuration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,  
			 @Col_Head15 = CASE WHEN  SM.Message_Key = 'PrimeNoofPromos' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			 @Col_Head16 = CASE WHEN  SM.Message_Key = 'OffPrimeStartTime' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,  
			 @Col_Head17 = CASE WHEN  SM.Message_Key = 'OffPrimeEndTime' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,
			 @Col_Head18 = CASE WHEN  SM.Message_Key = 'OffPrimeDurartion' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			 @Col_Head19 = CASE WHEN  SM.Message_Key = 'OffPrimeNoofPromos' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,  
			 @Col_Head20 = CASE WHEN  SM.Message_Key = 'Source' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END,
			 @Col_Head21 = CASE WHEN  SM.Message_Key = 'Remarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head21 END,  
			 @Col_Head22 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head22 END,
			 @Col_Head23 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head23 END 
	         FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealSportAncillaryCode','TitleName','Type','ObligationBroadcast','WhenToBroadcastNames','BroadcastWindow','BroadcastPeriodicity','Periodicity','Duration'
			 ,'NoOfPromos','PrimeStartTime','PrimeEndTime','PrimeDuration','PrimeNoofPromos','OffPrimeStartTime','OffPrimeEndTime','OffPrimeDurartion','OffPrimeNoofPromos',
			 'Source','Remarks','Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9, Col_Head10,
			 Col_Head11, Col_Head12,Col_Head13, Col_Head14,Col_Head15, Col_Head16,Col_Head17, Col_Head18,Col_Head19, Col_Head20, Col_Head21, Col_Head22, Col_Head23)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10,
			 @Col_Head11, @Col_Head12, @Col_Head13,@Col_Head14,@Col_Head15,@Col_Head16,@Col_Head17,@Col_Head18,@Col_Head19,@Col_Head20, @Col_Head21, @Col_Head22, @Col_Head23
		END
		ELSE IF(@CallFrom = 'F')    ---SPORTS ANCILLARY FCT COMMITMENTS TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealSportAncillaryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'Type' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'WhenToBroadcastNames' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'Duration' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'Source' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,  
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealSportAncillaryCode','TitleName','Type','WhenToBroadcastNames','Duration','Duration', 'Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09
		END
		ELSE IF(@CallFrom = 'E')    ---SPORTS ANCILLARY SALES TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealSportSalesAncillaryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'TitleSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'OfficialSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'FROGivenTitleSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'FROGivenOfficialSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'TitleFRONoOfDays' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,  
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'TitleFROValidity' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
			 @Col_Head10 = CASE WHEN  SM.Message_Key = 'OfficialFRONoOfDays' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,  
			 @Col_Head11 = CASE WHEN  SM.Message_Key = 'OfficialFROValidity' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
			 @Col_Head12 = CASE WHEN  SM.Message_Key = 'PriceProtectionTitleSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,  
			 @Col_Head13 = CASE WHEN  SM.Message_Key = 'PriceProtectionOfficialSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
			 @Col_Head14 = CASE WHEN  SM.Message_Key = 'LastMatchingRightsTitleSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,  
			 @Col_Head15 = CASE WHEN  SM.Message_Key = 'LastMatchingRightsOfficialSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head15 END,
			 @Col_Head16 = CASE WHEN  SM.Message_Key = 'TitleLastMatchingRightsValidity' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,  
			 @Col_Head17 = CASE WHEN  SM.Message_Key = 'OfficialLastMatchingRightsValidity' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END,  
			 @Col_Head18 = CASE WHEN  SM.Message_Key = 'Remarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head18 END,
			 @Col_Head19 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head19 END,  
			 @Col_Head20 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head20 END

			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealSportSalesAncillaryCode','TitleName','TitleSponsor','OfficialSponsor','FROGivenTitleSponsor','FROGivenOfficialSponsor', 'TitleFRONoOfDays','TitleFROValidity'
			 ,'OfficialFRONoOfDays','OfficialFROValidity','PriceProtectionTitleSponsor','PriceProtectionOfficialSponsor','LastMatchingRightsTitleSponsor','LastMatchingRightsOfficialSponsor',
			 'TitleLastMatchingRightsValidity','OfficialLastMatchingRightsValidity','Remarks','Status','InsertedBy')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9,Col_Head10,
			 Col_Head11, Col_Head12,Col_Head13, Col_Head14,Col_Head15, Col_Head16,Col_Head17, Col_Head18,Col_Head19,Col_Head20)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09, @Col_Head10,
			 @Col_Head11, @Col_Head12, @Col_Head13,@Col_Head14,@Col_Head15,@Col_Head16,@Col_Head17,@Col_Head18,@Col_Head19, @Col_Head20
		END
		ELSE IF(@CallFrom = 'O')    ---SPORTS MONETISATION TYPES TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealSportMonetisationAncillaryCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'AppointTitleSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'AppointBroadcastSponsor' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'MonetisationTypes' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
			 @Col_Head07 = CASE WHEN  SM.Message_Key = 'Remarks' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,  
			 @Col_Head08 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,  
			 @Col_Head09 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealSportMonetisationAncillaryCode','TitleName','AppointTitleSponsor','AppointBroadcastSponsor','MonetisationTypes','Remarks', 'Status','InsertedBy')
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6,Col_Head7, Col_Head8,Col_Head9)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06,@Col_Head07,@Col_Head08,@Col_Head09
		END
		ELSE IF(@CallFrom = 'B')    ---BUDGET TAB
		BEGIN
			 SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'Version' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'AcqDealBudgetCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'TitleName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,  
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'WBSCode' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
			 @Col_Head05 = CASE WHEN  SM.Message_Key = 'Status' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,  
			 @Col_Head06 = CASE WHEN  SM.Message_Key = 'InsertedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0) 
			 AND SM.Message_Key IN ('Version','AcqDealBudgetCode','TitleName','WBSCode','Status','InsertedBy')
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2,Col_Head3, Col_Head4,Col_Head5, Col_Head6)           
			 SELECT @Col_Head01, @Col_Head02, @Col_Head03,@Col_Head04,@Col_Head05,@Col_Head06
		END
		ELSE IF(@CallFrom = 'C')        -----------SHEET HEADER TAB
		BEGIN
			SELECT   
	 		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'AgreementNo' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,  
			 @Col_Head02 = CASE WHEN  SM.Message_Key = 'BusinessUnit' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
			 @Col_Head03 = CASE WHEN  SM.Message_Key = 'CreatedBy' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END,
			 @Col_Head04 = CASE WHEN  SM.Message_Key = 'CreatedOn' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END
			 FROM System_Message SM  
			 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @Module_Code OR ISNULL(SMM.Module_Code, 0)= 0)  
			 AND SM.Message_Key IN ('AgreementNo','BusinessUnit','CreatedBy','CreatedOn')  
			 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  
			 INSERT INTO #TempHeaderData (Col_Head1, Col_Head2, Col_Head3, Col_Head4)           
			 SELECT @Col_Head01,@Col_Head02,@Col_Head03,@Col_Head04
		END
	END
	----END SYNDICATION DEAL VERSION HISTORY REPORT--------------------------------------
		select * from #TempHeaderData		

		IF OBJECT_ID('tempdb..#TempHeaderData') IS NOT NULL DROP TABLE #TempHeaderData
		 
if(@Loglavel<2)Exec [USPLogSQLSteps] '[USP_Reports_Header_Data]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END
GO
PRINT N'Altering [dbo].[USPRUBVMappingList]...';


GO
ALTER PROCEDURE [dbo].[USPRUBVMappingList] 
--DECLARE
   @DropdownOption VARCHAR(20)='',
    @Tabselect VARCHAR(50)='',
	@PageNo INT=1,
	@PageSize INT = 10,
	@RecordCount INT OUT
AS
BEGIN
Declare @Loglevel int
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPRUBVMappingList]', 'Step 1', 0, 'Started Procedure', 0, ''
	IF(OBJECT_ID('TEMPDB..#TempRUBVMappingData') IS NOT NULL)
		DROP TABLE #TempRUBVMappingData
	IF(OBJECT_ID('TEMPDB..#Label') IS NOT NULL)
		DROP TABLE #Label
				SET NOCOUNT ON;
	CREATE TABLE #TempRUBVMappingData
	(
		Row_No INT IDENTITY(1,1),
		Title VARCHAR(MAX),                                      
		EpisodeNo INT,
		RUID INT,
		BVID INT,
		ErrorDescription VARCHAR(MAX),
		RecordStatus VARCHAR(MAX) ,
		LicenseRefNo NVARCHAR(50) ,
		RequestTime DATETIME,
		StartDate DATETIME,
		EndDate DATETIME,
		ChannelCode INT,
		VendorName  VARCHAR(MAX)
	)
	IF(@Tabselect='Asset')
	BEGIN
		IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(Title, EpisodeNo, BVID, RUID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Title, Episode_Number, BMS_Asset_Ref_Key, BMS_Asset_Code, Request_Time, Error_Description, 
			CASE WHEN Record_Status='E' THEN 'Error'  END AS Record_Status 
			FROM BMS_Asset WHERE Record_Status = 'E' order by BMS_Asset_Code desc;
		END
		ELSE IF(@DropdownOption='M')
		BEGIN
			INSERT INTO #TempRUBVMappingData(Title, EpisodeNo, BVID, RUID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Title, Episode_Number, BMS_Asset_Ref_Key, BMS_Asset_Code,Request_Time, Error_Description, 
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status
			FROM BMS_Asset WHERE BMS_Asset_Ref_Key=0 OR BMS_Asset_Ref_Key IS NULL order by BMS_Asset_Code desc;
		END
		ELSE IF(@DropdownOption='P')
		BEGIN
		INSERT INTO #TempRUBVMappingData(Title, EpisodeNo, BVID, RUID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Title, Episode_Number, BMS_Asset_Ref_Key, BMS_Asset_Code,Request_Time, Error_Description, 
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status
			FROM BMS_Asset WHERE  Record_Status IN ('P','W') order by BMS_Asset_Code desc;
		END
	END
  IF(@Tabselect='Deal')
	BEGIN
		IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID, RequestTime, ErrorDescription, RecordStatus)
			SELECT Lic_Ref_No,  BMS_Deal_Code, BMS_Deal_Ref_Key,Request_Time, Error_Description, 
			CASE WHEN Record_Status='E' THEN 'Error'  END AS Record_Status  
			FROM BMS_Deal	WHERE Record_Status = 'E' order by BMS_Deal_Code desc;
		END
		ELSE IF(@DropdownOption='P')
		BEGIN
		INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Lic_Ref_No,  BMS_Deal_Code, BMS_Deal_Ref_Key,Request_Time, Error_Description, 
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status 
			FROM BMS_Deal WHERE  Record_Status IN ('P','W') order by BMS_Deal_Code desc;
		END
    END 	
	IF(@Tabselect='Content')
	BEGIN
		IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID,RequestTime, Title,EpisodeNo,StartDate,EndDate, ErrorDescription, RecordStatus)
			SELECT D.Lic_Ref_No, C.BMS_Deal_Code, C.BMS_Deal_Content_Ref_Key,C.Request_Time, C.Title,A.Episode_No,  C.Start_Date, C.End_Date , C.Error_Description, 
			CASE WHEN C.Record_Status='E' THEN 'Error'  END AS Record_Status  FROM BMS_Deal_Content C 
			INNER JOIN BMS_Deal D ON C.BMS_Deal_Code=D.BMS_Deal_Code
			INNER JOIN BMS_Asset A 	ON C.BMS_Asset_Code=A.BMS_Asset_Code
			WHERE C.Record_Status = 'E' order by A.BMS_Asset_Code desc;
		END

		ELSE IF(@DropdownOption='P')
		BEGIN
			INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID, RequestTime,Title,EpisodeNo,StartDate,EndDate, ErrorDescription, RecordStatus)
			SELECT D.Lic_Ref_No, C.BMS_Deal_Code, C.BMS_Deal_Content_Ref_Key,C.Request_Time, C.Title, A.Episode_No,  C.Start_Date, C.End_Date , C.Error_Description, 
			 CASE WHEN C.Record_Status='W' THEN 'Waiting' WHEN C.Record_Status='P' THEN 'Pending'  END AS Record_Status FROM BMS_Deal_Content C 
			INNER JOIN BMS_Deal D ON C.BMS_Deal_Code=D.BMS_Deal_Code
			INNER JOIN BMS_Asset A 	ON C.BMS_Asset_Code=A.BMS_Asset_Code
			WHERE C.Record_Status IN ('P','W')  order by A.BMS_Asset_Code desc;
		END
    END

	IF(@Tabselect='Rights')
	BEGIN
	 IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID, RequestTime,Title,EpisodeNo,StartDate,EndDate, ChannelCode, ErrorDescription, RecordStatus)
			SELECT D.Lic_Ref_No, D.BMS_Deal_Code, R.BMS_Deal_Content_Ref_Key,R.Request_Time, R.Title, A.Episode_Number,  R.Start_Date, R.End_Date ,R.RU_Channel_Code , R.Error_Description,
			CASE WHEN R.Record_Status='E' THEN 'Error'  END AS Record_Status  FROM BMS_Deal_Content_Rights R 
			INNER JOIN BMS_Deal_Content C ON R.BMS_Deal_Content_Code=C.BMS_Deal_Content_Code
			INNER JOIN BMS_Deal D ON C.BMS_Deal_Code=D.BMS_Deal_Code
			INNER JOIN BMS_Asset A 	on R.BMS_Asset_Code=A.BMS_Asset_Code
			WHERE C.Record_Status = 'E' order by A.BMS_Asset_Code desc;
		END

		ELSE IF(@DropdownOption='P')
		BEGIN
		INSERT INTO #TempRUBVMappingData(LicenseRefNo, RUID, BVID,RequestTime, Title,EpisodeNo,StartDate,EndDate, ChannelCode, ErrorDescription, RecordStatus)
			SELECT D.Lic_Ref_No, D.BMS_Deal_Code, R.BMS_Deal_Content_Ref_Key,R.Request_Time, R.Title, A.Episode_Number,   R.Start_Date, R.End_Date , R.RU_Channel_Code, R.Error_Description,
			 CASE WHEN R.Record_Status='W' THEN 'Waiting' WHEN R.Record_Status='P' THEN 'Pending'  END AS Record_Status  FROM BMS_Deal_Content_Rights R 
			INNER JOIN BMS_Deal_Content C ON R.BMS_Deal_Content_Code=C.BMS_Deal_Content_Code
			INNER JOIN BMS_Deal D ON C.BMS_Deal_Code=D.BMS_Deal_Code
			INNER JOIN BMS_Asset A 	on R.BMS_Asset_Code=A.BMS_Asset_Code
			WHERE C.Record_Status IN ('P','W')  order by A.BMS_Asset_Code desc;
		END
    END
	IF(@Tabselect='License')
	BEGIN  
		IF(@DropdownOption='E')
		BEGIN
			INSERT INTO #TempRUBVMappingData(VendorName, RUID, BVID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Vendor_Name, Vendor_Code, Ref_Vendor_Key,Request_Time, Error_Description, 
			CASE WHEN Record_Status='E' THEN 'Error'  END AS Record_Status  
			FROM Vendor WHERE Record_Status = 'E' order by Vendor_Code desc;
		END
		ELSE IF(@DropdownOption='M')
		BEGIN
			INSERT INTO #TempRUBVMappingData(VendorName, RUID, BVID,RequestTime, ErrorDescription, RecordStatus)
			SELECT Vendor_Name, Vendor_Code, Ref_Vendor_Key,Request_Time, Error_Description, 
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status			
			FROM Vendor WHERE Ref_Vendor_Key=0 OR Ref_Vendor_Key IS NULL order by Vendor_Code desc		
        END
		ELSE IF(@DropdownOption='P')
		BEGIN
		INSERT INTO #TempRUBVMappingData(VendorName,RUID, BVID, RequestTime, ErrorDescription, RecordStatus)
			SELECT Vendor_Name, Vendor_Code, Ref_Vendor_Key,Request_Time, Error_Description,
			 CASE WHEN Record_Status='W' THEN 'Waiting' WHEN Record_Status='P' THEN 'Pending'  END AS Record_Status 
			 FROM Vendor WHERE Record_Status IN ('P','W') order by Vendor_Code desc;
		END
	END
	select @RecordCount = Count(*) from #TempRUBVMappingData
	delete from #TempRUBVMappingData where Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
	select Title,EpisodeNo ,RUID,BVID, RequestTime,ErrorDescription ,RecordStatus ,LicenseRefNo,StartDate,EndDate,ChannelCode,VendorName from #TempRUBVMappingData
	
	IF OBJECT_ID('tempdb..#Label') IS NOT NULL DROP TABLE #Label
	IF OBJECT_ID('tempdb..#TempRUBVMappingData') IS NOT NULL DROP TABLE #TempRUBVMappingData
	
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPRUBVMappingList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO
PRINT N'Altering [dbo].[USPRUR_Title_Expiry]...';


GO
ALTER PROC [dbo].[USPRUR_Title_Expiry]
(
	@RightsDefination RightsDefination READONLY,
	@FirstFrom INT,
	@FirstTo INT,
	@SecondFrom INT,
	@SecondTo INT,
	@ThirdFrom INT,
	@ThirdTo INT
)
AS
BEGIN
Declare @Loglevel int
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPRUR_Title_Expiry]', 'Step 1', 0, 'Started Procedure', 0, ''
	DECLARE @Deal_Rights_Title Deal_Rights_Title
	DECLARE @Deal_Rights_Platform Deal_Rights_Platform
	DECLARE @Deal_Rights_Territory Deal_Rights_Territory
	DECLARE @Deal_Rights_Subtitling Deal_Rights_Subtitling
	DECLARE @Deal_Rights_Dubbing Deal_Rights_Dubbing
	DECLARE @Syn_Deal_Code Int = 0

	CREATE TABLE #RigtsTitle
	(
		Acq_Deal_Rights_Code INT,  
		Title_Code INT, 
		Episode_From INT, 
		Episode_To INT, 
		Actual_Right_Start_Date DATE, 
		Actual_Right_End_Date DATE, 
		Is_Title_Language_Right CHAR(1)
	)
	
	CREATE TABLE #RightsCountry
	(
		Acq_Deal_Rights_Code INT,
		Country_Code INT
	)

	CREATE TABLE #ExpiryData(
		Title_Code INT,
		Country_Code INT,
		Platform_Code INT,
		Actual_Right_Start_Date DATE,
		Actual_Right_End_Date DATE,
		Expire_In_Days INT,
		Title_Name NVARCHAR(500),
		Country_Name NVARCHAR(500),
		Platform_Name NVARCHAR(500)
	);

	DECLARE @IntCode INT, @TitleCode INT, @EpisodeStart INT, @EpisodeEnd INT, @StartDate Date, @EndDate Date,
			@Is_Title_Language_Right Char(1) = 'Y', @Is_Exclusive Char(1) = 'N', @Is_Error Char(1) = 'N', @Right_Type Char(1) = 'Y',
			@CountryCodes VARCHAR(4000) = '', @PlatformCodes VARCHAR(4000) = ''--, @DubbingCodes VARCHAR(4000) = '', @SubtitlingCodes VARCHAR(4000) = ''

	DECLARE EUR_Rights CURSOR FOR 
		SELECT IntCode, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, CountryCodes, PlatformCodes
		FROM @RightsDefination ORDER BY TitleCode ASC, EpisodeStart ASC
	OPEN EUR_Rights
	FETCH NEXT FROM EUR_Rights INTO @IntCode, @TitleCode, @EpisodeStart, @EpisodeEnd, @StartDate, @EndDate, @CountryCodes, @PlatformCodes
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
	
		TRUNCATE TABLE #RigtsTitle
		TRUNCATE TABLE #RightsCountry

		DELETE FROM @Deal_Rights_Title
		DELETE FROM @Deal_Rights_Territory
		DELETE FROM @Deal_Rights_Platform
		
		INSERT INTO @Deal_Rights_Title(Title_Code, Episode_From, Episode_To)
		SELECT @TitleCode, @EpisodeStart, @EpisodeEnd

		INSERT INTO @Deal_Rights_Territory(Deal_Rights_Code, Country_Code)
		SELECT 0, number FROM dbo.fn_Split_withdelemiter(@CountryCodes, ',') WHERE number <> ''

		INSERT INTO @Deal_Rights_Platform(Deal_Rights_Code, Platform_Code)
		SELECT 0, number FROM dbo.fn_Split_withdelemiter(@PlatformCodes, ',') WHERE number <> ''

		INSERT INTO #RigtsTitle(Acq_Deal_Rights_Code, Title_Code, 
			Episode_From, 
			Episode_To, 
			Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right)
		SELECT adr.Acq_Deal_Rights_Code, adrt.Title_Code,
			CASE WHEN adrt.Episode_From >= drt.Episode_From THEN adrt.Episode_From ELSE drt.Episode_From END AS Episode_From,
			CASE WHEN adrt.Episode_To <= drt.Episode_To THEN adrt.Episode_To ELSE drt.Episode_To END AS Episode_To,
			Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right
		FROM Acq_Deal_Rights adr 
		INNER JOIN Acq_Deal_Rights_Title adrt On adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		INNER JOIN @Deal_Rights_Title drt ON adrt.Title_Code = drt.Title_Code AND 
		(
			adrt.Episode_From BETWEEN drt.Episode_From AND drt.Episode_To OR
			adrt.Episode_To BETWEEN drt.Episode_From AND drt.Episode_To OR
			drt.Episode_From BETWEEN adrt.Episode_From AND adrt.Episode_To OR
			drt.Episode_To BETWEEN adrt.Episode_From AND adrt.Episode_To 
		)
		WHERE ((Right_Type = 'M' And Actual_Right_End_Date Is Not Null) Or Right_Type <> 'M') AND Is_Title_Language_Right = 'Y'

		INSERT INTO #RightsCountry(Acq_Deal_Rights_Code, Country_Code)
		SELECT Acq_Deal_Rights_Code, Country_Code FROM (
			SELECT adr.Acq_Deal_Rights_Code, td.Country_Code 
			FROM #RigtsTitle adr
			INNER JOIN Acq_Deal_Rights_Territory tg ON adr.Acq_Deal_Rights_Code = tg.Acq_Deal_Rights_Code AND tg.Territory_Type = 'G'
			INNER JOIN Territory_Details td ON tg.Territory_Code = td.Territory_Code
			INNER JOIN @Deal_Rights_Territory drt ON td.Country_Code = drt.Country_Code
			UNION ALL
			SELECT adr.Acq_Deal_Rights_Code, tg.Country_Code 
			FROM #RigtsTitle adr
			INNER JOIN Acq_Deal_Rights_Territory tg ON adr.Acq_Deal_Rights_Code = tg.Acq_Deal_Rights_Code AND tg.Territory_Type = 'I'
			INNER JOIN @Deal_Rights_Territory drt ON tg.Country_Code = drt.Country_Code
		) AS a
		
		INSERT INTO #ExpiryData(Title_Code, Country_Code, Platform_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Expire_In_Days, Title_Name, Country_Name, Platform_Name)
		SELECT data.Title_Code, data.Country_Code, data.Platform_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Expire_In_Days, t.Title_Name, c.Country_Name, p.Platform_Hiearachy
		FROM (
			SELECT DISTINCT Title_Code, Country_Code, Platform_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Expire_In_Days 
			FROM
			(
				SELECT DISTINCT adr.Acq_Deal_Rights_Code, 
				ROW_NUMBER()OVER(PARTITION BY Title_Code, country_code, platform_code, adr.Is_Title_Language_Right ORDER BY [Actual_Right_Start_Date] DESC) AS [row],
				Platform_Code, Title_Code, Country_Code, Actual_Right_Start_Date,Actual_Right_End_Date,
				DATEDIFF(dd,GETDATE(),IsNull(Actual_Right_End_Date, '31Dec9999')) AS Expire_In_Days
				From #RigtsTitle adr
				Inner Join Acq_Deal_Rights_Platform adrp On adr.Acq_Deal_Rights_Code = adrp.Acq_Deal_Rights_Code
				Inner Join #RightsCountry adrc On adr.Acq_Deal_Rights_Code = adrc.Acq_Deal_Rights_Code
			) b
			WHERE [row] = 1 And (
				Expire_In_Days BETWEEN @FirstFrom AND @FirstTo OR
				Expire_In_Days BETWEEN @SecondFrom AND @SecondTo OR
				Expire_In_Days BETWEEN @ThirdFrom AND @ThirdTo
			)
		) AS data
		INNER JOIN Title t On t.Title_Code = data.Title_Code
		INNER JOIN Country c On c.Country_Code = data.Country_Code
		INNER JOIN Platform p On p.Platform_Code = data.Platform_Code


		FETCH NEXT FROM EUR_Rights INTO @IntCode, @TitleCode, @EpisodeStart, @EpisodeEnd, @StartDate, @EndDate, @CountryCodes, @PlatformCodes
	END
	CLOSE EUR_Rights
	DEALLOCATE EUR_Rights

	SELECT DISTINCT Title_Code, Country_Code, Platform_Code, Actual_Right_Start_Date, Actual_Right_End_Date, Expire_In_Days, Title_Name, Country_Name, Platform_Name
	FROM #ExpiryData
	
	DROP TABLE #RigtsTitle
	DROP TABLE #RightsCountry
	DROP TABLE #ExpiryData
	
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPRUR_Title_Expiry]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO
PRINT N'Altering [dbo].[USPRUR_VALIDATE_Content]...';


GO
ALTER PROC [dbo].[USPRUR_VALIDATE_Content]
(
	@RightsDefination RightsDefination READONLY
)
AS
BEGIN
Declare @Loglevel int
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPRUR_VALIDATE_Content]', 'Step 1', 0, 'Started Procedure', 0, ''
	--SELECT * INTO RURRightsDefination FROM @RightsDefination

	DECLARE @Deal_Rights_Title Deal_Rights_Title
	DECLARE @Deal_Rights_Platform Deal_Rights_Platform
	DECLARE @Deal_Rights_Territory Deal_Rights_Territory
	DECLARE @Deal_Rights_Subtitling Deal_Rights_Subtitling
	DECLARE @Deal_Rights_Dubbing Deal_Rights_Dubbing
	DECLARE @Syn_Deal_Code Int = 0

	CREATE TABLE #Temp_Episode_No
	(
		Episode_No Int
	)
	
	CREATE TABLE #Deal_Right_Title_WithEpsNo
	(
		Deal_Rights_Code Int,
		Title_Code Int,
		Episode_No Int,
	)
	
	CREATE TABLE #TempCombination
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
		Data_From CHAR(1),
		Is_Available CHAR(1),
		Error_Description NVARCHAR(MAX),
		Sum_of Int,
		Partition_Of Int
	)
	
	CREATE TABLE #TempCombination_Session
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
		Data_From CHAR(1),
		Is_Available CHAR(1),
		Error_Description NVARCHAR(MAX),
		Sum_of Int,
		Partition_Of Int,
		MessageUpadated CHAR(1) DEFAULT('N')
	)
	
	Create TABLE #TempRightsError(
		IntCode INT,
		TitleName NVARCHAR(500),
		TitleCode INT, 
		EpisodeStart INT, 
		EpisodeEnd INT, 
		PlatformName NVARCHAR(500),
		PlatformCode INT, 
		CountryName NVARCHAR(500),
		CountryCode INT, 
		StartDate Date, 
		EndDate Date,
		ErrorMessage NVARCHAR(MAX)
	);

	With gen As (
		Select 1 As num Union All
		Select num+1 From gen Where num + 1 <= 10000
	)

	Insert InTo #Temp_Episode_No
	Select * From gen Option (maxrecursion 10000)
	
	DECLARE @IntCode INT, @TitleCode INT, @EpisodeStart INT, @EpisodeEnd INT, @StartDate Date, @EndDate Date,
			@Is_Title_Language_Right Char(1) = 'Y', @Is_Exclusive Char(1) = 'N', @Is_Error Char(1) = 'N', @Right_Type Char(1) = 'Y',
			@CountryCodes VARCHAR(4000) = '', @PlatformCodes VARCHAR(4000) = '', @DubbingCodes VARCHAR(4000) = '', @SubtitlingCodes VARCHAR(4000) = ''
	DECLARE EUR_Rights CURSOR FOR 
		SELECT IntCode, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, CountryCodes, PlatformCodes, DubbingCodes, SubtitlingCodes 
		FROM @RightsDefination ORDER BY TitleCode ASC, EpisodeStart ASC
	OPEN EUR_Rights
	FETCH NEXT FROM EUR_Rights INTO @IntCode, @TitleCode, @EpisodeStart, @EpisodeEnd, @StartDate, @EndDate, @CountryCodes, @PlatformCodes, @DubbingCodes, @SubtitlingCodes
	WHILE(@@FETCH_STATUS = 0)
	BEGIN
	
		TRUNCATE TABLE #Deal_Right_Title_WithEpsNo
		TRUNCATE TABLE #TempCombination_Session
		TRUNCATE TABLE #TempCombination

		DELETE FROM @Deal_Rights_Title
		DELETE FROM @Deal_Rights_Territory
		DELETE FROM @Deal_Rights_Platform
		
		INSERT INTO @Deal_Rights_Title(Title_Code, Episode_From, Episode_To)
		SELECT @TitleCode, @EpisodeStart, @EpisodeEnd

		INSERT INTO @Deal_Rights_Territory(Deal_Rights_Code, Country_Code)
		SELECT 0, number FROM dbo.fn_Split_withdelemiter(@CountryCodes, ',') WHERE number <> ''

		INSERT INTO @Deal_Rights_Platform(Deal_Rights_Code, Platform_Code)
		SELECT 0, number FROM dbo.fn_Split_withdelemiter(@PlatformCodes, ',') WHERE number <> ''

		--SELECT * FROM @Deal_Rights_Title

		SELECT @Is_Error = 'N'
	
		INSERT INTO #Deal_Right_Title_WithEpsNo(Title_Code, Episode_No)
		SELECT @TitleCode, Episode_No FROM #Temp_Episode_No WHERE Episode_No Between @EpisodeStart And @EpisodeEnd

	
		SELECT ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,
				Is_Exclusive, ADR.Acq_Deal_Code, AD.Agreement_No,
				(Select Count(*) From Acq_Deal_Rights_Subtitling a Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) SubCnt, 
				(Select Count(*) From Acq_Deal_Rights_Dubbing a Where a.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code) DubCnt,
				Sum(                        
					Case 
						When (@StartDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
							Then datediff(d,@StartDate, DATEADD(d,1, ADR.Actual_Right_End_Date ))
						When (@StartDate Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
							Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @EndDate))
						When (@StartDate < ADR.Actual_Right_Start_Date) And (@EndDate > ADR.Actual_Right_End_Date)
							Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date))
						When (@StartDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
							Then datediff(d,@StartDate,DATEADD(d,1, @EndDate  ))
						Else 0 
					End
				)Sum_of,
				Sum(
					Case 
						When (@StartDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
							Then datediff(d,@StartDate, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
						When (@StartDate Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
							Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @EndDate))
						When (@StartDate < ADR.Actual_Right_Start_Date) And (@EndDate > ADR.Actual_Right_End_Date)
							Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
						When (@StartDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) And (@EndDate Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
							Then datediff(d,@StartDate,DATEADD(d,1, @EndDate  ))
						Else 0 
					End
				)
				OVER(
					PARTITION BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code
				) Partition_Of
				InTo #Acq_Deal_Rights
		From Acq_Deal_Rights ADR
		Inner Join Acq_Deal AD On ADR.Acq_Deal_Code = ad.Acq_Deal_Code --And IsNull(AD.Deal_Workflow_Status,'') = 'A'
		Where 
		ADR.Acq_Deal_Code Is Not Null
		--AND AD.Acq_Deal_Code = 695
		--AND Acq_Deal_Rights_Code IN (1071,1072,11481)
		--And ADR.Is_Sub_License='Y'
		--And ADR.Is_Tentative='N'
		And
		(
			(
				ADR.Right_Type ='Y' AND
				(
					(CONVERT(DATETIME, @StartDate, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) And Convert(DATETIME, ADR.Right_End_Date, 103)) OR
					(CONVERT(DATETIME, @EndDate, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) And CONVERT(DATETIME, ADR.Right_End_Date, 103)) OR
					(CONVERT(DATETIME, ADR.Right_Start_Date, 103) Between CONVERT(DATETIME, @StartDate, 103) And CONVERT(DATETIME, @EndDate, 103)) OR
					(CONVERT(DATETIME, ADR.Right_End_Date, 103) Between CONVERT(DATETIME, @StartDate, 103) And CONVERT(DATETIME, @EndDate, 103))
				)
			)OR(ADR.Right_Type ='U'  OR ADR.Right_Type ='M')
		) 
		AND (    
			(ADR.Is_Title_Language_Right = @Is_Title_Language_Right) OR 
			(@Is_Title_Language_Right <> 'Y' And ADR.Is_Title_Language_Right = 'Y') OR 
			(@Is_Title_Language_Right = 'Y' And ADR.Is_Title_Language_Right = 'N')
		) AND (
			(@Is_Exclusive = 'Y' And IsNull(ADR.Is_exclusive,'')='Y') OR @Is_Exclusive = 'N'
		) 
		GROUP BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code, AD.Agreement_No

		Select Distinct ADR.Acq_Deal_Rights_Code, ADRT.Title_Code, ADRT.Episode_From, ADRT.Episode_To, ADR.SubCnt, ADR.DubCnt,
						ADR.Sum_of, ADR.Partition_Of
		InTo #Acq_Titles_With_Rights
		From #Acq_Deal_Rights ADR
		Inner Join dbo.Acq_Deal_Rights_Title ADRT On ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
		Inner Join @Deal_Rights_Title drt On ADRT.Title_Code = drt.Title_Code And 
		(
			(drt.Episode_From Between ADRT.Episode_From And ADRT.Episode_To)
			Or
			(drt.Episode_To Between ADRT.Episode_From And ADRT.Episode_To)
			Or
			(ADRT.Episode_From Between drt.Episode_From And drt.Episode_To)
			Or
			(ADRT.Episode_To Between drt.Episode_From And drt.Episode_To)
		)

		--Select * From @Deal_Rights_Title
		--Select * From #Acq_Deal_Rights
		--Select * From #Acq_Titles_With_Rights

		Begin ----------------- CHECK PLATFORM And TITLE & EPISODE EXISTS OR NOT

			Select Distinct Title_Code, Episode_From, Episode_To InTo #Acq_Titles From #Acq_Titles_With_Rights
			
			--Select * From #Acq_Titles

			Select Title_Code, Episode_No InTo #Acq_Avail_Title_Eps
			From (
				Select Distinct t.Title_Code, a.Episode_No 
				From #Temp_Episode_No A 
				Cross Apply #Acq_Titles T 
				Where A.Episode_No Between T.Episode_FROM And T.Episode_To
			) As B 
		
			--SELECT * FROM #Deal_Right_Title_WithEpsNo

			SELECT ROW_NUMBER() OVER(ORDER BY Title_Code, Episode_No ASC) RowId, * INTO #Title_Not_Acquire FROM #Deal_Right_Title_WithEpsNo deps
			WHERE deps.Episode_No NOT IN (
				SELECT Episode_No FROM #Acq_Avail_Title_Eps aeps WHERE deps.Title_Code = aeps.Title_Code
			)

			--SELECT * FROM #Title_Not_Acquire

			CREATE TABLE #Temp_NA_Title(
				Title_Code INT,
				Episode_From INT,
				Episode_To INT,
				Status CHAR(1)
			)

			DECLARE @Cur_Title_code INT = 0, @Cur_Episode_No INT = 0, @Prev_Title_Code INT = 0, @Prev_Episode_No INT
			DECLARE CUS_EPS CURSOR FOR 
				SELECT Title_code, Episode_No FROM #Title_Not_Acquire ORDER BY Title_code ASC, Episode_No ASC
			OPEN CUS_EPS
			FETCH NEXT FROM CUS_EPS INTO @Cur_Title_code, @Cur_Episode_No
			WHILE(@@FETCH_STATUS = 0)
			BEGIN
	
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

			If Exists(Select Top 1 * From #Temp_NA_Title Where Status = 'U' And Title_Code = @Prev_Title_Code)
			Begin
				Update #Temp_NA_Title Set Episode_To = @Prev_Episode_No, Status = 'A' Where Status = 'U' And Title_Code = @Prev_Title_Code
			End

			--Select * From #Temp_NA_Title

			If Exists(Select Top 1 * From #Temp_NA_Title)
			Begin
				Insert InTo #TempRightsError(IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, ErrorMessage)
				Select @IntCode, t.Title_Name, tnt.Title_Code, Episode_From, Episode_To, @StartDate, @EndDate, 'Title not acquired'
				From #Temp_NA_Title tnt
				Inner Join Title t On tnt.Title_Code = t.Title_Code

				Set @Is_Error = 'Y'
			End
	
		End ------------------------------ END
				

	
		Begin ----------------- CHECK PLATFORM And TITLE & EPISODE EXISTS OR NOT

			Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRP.Platform_Code
			InTo #Temp_Platforms
			From #Acq_Titles DRT
			Inner Join @Deal_Rights_Platform DRP On 1 = 1

			--SELECT * FROM #Acq_Titles
			--SELECT * FROM #Acq_Titles_With_Rights

			SELECT art.*, adrp.Platform_Code INTO #Temp_Acq_Platform FROM #Acq_Titles_With_Rights art
			Inner Join Acq_Deal_Rights_Platform adrp On adrp.Acq_Deal_Rights_Code = art.Acq_Deal_Rights_Code
			Inner Join @Deal_Rights_Platform drp On adrp.Platform_Code = drp.Platform_Code

			--SELECT * FROM #Temp_Acq_Platform

			DELETE FROM #Temp_Acq_Platform WHERE Platform_Code NOT IN (SELECT Platform_Code FROM #Temp_Platforms)

			--SELECT * FROM #Temp_Acq_Platform

			Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRT.Platform_Code InTo #NA_Platforms
			From #Temp_Platforms DRT
			Where DRT.Platform_Code Not In (
				Select ap.Platform_Code From #Temp_Acq_Platform ap
				Where DRT.Title_Code = ap.Title_Code And DRT.Episode_From = ap.Episode_From And DRT.Episode_To = ap.Episode_To
			)

			--SELECT * FROM #Temp_Platforms

			Delete From #Temp_Platforms Where #Temp_Platforms.Platform_Code In (
				Select np.Platform_Code From #NA_Platforms np
				Where np.Title_Code = #Temp_Platforms.Title_Code And np.Episode_From = #Temp_Platforms.Episode_From And np.Episode_To = #Temp_Platforms.Episode_To
			)

			--SELECT * FROM #Temp_Platforms
			--SELECT * FROM #NA_Platforms

			DELETE b FROM #Temp_Platforms a
			INNER JOIN #NA_Platforms b ON a.Platform_Code = b.Platform_Code AND a.Title_Code = b.Title_Code AND 
			(
				(a.Episode_From Between b.Episode_From And b.Episode_To)
				Or
				(a.Episode_To Between b.Episode_From And b.Episode_To)
				Or
				(b.Episode_From Between a.Episode_From And a.Episode_To)
				Or
				(b.Episode_To Between a.Episode_From And a.Episode_To)
			)

			--SELECT * FROM #NA_Platforms


			--DELETE a FROM #NA_Platforms a WHERE Platform_Code IN (
			--	SELECT Platform_Code FROM #Temp_Platforms b WHERE a.Platform_Code
			--)

			Insert InTo #TempRightsError(IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, PlatformCode, PlatformName, ErrorMessage)
			Select @IntCode, t.Title_Name, t.Title_Code, Episode_From, Episode_To,  @StartDate, @EndDate, np.Platform_Code, p.Platform_Hiearachy, 'Platform not acquired'
			From #NA_Platforms np
			Inner Join Title t On np.Title_Code = t.Title_Code
			Inner Join Platform p On np.Platform_Code = p.Platform_Code
			WHERE @Is_Error = 'N'

		End ------------------------------ END
				
		Begin ----------------- CHECK COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT
			
			Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tc.Country_Code InTo #Temp_Country
			From #Temp_Platforms tp
			Inner Join @Deal_Rights_Territory TC On 1 = 1


			Select Acq_Deal_Rights_Code, Case When srter.Territory_Type = 'G' Then td.Country_Code Else srter.Country_Code End Country_Code InTo #Acq_Country
			From (
				Select Acq_Deal_Rights_Code, Territory_Code, Country_Code,  Territory_Type 
				From Acq_Deal_Rights_Territory  
				Where Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code from #Acq_Deal_Rights)
			) srter
			Left Join Territory_Details td On srter.Territory_Code = td.Territory_Code

			Select tap.*, adc.Country_Code InTo #Temp_Acq_Country From #Temp_Acq_Platform tap
			Inner Join #Acq_Country adc On tap.Acq_Deal_Rights_Code = adc.Acq_Deal_Rights_Code

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

			Insert InTo #TempRightsError(IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, PlatformCode, PlatformName, CountryCode, CountryName, ErrorMessage)
			Select @IntCode, t.Title_Name, t.Title_Code, Episode_From, Episode_To,  @StartDate, @EndDate, np.Platform_Code, p.Platform_Name, c.Country_Code, c.Country_Name, 'Region not acquired'
			From #NA_Country np
			Inner Join Title t On np.Title_Code = t.Title_Code
			Inner Join Platform p On np.Platform_Code = p.Platform_Code
			Inner Join Country c On np.Country_Code = c.Country_Code
			WHERE @Is_Error = 'N'

			If(@Is_Title_Language_Right = 'Y')
			Begin

				INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, Right_End_Date, Is_Title_Language_Right,
														Country_Code, Terrirory_Type, Is_exclusive, Subtitling_Language_Code, Dubbing_Language_Code,
														Data_From, Is_Available, Error_Description,
														Sum_of,partition_of)
				SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, 'Y', @StartDate, @EndDate, @Is_Title_Language_Right,
					T.Country_Code, 'I', @Is_Exclusive, 0, 0,
					'S', 'N', 'Session',
					Case 
						When @EndDate Is Null Then 0 Else datediff(D, @StartDate, DATEADD(D, 1, @EndDate))
					End Sum_of,
					Case 
						When @EndDate Is Null Then 0 Else datediff(D, @StartDate, DATEADD(D, 1, @EndDate))
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
	
		UPDATE b SET b.Sum_of = (
			SELECT SUM(c.Sum_of) FROM(
				SELECT DISTINCT a.Title_Code, a.Episode_From, a.Episode_To, a.Platform_Code, a.Country_Code, a.Sum_of --, a.Subtitling_Language_Code, a.Dubbing_Language_Code
				FROM #TempCombination AS a
			) AS c WHERE c.Title_Code = b.Title_Code And c.Episode_From = b.Episode_From And c.Episode_To = b.Episode_To AND
			c.Platform_Code = b.Platform_Code And c.Country_Code = b.Country_Code 
			--And c.Subtitling_Language_Code = b.Subtitling_Language_Code AND c.Dubbing_Language_Code = b.Dubbing_Language_Code
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
			WHERE CONVERT(DATETIME, @StartDate, 103) <= CONVERT(DATETIME, IsNull(T1.Right_Start_Date,''), 103)				
		END

		UPDATE t2 Set t2.Is_Available = 'Y'
		FROM #TempCombination_Session t2 
		LEFT join #Min_Right_Start_Date MRSD on T2.Title_Code = MRSD.Title_Code
		Inner Join #TempCombination t1 On 
		T1.Title_Code = T2.Title_Code And 
		T1.Episode_From = T2.Episode_From And 
		T1.Episode_To = T2.Episode_To And 
		T1.Platform_Code = T2.Platform_Code And 
		T1.Country_Code= T2.Country_Code
		--And T1.Subtitling_Language_Code = T2.Subtitling_Language_Code And 
		--T1.Dubbing_Language_Code = T2.Dubbing_Language_Code  
		And 
		(
			(
				(t1.sum_of = (Case When T2.Right_Type != 'U' Then datediff(d,@StartDate,dateadd(d,1,@EndDate))  Else 0 End)) OR
				(
					(T1.Right_Type = 'U' OR T2.Right_Type = 'U') AND
					(CONVERT(DATETIME, @StartDate, 103) >= CONVERT(DATETIME, IsNull(MRSD.MIN_Start_DATE,t1.Right_Start_Date), 103))
				)
			)OR
			(t1.Partition_Of = (Case When T2.Right_Type != 'U' Then datediff(d,@StartDate,dateadd(d,1,@EndDate))  Else 0 End))
		)AND 
		(
			((T1.Right_Type <> 'Y'  AND T1.Right_Type <> 'M') AND T2.Right_Type = 'U') OR
			((T1.Right_Type = 'Y' OR T1.Right_Type = 'M') AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M')) OR
			(T1.Right_Type = 'U' AND (T2.Right_Type = 'Y' OR T2.Right_Type = 'M'))
		)

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
							(TCS.sum_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@StartDate,dateadd(d,1,@EndDate))  ELSE 0 END))OR
							(
								(TCS.Right_Type = 'U' OR TC.Right_Type = 'U') AND
								(CONVERT(DATETIME, @StartDate, 103) >= CONVERT(DATETIME, ISNULL(TCS.Right_Start_Date,'') , 103))
							)
						)OR
						(TCS.partition_of = (CASE WHEN TC.Right_Type != 'U' Then datediff(d,@StartDate,dateadd(d,1,@EndDate))  ELSE 0 END))           
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

		UPDATE #TempCombination_Session Set Error_Description = 'Rights period mismatch' Where Is_Available='N' And Error_Description = ''
	
		Insert InTo #TempRightsError(IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, StartDate, EndDate, PlatformCode, PlatformName, CountryCode, CountryName, ErrorMessage)
		Select @IntCode, t.Title_Name, nsub.Title_Code, Episode_From, Episode_To, @StartDate, @EndDate, nsub.Platform_Code, p.Platform_Hiearachy, c.Country_Code, c.Country_Name, Error_Description
		From #TempCombination_Session nsub 
		Inner Join Title t On nsub.Title_Code = t.Title_Code
		Inner Join Platform p On nsub.Platform_Code = p.Platform_Code
		Inner Join Country c On nsub.Country_Code = c.Country_Code
		Where Is_Available = 'N'

		TRUNCATE TABLE #TempCombination_Session
		TRUNCATE TABLE #TempCombination

		DROP TABLE #Min_Right_Start_Date
		DROP TABLE #NA_Country
		DROP TABLE #Acq_Country
		DROP TABLE #Temp_Acq_Country

		DROP TABLE #Temp_Country
		DROP TABLE #Temp_Acq_Platform			
		DROP TABLE #Temp_Platforms
		DROP TABLE #NA_Platforms
		DROP TABLE #Acq_Avail_Title_Eps
		DROP TABLE #Title_Not_Acquire
		DROP TABLE #Acq_Deal_Rights	
		DROP TABLE #Acq_Titles_With_Rights
		DROP TABLE #Acq_Titles
		DROP TABLE #Temp_NA_Title

		FETCH NEXT FROM EUR_Rights INTO @IntCode, @TitleCode, @EpisodeStart, @EpisodeEnd, @StartDate, @EndDate, @CountryCodes, @PlatformCodes, @DubbingCodes, @SubtitlingCodes
	END
	CLOSE EUR_Rights
	DEALLOCATE EUR_Rights

	SELECT DISTINCT IntCode, TitleName, TitleCode, EpisodeStart, EpisodeEnd, PlatformName, PlatformCode, CountryName, CountryCode, StartDate, EndDate, ErrorMessage 
	FROM #TempRightsError
	
	DROP TABLE #Temp_Episode_No
	DROP TABLE #Deal_Right_Title_WithEpsNo
	DROP TABLE #TempCombination
	DROP TABLE #TempCombination_Session
	DROP TABLE #TempRightsError
	
if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPRUR_VALIDATE_Content]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO
PRINT N'Creating [dbo].[USP_Acq_SUPP_Tab]...';


GO
CREATE Procedure [dbo].[USP_Acq_SUPP_Tab](@Supplementary_Tab_Code INT)
As
Begin
	select supplementary_name, Control_Type,Is_Mandatory,Is_Multiselect,Max_Length,Page_Control_Order,Control_Field_Order,Supplementary_Config_Code, 
	sc.View_Name,Text_Field, Value_Field, Whr_Criteria from supplementary_config sc
	inner join Supplementary_Tab st on st.Supplementary_Tab_Code = sc.Supplementary_Tab_Code
	inner join supplementary s on s.Supplementary_Code = sc.Supplementary_Code
	where sc.Supplementary_Tab_Code = @Supplementary_Tab_Code and Is_Active='Y'
End
GO
PRINT N'Creating [dbo].[USP_Acq_Supplementary_Delete_Title]...';


GO
Create Procedure USP_Acq_Supplementary_Delete_Title(@SupplementaryCode int)
As
Begin
	delete from [dbo].[Acq_Deal_Supplementary_detail] where Acq_Deal_Supplementary_Code = @SupplementaryCode
	delete from [dbo].[Acq_Deal_Supplementary] where Acq_Deal_Supplementary_Code = @SupplementaryCode
End
GO
PRINT N'Creating [dbo].[USP_Ancillary_Validate_Syn_Udt]...';


GO
CREATE Procedure [dbo].[USP_Ancillary_Validate_Syn_Udt]	
	@Ancillary_Title [Ancillary_Title] READONLY,
	@Ancillary_Platform [Ancillary_Platform] READONLY,
	@Ancillary_Platform_Medium [Ancillary_Platform_Medium] READONLY,
	@Ancillary_Type_code INT,
	@Catch_Up_From VARCHAR(1),
	@Syn_Deal_Ancillary_Code INT,
	@Syn_Deal_Code INT
AS
-- =============================================
-- Author:		Rahul Kembhavi
-- Create Date: 19-May-2022
-- Description:	Syn Ancillary Validations RnD WITH UDT
-- Last Updated Date: 19-May-2022
-- Last Updated By: Rahul Kembhavi
-- =============================================
BEGIN



   Declare @Loglavel int;
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_Ancillary_Validate_Udt]', 'Step 1', 0, 'Started Procedure', 0, ''
	SET FMTONLY OFF
	SET ANSI_NULLS ON

	IF OBJECT_ID('tempdb..#Adv_Acq_Ancillary_Validate_UDT') IS NOT NULL
		DROP TABLE #Adv_Acq_Ancillary_Validate_UDT
	IF OBJECT_ID('tempdb..#Acq_Ancillary_Validate_UDT') IS NOT NULL
		DROP TABLE #Acq_Ancillary_Validate_UDT

	DECLARE @System_Parameter_New CHAR(1) = 'N'
	SELECT @System_Parameter_New = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_Ancillary_Advanced'

	IF(@System_Parameter_New <> 'N')
	BEGIN
		CREATE TABLE #Adv_Acq_Ancillary_Validate_UDT
		(
			[Syn_Deal_Ancillary_Code] [int] NULL,
			[Title_Code] [int] NULL,
			[Platform_Code] [int] NULL
		)
		INSERT INTO #Adv_Acq_Ancillary_Validate_UDT
		SELECT 
			AT.Deal_Ancillary_Code,
			AT.Title_Code,
			AP.Platform_Code
		FROM @Ancillary_Title AT 	
		LEFT JOIN @Ancillary_Platform AP ON AP.Deal_Ancillary_Code=AT.Deal_Ancillary_Code
		
		Select COUNT(A.Title_Code) dup_Count
		FROM (
			Select  
				ADAT.Syn_Deal_Ancillary_Code,
				ADAT.Title_Code,
				0 AS [Platform_Code]
			 FROM Syn_Deal_Ancillary ADA	
			Inner Join Syn_Deal_Ancillary_Title	ADAT ON ADA.Syn_Deal_Ancillary_Code=ADAT.Syn_Deal_Ancillary_Code
			--Inner Join Syn_Deal_Ancillary_Platform ADAP ON ADA.Syn_Deal_Ancillary_Code=ADAP.Syn_Deal_Ancillary_Code
			WHERE ADA.Ancillary_Type_code = @Ancillary_Type_code --AND ISNULL(ADA.Catch_Up_From,'') = ISNULL(@Catch_Up_From,'')
			AND ADA.Syn_Deal_Ancillary_Code <> @Syn_Deal_Ancillary_Code
			AND ADA.Syn_Deal_Code=@Syn_Deal_Code
		) AS A
		INNER JOIN #Adv_Acq_Ancillary_Validate_UDT UDT ON 
		A.Title_Code=UDT.Title_Code --AND A.Ancillary_Platform_code = UDT.Platform_Code
	END
	ELSE
	BEGIN
		CREATE TABLE #Acq_Ancillary_Validate_UDT
		(
			[Acq_Deal_Ancillary_Code] [int] NULL,
			[Title_Code] [int] NULL,
			[Ancillary_Platform_Code] [int] NULL,
			[Ancillary_Platform_Medium_Code] [int] NULL
		)
		INSERT INTO #Acq_Ancillary_Validate_UDT
		SELECT 
			AT.Deal_Ancillary_Code,
			AT.Title_Code,
			AP.Ancillary_Platform_Code,
			APM.Ancillary_Platform_Medium_Code
		FROM @Ancillary_Title AT 	
		INNER JOIN @Ancillary_Platform AP ON AP.Deal_Ancillary_Code=AT.Deal_Ancillary_Code
		--LEFT JOIN  @Ancillary_Platform_Medium APM ON AP.Deal_Ancillary_Code=AT.Deal_Ancillary_Code
		LEFT JOIN  (
			SELECT X.Ancillary_Platform_Code,X.Ancillary_Platform_Medium_Code 
			FROM @Ancillary_Platform_Medium X
			INNER JOIN Ancillary_Platform_Medium APMM ON X.Ancillary_Platform_Medium_Code=APMM.Ancillary_Platform_Medium_Code
			AND X.Deal_Ancillary_Code=@Syn_Deal_Ancillary_Code
		)APM 
		ON APM.Ancillary_Platform_Code=Ap.Ancillary_Platform_Code
		
		Select COUNT(A.Title_Code) dup_Count
		FROM (
			Select 
				ADAT.Acq_Deal_Ancillary_Code,
				ADAT.Title_Code,
				ADAP.Ancillary_Platform_Code,
				ADAPM.Ancillary_Platform_Medium_Code
			 FROM Acq_Deal_Ancillary ADA	
			Inner Join Acq_Deal_Ancillary_Title	ADAT ON ADA.Acq_Deal_Ancillary_Code=ADAT.Acq_Deal_Ancillary_Code
			Inner Join Acq_Deal_Ancillary_Platform ADAP ON ADA.Acq_Deal_Ancillary_Code=ADAP.Acq_Deal_Ancillary_Code
			--LEFT Join Acq_Deal_Ancillary_Platform_Medium ADAPM ON  ADAP.Acq_Deal_Ancillary_Platform_Code=ADAPM.Acq_Deal_Ancillary_Platform_Code
			LEFT JOIN  (
				SELECT Y.Acq_Deal_Ancillary_Code,Y.Ancillary_Platform_Code,X.Ancillary_Platform_Medium_Code 
				FROM Acq_Deal_Ancillary_Platform Y 
				INNER JOIN Acq_Deal_Ancillary_Platform_Medium  X ON X.Acq_Deal_Ancillary_Platform_Code=Y.Acq_Deal_Ancillary_Platform_Code 
				INNER JOIN Ancillary_Platform_Medium APMM ON X.Ancillary_Platform_Medium_Code=APMM.Ancillary_Platform_Medium_Code			
			) ADAPM 
			ON ADAPM.Ancillary_Platform_Code=ADAP.Ancillary_Platform_Code AND ADAPM.Acq_Deal_Ancillary_Code=ADA.Acq_Deal_Ancillary_Code
			WHERE ADA.Ancillary_Type_code = @Ancillary_Type_code AND ISNULL(ADA.Catch_Up_From,'') = ISNULL(@Catch_Up_From,'')
			AND ADA.Acq_Deal_Ancillary_Code<>@Syn_Deal_Ancillary_Code	
			AND ADA.Acq_Deal_Code=@Syn_Deal_Code
		) AS A
		INNER JOIN #Acq_Ancillary_Validate_UDT UDT ON 
		--(A.Title_Code=UDT.Title_Code AND A.Ancillary_Platform_code = UDT.Ancillary_Platform_Code )OR 
		(ISNULL(A.Ancillary_Platform_Medium_Code, 0)=IsNull(UDT.Ancillary_Platform_Medium_Code, 0) AND A.Title_Code=UDT.Title_Code AND A.Ancillary_Platform_code = UDT.Ancillary_Platform_Code)
	END

	IF OBJECT_ID('tempdb..#Acq_Ancillary_Validate_UDT') IS NOT NULL DROP TABLE #Acq_Ancillary_Validate_UDT
	IF OBJECT_ID('tempdb..#Adv_Acq_Ancillary_Validate_UDT') IS NOT NULL DROP TABLE #Adv_Acq_Ancillary_Validate_UDT
	
if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_Ancillary_Validate_Udt]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
GO
PRINT N'Creating [dbo].[USP_Get_Edit_Row]...';


GO
CREATE Procedure [dbo].[USP_Get_Edit_Row](@Acq_Deal_Supplementary_Code int, @Row_Num int, @Tab_SM varchar(20))
As
Begin
	Declare @tab_code int
	select @tab_code = Supplementary_tab_code from Supplementary_Tab where Short_Name=@Tab_SM

	select Supplementary_Data_Code, User_Value, Row_Num, DSD.Supplementary_Config_Code, Supplementary_Code, 
	DSD.Supplementary_Tab_Code, Control_Type, Is_Mandatory, Is_Multiselect, Max_Length, Control_Field_Order, View_Name, Whr_Criteria 
	from [dbo].[Acq_Deal_Supplementary] DS
	inner Join [dbo].[Acq_Deal_Supplementary_detail] DSD on DSD.Acq_Deal_Supplementary_Code = DS.Acq_Deal_Supplementary_Code
	inner join [dbo].[Supplementary_Config] SC on SC.Supplementary_Config_Code = DSD.Supplementary_Config_Code
	where DSD.Row_Num = @Row_Num and DS.Acq_Deal_Supplementary_Code = @Acq_Deal_Supplementary_Code and DSD.Supplementary_Tab_Code = @Tab_code
End
GO
PRINT N'Creating [dbo].[USP_GET_TITLE_FOR_SUPPLEMENTARY]...';


GO
CREATE PROCEDURE [dbo].[USP_GET_TITLE_FOR_SUPPLEMENTARY]
	@ACQ_DEAL_CODE int, @title_Code int = 0
AS
BEGIN	
	if(@title_Code = 0 )
	Begin
		SELECT  DISTINCT T.Title_Code,T.Title_Name FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code 
		INNER JOIN Title T ON T.Title_Code =  ADM.Title_Code
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Acq_Deal_Code = @ACQ_DEAL_CODE
		And T.Title_code not in (select Title_code from Acq_Deal_Supplementary where Acq_Deal_code = @ACQ_DEAL_CODE)
	End
	ELSE
	Begin
		SELECT  DISTINCT T.Title_Code,T.Title_Name FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code 
		INNER JOIN Title T ON T.Title_Code =  ADM.Title_Code
		WHERE  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Acq_Deal_Code = @ACQ_DEAL_CODE
		And T.Title_code = @title_Code
	End
END
GO
PRINT N'Creating [dbo].[USP_SUPP_Create_Table]...';


GO
CREATE PROCEDURE [dbo].[USP_SUPP_Create_Table](@tabCode INT=1, @Acq_Deal_Code int, @Title_Code varchar(max), @View varchar(10))
AS
BEGIN
	SET NOCOUNT ON
	SET FMTONLY OFF

	DECLARE @Acq_Deal_Supplementary_Detail_Code int, @Acq_Deal_Supplementary_Code int, @Supplementary_Tab_Code int, @Supplementary_Config_Code int, @Supplementary_Data_Code varchar(1000), 
	@User_Value varchar(max), @Row_Num int, @Supplementary_Data varchar(max), @Final_String varchar(max)='', @i int = 0, @prevrow int = 0, @Short_Name varchar(10)=''

	SELECT @Short_Name = Short_Name from Supplementary_Tab where Supplementary_Tab_Code = @tabCode
	
	DECLARE cur_Table CURSOR FOR 
	SELECT Acq_Deal_Supplementary_Detail_Code, ads.Acq_Deal_Supplementary_Code, Supplementary_Tab_Code, Supplementary_Config_Code, Supplementary_Data_Code, User_Value, Row_Num FROM 
	Acq_Deal_Supplementary ads
	inner join Acq_Deal_Supplementary_detail adsd on adsd.Acq_Deal_Supplementary_Code = ads.Acq_Deal_Supplementary_Code
	WHERE Supplementary_Tab_Code = @tabCode and ads.Acq_Deal_Code = @Acq_Deal_Code and ads.Title_code in (select number from fn_Split_withdelemiter(@Title_Code,','))

	OPEN cur_Table

	FETCH NEXT FROM cur_Table INTO @Acq_Deal_Supplementary_Detail_Code, @Acq_Deal_Supplementary_Code, @Supplementary_Tab_Code, @Supplementary_Config_Code, @Supplementary_Data_Code, 
	@User_Value, @Row_Num

	WHILE @@FETCH_STATUS = 0  
	BEGIN
		IF(@Row_Num != @prevrow)
		BEGIN
			SELECT @i = @i +1
			SELECT @prevrow = @Row_Num
			SELECT @Final_String = @Final_String + '<Tr id="'+ @Short_Name + Convert(varchar,@Row_Num) +'" name="' + @Short_Name + Convert(varchar,@Row_Num) + '">' 
		END
		
		print @Supplementary_Data_Code 

		if (@Supplementary_Data_Code !='' And isnull(@User_Value , '')='')
		BEGIN
			select @Supplementary_Data = Stuff(
			(SELECT ', ' + s.Data_Description FROM Supplementary_Data s where Supplementary_Data_Code in (SELECT number FROM [fn_Split_withdelemiter](@Supplementary_Data_Code,',')) FOR XML PATH('')), 1, 2, '') 

			select @Final_String = @Final_String + '<TD>' + @Supplementary_Data + '</TD>'
		END

		if (isnull(@Supplementary_Data_Code, '')='' And @User_Value != '' And @User_Value is not null)
		BEGIN
			select @Final_String = @Final_String + '<TD>' + @User_Value + '</TD>'
		END

		if isnull(@Supplementary_Data_Code,'')= '' And isnull(@User_Value ,'')=''
		BEGIN
			select @Final_String = @Final_String + '<TD>&nbsp;</TD>'
		END

		FETCH NEXT FROM cur_Table INTO @Acq_Deal_Supplementary_Detail_Code, @Acq_Deal_Supplementary_Code, @Supplementary_Tab_Code, @Supplementary_Config_Code, @Supplementary_Data_Code, 
		@User_Value, @Row_Num
		
		IF(@Row_Num != @prevrow and @View <> 'VIEW')
		SELECT @Final_String = @Final_String + '<TD><a id="E'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Edit" class="glyphicon glyphicon-pencil" onclick="SuppEdit(this,'+ Convert(varchar,@Acq_Deal_Supplementary_Code)+','+ Convert(varchar,@prevrow)+','+ Convert(varchar,@i)+');"></a><a id="D'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Delete" class="glyphicon glyphicon-trash" onclick="SuppDelete(this,'+ Convert(varchar,@Acq_Deal_Supplementary_Code)+','+ Convert(varchar,@prevrow)+','+ Convert(varchar,@i)+','+ CONVERT(varchar,@tabCode)+','''+ CONVERT(varchar,@Short_Name) +''');"></a></TD></Tr>' 
		print @Final_String
	END

	IF(Len(@Final_String) > 0 and @View <> 'VIEW' )
		SELECT @Final_String = @Final_String + '<TD><a id="E'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Edit" class="glyphicon glyphicon-pencil" onclick="SuppEdit(this,'+ Convert(varchar,@Acq_Deal_Supplementary_Code)+','+ Convert(varchar,@Row_Num)+','+ Convert(varchar,@i)+');"></a><a id="D'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Delete" class="glyphicon glyphicon-trash" onclick="SuppDelete(this,'+ Convert(varchar,@Acq_Deal_Supplementary_Code)+','+ Convert(varchar,@Row_Num)+','+ Convert(varchar,@i)+','+ CONVERT(varchar,@tabCode)+','''+ CONVERT(varchar,@Short_Name)+''');"></a></TD></Tr>' 


	CLOSE cur_Table
	Deallocate cur_Table

	SELECT @Final_String AS Tab
	
END
GO
PRINT N'Creating [dbo].[USP_Supplementary_List]...';


GO
CREATE Procedure [dbo].[USP_Supplementary_List](@Deal_Code int, @Title_Code varchar(max))
As
Begin
	SET NOCOUNT ON
	SET FMTONLY OFF

	Create Table #Supplementary_List_vertical
	(
		Title_Code int,
		Supplementary_code int,
		SocialMedia nvarchar(10) null,
		Commitments nvarchar(10) null,
		OpeningClosingCredits nvarchar(10) null,
		EssentialClauses nvarchar(10) null
	)

	Create Table #Supplementary_List
	(
		Title_Code int,
		Supplementary_code int,
		tab_count int,
		Supplementary_Tab_Code int,
		Supplementary_Tab_Description varchar(100) null,
		Tab_Result nvarchar(10) null,
	)

	insert into #Supplementary_List (Title_Code,Supplementary_Code,tab_count,Supplementary_Tab_Code,Supplementary_Tab_Description,Tab_Result)
	SELECT Title_code, ds.Acq_Deal_Supplementary_Code, COUNT(Number) AS tab_count, dsd.Supplementary_Tab_Code, st.Supplementary_Tab_Description, '' 
	from Acq_Deal_Supplementary ds  
	inner join Acq_Deal_Supplementary_detail dsd on dsd.Acq_Deal_Supplementary_Code = ds.Acq_Deal_Supplementary_Code
	inner join Supplementary_tab st on st.Supplementary_Tab_Code = dsd.Supplementary_Tab_Code and ds.Acq_Deal_Code = @Deal_Code AND ISNULL(dsd.Supplementary_Data_Code, '') <> ''
	CROSS APPLY [dbo].[fn_Split_withdelemiter](dsd.Supplementary_Data_Code, ',') 
	GROUP BY ds.Acq_Deal_Supplementary_Code, Title_code, dsd.Supplementary_Tab_Code, st.Supplementary_Tab_Description

	--SELECT Title_code, ds.Acq_Deal_Supplementary_Code, count(dsd.Supplementary_Tab_Code) tab_count, dsd.Supplementary_Tab_Code, st.Supplementary_Tab_Description,'' from Acq_Deal_Supplementary ds  
	--inner join Acq_Deal_Supplementary_detail dsd on dsd.Acq_Deal_Supplementary_Code = ds.Acq_Deal_Supplementary_Code
	--inner join Supplementary_tab st on st.Supplementary_Tab_Code = dsd.Supplementary_Tab_Code
	--and ds.Acq_Deal_Code = @Deal_Code --and ds.Title_code in (select number from fn_Split_withdelemiter(@Title_Code,','))
	--GROUP BY ds.Acq_Deal_Supplementary_Code, Title_code, dsd.Supplementary_Tab_Code, st.Supplementary_Tab_Description

	Update #Supplementary_List set Tab_Result = (select case when tab_count > 0 then 'Yes'  else 'No' end) where Supplementary_Tab_Description = 'Social Media'
	Update #Supplementary_List set Tab_Result = (select case when tab_count > 0 then 'Yes'  else 'No' end) where Supplementary_Tab_Description = 'Commitments'
	Update #Supplementary_List set Tab_Result = (select case when tab_count = (select isnull(count(*),0) from Supplementary_Data where Supplementary_Type='CR') then 'All' else 'Partial' end)
	where Supplementary_Tab_Description = 'Opening & Closing Credits'
	Update #Supplementary_List set Tab_Result = (select case when tab_count = (select isnull(count(*),0) from Supplementary_Data where Supplementary_Type='CL') then 'All' else 'Partial' end)
	where Supplementary_Tab_Description = 'Essential Clauses'
	
	insert into #Supplementary_List_vertical (Title_Code, Supplementary_code) select distinct Title_Code,Supplementary_code from #Supplementary_List

	Update slv set SocialMedia = sl.tab_result from #Supplementary_List_vertical slv
	inner join #Supplementary_List sl on sl.supplementary_code = slv.Supplementary_code and slv.Title_Code = sl.Title_Code 
	where sl.Supplementary_Tab_Description = 'Social Media'

	Update slv set Commitments = sl.tab_result from #Supplementary_List_vertical slv
	inner join #Supplementary_List sl on sl.supplementary_code = slv.Supplementary_code and slv.Title_Code = sl.Title_Code 
	where sl.Supplementary_Tab_Description = 'Commitments'
	
	Update slv set OpeningClosingCredits = sl.tab_result from #Supplementary_List_vertical slv
	inner join #Supplementary_List sl on sl.supplementary_code = slv.Supplementary_code and slv.Title_Code = sl.Title_Code 
	where sl.Supplementary_Tab_Description = 'Opening & Closing Credits'

	Update slv set EssentialClauses = sl.tab_result from #Supplementary_List_vertical slv
	inner join #Supplementary_List sl on sl.supplementary_code = slv.Supplementary_code and slv.Title_Code = sl.Title_Code 
	where sl.Supplementary_Tab_Description = 'Essential Clauses'
	
	UPDATE #Supplementary_List_vertical SET SocialMedia = 'No' WHERE ISNULL(SocialMedia, '') = ''
	UPDATE #Supplementary_List_vertical SET Commitments = 'No' WHERE ISNULL(Commitments, '') = ''
	UPDATE #Supplementary_List_vertical SET OpeningClosingCredits = 'No' WHERE ISNULL(OpeningClosingCredits, '') = ''
	UPDATE #Supplementary_List_vertical SET EssentialClauses = 'No' WHERE ISNULL(EssentialClauses, '') = ''

	select T.title_name, ISNULL(slv.SocialMedia, 'No') AS SocialMedia, ISNULL(Commitments, 'No') AS Commitments, ISNULL(OpeningClosingCredits, 'No') AS OpeningClosingCredits, ISNULL(EssentialClauses, 'No') AS EssentialClauses, t.title_code, Supplementary_code  
	from #Supplementary_List_vertical slv
	inner join Title t on t.title_code = slv.Title_code

	drop table #Supplementary_List_vertical 
	drop table #Supplementary_List
END
GO
PRINT N'Creating Permission...';


GO
DENY UPDATE
    ON OBJECT::[dbo].[System_Module_Message] TO [dbserver2012] CASCADE
    AS [dbo];


GO
PRINT N'Refreshing [dbo].[UFN_Get_Indiacast_Report_Country]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[UFN_Get_Indiacast_Report_Country]';


GO
PRINT N'Refreshing [dbo].[USPITGetSearchSequence]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetSearchSequence]';


GO
PRINT N'Refreshing [dbo].[USPITGetSynSearchCriteria]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetSynSearchCriteria]';


GO
PRINT N'Refreshing [dbo].[USP_UpdateParentHIDCodeForSameTitle]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_UpdateParentHIDCodeForSameTitle]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Unutilized_Run]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Unutilized_Run]';


GO
PRINT N'Refreshing [dbo].[USP_INSERT_ACQ_DEAL]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_INSERT_ACQ_DEAL]';


GO
PRINT N'Refreshing [dbo].[USP_Syndication_Deal_List_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syndication_Deal_List_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Report_AcqSyn_Expiry]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Report_AcqSyn_Expiry]';


GO
PRINT N'Refreshing [dbo].[USP_Report_PlatformWise_Acquisition_Neo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Report_PlatformWise_Acquisition_Neo]';


GO
PRINT N'Refreshing [dbo].[USP_Acquition_Deal_List_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acquition_Deal_List_Report]';


GO
PRINT N'Refreshing [dbo].[USP_GET_TITLE_DATA]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_GET_TITLE_DATA]';


GO
PRINT N'Refreshing [dbo].[Usp_Deal_Pending_Execution_Mail]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Usp_Deal_Pending_Execution_Mail]';


GO
PRINT N'Refreshing [dbo].[USP_Send_Mail_WBS_Linked_Titles]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Send_Mail_WBS_Linked_Titles]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rev_HB_Duplication_UDT_Acq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rev_HB_Duplication_UDT_Acq]';


GO
PRINT N'Refreshing [dbo].[USP_Populate_Music]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Populate_Music]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Deal_Title_Platform_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Deal_Title_Platform_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_And_Save_Assigned_Music_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_And_Save_Assigned_Music_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_List_Rights]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Rights]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Autopush_Rights_Validation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Autopush_Rights_Validation]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Deal_Title_Platform_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Deal_Title_Platform_Report]';


GO
PRINT N'Refreshing [dbo].[USP_Integration_Generate_XML]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Integration_Generate_XML]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rights_Duplication_UDT_Syn_New]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rights_Duplication_UDT_Syn_New]';


GO
PRINT N'Refreshing [dbo].[USP_Import_SubDeal_Insert]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Import_SubDeal_Insert]';


GO
PRINT N'Refreshing [dbo].[USP_INSERT_SYN_DEAL]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_INSERT_SYN_DEAL]';


GO
PRINT N'Refreshing [dbo].[USP_RightsU_Health_Checkup]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_RightsU_Health_Checkup]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Migrate_Syndication]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Migrate_Syndication]';


GO
PRINT N'Refreshing [dbo].[USP_AutoPushAcqDeal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_AutoPushAcqDeal]';


GO
PRINT N'Refreshing [dbo].[USP_Workflow_Reminder_Mail]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Workflow_Reminder_Mail]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rights_Duplication_UDT_Acq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rights_Duplication_UDT_Acq]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_SDM_Title]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_SDM_Title]';


GO
PRINT N'Refreshing [dbo].[Avail_GetTitlesToProcessList]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Avail_GetTitlesToProcessList]';


GO
PRINT N'Refreshing [dbo].[Avail_GetTitlesToProcessListNeo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[Avail_GetTitlesToProcessListNeo]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Bulk_Update]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Bulk_Update]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Deal_Rights_Validate]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Deal_Rights_Validate]';


GO
PRINT N'Refreshing [dbo].[USP_Ancillary_Validate_Udt]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Ancillary_Validate_Udt]';


GO
PRINT N'Refreshing [dbo].[USP_Content_Music_Link_Bulk_Insert_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Content_Music_Link_Bulk_Insert_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Content_Music_PIII]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Content_Music_PIII]';


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
PRINT N'Refreshing [dbo].[USP_Deal_WF_Pending_Automated_Email]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Deal_WF_Pending_Automated_Email]';


GO
PRINT N'Refreshing [dbo].[USP_DealReport_Filter]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DealReport_Filter]';


GO
PRINT N'Refreshing [dbo].[USP_DM_Music_Title_PIII]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DM_Music_Title_PIII]';


GO
PRINT N'Refreshing [dbo].[USP_DM_Title_PIII]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DM_Title_PIII]';


GO
PRINT N'Refreshing [dbo].[USP_DM_Title_PIV]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DM_Title_PIV]';


GO
PRINT N'Refreshing [dbo].[USP_Email_Pending_Execution]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Email_Pending_Execution]';


GO
PRINT N'Refreshing [dbo].[USP_Email_Run_Expiry]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Email_Run_Expiry]';


GO
PRINT N'Refreshing [dbo].[USP_Email_Run_Utilization]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Email_Run_Utilization]';


GO
PRINT N'Refreshing [dbo].[USP_Export_Table_To_Excel]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Export_Table_To_Excel]';


GO
PRINT N'Refreshing [dbo].[USP_Gen_Pro_Title_Content]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Gen_Pro_Title_Content]';


GO
PRINT N'Refreshing [dbo].[USP_Generate_Title_Content]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Generate_Title_Content]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Acq_PreReq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Acq_PreReq]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Dashboard_Data]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Dashboard_Data]';


GO
PRINT N'Refreshing [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_GET_DATA_FOR_APPROVED_TITLES]';


GO
PRINT N'Refreshing [dbo].[USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_GET_DATA_FOR_APPROVED_TITLES_FOR_SYN_PUSHBACK]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Login_Details]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Login_Details]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Syn_PreReq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Syn_PreReq]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_Avail_Language_Data]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_Avail_Language_Data]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_Avail_Language_Data_Show]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_Avail_Language_Data_Show]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Title_PreReq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Title_PreReq]';


GO
PRINT N'Refreshing [dbo].[USP_GetPromoterCodes]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_GetPromoterCodes]';


GO
PRINT N'Refreshing [dbo].[USP_Insert_Music_Title_Import_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Insert_Music_Title_Import_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_List_Content]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_Content]';


GO
PRINT N'Refreshing [dbo].[USP_List_DM_Master_Import]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_List_DM_Master_Import]';


GO
PRINT N'Refreshing [dbo].[USP_Lock_Refresh_Release_Record]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Lock_Refresh_Release_Record]';


GO
PRINT N'Refreshing [dbo].[USP_Music_Deal_Link_Show]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Music_Deal_Link_Show]';


GO
PRINT N'Refreshing [dbo].[USP_Music_Deal_Schedule_Validation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Music_Deal_Schedule_Validation]';


GO
PRINT N'Refreshing [dbo].[USP_Music_Schedule_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Music_Schedule_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Music_Schedule_Process_Neo]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Music_Schedule_Process_Neo]';


GO
PRINT N'Refreshing [dbo].[USP_PopulateContent]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_PopulateContent]';


GO
PRINT N'Refreshing [dbo].[USP_Provisional_Title_Content_Generation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Provisional_Title_Content_Generation]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_AsRun_Exception_Report]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_AsRun_Exception_Report]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_PrimeException_Email]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_PrimeException_Email]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Reject_File]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Reject_File]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_SendException_Userwise_Email]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_SendException_Userwise_Email]';


GO
PRINT N'Refreshing [dbo].[USP_Search_Run_Shows]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Search_Run_Shows]';


GO
PRINT N'Refreshing [dbo].[USP_SendMail_AskExpert]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_SendMail_AskExpert]';


GO
PRINT N'Refreshing [dbo].[USP_SendMail_Page_Crashed]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_SendMail_Page_Crashed]';


GO
PRINT N'Refreshing [dbo].[USP_SendMail_To_NextApprover_New]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_SendMail_To_NextApprover_New]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Deal_Rights_Error_Details_Mail]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Deal_Rights_Error_Details_Mail]';


GO
PRINT N'Refreshing [dbo].[USP_Title_Details_Report_Filter]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Title_Details_Report_Filter]';


GO
PRINT N'Refreshing [dbo].[USP_Title_Objection_PreReq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Title_Objection_PreReq]';


GO
PRINT N'Refreshing [dbo].[USP_Trademark_Expiry]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Trademark_Expiry]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Content_Music_Import]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Content_Music_Import]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Delay_Rights_Duplication_Acq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Delay_Rights_Duplication_Acq]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Perpetuity_Rights_Duplication_Acq]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Perpetuity_Rights_Duplication_Acq]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rollback]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rollback]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Title_Import]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Title_Import]';


GO
PRINT N'Refreshing [dbo].[USP_VALIDATE_TITLES_FOR_YEARWISE_RUN]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_VALIDATE_TITLES_FOR_YEARWISE_RUN]';


GO
PRINT N'Refreshing [dbo].[USPDealExpiryMailForTitleMilestone]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPDealExpiryMailForTitleMilestone]';


GO
PRINT N'Refreshing [dbo].[USPExportToExcelBulkImport]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPExportToExcelBulkImport]';


GO
PRINT N'Refreshing [dbo].[USPGetDashBoardNeoData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPGetDashBoardNeoData]';


GO
PRINT N'Refreshing [dbo].[USPGetRURContentMappedData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPGetRURContentMappedData]';


GO
PRINT N'Refreshing [dbo].[USPITGetAssetsData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetAssetsData]';


GO
PRINT N'Refreshing [dbo].[USPITGetDasboardLanguages]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetDasboardLanguages]';


GO
PRINT N'Refreshing [dbo].[USPITGetDrillDownGenreWiseTitle]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetDrillDownGenreWiseTitle]';


GO
PRINT N'Refreshing [dbo].[USPITGetDrillDownLicensorWiseTitle]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetDrillDownLicensorWiseTitle]';


GO
PRINT N'Refreshing [dbo].[USPITGetGenreWiseTitle]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetGenreWiseTitle]';


GO
PRINT N'Refreshing [dbo].[USPITGetLicensorWiseTitle]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetLicensorWiseTitle]';


GO
PRINT N'Refreshing [dbo].[USPITGetTitleLanguage]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPITGetTitleLanguage]';


GO
PRINT N'Refreshing [dbo].[USPMailForExceedJobRunDuration]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USPMailForExceedJobRunDuration]';


GO
PRINT N'Refreshing [dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail_Indiacast]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Report_PlatformWise_Acquisition_Neo_Avail_Indiacast]';


GO
PRINT N'Refreshing [dbo].[USP_Email_Notification]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Email_Notification]';


GO
PRINT N'Refreshing [dbo].[USP_INSERT_SAP_WBS_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_INSERT_SAP_WBS_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rights_Duplication_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rights_Duplication_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Content_Music_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Content_Music_Schedule]';


GO
PRINT N'Refreshing [dbo].[USP_Get_Dashboard_Detail]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Get_Dashboard_Detail]';


GO
PRINT N'Refreshing [dbo].[USP_Deal_Expiry_Email_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Deal_Expiry_Email_Schedule]';


GO
PRINT N'Refreshing [dbo].[USP_Music_Title_Import_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Music_Title_Import_Schedule]';


GO
PRINT N'Refreshing [dbo].[USP_Title_Import_Schedule]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Title_Import_Schedule]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Bind_listbox_Bulk_Update]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Bind_listbox_Bulk_Update]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Bulk_Populate]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Bulk_Populate]';


GO
PRINT N'Refreshing [dbo].[USP_Multi_Music_Schedule_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Multi_Music_Schedule_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Music_Schedule_Exception_AutoResolver]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Music_Schedule_Exception_AutoResolver]';


GO
PRINT N'Refreshing [dbo].[USP_Schedule_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Schedule_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Schedule_Revert_Count]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Schedule_Revert_Count]';


GO
PRINT N'Refreshing [dbo].[USP_Provisional_Content_Data_Generation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Provisional_Content_Data_Generation]';


GO
PRINT N'Refreshing [dbo].[USP_Assign_Workflow]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Assign_Workflow]';


GO
PRINT N'Refreshing [dbo].[USP_Process_Workflow]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Process_Workflow]';


GO
PRINT N'Refreshing [dbo].[USP_Content_Music_PI]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Content_Music_PI]';


GO
PRINT N'Refreshing [dbo].[USP_DM_Music_Title_PI]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DM_Music_Title_PI]';


GO
PRINT N'Refreshing [dbo].[USP_RollBack_Syn_Deal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_RollBack_Syn_Deal]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_RUN_SAVE_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_RUN_SAVE_Process]';


GO
PRINT N'Refreshing [dbo].[USP_Syn_Termination_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Syn_Termination_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Bulk_Update_Validation]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Bulk_Update_Validation]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Bulk_Update_Final]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Bulk_Update_Final]';


GO
PRINT N'Refreshing [dbo].[USP_Acq_Termination_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Acq_Termination_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_Validate_Rights_Duplication_UDT_Syn]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Validate_Rights_Duplication_UDT_Syn]';


GO
PRINT N'Refreshing [dbo].[USP_AT_Acq_Deal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_AT_Acq_Deal]';


GO
PRINT N'Refreshing [dbo].[USP_DM_Title_PI]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_DM_Title_PI]';


GO
PRINT N'Refreshing [dbo].[USP_Insert_Title_Import_UDT]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Insert_Title_Import_UDT]';


GO
PRINT N'Refreshing [dbo].[USP_RollBack_Acq_Deal]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_RollBack_Acq_Deal]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Execute_Package_FolderWise]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Execute_Package_FolderWise]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_SendException_Email]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_SendException_Email]';


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
PRINT N'Refreshing [dbo].[usp_Schedule_FileError]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_FileError]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_PkgExecutionFail]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_PkgExecutionFail]';


GO
PRINT N'Refreshing [dbo].[USP_Deal_Rights_Process]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_Deal_Rights_Process]';


GO
PRINT N'Refreshing [dbo].[USP_MIGRATE_TO_NEW_Main]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[USP_MIGRATE_TO_NEW_Main]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Validate_Temp_BV_Sche]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Validate_Temp_BV_Sche]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_Mapped_titles]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_Mapped_titles]';


GO
PRINT N'Refreshing [dbo].[usp_Schedule_ReProcess]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_Schedule_ReProcess]';


GO
PRINT N'Checking existing data against newly created constraints';



GO
ALTER TABLE [dbo].[Supplementary_Config] WITH CHECK CHECK CONSTRAINT [FK_Supplementary_Config_Supplementary];

ALTER TABLE [dbo].[Supplementary_Config] WITH CHECK CHECK CONSTRAINT [FK_Supplementary_Config_Supplementary_Tab];

ALTER TABLE [dbo].[Acq_Deal_Supplementary_detail] WITH CHECK CHECK CONSTRAINT [FK_Acq_Deal_Supplementary_detail_Acq_Deal_Supplementary];


GO
PRINT N'Update complete.';


GO
