CREATE PROCEDURE [dbo].[USP_Validate_SDM_Title]
--DECLARE
@ValidateXML NVARCHAR(MAX)
--=
--'<RightsData><RequestID>SM1212-33</RequestID>                                                                                                                                   
--<TitleCode>16170</TitleCode><StartDate>26-Dec-2017</StartDate><EndDate>25-May-2019</EndDate>
--<Exclusivity>N</Exclusivity><CountryCode>1</CountryCode><PlatformCodes>121,123</PlatformCodes>
--<TitleLanguage>Y</TitleLanguage><Subtitling>0</Subtitling><Dubbing>0</Dubbing> </RightsData>'
--select * from Acq_Deal_Rights_Platform where Acq_Deal_Rights_Code=6598 AND Platform_Code IN(121,123)
--select * from Acq_Deal_Rights_Platform where Acq_Deal_Rights_Code=6600 AND Platform_Code IN(121,123)
--'<RightsData><RequestID>SM1212-33</RequestID>
--<TitleCode>8052</TitleCode><StartDate>25-May-2017</StartDate><EndDate>24-Apr-2018</EndDate>
--<Exclusivity>N</Exclusivity><CountryCode>33</CountryCode><PlatformCodes>121,123</PlatformCodes>
--<TitleLanguage>Y</TitleLanguage><Subtitling></Subtitling><Dubbing></Dubbing> </RightsData>'
As
-- =============================================        
-- Author:  <Anchal>        
-- Create date: <27 Feb 2017>        
-- Description: <Call From RightsU Plus Web Api and Generate Validation XML For Title>        
 --=============================================   

 --BEGIN
 --select '' AS Response_XML
 --END
BEGIN
	DECLARE @Error_Desc VARCHAR(5000) = '',@Record_Status VARCHAR(5) = 'D'    
	DECLARE @Integration_Config_Code INT
	DECLARE @xml xml,@Request_Time DateTime=GETDATE()
	DECLARE @ResponseXML NVARCHAR(MAX)
	SELECT @xml = CAST(CAST(@ValidateXML AS VARBINARY(MAX)) AS XML) 
	BEGIN  /*Drop TEMP Table If EXISTS*/
			If OBJECT_ID('tempdb..#TempErrorTable') Is Not Null
			Begin
				Drop Table #TempErrorTable
			END
			If OBJECT_ID('tempdb..#Syn_Deal_Rights_Error_Details') Is Not Null
			Begin
				Drop Table #Syn_Deal_Rights_Error_Details
			END
			If OBJECT_ID('tempdb..#Temp_Acq_Dubbing') Is Not Null
			Begin
				Drop Table #Temp_Acq_Dubbing
			End
			If OBJECT_ID('tempdb..#NA_Dubbing') Is Not Null
			Begin
				Drop Table #NA_Dubbing
			End
			If OBJECT_ID('tempdb..#NE_Dubbing') Is Not Null
			Begin
				Drop Table #NE_Dubbing
			End
				
			--If OBJECT_ID('tempdb..#ApprovedAcqData') Is Not Null
			--Begin
			--	Drop Table #ApprovedAcqData
			--End

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
			If OBJECT_ID('tempdb..#NE_Title') Is Not Null
			Begin
				Drop Table #NE_Title
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
			If OBJECT_ID('tempdb..#NE_Country') Is Not Null
			Begin
				Drop Table #NE_Country
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
			If OBJECT_ID('tempdb..#NE_Subtitling') Is Not Null
			Begin
				Drop Table #NE_Subtitling
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
			If OBJECT_ID('tempdb..#Temp') Is Not Null
			Begin
				Drop Table #Temp
			End	
			If OBJECT_ID('tempdb..#Temp_Restriction_Remark') Is Not Null
			Begin
				Drop Table #Temp_Restriction_Remark
			End	
			If OBJECT_ID('tempdb..#NA_Platforms') Is Not Null
			Begin
				Drop Table #NA_Platforms
			End	
			If OBJECT_ID('tempdb..#NE_Platforms') Is Not Null
			Begin
				Drop Table #NE_Platforms
			End	
			If OBJECT_ID('tempdb..#Temp_Acq_WBS') Is Not Null
			Begin
				Drop Table #Temp_Acq_WBS
			End	
		End
