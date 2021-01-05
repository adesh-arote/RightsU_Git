
CREATE PROCEDURE [dbo].[USP_Get_Version_History_Syn]  
 @Syn_Deal_Code int  
 ,@Business_Unit_Code int  
 ,@TabName Varchar(100)  
AS  
-- =============================================  
-- Author:  Rajesh Godse  
-- Create date: 9-Sept-2015  
-- Description: Get version difference based on deal code  
-- =============================================  
/*  
SELECT * FROM Syn_Deal WHERE Agreement_No like 'S-2015-00122'  
EXEC [dbo].[USP_Get_Version_History_Syn]  1288,1,'DEALRIGHTS'   
*/  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  

 --DECLARE
	--	@Syn_Deal_Code int = 3710
	--	,@Business_Unit_Code int = 1
	--	,@TabName Varchar(100) = 'GENERAL'
  
 DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''  
 Select @Selected_Deal_Type_Code = Deal_Type_Code From Acq_Deal Where Acq_Deal_Code = @Syn_Deal_Code  
 SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)  
  
-------------------------------------------------------------GENERAL TAB------------------------------------------------------------------------------------  
/*  
EXEC [dbo].[USP_Get_Version_History_Syn]  3142,1,'GENERAL'   
select * from syn_deal where Agreement_No='S-2015-00109'  
*/  
 IF(@TabName = 'GENERAL')  
 BEGIN  
    
  --drop table #TempDealHistory  
  CREATE TABLE #TempDealHistory  
  (  
   AT_Syn_Deal_Code int,  
   Syn_Deal_Code int,  
   Agreement_No NVARCHAR(50),  
   [Version] VARCHAR(50),  
   [VersionOld] VARCHAR(50),  
   Deal_Description NVARCHAR(500),  
   Deal_Type_Name NVARCHAR(100),  
   [Entity_Name] NVARCHAR(100),  
   Exchange_Rate NVARCHAR(50),  
   Category_Name NVARCHAR(100),  
   Vendor_Name NVARCHAR(1000),  
   Contact_Name NVARCHAR(100),  
   Currency_Name NVARCHAR(100),  
   Role_Name NVARCHAR(100),  
   --Channel_Cluster_Name NVARCHAR(200),  
   [Index] int,  
   ChangedColumnIndex varchar(MAX),  
   [Inserted_By] VARCHAR(50),
   Deal_Segment NVARCHAR(max)  ,
   Revenue_Vertical NVARCHAR(max)  
  )  
  
  INSERT INTO #TempDealHistory(AT_Syn_Deal_Code,Syn_Deal_Code,Agreement_No,Version,VersionOld,Deal_Description,Deal_Type_Name,[Entity_Name],Exchange_Rate,Category_Name,Vendor_Name, Contact_Name,Currency_Name,[Index],ChangedColumnIndex,Inserted_By,Deal_Segment, Revenue_Vertical )  
  SELECT AAD.AT_Syn_Deal_Code,AAD.Syn_Deal_Code,AAD.Agreement_No,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4),AAD.Deal_Description,DT.Deal_Type_Name,E.[Entity_Name],AAD.Exchange_Rate,C.Category_Name,V.Vendor_Name, VC.Contact_Name,CR.Currency_Name,
 cast(AAD.Version as decimal),'',USR.Login_Name, DS.Deal_Segment_Name, RV.Revenue_Vertical_Name
  FROM AT_Syn_Deal AAD  
  INNER JOIN Deal_Type DT ON AAD.Deal_Type_Code = DT.Deal_Type_Code  
  INNER JOIN Entity E ON AAD.Entity_Code = E.Entity_Code  
  INNER JOIN Category C ON AAD.Category_Code = C.Category_Code  
  INNER JOIN Vendor V ON AAD.Vendor_Code = V.Vendor_Code  
  LEFT OUTER JOIN Vendor_Contacts VC ON AAD.Vendor_Contact_Code = VC.Vendor_Contacts_Code  
  INNER JOIN Currency CR ON AAD.Currency_Code = CR.Currency_Code  
  INNER JOIN Syn_Deal AD ON AD.Syn_Deal_Code = AAD.Syn_Deal_Code
  LEFT JOIN Deal_Segment DS ON AAD.Deal_Segment_Code = DS.Deal_Segment_Code
  LEFT JOIN Revenue_Vertical RV ON AAD.Revenue_Vertical_Code = RV.Revenue_Vertical_Code
  INNER JOIN Users USR ON USR.Users_Code = CASE WHEN AAD.version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
   END   
  --INNER JOIN Role R ON R.Role_Code = AAD.Role_Code  
  --LEFT OUTER JOIN Channel_Cluster CC ON AAD.Channel_Cluster_Code = CC.Channel_Cluster_Code  
  WHERE AAD.Syn_Deal_Code = @Syn_Deal_Code  
  

  INSERT INTO #TempDealHistory(AT_Syn_Deal_Code,Syn_Deal_Code,Agreement_No,Version, VersionOld,Deal_Description,Deal_Type_Name,[Entity_Name],Exchange_Rate,Category_Name,Vendor_Name, Contact_Name,Currency_Name, [Index],ChangedColumnIndex,Inserted_By,Deal_Segment, Revenue_Vertical )  
  SELECT 0,Syn_Deal_Code,Agreement_No,Version,RIGHT('000' + cast( (cast(Version as decimal) +1) as varchar(50)),4),Deal_Description,DT.Deal_Type_Name,E.[Entity_Name],Exchange_Rate,C.Category_Name,V.Vendor_Name, VC.Contact_Name,CR.Currency_Name, cast(AAD.Version as decimal),'',USR.Login_Name, DS.Deal_Segment_Name, RV.Revenue_Vertical_Name
  FROM Syn_Deal AAD  
  INNER JOIN Deal_Type DT ON AAD.Deal_Type_Code = DT.Deal_Type_Code  
  INNER JOIN Entity E ON AAD.Entity_Code = E.Entity_Code  
  INNER JOIN Category C ON AAD.Category_Code = C.Category_Code  
  INNER JOIN Vendor V ON AAD.Vendor_Code = V.Vendor_Code  
  LEFT OUTER JOIN Vendor_Contacts VC ON AAD.Vendor_Contact_Code = VC.Vendor_Contacts_Code  
  INNER JOIN Currency CR ON AAD.Currency_Code = CR.Currency_Code 
  LEFT JOIN Deal_Segment DS ON AAD.Deal_Segment_Code = DS.Deal_Segment_Code 
  LEFT JOIN Revenue_Vertical RV ON AAD.Revenue_Vertical_Code = RV.Revenue_Vertical_Code
  INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
   END  
  --INNER JOIN Role R ON R.Role_Code = AAD.Role_Code  
  --LEFT OUTER JOIN Channel_Cluster CC ON AAD.Channel_Cluster_Code = CC.Channel_Cluster_Code  
  WHERE Syn_Deal_Code = @Syn_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempDealHistory)



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
     
   select @ISChange =  case when ISNULL(a.Deal_Description,'')  != isnull(B.Deal_Description,'') then 'Y'  end  
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
  
   --select @ISChange =  case when ISNULL(a.Channel_Cluster_Name,'')  != isnull(B.Channel_Cluster_Name,'') then 'Y'  end  
   --from #TempDealHistory a   
   --left join #TempDealHistory b on a.Version = b.VersionOld  
   --where a.[Index] = @temp and  a.Version = @Version  
    
   if(@ISChange = 'Y')  
   BEGIN  
     update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '15,' where [Index] = @temp and version = @version  
     set @ISChange = ''   
   END  
  
   select @ISChange =  case when ISNULL(a.Deal_Segment ,'')  != isnull(B.Deal_Segment,'') then 'Y'  end  
   from #TempDealHistory a   
   left join #TempDealHistory b on a.Version = b.VersionOld  
   where a.[Index] = @temp and  a.Version = @Version  
    
   if(@ISChange = 'Y')  
   BEGIN  
     update #TempDealHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '16,' where [Index] = @temp and version = @version  
     set @ISChange = ''   
   END  

   select @ISChange =  case when ISNULL(a.Revenue_Vertical ,'')  != isnull(B.Revenue_Vertical,'') then 'Y'  end  
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
----------------------------------------------Movie Tab------------------------------------------------------------------  
IF(@TabName = 'DEALMOVIE')  
BEGIN  
  
 CREATE TABLE #TempMovieHistory  
 (  
  AT_Syn_Deal_Movie_Code int,  
  [Version] VARCHAR(50),  
  [VersionOld] VARCHAR(50),  
  Title_Name NVARCHAR(250),  
  No_Of_Episodes int,  
  Title_Type VARCHAR(50),  
  Episode_Starts_From int,  
  Episode_End_To int,  
  Closing_Remarks NVARCHAR(MAX),  
  [Status] VARCHAR(10),  
  [Index] int,  
  ChangedColumnIndex varchar(MAX),
  [Inserted_By] VARCHAR(50)  
 )  
   
 INSERT INTO #TempMovieHistory  
 (  
  AT_Syn_Deal_Movie_Code ,  
  [Version] ,  
  [VersionOld] ,  
  Title_Name ,  
  No_Of_Episodes ,  
  Title_Type ,  
  Episode_Starts_From ,  
  Episode_End_To ,  
  Closing_Remarks ,   
  [Status] ,  
  [Index] ,  
  ChangedColumnIndex,
  [Inserted_By]  
 )  
   Select AADM.AT_Syn_Deal_Movie_Code, AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld, t.Title_Name, ISNULL(AADM.No_Of_Episode,'') No_Of_Episodes, 
 CASE ISNULL(AADM.Syn_Title_Type,'')   
 WHEN  'P' THEN 'Premier'   
 WHEN 'L' THEN 'Library'   
 ELSE 'N/A'  
 END  
 Title_Type,  
 ISNULL(AADM.Episode_From,'') Episode_Starts_From,ISNULL(AADM.Episode_End_To,'') Episode_End_To,ISNULL(AADM.Remark,'') Closing_Remarks,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name 
 from AT_Syn_Deal AAD  
 INNER JOIN AT_Syn_Deal_Movie AADM ON AAD.AT_Syn_Deal_Code = AADM.AT_Syn_Deal_Code  
 INNER JOIN Title t ON t.Title_Code = AADM.Title_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN 
				AAD.Inserted_By
			  ELSE
				AAD.Last_Action_By
		 END	
 Where Syn_Deal_Code = @Syn_Deal_Code  
 Order by T.Title_Name DESC,AAD.version  

 INSERT INTO #TempMovieHistory  
 (  
  AT_Syn_Deal_Movie_Code ,  
  [Version] ,  
  [VersionOld] ,  
  Title_Name ,  
  No_Of_Episodes ,  
  Title_Type ,  
  Episode_Starts_From ,  
  Episode_End_To ,  
  Closing_Remarks ,  
  [Status] ,  
  [Index] ,  
  ChangedColumnIndex,
  [Inserted_By]
 )  
 Select AADM.Syn_Deal_Movie_Code, AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,   
 t.Title_Name, ISNULL(AADM.No_Of_Episode,'') No_Of_Episodes,CASE ISNULL(AADM.Syn_Title_Type,'')   
 WHEN  'P' THEN 'Premier'   
 WHEN 'L' THEN 'Library'   
 ELSE 'N/A'  
 END Title_Type,ISNULL(AADM.Episode_From,'') Episode_Starts_From,ISNULL(AADM.Episode_End_To,'') Episode_End_To,ISNULL(AADM.Remark,'') Closing_Remarks,  
 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 from Syn_Deal AAD  
 INNER JOIN Syn_Deal_Movie AADM ON AAD.Syn_Deal_Code = AADM.Syn_Deal_Code  
 INNER JOIN Title t ON t.Title_Code = AADM.Title_Code  
  INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN 
				AAD.Inserted_By
			  ELSE
				AAD.Last_Action_By
		 END	
 Where AAD.Syn_Deal_Code = @Syn_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempMovieHistory)  
 Order by T.Title_Name DESC,AAD.version  
  
 DECLARE @AT_Syn_Deal_Movie_Code int   
 DECLARE @Title_Name NVARCHAR(MAX)   
 DECLARE @CurrentVersion varchar(100)   
 DECLARE @ISChange_V1 INT  
  
   
 DECLARE cur_DealMovieHistory CURSOR for   
 select distinct AT_Syn_Deal_Movie_Code,Title_Name,Version,[Index]  from #TempMovieHistory --where AT_Syn_Deal_Movie_Code In (10089, 10101)  
 OPEN cur_DealMovieHistory  
  
 FETCH next from cur_DealMovieHistory  into @AT_Syn_Deal_Movie_Code,@Title_Name,@CurrentVersion, @temp  
 WHILE (@@FETCH_STATUS <> -1)  
 BEGIN  
  SET @ISChange = ''  
  SET @ISChange_V1 = 0  
  if(@CurrentVersion != (SELECT '000' + cast( MIN(cast(Version as decimal)) as varchar(50)) FROM #TempMovieHistory WHERE Title_Name = @Title_Name))  
  BEGIN  
     
   select @ISChange =  case when ISNULL(a.Closing_Remarks,'')  != isnull(b.Closing_Remarks,'') then 'Y'  end  
   from #TempMovieHistory a   
   left join #TempMovieHistory b on a.Version = b.VersionOld  
   where a.Version = @CurrentVersion and a.AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and b.Title_Name = @Title_Name  
  
   if(@ISChange = 'Y')  
   BEGIN  
     update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @CurrentVersion  
     and AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and Title_Name = @Title_Name  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
   END  
  
   select @ISChange =  case when ISNULL(a.Episode_Starts_From,'')  != isnull(b.Episode_Starts_From,'') then 'Y'  end  
   from #TempMovieHistory a   
   left join #TempMovieHistory b on a.Version = b.VersionOld  
   where a.Version = @CurrentVersion and a.AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and b.Title_Name = @Title_Name  
  
   if(@ISChange = 'Y')  
   BEGIN  
     update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @CurrentVersion  
     and AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and Title_Name = @Title_Name  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
   END  
  
   select @ISChange =  case when ISNULL(a.Episode_End_To,'')  != isnull(b.Episode_End_To,'') then 'Y'  end  
   from #TempMovieHistory a   
   left join #TempMovieHistory b on a.Version = b.VersionOld  
   where a.Version = @CurrentVersion and a.AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and b.Title_Name = @Title_Name  
  
   if(@ISChange = 'Y')  
   BEGIN  
     update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @CurrentVersion  
     and AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and Title_Name = @Title_Name  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
   END  
  
   --select @ISChange =  case when ISNULL(a.Notes,'')  != isnull(b.Notes,'') then 'Y'  end  
   --from #TempMovieHistory a   
   --left join #TempMovieHistory b on a.Version = b.VersionOld  
   --where a.Version = @CurrentVersion and a.AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and b.Title_Name = @Title_Name  
  
   if(@ISChange = 'Y')  
   BEGIN  
     update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @CurrentVersion  
     and AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and Title_Name = @Title_Name  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
   END  
  
   --select @ISChange =  case when ISNULL(a.Movie_Closed_Date,'')  != isnull(b.Movie_Closed_Date,'') then 'Y'  end  
   --from #TempMovieHistory a   
   --left join #TempMovieHistory b on a.Version = b.VersionOld  
   --where a.Version = @CurrentVersion and a.AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and b.Title_Name = @Title_Name  
  
   if(@ISChange = 'Y')  
   BEGIN  
     update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @CurrentVersion  
     and AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and Title_Name = @Title_Name  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
   END  
  
   select @ISChange =  case when ISNULL(a.Title_Type,'')  != isnull(b.Title_Type,'') then 'Y'  end  
   from #TempMovieHistory a   
   left join #TempMovieHistory b on a.Version = b.VersionOld  
   where a.Version = @CurrentVersion and a.AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and b.Title_Name = @Title_Name  
  
   if(@ISChange = 'Y')  
   BEGIN  
     update #TempMovieHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @CurrentVersion  
     and AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code and Title_Name = @Title_Name  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
   END  
  
   if(@ISChange_V1 > 0)  
   BEGIN  
    UPDATE #TempMovieHistory  
    SET Status = 'Modified'  
    WHERE AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code  
      
   END  
  END  
  ELSE  
  BEGIN  
   UPDATE #TempMovieHistory  
   SET Status = 'Added'  
   WHERE AT_Syn_Deal_Movie_Code = @AT_Syn_Deal_Movie_Code  
  END  
  
  FETCH next from cur_DealMovieHistory  into @AT_Syn_Deal_Movie_Code,@Title_Name,@CurrentVersion, @temp  
 END  
 Deallocate cur_DealMovieHistory  
  
 Select * from #TempMovieHistory  
 END  
-------------------------------------End Movie Tab----------------------------------------------------------------------  
-------------------------------------------------------- Code Start for Deal Rights History-------------------------------------------------------------------  
/*  
EXEC [dbo].[USP_Get_Version_History_Syn]  5,1,'DEALRIGHTS'   
select * from syn_deal where Agreement_No='S-2015-00099'  
*/  
IF(@TabName = 'DEALRIGHTS')  
BEGIN  
  
 CREATE TABLE #TempRightsHistory  
 (  
  AT_SYN_Deal_Rights_Code int,  
  [Version] VARCHAR(50),  
  [VersionOld] VARCHAR(50),  
  SYN_Deal_Rights_Code int,  
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
  Right_Start_Date date,  
  Right_End_Date date,  
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
  
 INSERT INTO #TempRightsHistory(AT_SYN_Deal_Rights_Code,  
 [Version],  
 [VersionOld],  
 SYN_Deal_Rights_Code,  
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
 [Inserted_By] )  
 Select AADR.AT_SYN_Deal_Rights_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADR.Syn_Deal_Rights_Code,0)  Syn_Deal_Rights_Code  
 ,AADR.Is_Exclusive,AADR.Is_Title_Language_Right,AADR.Is_Sub_License,ISNULL(S.Sub_License_Name ,'') as Sub_License_Name,AADR.Is_Theatrical_Right  
 ,AADR.Right_Type,AADR.Is_Tentative,AADR.Term,ISNULL(Convert(varchar(20),AADR.Actual_Right_Start_Date,106),'') Right_Start_Date,  
 ISNULL(Convert(varchar(20),AADR.Actual_Right_End_Date,106),'') Right_End_Date,ISNULL(MT.Milestone_Type_Name,'') Milestone_Type_Name,ISNULL(AADR.Milestone_No_Of_Unit,'') Milestone_No_Of_Unit,  
 ISNULL(AADR.Milestone_Unit_Type,'') Milestone_Unit_Type,AADR.Is_ROFR,ISNULL(Convert(varchar(20),AADR.ROFR_Date,106),'') ROFR_Date,ISNULL(AADR.Restriction_Remarks,'') Restriction_Remarks,ISNULL(Convert(varchar(20),AADR.Effective_Start_Date,106),'') Effective_Start_Date  
 ,ISNULL(R.ROFR_Type,'') ROFR_Type, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 FROM AT_SYN_Deal_Rights AADR   
 INNER JOIN AT_Syn_Deal AAD ON AADR.AT_SYN_Deal_Code = AAD.AT_Syn_Deal_Code  
 LEFT JOIN Sub_License S ON AADR.Sub_License_Code = S.Sub_License_Code  
 LEFT JOIN Milestone_Type MT ON AADR.Milestone_Type_Code = MT.Milestone_Type_Code  
 LEFT JOIN ROFR R ON AADR.ROFR_Code = R.ROFR_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code  
 AND AADR.Is_Pushback = 'N'  
 ORDER BY AADR.Syn_Deal_Rights_Code ASC, AAD.Version ASC  
  
  
  
 INSERT INTO #TempRightsHistory(AT_Syn_Deal_Rights_Code,  
 [Version],  
 [VersionOld],  
 Syn_Deal_Rights_Code,  
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
 Select 0 AT_Syn_Deal_Rights_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADR.Syn_Deal_Rights_Code,0) Syn_Deal_Rights_Code  
 ,AADR.Is_Exclusive,AADR.Is_Title_Language_Right,AADR.Is_Sub_License,ISNULL (S.Sub_License_Name, '') as Sub_License_Name,AADR.Is_Theatrical_Right  
 ,AADR.Right_Type,AADR.Is_Tentative,AADR.Term,ISNULL(Convert(varchar(20),AADR.Actual_Right_Start_Date,106),'') Right_Start_Date,  
 ISNULL(Convert(varchar(20),AADR.Actual_Right_End_Date,106),'') Right_End_Date,ISNULL(MT.Milestone_Type_Name,'') Milestone_Type_Name,ISNULL(AADR.Milestone_No_Of_Unit,'') Milestone_No_Of_Unit,  
 ISNULL(AADR.Milestone_Unit_Type,'') Milestone_Unit_Type,AADR.Is_ROFR,ISNULL(Convert(varchar(20),AADR.ROFR_Date,106),'') ROFR_Date,ISNULL(AADR.Restriction_Remarks,'') Restriction_Remarks,ISNULL(Convert(varchar(20),AADR.Effective_Start_Date,106),'') Effective_Start_Date  
 ,ISNULL(R.ROFR_Type,'') ROFR_Type, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 from Syn_Deal_Rights AADR   
 INNER JOIN Syn_Deal AAD ON AADR.Syn_Deal_Code = AAD.Syn_Deal_Code  
 LEFT JOIN Sub_License S ON AADR.Sub_License_Code = S.Sub_License_Code  
 LEFT JOIN Milestone_Type MT ON AADR.Milestone_Type_Code = MT.Milestone_Type_Code  
 LEFT JOIN ROFR R ON AADR.ROFR_Code = R.ROFR_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempRightsHistory)  
 AND AADR.Is_Pushback = 'N'  
 ORDER BY AADR.Syn_Deal_Rights_Code ASC, AAD.Version ASC  
  
  
 Declare @AT_Syn_Deal_Rights_Code int,@VersionOld VARCHAR(4),@Syn_Deal_Rights_Code int  
 Declare @Codes Varchar(MAX) = '0', @Title_Names NVARCHAR(MAX) = '', @Platform_Name NVARCHAR(4000)  
 Declare CUR_Right Cursor For Select AT_Syn_Deal_Rights_Code,Version,VersionOld,Syn_Deal_Rights_Code,[Index] From #TempRightsHistory  
   Open CUR_Right  
   Fetch Next From CUR_Right InTo @AT_Syn_Deal_Rights_Code,@Version,@VersionOld,@Syn_Deal_Rights_Code,@temp  
   While (@@FETCH_STATUS = 0)  
   Begin  
    IF(@AT_Syn_Deal_Rights_Code > 0)  
    BEGIN  
     Set @Codes = ''  
     Select @Codes = @Codes + Cast(Platform_Code as varchar) + ',' From AT_Syn_Deal_Rights_Platform Where AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code  
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
      From Title t   
      Inner Join AT_Syn_Deal_Rights_Title adrt On t.Title_Code = adrt.Title_Code   
      WHERE adrt.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code  
      ) as a  
      ORDER BY a.Title_Name  
  
      SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))  
  
     UPDATE #TempRightsHistory  
     SET [Platform_Name] = @Platform_Name,[Title_Name] = @Title_Names,  
     Country_Name = dbo.UFN_Get_Rights_Country_AT(@AT_Syn_Deal_Rights_Code,'S'),  
     Territory_Name = dbo.UFN_Get_Rights_Territory_AT(@AT_Syn_Deal_Rights_Code,'S'),   
     Dubbing = dbo.UFN_Get_Rights_Dubbing_AT(@AT_Syn_Deal_Rights_Code,'S')  
     ,Subtitling = dbo.UFN_Get_Rights_Subtitling_AT(@AT_Syn_Deal_Rights_Code,'S')  
     WHERE AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code  
    END  
    ELSE  
    BEGIN  
     Set @Codes = ''  
     Select @Codes = @Codes + Cast(Platform_Code as varchar) + ',' From Syn_Deal_Rights_Platform Where Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
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
      From Title t   
      Inner Join Syn_Deal_Rights_Title adrt On t.Title_Code = adrt.Title_Code   
      WHERE adrt.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      ) as a  
      ORDER BY a.Title_Name  
  
      SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))  
  
     UPDATE #TempRightsHistory  
     SET [Platform_Name] = @Platform_Name,[Title_Name] = @Title_Names,  
     Country_Name = dbo.UFN_Get_Rights_Country(@Syn_Deal_Rights_Code,'S',''),  
     Territory_Name = dbo.UFN_Get_Rights_Territory(@Syn_Deal_Rights_Code,'S'),  
      Dubbing = dbo.UFN_Get_Rights_Dubbing(@Syn_Deal_Rights_Code,'S')  
     ,Subtitling = dbo.UFN_Get_Rights_Subtitling(@Syn_Deal_Rights_Code,'S')  
     WHERE AT_Syn_Deal_Rights_Code = 0 AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
    END  
  
   SET @ISChange = ''  
   SET @ISChange_V1 = 0  
   if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempRightsHistory WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code))  
   BEGIN  
    select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Platform_Name,'')  != isnull(b.Platform_Name,'') then 'Y' else @ISChange  end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND ISNULL(@ISChange,'') <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Country_Name,'')  != isnull(b.Country_Name,'') then 'Y' else @ISChange  end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Territory_Name,'')  != isnull(b.Territory_Name,'') then 'Y' else @ISChange  end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Subtitling,'')  != isnull(b.Subtitling,'') then 'Y' else @ISChange  end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Dubbing,'')  != isnull(b.Dubbing,'') then 'Y'  else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Exclusive,'')  != isnull(b.Is_Exclusive,'') then 'Y' else @ISChange  end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Title_Language_Right,'')  != isnull(b.Is_Title_Language_Right,'') then 'Y' else @ISChange  end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '12,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Sub_License,'')  != isnull(b.Is_Sub_License,'') then 'Y' else @ISChange  end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '13,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Sub_License_Name,'')  != isnull(b.Sub_License_Name,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '14,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Theatrical_Right,'')  != isnull(b.Is_Theatrical_Right,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '15,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Right_Type,'')  != isnull(b.Right_Type,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '16,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Tentative,'')  != isnull(b.Is_Tentative,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '17,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Term,'')  != isnull(b.Term,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '18,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Right_Start_Date,'')  != isnull(b.Right_Start_Date,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '19,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Right_End_Date,'')  != isnull(b.Right_End_Date,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '20,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Milestone_Type_Name,'')  != isnull(b.Milestone_Type_Name,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '21,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Milestone_No_Of_Unit,'')  != isnull(b.Milestone_No_Of_Unit,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '22,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Milestone_Unit_Type,'')  != isnull(b.Milestone_Unit_Type,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '23,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_ROFR,'')  != isnull(b.Is_ROFR,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '24,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.ROFR_Date,'')  != isnull(b.ROFR_Date,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '25,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Restriction_Remarks,'')  != isnull(b.Restriction_Remarks,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '26,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Effective_Start_Date,'')  != isnull(b.Effective_Start_Date,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '27,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.ROFR_Type,'')  != isnull(b.ROFR_Type,'') then 'Y' else @ISChange end  
    from #TempRightsHistory a   
    left join #TempRightsHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempRightsHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '28,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    if(@ISChange_V1 > 1)  
    BEGIN  
     UPDATE #TempRightsHistory  
     SET Status = 'Modified'  
     WHERE AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code  
      
    END  
  
   END  
   ELSE  
   BEGIN  
    UPDATE #TempRightsHistory  
    SET Status = 'Added'  
    WHERE AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Rights_Code  
   END  
    Fetch Next From CUR_Right InTo @AT_Syn_Deal_Rights_Code,@Version,@VersionOld,@Syn_Deal_Rights_Code,@temp  
   END  
   Close CUR_Right  
   Deallocate CUR_Right  
   Select * from #TempRightsHistory  
  END  
