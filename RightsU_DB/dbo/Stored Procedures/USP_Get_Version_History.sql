CREATE PROCEDURE [dbo].[USP_Get_Version_History]
	@Acq_Deal_Code int
	,@Business_Unit_Code int
	,@TabName Varchar(100)
AS
---- =============================================
---- Author:		Rajesh Godse
---- Create date: 9-Sept-2015
---- Description:	Get version difference based on deal code
---- =============================================
--/*
--SELECT * FROM Acq_Deal WHERE Agreement_No like 'A-2016-00075'
--EXEC [dbo].[USP_Get_Version_History]  13461,1,'DEALPUSHBACK'
--select * from AT_acq_deal where agreement_no = 'A-2016-00099'
--*/
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Version_History]', 'Step 1', 0, 'Started Procedure', 0, '' 
			--DECLARE
			--@Acq_Deal_Code int = 21617
			--,@Business_Unit_Code int = 5
			--,@TabName Varchar(100) = 'GENERAL'
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

		IF OBJECT_ID('tempdb..#TempAncillaryHistory') IS NOT NULL DROP TABLE #TempAncillaryHistory
		IF OBJECT_ID('tempdb..#TempAttachmentHistory') IS NOT NULL DROP TABLE #TempAttachmentHistory
		IF OBJECT_ID('tempdb..#TempBudgetHistory') IS NOT NULL DROP TABLE #TempBudgetHistory
		IF OBJECT_ID('tempdb..#TempDealHistory') IS NOT NULL DROP TABLE #TempDealHistory
		IF OBJECT_ID('tempdb..#TempMaterialHistory') IS NOT NULL DROP TABLE #TempMaterialHistory
		IF OBJECT_ID('tempdb..#TempMovieHistory') IS NOT NULL DROP TABLE #TempMovieHistory
		IF OBJECT_ID('tempdb..#TempPlatformHistory') IS NOT NULL DROP TABLE #TempPlatformHistory
		IF OBJECT_ID('tempdb..#TempPushbackHistory') IS NOT NULL DROP TABLE #TempPushbackHistory
		IF OBJECT_ID('tempdb..#TempRightsHistory') IS NOT NULL DROP TABLE #TempRightsHistory
		IF OBJECT_ID('tempdb..#TempSportsAncFTCHistory') IS NOT NULL DROP TABLE #TempSportsAncFTCHistory
		IF OBJECT_ID('tempdb..#TempSportsAncMoneHistory') IS NOT NULL DROP TABLE #TempSportsAncMoneHistory
		IF OBJECT_ID('tempdb..#TempSportsAncMrktHistory') IS NOT NULL DROP TABLE #TempSportsAncMrktHistory
		IF OBJECT_ID('tempdb..#TempSportsAncProHistory') IS NOT NULL DROP TABLE #TempSportsAncProHistory
		IF OBJECT_ID('tempdb..#TempSportsAncSalesHistory') IS NOT NULL DROP TABLE #TempSportsAncSalesHistory
		IF OBJECT_ID('tempdb..#TempSportsHistory') IS NOT NULL DROP TABLE #TempSportsHistory

		DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''
		Select @Selected_Deal_Type_Code = Deal_Type_Code From Acq_Deal (NOLOCK) Where Acq_Deal_Code = @Acq_Deal_Code
		SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	-------------------------------------------------------------GENERAL TAB------------------------------------------------------------------------------------
		IF(@TabName = 'GENERAL')
		BEGIN
		
			--drop table #TempDealHistory
			CREATE TABLE #TempDealHistory
			(
				AT_Acq_Deal_Code int,
				Acq_Deal_Code int,
				Agreement_No NVARCHAR(50),
				[Version] VARCHAR(50),
				[VersionOld] VARCHAR(50),
				Deal_Desc NVARCHAR(500),
				Deal_Type_Name NVARCHAR(100),
				[Entity_Name] NVARCHAR(100),
				Exchange_Rate NVARCHAR(50),
				Category_Name NVARCHAR(100),
				Vendor_Name NVARCHAR(1000),
				Contact_Name NVARCHAR(100),
				Currency_Name NVARCHAR(100),
				Role_Name NVARCHAR(100),
				Channel_Cluster_Name NVARCHAR(200),
				[Index] int,
				ChangedColumnIndex varchar(MAX),
				[Inserted_By] VARCHAR(50),
				Deal_Segment NVARCHAR(MAX),
				Revenue_Vertical NVARCHAR(MAX)
			)

			INSERT INTO #TempDealHistory(AT_Acq_Deal_Code,Acq_Deal_Code,Agreement_No,Version,VersionOld,Deal_Desc,Deal_Type_Name,[Entity_Name],Exchange_Rate,Category_Name,Vendor_Name, Contact_Name,Currency_Name, Role_Name, Channel_Cluster_Name,[Index],ChangedColumnIndex,[Inserted_By],Deal_Segment, Revenue_Vertical)
			SELECT AAD.AT_Acq_Deal_Code,AAD.Acq_Deal_Code,AAD.Agreement_No,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4),AAD.Deal_Desc,DT.Deal_Type_Name,E.[Entity_Name],AAD.Exchange_Rate,C.Category_Name,V.Vendor_Name, VC.Contact_Name,CR.Currency_Name, R.Role_Name, CC.Channel_Cluster_Name ,cast(AAD.Version as decimal),'',USR.Login_Name, DS.Deal_Segment_Name, RV.Revenue_Vertical_Name
			FROM AT_Acq_Deal AAD (NOLOCK)
			INNER JOIN Deal_Type DT (NOLOCK) ON AAD.Deal_Type_Code = DT.Deal_Type_Code
			INNER JOIN Entity E (NOLOCK) ON AAD.Entity_Code = E.Entity_Code
			INNER JOIN Category C (NOLOCK) ON AAD.Category_Code = C.Category_Code
			INNER JOIN Vendor V (NOLOCK) ON AAD.Vendor_Code = V.Vendor_Code
			LEFT OUTER JOIN Vendor_Contacts VC (NOLOCK) ON AAD.Vendor_Contacts_Code = VC.Vendor_Contacts_Code
			INNER JOIN Currency CR (NOLOCK) ON AAD.Currency_Code = CR.Currency_Code
			INNER JOIN Role R (NOLOCK) ON R.Role_Code = AAD.Role_Code
			INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = AAD.Acq_Deal_Code
			LEFT JOIN Deal_Segment DS (NOLOCK) ON AAD.Deal_Segment_Code = DS.Deal_Segment_Code
			LEFT JOIN Revenue_Vertical RV (NOLOCK) ON AAD.Revenue_Vertical_Code = RV.Revenue_Vertical_Code
			LEFT OUTER JOIN Channel_Cluster CC (NOLOCK) ON AAD.Channel_Cluster_Code = CC.Channel_Cluster_Code
			INNER JOIN Users USR  (NOLOCK) ON USR.Users_Code = CASE WHEN AAD.version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
			END
			WHERE AAD.Acq_Deal_Code = @Acq_Deal_Code 

			INSERT INTO #TempDealHistory(AT_Acq_Deal_Code,Acq_Deal_Code,Agreement_No,Version, VersionOld,Deal_Desc,Deal_Type_Name,[Entity_Name],Exchange_Rate,Category_Name,Vendor_Name, Contact_Name,Currency_Name, Role_Name, Channel_Cluster_Name,[Index],ChangedColumnIndex,[Inserted_By], Deal_Segment, Revenue_Vertical)
			SELECT 0,Acq_Deal_Code,Agreement_No,Version,RIGHT('000' + cast( (cast(Version as decimal) +1) as varchar(50)),4),Deal_Desc,DT.Deal_Type_Name,E.[Entity_Name],Exchange_Rate,C.Category_Name,V.Vendor_Name, VC.Contact_Name,CR.Currency_Name, R.Role_Name, CC.Channel_Cluster_Name,cast(AAD.Version as decimal),'',USR.Login_Name, DS.Deal_Segment_Name, RV.Revenue_Vertical_Name
			FROM Acq_Deal AAD (NOLOCK)
			INNER JOIN Deal_Type DT (NOLOCK) ON AAD.Deal_Type_Code = DT.Deal_Type_Code
			INNER JOIN Entity E (NOLOCK) ON AAD.Entity_Code = E.Entity_Code
			INNER JOIN Category C (NOLOCK) ON AAD.Category_Code = C.Category_Code
			INNER JOIN Vendor V (NOLOCK) ON AAD.Vendor_Code = V.Vendor_Code
			LEFT OUTER JOIN Vendor_Contacts VC (NOLOCK) ON AAD.Vendor_Contacts_Code = VC.Vendor_Contacts_Code
			INNER JOIN Currency CR (NOLOCK) ON AAD.Currency_Code = CR.Currency_Code
			INNER JOIN Role R (NOLOCK) ON R.Role_Code = AAD.Role_Code
			LEFT JOIN Deal_Segment DS (NOLOCK) ON AAD.Deal_Segment_Code = DS.Deal_Segment_Code
			LEFT JOIN Revenue_Vertical RV (NOLOCK) ON AAD.Revenue_Vertical_Code = RV.Revenue_Vertical_Code
			LEFT OUTER JOIN Channel_Cluster CC (NOLOCK) ON AAD.Channel_Cluster_Code = CC.Channel_Cluster_Code
			INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
			END
			WHERE  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') and Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempDealHistory)

			DECLARE @ISChange varchar(2)
			DECLARE @Version varchar(100) 
			DECLARE @temp varchar(100) 
	
			DECLARE cur_DealHistory1 CURSOR for 
			select distinct [Version],[Index] from #TempDealHistory
			OPEN cur_DealHistory1

			FETCH next from cur_DealHistory1  into @Version,@temp
			WHILE (@@FETCH_STATUS <> -1)
																																																																																																													BEGIN
			if(@temp != 1)
			BEGIN
			
				select @ISChange =  case when ISNULL(a.Deal_Desc,'')  != isnull(B.Deal_Desc,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Deal_Type_Name,'')  != isnull(B.Deal_Type_Name,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.[Entity_Name],'')  != isnull(B.[Entity_Name],'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Exchange_Rate,'')  != isnull(B.[Exchange_Rate],'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Category_Name,'')  != isnull(B.Category_Name,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Vendor_Name,'')  != isnull(B.Vendor_Name,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Contact_Name,'')  != isnull(B.Contact_Name,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '12,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Currency_Name,'')  != isnull(B.Currency_Name,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '13,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Role_Name,'')  != isnull(B.Role_Name,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '14,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Channel_Cluster_Name,'')  != isnull(B.Channel_Cluster_Name,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '15,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Deal_Segment,'')  != isnull(B.Deal_Segment,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '16,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

				select @ISChange =  case when ISNULL(a.Revenue_Vertical,'')  != isnull(B.Revenue_Vertical,'') then 'Y'  end
				from #TempDealHistory a 
				left join #TempDealHistory b on a.Version = b.VersionOld
				where a.[Index] = @temp and  a.Version = @Version
		
				if(@ISChange = 'Y')
				BEGIN
				  update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '17,' where [Index] = @temp and version = @version
				  set @ISChange = '' 
				END

			END
			FETCH next from cur_DealHistory1  into @Version,@temp
			END
			Deallocate cur_DealHistory1
			Select * from #TempDealHistory
			END
			--Code Start for Deal Movie History

	-------------------------------------------------------------END OF GENERAL TAB------------------------------------------------------------------------------------


	-------------------------------------------------------------MOVIE TAB------------------------------------------------------------------------------------

	IF(@TabName = 'DEALMOVIE')
	BEGIN

		CREATE TABLE #TempMovieHistory
		(
			AT_Acq_Deal_Movie_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Title_Name NVARCHAR(250),
			No_Of_Episodes int,
			Notes NVARCHAR(500),
			Title_Type VARCHAR(50),
			Episode_Starts_From int,
			Episode_End_To int,
			Closing_Remarks NVARCHAR(MAX),
			Movie_Closed_Date date,
			[Status] VARCHAR(10),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)
	
		INSERT INTO #TempMovieHistory
		(
			AT_Acq_Deal_Movie_Code ,
			[Version] ,
			[VersionOld] ,
			Title_Name ,
			No_Of_Episodes ,
			Notes ,
			Title_Type ,
			Episode_Starts_From ,
			Episode_End_To ,
			Closing_Remarks ,
			Movie_Closed_Date ,
			[Status] ,
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADM.AT_Acq_Deal_Movie_Code, AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld, t.Title_Name, ISNULL(AADM.No_Of_Episodes,'') No_Of_Episodes,ISNULL(AADM.Notes,'') Notes,
		CASE ISNULL(AADM.Title_Type,'') 
		WHEN  'P' THEN 'Premier' 
		WHEN 'L' THEN 'Library' 
		ELSE 'N/A'
		END
		Title_Type,
		ISNULL(AADM.Episode_Starts_From,'') Episode_Starts_From,ISNULL(AADM.Episode_End_To,'') Episode_End_To,ISNULL(AADM.Closing_Remarks,'') Closing_Remarks,ISNULL(CONVERT(VARCHAR(20), AADM.Movie_Closed_Date,106),'') Movie_Closed_Date,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		from AT_Acq_Deal AAD (NOLOCK)
		INNER JOIN AT_Acq_Deal_Movie AADM (NOLOCK) ON AAD.AT_Acq_Deal_Code = AADM.AT_Acq_Deal_Code
		INNER JOIN Title t (NOLOCK) ON t.Title_Code = AADM.Title_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		Where Acq_Deal_Code = @Acq_Deal_Code
		Order by T.Title_Name DESC,AAD.version

		INSERT INTO #TempMovieHistory
		(
			AT_Acq_Deal_Movie_Code ,
			[Version] ,
			[VersionOld] ,
			Title_Name ,
			No_Of_Episodes ,
			Notes ,
			Title_Type ,
			Episode_Starts_From ,
			Episode_End_To ,
			Closing_Remarks ,
			Movie_Closed_Date ,
			[Status] ,
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADM.Acq_Deal_Movie_Code, AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld, 
		t.Title_Name, ISNULL(AADM.No_Of_Episodes,'') No_Of_Episodes,ISNULL(AADM.Notes,'') Notes,CASE ISNULL(AADM.Title_Type,'') 
		WHEN  'P' THEN 'Premier' 
		WHEN 'L' THEN 'Library' 
		ELSE 'N/A'
		END Title_Type,ISNULL(AADM.Episode_Starts_From,'') Episode_Starts_From,ISNULL(AADM.Episode_End_To,'') Episode_End_To,ISNULL(AADM.Closing_Remarks,'') Closing_Remarks,
		ISNULL(CONVERT(VARCHAR(20), AADM.Movie_Closed_Date,106),'') Movie_Closed_Date,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		from Acq_Deal AAD (NOLOCK)
		INNER JOIN Acq_Deal_Movie AADM (NOLOCK) ON AAD.Acq_Deal_Code = AADM.Acq_Deal_Code
		INNER JOIN Title t (NOLOCK) ON t.Title_Code = AADM.Title_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		Where  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempMovieHistory)
		Order by T.Title_Name DESC,AAD.version

		DECLARE @AT_Acq_Deal_Movie_Code int 
		DECLARE @Title_Name NVARCHAR(MAX) 
		DECLARE @CurrentVersion varchar(100) 
		DECLARE @ISChange_V1 INT

	
		DECLARE cur_DealMovieHistory CURSOR for 
		select distinct AT_Acq_Deal_Movie_Code,Title_Name,Version,[Index]  from #TempMovieHistory --where AT_Acq_Deal_Movie_Code In (10089, 10101)
		OPEN cur_DealMovieHistory

		FETCH next from cur_DealMovieHistory  into @AT_Acq_Deal_Movie_Code,@Title_Name,@CurrentVersion, @temp
		WHILE (@@FETCH_STATUS <> -1)
		BEGIN
			SET @ISChange = ''
			SET @ISChange_V1 = 0
			if(@CurrentVersion != (SELECT '000' + cast( MIN(cast(Version as decimal)) as varchar(50)) FROM #TempMovieHistory WHERE Title_Name = @Title_Name))
			BEGIN
			
				select @ISChange =  case when ISNULL(a.Closing_Remarks,'')  != isnull(b.Closing_Remarks,'') then 'Y'  end
				from #TempMovieHistory a 
				left join #TempMovieHistory b on a.Version = b.VersionOld
				where a.Version = @CurrentVersion and a.AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and b.Title_Name = @Title_Name

				if(@ISChange = 'Y')
				BEGIN
				  update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @CurrentVersion
				  and AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and Title_Name = @Title_Name
				  set @ISChange = '' 
				  SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Episode_Starts_From,'')  != isnull(b.Episode_Starts_From,'') then 'Y'  end
				from #TempMovieHistory a 
				left join #TempMovieHistory b on a.Version = b.VersionOld
				where a.Version = @CurrentVersion and a.AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and b.Title_Name = @Title_Name

				if(@ISChange = 'Y')
				BEGIN
				  update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @CurrentVersion
				  and AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and Title_Name = @Title_Name
				  set @ISChange = '' 
				  SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Episode_End_To,'')  != isnull(b.Episode_End_To,'') then 'Y'  end
				from #TempMovieHistory a 
				left join #TempMovieHistory b on a.Version = b.VersionOld
				where a.Version = @CurrentVersion and a.AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and b.Title_Name = @Title_Name

				if(@ISChange = 'Y')
				BEGIN
				  update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @CurrentVersion
				  and AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and Title_Name = @Title_Name
				  set @ISChange = '' 
				  SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Notes,'')  != isnull(b.Notes,'') then 'Y'  end
				from #TempMovieHistory a 
				left join #TempMovieHistory b on a.Version = b.VersionOld
				where a.Version = @CurrentVersion and a.AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and b.Title_Name = @Title_Name

				if(@ISChange = 'Y')
				BEGIN
				  update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @CurrentVersion
				  and AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and Title_Name = @Title_Name
				  set @ISChange = '' 
				  SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Movie_Closed_Date,'')  != isnull(b.Movie_Closed_Date,'') then 'Y'  end
				from #TempMovieHistory a 
				left join #TempMovieHistory b on a.Version = b.VersionOld
				where a.Version = @CurrentVersion and a.AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and b.Title_Name = @Title_Name

				if(@ISChange = 'Y')
				BEGIN
				  update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @CurrentVersion
				  and AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and Title_Name = @Title_Name
				  set @ISChange = '' 
				  SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Title_Type,'')  != isnull(b.Title_Type,'') then 'Y'  end
				from #TempMovieHistory a 
				left join #TempMovieHistory b on a.Version = b.VersionOld
				where a.Version = @CurrentVersion and a.AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and b.Title_Name = @Title_Name

				if(@ISChange = 'Y')
				BEGIN
				  update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @CurrentVersion
				  and AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code and Title_Name = @Title_Name
				  set @ISChange = '' 
				  SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				if(@ISChange_V1 > 0)
				BEGIN
					UPDATE #TempMovieHistory
					SET Status = 'Modified'
					WHERE AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code
				
				END
			END
			ELSE
			BEGIN
				UPDATE #TempMovieHistory
				SET Status = 'Added'
				WHERE AT_Acq_Deal_Movie_Code = @AT_Acq_Deal_Movie_Code
			END

			FETCH next from cur_DealMovieHistory  into @AT_Acq_Deal_Movie_Code,@Title_Name,@CurrentVersion, @temp
		END
		Deallocate cur_DealMovieHistory

		Select * from #TempMovieHistory
		END

	----------------------------------------------------------END OF MOVIE TAB------------------------------------------------------------------------------------

	-------------------------------------------------------- Code Start for Deal Rights History-------------------------------------------------------------------
	IF(@TabName = 'DEALRIGHTS')
	BEGIN

		CREATE TABLE #TempRightsHistory
		(
			AT_Acq_Deal_Rights_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Rights_Code int,
			[Title_Name] NVARCHAR(MAX),
			[Platform_Name] NVARCHAR(MAX),
			[Country_Name] NVARCHAR(MAX),
			[Territory_Name] NVARCHAR(MAX),
			[Subtitling] NVARCHAR(MAX),
			[Dubbing] NVARCHAR(MAX),
			Is_Exclusive CHAR,
			Is_Title_Language_Right CHAR,
			Is_Sub_License CHAR,
			Sub_License_Name NVARCHAR(100),
			Is_Theatrical_Right CHAR,
			Right_Type CHAR,
			Is_Tentative CHAR,
			Term VARCHAR(10),
			Right_Start_Date datetime,
			Right_End_Date datetime,
			Milestone_Type_Name VARCHAR(100),
			Milestone_No_Of_Unit int,
			Milestone_Unit_Type int,
			Is_ROFR CHAR,
			ROFR_Date date,
			Restriction_Remarks NVARCHAR(MAX),
			Effective_Start_Date datetime,
			ROFR_Type VARCHAR(100),
			[Status] NVARCHAR(10),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempRightsHistory(AT_Acq_Deal_Rights_Code,
		[Version],
		[VersionOld],
		Acq_Deal_Rights_Code,
		Is_Exclusive,
		Is_Title_Language_Right,
		Is_Sub_License,
		Sub_License_Name,
		Is_Theatrical_Right,
		Right_Type,
		Is_Tentative,
		Term,
		Right_Start_Date,
		Right_End_Date,
		Milestone_Type_Name,
		Milestone_No_Of_Unit,
		Milestone_Unit_Type,
		Is_ROFR,
		ROFR_Date,
		Restriction_Remarks,
		Effective_Start_Date,
		ROFR_Type ,
		[Status],
		[Index] ,
		ChangedColumnIndex,
		[Inserted_By])
		Select AADR.AT_Acq_Deal_Rights_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADR.Acq_Deal_Rights_Code,0)  Acq_Deal_Rights_Code
		,AADR.Is_Exclusive,AADR.Is_Title_Language_Right,AADR.Is_Sub_License,ISNULL(S.Sub_License_Name ,'') as Sub_License_Name,AADR.Is_Theatrical_Right
		,AADR.Right_Type,AADR.Is_Tentative,AADR.Term,ISNULL(Convert(varchar(20),AADR.Actual_Right_Start_Date,106),'') Right_Start_Date,
		ISNULL(Convert(varchar(20),AADR.Actual_Right_End_Date,106),'') Right_End_Date,ISNULL(MT.Milestone_Type_Name,'') Milestone_Type_Name,ISNULL(AADR.Milestone_No_Of_Unit,'') Milestone_No_Of_Unit,
		ISNULL(AADR.Milestone_Unit_Type,'') Milestone_Unit_Type,AADR.Is_ROFR,ISNULL(Convert(varchar(20),AADR.ROFR_Date,106),'') ROFR_Date,ISNULL(AADR.Restriction_Remarks,'') Restriction_Remarks,ISNULL(Convert(varchar(20),AADR.Effective_Start_Date,106),'') Effective_Start_Date
		,ISNULL(R.ROFR_Type,'') ROFR_Type, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Rights AADR  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADR.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		LEFT JOIN Sub_License S  (NOLOCK) ON AADR.Sub_License_Code = S.Sub_License_Code
		LEFT JOIN Milestone_Type MT (NOLOCK) ON AADR.Milestone_Type_Code = MT.Milestone_Type_Code
		LEFT JOIN ROFR R  (NOLOCK) ON AADR.ROFR_Code = R.ROFR_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AADR.Acq_Deal_Rights_Code ASC, AAD.Version ASC

		INSERT INTO #TempRightsHistory(AT_Acq_Deal_Rights_Code,
		[Version],
		[VersionOld],
		Acq_Deal_Rights_Code,
		Is_Exclusive,
		Is_Title_Language_Right,
		Is_Sub_License,
		Sub_License_Name,
		Is_Theatrical_Right,
		Right_Type,
		Is_Tentative,
		Term,
		Right_Start_Date,
		Right_End_Date,
		Milestone_Type_Name,
		Milestone_No_Of_Unit,
		Milestone_Unit_Type,
		Is_ROFR,
		ROFR_Date,
		Restriction_Remarks,
		Effective_Start_Date,
		ROFR_Type ,
		[Status],
		[Index] ,
		ChangedColumnIndex,
		[Inserted_By])
		Select 0 AT_Acq_Deal_Rights_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADR.Acq_Deal_Rights_Code,0) Acq_Deal_Rights_Code
		,AADR.Is_Exclusive,AADR.Is_Title_Language_Right,AADR.Is_Sub_License,ISNULL (S.Sub_License_Name, '') as Sub_License_Name,AADR.Is_Theatrical_Right
		,AADR.Right_Type,AADR.Is_Tentative,AADR.Term,ISNULL(Convert(varchar(20),AADR.Actual_Right_Start_Date,106),'') Right_Start_Date,
		ISNULL(Convert(varchar(20),AADR.Actual_Right_End_Date,106),'') Right_End_Date,ISNULL(MT.Milestone_Type_Name,'') Milestone_Type_Name,ISNULL(AADR.Milestone_No_Of_Unit,'') Milestone_No_Of_Unit,
		ISNULL(AADR.Milestone_Unit_Type,'') Milestone_Unit_Type,AADR.Is_ROFR,ISNULL(Convert(varchar(20),AADR.ROFR_Date,106),'') ROFR_Date,ISNULL(AADR.Restriction_Remarks,'') Restriction_Remarks,ISNULL(Convert(varchar(20),AADR.Effective_Start_Date,106),'') Effective_Start_Date
		,ISNULL(R.ROFR_Type,'') ROFR_Type, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		from Acq_Deal_Rights AADR  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADR.Acq_Deal_Code = AAD.Acq_Deal_Code
		LEFT JOIN Sub_License S (NOLOCK) ON AADR.Sub_License_Code = S.Sub_License_Code
		LEFT JOIN Milestone_Type MT (NOLOCK) ON AADR.Milestone_Type_Code = MT.Milestone_Type_Code
		LEFT JOIN ROFR R (NOLOCK) ON AADR.ROFR_Code = R.ROFR_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempRightsHistory)
		ORDER BY AADR.Acq_Deal_Rights_Code ASC, AAD.Version ASC


		Declare @AT_Acq_Deal_Rights_Code int,@VersionOld VARCHAR(4),@Acq_Deal_Rights_Code int
		Declare @Codes Varchar(MAX) = '0', @Title_Names NVARCHAR(MAX) = '', @Platform_Name NVARCHAR(4000)
		Declare CUR_Right Cursor For Select AT_Acq_Deal_Rights_Code,Version,VersionOld,Acq_Deal_Rights_Code,[Index] From #TempRightsHistory
				Open CUR_Right
				Fetch Next From CUR_Right InTo @AT_Acq_Deal_Rights_Code,@Version,@VersionOld,@Acq_Deal_Rights_Code,@temp
				While (@@FETCH_STATUS = 0)
				Begin
					IF(@AT_Acq_Deal_Rights_Code > 0)
					BEGIN
						Set @Codes = ''
						Select @Codes = @Codes + Cast(Platform_Code as varchar) + ',' From AT_Acq_Deal_Rights_Platform (NOLOCK) Where AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code
						SET  @Platform_Name = ''
						select @Platform_Name = @Platform_Name + Platform_Hiearachy + ',' from dbo.UFN_Get_Platform_With_Parent (@Codes)
						set @Platform_Name = reverse(stuff(reverse(@Platform_Name), 1, 1, ''))

						Set @Title_Names = ''
						Select @Title_Names = @Title_Names + Title_Name + ', ' From (
							Select Distinct 
							Case @Deal_Type_Condition
							When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
							When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
							Else t.Title_Name End As Title_Name
							From Title t  (NOLOCK)
							Inner Join AT_Acq_Deal_Rights_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
							WHERE adrt.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code
							) as a
							ORDER BY a.Title_Name

							SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						UPDATE #TempRightsHistory
						SET [Platform_Name] = @Platform_Name,[Title_Name] = @Title_Names,
						Country_Name = dbo.UFN_Get_Rights_Country_AT(@AT_Acq_Deal_Rights_Code,'A'),
						Territory_Name = dbo.UFN_Get_Rights_Territory_AT(@AT_Acq_Deal_Rights_Code,'A'), 
						Dubbing = dbo.UFN_Get_Rights_Dubbing_AT(@AT_Acq_Deal_Rights_Code,'A')
						,Subtitling = dbo.UFN_Get_Rights_Subtitling_AT(@AT_Acq_Deal_Rights_Code,'A')
						WHERE AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code
					END
					ELSE
					BEGIN
						Set @Codes = ''
						Select @Codes = @Codes + Cast(Platform_Code as varchar) + ',' From Acq_Deal_Rights_Platform Where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
						SET  @Platform_Name = ''
						select @Platform_Name = @Platform_Name + Platform_Hiearachy + ',' from dbo.UFN_Get_Platform_With_Parent (@Codes)
						set @Platform_Name = reverse(stuff(reverse(@Platform_Name), 1, 1, ''))

				

						Set @Title_Names = ''
						Select @Title_Names = @Title_Names + Title_Name + ', ' From (
							Select Distinct 
							Case @Deal_Type_Condition
							When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
							When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
							Else t.Title_Name End As Title_Name
							From Title t  (NOLOCK)
							Inner Join Acq_Deal_Rights_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
							WHERE adrt.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
							) as a
							ORDER BY a.Title_Name

							SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						UPDATE #TempRightsHistory
						SET [Platform_Name] = @Platform_Name,[Title_Name] = @Title_Names,
						Country_Name = dbo.UFN_Get_Rights_Country(@Acq_Deal_Rights_Code,'A',''),
						Territory_Name = dbo.UFN_Get_Rights_Territory(@Acq_Deal_Rights_Code,'A'),
						 Dubbing = dbo.UFN_Get_Rights_Dubbing(@Acq_Deal_Rights_Code,'A')
						,Subtitling = dbo.UFN_Get_Rights_Subtitling(@Acq_Deal_Rights_Code,'A')
						WHERE AT_Acq_Deal_Rights_Code = 0 AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					END

				SET @ISChange = ''
				SET @ISChange_V1 = 0
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempRightsHistory WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code))
				BEGIN
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Platform_Name,'')  != isnull(b.Platform_Name,'') then 'Y' else @ISChange  end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND ISNULL(@ISChange,'') <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Country_Name,'')  != isnull(b.Country_Name,'') then 'Y' else @ISChange  end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Territory_Name,'')  != isnull(b.Territory_Name,'') then 'Y' else @ISChange  end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Subtitling,'')  != isnull(b.Subtitling,'') then 'Y' else @ISChange  end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Dubbing,'')  != isnull(b.Dubbing,'') then 'Y'  else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Is_Exclusive,'')  != isnull(b.Is_Exclusive,'') then 'Y' else @ISChange  end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Is_Title_Language_Right,'')  != isnull(b.Is_Title_Language_Right,'') then 'Y' else @ISChange  end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '12,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Is_Sub_License,'')  != isnull(b.Is_Sub_License,'') then 'Y' else @ISChange  end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '13,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Sub_License_Name,'')  != isnull(b.Sub_License_Name,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '14,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Is_Theatrical_Right,'')  != isnull(b.Is_Theatrical_Right,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '15,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Right_Type,'')  != isnull(b.Right_Type,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '16,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Is_Tentative,'')  != isnull(b.Is_Tentative,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '17,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Term,'')  != isnull(b.Term,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '18,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Right_Start_Date,'')  != isnull(b.Right_Start_Date,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '19,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Right_End_Date,'')  != isnull(b.Right_End_Date,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '20,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Milestone_Type_Name,'')  != isnull(b.Milestone_Type_Name,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '21,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Milestone_No_Of_Unit,'')  != isnull(b.Milestone_No_Of_Unit,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '22,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Milestone_Unit_Type,'')  != isnull(b.Milestone_Unit_Type,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '23,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Is_ROFR,'')  != isnull(b.Is_ROFR,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '24,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.ROFR_Date,'')  != isnull(b.ROFR_Date,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '25,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Restriction_Remarks,'')  != isnull(b.Restriction_Remarks,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '26,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Effective_Start_Date,'')  != isnull(b.Effective_Start_Date,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '27,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.ROFR_Type,'')  != isnull(b.ROFR_Type,'') then 'Y' else @ISChange end
					from #TempRightsHistory a 
					left join #TempRightsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code AND a.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code and b.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
					  update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '28,' where [Index] = @temp and version = @Version
					  and AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code 
					  AND Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
					  set @ISChange = '' 
					  SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					if(@ISChange_V1 > 1)
					BEGIN
						UPDATE #TempRightsHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code
				
					END

				END
				ELSE
				BEGIN
					UPDATE #TempRightsHistory
					SET Status = 'Added'
					WHERE AT_Acq_Deal_Rights_Code = @AT_Acq_Deal_Rights_Code
				END
					Fetch Next From CUR_Right InTo @AT_Acq_Deal_Rights_Code,@Version,@VersionOld,@Acq_Deal_Rights_Code,@temp
				END
				Close CUR_Right
				Deallocate CUR_Right
				Select * from #TempRightsHistory
			END
	---------------------------------------------------------- Code End for Deal Rights History-----------------------------------------------------------------------

	---------------------------------------------------------- Code Start for Deal Pushback History-------------------------------------------------------------------

	IF(@TabName = 'DEALPUSHBACK')
	BEGIN

		CREATE TABLE #TempPushbackHistory
		(
			AT_Acq_Deal_Pushback_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Pushback_Code int,
			[Title_Name] NVARCHAR(MAX),
			[Platform_Name] NVARCHAR(MAX),
			[Country_Name] NVARCHAR(MAX),
			[Territory_Name] NVARCHAR(MAX),
			[Subtitling] NVARCHAR(MAX),
			[Dubbing] NVARCHAR(MAX),
			Is_Title_Language_Right CHAR,
			Right_Type CHAR,
			Is_Tentative CHAR,
			Term VARCHAR(10),
			Right_Start_Date date,
			Right_End_Date date,
			Milestone_Type_Name NVARCHAR(100),
			Milestone_No_Of_Unit int,
			Milestone_Unit_Type int,
			Restriction_Remarks NVARCHAR(MAX),
			[Status] VARCHAR(10),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempPushbackHistory(AT_Acq_Deal_Pushback_Code,
		[Version],
		[VersionOld],
		Acq_Deal_Pushback_Code,
		Is_Title_Language_Right,
		Right_Type,
		Is_Tentative,
		Term,
		Right_Start_Date,
		Right_End_Date,
		Milestone_Type_Name,
		Milestone_No_Of_Unit,
		Milestone_Unit_Type,
		Restriction_Remarks,
		[Status],
		[Index] ,
		ChangedColumnIndex,
		[Inserted_By])
		Select AADR.AT_Acq_Deal_Pushback_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADR.Acq_Deal_Pushback_Code,0) Acq_Deal_Pushback_Code
		,AADR.Is_Title_Language_Right,AADR.Right_Type,AADR.Is_Tentative,AADR.Term,ISNULL(Convert(varchar(20),AADR.Right_Start_Date,106),'') Right_Start_Date,
		ISNULL(Convert(varchar(20),AADR.Right_End_Date,106),'') Right_End_Date,ISNULL(MT.Milestone_Type_Name,'') Milestone_Type_Name,ISNULL(AADR.Milestone_No_Of_Unit,'') Milestone_No_Of_Unit,
		ISNULL(AADR.Milestone_Unit_Type,'') Milestone_Unit_Type,ISNULL(AADR.Remarks,'') Restriction_Remarks, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Pushback AADR  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADR.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		LEFT JOIN Milestone_Type MT (NOLOCK) ON AADR.Milestone_Type_Code = MT.Milestone_Type_Code
		INNER JOIN Users USR  (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AADR.Acq_Deal_Pushback_Code ASC, AAD.Version ASC

		INSERT INTO #TempPushbackHistory(AT_Acq_Deal_Pushback_Code,
		[Version],
		[VersionOld],
		Acq_Deal_Pushback_Code,
		Is_Title_Language_Right,
		Right_Type,
		Is_Tentative,
		Term,
		Right_Start_Date,
		Right_End_Date,
		Milestone_Type_Name,
		Milestone_No_Of_Unit,
		Milestone_Unit_Type,
		Restriction_Remarks,
		[Status],
		[Index] ,
		ChangedColumnIndex,
		[Inserted_By])
		Select 0 AT_Acq_Deal_Pushback_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADR.Acq_Deal_Pushback_Code, 0) Acq_Deal_Pushback_Code
		,AADR.Is_Title_Language_Right,AADR.Right_Type,AADR.Is_Tentative,AADR.Term,ISNULL(Convert(varchar(20),AADR.Right_Start_Date,106),'') Right_Start_Date,
		ISNULL(Convert(varchar(20),AADR.Right_End_Date,106),'') Right_End_Date,ISNULL(MT.Milestone_Type_Name,'') Milestone_Type_Name,ISNULL(AADR.Milestone_No_Of_Unit,'') Milestone_No_Of_Unit,
		ISNULL(AADR.Milestone_Unit_Type,'') Milestone_Unit_Type,ISNULL(AADR.Remarks,'') Restriction_Remarks, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		from Acq_Deal_Pushback AADR  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADR.Acq_Deal_Code = AAD.Acq_Deal_Code
		LEFT JOIN Milestone_Type MT (NOLOCK) ON AADR.Milestone_Type_Code = MT.Milestone_Type_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempPushbackHistory)
		ORDER BY AADR.Acq_Deal_Pushback_Code ASC, AAD.Version ASC

		Declare @AT_Acq_Deal_Pushback_Code int,@Acq_Deal_Pushback_Code int
		Declare CUR_Pushback Cursor For Select AT_Acq_Deal_Pushback_Code,Version,VersionOld,Acq_Deal_Pushback_Code,[Index] From #TempPushbackHistory
			Open CUR_Pushback
			Fetch Next From CUR_Pushback InTo @AT_Acq_Deal_Pushback_Code,@Version,@VersionOld,@Acq_Deal_Pushback_Code, @temp
			While (@@FETCH_STATUS = 0)
			Begin
				IF(@AT_Acq_Deal_Pushback_Code > 0)
				BEGIN
					Set @Codes = ''
					Select @Codes = @Codes + Cast(Platform_Code as varchar) + ',' From AT_Acq_Deal_Pushback_Platform  (NOLOCK) Where AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code
					SET  @Platform_Name = ''
					select @Platform_Name = @Platform_Name + Platform_Hiearachy + ',' from dbo.UFN_Get_Platform_With_Parent (@Codes)
					set @Platform_Name = reverse(stuff(reverse(@Platform_Name), 1, 1, ''))

					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join AT_Acq_Deal_Pushback_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

					UPDATE #TempPushbackHistory
					SET [Platform_Name] = @Platform_Name,[Title_Name] = @Title_Names,
					Country_Name = dbo.UFN_Get_Rights_Country_AT(@AT_Acq_Deal_Pushback_Code,'P'),
					Territory_Name = dbo.UFN_Get_Rights_Territory_AT(@AT_Acq_Deal_Pushback_Code,'P'),
					 Dubbing = dbo.UFN_Get_Rights_Dubbing_AT(@AT_Acq_Deal_Pushback_Code,'P')
					,Subtitling = dbo.UFN_Get_Rights_Subtitling_AT(@AT_Acq_Deal_Pushback_Code,'P')
					WHERE AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code
				END
				ELSE
				BEGIN
					Set @Codes = ''
					Select @Codes = @Codes + Cast(Platform_Code as varchar) + ',' From Acq_Deal_Pushback_Platform (NOLOCK) Where Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code
					SET  @Platform_Name = ''
					select @Platform_Name = @Platform_Name + Platform_Hiearachy + ',' from dbo.UFN_Get_Platform_With_Parent (@Codes)
					set @Platform_Name = reverse(stuff(reverse(@Platform_Name), 1, 1, ''))

				

					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join Acq_Deal_Pushback_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

					UPDATE #TempPushbackHistory
					SET [Platform_Name] = @Platform_Name,[Title_Name] = @Title_Names,
					Country_Name = dbo.UFN_Get_Rights_Country(@Acq_Deal_Pushback_Code,'P',''),
					Territory_Name = dbo.UFN_Get_Rights_Territory(@Acq_Deal_Pushback_Code,'P'),
					 Dubbing = dbo.UFN_Get_Rights_Dubbing(@Acq_Deal_Pushback_Code,'P')
					,Subtitling = dbo.UFN_Get_Rights_Subtitling(@Acq_Deal_Pushback_Code,'P')
					WHERE AT_Acq_Deal_Pushback_Code = 0 AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code
				END

			SET @ISChange = ''
			SET @ISChange_V1 = 0
			if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempPushbackHistory WHERE Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code))
			BEGIN
				select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code
						
				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Platform_Name,'')  != isnull(b.Platform_Name,'') then 'Y' else @ISChange  end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND ISNULL(@ISChange,'') <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Country_Name,'')  != isnull(b.Country_Name,'') then 'Y' else @ISChange  end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Territory_Name,'')  != isnull(b.Territory_Name,'') then 'Y' else @ISChange  end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Subtitling,'')  != isnull(b.Subtitling,'') then 'Y' else @ISChange  end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Dubbing,'')  != isnull(b.Dubbing,'') then 'Y'  else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Is_Title_Language_Right,'')  != isnull(b.Is_Title_Language_Right,'') then 'Y' else @ISChange  end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Right_Type,'')  != isnull(b.Right_Type,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '12,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Is_Tentative,'')  != isnull(b.Is_Tentative,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '13,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Term,'')  != isnull(b.Term,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '14,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Right_Start_Date,'')  != isnull(b.Right_Start_Date,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '15,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Right_End_Date,'')  != isnull(b.Right_End_Date,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '16,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Milestone_Type_Name,'')  != isnull(b.Milestone_Type_Name,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '17,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Milestone_No_Of_Unit,'')  != isnull(b.Milestone_No_Of_Unit,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '18,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Milestone_Unit_Type,'')  != isnull(b.Milestone_Unit_Type,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '19,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				select @ISChange =  case when ISNULL(a.Restriction_Remarks,'')  != isnull(b.Restriction_Remarks,'') then 'Y' else @ISChange end
				from #TempPushbackHistory a 
				left join #TempPushbackHistory b on a.Version = b.VersionOld
				where a.Version = @Version and a.AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code AND a.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code and b.Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code AND @ISChange <> 'Y'

				if(@ISChange = 'Y')
				BEGIN
					update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '20,' where [Index] = @temp and version = @Version
					and AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code 
					AND Acq_Deal_Pushback_Code = @Acq_Deal_Pushback_Code 
					set @ISChange = '' 
					SET @ISChange_V1 = @ISChange_V1 + 1 
				END

				if(@ISChange_V1 > 0)
				BEGIN
					UPDATE #TempPushbackHistory
					SET Status = 'Modified'
					WHERE AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code
				
				END

			END
			ELSE
			BEGIN
				UPDATE #TempPushbackHistory
				SET Status = 'Added'
				WHERE AT_Acq_Deal_Pushback_Code = @AT_Acq_Deal_Pushback_Code
			END
				Fetch Next From CUR_Pushback InTo @AT_Acq_Deal_Pushback_Code,@Version,@VersionOld,@Acq_Deal_Pushback_Code, @temp
			END
			Close CUR_Pushback
			Deallocate CUR_Pushback
			Select * from #TempPushbackHistory

	END

	-- Code End for Deal Pushback History

	-- Code Start for Deal Payment Term
	IF(@TabName = 'DEALPAYMENTTERM')
	BEGIN
		CREATE TABLE #TempPlatformHistory
		(
			AT_Acq_Deal_Payment_Terms_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Payment_Terms_Code int,
			Cost_Type NVARCHAR(200),
			Payment_Term NVARCHAR(200),
			Days_After int,
			Percentage decimal(10,3),
			Amount decimal(10,3),
			Due_Date date,
			[Status] VARCHAR(10),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempPlatformHistory
		(
			AT_Acq_Deal_Payment_Terms_Code,
			[Version] ,
			[VersionOld],
			Acq_Deal_Payment_Terms_Code,
			Cost_Type ,
			Payment_Term ,
			Days_After ,
			Percentage ,
			Amount ,
			Due_Date,
			[Status],
		[Index] ,
		ChangedColumnIndex,
		[Inserted_By]
		)
		Select AAPT.AT_Acq_Deal_Payment_Terms_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,
		ISNULL(AAPT.Acq_Deal_Payment_Terms_Code ,0) Acq_Deal_Payment_Terms_Code,CT.Cost_Type_Name,PT.Payment_Terms,AAPT.Days_After,AAPT.Percentage,AAPT.Amount,CONVERT(VARCHAR(20),AAPT.Due_Date,106) Due_Date, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Payment_Terms AAPT  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AAPT.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		LEFT JOIN Cost_Type CT (NOLOCK) ON AAPT.Cost_Type_Code = CT.Cost_Type_Code
		LEFT JOIN Payment_Terms PT (NOLOCK) ON AAPT.Payment_Term_Code = PT.Payment_Terms_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AAPT.Acq_Deal_Payment_Terms_Code ASC, AAD.Version ASC

		INSERT INTO #TempPlatformHistory
		(
			AT_Acq_Deal_Payment_Terms_Code,
			[Version] ,
			[VersionOld],
			Acq_Deal_Payment_Terms_Code,
			Cost_Type ,
			Payment_Term ,
			Days_After ,
			Percentage ,
			Amount ,
			Due_Date,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select 0 AT_Acq_Deal_Payment_Terms_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AAPT.Acq_Deal_Payment_Terms_Code, 0) Acq_Deal_Payment_Terms_Code,CT.Cost_Type_Name,PT.Payment_Terms,AAPT.Days_After,AAPT.Percentage,AAPT.Amount,CONVERT(VARCHAR(20),AAPT.Due_Date,106) Due_Date, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM Acq_Deal_Payment_Terms AAPT  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AAPT.Acq_Deal_Code = AAD.Acq_Deal_Code
		LEFT JOIN Cost_Type CT  (NOLOCK) ON AAPT.Cost_Type_Code = CT.Cost_Type_Code
		LEFT JOIN Payment_Terms PT (NOLOCK) ON AAPT.Payment_Term_Code = PT.Payment_Terms_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempPlatformHistory)
		ORDER BY AAPT.Acq_Deal_Payment_Terms_Code ASC, AAD.Version ASC


	Declare @AT_Acq_Deal_Payment_Terms_Code int, @Acq_Deal_Payment_Terms_Code int
	Declare CUR_PaymentTerm Cursor For Select AT_Acq_Deal_Payment_Terms_Code,Version,VersionOld,Acq_Deal_Payment_Terms_Code,[Index] From #TempPlatformHistory
			Open CUR_PaymentTerm
			Fetch Next From CUR_PaymentTerm InTo @AT_Acq_Deal_Payment_Terms_Code,@Version,@VersionOld,@Acq_Deal_Payment_Terms_Code, @temp
			While (@@FETCH_STATUS = 0)
			Begin
				SET @ISChange = ''
				SET @ISChange_V1 = 0
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempPlatformHistory WHERE Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Cost_Type,'')  != isnull(b.Cost_Type,'') then 'Y' else @ISChange end
					from #TempPlatformHistory a 
					left join #TempPlatformHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code AND a.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code and b.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code

					if(@ISChange = 'Y')
					BEGIN
						update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code 
						AND Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Payment_Term,'')  != isnull(b.Payment_Term,'') then 'Y' else @ISChange end
					from #TempPlatformHistory a 
					left join #TempPlatformHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code AND a.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code and b.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code 
						AND Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Days_After,'')  != isnull(b.Days_After,'') then 'Y' else @ISChange end
					from #TempPlatformHistory a 
					left join #TempPlatformHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code AND a.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code and b.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code 
						AND Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Percentage,'0')  != isnull(b.Percentage,'0') then 'Y' else @ISChange end
					from #TempPlatformHistory a 
					left join #TempPlatformHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code AND a.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code and b.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code 
						AND Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Amount,'0')  != isnull(b.Amount,'0') then 'Y' else @ISChange end
					from #TempPlatformHistory a 
					left join #TempPlatformHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code AND a.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code and b.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code 
						AND Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Due_Date,'')  != isnull(b.Due_Date,'') then 'Y' else @ISChange end
					from #TempPlatformHistory a 
					left join #TempPlatformHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code AND a.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code and b.Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code 
						AND Acq_Deal_Payment_Terms_Code = @Acq_Deal_Payment_Terms_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					if(@ISChange_V1 > 1)
					BEGIN
						UPDATE #TempPlatformHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempPlatformHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Payment_Terms_Code = @AT_Acq_Deal_Payment_Terms_Code
				END
				Fetch Next From CUR_PaymentTerm InTo @AT_Acq_Deal_Payment_Terms_Code,@Version,@VersionOld,@Acq_Deal_Payment_Terms_Code	, @temp
			END
			Close CUR_PaymentTerm
			Deallocate CUR_PaymentTerm
			Select * from #TempPlatformHistory
	END
	--------------------------------------------------------------- Code  End for Deal Payment Term--------------------------------------------------------------

	--------------------------------------------------------------- Code Start for Deal Attachment History--------------------------------------------------------

		IF(@TabName = 'DEALATTACHMENT')
		BEGIN
		
			CREATE TABLE #TempAttachmentHistory
			(
				AT_Acq_Deal_Attachment_Code int,
				[Version] VARCHAR(50),
				[VersionOld] VARCHAR(50),
				Acq_Deal_Attachment_Code int,
				Title_Name NVARCHAR(500),
				Attachment_Title NVARCHAR(500),
				Attachment_File_Name NVARCHAR(500),
				System_File_Name Varchar(1000),
				Document_Type NVARCHAR(500),
				Episode_From int,
				Episode_To int,
				[Status] NVARCHAR(10),
				[Index] int,
				ChangedColumnIndex VARCHAR(MAX),
				[Inserted_By] VARCHAR(50)
			)

		INSERT INTO #TempAttachmentHistory
		(
			AT_Acq_Deal_Attachment_Code ,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Attachment_Code,
			Title_Name ,
			Attachment_Title ,
			Attachment_File_Name ,
			System_File_Name ,
			Document_Type ,
			Episode_From ,
			Episode_To ,
			[Status] ,
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADA.AT_Acq_Deal_Attachment_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADA.Acq_Deal_Attachment_Code, 0) Acq_Deal_Attachment_Code,
		T.Title_Name,AADA.Attachment_Title,AADA.Attachment_File_Name,AADA.System_File_Name,DT.Document_Type_Name,AADA.Episode_From,AADA.Episode_To,'UnChanged' [Status]	,cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Attachment AADA  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADA.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		LEFT JOIN Document_Type DT (NOLOCK) ON AADA.Document_Type_Code = DT.Document_Type_Code
		LEFT JOIN Title T (NOLOCK) ON AADA.Title_Code = T.Title_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AADA.Acq_Deal_Attachment_Code ASC, AAD.Version ASC

		INSERT INTO #TempAttachmentHistory
		(
			AT_Acq_Deal_Attachment_Code ,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Attachment_Code,
			Title_Name ,
			Attachment_Title ,
			Attachment_File_Name ,
			System_File_Name ,
			Document_Type ,
			Episode_From ,
			Episode_To ,
			[Status] ,
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select 0 AT_Acq_Deal_Attachment_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADA.Acq_Deal_Attachment_Code, 0)Acq_Deal_Attachment_Code,
		T.Title_Name,AADA.Attachment_Title,AADA.Attachment_File_Name,AADA.System_File_Name,DT.Document_Type_Name,AADA.Episode_From,AADA.Episode_To,'UnChanged' [Status]	,cast(AAD.Version as decimal), '',USR.Login_Name
		FROM Acq_Deal_Attachment AADA  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADA.Acq_Deal_Code = AAD.Acq_Deal_Code
		LEFT JOIN Document_Type DT (NOLOCK) ON AADA.Document_Type_Code = DT.Document_Type_Code
		LEFT JOIN Title T (NOLOCK) ON AADA.Title_Code = T.Title_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempAttachmentHistory)
		ORDER BY AADA.Acq_Deal_Attachment_Code ASC, AAD.Version ASC


		Declare @AT_Acq_Deal_Attachment_Code int, @Acq_Deal_Attachment_Code int
		Declare CUR_Attachment Cursor For Select AT_Acq_Deal_Attachment_Code,Version,VersionOld,Acq_Deal_Attachment_Code, [Index] From #TempAttachmentHistory
			Open CUR_Attachment
			Fetch Next From CUR_Attachment InTo @AT_Acq_Deal_Attachment_Code,@Version,@VersionOld,@Acq_Deal_Attachment_Code, @temp
			While (@@FETCH_STATUS = 0)
			Begin
				SET @ISChange = ''
				SET @ISChange_V1 = 0
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempAttachmentHistory WHERE Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempAttachmentHistory a 
					left join #TempAttachmentHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code AND a.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code and b.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code 
						AND Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Attachment_Title,'')  != isnull(b.Attachment_Title,'') then 'Y' else @ISChange end
					from #TempAttachmentHistory a 
					left join #TempAttachmentHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code AND a.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code and b.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code 
						AND Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Attachment_File_Name,'')  != isnull(b.Attachment_File_Name,'') then 'Y' else @ISChange end
					from #TempAttachmentHistory a 
					left join #TempAttachmentHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code AND a.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code and b.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code 
						AND Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.System_File_Name,'')  != isnull(b.System_File_Name,'') then 'Y' else @ISChange end
					from #TempAttachmentHistory a 
					left join #TempAttachmentHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code AND a.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code and b.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code 
						AND Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Document_Type,'')  != isnull(b.Document_Type,'') then 'Y' else @ISChange end
					from #TempAttachmentHistory a 
					left join #TempAttachmentHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code AND a.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code and b.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code 
						AND Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Episode_From,'')  != isnull(b.Episode_From,'') then 'Y' else @ISChange end
					from #TempAttachmentHistory a 
					left join #TempAttachmentHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code AND a.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code and b.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code 
						AND Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Episode_To,'')  != isnull(b.Episode_To,'') then 'Y' else @ISChange end
					from #TempAttachmentHistory a 
					left join #TempAttachmentHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code AND a.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code and b.Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code 
						AND Acq_Deal_Attachment_Code = @Acq_Deal_Attachment_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					if(@ISChange_V1 > 1)
					BEGIN
						UPDATE #TempAttachmentHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempAttachmentHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Attachment_Code = @AT_Acq_Deal_Attachment_Code
				END
				Fetch Next From CUR_Attachment InTo @AT_Acq_Deal_Attachment_Code,@Version,@VersionOld,@Acq_Deal_Attachment_Code, @temp
			END
			Close CUR_Attachment
			Deallocate CUR_Attachment
			Select * from #TempAttachmentHistory
		END

	-- Code End for Deal Attachment History

	-- Code Start for Deal Material History

	IF(@TabName = 'DEALMATERIAL')
	BEGIN
		CREATE TABLE #TempMaterialHistory
		(
			AT_Acq_Deal_Material_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Material_Code int,
			Title_Name NVARCHAR(500),
			Material_Medium NVARCHAR(500),
			Material_Type NVARCHAR(500),
			Quantity int,
			Episode_From int,
			Episode_To int,
			[Status] VARCHAR(10),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempMaterialHistory
		(
			AT_Acq_Deal_Material_Code ,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Material_Code,
			Title_Name ,
			Material_Medium ,
			Material_Type ,
			Quantity ,
			Episode_From ,
			Episode_To ,
			[Status] ,
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADM.AT_Acq_Deal_Material_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADM.Acq_Deal_Material_Code, 0)Acq_Deal_Material_Code,
		T.Title_Name,MM.Material_Medium_Name,MT.Material_Type_Name,AADM.Quantity,AADM.Episode_From,AADM.Episode_To,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Material AADM  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADM.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		LEFT JOIN Material_Medium MM (NOLOCK) ON AADM.Material_Medium_Code= MM.Material_Medium_Code
		LEFT JOIN Material_Type MT (NOLOCK) ON AADM.Material_Type_Code = MT.Material_Type_Code
		LEFT JOIN Title T (NOLOCK) ON AADM.Title_Code = T.Title_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AADM.Acq_Deal_Material_Code ASC, AAD.Version ASC

		INSERT INTO #TempMaterialHistory
		(
			AT_Acq_Deal_Material_Code ,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Material_Code,
			Title_Name ,
			Material_Medium ,
			Material_Type ,
			Quantity ,
			Episode_From ,
			Episode_To ,
			[Status] ,
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select 0 AT_Acq_Deal_Material_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADM.Acq_Deal_Material_Code, 0)Acq_Deal_Material_Code,
		T.Title_Name,MM.Material_Medium_Name,MT.Material_Type_Name,AADM.Quantity,AADM.Episode_From,AADM.Episode_To,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM Acq_Deal_Material AADM  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADM.Acq_Deal_Code = AAD.Acq_Deal_Code
		LEFT JOIN Material_Medium MM (NOLOCK) ON AADM.Material_Medium_Code= MM.Material_Medium_Code
		LEFT JOIN Material_Type MT (NOLOCK) ON AADM.Material_Type_Code = MT.Material_Type_Code
		LEFT JOIN Title T (NOLOCK) ON AADM.Title_Code = T.Title_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempMaterialHistory)
		ORDER BY AADM.Acq_Deal_Material_Code ASC, AAD.Version ASC


		Declare @AT_Acq_Deal_Material_Code int, @Acq_Deal_Material_Code int
		Declare CUR_Material Cursor For Select AT_Acq_Deal_Material_Code,Version,VersionOld,Acq_Deal_Material_Code, [Index] From #TempMaterialHistory
				Open CUR_Material
				Fetch Next From CUR_Material InTo @AT_Acq_Deal_Material_Code,@Version,@VersionOld,@Acq_Deal_Material_Code, @temp
				While (@@FETCH_STATUS = 0)
				Begin
					SET @ISChange = ''
					SET @ISChange_V1 = 0
					if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempMaterialHistory WHERE Acq_Deal_Material_Code = @Acq_Deal_Material_Code))
					BEGIN
				
						select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
						from #TempMaterialHistory a 
						left join #TempMaterialHistory b on a.Version = b.VersionOld
						where a.Version = @Version and a.AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code AND a.Acq_Deal_Material_Code = @Acq_Deal_Material_Code and b.Acq_Deal_Material_Code = @Acq_Deal_Material_Code
			
						if(@ISChange = 'Y')
						BEGIN
							update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
							and AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code 
							AND Acq_Deal_Material_Code = @Acq_Deal_Material_Code 
							set @ISChange = '' 
							SET @ISChange_V1 = @ISChange_V1 + 1 
						END
			
						select @ISChange =  case when ISNULL(a.Material_Medium,'')  != isnull(b.Material_Medium,'') then 'Y' else @ISChange end
						from #TempMaterialHistory a 
						left join #TempMaterialHistory b on a.Version = b.VersionOld
						where a.Version = @Version and a.AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code AND a.Acq_Deal_Material_Code = @Acq_Deal_Material_Code and b.Acq_Deal_Material_Code = @Acq_Deal_Material_Code AND @ISChange <> 'Y'
					
						if(@ISChange = 'Y')
						BEGIN
							update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
							and AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code 
							AND Acq_Deal_Material_Code = @Acq_Deal_Material_Code 
							set @ISChange = '' 
							SET @ISChange_V1 = @ISChange_V1 + 1 
						END
			
						select @ISChange =  case when ISNULL(a.Material_Type,'')  != isnull(b.Material_Type,'') then 'Y' else @ISChange end
						from #TempMaterialHistory a 
						left join #TempMaterialHistory b on a.Version = b.VersionOld
						where a.Version = @Version and a.AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code AND a.Acq_Deal_Material_Code = @Acq_Deal_Material_Code and b.Acq_Deal_Material_Code = @Acq_Deal_Material_Code AND @ISChange <> 'Y'
					
						if(@ISChange = 'Y')
						BEGIN
							update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
							and AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code 
							AND Acq_Deal_Material_Code = @Acq_Deal_Material_Code 
							set @ISChange = '' 
							SET @ISChange_V1 = @ISChange_V1 + 1 
						END
			
						select @ISChange =  case when ISNULL(a.Quantity,'0')  != isnull(b.Quantity,'0') then 'Y' else @ISChange end
						from #TempMaterialHistory a 
						left join #TempMaterialHistory b on a.Version = b.VersionOld
						where a.Version = @Version and a.AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code AND a.Acq_Deal_Material_Code = @Acq_Deal_Material_Code and b.Acq_Deal_Material_Code = @Acq_Deal_Material_Code AND @ISChange <> 'Y'
					
						if(@ISChange = 'Y')
						BEGIN
							update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
							and AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code 
							AND Acq_Deal_Material_Code = @Acq_Deal_Material_Code 
							set @ISChange = '' 
							SET @ISChange_V1 = @ISChange_V1 + 1 
						END
			
						select @ISChange =  case when ISNULL(a.Episode_From,'1')  != isnull(b.Episode_From,'1') then 'Y' else @ISChange end
						from #TempMaterialHistory a 
						left join #TempMaterialHistory b on a.Version = b.VersionOld
						where a.Version = @Version and a.AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code AND a.Acq_Deal_Material_Code = @Acq_Deal_Material_Code and b.Acq_Deal_Material_Code = @Acq_Deal_Material_Code AND @ISChange <> 'Y'
					
						if(@ISChange = 'Y')
						BEGIN
							update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
							and AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code 
							AND Acq_Deal_Material_Code = @Acq_Deal_Material_Code 
							set @ISChange = '' 
							SET @ISChange_V1 = @ISChange_V1 + 1 
						END
			
						select @ISChange =  case when ISNULL(a.Episode_To,'1')  != isnull(b.Episode_To,'1') then 'Y' else @ISChange end
						from #TempMaterialHistory a 
						left join #TempMaterialHistory b on a.Version = b.VersionOld
						where a.Version = @Version and a.AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code AND a.Acq_Deal_Material_Code = @Acq_Deal_Material_Code and b.Acq_Deal_Material_Code = @Acq_Deal_Material_Code AND @ISChange <> 'Y'
					
						if(@ISChange = 'Y')
						BEGIN
							update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
							and AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code 
							AND Acq_Deal_Material_Code = @Acq_Deal_Material_Code 
							set @ISChange = '' 
							SET @ISChange_V1 = @ISChange_V1 + 1 
						END
			
						if(@ISChange_V1 > 1)
						BEGIN
							UPDATE #TempMaterialHistory
							SET Status = 'Modified'
							WHERE AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code
				
						END
					END
					ELSE
					BEGIN
							UPDATE #TempMaterialHistory
							SET Status = 'Added'
							WHERE AT_Acq_Deal_Material_Code = @AT_Acq_Deal_Material_Code
					END
					Fetch Next From CUR_Material InTo @AT_Acq_Deal_Material_Code,@Version,@VersionOld,@Acq_Deal_Material_Code, @temp
				END
				Close CUR_Material
				Deallocate CUR_Material
				Select * from #TempMaterialHistory
			END
	-- Code End for Deal Material History

	-- Code start for Deal Ancillary History	
		IF(@TabName = 'DEALANCILLARY')
		BEGIN

		CREATE TABLE #TempAncillaryHistory
		(
			AT_Acq_Deal_Ancillary_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Ancillary_Code int,
			Title_Name NVARCHAR(MAX),
			Ancillary_Type NVARCHAR(2000),
			Ancillary_Platform NVARCHAR(MAX),
			Ancillary_Platform_Medium NVARCHAR(MAX),
			Duration numeric(5,0),
			[Day] numeric(4,0),
			Remarks NVARCHAR(MAX),
			[Status] VARCHAR(10),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempAncillaryHistory
		(
			AT_Acq_Deal_Ancillary_Code,
			[Version],
			[VersionOld],
			Acq_Deal_Ancillary_Code,
			Ancillary_Type,
			Ancillary_Platform,
			Ancillary_Platform_Medium,
			Duration,
			[Day],
			Remarks,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADA.AT_Acq_Deal_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADA.Acq_Deal_Ancillary_Code ,0 ) AS Acq_Deal_Ancillary_Code,
		AT.Ancillary_Type_Name,
		dbo.UFN_Get_Acq_Ancillary_Platform_AT(AADA.AT_Acq_Deal_Ancillary_Code) Ancillary_Platform,
		dbo.UFN_Get_Acq_Ancillary_Medium_BaseOn_AncillaryCode_AT(AADA.AT_Acq_Deal_Ancillary_Code) Ancillary_Platform_Medium,
		AADA.Duration,AADA.[Day],AADA.Remarks,
		'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Ancillary AADA (NOLOCK)
		INNER JOIN Ancillary_Type AT (NOLOCK) ON AADA.Ancillary_Type_code = AT.Ancillary_Type_code
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADA.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AADA.Acq_Deal_Ancillary_Code ASC, AAD.Version ASC

		INSERT INTO #TempAncillaryHistory
		(
			AT_Acq_Deal_Ancillary_Code,
			[Version],
			[VersionOld],
			Acq_Deal_Ancillary_Code,
			Ancillary_Type,
			Ancillary_Platform,
			Ancillary_Platform_Medium,
			Duration,
			[Day],
			Remarks,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select 0 AT_Acq_Deal_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADA.Acq_Deal_Ancillary_Code, 0) Acq_Deal_Ancillary_Code,
		AT.Ancillary_Type_Name,
		dbo.UFN_Get_Acq_Ancillary_Platform(AADA.Acq_Deal_Ancillary_Code) Ancillary_Platform,
		dbo.UFN_Get_Acq_Ancillary_Medium_BaseOn_AncillaryCode(AADA.Acq_Deal_Ancillary_Code) Ancillary_Platform_Medium,
		AADA.Duration,AADA.[Day],AADA.Remarks,
		'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM Acq_Deal_Ancillary AADA  (NOLOCK)
		INNER JOIN Ancillary_Type AT (NOLOCK) ON AADA.Ancillary_Type_code = AT.Ancillary_Type_code
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADA.Acq_Deal_Code = AAD.Acq_Deal_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempAncillaryHistory)
		ORDER BY AADA.Acq_Deal_Ancillary_Code ASC, AAD.Version ASC

		Declare @AT_Acq_Deal_Ancillary_Code int, @Acq_Deal_Ancillary_Code int
		Declare CUR_Ancillary Cursor For Select AT_Acq_Deal_Ancillary_Code,Version,VersionOld,Acq_Deal_Ancillary_Code,[Index] From #TempAncillaryHistory
			Open CUR_Ancillary
			Fetch Next From CUR_Ancillary InTo @AT_Acq_Deal_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Ancillary_Code, @temp
			While (@@FETCH_STATUS = 0)
			Begin
			
				IF(@AT_Acq_Deal_Ancillary_Code > 0)
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join AT_Acq_Deal_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))
					
					UPDATE #TempAncillaryHistory
					SET [Title_Name] = @Title_Names
					WHERE AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code
				END
				ELSE
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join Acq_Deal_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						UPDATE #TempAncillaryHistory
						SET [Title_Name] = @Title_Names
						WHERE AT_Acq_Deal_Ancillary_Code = 0 AND Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code
				END

				SET @ISChange = ''
				SET @ISChange_V1 = 0
			
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempAncillaryHistory WHERE Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempAncillaryHistory a 
					left join #TempAncillaryHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code 
					AND a.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code and b.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code
			
					if(@ISChange = 'Y')
					BEGIN
						update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code 
						AND Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
					/*********************************/
					select @ISChange =  case when ISNULL(a.Ancillary_Type,'')  != isnull(b.Ancillary_Type,'') then 'Y' else @ISChange end
					from #TempAncillaryHistory a 
					left join #TempAncillaryHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code 
					AND a.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code and b.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code 
						AND Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					/***********************************/

			
					select @ISChange =  case when ISNULL(a.Ancillary_Platform,'')  != isnull(b.Ancillary_Platform,'') then 'Y' else @ISChange end
					from #TempAncillaryHistory a 
					left join #TempAncillaryHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code AND a.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code and b.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code 
						AND Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
			
					select @ISChange =  case when ISNULL(a.Ancillary_Platform_Medium,'')  != isnull(b.Ancillary_Platform_Medium,'') then 'Y' else @ISChange end
					from #TempAncillaryHistory a 
					left join #TempAncillaryHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code AND a.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code and b.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code 
						AND Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
			
					select @ISChange =  case when ISNULL(a.Duration,'0') != ISNULL(b.Duration,'0') then 'Y' else @ISChange end
					from #TempAncillaryHistory a 
					left join #TempAncillaryHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code AND a.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code and b.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code 
						AND Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END


					select @ISChange =  case when ISNULL(a.[Day],'0') != ISNULL(b.[Day],'0') then 'Y' else @ISChange end
					from #TempAncillaryHistory a 
					left join #TempAncillaryHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code AND a.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code and b.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code 
						AND Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
			
					select @ISChange =  case when ISNULL(a.Remarks,'')  != isnull(b.Remarks,'') then 'Y' else @ISChange end
					from #TempAncillaryHistory a 
					left join #TempAncillaryHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code AND a.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code and b.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code 
						AND Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code 
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
			
					if(@ISChange_V1 > 0)
					BEGIN
						UPDATE #TempAncillaryHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempAncillaryHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Ancillary_Code = @AT_Acq_Deal_Ancillary_Code
				END
				Fetch Next From CUR_Ancillary InTo @AT_Acq_Deal_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Ancillary_Code, @temp
			END
			Close CUR_Ancillary
			Deallocate CUR_Ancillary
			SELECT * FROM  #TempAncillaryHistory
		END

	-- Code end for Deal Ancillary History

	-- Code end for Deal Sport

		IF(@TabName = 'DEALSPORTS')
		BEGIN
	--	
		CREATE TABLE #TempSportsHistory
		(
			AT_Acq_Deal_Sport_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Sport_Code int,
			Title_Name NVARCHAR(MAX),
			Content_Delivery NVARCHAR(20),
			Content_Delivery_Broadcast_Names NVARCHAR(MAX),
			Obligation_Broadcast NVARCHAR(3),
			Obligation_Broadcast_Names NVARCHAR(MAX),
			Deferred_Live NVARCHAR(50),
			Deferred_Live_Duration NVARCHAR(100),
			Tape_Delayed NVARCHAR(50),
			Tape_Delayed_Duration NVARCHAR(100),
			Standalone_Transmission NVARCHAR(3),
			Standalone_Substantial NVARCHAR(3),
			Standalone_Digital_Platform NVARCHAR(MAX),
			Simulcast_Transmission NVARCHAR(3),
			Simulcast_Substantial NVARCHAR(3),
			Simulcast_Digital_Platform NVARCHAR(MAX),
			[LanguageNames] NVARCHAR(MAX),
			[LanguageGroupNames] NVARCHAR(MAX),
			[File_Name] NVARCHAR(1000),
			Sys_File_Name NVARCHAR(1000),
			Remarks NVARCHAR(2000),
			MBO_Note NVARCHAR(2000),
			[Status] VARCHAR(10),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempSportsHistory
		(
			AT_Acq_Deal_Sport_Code,
			[Version] ,
			[VersionOld],
			Acq_Deal_Sport_Code,
			Content_Delivery,
			Content_Delivery_Broadcast_Names ,
			Obligation_Broadcast ,
			Obligation_Broadcast_Names ,
			Deferred_Live ,
			Deferred_Live_Duration ,
			Tape_Delayed ,
			Tape_Delayed_Duration ,
			Standalone_Transmission ,
			Standalone_Substantial ,
			Standalone_Digital_Platform ,
			Simulcast_Transmission ,
			Simulcast_Substantial ,
			Simulcast_Digital_Platform ,
			[LanguageNames] ,
			[LanguageGroupNames] ,
			[File_Name] ,
			Sys_File_Name ,
			Remarks ,
			MBO_Note ,
			[Status] ,
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADS.AT_Acq_Deal_Sport_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADS.Acq_Deal_Sport_Code, CASE WHEN AADS.Content_Delivery = 'LV' THEN 'Live' ELSE 'Recorded' END Content_Delivery,
		[dbo].[UFN_Get_Sports_Broadcast](AADS.AT_Acq_Deal_Sport_Code,'MO','AT') Content_Delivery_Broadcast_Names,CASE WHEN AADS.Obligation_Broadcast ='Y' THEN 'Yes' ELSE 'No' END Obligation_Broadcast,
		[dbo].[UFN_Get_Sports_Broadcast](AADS.AT_Acq_Deal_Sport_Code,'OB','AT') Obligation_Broadcast_Names,
		CASE AADS.Deferred_Live  WHEN 'DF' THEN 'Defined' WHEN 'UL' THEN 'Unlimited' ELSE 'NA' END Deferred_Live,
		AADS.Deferred_Live_Duration,
		CASE AADS.Tape_Delayed  WHEN 'DF' THEN 'Defined' WHEN 'UL' THEN 'Unlimited' ELSE 'NA' END Tape_Delayed,
		AADS.Tape_Delayed_Duration,
		CASE WHEN AADS.Standalone_Transmission = 'Y' THEN 'Yes' ELSE 'No' END Standalone_Transmission,
		CASE WHEN AADS.Standalone_Substantial = 'Y' THEN 'Yes' ELSE 'No' END Standalone_Substantial,
		[dbo].[UFN_Get_Sports_Platform](AADS.AT_Acq_Deal_Sport_Code,'ST','AT') Standalone_Digital_Platform,
		CASE WHEN AADS.Simulcast_Transmission = 'Y' THEN 'Yes' ELSE 'No' END Simulcast_Transmission,
		CASE WHEN AADS.Simulcast_Substantial = 'Y' THEN 'Yes' ELSE 'No' END Simulcast_Substantial,
		[dbo].[UFN_Get_Sports_Platform](AADS.AT_Acq_Deal_Sport_Code,'SM','AT') Simulcast_Digital_Platform,
		[dbo].[UFN_Get_Sport_Language](AADS.AT_Acq_Deal_Sport_Code,'AT') [LanguageNames],
		[dbo].[UFN_Get_Sport_Language](AADS.AT_Acq_Deal_Sport_Code,'AT') [LanguageGroupNames],AADS.[File_Name],
		AADS.Sys_File_Name,AADS.Remarks,AADS.MBO_Note,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Sport AADS  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADS.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AADS.Acq_Deal_Sport_Code ASC, AAD.Version ASC

		INSERT INTO #TempSportsHistory
		(
			AT_Acq_Deal_Sport_Code,
			[Version] ,
			[VersionOld],
			Acq_Deal_Sport_Code,
			Content_Delivery,
			Content_Delivery_Broadcast_Names ,
			Obligation_Broadcast ,
			Obligation_Broadcast_Names ,
			Deferred_Live ,
			Deferred_Live_Duration ,
			Tape_Delayed ,
			Tape_Delayed_Duration ,
			Standalone_Transmission ,
			Standalone_Substantial ,
			Standalone_Digital_Platform ,
			Simulcast_Transmission ,
			Simulcast_Substantial ,
			Simulcast_Digital_Platform ,
			[LanguageNames] ,
			[LanguageGroupNames] ,
			[File_Name] ,
			Sys_File_Name ,
			Remarks ,
			MBO_Note ,
			[Status] ,
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select 0 AT_Acq_Deal_Sport_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADS.Acq_Deal_Sport_Code, CASE WHEN AADS.Content_Delivery = 'LV' THEN 'Live' ELSE 'Recorded' END Content_Delivery,
		[dbo].[UFN_Get_Sports_Broadcast](AADS.Acq_Deal_Sport_Code,'MO','A') Content_Delivery_Broadcast_Names,CASE WHEN AADS.Obligation_Broadcast ='Y' THEN 'Yes' ELSE 'No' END Obligation_Broadcast,
		[dbo].[UFN_Get_Sports_Broadcast](AADS.Acq_Deal_Sport_Code,'OB','A') Obligation_Broadcast_Names,
		CASE AADS.Deferred_Live  WHEN 'DF' THEN 'Defined' WHEN 'UL' THEN 'Unlimited' ELSE 'NA' END Deferred_Live
		,AADS.Deferred_Live_Duration,
		CASE AADS.Tape_Delayed  WHEN 'DF' THEN 'Defined' WHEN 'UL' THEN 'Unlimited' ELSE 'NA' END Tape_Delayed
		,AADS.Tape_Delayed_Duration,
		CASE WHEN AADS.Standalone_Transmission = 'Y' THEN 'Yes' ELSE 'No' END Standalone_Transmission,
		CASE WHEN AADS.Standalone_Substantial = 'Y' THEN 'Yes' ELSE 'No' END Standalone_Substantial,
		[dbo].[UFN_Get_Sports_Platform](AADS.Acq_Deal_Sport_Code,'ST','A') Standalone_Digital_Platform,
		CASE WHEN AADS.Simulcast_Transmission = 'Y' THEN 'Yes' ELSE 'No' END Simulcast_Transmission,
		CASE WHEN AADS.Simulcast_Substantial = 'Y' THEN 'Yes' ELSE 'No' END Simulcast_Substantial,
		[dbo].[UFN_Get_Sports_Platform](AADS.Acq_Deal_Sport_Code,'SM','A') Simulcast_Digital_Platform,
		[dbo].[UFN_Get_Sport_Language](AADS.Acq_Deal_Sport_Code,'A') [LanguageNames],
		[dbo].[UFN_Get_Sport_Language](AADS.Acq_Deal_Sport_Code,'A') [LanguageGroupNames],AADS.[File_Name],
		AADS.Sys_File_Name,AADS.Remarks,AADS.MBO_Note,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM Acq_Deal_Sport AADS  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADS.Acq_Deal_Code = AAD.Acq_Deal_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempSportsHistory)
		ORDER BY AADS.Acq_Deal_Sport_Code ASC, AAD.Version ASC

		Declare @AT_Acq_Deal_Sport_Code int, @Acq_Deal_Sport_Code int
		Declare CUR_Sports Cursor For Select AT_Acq_Deal_Sport_Code,Version,VersionOld,Acq_Deal_Sport_Code,[Index] From #TempSportsHistory
			Open CUR_Sports
			Fetch Next From CUR_Sports InTo @AT_Acq_Deal_Sport_Code,@Version,@VersionOld,@Acq_Deal_Sport_Code, @temp
			While (@@FETCH_STATUS = 0)
			Begin
			
				IF(@AT_Acq_Deal_Sport_Code > 0)
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t (NOLOCK) 
						Inner Join AT_Acq_Deal_Sport_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

					UPDATE #TempSportsHistory
					SET [Title_Name] = @Title_Names
					WHERE AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
				END
				ELSE
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join Acq_Deal_Sport_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						UPDATE #TempSportsHistory
						SET [Title_Name] = @Title_Names
						WHERE AT_Acq_Deal_Sport_Code = 0 AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
				END

				SET @ISChange = ''
				SET @ISChange_V1 = 0
			
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempSportsHistory WHERE Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Content_Delivery,'')  != isnull(b.Content_Delivery,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Content_Delivery_Broadcast_Names,'')  != isnull(b.Content_Delivery_Broadcast_Names,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Deferred_Live,'')  !=  ISNULL(b.Deferred_Live,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Deferred_Live_Duration,'')  != ISNULL(b.Deferred_Live_Duration,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.[File_Name],'')  != isnull(b.[File_Name],'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '22,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.LanguageGroupNames,'')  != isnull(b.LanguageGroupNames,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '20,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.LanguageNames,'')  != isnull(b.LanguageNames,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '21,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Obligation_Broadcast,'')  != isnull(b.Obligation_Broadcast,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Obligation_Broadcast_Names,'')  != isnull(b.Obligation_Broadcast_Names,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Remarks,'')  != isnull(b.Remarks,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '24,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Simulcast_Digital_Platform,'')  != isnull(b.Simulcast_Digital_Platform,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '19,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Simulcast_Substantial,'')  != isnull(b.Simulcast_Substantial,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '18,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Simulcast_Transmission,'')  != isnull(b.Simulcast_Transmission,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '17,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Standalone_Digital_Platform,'')  != isnull(b.Standalone_Digital_Platform,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '16,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Standalone_Substantial,'')  != isnull(b.Standalone_Substantial,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '15,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Standalone_Transmission,'')  != isnull(b.Standalone_Transmission,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '14,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					select @ISChange =  case when ISNULL(a.Sys_File_Name,'')  != isnull(b.Sys_File_Name,'') then 'Y' else @ISChange end
					from #TempSportsHistory a 
					left join #TempSportsHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code AND a.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code and b.Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '23,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END
				
					if(@ISChange_V1 > 0)
					BEGIN
						UPDATE #TempSportsHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempSportsHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
				END
				Fetch Next From CUR_Sports InTo @AT_Acq_Deal_Sport_Code,@Version,@VersionOld,@Acq_Deal_Sport_Code, @temp
			END
			Close CUR_Sports
			Deallocate CUR_Sports
			Select * from #TempSportsHistory
			drop table #TempSportsHistory
	END

	-- Code end for Deal Sport

	-- Code start for deal sport ancillary program

	IF(@TabName = 'SPORTANCPRO')
	BEGIN

		CREATE TABLE #TempSportsAncProHistory
		(
			AT_Acq_Deal_Sport_Ancillary_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Sport_Ancillary_Code int,
			Title_Name NVARCHAR(MAX),
			[Type] NVARCHAR(MAX),
			Obligation_Broadcast CHAR(3),
			When_To_Broadcast_Names NVARCHAR(MAX),
			Broadcast_Window int,
			Broadcast_Periodicity NVARCHAR(500),
			Periodicity NVARCHAR(500),
			Duration time(7),
			[Source] NVARCHAR(MAX),
			Remarks NVARCHAR(4000),
			[Status] VARCHAR(20),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempSportsAncProHistory
		(
			AT_Acq_Deal_Sport_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Ancillary_Code ,
			[Type] ,
			Obligation_Broadcast,
			When_To_Broadcast_Names,
			Broadcast_Window ,
			Broadcast_Periodicity ,
			Periodicity,
			Duration ,
			[Source] ,
			Remarks ,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADSA.AT_Acq_Deal_Sport_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Ancillary_Code,ISNULL(SAT.Name,'') [Type],
		CASE WHEN AADSA.Obligation_Broadcast = 'Y' THEN 'Yes' ELSE 'No' END Obligation_Broadcast,
		dbo.UFN_Get_Sport_Ancillary_Broadcast(AADSA.AT_Acq_Deal_Sport_Ancillary_Code,'AT') When_To_Broadcast_Names, 
		AADSA.Broadcast_Window,ISNULL(SAP.Name,'') Broadcast_Periodicity,ISNULL(SAP1.Name,'') Periodicity,AADSA.Duration,
		dbo.UFN_Get_Sport_Ancillary_Source(AADSA.AT_Acq_Deal_Sport_Ancillary_Code,'AT') [Source] ,AADSA.Remarks,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Sport_Ancillary AADSA  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADSA.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		LEFT JOIN Sport_Ancillary_Type SAT (NOLOCK) ON AADSA.Sport_Ancillary_Type_Code = SAT.Sport_Ancillary_Type_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP (NOLOCK) ON AADSA.Broadcast_Periodicity_Code = SAP.Sport_Ancillary_Periodicity_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP1 (NOLOCK) ON AADSA.Sport_Ancillary_Periodicity_Code = SAP1.Sport_Ancillary_Periodicity_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code AND AADSA.Ancillary_For = 'P'
		ORDER BY AADSA.Acq_Deal_Sport_Ancillary_Code ASC, AAD.Version ASC

		INSERT INTO #TempSportsAncProHistory
		(
			AT_Acq_Deal_Sport_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Ancillary_Code ,
			[Type] ,
			Obligation_Broadcast,
			When_To_Broadcast_Names,
			Broadcast_Window ,
			Broadcast_Periodicity ,
			Periodicity,
			Duration ,
			[Source] ,
			Remarks ,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By] 
		)
		Select 0 AT_Acq_Deal_Sport_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Ancillary_Code,ISNULL(SAT.Name,'') [Type]
		,CASE WHEN AADSA.Obligation_Broadcast = 'Y' THEN 'Yes' ELSE 'No' END Obligation_Broadcast,
		dbo.UFN_Get_Sport_Ancillary_Broadcast(AADSA.Acq_Deal_Sport_Ancillary_Code,'A') When_To_Broadcast_Names, 
		AADSA.Broadcast_Window,ISNULL(SAP.Name,'') Broadcast_Periodicity,ISNULL(SAP1.Name,'') Periodicity,AADSA.Duration,
		dbo.UFN_Get_Sport_Ancillary_Source(AADSA.Acq_Deal_Sport_Ancillary_Code,'A') [Source] ,AADSA.Remarks,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM Acq_Deal_Sport_Ancillary AADSA  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADSA.Acq_Deal_Code = AAD.Acq_Deal_Code
		LEFT JOIN Sport_Ancillary_Type SAT (NOLOCK) ON AADSA.Sport_Ancillary_Type_Code = SAT.Sport_Ancillary_Type_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP (NOLOCK) ON AADSA.Broadcast_Periodicity_Code = SAP.Sport_Ancillary_Periodicity_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP1 (NOLOCK) ON AADSA.Sport_Ancillary_Periodicity_Code = SAP1.Sport_Ancillary_Periodicity_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempSportsAncProHistory) AND AADSA.Ancillary_For = 'P'
		ORDER BY AADSA.Acq_Deal_Sport_Ancillary_Code ASC, AAD.Version ASC

		Declare @AT_Acq_Deal_Sport_Ancillary_Code int, @Acq_Deal_Sport_Ancillary_Code int
		Declare CUR_Sports_Anc_Pro Cursor For Select AT_Acq_Deal_Sport_Ancillary_Code,Version,VersionOld,Acq_Deal_Sport_Ancillary_Code,[Index] From #TempSportsAncProHistory
			Open CUR_Sports_Anc_Pro
			Fetch Next From CUR_Sports_Anc_Pro InTo @AT_Acq_Deal_Sport_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Ancillary_Code,@temp
			While (@@FETCH_STATUS = 0)
			Begin
			
				IF(@AT_Acq_Deal_Sport_Ancillary_Code > 0)
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join AT_Acq_Deal_Sport_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

					UPDATE #TempSportsAncProHistory
					SET [Title_Name] = @Title_Names
					WHERE AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
				END
				ELSE
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t (NOLOCK) 
						Inner Join Acq_Deal_Sport_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						UPDATE #TempSportsAncProHistory
						SET [Title_Name] = @Title_Names
						WHERE AT_Acq_Deal_Sport_Ancillary_Code = 0 AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
				END

				SET @ISChange = ''
				SET @ISChange_V1 = 0
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempSportsAncProHistory WHERE Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code

					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.[Type],'')  != isnull(b.[Type],'') then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Obligation_Broadcast,'')  != isnull(b.Obligation_Broadcast,'') then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.When_To_Broadcast_Names,'')  !=  ISNULL(b.When_To_Broadcast_Names,'') then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Broadcast_Window,'')  != ISNULL(b.Broadcast_Window,'') then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Broadcast_Periodicity,'')  != isnull(b.Broadcast_Periodicity,'') then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Periodicity,'')  != isnull(b.Periodicity,'') then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Duration != b.Duration then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '12,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.[Source],'')  != isnull(b.[Source],'') then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '13,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Remarks,'')  != isnull(b.Remarks,'') then 'Y' else @ISChange end
					from #TempSportsAncProHistory a 
					left join #TempSportsAncProHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncProHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '14,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					if(@ISChange_V1 > 0)
					BEGIN
						UPDATE #TempSportsAncProHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempSportsAncProHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
				END
				Fetch Next From CUR_Sports_Anc_Pro InTo @AT_Acq_Deal_Sport_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Ancillary_Code, @temp
			END
			Close CUR_Sports_Anc_Pro
			Deallocate CUR_Sports_Anc_Pro
			Select * from #TempSportsAncProHistory
			DROP TABLE #TempSportsAncProHistory
	END

	-- Code end for deal sport ancillary program

	-- code start for deal sport ancillary marketing

	IF(@TabName = 'SPORTANCMRKT')
	BEGIN

		CREATE TABLE #TempSportsAncMrktHistory
		(
			AT_Acq_Deal_Sport_Ancillary_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Sport_Ancillary_Code int,
			Title_Name NVARCHAR(MAX),
			[Type] NVARCHAR(MAX),
			Obligation_Broadcast CHAR(3),
			When_To_Broadcast_Names NVARCHAR(MAX),
			Broadcast_Window int,
			Broadcast_Periodicity NVARCHAR(500),
			Periodicity NVARCHAR(500),
			Duration time(7),
			No_Of_Promos int,
			Prime_Start_Time time(7),
			Prime_End_Time time(7),
			Prime_Durartion time(7),
			Prime_No_of_Promos int,
			Off_Prime_Start_Time time(7),
			Off_Prime_End_Time time(7),
			Off_Prime_Durartion time(7),
			Off_Prime_No_of_Promos int,
			[Source] NVARCHAR(MAX),
			Remarks NVARCHAR(4000),
			[Status] NVARCHAR(20),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempSportsAncMrktHistory
		(
			AT_Acq_Deal_Sport_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Ancillary_Code ,
			[Type] ,
			Obligation_Broadcast,
			When_To_Broadcast_Names,
			Broadcast_Window ,
			Broadcast_Periodicity ,
			Periodicity,
			Duration ,
			No_Of_Promos ,
			Prime_Start_Time ,
			Prime_End_Time ,
			Prime_Durartion ,
			Prime_No_of_Promos ,
			Off_Prime_Start_Time ,
			Off_Prime_End_Time ,
			Off_Prime_Durartion ,
			Off_Prime_No_of_Promos,
			[Source] ,
			Remarks ,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADSA.AT_Acq_Deal_Sport_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Ancillary_Code,ISNULL(SAT.Name,'') [Type],
		CASE WHEN ISNULL(AADSA.Obligation_Broadcast,'') ='Y' THEN 'Yes' ELSE 'No' END Obligation_Broadcast,
		dbo.UFN_Get_Sport_Ancillary_Broadcast(AADSA.AT_Acq_Deal_Sport_Ancillary_Code,'AT') When_To_Broadcast_Names, 
		AADSA.Broadcast_Window,ISNULL(SAP.Name,'') Broadcast_Periodicity,ISNULL(SAP1.Name,'') Periodicity,AADSA.Duration,
		AADSA.No_Of_Promos,AADSA.Prime_Start_Time,AADSA.Prime_End_Time,AADSA.Prime_Durartion,AADSA.Prime_No_of_Promos,
		AADSA.Off_Prime_Start_Time,AADSA.Off_Prime_End_Time,AADSA.Off_Prime_Durartion,AADSA.Off_Prime_No_of_Promos,
		dbo.UFN_Get_Sport_Ancillary_Source(AADSA.AT_Acq_Deal_Sport_Ancillary_Code,'AT') [Source] ,ISNULL(AADSA.Remarks,'') Remarks,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Sport_Ancillary AADSA  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADSA.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		LEFT JOIN Sport_Ancillary_Type SAT (NOLOCK) ON AADSA.Sport_Ancillary_Type_Code = SAT.Sport_Ancillary_Type_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP (NOLOCK) ON AADSA.Broadcast_Periodicity_Code = SAP.Sport_Ancillary_Periodicity_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP1 (NOLOCK) ON AADSA.Sport_Ancillary_Periodicity_Code = SAP1.Sport_Ancillary_Periodicity_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code AND AADSA.Ancillary_For = 'M'
		ORDER BY AADSA.Acq_Deal_Sport_Ancillary_Code ASC, AAD.Version ASC

		INSERT INTO #TempSportsAncMrktHistory
		(
			AT_Acq_Deal_Sport_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Ancillary_Code ,
			[Type] ,
			Obligation_Broadcast,
			When_To_Broadcast_Names,
			Broadcast_Window ,
			Broadcast_Periodicity ,
			Periodicity,
			Duration ,
			No_Of_Promos ,
			Prime_Start_Time ,
			Prime_End_Time ,
			Prime_Durartion ,
			Prime_No_of_Promos ,
			Off_Prime_Start_Time ,
			Off_Prime_End_Time ,
			Off_Prime_Durartion ,
			Off_Prime_No_of_Promos,
			[Source] ,
			Remarks ,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select 0 AT_Acq_Deal_Sport_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Ancillary_Code,ISNULL(SAT.Name,'') [Type],
		CASE WHEN ISNULL(AADSA.Obligation_Broadcast,'') ='Y' THEN 'Yes' ELSE 'No' END Obligation_Broadcast,
		dbo.UFN_Get_Sport_Ancillary_Broadcast(AADSA.Acq_Deal_Sport_Ancillary_Code,'A') When_To_Broadcast_Names, 
		AADSA.Broadcast_Window,ISNULL(SAP.Name,'') Broadcast_Periodicity,ISNULL(SAP1.Name,'') Periodicity,AADSA.Duration,
		AADSA.No_Of_Promos,AADSA.Prime_Start_Time,AADSA.Prime_End_Time,AADSA.Prime_Durartion,AADSA.Prime_No_of_Promos,
		AADSA.Off_Prime_Start_Time,AADSA.Off_Prime_End_Time,AADSA.Off_Prime_Durartion,AADSA.Off_Prime_No_of_Promos,
		dbo.UFN_Get_Sport_Ancillary_Source(AADSA.Acq_Deal_Sport_Ancillary_Code,'A') [Source] ,AADSA.Remarks,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name

		FROM Acq_Deal_Sport_Ancillary AADSA  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADSA.Acq_Deal_Code = AAD.Acq_Deal_Code
		LEFT JOIN Sport_Ancillary_Type SAT (NOLOCK) ON AADSA.Sport_Ancillary_Type_Code = SAT.Sport_Ancillary_Type_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP (NOLOCK) ON AADSA.Broadcast_Periodicity_Code = SAP.Sport_Ancillary_Periodicity_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP1 (NOLOCK) ON AADSA.Sport_Ancillary_Periodicity_Code = SAP1.Sport_Ancillary_Periodicity_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempSportsAncMrktHistory) AND AADSA.Ancillary_For = 'M'
		ORDER BY AADSA.Acq_Deal_Sport_Ancillary_Code ASC, AAD.Version ASC

		Declare CUR_Sports_Anc_Mrkt Cursor For Select AT_Acq_Deal_Sport_Ancillary_Code,Version,VersionOld,Acq_Deal_Sport_Ancillary_Code, [Index] From #TempSportsAncMrktHistory
			Open CUR_Sports_Anc_Mrkt
			Fetch Next From CUR_Sports_Anc_Mrkt InTo @AT_Acq_Deal_Sport_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Ancillary_Code, @temp
			While (@@FETCH_STATUS = 0)
			Begin
			
				IF(@AT_Acq_Deal_Sport_Ancillary_Code > 0)
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join AT_Acq_Deal_Sport_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

					UPDATE #TempSportsAncMrktHistory
					SET [Title_Name] = @Title_Names
					WHERE AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
				END
				ELSE
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join Acq_Deal_Sport_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						UPDATE #TempSportsAncMrktHistory
						SET [Title_Name] = @Title_Names
						WHERE AT_Acq_Deal_Sport_Ancillary_Code = 0 AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
				END

				SET @ISChange = ''
				SET @ISChange_V1 = 0
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempSportsAncMrktHistory WHERE Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code

					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.[Type],'')  != isnull(b.[Type],'') then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'

					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Obligation_Broadcast,'')  != isnull(b.Obligation_Broadcast,'') then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.When_To_Broadcast_Names,'')  !=  ISNULL(b.When_To_Broadcast_Names,'') then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Broadcast_Window,'')  != ISNULL(b.Broadcast_Window,'') then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Broadcast_Periodicity,'')  != isnull(b.Broadcast_Periodicity,'') then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Periodicity,'')  != isnull(b.Periodicity,'') then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Duration != b.Duration then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '12,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.No_Of_Promos != b.No_Of_Promos then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '13,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Prime_Start_Time != b.Prime_Start_Time then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '14,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Prime_End_Time != b.Prime_End_Time then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '15,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Prime_Durartion != b.Prime_Durartion then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '16,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Prime_No_of_Promos != b.Prime_No_of_Promos then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '17,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Off_Prime_Start_Time != b.Off_Prime_Start_Time then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '18,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Off_Prime_End_Time != b.Off_Prime_End_Time then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '19,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Off_Prime_Durartion != b.Off_Prime_Durartion then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '20,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Off_Prime_No_of_Promos != b.Off_Prime_No_of_Promos then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '21,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.[Source],'')  != isnull(b.[Source],'') then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '22,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Remarks,'')  != isnull(b.Remarks,'') then 'Y' else @ISChange end
					from #TempSportsAncMrktHistory a 
					left join #TempSportsAncMrktHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMrktHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '23,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					if(@ISChange_V1 > 0)
					BEGIN
						UPDATE #TempSportsAncMrktHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempSportsAncMrktHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
				END
				Fetch Next From CUR_Sports_Anc_Mrkt InTo @AT_Acq_Deal_Sport_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Ancillary_Code, @temp
			END
			Close CUR_Sports_Anc_Mrkt
			Deallocate CUR_Sports_Anc_Mrkt
			Select * from #TempSportsAncMrktHistory
			DROP TABLE #TempSportsAncMrktHistory
	END

	-- code end for deal sport ancillary marketing

	--Code Start for Sport Ancillary FCT

	IF(@TabName = 'SPORTANCFCT')
	BEGIN

		CREATE TABLE #TempSportsAncFTCHistory
		(
			AT_Acq_Deal_Sport_Ancillary_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Sport_Ancillary_Code int,
			Title_Name NVARCHAR(MAX),
			[Type] NVARCHAR(MAX),
			When_To_Broadcast_Names NVARCHAR(MAX),
			Duration time(7),
			[Source] NVARCHAR(MAX),
			[Status] VARCHAR(20),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempSportsAncFTCHistory
		(
			AT_Acq_Deal_Sport_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Ancillary_Code ,
			[Type] ,
			When_To_Broadcast_Names,
			Duration ,
			[Source] ,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADSA.AT_Acq_Deal_Sport_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Ancillary_Code,ISNULL(SAT.Name,'') [Type],
		dbo.UFN_Get_Sport_Ancillary_Broadcast(AADSA.AT_Acq_Deal_Sport_Ancillary_Code,'AT') When_To_Broadcast_Names, 
		AADSA.Duration,
		dbo.UFN_Get_Sport_Ancillary_Source(AADSA.AT_Acq_Deal_Sport_Ancillary_Code,'AT') [Source] ,'UnChanged' [Status]	,cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Sport_Ancillary AADSA  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADSA.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		LEFT JOIN Sport_Ancillary_Type SAT (NOLOCK) ON AADSA.Sport_Ancillary_Type_Code = SAT.Sport_Ancillary_Type_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP (NOLOCK) ON AADSA.Broadcast_Periodicity_Code = SAP.Sport_Ancillary_Periodicity_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP1 (NOLOCK) ON AADSA.Sport_Ancillary_Periodicity_Code = SAP1.Sport_Ancillary_Periodicity_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code AND AADSA.Ancillary_For = 'F'
		ORDER BY AADSA.Acq_Deal_Sport_Ancillary_Code ASC, AAD.Version ASC

		INSERT INTO #TempSportsAncFTCHistory
		(
			AT_Acq_Deal_Sport_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Ancillary_Code ,
			[Type] ,
			When_To_Broadcast_Names,
			Duration ,
			[Source] ,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select 0 AT_Acq_Deal_Sport_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Ancillary_Code,ISNULL(SAT.Name,'') [Type],
		dbo.UFN_Get_Sport_Ancillary_Broadcast(AADSA.Acq_Deal_Sport_Ancillary_Code,'A') When_To_Broadcast_Names, 
		AADSA.Duration,
		dbo.UFN_Get_Sport_Ancillary_Source(AADSA.Acq_Deal_Sport_Ancillary_Code,'A') [Source] ,'UnChanged' [Status]	,cast(AAD.Version as decimal), '',USR.Login_Name
		FROM Acq_Deal_Sport_Ancillary AADSA  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADSA.Acq_Deal_Code = AAD.Acq_Deal_Code
		LEFT JOIN Sport_Ancillary_Type SAT (NOLOCK) ON AADSA.Sport_Ancillary_Type_Code = SAT.Sport_Ancillary_Type_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP (NOLOCK) ON AADSA.Broadcast_Periodicity_Code = SAP.Sport_Ancillary_Periodicity_Code
		LEFT JOIN Sport_Ancillary_Periodicity SAP1 (NOLOCK) ON AADSA.Sport_Ancillary_Periodicity_Code = SAP1.Sport_Ancillary_Periodicity_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempSportsAncFTCHistory) AND AADSA.Ancillary_For = 'F'
		ORDER BY AADSA.Acq_Deal_Sport_Ancillary_Code ASC, AAD.Version ASC


		Declare CUR_Sports_Anc_FCT Cursor For Select AT_Acq_Deal_Sport_Ancillary_Code,Version,VersionOld,Acq_Deal_Sport_Ancillary_Code,[Index] From #TempSportsAncFTCHistory
			Open CUR_Sports_Anc_FCT
			Fetch Next From CUR_Sports_Anc_FCT InTo @AT_Acq_Deal_Sport_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Ancillary_Code, @temp
			While (@@FETCH_STATUS = 0)
			Begin
			
				IF(@AT_Acq_Deal_Sport_Ancillary_Code > 0)
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join AT_Acq_Deal_Sport_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

					UPDATE #TempSportsAncFTCHistory
					SET [Title_Name] = @Title_Names
					WHERE AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
				END
				ELSE
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join Acq_Deal_Sport_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						UPDATE #TempSportsAncFTCHistory
						SET [Title_Name] = @Title_Names
						WHERE AT_Acq_Deal_Sport_Ancillary_Code = 0 AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
				END

				SET @ISChange = ''
				SET @ISChange_V1 = 0 
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempSportsAncFTCHistory WHERE Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempSportsAncFTCHistory a 
					left join #TempSportsAncFTCHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code

					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncFTCHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.[Type],'')  != isnull(b.[Type],'') then 'Y' else @ISChange end
					from #TempSportsAncFTCHistory a 
					left join #TempSportsAncFTCHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncFTCHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.When_To_Broadcast_Names,'')  !=  ISNULL(b.When_To_Broadcast_Names,'') then 'Y' else @ISChange end
					from #TempSportsAncFTCHistory a 
					left join #TempSportsAncFTCHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncFTCHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when a.Duration != b.Duration then 'Y' else @ISChange end
					from #TempSportsAncFTCHistory a 
					left join #TempSportsAncFTCHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncFTCHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.[Source],'')  != isnull(b.[Source],'') then 'Y' else @ISChange end
					from #TempSportsAncFTCHistory a 
					left join #TempSportsAncFTCHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code AND a.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code and b.Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncFTCHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
						AND Acq_Deal_Sport_Ancillary_Code = @Acq_Deal_Sport_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					if(@ISChange_V1 > 0)
					BEGIN
						UPDATE #TempSportsAncFTCHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempSportsAncFTCHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Sport_Ancillary_Code = @AT_Acq_Deal_Sport_Ancillary_Code
				END
				Fetch Next From CUR_Sports_Anc_FCT InTo @AT_Acq_Deal_Sport_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Ancillary_Code, @temp
			END
			Close CUR_Sports_Anc_FCT
			Deallocate CUR_Sports_Anc_FCT
			Select * from #TempSportsAncFTCHistory

	END

	--Code End for Sport Ancillary FCT

	-- Code Start for Sport Ancillary Sales

	IF(@TabName = 'SPORTANCSALES')
	BEGIN

		CREATE TABLE #TempSportsAncSalesHistory
		(
			AT_Acq_Deal_Sport_Sales_Ancillary_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Sport_Sales_Ancillary_Code int,
			Title_Name NVARCHAR(MAX),
			Title_Sponsor NVARCHAR(MAX),
			Official_Sponsor NVARCHAR(MAX),
			FRO_Given_Title_Sponsor CHAR,
			FRO_Given_Official_Sponsor CHAR,
			Title_FRO_No_Of_Days int,
			Title_FRO_Validity int,
			Official_FRO_No_Of_Days int,
			Official_FRO_Validity int,
			Price_Protection_Title_Sponsor CHAR,
			Price_Protection_Official_Sponsor CHAR,
			Last_Matching_Rights_Title_Sponsor CHAR,
			Last_Matching_Rights_Official_Sponsor CHAR,
			Title_Last_Matching_Rights_Validity int,
			Official_Last_Matching_Rights_Validity int,
			Remarks NVARCHAR(MAX),
			[Status] VARCHAR(20),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempSportsAncSalesHistory
		(
			AT_Acq_Deal_Sport_Sales_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Sales_Ancillary_Code ,
			FRO_Given_Title_Sponsor ,
			FRO_Given_Official_Sponsor ,
			Title_FRO_No_Of_Days ,
			Title_FRO_Validity ,
			Official_FRO_No_Of_Days,
			Official_FRO_Validity ,
			Price_Protection_Title_Sponsor ,
			Price_Protection_Official_Sponsor ,
			Last_Matching_Rights_Title_Sponsor ,
			Last_Matching_Rights_Official_Sponsor ,
			Title_Last_Matching_Rights_Validity ,
			Official_Last_Matching_Rights_Validity ,
			Remarks,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADSA.AT_Acq_Deal_Sport_Sales_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Sales_Ancillary_Code,AADSA.FRO_Given_Title_Sponsor,
		AADSA.FRO_Given_Official_Sponsor,AADSA.Title_FRO_No_Of_Days,AADSA.Title_FRO_Validity,AADSA.Official_FRO_No_Of_Days,
		AADSA.Official_FRO_Validity,AADSA.Price_Protection_Title_Sponsor,AADSA.Price_Protection_Official_Sponsor,
		AADSA.Last_Matching_Rights_Title_Sponsor,AADSA.Last_Matching_Rights_Official_Sponsor,AADSA.Title_Last_Matching_Rights_Validity,
		AADSA.Official_Last_Matching_Rights_Validity,AADSA.Remarks,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Sport_Sales_Ancillary AADSA  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADSA.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AADSA.Acq_Deal_Sport_Sales_Ancillary_Code ASC, AAD.Version ASC

		INSERT INTO #TempSportsAncSalesHistory
		(
			AT_Acq_Deal_Sport_Sales_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Sales_Ancillary_Code ,
			FRO_Given_Title_Sponsor ,
			FRO_Given_Official_Sponsor ,
			Title_FRO_No_Of_Days ,
			Title_FRO_Validity ,
			Official_FRO_No_Of_Days,
			Official_FRO_Validity ,
			Price_Protection_Title_Sponsor ,
			Price_Protection_Official_Sponsor ,
			Last_Matching_Rights_Title_Sponsor ,
			Last_Matching_Rights_Official_Sponsor ,
			Title_Last_Matching_Rights_Validity ,
			Official_Last_Matching_Rights_Validity ,
			Remarks,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select 0 AT_Acq_Deal_Sport_Sales_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Sales_Ancillary_Code,AADSA.FRO_Given_Title_Sponsor,
		AADSA.FRO_Given_Official_Sponsor,AADSA.Title_FRO_No_Of_Days,AADSA.Title_FRO_Validity,AADSA.Official_FRO_No_Of_Days,
		AADSA.Official_FRO_Validity,AADSA.Price_Protection_Title_Sponsor,AADSA.Price_Protection_Official_Sponsor,
		AADSA.Last_Matching_Rights_Title_Sponsor,AADSA.Last_Matching_Rights_Official_Sponsor,AADSA.Title_Last_Matching_Rights_Validity,
		AADSA.Official_Last_Matching_Rights_Validity,AADSA.Remarks,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM Acq_Deal_Sport_Sales_Ancillary AADSA  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADSA.Acq_Deal_Code = AAD.Acq_Deal_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempSportsAncSalesHistory)
		ORDER BY AADSA.Acq_Deal_Sport_Sales_Ancillary_Code ASC, AAD.Version ASC

		Declare @AT_Acq_Deal_Sport_Sales_Ancillary_Code int, @Acq_Deal_Sport_Sales_Ancillary_Code int,@Title_Sponsor VARCHAR(MAX),@Official_Sponsor VARCHAR(MAX)
		Declare CUR_Sports_Anc_Sales Cursor For Select AT_Acq_Deal_Sport_Sales_Ancillary_Code,Version,VersionOld,Acq_Deal_Sport_Sales_Ancillary_Code, [Index] From #TempSportsAncSalesHistory
			Open CUR_Sports_Anc_Sales
			Fetch Next From CUR_Sports_Anc_Sales InTo @AT_Acq_Deal_Sport_Sales_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Sales_Ancillary_Code, @temp
			While (@@FETCH_STATUS = 0)
			Begin
			
				IF(@AT_Acq_Deal_Sport_Sales_Ancillary_Code > 0)
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join AT_Acq_Deal_Sport_Sales_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						Set @Title_Sponsor = ''
						Select @Title_Sponsor = @Title_Sponsor + Sponsor_Name + ', ' 
						From Sponsor s  (NOLOCK)
						Inner Join AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor adrt (NOLOCK) On s.Sponsor_Code = adrt.Sponsor_Code 
						WHERE adrt.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND adrt.Sponsor_Type = 'T'
						Order by s.Sponsor_Name

						SET @Title_Sponsor = Substring(@Title_Sponsor, 0, Len(@Title_Sponsor))

						Set @Official_Sponsor = ''
						Select @Official_Sponsor = @Official_Sponsor + Sponsor_Name + ', ' 
						From Sponsor s  (NOLOCK)
						Inner Join AT_Acq_Deal_Sport_Sales_Ancillary_Sponsor adrt (NOLOCK) On s.Sponsor_Code = adrt.Sponsor_Code 
						WHERE adrt.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND adrt.Sponsor_Type = 'O'
						Order by s.Sponsor_Name

						SET @Official_Sponsor = Substring(@Official_Sponsor, 0, Len(@Official_Sponsor))

					UPDATE #TempSportsAncSalesHistory
					SET [Title_Name] = @Title_Names,
					Title_Sponsor = @Title_Sponsor,
						Official_Sponsor = @Official_Sponsor
					WHERE AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
				END
				ELSE
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join Acq_Deal_Sport_Sales_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						Set @Title_Sponsor = ''
						Select @Title_Sponsor = @Title_Sponsor + Sponsor_Name + ', ' 
						From Sponsor s  (NOLOCK)
						Inner Join Acq_Deal_Sport_Sales_Ancillary_Sponsor adrt (NOLOCK) On s.Sponsor_Code = adrt.Sponsor_Code 
						WHERE adrt.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND adrt.Sponsor_Type = 'T'
						Order by s.Sponsor_Name

						SET @Title_Sponsor = Substring(@Title_Sponsor, 0, Len(@Title_Sponsor))

						Set @Official_Sponsor = ''
						Select @Official_Sponsor = @Official_Sponsor + Sponsor_Name + ', ' 
						From Sponsor s  (NOLOCK)
						Inner Join Acq_Deal_Sport_Sales_Ancillary_Sponsor adrt (NOLOCK) On s.Sponsor_Code = adrt.Sponsor_Code 
						WHERE adrt.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND adrt.Sponsor_Type = 'O'
						Order by s.Sponsor_Name

						SET @Official_Sponsor = Substring(@Official_Sponsor, 0, Len(@Official_Sponsor))

						UPDATE #TempSportsAncSalesHistory
						SET [Title_Name] = @Title_Names,
						Title_Sponsor = @Title_Sponsor,
						Official_Sponsor = @Official_Sponsor
						WHERE AT_Acq_Deal_Sport_Sales_Ancillary_Code = 0 AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
				END

				SET @ISChange = ''
				SET @ISChange_V1 = 0
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempSportsAncSalesHistory WHERE Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code

					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Title_Sponsor,'')  != isnull(b.Title_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Official_Sponsor,'')  !=  ISNULL(b.Official_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.FRO_Given_Title_Sponsor,'') != ISNULL(b.FRO_Given_Title_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.FRO_Given_Official_Sponsor,'')  != isnull(b.FRO_Given_Official_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Title_FRO_No_Of_Days,'')  != isnull(b.Title_FRO_No_Of_Days,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Title_FRO_Validity,'')  != isnull(b.Title_FRO_Validity,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Official_FRO_No_Of_Days,'')  != isnull(b.Official_FRO_No_Of_Days,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '12,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Official_FRO_Validity,'')  != isnull(b.Official_FRO_Validity,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '13,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Price_Protection_Title_Sponsor,'')  != isnull(b.Price_Protection_Title_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '14,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Price_Protection_Official_Sponsor,'')  != isnull(b.Price_Protection_Official_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '15,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Last_Matching_Rights_Title_Sponsor,'')  != isnull(b.Last_Matching_Rights_Title_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '16,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Last_Matching_Rights_Official_Sponsor,'')  != isnull(b.Last_Matching_Rights_Official_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '17,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Title_Last_Matching_Rights_Validity,'')  != isnull(b.Title_Last_Matching_Rights_Validity,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '18,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Official_Last_Matching_Rights_Validity,'')  != isnull(b.Official_Last_Matching_Rights_Validity,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '19,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Remarks,'')  != isnull(b.Remarks,'') then 'Y' else @ISChange end
					from #TempSportsAncSalesHistory a 
					left join #TempSportsAncSalesHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code AND a.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code and b.Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
							update #TempSportsAncSalesHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '20,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
						AND Acq_Deal_Sport_Sales_Ancillary_Code = @Acq_Deal_Sport_Sales_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					if(@ISChange_V1 > 0)
					BEGIN
						UPDATE #TempSportsAncSalesHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempSportsAncSalesHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Sport_Sales_Ancillary_Code = @AT_Acq_Deal_Sport_Sales_Ancillary_Code
				END
				Fetch Next From CUR_Sports_Anc_Sales InTo @AT_Acq_Deal_Sport_Sales_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Sales_Ancillary_Code, @temp
			END
			Close CUR_Sports_Anc_Sales
			Deallocate CUR_Sports_Anc_Sales
			Select * from #TempSportsAncSalesHistory
			DROP TABLE #TempSportsAncSalesHistory
	END

	-- Code End for Sport Ancillary Sales

	-- Code Start for Sport Ancillary Monetisation

	IF(@TabName = 'SPORTANCMONE')
	BEGIN

		CREATE TABLE #TempSportsAncMoneHistory
		(
			AT_Acq_Deal_Sport_Monetisation_Ancillary_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Sport_Monetisation_Ancillary_Code int,
			Title_Name NVARCHAR(MAX),
			Appoint_Title_Sponsor NVARCHAR(3),
			Appoint_Broadcast_Sponsor NVARCHAR(3),
			Monetisation_Types NVARCHAR(MAX),
			Remarks NVARCHAR(MAX),
			[Status] NVARCHAR(20),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempSportsAncMoneHistory
		(
			AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Monetisation_Ancillary_Code ,
			Appoint_Title_Sponsor,
			Appoint_Broadcast_Sponsor,
			Remarks,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADSA.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Monetisation_Ancillary_Code,
		CASE WHEN AADSA.Appoint_Title_Sponsor ='Y' THEN 'Yes' ELSE 'No' END Appoint_Title_Sponsor,
		CASE WHEN AADSA.Appoint_Broadcast_Sponsor ='Y' THEN 'Yes' ELSE 'No' END Appoint_Broadcast_Sponsor
		,AADSA.Remarks,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Sport_Monetisation_Ancillary AADSA  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADSA.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AADSA.Acq_Deal_Sport_Monetisation_Ancillary_Code ASC, AAD.Version ASC

		INSERT INTO #TempSportsAncMoneHistory
		(
			AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Sport_Monetisation_Ancillary_Code ,
			Appoint_Title_Sponsor,
			Appoint_Broadcast_Sponsor,
			Remarks,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select 0 AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Sport_Monetisation_Ancillary_Code,
		CASE WHEN AADSA.Appoint_Title_Sponsor ='Y' THEN 'Yes' ELSE 'No' END Appoint_Title_Sponsor,
		CASE WHEN AADSA.Appoint_Broadcast_Sponsor ='Y' THEN 'Yes' ELSE 'No' END Appoint_Broadcast_Sponsor
		,AADSA.Remarks,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM Acq_Deal_Sport_Monetisation_Ancillary AADSA  (NOLOCK)
		INNER JOIN Acq_Deal AAD (NOLOCK) ON AADSA.Acq_Deal_Code = AAD.Acq_Deal_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere  AAD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempSportsAncMoneHistory)
		ORDER BY AADSA.Acq_Deal_Sport_Monetisation_Ancillary_Code ASC, AAD.Version ASC

		Declare @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code int, @Acq_Deal_Sport_Monetisation_Ancillary_Code int,@Monetisation_Type VARCHAR(MAX)
		Declare CUR_Sports_Anc_Mone Cursor For Select AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,Version,VersionOld,Acq_Deal_Sport_Monetisation_Ancillary_Code, [Index] From #TempSportsAncMoneHistory
			Open CUR_Sports_Anc_Mone
			Fetch Next From CUR_Sports_Anc_Mone InTo @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Monetisation_Ancillary_Code, @temp
			While (@@FETCH_STATUS = 0)
			Begin
			
				IF(@AT_Acq_Deal_Sport_Monetisation_Ancillary_Code > 0)
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join AT_Acq_Deal_Sport_Monetisation_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))
					
						Set @Monetisation_Type = ''
						Select @Monetisation_Type = @Monetisation_Type + s.Monetisation_Type_Name +':'+ Cast(adrt.Monetisation_Rights as VARCHAR(3)) + ', ' 
						From Monetisation_Type s  (NOLOCK)
						Inner Join AT_Acq_Deal_Sport_Monetisation_Ancillary_Type adrt On s.[Monetisation_Type_Code] = adrt.[Monetisation_Type_Code] 
						WHERE adrt.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
						Order by s.Monetisation_Type_Name

						SET @Monetisation_Type = Substring(@Monetisation_Type, 0, Len(@Monetisation_Type))

					UPDATE #TempSportsAncMoneHistory
					SET [Title_Name] = @Title_Names,
					Monetisation_Types = @Monetisation_Type
					WHERE AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
				END
				ELSE
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join Acq_Deal_Sport_Monetisation_Ancillary_Title adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

					
						Set @Monetisation_Type = ''
						Select @Monetisation_Type = @Monetisation_Type + s.Monetisation_Type_Name +':'+ Cast(adrt.Monetisation_Rights as VARCHAR(3)) + ', ' 
						From Monetisation_Type s  (NOLOCK)
						Inner Join Acq_Deal_Sport_Monetisation_Ancillary_Type adrt (NOLOCK) On s.[Monetisation_Type_Code] = adrt.[Monetisation_Type_Code] 
						WHERE adrt.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code
						Order by s.Monetisation_Type_Name

						SET @Monetisation_Type = Substring(@Monetisation_Type, 0, Len(@Monetisation_Type))

						UPDATE #TempSportsAncMoneHistory
						SET [Title_Name] = @Title_Names,
						Monetisation_Types = @Monetisation_Type
						WHERE AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = 0 AND Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code
				END

				SET @ISChange = ''
				SET @ISChange_V1 = 0
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempSportsAncMoneHistory WHERE Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempSportsAncMoneHistory a 
					left join #TempSportsAncMoneHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code AND a.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code and b.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code

					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMoneHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
						AND Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Appoint_Title_Sponsor,'')  != isnull(b.Appoint_Title_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncMoneHistory a 
					left join #TempSportsAncMoneHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code AND a.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code and b.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMoneHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
						AND Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Appoint_Broadcast_Sponsor,'')  !=  ISNULL(b.Appoint_Broadcast_Sponsor,'') then 'Y' else @ISChange end
					from #TempSportsAncMoneHistory a 
					left join #TempSportsAncMoneHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code AND a.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code and b.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMoneHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
						AND Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Monetisation_Types,'') != ISNULL(b.Monetisation_Types,'') then 'Y' else @ISChange end
					from #TempSportsAncMoneHistory a 
					left join #TempSportsAncMoneHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code AND a.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code and b.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMoneHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
						AND Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.Remarks,'')  != isnull(b.Remarks,'') then 'Y' else @ISChange end
					from #TempSportsAncMoneHistory a 
					left join #TempSportsAncMoneHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code AND a.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code and b.Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsAncMoneHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
						AND Acq_Deal_Sport_Monetisation_Ancillary_Code = @Acq_Deal_Sport_Monetisation_Ancillary_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					if(@ISChange_V1 > 0)
					BEGIN
						UPDATE #TempSportsAncMoneHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempSportsAncMoneHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Sport_Monetisation_Ancillary_Code = @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code
				END
				Fetch Next From CUR_Sports_Anc_Mone InTo @AT_Acq_Deal_Sport_Monetisation_Ancillary_Code,@Version,@VersionOld,@Acq_Deal_Sport_Monetisation_Ancillary_Code, @temp
			END
			Close CUR_Sports_Anc_Mone
			Deallocate CUR_Sports_Anc_Mone
			Select * from #TempSportsAncMoneHistory
			DROP TABLE #TempSportsAncMoneHistory
	END

	-- Code End for Sport Ancillary Monetisation

	-- Code Start for Deal Budget

	IF(@TabName = 'DEALBUDGET')
	BEGIN

		CREATE TABLE #TempBudgetHistory
		(
			AT_Acq_Deal_Budget_Code int,
			[Version] VARCHAR(50),
			[VersionOld] VARCHAR(50),
			Acq_Deal_Budget_Code int,
			Title_Name NVARCHAR(MAX),
			WBS_Code NVARCHAR(100),
			[Status] VARCHAR(20),
			[Index] int,
			ChangedColumnIndex varchar(MAX),
			[Inserted_By] VARCHAR(50)
		)

		INSERT INTO #TempBudgetHistory
		(
			AT_Acq_Deal_Budget_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Budget_Code ,
			WBS_Code,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADSA.AT_Acq_Deal_Budget_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Budget_Code,
		SW.WBS_Code,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Budget AADSA  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADSA.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		INNER JOIN SAP_WBS SW (NOLOCK) ON AADSA.SAP_WBS_Code = SW.SAP_WBS_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code
		ORDER BY AADSA.Acq_Deal_Budget_Code ASC, AAD.Version ASC

		INSERT INTO #TempBudgetHistory
		(
			AT_Acq_Deal_Budget_Code,
			[Version] ,
			[VersionOld] ,
			Acq_Deal_Budget_Code ,
			WBS_Code,
			[Status],
			[Index] ,
			ChangedColumnIndex,
			[Inserted_By]
		)
		Select AADSA.AT_Acq_Deal_Budget_Code,AAD.Version,
		RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,AADSA.Acq_Deal_Budget_Code,
		SW.WBS_Code,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name
		FROM AT_Acq_Deal_Budget AADSA  (NOLOCK)
		INNER JOIN AT_Acq_Deal AAD (NOLOCK) ON AADSA.AT_Acq_Deal_Code = AAD.AT_Acq_Deal_Code
		INNER JOIN SAP_WBS SW (NOLOCK) ON AADSA.SAP_WBS_Code = SW.SAP_WBS_Code
		INNER JOIN Users USR (NOLOCK) ON USR.Users_Code = CASE WHEN version = '0001' THEN 
					AAD.Inserted_By
				  ELSE
					AAD.Last_Action_By
		END
		WHere AAD.Acq_Deal_Code = @Acq_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempBudgetHistory)
		ORDER BY AADSA.Acq_Deal_Budget_Code ASC, AAD.Version ASC

		Declare @AT_Acq_Deal_Budget_Code int, @Acq_Deal_Budget_Code int
		Declare CUR_Budget Cursor For Select AT_Acq_Deal_Budget_Code,Version,VersionOld,Acq_Deal_Budget_Code, [Index] From #TempBudgetHistory
			Open CUR_Budget
			Fetch Next From CUR_Budget InTo @AT_Acq_Deal_Budget_Code,@Version,@VersionOld,@Acq_Deal_Budget_Code,@temp
			While (@@FETCH_STATUS = 0)
			Begin
			
				IF(@AT_Acq_Deal_Budget_Code > 0)
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join AT_Acq_Deal_Budget adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.AT_Acq_Deal_Budget_Code = @AT_Acq_Deal_Budget_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))
					
					
					UPDATE #TempBudgetHistory
					SET [Title_Name] = @Title_Names
					WHERE AT_Acq_Deal_Budget_Code = @AT_Acq_Deal_Budget_Code
				END
				ELSE
				BEGIN
				
					Set @Title_Names = ''
					Select @Title_Names = @Title_Names + Title_Name + ', ' From (
						Select Distinct 
						Case @Deal_Type_Condition
						When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) ' 
						When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) ' 
						Else t.Title_Name End As Title_Name
						From Title t  (NOLOCK)
						Inner Join Acq_Deal_Sport_Budget adrt (NOLOCK) On t.Title_Code = adrt.Title_Code 
						WHERE adrt.Acq_Deal_Budget_Code = @Acq_Deal_Budget_Code
						) as a
						ORDER BY a.Title_Name

						SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))

						UPDATE #TempBudgetHistory
						SET [Title_Name] = @Title_Names
						WHERE AT_Acq_Deal_Budget_Code = 0 AND Acq_Deal_Budget_Code = @Acq_Deal_Budget_Code
				END

				SET @ISChange = ''
				SET @ISChange_V1 = 0
				if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempBudgetHistory WHERE Acq_Deal_Budget_Code = @Acq_Deal_Budget_Code))
				BEGIN
				
					select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end
					from #TempBudgetHistory a 
					left join #TempBudgetHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Budget_Code = @AT_Acq_Deal_Budget_Code AND a.Acq_Deal_Budget_Code = @Acq_Deal_Budget_Code and b.Acq_Deal_Budget_Code = @Acq_Deal_Budget_Code

					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					select @ISChange =  case when ISNULL(a.WBS_Code,'')  != isnull(b.WBS_Code,'') then 'Y' else @ISChange end
					from #TempBudgetHistory a 
					left join #TempBudgetHistory b on a.Version = b.VersionOld
					where a.Version = @Version and a.AT_Acq_Deal_Budget_Code = @AT_Acq_Deal_Budget_Code AND a.Acq_Deal_Budget_Code = @Acq_Deal_Budget_Code and b.Acq_Deal_Budget_Code = @Acq_Deal_Budget_Code AND @ISChange <> 'Y'
				
					if(@ISChange = 'Y')
					BEGIN
						update #TempSportsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version
						and AT_Acq_Deal_Sport_Code = @AT_Acq_Deal_Sport_Code
						AND Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code
						set @ISChange = '' 
						SET @ISChange_V1 = @ISChange_V1 + 1 
					END

					if(@ISChange_V1 > 0)
					BEGIN
						UPDATE #TempBudgetHistory
						SET Status = 'Modified'
						WHERE AT_Acq_Deal_Budget_Code = @AT_Acq_Deal_Budget_Code
				
					END
				END
				ELSE
				BEGIN
						UPDATE #TempBudgetHistory
						SET Status = 'Added'
						WHERE AT_Acq_Deal_Budget_Code = @AT_Acq_Deal_Budget_Code
				END
				Fetch Next From CUR_Budget InTo @AT_Acq_Deal_Budget_Code,@Version,@VersionOld,@Acq_Deal_Budget_Code,@temp
			END
			Close CUR_Budget
			Deallocate CUR_Budget
			Select * from #TempBudgetHistory

		IF OBJECT_ID('tempdb..#TempAncillaryHistory') IS NOT NULL DROP TABLE #TempAncillaryHistory
		IF OBJECT_ID('tempdb..#TempAttachmentHistory') IS NOT NULL DROP TABLE #TempAttachmentHistory
		IF OBJECT_ID('tempdb..#TempBudgetHistory') IS NOT NULL DROP TABLE #TempBudgetHistory
		IF OBJECT_ID('tempdb..#TempDealHistory') IS NOT NULL DROP TABLE #TempDealHistory
		IF OBJECT_ID('tempdb..#TempMaterialHistory') IS NOT NULL DROP TABLE #TempMaterialHistory
		IF OBJECT_ID('tempdb..#TempMovieHistory') IS NOT NULL DROP TABLE #TempMovieHistory
		IF OBJECT_ID('tempdb..#TempPlatformHistory') IS NOT NULL DROP TABLE #TempPlatformHistory
		IF OBJECT_ID('tempdb..#TempPushbackHistory') IS NOT NULL DROP TABLE #TempPushbackHistory
		IF OBJECT_ID('tempdb..#TempRightsHistory') IS NOT NULL DROP TABLE #TempRightsHistory
		IF OBJECT_ID('tempdb..#TempSportsAncFTCHistory') IS NOT NULL DROP TABLE #TempSportsAncFTCHistory
		IF OBJECT_ID('tempdb..#TempSportsAncMoneHistory') IS NOT NULL DROP TABLE #TempSportsAncMoneHistory
		IF OBJECT_ID('tempdb..#TempSportsAncMrktHistory') IS NOT NULL DROP TABLE #TempSportsAncMrktHistory
		IF OBJECT_ID('tempdb..#TempSportsAncProHistory') IS NOT NULL DROP TABLE #TempSportsAncProHistory
		IF OBJECT_ID('tempdb..#TempSportsAncSalesHistory') IS NOT NULL DROP TABLE #TempSportsAncSalesHistory
		IF OBJECT_ID('tempdb..#TempSportsHistory') IS NOT NULL DROP TABLE #TempSportsHistory

	END
	-- Code End for Deal Budget
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Version_History]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END