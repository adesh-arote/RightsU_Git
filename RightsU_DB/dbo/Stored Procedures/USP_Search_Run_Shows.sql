alter PROCEDURE [dbo].[USP_Search_Run_Shows]
	@searchCriteria VARCHAR(MAX),
	@Data_For_flag VARCHAR(2) ,
	@selectedDealMovieCodes VARCHAR(MAX) ,
	@selectedChannelNames NVARCHAR(MAX),	
	@selectedTitleCodes VARCHAR(MAX) , 
	@UnCheck_Run_Shows_Code VARCHAR(MAX),	
	@Run_Code INT = 0
AS
-- ==========================================================================================================
-- Author		: Rushabh V. Gohil
-- Creation Date: 12 Feb 2015
-- Updation Date: 02 Jul 2015
-- Description  : Brings list of Shows for a particular search criteria (Fiction/Non-fiction/Show/Channel)
-- ==========================================================================================================
BEGIN 	
	SET FMTONLY OFF
	SET NOCOUNT ON	 

	IF (@selectedChannelNames <> '')	 
		SELECT DISTINCT C.Channel_Code,C.Channel_Name  INTO #Temp_Channel_Codes 
		FROM Channel C WHERE  RTRIM(LTRIM(C.Channel_Name)) IN( SELECT RTRIM(LTRIM(NUmber)) from fn_Split_withdelemiter(@selectedChannelNames,','))	

	/* Channel Filter */
	CREATE TABLE #Temp_Run_Shows -- INSERT ONLY SELECT FROM ACQ_DEAL_RUN_SHOWS
	(
		Title_Code INT, 
		Acq_Deal_Run_Shows_Code INT,
		Acq_Deal_Movie_Code INT--,				
	)

	CREATE TABLE #Temp_Prog_Eps
	(
		Title_Code INT, 
		Acq_Deal_Run_Code INT,
		Acq_Deal_Run_Shows_Code INT,
		Acq_Deal_Movie_Code INT,				
		Episode_From INT,
		Episode_To INT,				
		Acq_Deal_Code INT,		
		Agreement_No VARCHAR(20),	
		Data_For	CHAR(1)
	)

	CREATE TABLE #Temp
	(
		Title_Code INT, 
		Acq_Deal_Run_Code INT,
		Acq_Deal_Run_Shows_Code INT,
		Acq_Deal_Movie_Code INT,
		Title_Name NVARCHAR(200),
		Episode_From INT,
		Episode_To INT,
		Channel_Name NVARCHAR(100),
		Acq_Deal_Code INT,
		Agreement_No VARCHAR(12),
		Ext_Column_Name NVARCHAR (50),
		Ext_Column_Value VARCHAR (50),
		Data_For varchar(1),
		Channel_Code INT,
		IS_Same_group CHAR(1)
	)

	CREATE TABLE #Temp2(
		Title_Code INT, 
		Acq_Deal_Run_Code INT,
		Acq_Deal_Run_Shows_Code INT,
		Acq_Deal_Movie_Code INT,
		Title_Name NVARCHAR(500),
		Episode_From INT,
		Episode_To INT,
		Channel_Name NVARCHAR(MAX),
		Acq_Deal_Code INT,
		Agreement_No VARCHAR(12),
		Ext_Column_Name NVARCHAR (50),
		Ext_Column_Value NVARCHAR (50),
		Is_Select CHAR(1),
		Data_For varchar(1)
	)		
	IF EXISTS(SELECT TOP  1 Acq_Deal_Run_Shows_Code FROM Acq_Deal_Run_Shows WHERE Acq_Deal_Run_Code = @Run_Code AND @Data_For_flag = '')
	BEGIN
		SELECT TOP 1 @Data_For_flag = Data_For FROM Acq_Deal_Run_Shows WHERE Acq_Deal_Run_Code = @Run_Code
		ORDER BY Data_For
		PRINT @Data_For_flag
	END	
	IF(@Data_For_flag <> '' OR @searchCriteria <> '')
	BEGIN	
	/************************************Program Wise*****************************************/	
	IF(@Data_For_flag = 'P')			
	BEGIN	
	PRINT 'P'	
	INSERT INTO #Temp_Run_Shows
	(
			Title_Code , 			
			Acq_Deal_Run_Shows_Code 
	)
	SELECT DISTINCT
		ADRS.Title_Code , 		
		ADRS.Acq_Deal_Run_Shows_Code 		
	FROM Acq_Deal_Run_Shows ADRS  
	WHERE  ADRS.Acq_Deal_Run_Code =  CAST(@Run_Code as nvarchar(20)) AND ADRS.Data_For= @Data_For_flag	
	INSERT INTO #Temp_Prog_Eps
	(
			Title_Code , 
			Acq_Deal_Run_Code ,				
			Data_For
	)	
	SELECT DISTINCT 
		ADRT.Title_Code,ADRT.Acq_Deal_Run_Code,@Data_For_flag AS Data_For
	FROM Acq_Deal_Run ADR
	INNER JOIN Acq_Deal_Run_Channel ADRC ON ADR.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code
		AND ADRC.Channel_Code IN(
				SELECT TC.Channel_Code FROM  #Temp_Channel_Codes  TC						
			)
	INNER JOIN Acq_Deal_Run_Title ADRT ON ADRC.Acq_Deal_Run_Code = ADRT.Acq_Deal_Run_Code			
	INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code=ADR.Acq_Deal_Code and  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 
		AND (AD.Deal_Type_Code=(SELECT TOP 1 Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Content')
			OR AD.Deal_Type_Code=(SELECT TOP 1 Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Format_Program'))					
		INSERT INTO #Temp
		(
			Title_Code , 
			Acq_Deal_Run_Code ,
			Acq_Deal_Run_Shows_Code ,
			Acq_Deal_Movie_Code ,				
			Episode_From ,
			Episode_To ,				
			Acq_Deal_Code,
			Agreement_No ,				
			Data_For ,
			Channel_Code ,
			IS_Same_group
		)
		SELECT DISTINCT 
			ADRT.Title_Code , 
			ADRT.Acq_Deal_Run_Code ,
			TS.Acq_Deal_Run_Shows_Code,
			0 AS Acq_Deal_Movie_Code ,				
			0 AS Episode_From ,
			0 AS Episode_To ,				
			0 AS Acq_Deal_Code,
			'' AS Agreement_No ,				
			@Data_For_flag AS Data_For,
			ADRC.Channel_Code,
			'Y' AS IS_Same_group
		FROM #Temp_Prog_Eps TS
		INNER JOIN Acq_Deal_Run_Title ADRT ON TS.Acq_Deal_Run_Code=ADRT.Acq_Deal_Run_Code AND  TS.Title_Code = ADRT.Title_Code 
		INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRT.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code 

								
		UPDATE #Temp SET #Temp.Acq_Deal_Run_Shows_Code =
		( 
			SELECT  DISTINCT TOP 1 Acq_Deal_Run_Shows_Code 
			FROM #Temp_Run_Shows T1 WHERE T1.Title_Code = #Temp.Title_Code			
			AND ISNULL(T1.Acq_Deal_Run_Shows_Code,0) > 0
		)
		--WHERE ISNULL(Acq_Deal_Run_Shows_Code,0) = 0

		DELETE FROM #Temp WHERE ISNULL(Acq_Deal_Run_Shows_Code,0) = 0 AND @searchCriteria = ''
		
	--END
	END
	/************************************Program with Episode Wise*****************************************/	
	IF(@Data_For_flag = 'E')
	BEGIN
		PRINT'E'	
		INSERT INTO #Temp_Run_Shows
		(
			--Title_Code , 
			--Acq_Deal_Run_Code ,
			Acq_Deal_Run_Shows_Code ,
			Acq_Deal_Movie_Code --,				
			--Episode_From ,
			--Episode_To ,				
			--Acq_Deal_Code ,			
			--Data_For	
		)
		SELECT DISTINCT 
			--ADRS.Title_Code , 
			--ADRS.Acq_Deal_Run_Code ,
			ADRS.Acq_Deal_Run_Shows_Code ,
			ADRS.Acq_Deal_Movie_Code --,				
			--ADRS.Episode_From ,
			--ADRS.Episode_To ,	
		--	0 AS Acq_Deal_Code,
			--ADRS.Data_For 												
		FROM  Acq_Deal_Run_Shows ADRS 		
		WHERE ADRS.Acq_Deal_Run_Code =  CAST(@Run_Code as nvarchar(20))  AND ADRS.Data_For= @Data_For_flag

		INSERT INTO #Temp_Prog_Eps
		(
			Agreement_No,
			Acq_Deal_Code,
			Acq_Deal_Movie_Code,									
			Episode_From ,
			Episode_To ,	
			Title_Code,						
			Acq_Deal_Run_Code ,	
			Data_For
		)
		SELECT DISTINCT 
		AD.Agreement_No,	
		AD.Acq_Deal_Code	,
		ADM.Acq_Deal_Movie_Code,				
		ADM.Episode_Starts_From ,
		ADM.Episode_End_To ,	
		ADM.Title_Code,							
		ADR.Acq_Deal_Run_Code ,			
		'E' AS Data_For									
		FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code		
		INNER JOIN Acq_Deal_Run ADR ON ADM.Acq_Deal_Code =ADR.Acq_Deal_Code
		INNER JOIN Acq_Deal_Run_Channel ADRC ON ADR.Acq_Deal_Run_Code =ADRC.Acq_Deal_Run_Code
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code 
			AND  ADM.Title_Code = ADRT.Title_Code AND ADM.Episode_Starts_From = ADRT.Episode_From AND ADM.Episode_End_To = ADRT.Episode_To
			AND ADRC.Channel_Code IN(
					SELECT TC.Channel_Code FROM  #Temp_Channel_Codes  TC						
			)
		WHERE 1 = 1 and   AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 
		AND (AD.Deal_Type_Code=(SELECT TOP 1 Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Content')
		OR AD.Deal_Type_Code=(SELECT TOP 1 Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Deal_Type_Format_Program'))
				
		INSERT INTO #Temp
		(
			Agreement_No ,
			Acq_Deal_Code,
			Acq_Deal_Movie_Code ,				
			Episode_From ,
			Episode_To ,				
			Title_Code , 
			Acq_Deal_Run_Code ,
			Channel_Code ,
			Acq_Deal_Run_Shows_Code ,
			Data_For ,
			IS_Same_group
		)
		SELECT DISTINCT 
			T.Agreement_No,			
			T.Acq_Deal_Code,					
			T.Acq_Deal_Movie_Code,
			T.Episode_From ,
			T.Episode_To ,				
			T.Title_Code , 
			ADRC.Acq_Deal_Run_Code ,
			ADRC.Channel_Code,
			0 AS Acq_Deal_Run_Shows_Code ,			
			'E' AS Data_For,	
			'Y' AS IS_Same_group		
		FROM #Temp_Prog_Eps T   				
		INNER JOIN Acq_Deal_Run_Channel ADRC ON T.Acq_Deal_Run_Code =ADRC.Acq_Deal_Run_Code
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADRC.Acq_Deal_Run_Code 		
			AND  T.Title_Code = ADRT.Title_Code AND T.Episode_From = ADRT.Episode_From AND T.Episode_To = ADRT.Episode_To

	--SELECT 'sa_#Temp_Prog_Eps',* FROM #Temp_Prog_Eps
	--SELECT 'sa_#Temp_Prog_Eps',* FROM #Temp
		UPDATE T SET T.Acq_Deal_Run_Shows_Code = TS.Acq_Deal_Run_Shows_Code
		FROM #Temp T
		INNER JOIN #Temp_Run_Shows TS ON T.Acq_Deal_Movie_Code = TS.Acq_Deal_Movie_Code
		--AND T.Channel_Code IN(
		--	SELECT TC.Channel_Code FROM  #Temp_Channel_Codes  TC 						
		--)
		
		--SELECT 'sagar',* FROM #Temp				
		--SELECT 'sagar',* FROM #Temp_Prog_Eps

	--	DELETE FROM #Temp WHERE ISNULL(Acq_Deal_Run_Shows_Code,0) = 0 AND @searchCriteria = ''
	END
	/**/
		/************************************Common Logic*****************************************/	
		--UPDATE T2 SET T2.Agreement_No = AD.Agreement_No ,T2.Acq_Deal_Code=ADM.Acq_Deal_Code
		--FROM #Temp T2
		--INNER JOIN Acq_Deal_Movie ADM ON T2.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
		--INNER JOIN Acq_Deal AD ON ADM.Acq_Deal_Code = AD.Acq_Deal_Code

		--UPDATE t SET t.IS_Same_group = 'Y' 
		--FROM #Temp t
		--WHERE t.Acq_Deal_Run_Code IN
		--(
		--	SELECT temp.Acq_Deal_Run_Code 
		--	FROM #Temp temp WHERE temp.Channel_Code IN(SELECT Channel_Code FROM #Temp_Channel_Codes)
		--	AND t.Acq_Deal_Run_Code =temp.Acq_Deal_Run_Code
		--)
		--AND IS_Same_group = 'N'	


		--UPDATE t SET t.IS_Same_group = 'Y' 
		--FROM #Temp t
		--WHERE 1 =1 
		--AND
		--(
		--	(t.Title_Code IN(SELECT number FROM dbo.fn_Split_withdelemiter(ISNULL(@selectedTitleCodes,'0'),',')) AND @Data_For_flag = 'P')
		--	OR
		--	(Acq_Deal_Movie_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(ISNULL(@selectedDealMovieCodes,'0'),',')) AND @Data_For_flag = 'E')			
		--)
		--AND IS_Same_group = 'N'	--AND  @Data_For_flag <> 'E'
		
		DELETE FROM #Temp WHERE IS_Same_group = 'N' 				
		
		--UPDATE T SET T.Acq_Deal_Run_Shows_Code = TS.Acq_Deal_Run_Shows_Code
		--FROM #Temp T
		--INNER JOIN #Temp_Prog_Eps TS ON T.Acq_Deal_Movie_Code = TS.Acq_Deal_Movie_Code AND @Data_For_flag = 'E' AND IS_Same_group = 'Y'

		DELETE FROM #Temp WHERE ISNULL(Acq_Deal_Run_Shows_Code,0) = 0 AND @searchCriteria = '' AND @Data_For_flag = 'E'

		/********************Update Master level****************/		
		UPDATE  temp  SET temp .Title_Name = T.Title_Name
		FROM #Temp temp 
		INNER JOIN Title  T ON temp.Title_Code = T.Title_Code

		UPDATE  temp  SET temp .Channel_Name = C.Channel_Name
		FROM #Temp temp 
		INNER JOIN Channel C ON temp.Channel_Code = C.Channel_Code

		/********************Insert into temp2****************/		
		--SELECT 'sagar',* FROM #Temp --WHERE IS_Same_group = 'Y'  AND Title_Name like 'band%'
		--SELECT 'sagar2',* FROM #Temp2

		INSERT INTO #Temp2
		SELECT DISTINCT Title_Code,Acq_Deal_Run_Code,Acq_Deal_Run_Shows_Code,Acq_Deal_Movie_Code,Title_Name,Episode_From,Episode_To,
			STUFF((SELECT DISTINCT ', ' + ISNULL(Channel_Name,'')
					FROM #Temp t1
					WHERE 1 =1 
					AND 
					(
						(t.Acq_Deal_Movie_Code = t1.Acq_Deal_Movie_Code AND @Data_For_flag = 'E')
						OR
						(t.Title_Code = t1.Title_Code AND @Data_For_flag = 'P')
					)					
					FOR XML PATH(''), TYPE
				).value('.', 'NVARCHAR(MAX)') 
				,1,2,'') Channel_Name,
			Acq_Deal_Code,Agreement_No,Ext_Column_Name,Ext_Column_Value,'N',Data_For
		FROM #Temp t
		WHERE 1 =1 		
		AND t.IS_Same_group = 'Y'
		AND
		(
				t.Title_Name like '%'+@searchCriteria + '%'
				OR
				t.Channel_Name like '%'+@searchCriteria + '%'		
				OR
				RTRIM(LTRIM(ISNULL(@searchCriteria,''))) = ''	
				OR				
				t.Acq_Deal_Run_Shows_Code > 0	
				OR
				(t.Title_Code IN(SELECT number FROM dbo.fn_Split_withdelemiter(ISNULL(@selectedTitleCodes,'0'),',')) AND @Data_For_flag = 'P')
				OR
				(t.Acq_Deal_Movie_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(ISNULL(@selectedDealMovieCodes,'0'),',')) AND @Data_For_flag = 'E')				
		)		
	--	SELECT 'sagar',* FROM #Temp
		UPDATE #Temp2 SET Is_Select='Y' 
		WHERE 1 =1
		AND 
		(

			(
				(@searchCriteria<> '')
				AND
				(
					(
						ISNULL(@selectedDealMovieCodes,'0') <> '0' 
						AND @Data_For_flag = 'E'
						AND Acq_Deal_Movie_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@selectedDealMovieCodes,','))
					)
					OR			
					(
						ISNULL(@selectedTitleCodes,'0') <> '0'
						AND @Data_For_flag = 'P'
						AND Title_Code IN(SELECT number FROM dbo.fn_Split_withdelemiter(ISNULL(@selectedTitleCodes,'0'),',')) 
					)
				)
			)
			OR
			(
				 ISNULL(Acq_Deal_Run_Shows_Code,0) > 0 		
			)
		)
		
		UPDATE #Temp2 SET Is_Select='N' 
		WHERE  ISNULL(Acq_Deal_Run_Shows_Code,0) > 0
		AND Acq_Deal_Run_Shows_Code IN(
				SELECT number FROM dbo.fn_Split_withdelemiter(ISNULL(@UnCheck_Run_Shows_Code,'0'),',') 
		)
	END	
	IF @Data_For_flag = 'P' OR @Data_For_flag = '' OR @Data_For_flag = 'A'-- p => Programwise 
	BEGIN
		UPDATE #Temp SET Acq_Deal_Run_Code = 0,Acq_Deal_Code = 0,Agreement_No = ''		

		SELECT DISTINCT Title_Code,0 Acq_Deal_Run_Code,Acq_Deal_Run_Shows_Code, Acq_Deal_Movie_Code,Title_Name,Episode_From,Episode_To,
				Channel_Name,Acq_Deal_Code,'' Agreement_No,'' AS Ext_Column_Name,'' 
				AS Ext_Column_Value,Is_Select,ISNULL(Data_For, @Data_For_flag) AS Data_For
		FROM #Temp2
		ORder BY Is_Select DESC--,Title_Name,Agreement_No,Channel_Name 
	END
	ELSE
	BEGIN		
		UPDATE T2 SET T2.Ext_Column_Name = EC.Columns_Name,T2.Ext_Column_Value = ECV.Columns_Value
		FROM #Temp2 T2
		INNER JOIN Map_Extended_Columns MEC ON MEC.Record_Code=T2.Title_Code AND MEC.Table_Name='TITLE'
		INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code AND EC.Columns_Name='Program Category'
		INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Code=EC.Columns_Code AND ECV.Columns_Value_Code = MEC.Columns_Value_Code

		SELECT DISTINCT Title_Code,0 Acq_Deal_Run_Code,Acq_Deal_Run_Shows_Code,Acq_Deal_Movie_Code,
		Title_Name + ' ('+ CAST(Episode_From AS VARCHAR) +  '-'  + CAST(Episode_To AS VARCHAR) + ')' AS Title_Name,
		Episode_From,Episode_To,
				Channel_Name,Acq_Deal_Code,Agreement_No, Ext_Column_Name,Ext_Column_Value,Is_Select,ISNULL(Data_For, @Data_For_flag) AS Data_For				
		FROM #Temp2 ORder BY Is_Select DESC--,Title_Name,Agreement_No,Channel_Name 
	END
END
/*
USP_Search_Run_Shows 'set','P','','Mtv','','',12911
USP_Search_Run_Shows '','','',' Colors India, Colors MENA, VH1','','',12911
USP_Search_Run_Shows '','','',' MTV, SET Jupiter','','',12779
/*
--SELECT * FROM Acq_Deal_Movie WHERE Acq_Deal_Code IN(11353)
SELECT * FROM Acq_Deal_Run WHERE Acq_Deal_Run_Code IN(12779)
SELECT * FROM Acq_Deal_Movie WHERE Acq_Deal_MOvie_Code IN(12018,12014)

USP_Search_Run_Shows 'sagar','P','0',' MTV, SET Jupiter','18534', '',12779 Colors India HD, HMC, MTV, SET Jupiter
USP_Search_Run_Shows 'sagar','P','0',' MTV, SET Jupiter','18534,18534,20576,20559,20573,20578','208',12779

USP_Search_Run_Shows 'set','P','',' MTV','','',12779
*/

,'0',' MTV, SET Jupiter','18534', '',12779 Colors India HD, HMC, MTV, SET Jupiter
USP_Search_Run_Shows 'sagar','P','0',' MTV, SET Jupiter','18534,18534,20576,20559,20573,20578','208',12779

USP_Search_Run_Shows 'set','P','',' MTV','','',12779
*/


GO

