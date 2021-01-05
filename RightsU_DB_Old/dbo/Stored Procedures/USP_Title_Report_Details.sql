ALTER PROCEDURE [dbo].[USP_Title_Report_Details]      
	@DealTypeCode  INT ,      
	@TitleName NVARCHAR(2000),  
	@OriginalTitleName NVARCHAR(MAX) ,        
	@AdvanceSearch NVARCHAR(MAX)    
AS      
-- =============================================
-- Author:		Akshay R Rane
-- Create DATE: 22 Aug 2018
-- Description:	Title Report
-- ============================================= 
BEGIN   

	--DECLARE  
	--@DealTypeCode  INT ,      
	--@TitleName NVARCHAR(2000),  
	--@OriginalTitleName NVARCHAR(MAX) ,          
	--@AdvanceSearch NVARCHAR(MAX)    

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp  
    CREATE TABLE #Temp(      
			Id Int Identity(1,1),      
			RowId Varchar(200),  
			Title_Name  Varchar(200),   
			Language_Name  Varchar(200),  
			Sort varchar(10),  
			Row_Num Int,  
			Last_Updated_Time datetime  
		);   
		 
	--SELECT @TitleName = ' ', @OriginalTitleName = '', @AdvanceSearch = ' '


	DECLARE @Condition NVARCHAR(MAX) = ' AND ISNULL(T.Reference_Key,'''') = '''' AND  ISNULL(T.Reference_Flag,'''') = '''' '      
	DECLARE @delimt NVARCHAR(2) = N'﹐', @SqlPageNo NVARCHAR(MAX) , @Sql NVARCHAR(MAX)     
      
    IF(@TitleName != '')      
        SET @Condition  += ' AND T.Title_code in (select Title_Code from Title where Title_Name IN (SELECT number FROM fn_Split_withdelemiter(N'''+@TitleName+''', N'''+ @delimt +''') where number != ''''))'      

         
	IF(@OriginalTitleName != '')      
        SET @Condition  += ' AND T.Title_code in (select Title_Code FROM Title WHERE Original_Title IN (SELECT number FROM fn_Split_withdelemiter(N'''+@OriginalTitleName+''', N'''+ @delimt +''') WHERE number != '''')) '      
  
    IF(@AdvanceSearch = '')  
		SET @AdvanceSearch =' ' 

	IF (@DealTypeCode > 0)      
        SET @Condition  += ' AND DT.Deal_Type_code in('+ cast(@DealTypeCode AS VARCHAR(max))+')'      
  
    SET @Condition  += ' '      
      
    SET @SqlPageNo = '      
            WITH Y AS (      
                            Select distinct X.Title_Code,X.Title_Name,X.Language_Name,X.Last_UpDated_Time From      
                            (      
                                select * from (      
                                    select distinct T.Title_Code, T.Original_Title, T.Title_Name, T.Title_Code_Id, T.Synopsis, T.Original_Language_Code, T.Title_Language_Code      
                                            ,T.Year_Of_Production,P.Program_Name, T.Duration_In_Min, T.Deal_Type_Code, T.Grade_Code, T.Reference_Key, T.Reference_Flag, T.Is_Active      
                                            ,T.Inserted_By, T.Inserted_On, T.Last_UpDated_Time, T.Last_Action_By, T.Lock_Time, T.Title_Image, L.Language_Name   
                                            from Title T      
                                            INNER join Deal_Type DT on DT.Deal_Type_Code = T.Deal_Type_Code  
           INNER join Language L on T.Title_Language_Code = L.Language_Code  
           LEFT JOIN Program P ON T.Program_Code = P.Program_Code  
				
                                            where 1=1       
                                            '+ @Condition +'  '+@AdvanceSearch+'  
                                      )as XYZ Where 1 = 1      
                             )as X      
                        )      
        Insert InTo #Temp Select Title_Code,Title_Name,Language_Name,''1'','' '',Last_UpDated_Time From Y'   
         
		 --LEFT join [Title_Geners] TG on TG.Title_Code  = T.Title_Code 
			--				LEFT join [Genres] GEN on GEN.Genres_Code  = TG.Genres_Code 
    EXEC (@SqlPageNo)    

	DECLARE @ProgramCategory NVARCHAR(MAX) = '0', @VMPLShareIPR  NVARCHAR(MAX) = '0', @VMPLShareDerivativeRights  NVARCHAR(MAX) = '0'

	SELECT TOP 1 @ProgramCategory = CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns WHERE Columns_Name = 'Program Category'
	SELECT TOP 1 @VMPLShareIPR =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns WHERE Columns_Name = 'VMP Share IPR'
	SELECT TOP 1 @VMPLShareDerivativeRights =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns WHERE Columns_Name = 'VMP Share Derivative Rights'

    SET @Sql = '      
        SELECT 
			Title_Name, 
			Deal_Type_Name,
			Language_Name, 
			Original_Title, 
			Original_Language, 
			Program_Name, 
			Duration_In_Min,
			Year_Of_Production, 
			TalentName, 
			Director, 
			Producer, 
			Genres_Name,
			CountryName, 
			Synopsis, 
			TypeofFilm,
			Banner,
			ColorOrBW,
			CBFCRating,
			MusicComposer,
			Lyricist,
			Singers,
			Story,
			Script,
			Dialogues,
			Screenplay,
			DOP,
			OthersTalent,
			Choreographer,
			VMPLShareDerivativeRights,
			VMPLShareIPR,
			ProgramCategory
			FROM (      
				select distinct 
						T.Duration_In_Min,
						T.Title_Name,
						T.Original_Title,
						T.Title_Code,
						T.Synopsis ,
						L.Language_Name , 
						OL.Language_Name AS ''Original_Language'',
						T.Year_Of_Production,
						p.Program_Name,
						DT.Deal_Type_Name,
						REVERSE(stuff(reverse(stuff(      
								(         
									select distinct cast(C.Country_Name  as NVARCHAR(MAX)) + '', '' from Title_Country TC      
									inner join Country C on C.Country_Code = TC.Country_Code      
									where TC.Title_Code = T.Title_Code      
									FOR XML PATH(''''), root(''CountryName''), type      
									).value(''/CountryName[1]'',''Nvarchar(max)''      
								),2,0, ''''      
								)      
						),1,2,'''')) as CountryName,  
						REVERSE(stuff(reverse(  stuff(      
								(         
							select distinct ECV.Columns_Value from Map_Extended_Columns MEC
							INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
							INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
							WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Type of Film'')
								FOR XML PATH(''''), root(''TypeofFilm''), type      
								).value(''/TypeofFilm[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as TypeofFilm,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct MEC.Column_Value from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Banner'')
									FOR XML PATH(''''), root(''Banner''), type      
								).value(''/Banner[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as Banner,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct ECV.Columns_Value from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code =(Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Colour or B&W'')
									FOR XML PATH(''''), root(''ColorOrBW''), type      
								).value(''/ColorOrBW[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as ColorOrBW,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct ECV.Columns_Value from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''CBFC Rating'')
									FOR XML PATH(''''), root(''CBFCRating''), type      
								).value(''/CBFCRating[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as CBFCRating,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code =(Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Singers'')
									FOR XML PATH(''''), root(''Singers''), type      
								).value(''/Singers[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as Singers,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Music Composer'')
      
									FOR XML PATH(''''), root(''MusicComposer''), type      
								).value(''/MusicComposer[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as MusicComposer,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Lyricist'')
      
									FOR XML PATH(''''), root(''Lyricist''), type      
								).value(''/Lyricist[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as Lyricist,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Story'')
      
									FOR XML PATH(''''), root(''Story''), type      
								).value(''/Story[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as Story ,
							REVERSE(stuff(reverse(  stuff(      
								(         
								select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Script'')
      
									FOR XML PATH(''''), root(''Script''), type      
								).value(''/Script[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as Script ,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Dialogues'')
									FOR XML PATH(''''), root(''Dialogues''), type      
								).value(''/Dialogues[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as Dialogues,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Screen play'')
									FOR XML PATH(''''), root(''Screenplay''), type      
								).value(''/Screenplay[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as Screenplay ,
							REVERSE(stuff(reverse(  stuff(      
								(         
								select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''DOP'')
									FOR XML PATH(''''), root(''DOP''), type      
								).value(''/DOP[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as DOP,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Others Talent'')
      
									FOR XML PATH(''''), root(''OthersTalent''), type      
								).value(''/OthersTalent[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as OthersTalent,		
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Map_Extended_Columns_Details MECD ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
									INNER JOIN Talent TAL ON TAL.Talent_Code = MECD.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code =(Select top 1 Columns_Code from Extended_Columns where Columns_Name = ''Choreographer'')
      
									FOR XML PATH(''''), root(''Choreographer''), type      
								).value(''/Choreographer[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as Choreographer,	
							REVERSE(stuff(reverse(  stuff(      
								(         
									select  MEC.Column_Value from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@VMPLShareDerivativeRights+'
      
									FOR XML PATH(''''), root(''VMPLShareDerivativeRights''), type      
								).value(''/VMPLShareDerivativeRights[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as VMPLShareDerivativeRights,	
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct TAL.Columns_Value  from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Extended_Columns_Value TAL ON TAL.Columns_Value_Code = MEC.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@ProgramCategory+'
      
									FOR XML PATH(''''), root(''ProgramCategory''), type      
								).value(''/ProgramCategory[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as ProgramCategory,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select  MEC.Column_Value from Map_Extended_Columns MEC
									INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@VMPLShareIPR+'
      
									FOR XML PATH(''''), root(''VMPLShareIPR''), type      
								).value(''/VMPLShareIPR[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as VMPLShareIPR,
						REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
									inner join Role R on R.Role_Code = TT.Role_Code      
									inner join Talent Tal on tal.talent_Code = TT.Talent_code      
									where TT.Title_Code = T.Title_Code AND R.Role_Code in (2)      
      
									FOR XML PATH(''''), root(''TalentName''), type      
								).value(''/TalentName[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,2,'''')) as TalentName      
						,REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
									inner join Role R on R.Role_Code = TT.Role_Code      
									inner join Talent Tal on tal.talent_Code = TT.Talent_code      
									where TT.Title_Code = T.Title_Code AND R.Role_Code in (4)      
      
									FOR XML PATH(''''), root(''Producer''), type      
								).value(''/Producer[1]'',''NVARCHAR(max)''      
								),1,0, ''''      
								)      
						),1,2,'''')) as Producer      
						,REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
									inner join Role R on R.Role_Code = TT.Role_Code      
									inner join Talent Tal on tal.talent_Code = TT.Talent_code      
									where TT.Title_Code = T.Title_Code AND R.Role_Code in (1)      
      
									FOR XML PATH(''''), root(''Director''), type      
								).value(''/Director[1]'',''NVARCHAR(max)''      
								),1,0, ''''      
							)      
						),1,2,'''')) as Director, 
						[dbo].[UFN_Get_Title_Genre](T.Title_Code) as Genres_Name,
						Tmp.Row_Num     
						
						FROM Title T      
							INNER join Deal_Type DT on DT.Deal_Type_Code = T.Deal_Type_Code     
							LEFT join [Language] L on T.Title_Language_Code  = L.Language_Code   
							LEFT join [Language] OL on T.Original_Language_Code  = OL.Language_Code    
							LEFT join Title_Country TC on T.Title_Code = TC.Title_Code 
			
							INNER JOIN #Temp Tmp on T.Title_Code = Tmp.RowId    
							LEFT JOIN Program P on T.Program_code = P.Program_Code   
						WHERE 1=1 '+ @Condition +'  '+@AdvanceSearch+'    
						) tbl  
				 WHERE tbl.Title_Code in (Select RowId From #Temp)    
				ORDER BY tbl.Row_Num   
    '  
					--LEFT join [Title_Geners] TG on TG.Title_Code  = T.Title_Code 
							--LEFT join [Genres] GEN on GEN.Genres_Code  = TG.Genres_Code 
	print @Sql
   -- select  @Sql      
   EXEC(@SQL)  
			--select 
			--'' as Title_Name, 
			--'' as Deal_Type_Name,
			--'' as Language_Name, 
			--'' as Original_Title, 
			--'' as Original_Language, 
			--'' as Program_Name, 
			--'' as Duration_In_Min,
			--'' as Year_Of_Production, 
			--'' as TalentName, 
			--'' as Director, 
			--'' as Producer, 
			--'' as Genres_Name,
			--'' as CountryName, 
			--'' as Synopsis, 
			--'' as TypeofFilm,
			--'' as Banner,
			--'' as ColorOrBW,
			--'' as CBFCRating,
			--'' as MusicComposer,
			--'' as Lyricist,
			--'' as Singers,
			--'' as Story,
			--'' as Script,
			--'' as Dialogues,
			--'' as Screenplay,
			--'' as DOP,
			--'' as OthersTalent,
			--'' as Choreographer,
			--'' as VMPLShareDerivativeRights,
			--'' as VMPLShareIPR,
			--'' as ProgramCategory
			
    Drop Table #Temp      
END

--[dbo].[UFN_Get_Title_Genre](T.Title_Code) as Genre,   
--select * from Title_Country where Title_Country like 'Les Misrables%'


--Select  * from Extended_Columns_Value where Columns_Code in (10,12)
--Select  * from Map_Extended_Columns where Record_Code = 27841
--Select * from Extended_Columns where Columns_Code in (Select  Columns_Code from Map_Extended_Columns where Record_Code = 27841)
--Select  * from Map_Extended_Columns_Details where  Map_Extended_Columns_Code in (7116,7117) 
--select * from Talent where Talent_Code in (5,8)

--select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT      
--									inner join Role R on R.Role_Code = TT.Role_Code      
--									inner join Talent Tal on tal.talent_Code = TT.Talent_code      
--									where TT.Title_Code = 27841 AND R.Role_Code in (13)      


--									select * from Title_Talent where Title_code = 27841

--select * from Deal_Type where Is_Active = 'Y'


--exec [dbo].[USP_Title_Report_Details] '','','','' 