---------------------------------------------------------- Code End for Deal Rights History-----------------------------------------------------------------------  
  
---------------------------------------------------------- Code Start for Deal Pushback History-------------------------------------------------------------------  
/*  
EXEC [dbo].[USP_Get_Version_History_Syn]  266,1,'DEALPUSHBACK'   
select * from syn_deal where Agreement_No='S-2015-00088'  
*/  
IF(@TabName = 'DEALPUSHBACK')  
BEGIN  
  
 CREATE TABLE #TempPushbackHistory  
 (  
  AT_SYN_Deal_Rights_Code int,  
  [Version] VARCHAR(50),  
  [VersionOld] VARCHAR(50),  
  SYN_Deal_Rights_Code int,  
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
  Right_Start_Date date,  
  Right_End_Date date,  
  Milestone_Type_Name VARCHAR(100),  
  Milestone_No_Of_Unit int,  
  Milestone_Unit_Type int,  
  Is_ROFR CHAR,  
  ROFR_Date date,  
  Restriction_Remarks NVARCHAR(MAX),  
  Effective_Start_Date VARCHAR(20),  
  ROFR_Type VARCHAR(100),  
  [Status] NVARCHAR(10),  
  [Index] int,  
  ChangedColumnIndex varchar(MAX),  
  [Inserted_By] VARCHAR(50)  
 )  
  
 INSERT INTO #TempPushbackHistory(AT_SYN_Deal_Rights_Code,  
 [Version],  
 [VersionOld],  
 SYN_Deal_Rights_Code,  
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
 Select AADR.AT_SYN_Deal_Rights_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADR.Syn_Deal_Rights_Code,0)  Syn_Deal_Rights_Code  
 ,AADR.Is_Exclusive,AADR.Is_Title_Language_Right,AADR.Is_Sub_License,ISNULL(S.Sub_License_Name ,'') as Sub_License_Name,AADR.Is_Theatrical_Right  
 ,AADR.Right_Type,AADR.Is_Tentative,AADR.Term,ISNULL(Convert(varchar(20),AADR.Actual_Right_Start_Date,106),'') Right_Start_Date,  
 ISNULL(Convert(varchar(20),AADR.Actual_Right_End_Date,106),'') Right_End_Date,ISNULL(MT.Milestone_Type_Name,'') Milestone_Type_Name,ISNULL(AADR.Milestone_No_Of_Unit,'') Milestone_No_Of_Unit,  
 ISNULL(AADR.Milestone_Unit_Type,'') Milestone_Unit_Type,AADR.Is_ROFR,ISNULL(Convert(varchar(20),AADR.ROFR_Date,106),'') ROFR_Date,ISNULL(AADR.Restriction_Remarks,'') Restriction_Remarks,ISNULL(Convert(varchar(20),AADR.Effective_Start_Date,106),'') Effective_Start_Date  
 ,ISNULL(R.ROFR_Type,'') ROFR_Type, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 FROM AT_SYN_Deal_Rights AADR   
 INNER JOIN AT_Syn_Deal AAD ON AADR.AT_SYN_Deal_Code = AAD.AT_Syn_Deal_Code  
 LEFT JOIN Sub_License S ON AADR.Sub_License_Code = S.Sub_License_Code  
 LEFT JOIN Milestone_Type MT ON AADR.Milestone_Type_Code = MT.Milestone_Type_Code  
 LEFT JOIN ROFR R ON AADR.ROFR_Code = R.ROFR_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code  
 AND AADR.Is_Pushback = 'Y'  
 ORDER BY AADR.Syn_Deal_Rights_Code ASC, AAD.Version ASC  
  
 INSERT INTO #TempPushbackHistory(AT_Syn_Deal_Rights_Code,  
 [Version],  
 [VersionOld],  
 Syn_Deal_Rights_Code,  
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
 Select 0 AT_Syn_Deal_Rights_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADR.Syn_Deal_Rights_Code,0) Syn_Deal_Rights_Code  
 ,AADR.Is_Exclusive,AADR.Is_Title_Language_Right,AADR.Is_Sub_License,ISNULL (S.Sub_License_Name, '') as Sub_License_Name,AADR.Is_Theatrical_Right  
 ,AADR.Right_Type,AADR.Is_Tentative,AADR.Term,ISNULL(Convert(varchar(20),AADR.Actual_Right_Start_Date,106),'') Right_Start_Date,  
 ISNULL(Convert(varchar(20),AADR.Actual_Right_End_Date,106),'') Right_End_Date,ISNULL(MT.Milestone_Type_Name,'') Milestone_Type_Name,ISNULL(AADR.Milestone_No_Of_Unit,'') Milestone_No_Of_Unit,  
 ISNULL(AADR.Milestone_Unit_Type,'') Milestone_Unit_Type,AADR.Is_ROFR,ISNULL(Convert(varchar(20),AADR.ROFR_Date,106),'') ROFR_Date,ISNULL(AADR.Restriction_Remarks,'') Restriction_Remarks,ISNULL(Convert(varchar(20),AADR.Effective_Start_Date,106),'') Effective_Start_Date  
 ,ISNULL(R.ROFR_Type,'') ROFR_Type, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 from Syn_Deal_Rights AADR   
 INNER JOIN Syn_Deal AAD ON AADR.Syn_Deal_Code = AAD.Syn_Deal_Code  
 LEFT JOIN Sub_License S ON AADR.Sub_License_Code = S.Sub_License_Code  
 LEFT JOIN Milestone_Type MT ON AADR.Milestone_Type_Code = MT.Milestone_Type_Code  
 LEFT JOIN ROFR R ON AADR.ROFR_Code = R.ROFR_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempPushbackHistory)  
 AND Is_Pushback = 'Y' 
 ORDER BY AADR.Syn_Deal_Rights_Code ASC, AAD.Version ASC  
  
  
 Declare @AT_Syn_Deal_Pushback_Code int,@Syn_Deal_Pushback_Code int  
 Declare @Codes_Pushback Varchar(MAX) = '0', @Title_Names_Pushback NVARCHAR(MAX) = '', @Platform_Name_Pushback NVARCHAR(4000)  
 Declare CUR_Right Cursor For Select AT_Syn_Deal_Rights_Code,Version,VersionOld,Syn_Deal_Rights_Code,[Index] From #TempPushbackHistory  
   Open CUR_Right  
   Fetch Next From CUR_Right InTo @AT_Syn_Deal_Pushback_Code,@Version,@VersionOld,@Syn_Deal_Pushback_Code,@temp  
   While (@@FETCH_STATUS = 0)  
   Begin  
    IF(@AT_Syn_Deal_Pushback_Code > 0)  
    BEGIN  
     Set @Codes_Pushback = ''  
     Select @Codes_Pushback = @Codes_Pushback + Cast(Platform_Code as varchar) + ',' From AT_Syn_Deal_Rights_Platform Where AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code  
     SET  @Platform_Name_Pushback = ''  
     select @Platform_Name_Pushback = @Platform_Name_Pushback + Platform_Hiearachy + ',' from dbo.UFN_Get_Platform_With_Parent (@Codes_Pushback)  
     set @Platform_Name_Pushback = reverse(stuff(reverse(@Platform_Name_Pushback), 1, 1, ''))  
  
     Set @Title_Names_Pushback = ''  
     Select @Title_Names_Pushback = @Title_Names_Pushback + Title_Name + ', ' From (  
      Select Distinct   
      Case @Deal_Type_Condition  
      When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) '   
      When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) '   
      Else t.Title_Name End As Title_Name  
      From Title t   
      Inner Join AT_Syn_Deal_Rights_Title adrt On t.Title_Code = adrt.Title_Code   
      WHERE adrt.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code  
      ) as a  
      ORDER BY a.Title_Name  
  
      SET @Title_Names_Pushback = Substring(@Title_Names_Pushback, 0, Len(@Title_Names_Pushback))  
  
     UPDATE #TempPushbackHistory  
     SET [Platform_Name] = @Platform_Name_Pushback,[Title_Name] = @Title_Names_Pushback,  
     Country_Name = dbo.UFN_Get_Rights_Country_AT(@AT_Syn_Deal_Pushback_Code,'S'),  
     Territory_Name = dbo.UFN_Get_Rights_Territory_AT(@AT_Syn_Deal_Pushback_Code,'S'),   
     Dubbing = dbo.UFN_Get_Rights_Dubbing_AT(@AT_Syn_Deal_Pushback_Code,'S')  
     ,Subtitling = dbo.UFN_Get_Rights_Subtitling_AT(@AT_Syn_Deal_Pushback_Code,'S')  
     WHERE AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code  
    END  
    ELSE  
    BEGIN  
     Set @Codes_Pushback = ''  
     Select @Codes_Pushback = @Codes_Pushback + Cast(Platform_Code as varchar) + ',' From Syn_Deal_Rights_Platform Where Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
     SET  @Platform_Name_Pushback = ''  
     select @Platform_Name_Pushback = @Platform_Name_Pushback + Platform_Hiearachy + ',' from dbo.UFN_Get_Platform_With_Parent (@Codes_Pushback)  
     set @Platform_Name_Pushback = reverse(stuff(reverse(@Platform_Name_Pushback), 1, 1, ''))  
  
      
  
     Set @Title_Names_Pushback = ''  
     Select @Title_Names_Pushback = @Title_Names_Pushback + Title_Name + ', ' From (  
      Select Distinct   
      Case @Deal_Type_Condition  
      When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) '   
      When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) '   
      Else t.Title_Name End As Title_Name  
      From Title t   
      Inner Join Syn_Deal_Rights_Title adrt On t.Title_Code = adrt.Title_Code   
      WHERE adrt.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      ) as a  
      ORDER BY a.Title_Name  
  
      SET @Title_Names_Pushback = Substring(@Title_Names_Pushback, 0, Len(@Title_Names_Pushback))  
  
     UPDATE #TempPushbackHistory  
     SET [Platform_Name] = @Platform_Name_Pushback,[Title_Name] = @Title_Names_Pushback,  
     Country_Name = dbo.UFN_Get_Rights_Country(@Syn_Deal_Pushback_Code,'S',''),  
     Territory_Name = dbo.UFN_Get_Rights_Territory(@Syn_Deal_Pushback_Code,'S'),  
      Dubbing = dbo.UFN_Get_Rights_Dubbing(@Syn_Deal_Pushback_Code,'S')  
     ,Subtitling = dbo.UFN_Get_Rights_Subtitling(@Syn_Deal_Pushback_Code,'S')  
     WHERE AT_Syn_Deal_Rights_Code = 0 AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
    END  
  
   SET @ISChange = ''  
   SET @ISChange_V1 = 0  
   if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempPushbackHistory WHERE Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code))  
   BEGIN  
    select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Platform_Name,'')  != isnull(b.Platform_Name,'') then 'Y' else @ISChange  end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND ISNULL(@ISChange,'') <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Country_Name,'')  != isnull(b.Country_Name,'') then 'Y' else @ISChange  end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Territory_Name,'')  != isnull(b.Territory_Name,'') then 'Y' else @ISChange  end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Subtitling,'')  != isnull(b.Subtitling,'') then 'Y' else @ISChange  end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Dubbing,'')  != isnull(b.Dubbing,'') then 'Y'  else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Exclusive,'')  != isnull(b.Is_Exclusive,'') then 'Y' else @ISChange  end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Title_Language_Right,'')  != isnull(b.Is_Title_Language_Right,'') then 'Y' else @ISChange  end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '12,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Sub_License,'')  != isnull(b.Is_Sub_License,'') then 'Y' else @ISChange  end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '13,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Sub_License_Name,'')  != isnull(b.Sub_License_Name,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '14,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Theatrical_Right,'')  != isnull(b.Is_Theatrical_Right,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '15,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Right_Type,'')  != isnull(b.Right_Type,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '16,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_Tentative,'')  != isnull(b.Is_Tentative,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '17,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Term,'')  != isnull(b.Term,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '18,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Right_Start_Date,'')  != isnull(b.Right_Start_Date,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '19,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Right_End_Date,'')  != isnull(b.Right_End_Date,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '20,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Milestone_Type_Name,'')  != isnull(b.Milestone_Type_Name,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '21,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Milestone_No_Of_Unit,'')  != isnull(b.Milestone_No_Of_Unit,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '22,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Milestone_Unit_Type,'')  != isnull(b.Milestone_Unit_Type,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '23,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Is_ROFR,'')  != isnull(b.Is_ROFR,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '24,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.ROFR_Date,'')  != isnull(b.ROFR_Date,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '25,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Restriction_Remarks,'')  != isnull(b.Restriction_Remarks,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '26,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Effective_Start_Date,'')  != isnull(b.Effective_Start_Date,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '27,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.ROFR_Type,'')  != isnull(b.ROFR_Type,'') then 'Y' else @ISChange end  
    from #TempPushbackHistory a   
    left join #TempPushbackHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code AND a.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code and b.Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code AND @ISChange <> 'Y'  
  
    if(@ISChange = 'Y')  
    BEGIN  
      update #TempPushbackHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '28,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code   
      AND Syn_Deal_Rights_Code = @Syn_Deal_Pushback_Code  
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    if(@ISChange_V1 > 1)  
    BEGIN  
     UPDATE #TempPushbackHistory  
     SET Status = 'Modified'  
     WHERE AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code  
      
    END  
  
   END  
   ELSE  
   BEGIN  
    UPDATE #TempPushbackHistory  
    SET Status = 'Added'  
    WHERE AT_Syn_Deal_Rights_Code = @AT_Syn_Deal_Pushback_Code  
   END  
    Fetch Next From CUR_Right InTo @AT_Syn_Deal_Pushback_Code,@Version,@VersionOld,@Syn_Deal_Pushback_Code,@temp  
   END  
   Close CUR_Right  
   Deallocate CUR_Right  
   Select * from #TempPushbackHistory  
  END  
  
