CREATE PROCEDURE [dbo].[USP_Music_Deal_List_Report]        
(        
	@Agreement_No varchar(100),        
	@MusicLabelCode varchar(500),        
	@start_Date varchar(50),        
	@End_Date varchar(50),        
	@Expired_Deal char(1),
	@SysLanguageCode INT
)        
AS        
BEGIN       
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Music_Deal_List_Report]', 'Step 1', 0, 'Started Procedure', 0, ''    
      
		--DECLARE 
		-- @Agreement_No varchar(100) = '',   
		-- @MusicLabelCode varchar(500) = '1', 
		-- @start_Date varchar(50) = '',      
		-- @End_Date varchar(50) = '',        
		-- @Expired_Deal char(1) = 'N',    
		-- @SysLanguageCode INT = 1

		 IF OBJECT_ID('tempdb..#TempMusicDealData') IS NOT NULL
			DROP TABLE #TempMusicDealData
	
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
			@Col_Head22 NVARCHAR(MAX) = ''	
		

		SELECT 
			Md.Agreement_No AS [Deal No], Cast(MD.Agreement_Date as date) AS [Agreement Date],        
			ML.Music_Label_Name AS [Music Label], MD.Description as [Description], E.Entity_Name AS [Licensee],         
			STUFF((        
				SELECT DISTINCT ', ' + CAST(V.Vendor_Name AS nvarchar(MAX))  FROM Vendor  V   (NOLOCK)      
				INNER JOIN Music_Deal_Vendor MDV  (NOLOCK) ON MD.Music_Deal_Code = MDV.Music_Deal_Code        
				WHERE MDv.Vendor_Code = V.Vendor_Code        
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')       
			AS [Licensor],   
			CAST(MD.Rights_Start_Date as date)  AS [Start Date],        
			CAST(MD.Rights_End_Date as date)  AS [End Date],        
			STUFF((        
				SELECT DISTINCT ', ' + CAST(ML.Language_Name AS VARCHAR)  FROM Music_Language  ML   (NOLOCK)      
				LEFT JOIN Music_Deal_Language MDL (NOLOCK) ON MD.Music_Deal_Code = MDL.Music_Deal_Code        
				WHERE MDL.Music_Language_Code = ML.Music_Language_Code        
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')       
			AS [Track Language],  
			RIGHT(CONVERT(CHAR(8),DATEADD(SECOND ,MD.Duration_Restriction,0),108),5) AS [Duration Restriction (MM:SS)],    
			CASE         
			WHEN MD.Run_Type = 'U' THEN 'Unlimited'
			ELSE CAST(MD.No_Of_Songs AS VARCHAR)         
			END AS [No of Songs],       
			CC.Channel_Category_Name As [Channel Category],      
			STUFF((        
				SELECT DISTINCT ', ' + CAST(C.Channel_Name AS VARCHAR)  FROM Channel C  (NOLOCK)       
				INNER JOIN Music_Deal_Channel MDC (NOLOCK) ON MD.Music_Deal_Code = MDC.Music_Deal_Code        
				WHERE MDC.Channel_Code = C.Channel_Code        
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')       
			AS [Channel],         
			CASE         
			WHEN MD.Channel_Type= 'C' THEN 'ChannelWise' ELSE 'Shared'         
			END AS [Channel Type],        
			MD.Agreement_Cost AS [Agreement Cost],        
			ISNULL(R.Right_Rule_Name,'Unlimited') AS [Right Rule],        
			CASE         
				WHEN MD.Link_Show_Type = 'AS' THEN 'All Shows'         
				WHEN MD.Link_Show_Type = 'AF' THEN 'All Fiction'        
				WHEN MD.Link_Show_Type = 'AN' THEN 'All Non fiction'        
				WHEN MD.Link_Show_Type = 'AE' THEN 'All Event'        
			ELSE        
			STUFF((        
				SELECT DISTINCT ', ' + CAST(T.Title_Name AS VARCHAR)  FROM Title T   (NOLOCK)      
				INNER JOIN Music_Deal_LinkShow MDLS (NOLOCK) ON MD.Music_Deal_Code= MDLS.Music_Deal_Code        
				WHERE MDLS.Title_Code = T.Title_Code        
				FOR XML PATH(''),root('MyString'), type ).value('/MyString[1]','nvarchar(max)'), 1, 2, '')        
			END AS [Linked Show],         
			BU.Business_Unit_Name AS [Bussiness Unit]  ,  
			MD.Reference_No As [Reference No],  
			MD.Remarks As Remarks,
			DT.Deal_Tag_Description AS [Status],
			[dbo].[UFN_Get_Platform_Name](MD.Music_Deal_Code, 'MD') Platform_Name 
		INTO #TempMusicDealData
		FROM Music_Deal MD  (NOLOCK)       
		INNER JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MD.Music_Label_Code        
		INNER JOIN Entity E (NOLOCK) ON E.Entity_Code = MD.Entity_Code         
		INNER JOIN Business_Unit BU (NOLOCK) ON BU.Business_Unit_Code = MD.Business_Unit_Code   
		LEFT JOIN Deal_Tag DT (NOLOCK) ON DT.Deal_Tag_Code = MD.Deal_Tag_Code
		LEFT JOIN Right_Rule R (NOLOCK) ON R.Right_Rule_Code = MD.Right_Rule_Code       
		LEFT JOIN Channel_Category CC (NOLOCK) ON CC.Channel_Category_Code = MD.Channel_Category_Code      
		WHERE (@Agreement_No = '' or MD.Agreement_No = @Agreement_No  )        
		AND (ISNULL(@MusicLabelCode,'') = '' OR (MD.Music_Label_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@MusicLabelCode,','))))        
		AND (        
			(        
			(ISNULL(CONVERT(date,md.Rights_Start_Date,103),'') >= CONVERT(date,@Start_Date,103)  OR @Start_Date = '' )        
			AND (ISNULL(CONVERT(date,MD.Rights_Start_Date,103),'') <= CONVERT(date,@End_Date,103) OR @End_Date = '' )        
		)        
		AND         
		(        
			(ISNULL(CONVERT(date,MD.Rights_End_Date,103),'') <=  CONVERT(date,@End_Date,103) OR @End_Date = '')         
			AND (ISNULL(CONVERT(date,MD.Rights_Start_Date,103),'') >= CONVERT(date,@Start_Date,103) OR @Start_Date = '' )        
		)        
		)        
		AND (@Expired_Deal ='Y' OR (CONVERT(datetime,MD.Rights_End_Date,1) >= GETDATE() AND @Expired_Deal ='N'))        
      

		SELECT 
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
		FROM System_Message SM  (NOLOCK)
		INNER JOIN System_Module_Message SMM (NOLOCK) ON SMM.System_Message_Code = SM.System_Message_Code  
		AND SM.Message_Key IN ('AgreementNo','AgreementDate','MusicLabel','Description','Licensee','Licensor','StartDate','EndDate','Platform','TrackLanguage',
		'DurationRestrictionHHMM','Noofsongs','ChannelCategory','Channel','ChannelType','AgreementCost','RightRule','LinkedShow','BusinessUnit','RestrictionRemarks','ReferenceNo', 'Status')  
		INNER JOIN System_Language_Message SLM  (NOLOCK) ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  

		IF EXISTS(SELECT TOP 1 * FROM #TempMusicDealData)
		BEGIN
			SELECT [Agreement No], [Agreement Date], [Music Label], [Description], [Licensee], [Licensor], [Start Date], [End Date], [Platform],
				[Track Language], [Duration Restriction], [No of Songs], [Channel Category], [Channel], [Channel Type], [Agreement Cost], [Right Rule], [Linked Show],
				[Bussiness Unit], [Restriction Remarks], [Reference No],[Status]
				FROM (
					SELECT
					sorter = 1,
					CAST([Deal No] AS NVARCHAR(MAX)) AS [Agreement No], 
					CONVERT(DATE,[Agreement Date],103) AS [Agreement Date], 
					CAST([Music Label] AS VARCHAR(100)) AS [Music Label],
					CAST([Description] AS NVARCHAR(MAX)) AS [Description], 
					CAST([Licensee] AS VARCHAR(100)) AS [Licensee], 
					CAST([Licensor] AS VARCHAR(100)) AS [Licensor],
					CONVERT(DATE,[Start Date], 103) AS [Start Date], 
					CONVERT(DATE,[End Date], 103) AS [End Date],
					CAST([Platform_Name] AS NVARCHAR(MAX)) AS [Platform],
					CAST([Track Language] AS VARCHAR(100)) AS [Track Language],
					CAST([Duration Restriction (MM:SS)] AS VARCHAR(100)) AS [Duration Restriction],
					CAST([No of Songs] AS VARCHAR(100)) AS [No of Songs],
					CAST([Channel Category] AS VARCHAR(100)) AS [Channel Category], 
					CAST([Channel] AS VARCHAR(100)) AS [Channel],
					CAST([Channel Type] AS VARCHAR(100)) AS [Channel Type],
					CAST([Agreement Cost] AS VARCHAR(100)) AS [Agreement Cost], 
					CAST([Right Rule] AS VARCHAR(100)) AS [Right Rule],
					CAST([Linked Show] AS VARCHAR(100)) AS [Linked Show],
					CAST([Bussiness Unit] AS VARCHAR(100)) AS [Bussiness Unit], 
					CAST([Remarks] AS NVARCHAR(MAX)) AS [Restriction Remarks],
					CAST([Reference No] AS VARCHAR(100)) AS [Reference No],
					CASt([Status] AS VARCHAR(100)) AS [Status]
					From #TempMusicDealData
					UNION ALL
						SELECT 0, @Col_Head01, GETDATE(), @Col_Head03, @Col_Head04, @Col_Head05, @Col_Head06, GETDATE(), GETDATE(), @Col_Head09, 
						@Col_Head10, @Col_Head11, @Col_Head12, @Col_Head13, @Col_Head14, @Col_Head15, @Col_Head16, @Col_Head17, @Col_Head18, @Col_Head19, @Col_Head20, @Col_Head21,@Col_Head22
					) X   
			ORDER BY Sorter
		END
		ELSE
		BEGIN
			SELECT * FROM #TempMusicDealData
		END

		IF OBJECT_ID('tempdb..#TempMusicDealData') IS NOT NULL DROP TABLE #TempMusicDealData
	 
	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Music_Deal_List_Report]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END
