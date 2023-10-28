CREATE PROCEDURE [dbo].[USP_Title_Report_Details]      
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
	SET FMTONLY OFF
	SET NOCOUNT ON 
	Declare @Loglevel int  
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Title_Report_Details]', 'Step 1', 0, 'Started Procedure', 0, ''   
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
		 
		 IF OBJECT_ID('tempdb..#TempResult') IS NOT NULL DROP TABLE #TempResult
		 Create Table #TempResult(
			Title_Name nvarchar(MAX) null, 	Deal_Type_Name varchar(MAX) null, Language_Name nvarchar(MAX) null, Original_Title nvarchar(MAX) null,
			Original_Language nvarchar(MAX) null, 	[Program_Name] nvarchar(MAX) null,	[Duration_In_Min] decimal(18,2) null,	[Year_Of_Production] int null,
			TalentName nvarchar(MAX) null,	Director nvarchar(MAX) null, Producer nvarchar(MAX) null, Genres_Name nvarchar(MAX) null,	
			CountryName nvarchar(MAX) null, Synopsis nvarchar(MAX) null, TypeofFilm nvarchar(MAX) null,  Banner nvarchar(MAX) null,	
			ColorOrBW nvarchar(MAX) null,  CBFCRating nvarchar(MAX) null,	MusicComposer nvarchar(MAX) null, Lyricist nvarchar(MAX) null,	
			Singers nvarchar(MAX) null,	 Story nvarchar(MAX) null, Script nvarchar(MAX) null, Dialogues nvarchar(MAX) null,	
			Screenplay nvarchar(MAX) null, 	DOP nvarchar(MAX) null,	OthersTalent nvarchar(MAX) null, Choreographer nvarchar(MAX) null,	
			VMPLShareDerivativeRights varchar(MAX), VMPLShareIPR  varchar(MAX),	ProgramCategory varchar(MAX),	
			Awards nvarchar(MAX) null,	Labs nvarchar(MAX) null, Grade nvarchar(MAX) null, Original_CC_NO nvarchar(MAX), CBFC_Date nvarchar(MAX), 
			Dubbed_CBFC_Rating nvarchar(MAX) null, Dubbed_CC_NO nvarchar(MAX) null, Dubbed_Year_of_Release nvarchar(MAX) null, 
			Creative_Producer nvarchar(MAX) null, Cinematography nvarchar(MAX) null, Film_Editing nvarchar(MAX) null, 
			Casting nvarchar(MAX) null, Music_Director nvarchar(MAX) null, Row_Num int null
		 );

		DECLARE @Condition NVARCHAR(MAX) = ' AND ISNULL(T.Reference_Key,'''') = '''' AND  ISNULL(T.Reference_Flag,'''') = '''' '      
		DECLARE @delimt NVARCHAR(2) = N'﹐', @SqlPageNo NVARCHAR(MAX) , @Sql NVARCHAR(MAX)  ,@SqlAdditionalColumns NVARCHAR(MAX)   
      
		IF(@TitleName != '')      
			SET @Condition  += ' AND T.Title_code in (select Title_Code from Title where Title_Name IN (SELECT number FROM fn_Split_withdelemiter(N'''+@TitleName+''', N'''+ @delimt +''') where number != ''''))'      

         
		IF(@OriginalTitleName != '')      
			SET @Condition  += ' AND T.Title_code in (select Title_Code FROM Title WHERE Original_Title IN (SELECT number FROM fn_Split_withdelemiter(N'''+@OriginalTitleName+''', N'''+ @delimt +''') WHERE number != '''')) '      
  
		IF(@AdvanceSearch != '')  
			SET @AdvanceSearch =' ' 

		IF (@DealTypeCode > 0)      
			SET @Condition  += ' AND DT.Deal_Type_code in('+ cast(@DealTypeCode AS VARCHAR(max))+')'      
  
		SET @Condition  += ' '      
      
		SET @SqlPageNo = '      
				WITH Y AS (      
								Select distinct X.Title_Code,X.Title_Name,X.Language_Name,X.Last_UpDated_Time From      
								(      
									select * from (      
										select distinct T.Title_Code, T.Original_Title, T.Title_Name, T.Title_Code_Id, T.Synopsis, T.Original_Language_Code, T.Title_Language_Code,      
												T.Year_Of_Production,P.Program_Name, T.Duration_In_Min, T.Deal_Type_Code, T.Grade_Code, T.Reference_Key, T.Reference_Flag, T.Is_Active,      
												T.Inserted_By, T.Inserted_On, T.Last_UpDated_Time, T.Last_Action_By, T.Lock_Time, T.Title_Image, L.Language_Name   
												from Title T (NOLOCK)
												INNER join Deal_Type DT (NOLOCK) on DT.Deal_Type_Code = T.Deal_Type_Code  
			                                    INNER join Language L (NOLOCK) on T.Title_Language_Code = L.Language_Code  
			                                    LEFT JOIN Program P (NOLOCK) ON T.Program_Code = P.Program_Code  				
												where 1=1       
												'+ @Condition +'  '+@AdvanceSearch+'  
										  )as XYZ Where 1 = 1      
								 )as X      
							)      
			Insert InTo #Temp Select Title_Code,Title_Name,Language_Name,''1'','' '',Last_UpDated_Time From Y'  

		EXEC (@SqlPageNo)    
		--print @SqlPageNo

		DECLARE @ProgramCategory NVARCHAR(MAX) = '0', @VMPLShareIPR  NVARCHAR(MAX) = '0', @VMPLShareDerivativeRights  NVARCHAR(MAX) = '0', @Awards NVARCHAR(MAX) = '0', @Labs NVARCHAR(MAX) = '0',
		        @Original_CC_NO NVARCHAR(MAX) = '0', @CBFC_Date NVARCHAR(MAX) = '0', @Dubbed_CBFC_Rating NVARCHAR(MAX) = '0', @Dubbed_CC_NO NVARCHAR(MAX) = '0', @Dubbed_Year_of_Release NVARCHAR(MAX) = '0'

		SELECT TOP 1 @ProgramCategory = CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'Program Category'
		SELECT TOP 1 @VMPLShareIPR =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'VMP Share IPR'
		SELECT TOP 1 @VMPLShareDerivativeRights =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'VMP Share Derivative Rights'
		SELECT TOP 1 @Awards =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'Awards'
		SELECT TOP 1 @Labs =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'Labs'
		SELECT TOP 1 @Original_CC_NO =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'CC NO'
		SELECT TOP 1 @CBFC_Date =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'CBFC Date'
		SELECT TOP 1 @Dubbed_CBFC_Rating =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'Dubbed_CBFC_Rating' 
		SELECT TOP 1 @Dubbed_CC_NO =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'Dubbed CC NO'
		SELECT TOP 1 @Dubbed_Year_of_Release =  CAST(Columns_Code as NVARCHAR(MAX)) FROM Extended_Columns (NOLOCK) WHERE Columns_Name = 'Dubbed Year of Release'

		SET @SqlAdditionalColumns = 'REVERSE(stuff(reverse(  stuff(  (  select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Music Director'')      
										FOR XML PATH(''''), root(''Music_Director''), type   ).value(''/Music_Director[1]'',''NVARCHAR(max)'' ),1,0, '''' )      
								     ),1,2,'''')) as Music_Director'

		SET @Sql = '      
			WITH Z AS (
			SELECT 
				Title_Name, Deal_Type_Name,	Language_Name, 	Original_Title, Original_Language, 	Program_Name, 
				Duration_In_Min, Year_Of_Production, TalentName, Director, Producer, Genres_Name,	CountryName, Synopsis, 
				TypeofFilm,	Banner,	ColorOrBW,	CBFCRating,	MusicComposer,	Lyricist,	Singers,	Story,
				Script,	Dialogues,	Screenplay,	DOP,	OthersTalent,	Choreographer,	VMPLShareDerivativeRights,
				VMPLShareIPR,	ProgramCategory,	Awards,	Labs,	Grade, Original_CC_NO, CBFC_Date, Dubbed_CBFC_Rating, 
				Dubbed_CC_NO, Dubbed_Year_of_Release, Creative_Producer, Cinematography, Film_Editing, Casting, Music_Director, Row_Num
				FROM (      
					select distinct 
							T.Duration_In_Min,	T.Title_Name,	T.Original_Title,	T.Title_Code,	T.Synopsis ,	L.Language_Name , 
							OL.Language_Name AS ''Original_Language'',	T.Year_Of_Production,	p.Program_Name,		DT.Deal_Type_Name,
							REVERSE(stuff(reverse(stuff(      
									(         
										select distinct cast(C.Country_Name  as NVARCHAR(MAX)) + '', '' from Title_Country TC (NOLOCK)     
										inner join Country C (NOLOCK) on C.Country_Code = TC.Country_Code      
										where TC.Title_Code = T.Title_Code      
										FOR XML PATH(''''), root(''CountryName''), type      
										).value(''/CountryName[1]'',''Nvarchar(max)''      
									),2,0, ''''      
									)      
							),1,2,'''')) as CountryName,  
							REVERSE(stuff(reverse(  stuff(      
									(         
								select distinct ECV.Columns_Value from Map_Extended_Columns MEC  (NOLOCK)
								INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
								INNER JOIN Extended_Columns_Value ECV (NOLOCK) ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
								WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Type of Film'')
									FOR XML PATH(''''), root(''TypeofFilm''), type      
									).value(''/TypeofFilm[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,0,'''')) as TypeofFilm,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct MEC.Column_Value from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Banner'')
										FOR XML PATH(''''), root(''Banner''), type      
									).value(''/Banner[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,0,'''')) as Banner,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct ECV.Columns_Value from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Extended_Columns_Value ECV (NOLOCK) ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code =(Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Colour or B&W'')
										FOR XML PATH(''''), root(''ColorOrBW''), type      
									).value(''/ColorOrBW[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,0,'''')) as ColorOrBW,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct ECV.Columns_Value from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Extended_Columns_Value ECV (NOLOCK) ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''CBFC Rating'')
										FOR XML PATH(''''), root(''CBFCRating''), type      
									).value(''/CBFCRating[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,0,'''')) as CBFCRating,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code =(Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Singers'')
										FOR XML PATH(''''), root(''Singers''), type      
									).value(''/Singers[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Singers,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Music Composer'')
      
										FOR XML PATH(''''), root(''MusicComposer''), type      
									).value(''/MusicComposer[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as MusicComposer,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Lyricist'')
      
										FOR XML PATH(''''), root(''Lyricist''), type      
									).value(''/Lyricist[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Lyricist,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Story'')
      
										FOR XML PATH(''''), root(''Story''), type      
									).value(''/Story[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Story ,
								REVERSE(stuff(reverse(  stuff(      
									(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Script'')
      
										FOR XML PATH(''''), root(''Script''), type      
									).value(''/Script[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Script ,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Dialogues'')
										FOR XML PATH(''''), root(''Dialogues''), type      
									).value(''/Dialogues[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Dialogues,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Screen play'')
										FOR XML PATH(''''), root(''Screenplay''), type      
									).value(''/Screenplay[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Screenplay ,
								REVERSE(stuff(reverse(  stuff(      
									(         
									select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''DOP'')
										FOR XML PATH(''''), root(''DOP''), type      
									).value(''/DOP[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as DOP,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL  (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Others Talent'')
      
										FOR XML PATH(''''), root(''OthersTalent''), type      
									).value(''/OthersTalent[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as OthersTalent,		
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code =(Select top 1 Columns_Code from Extended_Columns  (NOLOCK) where Columns_Name = ''Choreographer'')
      
										FOR XML PATH(''''), root(''Choreographer''), type      
									).value(''/Choreographer[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Choreographer,	
								REVERSE(stuff(reverse(  stuff(      
									(         
										select  MEC.Column_Value from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@VMPLShareDerivativeRights+'
      
										FOR XML PATH(''''), root(''VMPLShareDerivativeRights''), type      
									).value(''/VMPLShareDerivativeRights[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,0,'''')) as VMPLShareDerivativeRights,	
								REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct TAL.Columns_Value  from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Extended_Columns_Value TAL (NOLOCK) ON TAL.Columns_Value_Code = MEC.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@ProgramCategory+'
      
										FOR XML PATH(''''), root(''ProgramCategory''), type      
									).value(''/ProgramCategory[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,0,'''')) as ProgramCategory,
								REVERSE(stuff(reverse(  stuff(      
									(         
										select  MEC.Column_Value from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@VMPLShareIPR+'
      
										FOR XML PATH(''''), root(''VMPLShareIPR''), type      
									).value(''/VMPLShareIPR[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,0,'''')) as VMPLShareIPR,
							REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT  (NOLOCK)  
										inner join Role R  (NOLOCK) on R.Role_Code = TT.Role_Code      
										inner join Talent Tal (NOLOCK) on tal.talent_Code = TT.Talent_code      
										where TT.Title_Code = T.Title_Code AND R.Role_Code in (2)      
      
										FOR XML PATH(''''), root(''TalentName''), type      
									).value(''/TalentName[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as TalentName      
							,REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT  (NOLOCK)     
										inner join Role R  (NOLOCK) on R.Role_Code = TT.Role_Code      
										inner join Talent Tal (NOLOCK) on tal.talent_Code = TT.Talent_code      
										where TT.Title_Code = T.Title_Code AND R.Role_Code in (4)      
      
										FOR XML PATH(''''), root(''Producer''), type      
									).value(''/Producer[1]'',''NVARCHAR(max)''      
									),1,0, ''''      
									)      
							),1,2,'''')) as Producer      
							,REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + '', '' from Title_Talent TT  (NOLOCK)     
										inner join Role R (NOLOCK) on R.Role_Code = TT.Role_Code      
										inner join Talent Tal (NOLOCK) on tal.talent_Code = TT.Talent_code      
										where TT.Title_Code = T.Title_Code AND R.Role_Code in (1)      
      
										FOR XML PATH(''''), root(''Director''), type      
									).value(''/Director[1]'',''NVARCHAR(max)''      
									),1,0, ''''      
								)      
							),1,2,'''')) as Director, 
							[dbo].[UFN_Get_Title_Genre](T.Title_Code) as Genres_Name,
							Tmp.Row_Num,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select  MEC.Column_Value from Map_Extended_Columns MEC (NOLOCK)
									INNER JOIN Extended_Columns EC  (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@Awards+'
      
									FOR XML PATH(''''), root(''Awards''), type      
								).value(''/Awards[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as Awards,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select  MEC.Column_Value from Map_Extended_Columns MEC (NOLOCK)
									INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@Labs+'
      
									FOR XML PATH(''''), root(''Labs''), type      
								).value(''/Labs[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as Labs,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct ECV.Columns_Value from Map_Extended_Columns MEC (NOLOCK)
									INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Extended_Columns_Value ECV (NOLOCK) ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Grade'')
									FOR XML PATH(''''), root(''Grade''), type      
								).value(''/Grade[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as Grade,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select  MEC.Column_Value from Map_Extended_Columns MEC (NOLOCK)
									INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@Original_CC_NO+'
      
									FOR XML PATH(''''), root(''Original_CC_NO''), type      
								).value(''/Original_CC_NO[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as Original_CC_NO,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select  MEC.Column_Value from Map_Extended_Columns MEC (NOLOCK)
									INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@CBFC_Date+'
      
									FOR XML PATH(''''), root(''CBFC_Date''), type      
								).value(''/CBFC_Date[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as CBFC_Date, 
							REVERSE(stuff(reverse(  stuff(      
								(         
									select distinct ECV.Columns_Value from Map_Extended_Columns MEC (NOLOCK)
									INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
									INNER JOIN Extended_Columns_Value ECV (NOLOCK) ON ECV.Columns_Value_Code = MEC.Columns_Value_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Dubbed CBFC Rating'')
									FOR XML PATH(''''), root(''Dubbed_CBFC_Rating''), type      
								).value(''/Dubbed_CBFC_Rating[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as Dubbed_CBFC_Rating,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select  MEC.Column_Value from Map_Extended_Columns MEC (NOLOCK)
									INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@Dubbed_CC_NO+'
      
									FOR XML PATH(''''), root(''Dubbed_CC_NO''), type      
								).value(''/Dubbed_CC_NO[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as Dubbed_CC_NO,
							REVERSE(stuff(reverse(  stuff(      
								(         
									select  MEC.Column_Value from Map_Extended_Columns MEC (NOLOCK)
									INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
									WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code ='+@Dubbed_Year_of_Release+'
      
									FOR XML PATH(''''), root(''Dubbed_Year_of_Release''), type      
								).value(''/Dubbed_Year_of_Release[1]'',''NVARCHAR(max)''      
							),1,0, '''' )      
							),1,0,'''')) as Dubbed_Year_of_Release,
							REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns  (NOLOCK) where Columns_Name = ''Creative Producer'')
      
										FOR XML PATH(''''), root(''Creative_Producer''), type      
									).value(''/Creative_Producer[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Creative_Producer,
                            REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Cinematography'')
      
										FOR XML PATH(''''), root(''Cinematography''), type      
									).value(''/Cinematography[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Cinematography,
							REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL  (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns  (NOLOCK) where Columns_Name = ''Film Editing'')
      
										FOR XML PATH(''''), root(''Film_Editing''), type      
									).value(''/Film_Editing[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Film_Editing,
							REVERSE(stuff(reverse(  stuff(      
									(         
										select distinct CAST(TAL.Talent_Name  AS NVARCHAR(MAX)) + '', '' from Map_Extended_Columns MEC (NOLOCK)
										INNER JOIN Extended_Columns EC (NOLOCK) ON EC.Columns_Code = MEC.Columns_Code
										INNER JOIN Map_Extended_Columns_Details MECD (NOLOCK) ON MEC.Map_Extended_Columns_Code = MECD.Map_Extended_Columns_Code
										INNER JOIN Talent TAL (NOLOCK) ON TAL.Talent_Code = MECD.Columns_Value_Code
										WHERE MEC.Record_Code = T.Title_Code AND EC.Columns_Code = (Select top 1 Columns_Code from Extended_Columns (NOLOCK) where Columns_Name = ''Casting'')
      
										FOR XML PATH(''''), root(''Casting''), type      
									).value(''/Casting[1]'',''NVARCHAR(max)''      
								),1,0, '''' )      
								),1,2,'''')) as Casting,
							'+@SqlAdditionalColumns+'

							FROM Title T  (NOLOCK)
								INNER join Deal_Type DT (NOLOCK) on DT.Deal_Type_Code = T.Deal_Type_Code     
								LEFT join [Language] L (NOLOCK) on T.Title_Language_Code  = L.Language_Code   
								LEFT join [Language] OL (NOLOCK) on T.Original_Language_Code  = OL.Language_Code    
								LEFT join Title_Country TC (NOLOCK) on T.Title_Code = TC.Title_Code 
			
								INNER JOIN #Temp Tmp on T.Title_Code = Tmp.RowId    
								LEFT JOIN Program P (NOLOCK) on T.Program_code = P.Program_Code   
							WHERE 1=1 '+ @Condition +'  '+@AdvanceSearch+'    
							) tbl 
					 WHERE tbl.Title_Code in (Select RowId From #Temp)    
					 
					) 
		Insert into #TempResult select * from Z' 

	   --print @Sql
	   --select  @Sql      
	   EXEC(@SQL)  
			
		--Drop Table #Temp      
		SELECT * FROM #TempResult ORDER BY Row_Num

		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp

	  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Title_Report_Details]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''   
END