-- Code End for Deal Pushback History  
  
-- Code Start for Deal Payment Term  
/*  
EXEC [dbo].[USP_Get_Version_History_Syn]  266,1,'DEALPAYMENTTERM'   
select * from syn_deal where Agreement_No='S-2015-00088'  
*/  
IF(@TabName = 'DEALPAYMENTTERM')  
BEGIN  
 CREATE TABLE #TempPlatformHistory  
 (  
  AT_Syn_Deal_Payment_Terms_Code int,  
  [Version] VARCHAR(50),  
  [VersionOld] VARCHAR(50),  
  Syn_Deal_Payment_Terms_Code int,  
  Cost_Type NVARCHAR(200),  
  Payment_Term NVARCHAR(200),  
  Days_After int,  
  Percentage decimal(10,3),  
  --Amount decimal(10,3),  
  Due_Date datetime,  
  [Status] VARCHAR(10),  
  [Index] int,  
  ChangedColumnIndex varchar(MAX),  
  [Inserted_By] VARCHAR(50)  
 )  
  
 INSERT INTO #TempPlatformHistory  
 (  
  AT_Syn_Deal_Payment_Terms_Code,  
  [Version] ,  
  [VersionOld],  
  Syn_Deal_Payment_Terms_Code,  
  Cost_Type ,  
  Payment_Term ,  
  Days_After ,  
  Percentage ,  
  --Amount ,  
  Due_Date,  
  [Status],  
  [Index] ,  
  ChangedColumnIndex,  
  [Inserted_By]  
 )  
 Select AAPT.AT_Syn_Deal_Payment_Terms_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,  
 ISNULL(AAPT.Syn_Deal_Payment_Terms_Code ,0) Syn_Deal_Payment_Terms_Code,CT.Cost_Type_Name,PT.Payment_Terms,AAPT.Days_After,AAPT.Percentage,CONVERT(VARCHAR(20),AAPT.Due_Date,106) Due_Date, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 FROM AT_Syn_Deal_Payment_Terms AAPT   
 INNER JOIN AT_Syn_Deal AAD ON AAPT.AT_Syn_Deal_Code = AAD.AT_Syn_Deal_Code  
 LEFT JOIN Cost_Type CT ON AAPT.Cost_Type_Code = CT.Cost_Type_Code  
 LEFT JOIN Payment_Terms PT ON AAPT.Payment_Terms_Code = PT.Payment_Terms_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code  
 ORDER BY AAPT.Syn_Deal_Payment_Terms_Code ASC, AAD.Version ASC  
  
 INSERT INTO #TempPlatformHistory  
 (  
  AT_Syn_Deal_Payment_Terms_Code,  
  [Version] ,  
  [VersionOld],  
  Syn_Deal_Payment_Terms_Code,  
  Cost_Type ,  
  Payment_Term ,  
  Days_After ,  
  Percentage ,  
  --Amount ,  
  Due_Date,  
  [Status],  
  [Index] ,  
  ChangedColumnIndex,  
  [Inserted_By]  
 )  
 Select 0 AT_Syn_Deal_Payment_Terms_Code,AAD.Version,RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AAPT.Syn_Deal_Payment_Terms_Code, 0) Syn_Deal_Payment_Terms_Code,CT.Cost_Type_Name,PT.Payment_Terms,AAPT.Days_After
