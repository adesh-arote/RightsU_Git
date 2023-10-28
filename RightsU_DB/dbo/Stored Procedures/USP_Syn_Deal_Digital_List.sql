


CREATE Procedure [dbo].[USP_Syn_Deal_Digital_List](@Syn_Deal_Code INT, @Title_Code VARCHAR(MAX), @pageNo int, @pagesize int, @RecordCount Int Out)            
As            
Begin          
        
	Declare @Loglevel int;            
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'            
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[USP_Syn_Deal_Digital_List]', 'Step 1', 0, 'Started Procedure', 0, ''            
             
	SET NOCOUNT ON            
	SET FMTONLY OFF        
	
	if(@PageNo = 0)        
	 Set @PageNo = 1 
          
	If OBJECT_ID('tempdb..#DigDealData') is not null                    
	drop table #DigDealData           
	If OBJECT_ID('tempdb..#tempDigData') is not null                    
	drop table #tempDigData                    
	If OBJECT_ID('tempdb..#tempdata') is not null                    
	drop table #tempdata                    
	If OBJECT_ID('tempdb..#Digital_List_vertical') is not null                    
	drop table #Digital_List_vertical          
	If OBJECT_ID('tempdb..#FinalDataOP') is not null                    
	drop table #FinalDataOP          
           
          
	--Declare @Deal_Code int=5818          
	Declare @Module_Code int=35          
          
	create table #DigDealData (id int identity , ttlcode int,epfrm int,epto int,sndsc int)          
	create table #tempDigData(id int identity,Order_No int,Title_Code int,Episode_From int,Episode_To int,Syn_Deal_Digital_Code int,Digital_Tab_Code int,Digital_Tab_Description varchar(500),Control_Type varchar(50),Digital_Config_Code int,Whr_Criteria varchar(50),tabcountData varchar(5000),tabcount int,actualdatacount int)          
          
	insert into #DigDealData(ttlcode ,epfrm ,epto ,sndsc)          
	SELECT ds.Title_Code, ds.Episode_From,ds.Episode_To, ds.Syn_Deal_Digital_Code                  
	from Syn_Deal_Digital ds  (NOLOCK)                         
	Left join Syn_Deal_Digital_Detail dsd (NOLOCK) on dsd.Syn_Deal_Digital_Code = ds.Syn_Deal_Digital_Code                       
	WHERE ds.Syn_Deal_Code = @Syn_Deal_Code                        
	GROUP BY Title_Code, Episode_From, Episode_To, ds.Syn_Deal_Digital_Code          
          
            
	Declare @ii int =1          
	Declare @ttlcode int ,@epfrm  int ,@epto int ,@sndsc int          
		while((select Count(*) from #DigDealData) >= @ii)          
			Begin          
          
					select @ttlcode=ttlcode ,@epfrm=epfrm ,@epto=epto ,@sndsc=sndsc from #DigDealData where id=@ii          
          
					insert into #tempDigData(Order_No ,Title_Code ,Episode_From ,Episode_To ,Syn_Deal_Digital_Code ,Digital_Tab_Code ,Digital_Tab_Description,Control_Type ,Digital_Config_Code,Whr_Criteria)          
					select dt.Order_No,@ttlcode,@epfrm,@epto,@sndsc,dt.Digital_Tab_Code,dt.Digital_Tab_Description,dc.Control_Type,dc.Digital_Config_Code,dc.Whr_Criteria                     
					from Digital_tab  dt   (NOLOCK)                     
					left join Digital_Config dc  (NOLOCK)  on dc.Digital_Tab_Code=dt.Digital_Tab_Code and  dc.Digital_Config_Code=dt.Key_Config_Code                    
					where dt.module_code=@Module_Code and Is_Show='Y'          
					order by dt.Order_No,dt.Digital_Tab_Code          
          
					set @ii=@ii+1          
			End          
           
          
	Declare @id int =1                    
	Declare @Digital_Config_Code int                     
	Declare @Digital_Tab_Code int                     
	Declare @ControlType varchar(500)                    
	Declare @tabcountData varchar(500)                    
	Declare @tabcount int                    
	Declare @actualdatacount int                    
	Declare @TitleCode int, @EpisodeFrom int, @EpisodeTo int , @Syn_Deal_Digital_Code int                    
          
          
          
		while ((select count(*) from #tempDigData) >= @id )                    
		begin                    
          
		select @Digital_Tab_Code=Digital_Tab_Code,@Digital_Config_Code=Digital_Config_Code,@ControlType=Control_Type,@TitleCode=Title_code from #tempDigData where id=@id                     
          
				if(@ControlType='TXTDDL')                    
						begin                    
          
							select @tabcountData=isnull(count(distinct number),0)            
							from Syn_Deal_Digital dd  (NOLOCK)                     
							left join Syn_Deal_Digital_detail ddd   (NOLOCK)  on   ddd.Syn_Deal_Digital_Code = dd.Syn_Deal_Digital_Code                     
							CROSS APPLY [dbo].[fn_Split_withdelemiter](ISNULL(ddd.Digital_Data_Code, ''), ',')                     
							where  dd.Syn_Deal_Code = @Syn_Deal_Code  and  Digital_Tab_Code=@Digital_Tab_Code           
							and ddd.Digital_Config_Code=@Digital_Config_Code and dd.Title_code=@TitleCode                     
            
							--select @actualdatacount=isnull(count(distinct dd.Digital_Data_Code),0)          
							--from Digital_tab d  (NOLOCK)                 
							--inner join Digital_config dc  (NOLOCK)   on d.Key_Config_Code=dc.Digital_Config_Code             
							--inner  join Digital_Data dd (NOLOCK)   on dd.Digital_Type=dc.Whr_Criteria            
							--where  d.Digital_Tab_Code=@Digital_Tab_Code  and d.Is_Show='Y'  and d.Module_Code=@Module_Code       
							
							select @actualdatacount=isnull(count(distinct mt.Music_Title_Code),0)          
							from Music_Title mt  (NOLOCK)							           
							where  mt.Title_Code=@TitleCode
          
							set @tabcount=isnull(@tabcountData,0)  
							
							PRINT 'TabCount:'+CAST(@tabcount as VARCHAR)
							PRINT 'TabCountData:'+CAST(@tabcountData as VARCHAR)
							PRINT 'ActualCount:'+CAST(@actualdatacount As VARCHAR)
							
						end                      
				else                    
						BEgin                    
          
							declare @tmp varchar(250)                    
							SET @tmp = ''                    
							select @tmp = @tmp + isnull(User_Value,'') + ', '           
							from Syn_Deal_Digital dd  (NOLOCK)                     
							left join Syn_Deal_Digital_Detail ddd  (NOLOCK)  on  ddd.Syn_Deal_Digital_Code = dd.Syn_Deal_Digital_Code                     
							where  dd.Syn_Deal_Code = @Syn_Deal_Code  and  Digital_Tab_Code=@Digital_Tab_Code and ddd.Digital_Config_Code=@Digital_Config_Code          
							and dd.Title_code=@TitleCode          
          
							select @tabcountData=SUBSTRING(@tmp, 0, LEN(@tmp))                    
							set @tabcount=null                    
							set @actualdatacount=null                 
          
						End                    
          
			update #tempDigData set tabcountData=@tabcountData,tabcount=@tabcount,actualdatacount=@actualdatacount where id=@id   and Title_code=@TitleCode                   
          
		set @id=@id+1                    
		End            
          
            --select * from #tempDigData
          
	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''                        
	Select @Selected_Deal_Type_Code = Deal_Type_Code From Syn_Deal WITH(NOLOCK) Where Syn_Deal_Code =  @Syn_Deal_Code                        
	SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)                     
          
	create table #FinalDataOP(id int identity,title_name varchar(500),Digital_Tab_Code int,Digital_Tab_Description varchar(500),Remarks varchar(5000),Title_Code int,Syn_Deal_Digital_Code int, Row_Num int)          
          
	insert into #FinalDataOP( title_name ,Digital_Tab_Code ,Digital_Tab_Description ,Remarks ,Title_Code ,Syn_Deal_Digital_Code, Row_Num )          
	select isnull(DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, Title_Name, Episode_From, Episode_To),'') AS title_name,isnull(st.Digital_Tab_Code,0) ,isnull(st.Digital_Tab_Description,0),                    
	case when  (tabcount is null) then isnull(tabcountData,'') when (tabcount is not null and tabcount=actualdatacount ) then 'Yes' when  (tabcount is not null and tabcount=0)  then 'No' else 'Partial' End DigStatus,isnull(st.Title_Code,0),isnull(st.Syn_Deal_Digital_Code,0)    
	,dense_Rank() over(order by st.Syn_Deal_Digital_Code Asc, st.Syn_Deal_Digital_Code ASC) as Row_Num
	from #tempDigData st                    
	left JOIN Title t (NOLOCK) on t.title_code = st.Title_code                      
	order by st.Digital_Tab_Code,st.Title_Code          
          
        
          --select * from #FinalDataOP
---------------------------------------------------------------------------------------------------------tab config base N o/p---------------------------------         
        
	If OBJECT_ID('tempdb..#tempdata') is not null                    
	drop table #tempdata             

	If OBJECT_ID('tempdb..#finaldata') is not null                    
	drop table #finaldata            
          
	If OBJECT_ID('tempdb..#DigDealDataN') is not null                    
	drop table #DigDealDataN           
          
	If OBJECT_ID('tempdb..#tempDigDataN') is not null                    
	drop table #tempDigDataN                   
          
        
	create table #DigDealDataN (id int identity , ttlcode int,epfrm int,epto int,sndsc int)          
	create table #tempDigDataN(id int identity,Order_No int,Title_Code int,Episode_From int,Episode_To int,Syn_Deal_Digital_Code int,Digital_Tab_Code int,Digital_Tab_Description varchar(500),datacode int)          
          
	insert into #DigDealDataN(ttlcode ,epfrm ,epto ,sndsc)          
	SELECT dd.Title_Code, dd.Episode_From,dd.Episode_To, dd.Syn_Deal_Digital_Code                  
	from Syn_Deal_Digital dd  (NOLOCK)                         
	Left join Syn_Deal_Digital_detail ddd (NOLOCK) on ddd.Syn_Deal_Digital_Code = dd.Syn_Deal_Digital_Code                       
	WHERE dd.Syn_Deal_Code = @Syn_Deal_Code                        
	GROUP BY Title_Code, Episode_From, Episode_To, dd.Syn_Deal_Digital_Code          
          
            
	Declare @in int =1          
         
			while((select Count(*) from #DigDealDataN) >= @in)          
				Begin          
        
					select @ttlcode=ttlcode ,@epfrm=epfrm ,@epto=epto ,@sndsc=sndsc from #DigDealDataN where id=@in          
          
					insert into #tempDigDataN(Order_No ,Title_Code ,Episode_From ,Episode_To ,Syn_Deal_Digital_Code ,Digital_Tab_Code,Digital_Tab_Description,datacode)          
					select t.Order_No,@ttlcode,@epfrm,@epto,@sndsc,t.Digital_Tab_Code,mt.Music_Title_Name,number                     
					from Digital_Tab t (NOLOCK)          
					inner join Digital_Config dc (NOLOCK) on dc.Digital_Tab_Code=t.Digital_Tab_Code          
					cross apply [dbo].[fn_Split_withdelemiter](ISNULL(LP_Digital_Data_Code, ''), ',')          
					--left join Digital_Data (NOLOCK) d on d.Digital_Data_Code=number and d.Digital_Type=dc.Whr_Criteria        
					left join Music_Title (NOLOCK) mt on mt.Music_Title_Code=number
					where t.Is_Show='N' and t.Module_Code=@Module_Code          
          
					set @in=@in+1          
				End          
          
--Declare @Deal_Code int=25970          
          
	create table #tempdata(id int identity,Row_Num int, Digital_Config_Code int, LP_Digital_Data_Code varchar(400), LP_Digital_Value_Config_Code varchar(400) , Title_Code int, Episode_From int, Episode_To int, Syn_Deal_Digital_Code int, Digital_Tab_Code int, Digital_Tab_Description varchar(500), Digital_Data_Code varchar(500), User_Value varchar(5000))          
            
	insert into #tempdata(Row_Num,Digital_Config_Code , LP_Digital_Data_Code, LP_Digital_Value_Config_Code  , Title_Code , Episode_From , Episode_To , Syn_Deal_Digital_Code , Digital_Tab_Code , Digital_Tab_Description , Digital_Data_Code , User_Value )          
            
	SELECT  ddd.Row_Num,dc.Digital_Config_Code,dc.LP_Digital_Data_Code,dc.LP_Digital_Value_Config_Code,          
	Title_Code, Episode_From, Episode_To, dd.Syn_Deal_Digital_Code,ddd.Digital_Tab_Code, dt.Digital_Tab_Description,ddd.Digital_Data_Code Digital_Data_Code ,ddd.User_Value             
	from Syn_Deal_Digital dd  (NOLOCK)             
	inner join Syn_Deal_Digital_detail ddd (NOLOCK) on ddd.Syn_Deal_Digital_Code = dd.Syn_Deal_Digital_Code          
	inner join Digital_Config dc (NOLOCK) on dc.Digital_Config_Code=ddd.Digital_Config_Code          
	inner join Digital_tab dt (NOLOCK) on dt.Digital_Tab_Code = ddd.Digital_Tab_Code --AND ISNULL(dsd.Supplementary_Data_Code, '') <> ''            
	WHERE dd.Syn_Deal_Code = @Syn_Deal_Code and dt.Is_Show='N' and dt.Module_Code=@Module_Code         
          
  --SELECT * from #tempdata          
          
	Declare @i  int=1          
	Declare @datacode varchar(50), @Valuecode varchar(50)          
	Declare @Digi_Data_CodeSyn varchar(500),@user_value varchar(500),@rownm int,@TitleCodeN int,@Digital_tabcodeN int,@Syn_DealDigiCodeN int          
	create table #finaldata(id int identity,datacode int,userval varchar(500),Title_Code int,Syn_Deal_Digital_Code int,Digital_Tab_Code int)          
          
		while(( select Count(*) from #tempdata)>=@i)          
			begin          
          
			select @rownm=row_num ,@datacode=LP_Digital_Data_Code,@Valuecode=LP_Digital_Value_Config_Code,@Digi_Data_CodeSyn=Digital_Data_Code,@user_value=user_value,@TitleCodeN =Title_Code,@Syn_DealDigiCodeN=Syn_Deal_Digital_Code,@Digital_tabcodeN=Digital_tab_code  from #tempdata where id=@i           
			--select number from [dbo].[fn_Split_withdelemiter](ISNULL(@datacode, ''), ',')-- where number in (select number from [dbo].[fn_Split_withdelemiter](ISNULL(@Data_CodeSyn, ''), ','))           
            
				if exists(select number from [dbo].[fn_Split_withdelemiter](ISNULL(@datacode, ''), ',') where number in (select number from [dbo].[fn_Split_withdelemiter](ISNULL(@Digi_Data_CodeSyn, ''), ','))  )          
							Begin          
								declare @tmpN varchar(250)          
								SET @tmpN = ''          
								select @tmpN= @tmpN + user_value + ', '   from #tempdata where  row_num=@rownm and Title_Code=@TitleCodeN           
								and Digital_tab_code=@Digital_tabcodeN and Syn_Deal_Digital_Code=@Syn_DealDigiCodeN           
								and Digital_Config_Code in (select number from [dbo].[fn_Split_withdelemiter](ISNULL(@Valuecode, ''), ','))          
								select @user_value=SUBSTRING(@tmpN, 0, LEN(@tmpN))          
          
								insert into #finaldata(datacode,userval,Title_Code,Syn_Deal_Digital_Code,Digital_Tab_Code)          
								select number,@user_value,@TitleCodeN,@Syn_DealDigiCodeN,@Digital_tabcodeN from [dbo].[fn_Split_withdelemiter](ISNULL(@Digi_Data_CodeSyn, ''), ',')          
							end          
				set @i=@i+1          
			end				        
        
           
	insert into #FinalDataOP( title_name ,Digital_Tab_Code ,Digital_Tab_Description ,Remarks , Title_Code ,Syn_Deal_Digital_Code )          
	select isnull(DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, Title_Name, Episode_From, Episode_To),'') AS title_name,          
	isnull(fm.Digital_Tab_Code,'') ,isnull(fm.Digital_Tab_Description,''), isnull(fm.DigStatus,''),isnull(fm.Title_Code,'') Title_Code,isnull(fm.Syn_Deal_Digital_Code,'')           
	from(          
	select z1.Digital_Tab_Code,z1.Syn_Deal_Digital_Code,z1.Episode_From,z1.Episode_To,z1.Title_code,          
	z1.Digital_Tab_Description ,isnull(z2.userval,'') DigStatus , userval from (          
	select * from #tempDigDataN          
	)z1          
	left join(          
	select datacode,userval,Title_Code,Syn_Deal_Digital_Code,Digital_Tab_Code from #finaldata          
	)z2 on z1.Digital_Tab_Code=z2.Digital_Tab_Code and z1.Title_code=z2.Title_code and           
	z1.Syn_Deal_Digital_Code=z2.Syn_Deal_Digital_Code and  z1.datacode=z2.datacode          
	)fm           
	left JOIN Title t (NOLOCK) on t.title_code = fm.Title_code              
	order by Title_Code,Digital_Tab_Code          
           
	select @RecordCount=count(distinct Title_Code ) from #FinalDataOP 
	--select @RecordCount=Count(distinct Syn_Deal_Digital_Code) from #FinalDataOP
    --select * from #FinalDataOP
	Delete From #FinalDataOP Where Row_Num < (((@PageNo - 1) * @PageSize) + 1) Or Row_Num > @PageNo * @PageSize

	select title_name,Digital_Tab_Code,Digital_Tab_Description,case  isnull(Remarks,'') when '' then 'NA' else Remarks end Remarks,Title_Code,Syn_Deal_Digital_Code from #FinalDataOP          
	group by title_name,Digital_Tab_Code,Digital_Tab_Description,Remarks,Title_Code,Syn_Deal_Digital_Code          
	order by Title_Code,Syn_Deal_Digital_Code        
          
            
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Syn_Deal_Digital_List]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''            
END