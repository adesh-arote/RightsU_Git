CREATE PROCEDURE [dbo].[USP_Title_Report_Details]      
	@DealTypeCode  INT ,      
	@TitleName NVARCHAR(2000),  
	@OriginalTitleName NVARCHAR(MAX) = '' ,        
	@AdvanceSearch NVARCHAR(MAX)=''    
AS      
-- =============================================
-- Author:		Akshay R Rane
-- Create DATE: 22 Aug 2018
-- Description:	Title Report
-- ============================================= 

BEGIN  
	SET FMTONLY OFF
	SET NOCOUNT ON 
	Declare @Loglevel int  
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Title_Report_Details]', 'Step 1', 0, 'Started Procedure', 0, ''   
		--DECLARE  
		--@DealTypeCode  INT ,      
		--@TitleName NVARCHAR(2000),  
		--@OriginalTitleName NVARCHAR(MAX) ,          
		--@OriginalTitleName NVARCHAR(MAX) ,          
		--@AdvanceSearch NVARCHAR(MAX)    

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
		IF OBJECT_ID('tempdb..#ExtendedColumn') IS NOT NULL DROP TABLE #ExtendedColumn
		IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput 
		IF OBJECT_ID('tempdb..#GroupwiseExtendedColumn') IS NOT NULL DROP TABLE #GroupwiseExtendedColumn 

		CREATE TABLE #Temp(      
				Id Int Identity(1,1),      
				RowId Varchar(200),  
				Title_Name  nvarchar(MAX) null,  
				Deal_Type_Name varchar(MAX) null,
				Language_Name nvarchar(MAX) null, 
				Original_Title nvarchar(MAX) null,
				Original_Language Varchar(200),
				[Program_Name] nvarchar(MAX) null,
				Year_Of_Production int null,
				Synopsis nvarchar(MAX) null,
				Duration_In_Min decimal(18,2) null,
				CountryName nvarchar(MAX) null,
				TalentName nvarchar(MAX) null,
				Producer nvarchar(MAX) null,
				Director nvarchar(MAX) null,
				Genres_Name nvarchar(MAX) null,
				Sort varchar(10),  
				Row_Num Int,  
				Last_Updated_Time datetime
			);    
		 

		DECLARE @Condition NVARCHAR(MAX) = ' AND ISNULL(T.Reference_Key,'''') = '''' AND  ISNULL(T.Reference_Flag,'''') = '''' '      
		DECLARE @delimt NVARCHAR(2) = N',', @SqlPageNo NVARCHAR(MAX) , @Sql NVARCHAR(MAX)  ,@SqlAdditionalColumns NVARCHAR(MAX)   
      
		IF(@TitleName != '')      
			SET @Condition  += ' AND T.Title_code in (select Title_Code from Title where Title_Name IN (SELECT number FROM fn_Split_withdelemiter(N'''+@TitleName+''', N'''+ @delimt +''') where number != ''''))'      

         
		IF(@OriginalTitleName != '')      
			SET @Condition  += ' AND T.Title_code in (select Title_Code FROM Title WHERE Original_Title IN (SELECT number FROM fn_Split_withdelemiter(N'''+@OriginalTitleName+''', N'''+ @delimt +''') WHERE number != '''')) '      
  
		IF(@AdvanceSearch != '')  
			SET @AdvanceSearch =' ' 

		IF (@DealTypeCode > 0)      
			SET @Condition  += ' AND DT.Deal_Type_code in('+ cast(@DealTypeCode AS VARCHAR(max))+')'      
  
		SET @Condition  += ' '      
      
		SET @SqlPageNo = 'WITH Y AS (Select distinct X.Title_Code,X.Title_Name,X.Language_Name,X.Last_UpDated_Time,X.Deal_Type_Name,X.Original_Title,X.Year_Of_Production,X.Program_Name,X.Synopsis,X.Duration_In_Min,X.Original_Language,X.CountryName,X.TalentName,X.Producer,X.Director,X.Genres_Name From      
								( select * from ( select distinct T.Title_Code, T.Original_Title, T.Title_Name, T.Title_Code_Id, T.Synopsis, T.Original_Language_Code, T.Title_Language_Code,      
												T.Year_Of_Production,P.Program_Name, T.Duration_In_Min, T.Deal_Type_Code, T.Grade_Code, T.Reference_Key, T.Reference_Flag, T.Is_Active,      
												T.Inserted_By, T.Inserted_On, T.Last_UpDated_Time, T.Last_Action_By, T.Lock_Time, T.Title_Image, L.Language_Name,DT.Deal_Type_Name,OL.Language_Name AS ''Original_Language'',
												REVERSE(stuff(reverse(stuff((         
										select distinct cast(C.Country_Name  as NVARCHAR(MAX)) + '', '' from Title_Country TC (NOLOCK)     
										inner join Country C (NOLOCK) on C.Country_Code = TC.Country_Code      
										where TC.Title_Code = T.Title_Code      
										FOR XML PATH(''''), root(''CountryName''), type      
										).value(''/CountryName[1]'',''Nvarchar(max)''      
									 ),2,0, '''') ),1,2,'''')) as CountryName,
									 REVERSE(stuff(reverse(  stuff(      
									(  select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT  (NOLOCK)  
										inner join Role R  (NOLOCK) on R.Role_Code = TT.Role_Code      
										inner join Talent Tal (NOLOCK) on tal.talent_Code = TT.Talent_code      
										where TT.Title_Code = T.Title_Code AND R.Role_Code in (2)      
										FOR XML PATH(''''), root(''TalentName''), type      
									 ).value(''/TalentName[1]'',''NVARCHAR(max)''      
							    	),1,0, '''' )),1,2,'''')) as TalentName,
									REVERSE(stuff(reverse(  stuff((select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT  (NOLOCK)     
										inner join Role R  (NOLOCK) on R.Role_Code = TT.Role_Code      
										inner join Talent Tal (NOLOCK) on tal.talent_Code = TT.Talent_code      
										where TT.Title_Code = T.Title_Code AND R.Role_Code in (4)      
										FOR XML PATH(''''), root(''Producer''), type      
									).value(''/Producer[1]'',''NVARCHAR(max)''),1,0, '''' )),1,2,'''')) as Producer,
								  REVERSE(stuff(reverse(  stuff(( select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT  (NOLOCK)     
										inner join Role R (NOLOCK) on R.Role_Code = TT.Role_Code      
										inner join Talent Tal (NOLOCK) on tal.talent_Code = TT.Talent_code      
										where TT.Title_Code = T.Title_Code AND R.Role_Code in (1)      
										FOR XML PATH(''''), root(''Director''), type      
									).value(''/Director[1]'',''NVARCHAR(max)''),1,0, '''')),1,2,'''')) as Director,[dbo].[UFN_Get_Title_Genre](T.Title_Code) as Genres_Name
										from Title T (NOLOCK)
												INNER join Deal_Type DT (NOLOCK) on DT.Deal_Type_Code = T.Deal_Type_Code  
			                                    INNER join Language L (NOLOCK) on T.Title_Language_Code = L.Language_Code  
												LEFT join [Language] OL (NOLOCK) on T.Original_Language_Code  = OL.Language_Code   
												LEFT join Title_Country TC (NOLOCK) on T.Title_Code = TC.Title_Code 
			                                    LEFT JOIN Program P (NOLOCK) ON T.Program_Code = P.Program_Code  				
												where 1=1 '+ @Condition +'  '+@AdvanceSearch+'  
                                               )as XYZ Where 1 = 1 )as X  )   
							Insert InTo #Temp select Title_Code,Title_Name,Deal_Type_Name,Language_Name, Original_Title,Original_Language,Program_Name,Year_Of_Production,Synopsis,Duration_In_Min,CountryName,TalentName,Producer,Director,Genres_Name,''1'','' '',Last_UpDated_Time From Y'
			
		EXEC (@SqlPageNo)   
	    
		--print @SqlPageNo

		CREATE TABLE #TempOutput
	     (
	        TL_1 VARCHAR(500),
			TL_2 VARCHAR(500),
			TL_3 VARCHAR(500),
			TL_4 VARCHAR(500),
			TL_5 VARCHAR(500),
			TL_6 VARCHAR(500),
			TL_7 VARCHAR(500),
			TL_8 VARCHAR(500),
			TL_9 VARCHAR(500),
			TL_10 VARCHAR(500),
			TL_11 VARCHAR(500),
			TL_12 VARCHAR(500),
			TL_13 VARCHAR(500),
			TL_14 VARCHAR(500),
			TL_15 VARCHAR(500),
			TL_16 VARCHAR(500),
			TL_17 VARCHAR(500),
			TL_18 VARCHAR(500),
			TL_19 VARCHAR(500),
			TL_20 VARCHAR(500),
			TL_21 VARCHAR(500),
			TL_22 VARCHAR(500),
			TL_23 VARCHAR(500),
			TL_24 VARCHAR(500),
			TL_25 VARCHAR(500),
			TL_26 VARCHAR(500),
			TL_27 VARCHAR(500),
			TL_28 VARCHAR(500),
			TL_29 VARCHAR(500),
			TL_30 VARCHAR(500),
			TL_31 VARCHAR(500),
			TL_32 VARCHAR(500),
			TL_33 VARCHAR(500),
			TL_34 VARCHAR(500),
			TL_35 VARCHAR(500),
			TL_36 VARCHAR(500),
			TL_37 VARCHAR(500),
			TL_38 VARCHAR(500),
			TL_39 VARCHAR(500),
			TL_40 VARCHAR(500),
			TL_41 VARCHAR(500),
			TL_42 VARCHAR(500),
			TL_43 VARCHAR(500),
			TL_44 VARCHAR(500),
			TL_45 VARCHAR(500),
			TL_46 VARCHAR(500),
			TL_47 VARCHAR(500),
			TL_48 VARCHAR(500),
			TL_49 VARCHAR(500),
			TL_50 VARCHAR(500)
			,TL_51 VARCHAR(500),
			TL_52 VARCHAR(500),
			TL_53 VARCHAR(500),
			TL_54 VARCHAR(500),
			TL_55 VARCHAR(500),
			TL_56 VARCHAR(500),
			TL_57 VARCHAR(500),
			TL_58 VARCHAR(500),
			TL_59 VARCHAR(500),
			TL_60 VARCHAR(500),
			TL_61 VARCHAR(500),
			TL_62 VARCHAR(500),
			TL_63 VARCHAR(500),
			TL_64 VARCHAR(500),
			TL_65 VARCHAR(500),
			TL_66 VARCHAR(500),
			TL_67 VARCHAR(500),
			TL_68 VARCHAR(500),
			TL_69 VARCHAR(500),
			TL_70 VARCHAR(500),
			TL_71 VARCHAR(500),
			TL_72 VARCHAR(500),
			TL_73 VARCHAR(500),
			TL_74 VARCHAR(500),
			TL_75 VARCHAR(500),
			TL_76 VARCHAR(500),
			TL_77 VARCHAR(500),
			TL_78 VARCHAR(500),
			TL_79 VARCHAR(500),
			TL_80 VARCHAR(500),
			TL_81 VARCHAR(500),
			TL_82 VARCHAR(500),
			TL_83 VARCHAR(500),
			TL_84 VARCHAR(500),
			TL_85 VARCHAR(500),
			TL_86 VARCHAR(500),
			TL_87 VARCHAR(500),
			TL_88 VARCHAR(500),
			TL_89 VARCHAR(500),
			TL_90 VARCHAR(500),
			TL_91 VARCHAR(500),
			TL_92 VARCHAR(500),
			TL_93 VARCHAR(500),
			TL_94 VARCHAR(500),
			TL_95 VARCHAR(500),
			TL_96 VARCHAR(500),
			TL_97 VARCHAR(500),
			TL_98 VARCHAR(500),
			TL_99 VARCHAR(500),
			TL_100 VARCHAR(500)
	       )


		   CREATE TABLE #ExtendedColumn(
		   Columns_Code Int,
		   Columns_Name VARCHAR(200),
		   Column_Value VARCHAR(200),
		   Ref_Table VARCHAR(200),
		   Control_Type VARCHAR(200),
		   Extended_Group_Code Int,
		   Group_Name VARCHAR(200),
		   Header_Name VARCHAR(200)
		   )

		    CREATE TABLE #GroupwiseExtendedColumn(
			Id int identity(1,1),
		   Columns_Code Int,
		   Columns_Name VARCHAR(200),
		   Group_Name VARCHAR(200)
		   )

		    Insert Into #ExtendedColumn(Columns_Code,Columns_Name,Header_Name)
		  Values(0,'Title_Name','Title Name'),(0,'Deal_Type_Name','Title Type'),(0,'Language_Name','Language Name'),(0,'Original_Title','Original Title'),(0,'Original_Language','Original Language'),(0,'Program_Name','Program Name'),(0,'Duration_In_Min','Duration In Min'),
		   (0,'Year_Of_Production','Year Of Production'),(0,'TalentName','TalentName'),(0,'Director','Director'),(0,'Producer','Producer'),(0,'Genres_Name','Genres Name'),(0,'CountryName','CountryName'),(0,'Synopsis','Synopsis');
		   
		   --Insert Into #ExtendedColumn(Columns_Code,Columns_Name,Ref_Table,Control_Type)
		   --select distinct EC.Columns_Code,EC.Columns_Name,EC.Ref_Table,EC.Control_Type from Map_Extended_Columns MEC
           --      Left join Extended_Group_Config EGC On MEC.Columns_Code = EGC.Columns_Code  
           --      left Join Extended_Columns EC On Ec.Columns_Code = MEC.Columns_Code
           --      left join Extended_Group EG  On EGC.Extended_Group_Code = EG.Extended_Group_Code 
           -- Where MEC.Record_Code in (select RowId from #Temp)
	       --select EGC.Columns_Code,EC.Columns_Name,EC.Ref_Table,EC.Control_Type,EGC.Extended_Group_Code,EC.Columns_Name from Extended_Group EG
		   --Inner Join Extended_Group_Config EGC On EG.Extended_Group_Code = EGC.Extended_Group_Code
		   --Inner Join Extended_Columns EC On EC.Columns_Code = EGC.Columns_Code
		   --where EG.Module_Code = (select Top 1 Module_Code from System_Module where Module_Name = 'Title List') and EGC.Is_Active  = 'Y'  and EG.IsActive = 'Y'
		   --Order by EGC.Extended_Group_Code

		   Insert Into #ExtendedColumn(Columns_Code,Columns_Name,Ref_Table,Control_Type,Extended_Group_Code,Header_Name)
		   select EGC.Columns_Code,EC.Columns_Name,EC.Ref_Table,EC.Control_Type,EGC.Extended_Group_Code,EC.Columns_Name from Extended_Group EG
		   Inner Join Extended_Group_Config EGC On EG.Extended_Group_Code = EGC.Extended_Group_Code
		   Inner Join Extended_Columns EC On EC.Columns_Code = EGC.Columns_Code
		   -- Left Join Map_Extended_Columns MEC On MEC.Record_Code in (48124,48125,48126,49147) and MEC.Columns_Code = EC.Columns_Code 
		   OUTER APPLY ( SELECT TOP 1 *  from Map_Extended_Columns where Record_Code in ((select RowId from #Temp)) and Columns_Code = EC.Columns_Code ) MEC
		   where EG.Module_Code = (select Top 1 Module_Code from System_Module where Module_Name = 'Title List') and EGC.Is_Active  = 'Y' and EG.IsActive = 'Y'
		   Order by  EGC.Extended_Group_Code,MEC.Map_Extended_Columns_Code
		   


		 
		     INSERT INTO #TempOutput(TL_1, TL_2, TL_3, TL_4, TL_5, TL_6, TL_7, TL_8, TL_9, TL_10, TL_11, TL_12, TL_13, TL_14, TL_15, TL_16, TL_17, TL_18, TL_19, TL_20, TL_21, TL_22, TL_23, TL_24, TL_25, TL_26, TL_27, TL_28, TL_29, TL_30, TL_31, TL_32, TL_33, TL_34, TL_35, TL_36, TL_37, TL_38, TL_39, TL_40, TL_41, TL_42, TL_43, TL_44, TL_45, TL_46, TL_47, TL_48, TL_49, TL_50
			 ,TL_51,TL_52,TL_53,TL_54,TL_55,TL_56,TL_57,TL_58,TL_59,TL_60,TL_61,TL_62,TL_63,TL_64,TL_65,TL_66,TL_67,TL_68,TL_69,TL_70,TL_71,TL_72,TL_73,TL_74,TL_75,TL_76,TL_77,TL_78,TL_79,TL_80,TL_81,TL_82,TL_83,TL_84,TL_85,TL_86,TL_87,TL_88,TL_89,TL_90,TL_91,TL_92,TL_93,TL_94,TL_95,TL_96,TL_97,TL_98,TL_99,TL_100
			 )
				Select *
				from (
				    Select Header_Name, RowN = Row_Number() over (ORDER BY (SELECT NULL)) from #ExtendedColumn 
				) a
				pivot (max(Header_Name) for RowN in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50]
				, [51], [52], [53], [54], [55], [56], [57], [58], [59], [60], [61], [62], [63], [64], [65], [66], [67], [68], [69], [70], [71], [72], [73], [74], [75], [76], [77], [78], [79], [80], [81], [82], [83], [84], [85], [86], [87], [88], [89], [90], [91], [92], [93], [94], [95], [96], [97], [98],[99],[100]
				)) p
		
		Declare @count Int;
	    set @count = 1;
		Declare @Record_Code int;

		while @count <= (select count(Id) from #Temp)
		begin
		
		 set @Record_Code = cast((select RowId from #Temp where Id = @count) as Int)
		-- print @Record_Code
		      
		     Insert Into #GroupwiseExtendedColumn
		     select Columns_Code,Columns_Name,Group_Name from #ExtendedColumn 

		     Declare @row Int
			 set @row = 1;

		     while @row <= (Select count(Id) from #GroupwiseExtendedColumn)
			 Begin 
				
				   Declare @Map_Extended_columns_Code Int, @ColumnCode Int,@Control_Type Nvarchar(200),@Is_Multiple Nvarchar(200),@TrimColumnName Nvarchar(50);
				   DECLARE @sqlCommand NVARCHAR(MAX) =''
                   DECLARE @ColumnValue  NVARCHAR(Max) =''
                   DECLARE @ColumnName NVARCHAR(MAX) =''
				   
				  Set @ColumnCode = (select Columns_Code from #GroupwiseExtendedColumn where ID = @row)
				   Set @ColumnName = (select Columns_Name from #GroupwiseExtendedColumn where ID = @row)
				   --set @Map_Extended_columns_Code = (select Map_Extended_columns_Code from Map_Extended_Columns where Record_Code = @Record_Code and Columns_Code = @ColumnCode)
			       set @Control_Type = (select Control_Type from Extended_Columns where Columns_Code = @ColumnCode);
				   Set @Is_Multiple = (select Is_Multiple_Select from Extended_Columns where Columns_Code = @ColumnCode);

				  Set @TrimColumnName = replace(@ColumnName,' ','')
				   Set @TrimColumnName =  REPLACE(@TrimColumnName,'(','')
			      Set @TrimColumnName =  REPLACE(@TrimColumnName,')','')
				  --print @TrimColumnName
				  
				  if( @Control_Type = 'DDL' and @Is_Multiple = 'Y')
				  begin
				      
					  Declare @Ref_Table Varchar(200),@Ref_Display_Field Varchar(200),@Ref_Value_field Varchar(200);
				        select @Ref_Table = Ref_Table,@Ref_Display_Field = Ref_Display_Field,@Ref_Value_field = Ref_Value_field from Extended_Columns where Columns_Code = @ColumnCode;

				                 SET @sqlCommand ='select @Name= (select REVERSE(stuff(reverse(stuff(      
									(         
										select cast('+@Ref_Display_Field+' as nvarchar(max))+ '', ''  from '+@Ref_Table+' where '+@Ref_Value_field+' in(select Columns_Value_Code from Map_Extended_Columns_Details where Map_Extended_Columns_Code
										in(select Map_Extended_columns_Code from Map_Extended_Columns where Record_Code = '+cast(@Record_Code as varchar(200))+' and Columns_Code = '+cast(@ColumnCode as varchar(200))+'))    
										FOR XML PATH(''''), root('''+cast(@TrimColumnName as varchar(200))+'''), type      
										).value(''/'+Cast(@TrimColumnName as varchar(200))+'[1]'',''Nvarchar(max)''     
									),2,0, ''''     
									)      
							),1,2,'''')))'
				      EXECUTE sp_executesql @sqlCommand, N'@ColumnValue nvarchar(75), @Name VARCHAR(75) OUTPUT', @ColumnValue = @ColumnValue, @Name = @ColumnValue OUTPUT
				     Update #ExtendedColumn set Column_Value = @ColumnValue where Columns_Name = @ColumnName;
					
				  End
				  else If(@Is_Multiple = 'N')
				  Begin
				    SET @sqlCommand ='select @Name= (select REVERSE(stuff(reverse(  stuff(      
								(         
									select  MEC.Column_Value +'', '' from Map_Extended_Columns MEC (NOLOCK)
									INNER JOIN Extended_Columns EC  (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = '+Cast(@Record_Code as varchar(200))+' AND EC.Columns_Code = '+cast(@ColumnCode as Varchar(200))+'
      
									FOR XML PATH(''''), root('''+@TrimColumnName+'''), type      
								).value(''/'+@TrimColumnName+'[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')))'
							
					
				    EXECUTE sp_executesql @sqlCommand, N'@ColumnValue nvarchar(75), @Name VARCHAR(75) OUTPUT', @ColumnValue = @ColumnValue, @Name = @ColumnValue OUTPUT
					
				    Update #ExtendedColumn set Column_Value = @ColumnValue where Columns_Name = @ColumnName;
				  end
				  else if exists(select Columns_Name from #ExtendedColumn where Columns_Name = @ColumnName and @ColumnCode = 0)
				  begin
				 
				    SET @sqlCommand = 'SELECT @Name='+@ColumnName+' FROM #Temp WHERE Id = '+cast(@count as nvarchar(50))+''
					
					EXECUTE sp_executesql @sqlCommand, N'@ColumnValue nvarchar(75), @Name VARCHAR(75) OUTPUT', @ColumnValue = @ColumnValue, @Name = @ColumnValue OUTPUT
					Update #ExtendedColumn set Column_Value = cast( @ColumnValue as varchar(200)) where Columns_Name = @ColumnName;
				
				  end 
				-- print @sqlCommand
				 
			  set @row = @row + 1;
			End;
			--Insert Value in Output Table
			INSERT INTO #TempOutput(TL_1, TL_2, TL_3, TL_4, TL_5, TL_6, TL_7, TL_8, TL_9, TL_10, TL_11, TL_12, TL_13, TL_14, TL_15, TL_16, TL_17, TL_18, TL_19, TL_20, TL_21, TL_22, TL_23, TL_24, TL_25, TL_26, TL_27, TL_28, TL_29, TL_30, TL_31, TL_32, TL_33, TL_34, TL_35, TL_36, TL_37, TL_38, TL_39, TL_40, TL_41, TL_42, TL_43, TL_44, TL_45, TL_46, TL_47, TL_48, TL_49, TL_50,TL_51,TL_52,TL_53,TL_54,TL_55,TL_56,TL_57,TL_58,TL_59,TL_60,TL_61,TL_62,TL_63,TL_64,TL_65,TL_66,TL_67,TL_68,TL_69,TL_70,TL_71,TL_72,TL_73,TL_74,TL_75,TL_76,TL_77,TL_78,TL_79,TL_80,TL_81,TL_82,TL_83,TL_84,TL_85,TL_86,TL_87,TL_88,TL_89,TL_90,TL_91,TL_92,TL_93,TL_94,TL_95,TL_96,TL_97,TL_98,TL_99,TL_100)
				Select *
				from (
				    Select Column_Value, RowN = Row_Number() over (ORDER BY (SELECT NULL)) from #ExtendedColumn 
				) a
				pivot (max(Column_Value) for RowN in ([1],[2],[3],[4],[5],[6],[7],[8],[9],[10],[11],[12],[13],[14],[15],[16],[17],[18],[19],[20],[21],[22],[23],[24],[25],[26],[27],[28],[29],[30],[31],[32],[33],[34],[35],[36],[37],[38],[39],[40],[41],[42],[43],[44],[45],[46],[47],[48],[49],[50], [51], [52], [53], [54], [55], [56], [57], [58], [59], [60], [61], [62], [63], [64], [65], [66], [67], [68], [69], [70], [71], [72], [73], [74], [75], [76], [77], [78], [79], [80], [81], [82], [83], [84], [85], [86], [87], [88], [89], [90], [91], [92], [93], [94], [95], [96], [97], [98],[99],[100])) p
				--empty Value Column
				UPDATE #ExtendedColumn SET Column_Value = NULL;
			set @count = @count + 1;
		end
		
		  select * from #TempOutput
		  IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
		IF OBJECT_ID('tempdb..#ExtendedColumn') IS NOT NULL DROP TABLE #ExtendedColumn
		IF OBJECT_ID('tempdb..#TempOutput') IS NOT NULL DROP TABLE #TempOutput 
		IF OBJECT_ID('tempdb..#GroupwiseExtendedColumn') IS NOT NULL DROP TABLE #GroupwiseExtendedColumn  

	  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Title_Report_Details]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''   
END