,AAPT.Percentage,CONVERT(VARCHAR(20),AAPT.Due_Date,106) Due_Date, 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 FROM Syn_Deal_Payment_Terms AAPT   
 INNER JOIN Syn_Deal AAD ON AAPT.Syn_Deal_Code = AAD.Syn_Deal_Code  
 LEFT JOIN Cost_Type CT ON AAPT.Cost_Type_Code = CT.Cost_Type_Code  
 LEFT JOIN Payment_Terms PT ON AAPT.Payment_Terms_Code = PT.Payment_Terms_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempPlatformHistory)  
 ORDER BY AAPT.Syn_Deal_Payment_Terms_Code ASC, AAD.Version ASC  
  
  
Declare @AT_Syn_Deal_Payment_Terms_Code int, @Syn_Deal_Payment_Terms_Code int  
Declare CUR_PaymentTerm Cursor For Select AT_Syn_Deal_Payment_Terms_Code,Version,VersionOld,Syn_Deal_Payment_Terms_Code,[Index] From #TempPlatformHistory  
  Open CUR_PaymentTerm  
  Fetch Next From CUR_PaymentTerm InTo @AT_Syn_Deal_Payment_Terms_Code,@Version,@VersionOld,@Syn_Deal_Payment_Terms_Code, @temp  
  While (@@FETCH_STATUS = 0)  
  Begin  
   SET @ISChange = ''  
   SET @ISChange_V1 = 0  
   if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempPlatformHistory WHERE Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code))  
   BEGIN  
      
    select @ISChange =  case when ISNULL(a.Cost_Type,'')  != isnull(b.Cost_Type,'') then 'Y' else @ISChange end  
    from #TempPlatformHistory a   
    left join #TempPlatformHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code AND a.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code and b.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code  
  
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code   
     AND Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Payment_Term,'')  != isnull(b.Payment_Term,'') then 'Y' else @ISChange end  
    from #TempPlatformHistory a   
    left join #TempPlatformHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code AND a.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code and b.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code   
     AND Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Days_After,'')  != isnull(b.Days_After,'') then 'Y' else @ISChange end  
    from #TempPlatformHistory a   
    left join #TempPlatformHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code AND a.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code and b.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code   
     AND Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Percentage,'0')  != isnull(b.Percentage,'0') then 'Y' else @ISChange end  
    from #TempPlatformHistory a   
    left join #TempPlatformHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code AND a.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code and b.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code   
     AND Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Percentage,'0')  != isnull(b.Percentage,'0') then 'Y' else @ISChange end  
    from #TempPlatformHistory a   
    left join #TempPlatformHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code AND a.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code and b.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code   
     AND Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Due_Date,'')  != isnull(b.Due_Date,'') then 'Y' else @ISChange end  
    from #TempPlatformHistory a   
    left join #TempPlatformHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code AND a.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code and b.Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempPlatformHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code   
     AND Syn_Deal_Payment_Terms_Code = @Syn_Deal_Payment_Terms_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    if(@ISChange_V1 > 1)  
    BEGIN  
     UPDATE #TempPlatformHistory  
     SET Status = 'Modified'  
     WHERE AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code  
      
    END  
   END  
   ELSE  
   BEGIN  
     UPDATE #TempPlatformHistory  
     SET Status = 'Added'  
     WHERE AT_Syn_Deal_Payment_Terms_Code = @AT_Syn_Deal_Payment_Terms_Code  
   END  
   Fetch Next From CUR_PaymentTerm InTo @AT_Syn_Deal_Payment_Terms_Code,@Version,@VersionOld,@Syn_Deal_Payment_Terms_Code , @temp  
  END  
  Close CUR_PaymentTerm  
  Deallocate CUR_PaymentTerm  
  Select * from #TempPlatformHistory  