--  Iterate through each of the "users\user" records in our XML
	SELECT 
		 x.Rec.query('./RequestID').value('.', 'nvarchar(2000)') AS 'RequestID'
		,x.Rec.query('./TitleCode').value('.', 'nvarchar(2000)') AS 'TitleCode'
		,x.Rec.query('./StartDate').value('.', 'DateTime') AS 'StartDate'
		,x.Rec.query('./EndDate').value('.', 'DateTime') AS 'EndDate'
		,x.Rec.query('./Exclusivity').value('.', 'nvarchar(2000)') AS 'Exclusivity'
		,x.Rec.query('./EpisodeFrom').value('.', 'nvarchar(2000)') AS 'EpisodeFrom'
		,x.Rec.query('./EpisodeTo').value('.', 'nvarchar(2000)') AS 'EpisodeTo'
		,x.Rec.query('./CountryCode').value('.', 'nvarchar(2000)') AS 'CountryCode'
		,x.Rec.query('./PlatformCodes').value('.', 'nvarchar(2000)') AS 'PlatformCode'
		,x.Rec.query('./TitleLanguage').value('.', 'nvarchar(2000)') AS 'TitleLanguage'
		,x.Rec.query('./Subtitling').value('.', 'nvarchar(2000)') AS 'Subtitling'
		,x.Rec.query('./Dubbing').value('.', 'nvarchar(2000)') AS 'Dubbing'
	
		INTO #Temp
	FROM @xml.nodes('/RightsData') as x(Rec)
	DECLARE @IS_PUSH_BACK_SAME_DEAL CHAR(1) ='N'
	--select @IS_PUSH_BACK_SAME_DEAL  = Parameter_Value from System_Parameter_New where Parameter_Name = 'VALIDATE_PUSHBACK_SAME_DEAL'
	--select * from #Temp
	IF((select Count(*) from #Temp)>1)
	BEGIN
		SET @ResponseXML='<Error>Requested Record should not be Greater Then One</Error>'
	END
	ELSE
	BEGIN
	BEGIN TRY
		DECLARE @Syn_Deal_Rights_Code INT=0
		--Select Top 1 @Syn_Deal_Rights_Code = Syn_Deal_Rights_Code From Syn_Deal_Rights_Process_Validation Where Status = 'P' Order By Created_On ASC

		--Update Syn_Deal_Rights_Process_Validation Set Status = 'W' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		--Update Syn_Deal_Rights Set Right_Status = 'W' Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		--Delete From Syn_Deal_Rights_Error_Details Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
		DECLARE   @RequestID VARCHAR(100)
				 ,@TitleCode INT
				 ,@StartDate DateTime
				 ,@EndDate DateTime
				 ,@Exclusivity CHAR(1)
				 ,@EpisodeFrom INT
				 ,@EpisodeTo INT
				 ,@CountryCode INT
				 ,@PlatformCode VARCHAR(1000)
				 ,@TitleLanguage CHAR(1)
				 ,@Subtitling VARCHAR(1000)
				 ,@Dubbing VARCHAR(1000)
		SELECT @RequestID = RequestID ,@TitleCode = TitleCode ,@StartDate = CONVERT(DATETIME,StartDate,106) ,@EndDate = CONVERT(DATETIME,EndDate,106)
		   ,@Exclusivity = Exclusivity ,@EpisodeFrom = CASE WHEN (RTRIM(EpisodeFrom)='' OR EpisodeFrom IS NULL) THEN '1' ELSE EpisodeFrom END
		   ,@EpisodeTo = CASE WHEN (RTRIM(EpisodeTo)='' OR EpisodeTo IS NULL) THEN '1' ELSE EpisodeTo END ,@CountryCode = CountryCode ,@PlatformCode = PlatformCode
		   ,@TitleLanguage = TitleLanguage ,@Subtitling = Subtitling ,@Dubbing = Dubbing
		   FROM #Temp
		--END --DECLARATION PART

		
			Begin /*CREATE TEMP TABLES*/

			CREATE TABLE #Syn_Deal_Rights_Error_Details (
				--[Syn_Deal_Rights_Error_Details_Code] INT           IDENTITY (1, 1) NOT NULL,
				[Syn_Deal_Rights_Code]               INT           NULL,
				[Title_Code]                         VARCHAR (MAX) NULL,
				[Platform_Code]                      VARCHAR (MAX) NULL,
				[Right_Start_Date]                   DATETIME      NULL,
				[Right_End_Date]                     DATETIME      NULL,
				[Right_Type]                         VARCHAR (100) NULL,
				[Is_Sub_Licence]                     VARCHAR (10)  NULL,
				[Is_Title_Language_Right]            VARCHAR (10)  NULL,
				[Country_Code]                       VARCHAR (MAX) NULL,
				[Subtitling_Language_Code]           VARCHAR (MAX) NULL,
				[Dubbing_Language_Code]              VARCHAR (MAX) NULL,
				[Agreement_No]                       VARCHAR (MAX) NULL,
				[ErrorMsg]                           VARCHAR (MAX) NULL,
				[Episode_From]                       INT           NULL,
				[Episode_To]                         INT           NULL,
				[Inserted_On]                        DATETIME      NULL,
				[IsPushback]                         VARCHAR (100) NULL
			);

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
					Right_End_Date DATETIME  Null,
					Is_Title_Language_Right CHAR(1),
					Country_Code Int,
					Terrirory_Type CHAR(1),
					Is_exclusive CHAR(1),
					Subtitling_Language_Code Int,
					Dubbing_Language_Code Int,
					Data_From CHAR(1),
					Is_Available CHAR(1),
					Error_Description VARCHAR(MAX),
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
					Right_End_Date DATETIME  Null,
					Is_Title_Language_Right CHAR(1),
					Country_Code Int,
					Terrirory_Type CHAR(1),
					Is_exclusive CHAR(1),
					Subtitling_Language_Code Int,
					Dubbing_Language_Code Int,
					Data_From CHAR(1),
					Is_Available CHAR(1),
					Error_Description VARCHAR(MAX),
					Sum_of Int,
					Partition_Of Int
				)

				Create Table #Temp_Restriction_Remark
				(
					PlatformCodes Varchar(MAX),
					Restriction_Remark Varchar(MAX),
				)
				CREATE TABLE #TempErrorTable(Error_Code varchar(100),Err_Desc VARCHAR(100)) 
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1001','Title not acquired'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1002','Platform not acquired'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1003','Subtitling Language not acquired'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1004','Dubbing Language not acquired'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1005','Region not acquired'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1006','Rights period mismatch'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1007','Title Language not acquired'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1008','Combination already Syndicated'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1009','Combination conflicts with other Rights'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1010','Platform does not Exist'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1011','Region does not Exist'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1012','Subtitling Language does not Exist'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1013','Dubbing Language does not Exist'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1014','Title does not Exist'
				INSERT INTO #TempErrorTable(Error_Code,Err_Desc) SELECT 'ERR1015','Atleast One Language Required'

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
			--Select @CallFrom = 'N'
			--Case When IsNull(Is_Pushback, 'N') = 'N' Then 'SR' Else 'SP' End  From Syn_Deal_Rights  
			--Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			BEGIN
				Insert InTo @Deal_Rights_Title(Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
				Select  0, @TitleCode, @EpisodeFrom, @EpisodeTo

				Insert InTo @Deal_Rights_Platform(Deal_Rights_Code,Platform_Code)
				SELECT 0,number FROM dbo.[fn_Split_withdelemiter](RTRIM(@PlatformCode),',') --where ISNULL(number,'')!='' 

				Insert InTo @Deal_Rights_Territory(Deal_Rights_Code, Country_Code)
				SELECT 0,RTRIM(@CountryCode)

				Insert InTo @Deal_Rights_Subtitling(Deal_Rights_Code, Subtitling_Code)
				SELECT 0,CONVERT(INT,number,0) FROM dbo.[fn_Split_withdelemiter](RTRIM(@Subtitling),',') where ISNULL(number,'')!=''

				Insert InTo @Deal_Rights_Dubbing(Deal_Rights_Code, Dubbing_Code)
				SELECT 0,CONVERT(INT,number,0) FROM dbo.[fn_Split_withdelemiter](@Dubbing,',') where ISNULL(number,'')!=''

				Declare @Dup_Records Dup_Records, @Dup_Records_Language Dup_Records_Language, @NE_Records Dup_Records_Language
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
			END
			-- =============================================Assign Values To Local Variable =============================================	        
			Select 
				@Deal_Code=0,
				@Deal_Rights_Code = 0, --Case When @CallFrom = 'SR' Then dr.Deal_Rights_Code Else dr.Deal_Rights_Code End,
				@Deal_Pushback_Code = 0 ,
				@Right_Start_Date=@StartDate,
				@Right_End_Date=@EndDate,
				@Right_Type='Y',
				@Is_Exclusive=@Exclusivity,
				@Is_Tentative='N',
				@Is_Sub_License='Y',
				@Sub_License_Code=1,
				@Is_Title_Language_Right=@TitleLanguage,	
				@Title_Code=0,
				@Platform_Code=0,
				@Is_Theatrical_Right='N'
			--From Syn_Deal_Rights dr Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code

			-- ============== Start Abhay's code ================

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

			-- ============== End Abhay's code ================
		
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
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) 
							And (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
							When (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) 
							And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
							When (@Right_Start_Date < ADR.Actual_Right_Start_Date) And (@Right_End_Date > ADR.Actual_Right_End_Date)
								Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date))
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) 
							And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
							Else 0 
						End
					)Sum_of,
					Sum(
						Case 
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) 
							And (@Right_End_Date Not Between ADR.Actual_Right_Start_Date  And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))   
							When (@Right_Start_Date Not Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) 
							And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d, ADR.Actual_Right_Start_Date,DATEADD(d,1, @Right_End_Date))
							When (@Right_Start_Date < ADR.Actual_Right_Start_Date) And (@Right_End_Date > ADR.Actual_Right_End_Date)
								Then datediff(d,ADR.Actual_Right_Start_Date, DATEADD(d,1, ADR.Actual_Right_End_Date ))
							When (@Right_Start_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date) 
							And (@Right_End_Date Between ADR.Actual_Right_Start_Date And ADR.Actual_Right_End_Date)
								Then datediff(d,@Right_Start_Date,DATEADD(d,1, @Right_End_Date  ))
							Else 0 
						End
					)
					OVER(
						PARTITION BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, 
						Is_Title_Language_Right,Is_Exclusive, adr.Acq_Deal_Code
					) Partition_Of
					InTo #Acq_Deal_Rights
			From Acq_Deal_Rights ADR
			Inner Join Acq_Deal AD On ADR.Acq_Deal_Code = ad.Acq_Deal_Code And IsNull(AD.Deal_Workflow_Status,'') = 'A'
			Where 
			ADR.Acq_Deal_Code Is Not Null
			And ADR.Is_Sub_License='Y'
			And ADR.Is_Tentative='N'
			And
			(
				(
					ADR.Right_Type ='Y' 
					And
					(
						(
							CONVERT(DATETIME, @Right_Start_Date, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) 
							And Convert(DATETIME, ADR.Right_End_Date, 103)					
						)
						OR
						(
							CONVERT(DATETIME, @Right_End_Date, 103) Between CONVERT(DATETIME, ADR.Right_Start_Date, 103) 
							And CONVERT(DATETIME, ADR.Right_End_Date, 103)
						)
						Or
						(
							CONVERT(DATETIME, ADR.Right_Start_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) 
							And CONVERT(DATETIME, @Right_End_Date, 103)
						)
						Or
						(
							CONVERT(DATETIME, ADR.Right_End_Date, 103) Between CONVERT(DATETIME, @Right_Start_Date, 103) 
							And CONVERT(DATETIME, @Right_End_Date, 103)
						)
					)
				)
				Or
				(
					(
						ADR.Right_Type ='U'
					)
					Or ADR.Right_Type ='M'
				)
			)
			And ( 
				(   
					(ADR.Is_Title_Language_Right = @Is_Title_Language_Right)
					Or 
					(@Is_Title_Language_Right <> 'Y' And ADR.Is_Title_Language_Right = 'Y')
					Or 
					(@Is_Title_Language_Right = 'Y' And ADR.Is_Title_Language_Right = 'N')
				)
			) 
			And (
				(@Is_Exclusive = 'Y' And IsNull(ADR.Is_exclusive,'')='Y')
				Or @Is_Exclusive = 'N'
			) 
			GROUP BY ADR.Acq_Deal_Rights_Code, Right_Type, Actual_Right_Start_Date, Actual_Right_End_Date, Is_Title_Language_Right
			,Is_Exclusive, adr.Acq_Deal_Code, AD.Agreement_No

				--Select * From #Acq_Deal_Rights
				--Select @Right_Start_Date, @Right_End_Date
				--Select * From #Acq_Deal_Rights

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

				--select * from #Acq_Titles_With_Rights
				Select Distinct 0 AS Acq_Deal_Rights_Code, drt.Title_Code, drt.Episode_From, drt.Episode_To, 0 AS SubCnt, 0 AS DubCnt,
								0 AS Sum_of, 0 AS Partition_Of
				InTo #NE_Title
				from @Deal_Rights_Title drt where drt.Title_Code NOT IN(select Distinct Title_Code from Title)

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
					Insert InTo #Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Right_Start_Date, Right_End_Date, 
																Right_Type, Is_Sub_Licence, Is_Title_Language_Right, Country_Code, 
																Subtitling_Language_Code, Dubbing_Language_Code, Agreement_No, ErrorMsg, Episode_From,
																Episode_To, Inserted_On ,IsPushback)
					Select @Syn_Deal_Rights_Code, tnt.Title_Code, Null, Null, Null,Null, Null, Null, Null, Null,Null, Null, 'Title not acquired', 
							Episode_From, Episode_To, GETDATE(), Null
					From #Temp_NA_Title tnt
					Inner Join Title t On tnt.Title_Code = t.Title_Code

					Drop Table #Temp_NA_Title
					Set @Is_Error = 'Y'
				End
				
				If Exists(Select Top 1 * From #NE_Title)
				Begin
					Insert InTo #Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Right_Start_Date, Right_End_Date, 
																Right_Type, Is_Sub_Licence, Is_Title_Language_Right, Country_Code, 
																Subtitling_Language_Code, Dubbing_Language_Code, Agreement_No, ErrorMsg, Episode_From,
																Episode_To, Inserted_On ,IsPushback)
					Select @Syn_Deal_Rights_Code, tnt.Title_Code, Null, Null, Null,Null, Null, Null, Null, Null,Null, Null, 'Title does not exist', 
							Episode_From, Episode_To, GETDATE(), Null
					From #NE_Title tnt

					Drop Table #NE_Title
					Set @Is_Error = 'Y'
				End

			End ------------------------------ END

			--Select * From @Deal_Rights_Platform

			Begin ----------------- CHECK PLATFORM And TITLE & EPISODE EXISTS OR NOT
			--select * from #Acq_Titles_With_Rights
				Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRP.Platform_Code
				InTo #Temp_Platforms
				From #Acq_Titles DRT
				Inner Join @Deal_Rights_Platform DRP On 1 = 1

				--select * from @Deal_Rights_Platform
				Drop Table #Acq_Titles

				Select art.*, adrp.Platform_Code InTo #Temp_Acq_Platform From #Acq_Titles_With_Rights art
				Inner Join Acq_Deal_Rights_Platform adrp On adrp.Acq_Deal_Rights_Code = art.Acq_Deal_Rights_Code
				Inner Join @Deal_Rights_Platform drp On adrp.Platform_Code = drp.Platform_Code
				
				Select art.Title_Code,T.Title_Name,adr.Actual_Right_Start_Date,adr.Actual_Right_End_Date,SW.WBS_Code AS WBS_Code
				InTo #Temp_Acq_WBS  
				From #Acq_Titles_With_Rights art
				Inner Join Acq_Deal_Rights adr ON adr.Acq_Deal_Rights_Code = art.Acq_Deal_Rights_Code
				Inner join Acq_Deal_Budget adb ON adb.Acq_Deal_Code=adr.Acq_Deal_Code
				AND adb.Title_Code=art.Title_Code AND adb.Episode_From=art.Episode_From AND adb.Episode_To=art.Episode_To
				INNER JOIN SAP_WBS SW ON SW.SAP_WBS_Code=adb.SAP_WBS_Code
				INNER JOIN Title T ON T.Title_Code=art.Title_Code
				Drop Table #Acq_Titles_With_Rights
				--Select * From #Temp_Acq_WBS
				IF EXISTS(Select * From #Temp_Acq_Platform)
				BEGIN
				INSERT INTO #Temp_Restriction_Remark(Restriction_Remark,PlatformCodes)
					select DISTINCT Restriction_Remarks 
					,STUFF
					(
						(
						Select Distinct ',' + CAST(adrp.Platform_Code as Varchar) 
						
							  From Acq_Deal_Rights_Platform adrp
							Inner Join @Deal_Rights_Platform drp ON adrp.Platform_Code=drp.Platform_Code
						FOR XML PATH('')), 1, 1, ''
					) 
					--'0' 
					as PlatformCodes
					from Acq_Deal_Rights 
					where Acq_Deal_Rights_Code IN(Select DISTINCT Acq_Deal_Rights_Code From #Temp_Acq_Platform)
				END
				

				Delete From #Temp_Acq_Platform Where Platform_Code Not In (Select Platform_Code From #Temp_Platforms)
				

				Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRT.Platform_Code InTo #NE_Platforms
				From #Temp_Platforms DRT
				Where DRT.Platform_Code Not In (
					Select DISTINCT Platform_Code From [Platform] ap
				)

				Select Distinct DRT.Title_Code, Episode_From, Episode_To, DRT.Platform_Code InTo #NA_Platforms
				From #Temp_Platforms DRT
				Where DRT.Platform_Code Not In (
					Select ap.Platform_Code From #Temp_Acq_Platform ap
					Where DRT.Title_Code = ap.Title_Code And DRT.Episode_From = ap.Episode_From And DRT.Episode_To = ap.Episode_To
				)
				AND DRT.Platform_Code Not In (select DISTINCT Platform_Code FROM #NE_Platforms)
				

				Delete From #Temp_Platforms Where #Temp_Platforms.Platform_Code In (
					Select np.Platform_Code From #NA_Platforms np
					Where np.Title_Code = #Temp_Platforms.Title_Code And np.Episode_From = #Temp_Platforms.Episode_From 
					And np.Episode_To = #Temp_Platforms.Episode_To
				)

				Delete From #Temp_Platforms Where #Temp_Platforms.Platform_Code In (
					Select np.Platform_Code From #NE_Platforms np
					Where np.Title_Code = #Temp_Platforms.Title_Code And np.Episode_From = #Temp_Platforms.Episode_From 
					And np.Episode_To = #Temp_Platforms.Episode_To
				)

				Insert InTo @Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
				Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, 0, '', 
						@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Platform not acquired', @Is_Title_Language_Right 
				From #NA_Platforms np
				
				Insert InTo @NE_Records(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, 
				Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, 0, '', 
						@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Platform does not Exist', @Is_Title_Language_Right 
				From #NE_Platforms np

				Drop Table #NA_Platforms
				Drop Table #NE_Platforms

			End ------------------------------ END
	
			Begin ----------------- CHECK COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT
			
				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tc.Country_Code InTo #Temp_Country
				From #Temp_Platforms tp
				Inner Join @Deal_Rights_Territory TC On 1 = 1

				Drop Table #Temp_Platforms

				Declare @Thetrical_Platform_Code Int = 0, @Domestic_Country Int = 0
				Select @Thetrical_Platform_Code = Cast(Parameter_Value As Int) From System_Parameter_New 
				Where Parameter_Name = 'THEATRICAL_PLATFORM_CODE'
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
					Insert InTo #Temp_Acq_Country(Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Sum_of,
					 partition_of)
					Select tp.Acq_Deal_Rights_Code, tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, c.Country_Code,tp.Sum_of, 
					tp.partition_of
					From (
						Select * From #Temp_Acq_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country
					) As tp Inner Join Country c On c.Parent_Country_Code = tp.Country_Code

					Delete From #Temp_Acq_Country Where Platform_Code = @Thetrical_Platform_Code And Country_Code = @Domestic_Country

				End
			
				Delete From #Temp_Acq_Country Where Country_Code Not In (Select Country_Code From #Temp_Country)

				Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code InTo #NE_Country
				From #Temp_Country DRC
				Where DRC.Country_Code Not In (
					Select ac.Country_Code From #Temp_Acq_Country ac
					Where DRC.Title_Code = ac.Title_Code And DRC.Episode_From = ac.Episode_From And DRC.Episode_To = ac.Episode_To 
					And DRC.Platform_Code = ac.Platform_Code
				)

				Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code InTo #NA_Country
				From #Temp_Country DRC
				Where DRC.Country_Code Not In (
					Select ac.Country_Code From #Temp_Acq_Country ac
					Where DRC.Title_Code = ac.Title_Code And DRC.Episode_From = ac.Episode_From And DRC.Episode_To = ac.Episode_To 
					And DRC.Platform_Code = ac.Platform_Code
				) AND DRC.Country_Code Not In (
					SELECT DISTINCT Country_Code FROM #NE_Country
				)

				Delete From #Temp_Country Where #Temp_Country.Country_Code In (
					Select np.Country_Code From #NA_Country np
					Where np.Title_Code = #Temp_Country.Title_Code And np.Episode_From = #Temp_Country.Episode_From 
							And np.Episode_To = #Temp_Country.Episode_To And np.Platform_Code = #Temp_Country.Platform_Code
				)
				Delete From #Temp_Country Where #Temp_Country.Country_Code In (
					Select np.Country_Code From #NE_Country np
					Where np.Title_Code = #Temp_Country.Title_Code And np.Episode_From = #Temp_Country.Episode_From 
							And np.Episode_To = #Temp_Country.Episode_To And np.Platform_Code = #Temp_Country.Platform_Code
				)
			
				Insert InTo @Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code,
				 Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Region not acquired', @Is_Title_Language_Right 
				From #NA_Country np

				Insert InTo @NE_Records(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code,
				 Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right
				)
				Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
						@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Region does not Exist', @Is_Title_Language_Right 
				From #NE_Country np

				Drop Table #NA_Country
				Drop Table #NE_Country

				If(@Is_Title_Language_Right = 'Y')
				Begin
				print 'Is_Title_Language_Right'
					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, 
															Right_End_Date, Is_Title_Language_Right, Country_Code, Terrirory_Type, Is_exclusive, 
															Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, 
															Error_Description, Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, 
					@Is_Title_Language_Right, T.Country_Code, 'I', @Is_Exclusive, 0, 0, 'S', 'N', 'Session',
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End Sum_of,
						Case 
							When @Right_End_Date Is Null Then 0 Else datediff(D, @Right_Start_Date, DATEADD(D, 1, @Right_End_Date))
						End partition_of
					From #Temp_Country T
				End
				IF((RTRIM(@Is_Title_Language_Right)='N' OR RTRIM(@Is_Title_Language_Right)='' ) AND (RTRIM(@Subtitling)='0' OR RTRIM(@Subtitling)='') AND (RTRIM(@Dubbing)='0' OR RTRIM(@Dubbing)='')) 
				BEGIN
					Insert InTo @NE_Records(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, 
														Country_Code, Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, 
														Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					SELECT DISTINCT '', 0,T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code,T.Country_Code,'I', @Right_Start_Date, @Right_End_Date, @Right_Type, 
					@Is_Sub_License, 'Atleast One Language Required',@Is_Title_Language_Right, '',''
					From #Temp_Country T
				END
				
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
				--select * from #TempCombination
			End ------------------------------ END

			Begin ----------------- CHECK SUBTITLING And COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT


				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Subtitling_Code
				InTo #Temp_Subtitling
				From #Temp_Country tp
				Inner Join @Deal_Rights_Subtitling ts On 1 = 1

				If Exists(Select Top 1 * From @Deal_Rights_Subtitling)
				Begin
				--select * from @Deal_Rights_Subtitling
					Select Acq_Deal_Rights_Code, Case When sub.Language_Type = 'G' Then lgd.Language_Code Else sub.Language_Code End Language_Code 
					InTo #Acq_Sub
					From (
						Select Acq_Deal_Rights_Code, Language_Type, Language_Code, Language_Group_Code 
						From Acq_Deal_Rights_Subtitling adrs 
						Where Acq_Deal_Rights_Code In (Select Acq_Deal_Rights_Code from #Acq_Deal_Rights)
					)As sub
					Left Join Language_Group_Details lgd On sub.Language_Group_Code = lgd.Language_Group_Code 
					--select * from #Acq_Sub where Language_Code=2365
					Delete From #Acq_Sub Where Language_Code Not In (Select Subtitling_Code From @Deal_Rights_Subtitling)
					--select * from #Acq_Sub
					Select tac.*, adrs.Language_Code InTo #Temp_Acq_Subtitling From #Temp_Acq_Country tac
					Inner Join #Acq_Sub adrs On tac.Acq_Deal_Rights_Code = adrs.Acq_Deal_Rights_Code 
					--And tac.SubCnt > 0 --Commented BY Sagar (For Domestic logic)
					--select * from #Temp_Acq_Subtitling
					Drop Table #Acq_Sub
					
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Subtitling_Code 
					InTo #NE_Subtitling
					From #Temp_Subtitling DRC
					Where DRC.Subtitling_Code Not In (
						Select DISTINCT Language_Code From Language
					)
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Subtitling_Code 
					InTo #NA_Subtitling
					From #Temp_Subtitling DRC
					Where DRC.Subtitling_Code Not In (
						Select asub.Language_Code From #Temp_Acq_Subtitling asub
						Where DRC.Title_Code = asub.Title_Code And DRC.Episode_From = asub.Episode_From And DRC.Episode_To = asub.Episode_To 
						And DRC.Platform_Code = asub.Platform_Code And DRC.Country_Code = asub.Country_Code
					)
					AND DRC.Subtitling_Code Not In (SELECT DISTINCT Platform_Code FROM #NE_Subtitling)

					Delete From #Temp_Subtitling Where #Temp_Subtitling.Subtitling_Code In (
						Select asub.Subtitling_Code From #NA_Subtitling asub
						Where #Temp_Subtitling.Title_Code = asub.Title_Code And #Temp_Subtitling.Episode_From = asub.Episode_From 
						And #Temp_Subtitling.Episode_To = asub.Episode_To And #Temp_Subtitling.Platform_Code = asub.Platform_Code 
						And #Temp_Subtitling.Country_Code = asub.Country_Code
					)
					Delete From #Temp_Subtitling Where #Temp_Subtitling.Subtitling_Code In (
						Select asub.Subtitling_Code From #NE_Subtitling asub
						Where #Temp_Subtitling.Title_Code = asub.Title_Code And #Temp_Subtitling.Episode_From = asub.Episode_From 
						And #Temp_Subtitling.Episode_To = asub.Episode_To And #Temp_Subtitling.Platform_Code = asub.Platform_Code 
						And #Temp_Subtitling.Country_Code = asub.Country_Code
					)

					Insert InTo @Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, 
														Country_Code, Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, 
														Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', @Right_Start_Date, @Right_End_Date, 
							@Right_Type, @Is_Sub_License, 'Subtitling Language not acquired', @Is_Title_Language_Right, Subtitling_Code, 0
					From #NA_Subtitling nsub

					Insert InTo @NE_Records(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, 
														Country_Code, Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, 
														Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', @Right_Start_Date, @Right_End_Date, 
							@Right_Type, @Is_Sub_License, 'Subtitling Language does not Exist', @Is_Title_Language_Right, Subtitling_Code, 0
					From #NE_Subtitling nsub
					
					Drop Table #NA_Subtitling
					Drop Table #NE_Subtitling

					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, 
															Right_End_Date, Is_Title_Language_Right,Country_Code, Terrirory_Type, Is_exclusive, 
															Subtitling_Language_Code, Dubbing_Language_Code, Data_From, Is_Available, 
															Error_Description, Sum_of, partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date,
									@Is_Title_Language_Right, T.Country_Code, 'I', @Is_Exclusive, Subtitling_Code, 0, 'S', 'N', 'Session',
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

					Drop Table #Temp_Acq_Subtitling
				End
				Else
				Begin
				
					Insert InTo @Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, 
													  Country_Code, Territory_Type, Right_Start_Date, Right_End_Date, Right_Type,
													  Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
							@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Subtitling Language not acquired', 
							@Is_Title_Language_Right, Subtitling_Code, 0
					From #Temp_Subtitling nsub

				End

				Drop Table #Temp_Subtitling

			End ------------------------------ END
			
			--BEGIN ----AtLeast One Language Required
			--	IF((RTRIM(@Is_Title_Language_Right)='N' OR RTRIM(@Is_Title_Language_Right)='' ) AND (RTRIM(@Subtitling)='0' OR RTRIM(@Subtitling)='') AND (RTRIM(@Dubbing)='0' OR RTRIM(@Dubbing)='')) 
			--	BEGIN
			--		Insert InTo @NE_Records(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, 
			--											Country_Code, Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, 
			--											Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
			--		)
			--		Select '', 0, @TitleCode, @EpisodeFrom, @EpisodeTo, 0, @CountryCode, '', @StartDate, @EndDate, 
			--				@Right_Type, @Is_Sub_License, 'Atleast One Language Required', @Is_Title_Language_Right, 0, 0
			--		--From #NE_Subtitling nsub
			--	END
			--END
			
			Begin ----------------- CHECK DUBBING And COUNTRY And PLATFORM And TITLE & EPISODE EXISTS OR NOT


				Select Distinct tp.Title_Code, tp.Episode_From, tp.Episode_To, tp.Platform_Code, tp.Country_Code, ts.Dubbing_Code
				InTo #Temp_Dubbing
				From #Temp_Country tp
				Inner Join @Deal_Rights_Dubbing ts On 1 = 1

				Drop Table #Temp_Country

				If Exists(Select Top 1 * From @Deal_Rights_Dubbing)
				Begin

					Select Acq_Deal_Rights_Code, Case When dub.Language_Type = 'G' Then lgd.Language_Code Else dub.Language_Code End Language_Code 
					InTo #Acq_Dub
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
					--Select * From #Temp_Dubbing
					--Select * From #Temp_Acq_Dubbing
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Dubbing_Code 
					InTo #NE_Dubbing
					From #Temp_Dubbing DRC
					Where DRC.Dubbing_Code Not In (
						Select DISTINCT Language_Code From Language
					)
					Select Distinct DRC.Title_Code, DRC.Episode_From, DRC.Episode_To, DRC.Platform_Code, DRC.Country_Code, DRC.Dubbing_Code 
					InTo #NA_Dubbing
					From #Temp_Dubbing DRC
					Where DRC.Dubbing_Code Not In (
						Select adub.Language_Code From #Temp_Acq_Dubbing adub
						Where DRC.Title_Code = adub.Title_Code And DRC.Episode_From = adub.Episode_From And DRC.Episode_To = adub.Episode_To 
						And DRC.Platform_Code = adub.Platform_Code And DRC.Country_Code = adub.Country_Code
					)
					AND DRC.Dubbing_Code NOT IN (select DISTINCT Dubbing_Code from #NE_Dubbing)
					
					--Select * From #NA_Dubbing
					Delete From #Temp_Dubbing Where #Temp_Dubbing.Dubbing_Code In (
						Select adub.Dubbing_Code From #NA_Dubbing adub
						Where #Temp_Dubbing.Title_Code = adub.Title_Code And #Temp_Dubbing.Episode_From = adub.Episode_From 
						And #Temp_Dubbing.Episode_To = adub.Episode_To And #Temp_Dubbing.Platform_Code = adub.Platform_Code 
						And #Temp_Dubbing.Country_Code = adub.Country_Code
					)
					
					Delete From #Temp_Dubbing Where #Temp_Dubbing.Dubbing_Code In (
						Select adub.Dubbing_Code From #NE_Dubbing adub
						Where #Temp_Dubbing.Title_Code = adub.Title_Code And #Temp_Dubbing.Episode_From = adub.Episode_From 
						And #Temp_Dubbing.Episode_To = adub.Episode_To And #Temp_Dubbing.Platform_Code = adub.Platform_Code 
						And #Temp_Dubbing.Country_Code = adub.Country_Code
					)
					
					
					Insert InTo @Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, 
													  Country_Code, Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, 
													  ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
							@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Dubbing Language not acquired',
							@Is_Title_Language_Right, 0, Dubbing_Code
					From #NA_Dubbing nsub

					Insert InTo @NE_Records(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, 
													  Country_Code, Territory_Type, Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, 
													  ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
							@Right_Start_Date, @Right_End_Date, @Right_Type, @Is_Sub_License, 'Dubbing Language does not Exist',
							@Is_Title_Language_Right, 0, Dubbing_Code
					From #NE_Dubbing nsub
					
					Drop Table #NA_Dubbing
					Drop Table #NE_Dubbing

					INSERT INTO #TempCombination_Session(Title_Code, Episode_From, Episode_To, Platform_Code, Right_Type, Right_Start_Date, 
														 Right_End_Date, Is_Title_Language_Right,Country_Code, Terrirory_Type, Is_exclusive, 
														 Subtitling_Language_Code, Dubbing_Language_Code,Data_From, Is_Available, Error_Description,
														 Sum_of,partition_of)
					SELECT DISTINCT T.Title_Code, T.Episode_From, T.Episode_To, T.Platform_Code, @Right_Type, @Right_Start_Date, @Right_End_Date, 
									@Is_Title_Language_Right, T.Country_Code, 'I', @Is_Exclusive, 0, Dubbing_Code,
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
					Drop Table #Temp_Acq_Dubbing
				End
				Else
				Begin
				
					Insert InTo @Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, 
													  Country_Code, Territory_Type,Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, 
													  ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
					)
					Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', @Right_Start_Date, @Right_End_Date, 
						   @Right_Type, @Is_Sub_License, 'Dubbing Language not acquired', @Is_Title_Language_Right, 0, Dubbing_Code
					From #Temp_Dubbing nsub

				End

				Drop Table #Temp_Dubbing
			End ------------------------------ END
			
			Drop Table #Temp_Acq_Country
			Drop Table #Temp_Episode_No
			Drop Table #Deal_Right_Title_WithEpsNo
			Drop Table #Acq_Deal_Rights
			--Select @Right_Start_Date, @Right_End_Date
			--Select * From #TempCombination_Session
			--Select * From #TempCombination

			--Select c.* 
			Update b Set b.Sum_of = c.Sum_of
			From (
				Select a.Title_Code, a.Episode_From, a.Episode_To, a.Platform_Code, a.Country_Code, a.Subtitling_Language_Code,
					   a.Dubbing_Language_Code, Sum(IsNull(a.Sum_of, 0)) As Sum_of
				From #TempCombination As a
				Group By a.Title_Code, a.Episode_From, a.Episode_To, a.Platform_Code, a.Country_Code, a.Subtitling_Language_Code,
						 a.Dubbing_Language_Code
			) AS c
			Inner Join #TempCombination b On c.Title_Code = b.Title_Code And c.Episode_From = b.Episode_From And c.Episode_To = b.Episode_To And
											 c.Platform_Code = b.Platform_Code And c.Country_Code = b.Country_Code And 
											 c.Subtitling_Language_Code = b.Subtitling_Language_Code And c.Dubbing_Language_Code = b.Dubbing_Language_Code

			--Update b Set b.Sum_of = (
			--	Select Sum(c.Sum_of) From(
			--		Select Distinct a.Title_Code, a.Episode_From, a.Episode_To, a.Platform_Code, a.Country_Code, a.Subtitling_Language_Code,
			--						a.Dubbing_Language_Code, a.Sum_of From #TempCombination As a
			--	) as c Where c.Title_Code = b.Title_Code And c.Episode_From = b.Episode_From And c.Episode_To = b.Episode_To And
			--				 c.Platform_Code = b.Platform_Code And c.Country_Code = b.Country_Code 
			--				 And c.Subtitling_Language_Code = b.Subtitling_Language_Code And c.Dubbing_Language_Code = b.Dubbing_Language_Code
			--) From #TempCombination b			

			CREATE TABLE #Min_Right_Start_Date
			(
				Title_Code INT,
				Min_Start_Date DateTime
			)
			
			INSERT INTO #Min_Right_Start_Date
			SELECT T1.Title_Code,MIN(T1.Right_Start_Date) FROM  #TempCombination T1
			GROUP BY T1.Title_Code
			--select @Right_Start_Date
			--select * from #Min_Right_Start_Date
			--select * from #TempCombination
			IF(@Right_Type ='U' AND EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination WHERE Right_Type='U')
			 AND NOT EXISTS(SELECT TOP 1 Right_Type FROM #TempCombination WHERE Right_Type='Y'))
			BEGIN				
				DELETE T1 				
				FROM #TempCombination T1 
				INNER JOIN #Min_Right_Start_Date MRSD ON T1.Title_Code = MRSD.Title_Code
				WHERE CONVERT(DATETIME, @Right_Start_Date, 103) <= CONVERT(DATETIME, IsNull(T1.Right_Start_Date,''), 103)				
			END
			--select @Right_Start_Date
			--select * from #TempCombination_Session
			--select * from #TempCombination
			--select datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))
			Update t2 Set t2.Is_Available = 'Y'
			From #TempCombination_Session t2 
			LEFT join #Min_Right_Start_Date MRSD on T2.Title_Code = MRSD.Title_Code
			Inner Join #TempCombination t1 On 
			T1.Title_Code = T2.Title_Code And 
			T1.Episode_From = T2.Episode_From And 
			T1.Episode_To = T2.Episode_To And 
			T1.Platform_Code = T2.Platform_Code And 
			T1.Country_Code= T2.Country_Code And 
			T1.Subtitling_Language_Code = T2.Subtitling_Language_Code And 
			T1.Dubbing_Language_Code = T2.Dubbing_Language_Code  
			And 
			(
				(
					(t1.sum_of = (Case When T2.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  Else 0 End))
					Or
					(
						(
							T1.Right_Type = 'U'
							Or
							T2.Right_Type = 'U'
						)
						And
						(
							CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, IsNull(MRSD.MIN_Start_DATE,t1.Right_Start_Date), 103)
							--CONVERT(DATETIME, @Right_Start_Date, 103) >= CONVERT(DATETIME, IsNull(T1.Right_Start_Date,''), 103)
						)
					)
				)
				Or
				(
					t1.Partition_Of = (Case When T2.Right_Type != 'U' Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  Else 0 End)
				)
			)
			
			DROP TABLE #Min_Right_Start_Date
			--select * from #TempCombination
			Update #TempCombination_Session Set Error_Description = (
				Case 
					When (Select Count(*) Title_Code From #TempCombination a Where #TempCombination_Session.Title_Code = a.Title_Code) = 0
					Then 'TITLE_MISMATCH' Else '' 
				End + 
				Case 
					When (Select Count(*) From #TempCombination a 
							Where #TempCombination_Session.Title_Code = a.Title_Code And a.Platform_Code = #TempCombination_Session.Platform_Code) = 0 
							Then 'PLATFORM_MISMATCH' Else '' 
				End +
				Case 
					When (Select Count(*) Title_Code From #TempCombination a 
								Where #TempCombination_Session.Title_Code = a.Title_Code And a.Platform_Code = #TempCombination_Session.Platform_Code
										And a.Country_Code = #TempCombination_Session.Country_Code) = 0 
					Then 'COUNTRY_MISMATCH' Else '' 
				End +
				Case 
					When #TempCombination_Session.Is_Title_Language_Right = 'Y' 
							And #TempCombination_Session.Subtitling_Language_Code = 0
							And #TempCombination_Session.Dubbing_Language_Code = 0
							And (Select Count(*) Title_Code From #TempCombination a 
								Where #TempCombination_Session.Title_Code = a.Title_Code And a.Platform_Code = #TempCombination_Session.Platform_Code
									  And a.Country_Code = #TempCombination_Session.Country_Code And #TempCombination_Session.Subtitling_Language_Code = 0
									  And 0 = #TempCombination_Session.Dubbing_Language_Code 
									  And #TempCombination_Session.Is_Title_Language_Right = a.Is_Title_Language_Right) = 0 
					Then 'TITLE_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When #TempCombination_Session.Dubbing_Language_Code > 0 And (Select Count(*) Title_Code From #TempCombination a 
								Where #TempCombination_Session.Title_Code = a.Title_Code And a.Platform_Code = #TempCombination_Session.Platform_Code
									  And a.Country_Code = #TempCombination_Session.Country_Code And #TempCombination_Session.Subtitling_Language_Code = 0
									  And a.Dubbing_Language_Code = #TempCombination_Session.Dubbing_Language_Code) = 0 
					Then 'DUBBING_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When #TempCombination_Session.Subtitling_Language_Code > 0 And (Select Count(*) Title_Code From #TempCombination a 
								Where #TempCombination_Session.Title_Code = a.Title_Code And a.Platform_Code = #TempCombination_Session.Platform_Code
									  And a.Country_Code = #TempCombination_Session.Country_Code And #TempCombination_Session.Subtitling_Language_Code = a.Subtitling_Language_Code
									  And 0 = #TempCombination_Session.Dubbing_Language_Code) = 0 
					Then 'SUBTITLING_LANGAUGE_RIGHT' Else '' 
				End +
				Case 
					When (Select Count(*) Title_Code From #TempCombination a 
								Where #TempCombination_Session.Title_Code = a.Title_Code And a.Platform_Code = #TempCombination_Session.Platform_Code
									  And a.Country_Code = #TempCombination_Session.Country_Code And #TempCombination_Session.Subtitling_Language_Code = a.Subtitling_Language_Code
									  And a.Dubbing_Language_Code = #TempCombination_Session.Dubbing_Language_Code
									  And (( 
											(#TempCombination_Session.sum_of = (CASE WHEN a.Right_Type != 'U' 
											Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  ELSE 0 END))
												OR            
												(
													(
														#TempCombination_Session.Right_Type = 'U'
														OR
														a.Right_Type = 'U'
													)
													AND
													(
														CONVERT(DATETIME, @Right_Start_Date, 103) >=
														CONVERT(DATETIME, ISNULL(#TempCombination_Session.Right_Start_Date,'') , 103)
													)
												)
											)
											OR
											(
												#TempCombination_Session.partition_of = (CASE WHEN a.Right_Type != 'U' 
												Then datediff(d,@Right_Start_Date,dateadd(d,1,@Right_End_Date))  ELSE 0 END)          
											)           
										)) = 0 
					Then 'RIGHT_PERIOD' Else '' 
				End
			)
			Where Is_Available='N'
			
			--select * from #TempCombination_Session
			--Select Error_Description, * From #TempCombination_Session Where Title_Code = 5159 And Is_Available='N'
			BEGIN --Update #TempCombination_Session
			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title not acquired') 
			Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired') 
			Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired') 
			Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_MISMATCHPLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired') Where Is_Available='N'
	
			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')
			Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'PLATFORM_MISMATCHCOUNTRY_MISMATCHDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired') Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'PLATFORM_MISMATCHCOUNTRY_MISMATCHSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'PLATFORM_MISMATCHCOUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Platform not acquired')Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_LANGAUGE_RIGHTSUBTITLING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&SUBTITLING_LANGAUGE_RIGHT') Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_LANGAUGE_RIGHTDUBBING_LANGAUGE_RIGHT', 'TITLE_LANGAUGE_RIGHT&DUBBING_LANGAUGE_RIGHT') Where Is_Available='N'
			
			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_MISMATCHPLATFORM_MISMATCH', 'Title not acquired') Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'COUNTRY_MISMATCHTITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Region not acquired')Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'SUBTITLING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Subtitling Language not acquired')Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'DUBBING_LANGAUGE_RIGHTRIGHT_PERIOD', 'Dubbing Language not acquired')Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = Replace(Error_Description, 
			'TITLE_LANGAUGE_RIGHTRIGHT_PERIOD', 'Title Language not acquired')Where Is_Available='N'

			Update #TempCombination_Session Set Error_Description = 'Rights period mismatch' Where Is_Available='N' And Error_Description = ''
			END --Update #TempCombination_Session


			--Select * From #TempCombination_Session nsub --Where Is_Available='N'

			Insert InTo @Dup_Records_Language(Agreement_No, Deal_Rights_Code, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, Territory_Type,
												Right_Start_Date, Right_End_Date, Right_Type, Is_Sub_License, ErrorMSG, Is_Title_Language_Right, Subtitling_Language, Dubbing_Language
			)
			Select '', 0, Title_Code, Episode_From, Episode_To, Platform_Code, Country_Code, '', 
					--Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, 'Rights Period Mismatch', Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
					Right_Start_Date, Right_End_Date, Right_Type, @Is_Sub_License, Error_Description, Is_Title_Language_Right, Subtitling_Language_Code, Dubbing_Language_Code
			From #TempCombination_Session nsub Where Is_Available='N'

			

			Declare @Deal_Type_Code Int = 0, @Deal_Type Varchar(20) = ''
			Select @Deal_Type_Code = Deal_Type_Code From Syn_Deal Where Syn_Deal_Code = @Deal_Code
			Select @Deal_Type = [dbo].[UFN_GetDealTypeCondition](@Deal_Type_Code)
			--select * from @Dup_Records_Language
			If Exists(Select Top 1 * From @Dup_Records_Language)
			Begin
				Insert InTo #Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Right_Start_Date, Right_End_Date, 
															Right_Type, 
															Is_Sub_Licence, 
															Is_Title_Language_Right, 
															Country_Code, 
															Subtitling_Language_Code, 
															Dubbing_Language_Code, 
															Agreement_No, ErrorMsg, Episode_From, Episode_To, Inserted_On, IsPushback)
				Select 
					@Syn_Deal_Rights_Code, Title_Code, MainOutput.Platform_Code Platform_Code, Right_Start_Date as Right_Start_Date, Right_End_Date as Right_End_Date,
					CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
					CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
					Is_Title_Language_Right AS Is_Title_Language_Right,
					MainOutput.Country_Code,
					--CASE WHEN IsNull(Subtitling_Language_Code,'')='' THEN 'NA' ELSE Subtitling_Language_Code END 
					Subtitling_Language_Code AS Subtitling_Language,
					--CASE WHEN IsNull(Dubbing_Language_Code,'')='' THEN 'NA' ELSE Dubbing_Language_Code END 
					Dubbing_Language_Code AS Dubbing_Language,
					Agreement_No, IsNull(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, Getdate(), 'N'
				From(
					Select *,
						(
						Select @CountryCode
						Where @CountryCode In(
							Select Distinct Country_Code From @Dup_Records_Language adrn
							Where a.Title_Code = adrn.Title_Code 
								And a.Right_Start_Date = adrn.Right_Start_Date
								And IsNull(a.Right_End_Date,'') = IsNull(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From 
								And a.Episode_To = adrn.Episode_To 
								And IsNull(a.Is_Sub_License,'') = IsNull(adrn.Is_Sub_License,'') 
								And IsNull(a.Is_Title_Language_Right,'') = IsNull(adrn.Is_Title_Language_Right,'')
								And a.ErrorMSG = adrn.ErrorMSG
						)) --And C.Country_Code in (select distinct Country_Code from #Deal_Rights_Territory)
					 as Country_Code,
					STUFF
					(
						(
						Select ',' + CAST(P.Platform_Code as Varchar) 
						From Platform p Where p.Platform_Code In
						(
							Select Distinct Platform_Code From @Dup_Records_Language adrn
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
					) 
					--'0' 
					as Platform_Code,
					STUFF
					(
						(
						Select ',' +
						+  CAST(l.Language_Code as Varchar)  From Language l 
						Where l.Language_Code In(
							Select Distinct 
							Subtitling_Language From @Dup_Records_Language adrn
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
					) as Subtitling_Language_Code,
					STUFF
					(
						(
						Select ',' + CAST(l.Language_Code AS VARCHAR) From Language l 
						Where l.Language_Code In(
							Select Distinct Dubbing_Language From @Dup_Records_Language adrn
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
					) as Dubbing_Language_Code,
					STUFF
					(
						(
						Select ',' + t.Agreement_No From (
							Select Distinct Agreement_No From @Dup_Records_Language adrn
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
							dbo.UFN_GetTitleNameInFormat(@Deal_Type, Title_Name, Episode_From, Episode_To) AS Title_Name,
							ADR.Right_Start_Date, ADR.Right_End_Date,
							Is_Sub_License, Is_Title_Language_Right, ADR.ErrorMSG, Right_Type, Episode_From, Episode_To
						from (
							Select Distinct Title_Code, Episode_From, Episode_To, Right_Start_Date, Right_End_Date, Is_Sub_License,
								Is_Title_Language_Right, ErrorMSG, Right_Type
							From @Dup_Records_Language
						) ADR
						INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
					) as a
				) as MainOutput
				Cross Apply
				(
					Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
				) as abcd

				Set @Is_Error = 'Y'
			End

			If Exists(Select Top 1 * From @NE_Records)
			Begin
				Insert InTo #Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Right_Start_Date, Right_End_Date, 
															Right_Type, 
															Is_Sub_Licence, 
															Is_Title_Language_Right, 
															Country_Code, 
															Subtitling_Language_Code, 
															Dubbing_Language_Code, 
															Agreement_No, ErrorMsg, Episode_From, Episode_To, Inserted_On, IsPushback)
				Select 
				
					@Syn_Deal_Rights_Code, Title_Code, MainOutput.Platform_Code Platform_Code, Right_Start_Date as Right_Start_Date, Right_End_Date as Right_End_Date,
					CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
					CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
					Is_Title_Language_Right AS Is_Title_Language_Right,
					MainOutput.Country_Code,
					--CASE WHEN IsNull(Subtitling_Language_Code,'')='' THEN 'NA' ELSE Subtitling_Language_Code END 
					Subtitling_Language_Code AS Subtitling_Language,
					--CASE WHEN IsNull(Dubbing_Language_Code,'')='' THEN 'NA' ELSE Dubbing_Language_Code END 
					Dubbing_Language_Code AS Dubbing_Language,
					Agreement_No, IsNull(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, Getdate(), 'N'
				From(
					Select *,
						(
						Select @CountryCode
						) --And C.Country_Code in (select distinct Country_Code from #Deal_Rights_Territory)
					 as Country_Code,
					REVERSE(
						STUFF(REVERSE(STUFF((
						Select DISTINCT CAST(P.Platform_Code as Varchar) +',' 
						From @NE_Records p WHERE ISNULL(P.Platform_Code,0)!=0
						FOR XML PATH(''), root('Platform_Code'), type
							).value('/Platform_Code[1]','VARCHAR(max)'

						),2,0, '')), 1, 1, ''))
					--'0' 
					as Platform_Code,
					REVERSE(
						STUFF(REVERSE(STUFF((
						Select DISTINCT
						+  CAST(l.Subtitling_Language as Varchar)+','   From @NE_Records l 
						WHERE ISNULL(l.Subtitling_Language,0)!=0
						FOR XML PATH(''), root('Subtitling_Language_Code'), type
							).value('/Subtitling_Language_Code[1]','VARCHAR(max)'

						),2,0, '')), 1, 1, '')) as Subtitling_Language_Code,
					REVERSE(
						STUFF(REVERSE(STUFF((
						Select DISTINCT CAST(l.Dubbing_Language AS VARCHAR)+','  From @NE_Records l		
						WHERE ISNULL(l.Dubbing_Language,0)!=0				
						FOR XML PATH(''), root('Dubbing_Language_Code'), type
							).value('/Dubbing_Language_Code[1]','VARCHAR(max)'

						),2,0, '')), 1, 1, '')) as Dubbing_Language_Code,
					0 AS Agreement_No
					From (
						Select T.Title_Code,
							T.Title_Name AS Title_Name,
							ADR.Right_Start_Date, ADR.Right_End_Date,
							Is_Sub_License, Is_Title_Language_Right, ADR.ErrorMSG, Right_Type, Episode_From, Episode_To
						from (
							Select Distinct Title_Code, Episode_From, Episode_To, Right_Start_Date, Right_End_Date, Is_Sub_License,
								Is_Title_Language_Right, ErrorMSG, Right_Type
							From @NE_Records
						) ADR
						INNER JOIN Title T ON T.Title_Code=ADR.Title_Code
					) as a
				) as MainOutput
				
				Set @Is_Error = 'Y'
			End
			
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

				Select SDR.Syn_Deal_Rights_Code, SDR.Actual_Right_Start_Date, SDR.Actual_Right_End_Date, SDR.Right_Type, SDR.Is_Title_Language_Right, 
					   SDR.Syn_Deal_Code,(Select Count(*) From Syn_Deal_Rights_Subtitling a Where a.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) 
					   Sub_Cnt, (Select Count(*) From Syn_Deal_Rights_Dubbing a Where a.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code) Dub_Cnt, 
					   Is_Sub_License, Is_Exclusive, Is_Pushback
					   InTo #Syn_Deal_Rights
				From Syn_Deal_Rights SDR
				Where 
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
					( @CallFrom = 'SP' And  SDR.Syn_Deal_Code = @Deal_Code  And  @IS_PUSH_BACK_SAME_DEAL = 'Y')
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
				--Select '123'
					Insert InTo #Syn_Deal_Rights_Error_Details(Syn_Deal_Rights_Code, Title_Code, Platform_Code, Right_Start_Date, Right_End_Date
															, Right_Type, 
															Is_Sub_Licence,
															Is_Title_Language_Right, 
															Country_Code, 
															Subtitling_Language_Code, 
															Dubbing_Language_Code,
															Agreement_No, ErrorMsg, Episode_From, Episode_To, Inserted_On, 
															IsPushback
															)
					Select @Syn_Deal_Rights_Code, Title_Code, MainOutput.Platform_Code, Actual_Right_Start_Date, Actual_Right_End_Date
						,CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
						CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
						Is_Title_Language_Right AS Is_Title_Language_Right,
						Country_Code,
						----CASE WHEN ISNULL(Subtitling_Language_Code,'')='' THEN 'NA' ELSE Subtitling_Language_Code END 
						Subtitling_Language_Code AS Subtitling_Language,
						----CASE WHEN ISNULL(Dubbing_Language_Code,'')='' THEN 'NA' ELSE Dubbing_Language_Code END 
						Dubbing_Language_Code AS Dubbing_Language,
						Agreement_No, ISNULL(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To, GetDate(), 
						'Rights' As Is_Pushback
					From(
						Select *,
							(
							Select @CountryCode 
							Where @CountryCode In(
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
							)) 
							as Country_Code,
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
							Select ', ' + CAST(l.Language_Code as Varchar) From Language l 
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
						) as Subtitling_Language_Code,
						STUFF
						(
							(
							Select ', ' + Cast(l.Language_Code as Varchar) From Language l 
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
						) as Dubbing_Language_Code,
						STUFF
						(
							(
							Select ', ' + t.Agreement_No From Syn_Deal t
							Where t.Syn_Deal_Code In (
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
								dbo.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name,
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
						Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
					) as abcd
				End

				Drop Table #Syn_Rights_New
				Drop Table #Syn_Deal_Rights
				Drop Table #Syn_Deal_Rights_Title
				Drop Table #Syn_Deal_Rights_Platform
				Drop Table #Syn_Deal_Rights_Territory
				Drop Table #Syn_Deal_Rights_Subtitling
				Drop Table #Syn_Deal_Rights_Dubbing
				Drop Table #Syn_Rights_Code_Lang

			End  ------------------------ End
			IF EXISTS(SELECT * FROM #Syn_Deal_Rights_Error_Details)
			BEGIN
				SET @ResponseXML=
				'<?xml version="1.0" ?>'+
				ISNULL((select DISTINCT 
					@RequestID AS RequestID
					,sd.Platform_Code AS PlatformCodes
					,sd.Subtitling_Language_Code AS SubtitlingLanguageCode
					,sd.Dubbing_Language_Code AS DubbingLanguageCode
					,sd.Episode_From AS EpisodeFrom
					,sd.Episode_To AS EpisodeTo
					,sd.Is_Title_Language_Right AS TitleLanguage
					,'N' AS IsValid
					,tet.Error_Code AS ErrorCode
				from #Syn_Deal_Rights_Error_Details sd
				INNER JOIN #TempErrorTable tet ON tet.Err_Desc=sd.ErrorMsg
				FOR XML PATH('Rights'), ROOT('RightsData')),'')
			END
			ELSE
			BEGIN
				IF (EXISTS(select * from #Temp_Restriction_Remark) OR EXISTS(select * from #Temp_Acq_WBS))
				BEGIN
				Print 'Valid'
					SELECT @ResponseXML=
					'<?xml version="1.0" ?><RightsData>'+
					ISNULL((select DISTINCT 
					@RequestID AS RequestID
					,@EpisodeFrom AS EpisodeFrom
					,@EpisodeTo AS EpisodeTo
					,@PlatformCode AS PlatformCodes
					,@TitleLanguage AS TitleLanguage
					,'Y' AS IsValid
					FOR XML PATH('Rights')),'')
					+
					ISNULL((
						Select PlatformCodes,Restriction_Remark AS Remarks from #Temp_Restriction_Remark
						FOR XML PATH('Restrictions'),ROOT('RestrictionRemarks')
						--, ROOT('RightData')
					),'')
					+
					ISNULL((
					    select Title_Name AS Title, WBS_Code AS WBSCode,CONVERT(VARCHAR,Actual_Right_Start_Date,106) AS StartDate,
						CONVERT(VARCHAR,Actual_Right_End_Date,106) AS EndDate from #Temp_Acq_WBS
						FOR XML PATH('WBS'),ROOT('TitleWBS')
					),'')
					+'</RightsData>'
				END
			END
	End Try
	Begin Catch

	SET @Is_Error   = 'Y'         
		SET @Error_Desc = 'Error In USP_Validate_SDM_Title : Error_Desc : ' +  ERROR_MESSAGE() 
							+ ' ;ErrorNumber : ' + CAST(ERROR_NUMBER() AS VARCHAR)        
		SET @Error_Desc =  @Error_Desc + ';ErrorLine : '+ CAST(ERROR_LINE() AS VARCHAR) + ' ;'         
		SET @Error_Desc =  @Error_Desc + ' ;USP Input Parameters : ' +';@Module_Name : ' 
		SET @Record_Status = 'E'
        SET @ResponseXML = ''

	SEt @ResponseXML='<ERROR>'+ERROR_MESSAGE()+'</ERROR>'

	End Catch
	
	INSERT INTO Integration_Log(Intergration_Config_Code,Request_XML,Response_XML,Request_Type,Request_DateTime,Response_DateTime,[Error_Message],[Record_Status])  
	SELECT NULL,@ValidateXML,@ResponseXML,'V',@Request_Time,GETDATE(),@Error_Desc,@Record_Status
	select @ResponseXML AS Response_XML
	END

	IF OBJECT_ID('tempdb..#Acq_Avail_Title_Eps') IS NOT NULL DROP TABLE #Acq_Avail_Title_Eps
	IF OBJECT_ID('tempdb..#Acq_Country') IS NOT NULL DROP TABLE #Acq_Country
	IF OBJECT_ID('tempdb..#Acq_Deal_Rights') IS NOT NULL DROP TABLE #Acq_Deal_Rights
	IF OBJECT_ID('tempdb..#Acq_Dub') IS NOT NULL DROP TABLE #Acq_Dub
	IF OBJECT_ID('tempdb..#Acq_Sub') IS NOT NULL DROP TABLE #Acq_Sub
	IF OBJECT_ID('tempdb..#Acq_Titles') IS NOT NULL DROP TABLE #Acq_Titles
	IF OBJECT_ID('tempdb..#Acq_Titles_With_Rights') IS NOT NULL DROP TABLE #Acq_Titles_With_Rights
	IF OBJECT_ID('tempdb..#ApprovedAcqData') IS NOT NULL DROP TABLE #ApprovedAcqData
	IF OBJECT_ID('tempdb..#Deal_Right_Title_WithEpsNo') IS NOT NULL DROP TABLE #Deal_Right_Title_WithEpsNo
	IF OBJECT_ID('tempdb..#Deal_Rights_Territory') IS NOT NULL DROP TABLE #Deal_Rights_Territory
	IF OBJECT_ID('tempdb..#Min_Right_Start_Date') IS NOT NULL DROP TABLE #Min_Right_Start_Date
	IF OBJECT_ID('tempdb..#NA_Country') IS NOT NULL DROP TABLE #NA_Country
	IF OBJECT_ID('tempdb..#NA_Dubbing') IS NOT NULL DROP TABLE #NA_Dubbing
	IF OBJECT_ID('tempdb..#NA_Platforms') IS NOT NULL DROP TABLE #NA_Platforms
	IF OBJECT_ID('tempdb..#NA_Subtitling') IS NOT NULL DROP TABLE #NA_Subtitling
	IF OBJECT_ID('tempdb..#NE_Country') IS NOT NULL DROP TABLE #NE_Country
	IF OBJECT_ID('tempdb..#NE_Dubbing') IS NOT NULL DROP TABLE #NE_Dubbing
	IF OBJECT_ID('tempdb..#NE_Platforms') IS NOT NULL DROP TABLE #NE_Platforms
	IF OBJECT_ID('tempdb..#NE_Subtitling') IS NOT NULL DROP TABLE #NE_Subtitling
	IF OBJECT_ID('tempdb..#NE_Title') IS NOT NULL DROP TABLE #NE_Title
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights') IS NOT NULL DROP TABLE #Syn_Deal_Rights
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Dubbing') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Dubbing
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Error_Details') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Error_Details
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Platform') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Platform
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Subtitling') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Subtitling
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Territory') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Territory
	IF OBJECT_ID('tempdb..#Syn_Deal_Rights_Title') IS NOT NULL DROP TABLE #Syn_Deal_Rights_Title
	IF OBJECT_ID('tempdb..#Syn_Rights_Code_Lang') IS NOT NULL DROP TABLE #Syn_Rights_Code_Lang
	IF OBJECT_ID('tempdb..#Syn_RIGHTS_NEW') IS NOT NULL DROP TABLE #Syn_RIGHTS_NEW
	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#Temp_Acq_Country') IS NOT NULL DROP TABLE #Temp_Acq_Country
	IF OBJECT_ID('tempdb..#Temp_Acq_Dubbing') IS NOT NULL DROP TABLE #Temp_Acq_Dubbing
	IF OBJECT_ID('tempdb..#Temp_Acq_Platform') IS NOT NULL DROP TABLE #Temp_Acq_Platform
	IF OBJECT_ID('tempdb..#Temp_Acq_Subtitling') IS NOT NULL DROP TABLE #Temp_Acq_Subtitling
	IF OBJECT_ID('tempdb..#Temp_Acq_WBS') IS NOT NULL DROP TABLE #Temp_Acq_WBS
	IF OBJECT_ID('tempdb..#Temp_Country') IS NOT NULL DROP TABLE #Temp_Country
	IF OBJECT_ID('tempdb..#Temp_Dubbing') IS NOT NULL DROP TABLE #Temp_Dubbing
	IF OBJECT_ID('tempdb..#Temp_Episode_No') IS NOT NULL DROP TABLE #Temp_Episode_No
	IF OBJECT_ID('tempdb..#Temp_Exceptions') IS NOT NULL DROP TABLE #Temp_Exceptions
	IF OBJECT_ID('tempdb..#Temp_NA_Title') IS NOT NULL DROP TABLE #Temp_NA_Title
	IF OBJECT_ID('tempdb..#Temp_Platforms') IS NOT NULL DROP TABLE #Temp_Platforms
	IF OBJECT_ID('tempdb..#Temp_Restriction_Remark') IS NOT NULL DROP TABLE #Temp_Restriction_Remark
	IF OBJECT_ID('tempdb..#Temp_Subtitling') IS NOT NULL DROP TABLE #Temp_Subtitling
	IF OBJECT_ID('tempdb..#Temp_Syn_Dup_Records') IS NOT NULL DROP TABLE #Temp_Syn_Dup_Records
	IF OBJECT_ID('tempdb..#Temp_Tit_Right') IS NOT NULL DROP TABLE #Temp_Tit_Right
	IF OBJECT_ID('tempdb..#TempCombination') IS NOT NULL DROP TABLE #TempCombination
	IF OBJECT_ID('tempdb..#TempCombination_Session') IS NOT NULL DROP TABLE #TempCombination_Session
	IF OBJECT_ID('tempdb..#TempErrorTable') IS NOT NULL DROP TABLE #TempErrorTable
	IF OBJECT_ID('tempdb..#Title_Not_Acquire') IS NOT NULL DROP TABLE #Title_Not_Acquire
END