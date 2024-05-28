CREATE PROCEDURE [dbo].[USP_Reports_Header_Data]
	@Module_Code INT,    
	@SysLanguageCode INT ,
	@CallFrom CHAR(1)
AS     
BEGIN  
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
END