END  
--------------------------------------------------------------- Code  End for Deal Payment Term--------------------------------------------------------------  
  
--------------------------------------------------------------- Code Start for Deal Attachment History--------------------------------------------------------  
/*  
EXEC [dbo].[USP_Get_Version_History_Syn]  266,1,'DEALATTACHMENT'   
select * from syn_deal where Agreement_No='S-2015-00122'  
*/  
 IF(@TabName = 'DEALATTACHMENT')  
 BEGIN  
    
  CREATE TABLE #TempAttachmentHistory  
  (  
   AT_Syn_Deal_Attachment_Code int,  
   [Version] VARCHAR(50),  
   [VersionOld] VARCHAR(50),  
   Syn_Deal_Attachment_Code int,  
   Title_Name NVARCHAR(500),  
   Attachment_Title NVARCHAR(500),  
   Attachment_File_Name NVARCHAR(500),  
   System_File_Name Varchar(1000),  
   Document_Type NVARCHAR(500),  
   Episode_From int,  
   Episode_To int,  
   [Status] NVARCHAR(10),  
   [Index] int,  
   ChangedColumnIndex VARCHAR(MAX)  
  )  
  
 INSERT INTO #TempAttachmentHistory  
 (  
  AT_Syn_Deal_Attachment_Code ,  
  [Version] ,  
  [VersionOld] ,  
  Syn_Deal_Attachment_Code,  
  Title_Name ,  
  Attachment_Title ,  
  Attachment_File_Name ,  
  System_File_Name ,  
  Document_Type ,  
  Episode_From ,  
  Episode_To ,  
  [Status] ,  
  [Index] ,  
  ChangedColumnIndex  
 )  
 Select AADA.AT_Syn_Deal_Attachment_Code,AAD.Version,  
 RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADA.Syn_Deal_Attachment_Code, 0) Syn_Deal_Attachment_Code,  
 T.Title_Name,AADA.Attachment_Title,AADA.Attachment_File_Name,AADA.System_File_Name,DT.Document_Type_Name,AADA.Episode_From,AADA.Episode_To,'UnChanged' [Status] ,cast(AAD.Version as decimal), ''  
 FROM AT_Syn_Deal_Attachment AADA   
 INNER JOIN AT_Syn_Deal AAD ON AADA.AT_Syn_Deal_Code = AAD.AT_Syn_Deal_Code  
 LEFT JOIN Document_Type DT ON AADA.Document_Type_Code = DT.Document_Type_Code  
 LEFT JOIN Title T ON AADA.Title_Code = T.Title_Code  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code  
 ORDER BY AADA.Syn_Deal_Attachment_Code ASC, AAD.Version ASC  
  
 INSERT INTO #TempAttachmentHistory  
 (  
  AT_Syn_Deal_Attachment_Code ,  
  [Version] ,  
  [VersionOld] ,  
  Syn_Deal_Attachment_Code,  
  Title_Name ,  
  Attachment_Title ,  
  Attachment_File_Name ,  
  System_File_Name ,  
  Document_Type ,  
  Episode_From ,  
  Episode_To ,  
  [Status] ,  
  [Index] ,  
  ChangedColumnIndex  
 )  
 Select 0 AT_Syn_Deal_Attachment_Code,AAD.Version,  
 RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADA.Syn_Deal_Attachment_Code, 0)Syn_Deal_Attachment_Code,  
 T.Title_Name,AADA.Attachment_Title,AADA.Attachment_File_Name,AADA.System_File_Name,DT.Document_Type_Name,AADA.Episode_From,AADA.Episode_To,'UnChanged' [Status] ,cast(AAD.Version as decimal), ''  
 FROM Syn_Deal_Attachment AADA   
 INNER JOIN Syn_Deal AAD ON AADA.Syn_Deal_Code = AAD.Syn_Deal_Code  
 LEFT JOIN Document_Type DT ON AADA.Document_Type_Code = DT.Document_Type_Code  
 LEFT JOIN Title T ON AADA.Title_Code = T.Title_Code  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempAttachmentHistory)  
 ORDER BY AADA.Syn_Deal_Attachment_Code ASC, AAD.Version ASC  
  
  
 Declare @AT_Syn_Deal_Attachment_Code int, @Syn_Deal_Attachment_Code int  
 Declare CUR_Attachment Cursor For Select AT_Syn_Deal_Attachment_Code,Version,VersionOld,Syn_Deal_Attachment_Code, [Index] From #TempAttachmentHistory  
  Open CUR_Attachment  
  Fetch Next From CUR_Attachment InTo @AT_Syn_Deal_Attachment_Code,@Version,@VersionOld,@Syn_Deal_Attachment_Code, @temp  
  While (@@FETCH_STATUS = 0)  
  Begin  
   SET @ISChange = ''  
   SET @ISChange_V1 = 0  
   if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempAttachmentHistory WHERE Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code))  
   BEGIN  
      
    select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end  
    from #TempAttachmentHistory a   
    left join #TempAttachmentHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code AND a.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code and b.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code   
     AND Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Attachment_Title,'')  != isnull(b.Attachment_Title,'') then 'Y' else @ISChange end  
    from #TempAttachmentHistory a   
    left join #TempAttachmentHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code AND a.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code and b.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code   
     AND Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Attachment_File_Name,'')  != isnull(b.Attachment_File_Name,'') then 'Y' else @ISChange end  
    from #TempAttachmentHistory a   
    left join #TempAttachmentHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code AND a.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code and b.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code   
     AND Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.System_File_Name,'')  != isnull(b.System_File_Name,'') then 'Y' else @ISChange end  
    from #TempAttachmentHistory a   
    left join #TempAttachmentHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code AND a.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code and b.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code   
     AND Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Document_Type,'')  != isnull(b.Document_Type,'') then 'Y' else @ISChange end  
    from #TempAttachmentHistory a   
    left join #TempAttachmentHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code AND a.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code and b.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code   
     AND Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Episode_From,'')  != isnull(b.Episode_From,'') then 'Y' else @ISChange end  
    from #TempAttachmentHistory a   
    left join #TempAttachmentHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code AND a.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code and b.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code   
     AND Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    select @ISChange =  case when ISNULL(a.Episode_To,'')  != isnull(b.Episode_To,'') then 'Y' else @ISChange end  
    from #TempAttachmentHistory a   
    left join #TempAttachmentHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code AND a.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code and b.Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAttachmentHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code   
     AND Syn_Deal_Attachment_Code = @Syn_Deal_Attachment_Code  
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    if(@ISChange_V1 > 1)  
    BEGIN  
     UPDATE #TempAttachmentHistory  
     SET Status = 'Modified'  
     WHERE AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code  
      
    END  
   END  
   ELSE  
   BEGIN  
     UPDATE #TempAttachmentHistory  
     SET Status = 'Added'  
     WHERE AT_Syn_Deal_Attachment_Code = @AT_Syn_Deal_Attachment_Code  
   END  
   Fetch Next From CUR_Attachment InTo @AT_Syn_Deal_Attachment_Code,@Version,@VersionOld,@Syn_Deal_Attachment_Code, @temp  
  END  
  Close CUR_Attachment  
  Deallocate CUR_Attachment  
  Select * from #TempAttachmentHistory  
 END  
  
