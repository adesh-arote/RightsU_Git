CREATE Procedure [dbo].[USP_Acq_Deal_Supplementary_List](@Deal_Code int, @Title_Code varchar(max), @pageNo int, @pagesize int, @RecordCount Int Out)            
As            
Begin            
	SET NOCOUNT ON            
	SET FMTONLY OFF            
            
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Deal_Supplementary_List]', 'Step 1', 0, 'Started Procedure', 0, ''            
            
          
  if(@PageNo = 0)            
   Set @PageNo = 1            
            
	If OBJECT_ID('tempdb..#SupDealData') is not null                  
	 drop table #SupDealData         
	If OBJECT_ID('tempdb..#tempSupData') is not null                  
	 drop table #tempSupData                  
	If OBJECT_ID('tempdb..#tempdata') is not null                  
	 drop table #tempdata                  
	If OBJECT_ID('tempdb..#Supplementary_List_vertical') is not null                  
	 drop table #Supplementary_List_vertical          
	If OBJECT_ID('tempdb..#FinalDataOP') is not null                  
	 drop table #FinalDataOP        
         
        
	--Declare @Deal_Code int=25818        
	Declare @Module_Code int=30        
        
	create table #SupDealData (id int identity , ttlcode int,epfrm int,epto int,acdsc int)        
	create table #tempSupData(id int identity,Order_No int,Title_Code int,Episode_From int,Episode_To int,Acq_Deal_Supplementary_Code int,Supplementary_Tab_Code int,Supplementary_Tab_Description varchar(500),Control_Type varchar(50),Supplementary_Config_Code int,Whr_Criteria varchar(50),tabcountData varchar(5000),tabcount int,actualdatacount int)        
        
	insert into #SupDealData(ttlcode ,epfrm ,epto ,acdsc)        
	SELECT ds.Title_Code, ds.Episode_From,ds.Episode_To, ds.Acq_Deal_Supplementary_Code                
	from Acq_Deal_Supplementary ds  (NOLOCK)                       
	Left join Acq_Deal_Supplementary_detail dsd (NOLOCK) on dsd.Acq_Deal_Supplementary_Code = ds.Acq_Deal_Supplementary_Code                     
	WHERE ds.Acq_Deal_Code = @Deal_Code                      
	GROUP BY Title_Code, Episode_From, Episode_To, ds.Acq_Deal_Supplementary_Code        
         
	Declare @ii int =1        
	Declare @ttlcode int ,@epfrm  int ,@epto int ,@acdsc int        
	
		while((select Count(*) from #SupDealData) >= @ii)        
		Begin  

			select @ttlcode=ttlcode ,@epfrm=epfrm ,@epto=epto ,@acdsc=acdsc from #SupDealData where id=@ii        
        
			insert into #tempSupData(Order_No ,Title_Code ,Episode_From ,Episode_To ,Acq_Deal_Supplementary_Code ,Supplementary_Tab_Code ,Supplementary_Tab_Description,Control_Type ,Supplementary_Config_Code,Whr_Criteria)        
			select st.Order_No,@ttlcode,@epfrm,@epto,@acdsc,st.Supplementary_Tab_Code,st.Supplementary_Tab_Description,sc.Control_Type,sc.Supplementary_Config_Code,sc.Whr_Criteria                   
			from Supplementary_tab  st   (NOLOCK)                   
			left join Supplementary_Config sc  (NOLOCK)  on sc.Supplementary_Tab_Code=st.Supplementary_Tab_Code and  sc.Supplementary_Config_Code=st.Key_Config_Code                  
			where st.module_code=@Module_Code and Is_Show='Y'        
			order by st.Order_No,st.Supplementary_Tab_Code           
			set @ii=@ii+1        
		End        
        
        
	Declare @id int =1                  
	Declare @Supplementary_Config_Code int                   
	Declare @Supplementary_Tab_Code int                   
	Declare @ControlType varchar(500)                  
	Declare @tabcountData varchar(500)                  
	Declare @tabcount int                  
	Declare @actualdatacount int                  
	Declare @TitleCode int, @EpisodeFrom int, @EpisodeTo int , @Acq_Deal_Supplementary_Code int                  
        
                 
			while ((select count(*) from #tempSupData) >= @id )                  
			  begin                  
			   select @Supplementary_Tab_Code=Supplementary_Tab_Code,@Supplementary_Config_Code=Supplementary_Config_Code,@ControlType=Control_Type,@TitleCode=Title_code from #tempSupData where id=@id                   
        
				if(@ControlType='TXTDDL')                  
					begin                  
        
							select @tabcountData=isnull(count(distinct number),0)          
							from Acq_Deal_Supplementary ds  (NOLOCK)                   
							left join Acq_Deal_Supplementary_detail dsd   (NOLOCK)  on   dsd.Acq_Deal_Supplementary_Code = ds.Acq_Deal_Supplementary_Code                   
							CROSS APPLY [dbo].[fn_Split_withdelemiter](ISNULL(dsd.Supplementary_Data_Code, ''), ',')                   
							where  ds.Acq_Deal_Code = @Deal_Code  and  Supplementary_Tab_Code=@Supplementary_Tab_Code         
							and dsd.Supplementary_Config_Code=@Supplementary_Config_Code and ds.Title_code=@TitleCode                   
        
							select @actualdatacount=isnull(count(distinct dd.supplementary_Data_Code),0)        
							from supplementary_tab d  (NOLOCK)               
							inner join supplementary_config dc  (NOLOCK)   on d.Key_Config_Code=dc.supplementary_Config_Code           
							inner  join supplementary_Data dd (NOLOCK)   on dd.supplementary_Type=dc.Whr_Criteria          
							where  d.supplementary_Tab_Code=@supplementary_Tab_Code  and d.Is_Show='Y'  and d.Module_Code=@Module_Code         
        
					set @tabcount=isnull(@tabcountData,0)                  
				   end                    
				else                  
					BEgin                  
        
						 declare @tmp varchar(250)                  
						 SET @tmp = ''                  
						 select @tmp = @tmp + isnull(User_Value,'') + ', '         
						 from Acq_Deal_Supplementary ds  (NOLOCK)                   
						 left join Acq_Deal_Supplementary_Detail dsd  (NOLOCK)  on  dsd.Acq_Deal_Supplementary_Code = ds.Acq_Deal_Supplementary_Code                   
						 where  ds.Acq_Deal_Code = @Deal_Code  and  Supplementary_Tab_Code=@Supplementary_Tab_Code and dsd.Supplementary_Config_Code=@Supplementary_Config_Code        
						 and ds.Title_code=@TitleCode        
        
						 select @tabcountData=SUBSTRING(@tmp, 0, LEN(@tmp))                  
						 set @tabcount=null                  
						 set @actualdatacount=null               
        
					End                  
        
				update #tempSupData set tabcountData=@tabcountData,tabcount=@tabcount,actualdatacount=@actualdatacount where id=@id   and Title_code=@TitleCode                         
			  set @id=@id+1                  
			  End          
        
         
        
	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''                      
	Select @Selected_Deal_Type_Code = Deal_Type_Code From Acq_Deal WITH(NOLOCK) Where Acq_Deal_Code =  @Deal_Code                      
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)                   
        
	create table #FinalDataOP(id int identity,title_name varchar(500),Supplementary_Tab_Code int,Supplementary_Tab_Description varchar(500),Remarks varchar(5000),Title_Code int,Acq_Deal_Supplementary_Code int, Row_Num int)        
        
	insert into #FinalDataOP( title_name ,Supplementary_Tab_Code ,Supplementary_Tab_Description ,Remarks ,Title_Code ,Acq_Deal_Supplementary_Code, Row_Num )        
	select isnull(DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, Title_Name, Episode_From, Episode_To),'') AS title_name,isnull(st.Supplementary_Tab_Code,0) ,isnull(st.Supplementary_Tab_Description,0),                  
	case when  tabcount is null  then isnull(tabcountData,'') when (tabcount is not null and tabcount=actualdatacount ) then 'Yes' when  (tabcount is not null and tabcount=0 )  then 'No' else 'Partial' End SupStatus,isnull(st.Title_Code,0),isnull(st.Acq_Deal_Supplementary_Code,0)   
	,dense_Rank() over(order by st.Acq_Deal_Supplementary_Code Asc, st.Acq_Deal_Supplementary_Code ASC) as Row_Num
	from #tempSupData st                  
	left JOIN Title t (NOLOCK) on t.title_code = st.Title_code                    
	order by st.Supplementary_Tab_Code,st.Title_Code        
        
        
        
	---------------------------------------------------------------------------------------------------------tab config base N o/p---------------------------------        
        
        
	If OBJECT_ID('tempdb..#tempdata') is not null                  
	drop table #tempdata              
	If OBJECT_ID('tempdb..#finaldata') is not null                  
	drop table #finaldata               
	If OBJECT_ID('tempdb..#SupDealDataN') is not null                  
	drop table #SupDealDataN              
	If OBJECT_ID('tempdb..#tempSupDataN') is not null                  
	drop table #tempSupDataN                 
          
	create table #SupDealDataN (id int identity , ttlcode int,epfrm int,epto int,acdsc int)        
	create table #tempSupDataN(id int identity,Order_No int,Title_Code int,Episode_From int,Episode_To int,Acq_Deal_Supplementary_Code int,Supplementary_Tab_Code int,Supplementary_Tab_Description varchar(500),datacode int)        
        
	insert into #SupDealDataN(ttlcode ,epfrm ,epto ,acdsc)        
	SELECT ds.Title_Code, ds.Episode_From,ds.Episode_To, ds.Acq_Deal_Supplementary_Code                
	from Acq_Deal_Supplementary ds  (NOLOCK)                       
	Left join Acq_Deal_Supplementary_detail dsd (NOLOCK) on dsd.Acq_Deal_Supplementary_Code = ds.Acq_Deal_Supplementary_Code                     
	WHERE ds.Acq_Deal_Code = @Deal_Code                      
	GROUP BY Title_Code, Episode_From, Episode_To, ds.Acq_Deal_Supplementary_Code        
        
          
	Declare @in int =1        
	--Declare @ttlcode int ,@epfrm  int ,@epto int ,@acdsc int        
			while((select Count(*) from #SupDealDataN) >= @in)        
			Begin        
				select @ttlcode=ttlcode ,@epfrm=epfrm ,@epto=epto ,@acdsc=acdsc from #SupDealDataN where id=@in        
        
				insert into #tempSupDataN(Order_No ,Title_Code ,Episode_From ,Episode_To ,Acq_Deal_Supplementary_Code ,Supplementary_Tab_Code,Supplementary_Tab_Description,datacode)        
				select t.Order_No,@ttlcode,@epfrm,@epto,@acdsc,t.Supplementary_Tab_Code,d.Data_Description,number                   
				from Supplementary_Tab t (NOLOCK)       
				inner join Supplementary_Config sc (NOLOCK)  on sc.Supplementary_Tab_Code=t.Supplementary_Tab_Code        
				cross apply [dbo].[fn_Split_withdelemiter](ISNULL(LP_Supplementary_Data_Code, ''), ',')        
				left join Supplementary_Data d on d.Supplementary_Data_Code=number and d.Supplementary_Type=sc.Whr_Criteria        
				where t.Is_Show='N'  and t.Module_Code=@Module_Code       
        
				set @in=@in+1        
			End        
        
	--Declare @Deal_Code int=25970        
        
		create table #tempdata(id int identity,Row_Num int, Supplementary_Config_Code int, LP_Supplementary_Data_Code varchar(400), LP_Supplementary_Value_Config_Code varchar(400) , Title_Code int, Episode_From int, Episode_To int, Acq_Deal_Supplementary_Code int,Supplementary_Tab_Code int, Supplementary_Tab_Description varchar(500), Supplementary_Data_Code varchar(500), User_Value varchar(5000))        
          
		insert into #tempdata(Row_Num,Supplementary_Config_Code , LP_Supplementary_Data_Code, LP_Supplementary_Value_Config_Code  , Title_Code , Episode_From , Episode_To , Acq_Deal_Supplementary_Code , Supplementary_Tab_Code , Supplementary_Tab_Description , Supplementary_Data_Code , User_Value )        
		SELECT  dsd.Row_Num,sc.Supplementary_Config_Code,sc.LP_Supplementary_Data_Code,sc.LP_Supplementary_Value_Config_Code,        
		Title_Code, Episode_From, Episode_To, ds.Acq_Deal_Supplementary_Code,dsd.Supplementary_Tab_Code, st.Supplementary_Tab_Description,dsd.Supplementary_Data_Code Supplementary_Data_Code ,dsd.User_Value           
		from Acq_Deal_Supplementary ds  (NOLOCK)           
		inner join Acq_Deal_Supplementary_detail dsd (NOLOCK) on dsd.Acq_Deal_Supplementary_Code = ds.Acq_Deal_Supplementary_Code        
		inner join Supplementary_Config sc on sc.Supplementary_Config_Code=dsd.Supplementary_Config_Code        
		inner join Supplementary_tab st (NOLOCK) on st.Supplementary_Tab_Code = dsd.Supplementary_Tab_Code --AND ISNULL(dsd.Supplementary_Data_Code, '') <> ''          
		WHERE ds.Acq_Deal_Code = @Deal_Code and st.Is_Show='N'        
        
	  --SELECT * from #tempdata        
        
	  Declare @i  int=1        
	  Declare @datacode varchar(50), @Valuecode varchar(50)        
	  Declare @Supp_Data_CodeAcq varchar(500),@user_value varchar(500),@rownm int,@TitleCodeN int,@Supplementary_tabcodeN int,@Acq_DealSuppCodeN int        
		create table #finaldata(id int identity,datacode int,userval varchar(500),Title_Code int,Acq_Deal_Supplementary_Code int,Supplementary_Tab_Code int)        
        
		  while(( select Count(*) from #tempdata)>=@i)        
		  begin        
        
				select @rownm=row_num ,@datacode=LP_Supplementary_Data_Code,@Valuecode=LP_Supplementary_Value_Config_Code,@Supp_Data_CodeAcq=Supplementary_Data_Code,@user_value=user_value,@TitleCodeN =Title_Code,@Acq_DealSuppCodeN=Acq_Deal_Supplementary_Code,@Supplementary_tabcodeN=Supplementary_tab_code  from #tempdata where id=@i         
				--select number from [dbo].[fn_Split_withdelemiter](ISNULL(@datacode, ''), ',')-- where number in (select number from [dbo].[fn_Split_withdelemiter](ISNULL(@Data_CodeAcq, ''), ','))         
          
			  if exists(select number from [dbo].[fn_Split_withdelemiter](ISNULL(@datacode, ''), ',') where number in (select number from [dbo].[fn_Split_withdelemiter](ISNULL(@Supp_Data_CodeAcq, ''), ','))  )        
				  Begin        
					   declare @tmpN varchar(250)        
        
					   SET @tmpN = ''        
					   select @tmpN= @tmpN + user_value + ', '   from #tempdata where  row_num=@rownm and Title_Code=@TitleCodeN         
					   and Supplementary_tab_code=@Supplementary_tabcodeN and Acq_Deal_Supplementary_Code=@Acq_DealSuppCodeN         
					   and Supplementary_Config_Code in (select number from [dbo].[fn_Split_withdelemiter](ISNULL(@Valuecode, ''), ','))        
					   select @user_value=SUBSTRING(@tmpN, 0, LEN(@tmpN))        
        
					   insert into #finaldata(datacode,userval,Title_Code,Acq_Deal_Supplementary_Code,Supplementary_Tab_Code)        
					   select number,@user_value,@TitleCodeN,@Acq_DealSuppCodeN,@Supplementary_tabcodeN from [dbo].[fn_Split_withdelemiter](ISNULL(@Supp_Data_CodeAcq, ''), ',')        
				  end        
			  set @i=@i+1        
		  end        
        
               
          
		insert into #FinalDataOP( title_name ,Supplementary_Tab_Code ,Supplementary_Tab_Description ,Remarks , Title_Code ,Acq_Deal_Supplementary_Code )        
		select isnull(DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, Title_Name, Episode_From, Episode_To),'') AS title_name,        
		isnull(fm.Supplementary_Tab_Code,'') ,isnull(fm.Supplementary_Tab_Description,''), isnull(fm.SupStatus,''),isnull(fm.Title_Code,'') Title_Code,isnull(fm.Acq_Deal_Supplementary_Code,'')         
		from(        
		select z1.Supplementary_Tab_Code,z1.Acq_Deal_Supplementary_Code,z1.Episode_From,z1.Episode_To,z1.Title_code,        
		z1.Supplementary_Tab_Description ,isnull(z2.userval,'') SupStatus , userval from (        
		select * from #tempSupDataN        
		)z1        
		left join(        
		select datacode,userval,Title_Code,Acq_Deal_Supplementary_Code,Supplementary_Tab_Code from #finaldata        
		)z2 on z1.Supplementary_Tab_Code=z2.Supplementary_Tab_Code and z1.Title_code=z2.Title_code and         
		z1.Acq_Deal_Supplementary_Code=z2.Acq_Deal_Supplementary_Code and  z1.datacode=z2.datacode        
		)fm         
		left JOIN Title t (NOLOCK) on t.title_code = fm.Title_code            
		order by Title_Code,Supplementary_Tab_Code        
         
		--select @RecordCount=Count(distinct Title_Code) from #FinalDataOP  
		select @RecordCount=Count(distinct Acq_Deal_Supplementary_Code) from #FinalDataOP
    
		Delete From #FinalDataOP Where Row_Num < (((@PageNo - 1) * @PageSize) + 1) Or Row_Num > @PageNo * @PageSize

		select title_name,Supplementary_Tab_Code,Supplementary_Tab_Description,case  isnull(Remarks,'') when '' then 'NA' else Remarks end Remarks ,Title_Code,Acq_Deal_Supplementary_Code from #FinalDataOP        
		group by title_name,Supplementary_Tab_Code,Supplementary_Tab_Description,Remarks,Title_Code,Acq_Deal_Supplementary_Code        
		order by Title_Code,Acq_Deal_Supplementary_Code        
            
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Acq_Deal_Supplementary_List]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''            
END