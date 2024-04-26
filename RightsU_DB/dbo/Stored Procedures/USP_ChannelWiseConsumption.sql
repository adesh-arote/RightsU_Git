CREATE PROCEDURE [dbo].[USP_ChannelWiseConsumption]
(
	@TitleCodes VARCHAR(MAX),
	@ChannelCodes VARCHAR(MAX),
	@AllYears CHAR(1),
	@Flag VARCHAR(10),
	@Run_Type CHAR(2),--(0) = Limited, (-1) = UnLimited
	@DMContentCodes VARCHAR(5000) = NULL,
	@Channel_Region int = 0,
	@IsDealExpire char(1)
)
---- =============================================
---- Updated By : Anchal Sikarwar
---- Updated On : 04 June 2018
---- =============================================
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_ChannelWiseConsumption]', 'Step 1', 0, 'Started Procedure', 0, ''
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

			SELECT Title_Code, Title_Name,Title_Language_Code,Deal_Type_Code INTO #TempTitles FROM Title T (NOLOCK)
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
				SELECT Channel_Code, Channel_Name, Channel_Id, Order_For_schedule FROM Channel (NOLOCK)
			END

			SELECT X.Agreement_No,X.Business_Unit,X.ModeOfAcq,X.Deal_Type_Name,X.Genres_Name,X.Language_Name, 
			X.Title_Name,X.Episode_No, X.Deal_Code, X.Title_Content_Code, X.Channel_Code, X.Channel_Name, X.Channels_Beam, X.Channel_Id, X.Run_Def_Type, X.Order_For_schedule,
			X.Right_Rule_Name, CONVERT(VARCHAR(25),MIN(X.Rights_Start_Date),106) +' To '+ CONVERT(VARCHAR(25),MAX(Rights_End_Date), 106) Rights_Period, SUM(Defined_Runs) NoOfRuns, SUM(Provision_Runs) Provision_Runs,
			SUM(Defined_Runs) - SUM(Provision_Runs) Balance_Runs, X.Deal_Type, Consume_Runs
			FROM
			(
				SELECT DISTINCT 
				AD.Agreement_No, (select Business_Unit_Name from Business_Unit where Business_Unit_Code = AD.Business_Unit_Code) Business_Unit,
				TT.Title_Name,
				AD.Acq_Deal_Code Deal_Code,
				CCR.BMS_Asset_Code Title_Content_Code,
				CCR.RU_Channel_Code Channel_Code, 
				TempC.Channel_Name, 
				dbo.UFN_Get_Channels_Beam(TempC.Channel_Name) Channels_Beam, 
				TempC.Channel_Id, 
				ADR.Run_Definition_Type Run_Def_Type,
				TempC.Order_For_schedule,
				CASE WHEN ISNULL(CCR.RU_Right_Rule_Code ,0) > 0 THEN RR.Right_Rule_Name ELSE ''  END AS Right_Rule_Name,
				CCR.Total_Runs Defined_Runs,
				(
					SELECT COUNT(*) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE BV.BMS_Deal_Content_Rights_Code = CCR.BMS_Deal_Content_Rights_Code AND
					--CONVERT(DATETIME, CONVERT(CHAR(12), Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), Schedule_Item_Log_Time, 108), 103)
					CONVERT(DATETIME, Schedule_Item_Log_DateTime, 103)
					> GETDATE() AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
				) AS Provision_Runs,
				(
					SELECT COUNT(*) FROM BV_Schedule_Transaction BV (NOLOCK) WHERE BV.BMS_Deal_Content_Rights_Code = CCR.BMS_Deal_Content_Rights_Code AND
					--CONVERT(DATETIME, CONVERT(CHAR(12), Schedule_Item_Log_Date, 103) + ' ' + CONVERT(CHAR(8), Schedule_Item_Log_Time, 108), 103)
					CONVERT(DATETIME, Schedule_Item_Log_DateTime, 103)
					<= GETDATE() AND BV.IsProcessed = 'Y' AND ISNULL(BV.IsIgnore, 'N') <> 'Y'
				) AS Consume_Runs,
				CCR.Start_Date Rights_Start_Date,
				CCR.End_Date Rights_End_Date,
				NULL Deal_Type,
				TC.Episode_No,
				L.Language_Name,
				DT.Deal_Type_Name,
				G.Genres_Name,
				CASE WHEN ISNULL(AD.Acq_Deal_Code,0) = 0 THEN '' ELSE 'Acquisition' END as ModeOfAcq
				FROM BMS_Deal_Content_Rights CCR (NOLOCK)
				INNER JOIN Acq_Deal_Run ADR ON ADR.Acq_Deal_Run_Code = CCR.Acq_Deal_Run_Code
				INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code
				INNER JOIN BMS_Asset BA ON BA.BMS_Asset_Code = CCR.BMS_Asset_Code
				INNER JOIN #TempTitles TT ON BA.RU_Title_Code = TT.Title_Code
				INNER JOIN Title_Content TC (NOLOCK) ON TC.Ref_BMS_Content_Code = BA.BMS_Asset_Ref_Key 
				INNER JOIN #TempChannels TempC ON TempC.Channel_Code = CCR.RU_Channel_Code
				LEFT  JOIN Right_Rule RR (NOLOCK) on RR.Right_Rule_Code = CCR.RU_Right_Rule_Code 
				LEFT JOIN Language L (NOLOCK) on L.Language_Code = TT.Title_Language_Code
				LEFT JOIN Deal_Type DT (NOLOCK) on DT.Deal_Type_Code = TT.Deal_Type_Code
				LEFT JOIN Title_Geners TG (NOLOCK) on TG.Title_Code = TT.Title_Code
				LEFT JOIN Genres G (NOLOCK) on G.Genres_Code = TG.Genres_Code
				Where ISNULL(CCR.Is_Active, 'N') = 'Y' 
				AND CASE WHEN @Run_Type = '' THEN 1 
				WHEN @Run_Type = '-1' THEN CASE WHEN CCR.Total_Runs = '-1' THEN 1 ELSE 0 END
				WHEN @Run_Type = '0' THEN CASE WHEN CCR.Total_Runs >= 0 THEN 1 ELSE 0 END ELSE 0 END = 1
				AND ((Convert(datetime, isnull(CCR.End_Date, GETDATE() ), 103) >= Convert(date, GETDATE() , 103)) OR @IsDealExpire <> 'Y')
				AND ((@AllYears = 'N' AND GETDATE() BETWEEN CCR.Start_Date AND CCR.End_Date) OR @AllYears = 'Y')
			) AS X
			GROUP BY X.Agreement_No, 
			X.Title_Name, X.Deal_Code, X.Title_Content_Code, X.Channel_Code, X.Channel_Name, X.Channels_Beam, X.Channel_Id, X.Run_Def_Type, X.Order_For_schedule,
			X.Right_Rule_Name, X.Deal_Type,Consume_Runs,X.Business_Unit,X.Episode_No,X.Language_Name,X.Deal_Type_Name,X.Genres_Name,X.ModeOfAcq
			ORDER BY X.Episode_No
		END
		ELSE
		BEGIN
			PRINT '   ERROR : Invalid Flag ''' + @Flag + ''''
		END

		PRINT 'Process Ended' 
		IF OBJECT_ID('tempdb..#ChannelWiseConsumption') IS NOT NULL DROP TABLE #ChannelWiseConsumption
		IF OBJECT_ID('tempdb..#TempChannels') IS NOT NULL DROP TABLE #TempChannels
		IF OBJECT_ID('tempdb..#TempTitles') IS NOT NULL DROP TABLE #TempTitles
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_ChannelWiseConsumption]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END