-- Code End for Deal Attachment History  
/*  
EXEC [dbo].[USP_Get_Version_History_Syn]  266,1,'DEALMATERIAL'   
select * from syn_deal where Agreement_No='S-2015-00088'  
*/  
-- Code Start for Deal Material History  
  
IF(@TabName = 'DEALMATERIAL')  
BEGIN  
 CREATE TABLE #TempMaterialHistory  
 (  
  AT_Syn_Deal_Material_Code int,  
  [Version] VARCHAR(50),  
  [VersionOld] VARCHAR(50),  
  Syn_Deal_Material_Code int,  
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
  AT_Syn_Deal_Material_Code ,  
  [Version] ,  
  [VersionOld] ,  
  Syn_Deal_Material_Code,  
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
 Select AADM.AT_Syn_Deal_Material_Code,AAD.Version,  
 RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADM.Syn_Deal_Material_Code, 0)Syn_Deal_Material_Code,  
 T.Title_Name,MM.Material_Medium_Name,MT.Material_Type_Name,AADM.Quantity,AADM.Episode_From,AADM.Episode_To,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 FROM AT_Syn_Deal_Material AADM   
 INNER JOIN AT_Syn_Deal AAD ON AADM.AT_Syn_Deal_Code = AAD.AT_Syn_Deal_Code  
 LEFT JOIN Material_Medium MM ON AADM.Material_Medium_Code= MM.Material_Medium_Code  
 LEFT JOIN Material_Type MT ON AADM.Material_Type_Code = MT.Material_Type_Code  
 LEFT JOIN Title T ON AADM.Title_Code = T.Title_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code  
 ORDER BY AADM.Syn_Deal_Material_Code ASC, AAD.Version ASC  
  
 INSERT INTO #TempMaterialHistory  
 (  
  AT_Syn_Deal_Material_Code ,  
  [Version] ,  
  [VersionOld] ,  
  Syn_Deal_Material_Code,  
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
 Select 0 AT_Syn_Deal_Material_Code,AAD.Version,  
 RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADM.Syn_Deal_Material_Code, 0)Syn_Deal_Material_Code,  
 T.Title_Name,MM.Material_Medium_Name,MT.Material_Type_Name,AADM.Quantity,AADM.Episode_From,AADM.Episode_To,'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 FROM Syn_Deal_Material AADM   
 INNER JOIN Syn_Deal AAD ON AADM.Syn_Deal_Code = AAD.Syn_Deal_Code  
 LEFT JOIN Material_Medium MM ON AADM.Material_Medium_Code= MM.Material_Medium_Code  
 LEFT JOIN Material_Type MT ON AADM.Material_Type_Code = MT.Material_Type_Code  
 LEFT JOIN Title T ON AADM.Title_Code = T.Title_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempMaterialHistory)  
 ORDER BY AADM.Syn_Deal_Material_Code ASC, AAD.Version ASC  
  
  
 Declare @AT_Syn_Deal_Material_Code int, @Syn_Deal_Material_Code int  
 Declare CUR_Material Cursor For Select AT_Syn_Deal_Material_Code,Version,VersionOld,Syn_Deal_Material_Code, [Index] From #TempMaterialHistory  
   Open CUR_Material  
   Fetch Next From CUR_Material InTo @AT_Syn_Deal_Material_Code,@Version,@VersionOld,@Syn_Deal_Material_Code, @temp  
   While (@@FETCH_STATUS = 0)  
   Begin  
    SET @ISChange = ''  
    SET @ISChange_V1 = 0  
    if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempMaterialHistory WHERE Syn_Deal_Material_Code = @Syn_Deal_Material_Code))  
    BEGIN  
      
     select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end  
     from #TempMaterialHistory a   
     left join #TempMaterialHistory b on a.Version = b.VersionOld  
     where a.Version = @Version and a.AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code AND a.Syn_Deal_Material_Code = @Syn_Deal_Material_Code and b.Syn_Deal_Material_Code = @Syn_Deal_Material_Code  
     
     if(@ISChange = 'Y')  
     BEGIN  
      update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code   
      AND Syn_Deal_Material_Code = @Syn_Deal_Material_Code   
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
     END  
     
     select @ISChange =  case when ISNULL(a.Material_Medium,'')  != isnull(b.Material_Medium,'') then 'Y' else @ISChange end  
     from #TempMaterialHistory a   
     left join #TempMaterialHistory b on a.Version = b.VersionOld  
     where a.Version = @Version and a.AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code AND a.Syn_Deal_Material_Code = @Syn_Deal_Material_Code and b.Syn_Deal_Material_Code = @Syn_Deal_Material_Code AND @ISChange <> 'Y'  
       
     if(@ISChange = 'Y')  
     BEGIN  
      update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code   
      AND Syn_Deal_Material_Code = @Syn_Deal_Material_Code   
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
     END  
     
     select @ISChange =  case when ISNULL(a.Material_Type,'')  != isnull(b.Material_Type,'') then 'Y' else @ISChange end  
     from #TempMaterialHistory a   
     left join #TempMaterialHistory b on a.Version = b.VersionOld  
     where a.Version = @Version and a.AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code AND a.Syn_Deal_Material_Code = @Syn_Deal_Material_Code and b.Syn_Deal_Material_Code = @Syn_Deal_Material_Code AND @ISChange <> 'Y'  
       
     if(@ISChange = 'Y')  
     BEGIN  
      update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code   
      AND Syn_Deal_Material_Code = @Syn_Deal_Material_Code   
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
     END  
     
     select @ISChange =  case when ISNULL(a.Quantity,'0')  != isnull(b.Quantity,'0') then 'Y' else @ISChange end  
     from #TempMaterialHistory a   
     left join #TempMaterialHistory b on a.Version = b.VersionOld  
     where a.Version = @Version and a.AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code AND a.Syn_Deal_Material_Code = @Syn_Deal_Material_Code and b.Syn_Deal_Material_Code = @Syn_Deal_Material_Code AND @ISChange <> 'Y'  
       
     if(@ISChange = 'Y')  
     BEGIN  
      update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code   
      AND Syn_Deal_Material_Code = @Syn_Deal_Material_Code   
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
     END  
     
     select @ISChange =  case when ISNULL(a.Episode_From,'1')  != isnull(b.Episode_From,'1') then 'Y' else @ISChange end  
     from #TempMaterialHistory a   
     left join #TempMaterialHistory b on a.Version = b.VersionOld  
     where a.Version = @Version and a.AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code AND a.Syn_Deal_Material_Code = @Syn_Deal_Material_Code and b.Syn_Deal_Material_Code = @Syn_Deal_Material_Code AND @ISChange <> 'Y'  
       
     if(@ISChange = 'Y')  
     BEGIN  
      update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code   
      AND Syn_Deal_Material_Code = @Syn_Deal_Material_Code   
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
     END  
     
     select @ISChange =  case when ISNULL(a.Episode_To,'1')  != isnull(b.Episode_To,'1') then 'Y' else @ISChange end  
     from #TempMaterialHistory a   
     left join #TempMaterialHistory b on a.Version = b.VersionOld  
     where a.Version = @Version and a.AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code AND a.Syn_Deal_Material_Code = @Syn_Deal_Material_Code and b.Syn_Deal_Material_Code = @Syn_Deal_Material_Code AND @ISChange <> 'Y'  
       
     if(@ISChange = 'Y')  
     BEGIN  
      update #TempMaterialHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version  
      and AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code   
      AND Syn_Deal_Material_Code = @Syn_Deal_Material_Code   
      set @ISChange = ''   
      SET @ISChange_V1 = @ISChange_V1 + 1   
     END  
     
     if(@ISChange_V1 > 1)  
     BEGIN  
      UPDATE #TempMaterialHistory  
      SET Status = 'Modified'  
      WHERE AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code  
      
     END  
    END  
    ELSE  
    BEGIN  
      UPDATE #TempMaterialHistory  
      SET Status = 'Added'  
      WHERE AT_Syn_Deal_Material_Code = @AT_Syn_Deal_Material_Code  
    END  
    Fetch Next From CUR_Material InTo @AT_Syn_Deal_Material_Code,@Version,@VersionOld,@Syn_Deal_Material_Code, @temp  
   END  
   Close CUR_Material  
   Deallocate CUR_Material  
   Select * from #TempMaterialHistory  
  END  
