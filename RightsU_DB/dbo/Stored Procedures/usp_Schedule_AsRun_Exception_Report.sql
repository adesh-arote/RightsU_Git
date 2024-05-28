CREATE PROCEDURE [dbo].[usp_Schedule_AsRun_Exception_Report]   
(  
	@ReportType varchar(10),	
	@IsShowAll varchar(10),
	@TitleType varchar(10),	
	@TitleCode varchar(8000),
	@StartDate varchar(20),
	@EndDate varchar(20),
	@EpisodeFrom NVARCHAR(10),
	@EpisodeTo NVARCHAR(10)
	--@Business_Unit_Code INT
	--@StartDate Datetime,
	--@EndDate Datetime
)  
AS  
BEGIN  
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[usp_Schedule_AsRun_Exception_Report]', 'Step 1', 0, 'Started Procedure', 0, ''
		-- SET NOCOUNT ON added to prevent extra result sets from  
		-- interfering with SELECT statements.  
		SET NOCOUNT ON;  
	
			--DECLARE @TitleCode INT
			--SELECT @TitleCode = ISNULL(title_code,0) FROM Title WHERE title_name like '' + @Title + '%'
	
			IF(ISNULL(@ReportType,'') = '')
				SET @ReportType = 'S'

			--IF(ISNULL(@Business_Unit_Code,'') = '')
			--	SET @Business_Unit_Code = 1

			
			------------------------------------------- DELETE TEMP TABLES -------------------------------------------	
   			IF OBJECT_ID('tempdb..#ExceptionReport') IS NOT NULL
			BEGIN
				DROP TABLE #ExceptionReport
			END
	
			CREATE TABLE #ExceptionReport
			(  
				title_code INT,  
				title_name NVARCHAR(500),  
		
				File_Episode_Title VARCHAR(500),  
				File_Program_Episode_Number NVARCHAR(500),  
				File_Program_Title NVARCHAR(500),  
				File_Program_Category NVARCHAR(500),  
				File_Schedule_Item_Log_Date Datetime,  
				File_Schedule_Item_Log_Time VARCHAR(50),  
				File_Schedule_Item_Duration Varchar(50),
				File_HouseID VARCHAR(500),
		
				Channel_Code INT,
				Channel_Name NVARCHAR(100),
				Notification_Msg NVARCHAR(500)
			)
			------------------------------------------- END DELETE TEMP TABLES -------------------------------------------	
	
			DECLARE @filter VARCHAR(8000);	SET @filter = ' '
			DECLARE @strSql VARCHAR(MAX)	SET @strSql = ' '
			DECLARE @BV_Program_Category_Name_For_Show NVARCHAR(MAX)
			--SELECT  @BV_Program_Category_Name_For_Show = BV_Program_Category_Name FROM System_Parameter_New SPN
			--INNER JOIN BV_Program_Category PC ON PC.BV_Program_Category_code = SPN.Parameter_Value
			--where SPN.Parameter_Name = 'BV_Program_Category_Code_For_Show'

			DECLARE @BV_Pc_Code NVARCHAR(MAX) = (select Parameter_Value FROM System_Parameter_New WHERE Parameter_Name= 'BV_Program_Category_Code_For_Show')

			SELECT @BV_Program_Category_Name_For_Show = ISNULL(STUFF((SELECT DISTINCT ',''' + t.BV_Program_Category_Name + ''''
			FROM BV_Program_Category t (NOLOCK)    
			WHERE t.BV_Program_Category_code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@BV_Pc_Code, ',') WHERE number NOT IN ('0', ''))
			FOR XML PATH(''), TYPE      
			 ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')

			IF(@ReportType = 'S')
			BEGIN
				IF(@TitleCode != '')
				BEGIN
					--SET @filter = @filter  + ' AND ((T.Title_Code in (select number from dbo.fn_Split_withdelemiter(''' + @TitleCode + ''','','') )) OR 
					--(ENS.Program_Title in (select  tTmp.Title_Name from dbo.fn_Split_withdelemiter(''' + @TitleCode + ''','','') A INNER JOIN Title tTmp on tTmp.Title_Code = A.Number))
					--)'

					SET @filter = @filter  + ' AND ((T.Title_Code in (select number from dbo.fn_Split_withdelemiter(''' + @TitleCode + ''','','') )) OR 
					(ENS.Program_Title in (select  tTmp.Title_Name from dbo.fn_Split_withdelemiter(''' + @TitleCode + ''','','') A INNER JOIN Title tTmp on tTmp.Title_Code = A.Number))
					)'
				END

				IF(@StartDate != '' AND @EndDate != '')
				BEGIN
					--set @filter = @filter  +  ' AND CONVERT(datetime,ENS.Schedule_Item_Log_Date,102) BETWEEN '''+Convert(varchar(20),@StartDate,103)+''' AND '''+Convert(varchar(20),@EndDate,103)+''' '
					set @filter = @filter  +  ' AND CONVERT(datetime,ENS.Schedule_Item_Log_Date,102) BETWEEN '''+@StartDate+''' AND '''+@EndDate+''' '
				END
				IF( @IsShowAll = 'Y')
				BEGIN
					SET @filter = ' '
				END

				IF(@TitleType = 'Program' OR @TitleType = 'ALL')
				BEGIN
					IF((@EpisodeFrom != '') AND (@EpisodeTo != ''))
					BEGIN
						SET @filter = @filter + ' AND ENS.Program_Episode_Number BETWEEN ''' + CAST(@EpisodeFrom AS varchar(MAX)) + ''' AND ''' + CAST(@EpisodeTo AS varchar(MAX)) + ''' '
					END		
				END
		
				IF(@TitleType = 'Movie' OR @TitleType = 'ALL')
				BEGIN
					SET @strSql = '
					INSERT INTO #ExceptionReport
					(
						title_code,  title_name, File_Episode_Title, File_Program_Category, File_Program_Episode_Number, File_Program_Title, 
						File_Schedule_Item_Log_Date,  File_Schedule_Item_Log_Time, File_Schedule_Item_Duration, File_HouseID, 
						Channel_Code, Channel_Name, Notification_Msg
					)  
					select ENS.Title_Code, T.Title_Name , ENS.Program_Episode_Title, ENS.Program_Category, ENS.Program_Episode_Number, ENS.Program_Title, 
					ENS.Schedule_Item_Log_Date, ENS.Schedule_Item_Log_Time, ENS.Schedule_Item_Duration, ENS.Scheduled_Version_House_Number_List, C.channel_code, C.channel_name,
					ENS.Email_Notification_Msg
					from Email_Notification_Schedule ENS (NOLOCK)
					LEFT OUTER JOIN Title T (NOLOCK) ON T.title_code = ENS.Title_Code
					INNER JOIN Channel C (NOLOCK) ON C.channel_code = ENS.Channel_Code
					WHERE 1=1 ' + @filter
					--WHERE 1=1 AND Program_category NOT In ('''+ ISNULL(@BV_Program_Category_Name_For_Show,'') +''') ' + @filter
			
					PRINT @strSql
					EXEC(@strSql)
				END
				IF(@TitleType = 'Program' OR @TitleType = 'ALL')
				BEGIN
					-----SELECT 'aaa'
					SET @strSql = '
					INSERT INTO #ExceptionReport
					(
						title_code,  title_name, File_Episode_Title, File_Program_Category, File_Program_Episode_Number, File_Program_Title, 
						File_Schedule_Item_Log_Date,  File_Schedule_Item_Log_Time, File_Schedule_Item_Duration, File_HouseID, 
						Channel_Code, Channel_Name, Notification_Msg
					)  
					select ENS.Title_Code, T.Title_Name , ENS.Program_Episode_Title, ENS.Program_Category, ENS.Program_Episode_Number, ENS.Program_Title, 
					ENS.Schedule_Item_Log_Date, ENS.Schedule_Item_Log_Time, ENS.Schedule_Item_Duration, ENS.Scheduled_Version_House_Number_List, C.channel_code, C.channel_name,
					ENS.Email_Notification_Msg
					from Email_Notification_Schedule ENS (NOLOCK)
					LEFT OUTER JOIN Title T (NOLOCK) ON T.title_code = ENS.Title_Code
					INNER JOIN Channel C (NOLOCK) ON C.channel_code = ENS.Channel_Code
					WHERE 1=1  AND Program_category IN ('+ ISNULL(@BV_Program_Category_Name_For_Show,'') +') ' + ISNULL(@filter,'')
			
					PRINT @strSql
					EXEC(@strSql)
				END

			END
			ELSE IF(@ReportType = 'A')
			BEGIN
				IF(@TitleCode != '')
				BEGIN
					SET @filter = @filter  + ' AND T.Title_Code in (select number from dbo.fn_Split_withdelemiter(''' + @TitleCode + ''','',''))'
				END
				IF(@StartDate != '' AND @EndDate != '')
				BEGIN
					set @filter =  @filter  + ' AND CONVERT(datetime,ENA.On_AIR,1) BETWEEN '''+ @StartDate +''' AND '''+ @EndDate +''' '
				END
		
				IF( @IsShowAll = 'Y')
				BEGIN
					SET @filter = ' '
				END
		
				IF(@TitleType = 'Movie' OR @TitleType = 'ALL')
				BEGIN
					SET @strSql = '
					INSERT INTO #ExceptionReport 
					(
						title_code,  title_name, File_Episode_Title, File_Program_Category, File_Program_Episode_Number, File_Program_Title, 
						File_Schedule_Item_Log_Date,  File_Schedule_Item_Log_Time, File_Schedule_Item_Duration, File_HouseID, 
						Channel_Code, Channel_Name, Notification_Msg
					)  
					select ENA.Title_Code, T.title_name, NULL, NULL, NULL, ENA.TITLE, 
					ENA.ON_AIR, ENA.Dt_Tm, ENA.DUration, ENA.ID, 
					C.channel_code, C.channel_name, ENA.Email_Notification_Msg
					from Email_Notification_AsRun ENA (NOLOCK)
					LEFT OUTER JOIN Title T (NOLOCK) ON T.title_code = ENA.Title_Code
					INNER JOIN Channel C (NOLOCK) ON C.channel_code = ENA.Channel_Code 
					WHERE 1=1 ' + @filter
						
					PRINT @strSql
					EXEC(@strSql)
				END
				IF(@TitleType = 'Program' OR @TitleType = 'ALL')
				BEGIN
					SET @strSql = '
					INSERT INTO #ExceptionReport 
					(
						title_code,  title_name, File_Episode_Title, File_Program_Category, File_Program_Episode_Number, File_Program_Title, 
						File_Schedule_Item_Log_Date,  File_Schedule_Item_Log_Time, File_Schedule_Item_Duration, File_HouseID, 
						Channel_Code, Channel_Name, Notification_Msg
					)  
					select ENA.Title_Code, T.title_name, NULL, NULL, NULL, ENA.TITLE, 
					ENA.ON_AIR, ENA.Dt_Tm, ENA.DUration, ENA.ID, 
					C.channel_code, C.channel_name, ENA.Email_Notification_Msg
					from Email_Notification_AsRun_Shows ENA (NOLOCK)
					LEFT OUTER JOIN Title T (NOLOCK) ON T.title_code = ENA.Title_Code
					INNER JOIN Channel C (NOLOCK) ON C.channel_code = ENA.Channel_Code 
					WHERE 1=1 ' + @filter
			
					PRINT @strSql
					EXEC(@strSql)
				END
			END

			--SELECT * FROM #ExceptionReport	order by File_Schedule_Item_Log_Date
			Select title_code ,  title_name,
					File_Episode_Title,File_Program_Episode_Number ,
					File_Program_Title ,File_Program_Category ,
					--(Convert(varchar(50),File_Schedule_Item_Log_Date,106) + ' ' + File_Schedule_Item_Log_Time) as File_Schedule_Item_Log_Date,
					Convert(Datetime,(Convert(varchar(50),File_Schedule_Item_Log_Date,106) + ' ' + File_Schedule_Item_Log_Time),120) as File_Schedule_Item_Log_Date,
					Convert(varchar(50),File_Schedule_Item_Log_Date,106) as LogDate,
					--CONVERT(VARCHAR(25), convert(datetime,File_Schedule_Item_Log_Date,103), 106) + ' ' + CONVERT(VARCHAR(25), convert(datetime,File_Schedule_Item_Log_Time,103), 106),
					--CONVERT(VARCHAR(25), convert(datetime,File_Schedule_Item_Log_Date,103), 106)as Date_Format,
			
					File_Schedule_Item_Log_Time,
					File_Schedule_Item_Duration,File_HouseID,Channel_Code,Channel_Name ,Notification_Msg
			FROM #ExceptionReport	order by File_Schedule_Item_Log_Date
			------------------------------------------- DELETE TEMP TABLES -------------------------------------------	
   			IF OBJECT_ID('tempdb..#ExceptionReport') IS NOT NULL
			BEGIN
				DROP TABLE #ExceptionReport
			END
			------------------------------------------- END DELETE TEMP TABLES -------------------------------------------		
    
	if(@Loglevel<2)Exec [USPLogSQLSteps] '[usp_Schedule_AsRun_Exception_Report]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END  