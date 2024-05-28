ALTER PROCEDURE [dbo].[USP_ChannelWiseConsumption]
(
	@TitleCodes VARCHAR(MAX),
	@ChannelCodes VARCHAR(MAX),
	@AllYears CHAR(1)='N',
	@Flag VARCHAR(10),
	@Run_Type CHAR(1),--C  Limited, U - UnLimited
	@DMContentCodes VARCHAR(5000) = NULL,
	@Channel_Region int = 0,
	@IsDealExpire char(1) = 'N'
)
---- =============================================
---- Updated By : Anchal Sikarwar
---- Updated On : 04 June 2018
---- =============================================
AS
BEGIN
	--DECLARE
	--@TitleCodes VARCHAR(MAX)='27520',
	--@ChannelCodes VARCHAR(MAX)='1,2,3,4',
	--@AllYears CHAR(1)='N',
	--@Flag VARCHAR(10)='MOVIE',
	--@Run_Type CHAR(1)= 'C',--C  Limited, U - UnLimited
	--@DMContentCodes VARCHAR(5000) = NULL,
	--@Channel_Region int = 0,
	--@IsDealExpire char(1) = 'N'
	PRINT 'Process Started'
	PRINT '  Drop all temp table, if exists'
   	IF OBJECT_ID('TEMPDB..#ChannelWiseConsumption') IS NOT NULL
		DROP TABLE #ChannelWiseConsumption

	IF OBJECT_ID('TEMPDB..#TempTitles') IS NOT NULL
		DROP TABLE #TempTitles
	
	IF OBJECT_ID('TEMPDB..#TempChannels') IS NOT NULL
		DROP TABLE #TempChannels
	
	IF(@Flag = UPPER('MOVIE'))
	BEGIN
		PRINT '  Create Temp Table'
		CREATE Table #TempChannels
		(
			Channel_Code		INT,
			Channel_Name		NVARCHAR(MAX),
			Channel_Id			NVARCHAR(MAX),
			Order_For_schedule	INT
		)
		CREATE TABLE #ChannelWiseConsumption 
		(
			Deal_no VARCHAR(250), 
			English_title NVARCHAR(250), 
			Rights_period VARCHAR(50),                       
			--Deal_movie_code INT, 
			Deal_Code INT,
			Title_Content_Code INT,
			Channel_code INT, 
			Channel_name NVARCHAR(50), 
			Channels NVARCHAR(MAX),                       
			Channel_Beam NVARCHAR(MAX),
			Run_definition_type VARCHAR(10),
			Run_definition_group_code INT,
			DMR_IsGroupCode INT,
			ColorCode VARCHAR(100),
			NoOfRuns VARCHAR(50),
			Provision_Runs VARCHAR(50),
			Consume_Runs VARCHAR(50),
			Balance_Runs VARCHAR(50),
			Order_For_schedule int ,
			[RuleRight] NVARCHAR(2000)
		)
		PRINT '  Created Temp Table'		

		SELECT Title_Code, Title_Name INTO #TempTitles FROM Title T 
		WHERE Title_Code IN(Select number AS TitleCode FROM fn_Split_withdelemiter(@TitleCodes,',') where number <> '')

		IF (@ChannelCodes<>'') 
		BEGIN
			INSERT INTO #TempChannels(Channel_Code)
			Select number from fn_Split_withdelemiter(@ChannelCodes,',') where number <> ''

			UPDATE TC SET  TC.Channel_Name = C.Channel_Name, TC.Channel_Id = C.Channel_Id, TC.Order_For_schedule = C.Order_For_schedule 
			FROM #TempChannels TC
			INNER JOIN Channel C ON C.Channel_Code = TC.Channel_Code
		END
		ELSE 
		BEGIN
			INSERT INTO #TempChannels(Channel_Code, Channel_Name, Channel_Id, Order_For_schedule)
			SELECT Channel_Code, Channel_Name, Channel_Id, Order_For_schedule FROM Channel
		END

		SELECT X.Agreement_No, 
		X.Title_Name, X.Deal_Code, X.Title_Content_Code, X.Channel_Code, X.Channel_Name, X.Channels_Beam, X.Channel_Id, X.Run_Def_Type, X.Order_For_schedule,
		X.Right_Rule_Name, CONVERT(VARCHAR(25),MIN(X.Rights_Start_Date),106) +' To '+ CONVERT(VARCHAR(25),MAX(Rights_End_Date), 106) Rights_Period, SUM(Defined_Runs) NoOfRuns, SUM(Provision_Runs) Provision_Runs,
		SUM(Defined_Runs) - SUM(Provision_Runs) Balance_Runs, X.Deal_Type, Consume_Runs
		FROM
		(
			SELECT DISTINCT 
			CASE WHEN ISNULL(CCR.Acq_Deal_Code,0) = 0 THEN
				(SELECT PD.Agreement_No FROM Provisional_Deal PD WHERE CCR.Provisional_Deal_Code = PD.Provisional_Deal_Code)
				ELSE (SELECT AD.Agreement_No FROM Acq_Deal AD WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND CCR.Acq_Deal_Code = AD.Acq_Deal_Code)
			END Agreement_No,
			TT.Title_Name,
			ISNULL(CCR.Acq_Deal_Code, CCR.Provisional_Deal_Code) Deal_Code,
			CCR.Title_Content_Code,
			CCR.Channel_Code, 
			TempC.Channel_Name, 
			dbo.UFN_Get_Channels_Beam(TempC.Channel_Name) Channels_Beam, 
			TempC.Channel_Id, 
			CCR.Run_Def_Type,
			TempC.Order_For_schedule,
			CASE WHEN ISNULL(CCR.Right_Rule_Code ,0) > 0 THEN RR.Right_Rule_Name ELSE ''  END AS Right_Rule_Name,
			CCR.Defined_Runs,
			(
				SELECT COUNT(*) FROM BV_Schedule_Transaction BV WHERE BV.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code AND
				CONVERT(DATETIME, CONVERT(CHAR(12), Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), Schedule_Item_Log_Time, 108), 103)
				> GETDATE() AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
			) AS Provision_Runs,
			(
				SELECT COUNT(*) FROM BV_Schedule_Transaction BV WHERE BV.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code AND
				CONVERT(DATETIME, CONVERT(CHAR(12), Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), Schedule_Item_Log_Time, 108), 103)
				<= GETDATE() AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
			) AS Consume_Runs,
			CCR.Rights_Start_Date,
			CCR.Rights_End_Date,
			CCR.Deal_Type
			FROM Content_Channel_Run CCR
			INNER JOIN #TempTitles TT ON CCR.Title_Code = TT.Title_Code
			INNER JOIN Title_Content TC ON TC.Title_Content_Code = CCR.Title_Content_Code
			INNER JOIN #TempChannels TempC ON TempC.Channel_Code = CCR.Channel_Code
			LEFT  JOIN Right_Rule RR on RR.Right_Rule_Code = CCR.Right_Rule_Code 
			Where ISNULL(CCR.Is_Archive, 'N') = 'N'
		) AS X
		GROUP BY X.Agreement_No, 
		X.Title_Name, X.Deal_Code, X.Title_Content_Code, X.Channel_Code, X.Channel_Name, X.Channels_Beam, X.Channel_Id, X.Run_Def_Type, X.Order_For_schedule,
		X.Right_Rule_Name, X.Deal_Type,Consume_Runs
    END
	ELSE
	BEGIN
		PRINT '   ERROR : Invalid Flag ''' + @Flag + ''''
	END

	PRINT 'Process Ended' 
END

--select * from Content_Channel_Run