-- Code End for Deal Material History  
  
-- Code start for Deal Ancillary History   
/*  
EXEC [dbo].[USP_Get_Version_History_Syn]  266,1,'DEALANCILLARY'   
select * from syn_deal where Agreement_No='S-2015-00088'  
*/  
 IF(@TabName = 'DEALANCILLARY')  
 BEGIN  
  
 CREATE TABLE #TempAncillaryHistory  
 (  
  AT_Syn_Deal_Ancillary_Code int,  
  [Version] VARCHAR(50),  
  [VersionOld] VARCHAR(50),  
  Syn_Deal_Ancillary_Code int,  
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
  AT_Syn_Deal_Ancillary_Code,  
  [Version],  
  [VersionOld],  
  Syn_Deal_Ancillary_Code,  
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
 Select AADA.AT_Syn_Deal_Ancillary_Code,AAD.Version,  
 RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADA.Syn_Deal_Ancillary_Code ,0 ) AS Syn_Deal_Ancillary_Code,  
 AT.Ancillary_Type_Name,  
 dbo.UFN_Get_Syn_Ancillary_Platform_AT(AADA.AT_Syn_Deal_Ancillary_Code) Ancillary_Platform,  
 dbo.UFN_Get_Syn_Ancillary_Medium_BaseOn_AncillaryCode_AT(AADA.AT_Syn_Deal_Ancillary_Code) Ancillary_Platform_Medium,  
 AADA.Duration,AADA.[Day],AADA.Remarks,  
 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 FROM AT_Syn_Deal_Ancillary AADA  
 INNER JOIN Ancillary_Type AT ON AADA.Ancillary_Type_code = AT.Ancillary_Type_code  
 INNER JOIN AT_Syn_Deal AAD ON AADA.AT_Syn_Deal_Code = AAD.AT_Syn_Deal_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code  
 ORDER BY AADA.Syn_Deal_Ancillary_Code ASC, AAD.Version ASC  
  
 INSERT INTO #TempAncillaryHistory  
 (  
  AT_Syn_Deal_Ancillary_Code,  
  [Version],  
  [VersionOld],  
  Syn_Deal_Ancillary_Code,  
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
 Select 0 AT_Syn_Deal_Ancillary_Code,AAD.Version,  
 RIGHT('000' + cast( (cast(AAD.Version as decimal) +1) as varchar(50)),4) VersionOld,ISNULL(AADA.Syn_Deal_Ancillary_Code, 0) Syn_Deal_Ancillary_Code,  
 AT.Ancillary_Type_Name,  
 dbo.UFN_Get_Syn_Ancillary_Platform(AADA.Syn_Deal_Ancillary_Code) Ancillary_Platform,  
 dbo.UFN_Get_Syn_Ancillary_Medium_BaseOn_AncillaryCode(AADA.Syn_Deal_Ancillary_Code) Ancillary_Platform_Medium,  
 AADA.Duration,AADA.[Day],AADA.Remarks,  
 'UnChanged' [Status],cast(AAD.Version as decimal), '',USR.Login_Name  
 FROM Syn_Deal_Ancillary AADA   
 INNER JOIN Ancillary_Type AT ON AADA.Ancillary_Type_code = AT.Ancillary_Type_code  
 INNER JOIN Syn_Deal AAD ON AADA.Syn_Deal_Code = AAD.Syn_Deal_Code  
 INNER JOIN Users USR ON USR.Users_Code = CASE WHEN version = '0001' THEN   
    AAD.Inserted_By  
     ELSE  
    AAD.Last_Action_By  
 END  
 WHere AAD.Syn_Deal_Code = @Syn_Deal_Code AND cast(AAD.Version as decimal) > (SELECT MAX(cast(Version as decimal)) from #TempAncillaryHistory)  
 ORDER BY AADA.Syn_Deal_Ancillary_Code ASC, AAD.Version ASC  
  
 Declare @AT_Syn_Deal_Ancillary_Code int, @Syn_Deal_Ancillary_Code int  
 Declare CUR_Ancillary Cursor For Select AT_Syn_Deal_Ancillary_Code,Version,VersionOld,Syn_Deal_Ancillary_Code,[Index] From #TempAncillaryHistory  
  Open CUR_Ancillary  
  Fetch Next From CUR_Ancillary InTo @AT_Syn_Deal_Ancillary_Code,@Version,@VersionOld,@Syn_Deal_Ancillary_Code, @temp  
  While (@@FETCH_STATUS = 0)  
  Begin  
     
   IF(@AT_Syn_Deal_Ancillary_Code > 0)  
   BEGIN  
      
    Set @Title_Names = ''  
    Select @Title_Names = @Title_Names + Title_Name + ', ' From (  
     Select Distinct   
     Case @Deal_Type_Condition  
     When 'DEAL_PROGRAM' Then t.Title_Name + ' ( ' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ' ) '   
     When 'DEAL_MUSIC' Then t.Title_Name + ' ( ' + Case When adrt.Episode_From = 0 Then 'Unlimited' Else Cast(adrt.Episode_From as Varchar(10)) End + ' ) '   
     Else t.Title_Name End As Title_Name  
     From Title t   
     Inner Join AT_Syn_Deal_Ancillary_Title adrt On t.Title_Code = adrt.Title_Code   
     WHERE adrt.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code  
     ) as a  
     ORDER BY a.Title_Name  
  
     SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))  
       
    UPDATE #TempAncillaryHistory  
    SET [Title_Name] = @Title_Names  
    WHERE AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code  
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
     From Title t   
     Inner Join Syn_Deal_Ancillary_Title adrt On t.Title_Code = adrt.Title_Code   
     WHERE adrt.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code  
     ) as a  
     ORDER BY a.Title_Name  
  
     SET @Title_Names = Substring(@Title_Names, 0, Len(@Title_Names))  
  
     UPDATE #TempAncillaryHistory  
     SET [Title_Name] = @Title_Names  
     WHERE AT_Syn_Deal_Ancillary_Code = 0 AND Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code  
   END  
  
   SET @ISChange = ''  
   SET @ISChange_V1 = 0  
     
   if(@Version != (SELECT RIGHT('000' + cast( MIN(cast(Version as decimal)) as varchar(50)),4) FROM #TempAncillaryHistory WHERE Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code))  
   BEGIN  
      
    select @ISChange =  case when ISNULL(a.Title_Name,'')  != isnull(b.Title_Name,'') then 'Y' else @ISChange end  
    from #TempAncillaryHistory a   
    left join #TempAncillaryHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code   
    AND a.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code and b.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code  
     
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '5,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code   
     AND Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
    /*********************************/  
    select @ISChange =  case when ISNULL(a.Ancillary_Type,'')  != isnull(b.Ancillary_Type,'') then 'Y' else @ISChange end  
    from #TempAncillaryHistory a   
    left join #TempAncillaryHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code   
    AND a.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code and b.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '6,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code   
     AND Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
    /***********************************/  
  
     
    select @ISChange =  case when ISNULL(a.Ancillary_Platform,'')  != isnull(b.Ancillary_Platform,'') then 'Y' else @ISChange end  
    from #TempAncillaryHistory a   
    left join #TempAncillaryHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code AND a.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code and b.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '7,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code   
     AND Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
     
    select @ISChange =  case when ISNULL(a.Ancillary_Platform_Medium,'')  != isnull(b.Ancillary_Platform_Medium,'') then 'Y' else @ISChange end  
    from #TempAncillaryHistory a   
    left join #TempAncillaryHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code AND a.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code and b.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '8,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code   
     AND Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
     
    select @ISChange =  case when ISNULL(a.Duration,'0') != ISNULL(b.Duration,'0') then 'Y' else @ISChange end  
    from #TempAncillaryHistory a   
    left join #TempAncillaryHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code AND a.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code and b.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '9,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code   
     AND Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
  
  
    select @ISChange =  case when ISNULL(a.[Day],'0') != ISNULL(b.[Day],'0') then 'Y' else @ISChange end  
    from #TempAncillaryHistory a   
    left join #TempAncillaryHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code AND a.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code and b.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '10,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code   
     AND Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
     
    select @ISChange =  case when ISNULL(a.Remarks,'')  != isnull(b.Remarks,'') then 'Y' else @ISChange end  
    from #TempAncillaryHistory a   
    left join #TempAncillaryHistory b on a.Version = b.VersionOld  
    where a.Version = @Version and a.AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code AND a.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code and b.Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code AND @ISChange <> 'Y'  
      
    if(@ISChange = 'Y')  
    BEGIN  
     update #TempAncillaryHistory set ChangedColumnIndex = isnull(ChangedColumnIndex, '')  + '11,' where [Index] = @temp and version = @Version  
     and AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code   
     AND Syn_Deal_Ancillary_Code = @Syn_Deal_Ancillary_Code   
     set @ISChange = ''   
     SET @ISChange_V1 = @ISChange_V1 + 1   
    END  
     
    if(@ISChange_V1 > 0)  
    BEGIN  
     UPDATE #TempAncillaryHistory  
     SET Status = 'Modified'  
     WHERE AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code  
      
    END  
   END  
   ELSE  
   BEGIN  
     UPDATE #TempAncillaryHistory  
     SET Status = 'Added'  
     WHERE AT_Syn_Deal_Ancillary_Code = @AT_Syn_Deal_Ancillary_Code  
   END  
   Fetch Next From CUR_Ancillary InTo @AT_Syn_Deal_Ancillary_Code,@Version,@VersionOld,@Syn_Deal_Ancillary_Code, @temp  
  END  
  Close CUR_Ancillary  
  Deallocate CUR_Ancillary  
  SELECT * FROM  #TempAncillaryHistory  
 END  
  
-- Code end for Deal Ancillary History  
	IF OBJECT_ID('tempdb..#TempAncillaryHistory') IS NOT NULL DROP TABLE #TempAncillaryHistory
	IF OBJECT_ID('tempdb..#TempAttachmentHistory') IS NOT NULL DROP TABLE #TempAttachmentHistory
	IF OBJECT_ID('tempdb..#TempDealHistory') IS NOT NULL DROP TABLE #TempDealHistory
	IF OBJECT_ID('tempdb..#TempMaterialHistory') IS NOT NULL DROP TABLE #TempMaterialHistory
	IF OBJECT_ID('tempdb..#TempMovieHistory') IS NOT NULL DROP TABLE #TempMovieHistory
	IF OBJECT_ID('tempdb..#TempPlatformHistory') IS NOT NULL DROP TABLE #TempPlatformHistory
	IF OBJECT_ID('tempdb..#TempPushbackHistory') IS NOT NULL DROP TABLE #TempPushbackHistory
	IF OBJECT_ID('tempdb..#TempRightsHistory') IS NOT NULL DROP TABLE #TempRightsHistory 
END  
  
/*  
--SELECT * FROM Acq_Deal WHERE Agreement_No like 'A-2016-00134'  
--EXEC [dbo].[USP_Get_Version_History] 1288,1,'GENERAL'  
*/

--SELECT * FRom syn_Deal where Deal_Segment_Code is not null
--select parameter_name from system_parameter_new where parameter_name = 'Is_AcqSyn_Gen_Deal_Segment'

--SELECT * FROM Syn_deal where Agreement_No = 'S-2020-00034'

--exec USP_Validate_Rights_Duplication_UDT_Syn