CREATE PROCEDURE [dbo].[USP_List_Music_Title]            
(            
	@MusicTitleName NVARCHAR(MAX),  
	@SysLanguageCode INT,          
	@PageNo Int=0,            
	@RecordCount Int out,            
	@IsPaging Varchar(2),            
	@PageSize Int,            
	@StarCastCode NVARCHAR(2000),            
	@LanguageCode NVARCHAR(2000),            
	@AlbumCode NVARCHAR(2000),            
	@GenresCode NVARCHAR(2000),            
	@MusicLabelCode NVARCHAR(2000),            
	@YearOfRelease VARCHAR(10),            
	@SingerCode NVARCHAR(2000),            
	@ComposerCode NVARCHAR(2000),            
	@LyricistCode NVARCHAR(2000),            
	@MusicNameText NVARCHAR(2000),            
	@ThemeCode NVARCHAR(2000),             
	@MusicTag NVARCHAR(2000),
	@PublicDomain CHAR(1),
	@ExactMatch varchar(2000) =''            
)            
AS            
	BEGIN            
-- exec [USP_List_Music_Title] '',1,0,'Y',10,'','','','','','','','','','Rangoon 45,Afeemeee','',''              
--  1            
--7809        
	DECLARE
		--@MusicTitleName NVARCHAR(MAX),    
		--@PageNo Int=0,            
		--@RecordCount Int,            
		--@IsPaging Varchar(2),            
		--@PageSize Int,            
		--@StarCastCode NVARCHAR(2000),     
		--@LanguageCode NVARCHAR(2000),     
		--@AlbumCode NVARCHAR(2000),        
		--@GenresCode NVARCHAR(2000),       
		--@MusicLabelCode NVARCHAR(2000),   
		--@YearOfRelease VARCHAR(10),       
		--@SingerCode NVARCHAR(2000),       
		--@ComposerCode NVARCHAR(2000),     
		--@LyricistCode NVARCHAR(2000),     
		--@MusicNameText NVARCHAR(2000),    
		--@ThemeCode NVARCHAR(2000),        
		--@MusicTag NVARCHAR(2000),   
		--@SysLanguageCode INT = 2,   
		--@PublicDomain CHAR(1) ,  
		--@ExactMatch varchar(2000) ='',
		@Col_Head01 NVARCHAR(MAX) = '',  
		@Col_Head02 NVARCHAR(MAX) = '',  
		@Col_Head03 NVARCHAR(MAX) = '',  
		@Col_Head04 NVARCHAR(MAX) = '',  
		@Col_Head05 NVARCHAR(MAX) = '',  
		@Col_Head06 NVARCHAR(MAX) = '',  
		@Col_Head07 NVARCHAR(MAX) = '',  
		@Col_Head08 NVARCHAR(MAX) = '',
		@Col_Head09 NVARCHAR(MAX) = '',
		@Col_Head10 NVARCHAR(MAX) = '',
		@Col_Head11 NVARCHAR(MAX) = '',
		@Col_Head12 NVARCHAR(MAX) = '',  
		@Col_Head13 NVARCHAR(MAX) = '',
		@Col_Head14 NVARCHAR(MAX) = '',     
		@Col_Head16 NVARCHAR(MAX) = '',
		@Col_Head17 NVARCHAR(MAX) = ''              
            
	--SET @MusicTitleName ='AND Masters_Value like ''%Yeh raaten%'''            
	--SET @PageNo = 1            
	--SET @RecordCount = 10            
	--SET @IsPaging = 'Y'            
	--SET @PageSize ='1000'            
	--SET @StarCastCode =''                
	--SET @LanguageCode = '1'                
	--SET @AlbumCode = ''                
	--SET @GenresCode = ''             
	--SET @MusicLabelCode = ''            
	--SET @YearOfRelease = ''            
	--SET @SingerCode = ''            
	--SET @ComposerCode  = ''            
	--SET @LyricistCode = ''            
	--SET @MusicNameText = ''            
	--SET @ThemeCode = ''            
	--SET @MusicTag = ''    
 --   SET @PublicDomain  = ''                
	
	 SET FMTONLY OFF            
	 SET NOCOUNT ON            
            
	DECLARE @delimt NVARCHAR(2) = N'﹐'            
	DECLARE @Singer INT            
	SET @Singer  = 13            
	DECLARE @Lyricist INT            
	SET @Lyricist  = 15            
	DECLARE @Composer INT            
	SET  @Composer  = 21            
	DECLARE @StarCast INT            
	SET  @StarCast  = 2            
	Declare @SqlPageNo VARCHAR(MAX)            
             
	IF(OBJECT_ID('TEMPDB..#TempMusicTitleCodes') IS NOT NULL)            
		 DROP TABLE #TempMusicTitleCodes                
             
    IF(OBJECT_ID('TEMPDB..#Temp') IS NOT NULL)            
		 DROP TABLE #Temp             
            
	 CREATE TABLE #Temp            
	 (            
		Id Int Identity(1,1),            
		RowNumber BigInt,            
		Music_Title_Code Int,            
		Masters_Value nvarchar(max) default (''),            
		Last_Updated_Time datetime,            
		Sort varchar(10) default ('1')             
	 )            
            
	 CREATE TABLE #TempMusicTitleCodes            
	 (            
		  Row_No Int,            
		  Music_Title_Code Int            
	 )            
              
	 Declare @TblAlbum TABLE (            
		  Music_Album_Code Int,            
		  Music_Album_Name NVarchar(200)            
	 )            
            
	If(@ExactMatch = '')            
		Begin               
			  IF(OBJECT_ID('TEMPDB..#TempAllCodes') IS NOT NULL)            
			  DROP TABLE #TempAllCodes            
			   
			  CREATE TABLE #TempAllCodes              
			  (              
				 Music_Title_Code VARCHAR(50)            
			  )            
            
			  Declare @TblStarCast TABLE (            
				  Music_Title_Code Int            
			  )            
            
			  Declare @TblLanguage TABLE (            
				  Music_Title_Code Int            
			  )            
            
			  Declare @TblGenres TABLE (            
				  Music_Title_Code Int            
			  )            
            
			  Declare @TblMusicLabel TABLE (            
				  Music_Title_Code Int            
			  )            
            
			  Declare @TblSinger TABLE (            
				  Music_Title_Code Int            
			  )            
            
			  Declare @TblComposer TABLE (            
				 Music_Title_Code Int            
			  )            
            
			  Declare @TblLyricist TABLE (            
				 Music_Title_Code Int            
			  )            
            
			  Declare @TblTheme TABLE (            
				 Music_Title_Code Int            
			  )            
            
			  Declare @TblMusicTag TABLE (            
				 Music_Title_Code Int            
			  ) 
			  
			  Declare @TblDealType TABLE (
				 Music_Title_Code Int
			  )           
            
		  If(LTRIM(RTRIM(@StarCastCode)) <> '')            
		  Begin            
              
			  Insert InTo @TblStarCast(Music_Title_Code)            
			  Select DISTINCT mtt.Music_Title_Code             
			  From Music_Title_Talent mtt             
			  Where  mtt.Role_Code = @StarCast AND mtt.Talent_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@StarCastCode,',')) AND mtt.Music_Title_Code IS NOT NULL            
            
		  End            
             
		  If(LTRIM(RTRIM(@SingerCode)) <> '')            
		  Begin            
			   Insert InTo @TblSinger(Music_Title_Code)            
			   Select DISTINCT mtt.Music_Title_Code             
			   From Music_Title_Talent mtt             
			   Where  mtt.Role_Code = @Singer AND mtt.Talent_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@SingerCode,',')) AND mtt.Music_Title_Code IS NOT NULL            
            
		  End            
             
		  If(LTRIM(RTRIM(@ComposerCode)) <> '')            
		  Begin            
              
			   Insert InTo @TblComposer(Music_Title_Code)            
			   Select DISTINCT mtt.Music_Title_Code             
			   From Music_Title_Talent mtt             
			   Where  mtt.Role_Code = @Composer AND mtt.Talent_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@ComposerCode,',')) AND mtt.Music_Title_Code IS NOT NULL            
               
		   --select * from @TblComposer            
		  End            
             
		  If(LTRIM(RTRIM(@LyricistCode)) <> '')            
		  Begin            
			   Insert InTo @TblLyricist(Music_Title_Code)            
			   Select DISTINCT mtt.Music_Title_Code             
			   From Music_Title_Talent mtt             
			   Where  mtt.Role_Code = @Lyricist AND mtt.Talent_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@LyricistCode,',')) AND mtt.Music_Title_Code IS NOT NULL            
		  End            
             
		  If(LTRIM(RTRIM(@LanguageCode)) <> '')            
		  Begin            
			   Insert InTo @TblLanguage(Music_Title_Code)            
			   Select DISTINCT mtt.Music_Title_Code             
			   From Music_Title_Language mtt             
			   Where mtt.Music_Language_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@LanguageCode,',')) AND mtt.Music_Title_Code IS NOT NULL            
		  End            
             
		  IF(LTRIM(RTRIM(@ThemeCode)) <> '')            
		  BEGIN            
            
			   Insert InTo @TblTheme(Music_Title_Code)            
			   SELECT DISTINCT Music_Title_Code             
			   FROM Music_Title_Theme MTL (NOLOCK)             
			   WHERE Music_Theme_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@ThemeCode,',')) AND MTL.Music_Title_Code IS NOT NULL            
             
		  END            
             
		  IF(LTRIM(RTRIM(@MusicLabelCode)) <> '')            
		  BEGIN            
            
			   Insert InTo @TblMusicLabel(Music_Title_Code)            
			   SELECT DISTINCT Music_Title_Code             
			   FROM Music_Title_Label MTL (NOLOCK)             
			   WHERE Music_Label_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(@MusicLabelCode,',')) and MTL.Effective_To IS Null AND MTL.Music_Title_Code IS NOT NULL            
             
		  END            
            
			IF(LTRIM(RTRIM(@GenresCode)) <> '')
			BEGIN
		
				Insert InTo @TblGenres(Music_Title_Code)
				SELECT DISTINCT Music_Title_Code 
				FROM Music_Title MT (NOLOCK) 
				WHERE Genres_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@GenresCode,','))
	
			END	
			  
		  If(LTRIM(RTRIM(@AlbumCode)) <> '')            
		  Begin            
              
			   Insert InTo @TblAlbum(Music_Album_Code, Music_Album_Name)            
			   Select mtt.Music_Album_Code, Music_Album_Name            
			   From Music_Album mtt             
			   Where mtt.Music_Album_Name IN (SELECT number FROM dbo.fn_Split_withdelemiter(@AlbumCode,','))            
            
		  End            
		  Else            
		  Begin            
			   Insert InTo @TblAlbum(Music_Album_Code, Music_Album_Name)            
			   Select mtt.Music_Album_Code, Music_Album_Name            
			   From Music_Album mtt             
              
		  End            
            
		  IF((LTRIM(RTRIM(@MusicLabelCode)) = '') AND            
			(LTRIM(RTRIM(@ThemeCode)) = '') AND            
			(LTRIM(RTRIM(@LanguageCode)) = '') AND            
			(LTRIM(RTRIM(@LyricistCode)) = '') AND            
			(LTRIM(RTRIM(@ComposerCode)) = '') AND            
			(LTRIM(RTRIM(@SingerCode)) = '') AND
			(LTRIM(RTRIM(@GenresCode)) = '') AND            
			(LTRIM(RTRIM(@StarCastCode)) = ''))            
		  Begin            
             
			   Insert InTo #TempMusicTitleCodes(Music_Title_Code)            
			   Select Music_Title_Code From Music_Title mt            
            
		  End            
		  Else     
			  Begin            
				  print 'union'            
					   Insert InTo #TempAllCodes            
					   Select Music_Title_Code From @TblMusicLabel            
					   Union            
					   Select Music_Title_Code From @TblTheme            
					   Union            
					   Select Music_Title_Code From @TblLanguage            
					   Union            
					   Select Music_Title_Code From @TblLyricist            
					   Union
					   Select Music_Title_Code From @TblGenres            
					   Union                        
					   Select Music_Title_Code From @TblComposer            
					   Union            
					   Select Music_Title_Code From @TblSinger          
					   Union            
					   Select Music_Title_Code From @TblStarCast
					   Union
					   Select Music_Title_Code From @TblDealType            
            
				   If (Not Exists(Select Top 1 Music_Title_Code From @TblMusicLabel) AND @MusicLabelCode = '')            
				   Begin            
             
						Insert InTo @TblMusicLabel            
						Select Music_Title_Code From #TempAllCodes            
            
				   End            
              
				   If (Not Exists(Select Top 1 Music_Title_Code From @TblTheme) AND @ThemeCode = '')            
				   Begin            
             
						Insert InTo @TblTheme            
						Select Music_Title_Code From #TempAllCodes            
            
				   End            
            
				   If (Not Exists(Select Top 1 Music_Title_Code From @TblLanguage) AND @LanguageCode = '')            
				   Begin            
             
						Insert InTo @TblLanguage            
						Select Music_Title_Code From #TempAllCodes            
            
				   End     
				          
					If (Not Exists(Select Top 1 Music_Title_Code From @TblGenres) AND @GenresCode = '')
					Begin
	
						Insert InTo @TblGenres
						Select Music_Title_Code From #TempAllCodes

					End

				   If (Not Exists(Select Top 1 Music_Title_Code From @TblLyricist) AND @LyricistCode = '')            
				   Begin            
                
						Insert InTo @TblLyricist            
						Select Music_Title_Code From #TempAllCodes            
            
				   End            
            
				   If (Not Exists(Select Top 1 Music_Title_Code From @TblComposer) AND @ComposerCode = '')            
				   Begin            
             
						Insert InTo @TblComposer            
						Select Music_Title_Code From #TempAllCodes            
            
				   End            
            
				   If (Not Exists(Select Top 1 Music_Title_Code From @TblSinger) AND @SingerCode = '')            
				   Begin            
             
						Insert InTo @TblSinger            
						Select Music_Title_Code From #TempAllCodes            
            
				   End            
            
				   If (Not Exists(Select Top 1 Music_Title_Code From @TblStarCast) AND @StarCastCode = '')            
				   Begin            
             
						Insert InTo @TblStarCast            
						Select Music_Title_Code From #TempAllCodes            
            
				   End            
            
						Insert InTo #TempMusicTitleCodes(Music_Title_Code)            
						Select TML.Music_Title_Code From @TblMusicLabel TML
						INNER JOIN @TblTheme THM ON TML.Music_Title_Code = THM.Music_Title_Code
						INNER JOIN @TblLanguage TL ON TML.Music_Title_Code = TL.Music_Title_Code
						INNER JOIN @TblGenres TG ON TML.Music_Title_Code = TG.Music_Title_Code
						INNER JOIN @TblLyricist TLY ON TML.Music_Title_Code = TLY.Music_Title_Code
						INNER JOIN @TblComposer TC ON TML.Music_Title_Code = TC.Music_Title_Code
						INNER JOIN @TblSinger TS ON TML.Music_Title_Code = TS.Music_Title_Code
						INNER JOIN @TblStarCast TSC ON TML.Music_Title_Code = TSC.Music_Title_Code         
						--Intersect
						--Select Music_Title_Code From @TblTheme
						--Intersect
						--Select Music_Title_Code From @TblLanguage
						--Intersect
						--Select Music_Title_Code From @TblLyricist
						--Intersect
						--Select Music_Title_Code From @TblComposer
						--Intersect
						--Select Music_Title_Code From @TblSinger
						--Intersect
						--Select Music_Title_Code From @TblStarCast           
            
			  End            
              
	  Insert InTo #Temp(RowNumber, Music_Title_Code)            
	  SELECT ROW_NUMBER() OVER(ORDER BY MT.Last_UpDated_Time DESC) RowNumber, MT.Music_Title_Code            
	  FROM Music_Title (nolock) MT            
	  Inner Join #TempMusicTitleCodes tmp On tmp.Music_Title_Code = MT.Music_Title_Code            
	  Inner Join @TblAlbum alb On MT.Music_Album_Code = alb.Music_Album_Code          
	  Where 1=1            
	  AND ((ISNULL(RTRIM(LTRIM(@YearOfRelease)), '') = '') OR (Release_Year LIKE '%' + @YearOfRelease + '%'))            
	  AND (            
	   (@MusicNameText = '') OR (Music_Title_Name IN(SELECT number  FROM fn_Split_withdelemiter(N''+@MusicNameText, N''+ ',')))            
	  )            
	  AND ((@MusicTag = '') OR (Music_Tag  LIKE '%' + @MusicTag + '%'))  
	  AND ((@PublicDomain = '') OR (Public_Domain LIKE '%' + @PublicDomain + '%'))
	            
	 End            
 Else            
	Begin            
	 print('Inside generic search')            
		  --Insert InTo #TempMusicTitleCodes(Music_Title_Code)            
		  --Select 1            
		  DECLARE @SqlQuery NVARCHAR(MAX) = '            
		   Insert InTo #Temp(RowNumber, Music_Title_Code,Masters_Value,Last_Updated_Time)            
		   SELECT ROW_NUMBER() OVER(ORDER BY MT.Last_UpDated_Time DESC) RowNumber, MT.Music_Title_Code,MTS.Masters_Value,MT.Last_UpDated_Time            
		   FROM Music_Title (nolock) MT            
		   LEFT JOIN Music_Type (nolock) MTY ON MTY.Music_type_Code = MT.Music_type_Code                
		   LEFT JOIN Music_Album ma on ma.Music_Album_Code = mt.Music_Album_Code            
		   LEFT JOIN Music_Title_search MTS ON MT.Music_title_Code = MTS.Music_title_Code            
			Where 1=1 '+ @MusicTitleName            
		  EXEC(@SqlQuery)            
            
		  Set @ExactMatch = '%'+@ExactMatch+'%'            
		  Update #Temp Set Sort = '0' Where Masters_Value like @ExactMatch             
		  delete from T From #Temp T Inner Join            
		  (            
		   Select ROW_NUMBER()Over(Partition By Music_Title_Code Order By Sort asc) RowNum, Id, Music_Title_Code, Sort From #Temp            
		  )a On T.Id = a.Id and a.RowNum <> 1            
		  Select @RecordCount = Count(distinct (Music_Title_Code )) From #Temp            
             
		  Update a             
		  Set a.RowNumber = b.RowNumber            
		  From #Temp a            
		  Inner Join (            
		   --Select Rank() over(order by Sort Asc, Last_Updated_Time desc, ID ASC) RowNumber, ID From #Temp            
		   Select dense_Rank() over(order by Sort Asc, Last_Updated_Time desc, Music_Title_Code ASC) RowNumber, ID From #Temp            
		  ) As b On a.Id = b.Id            
 End          
   
 Select @RecordCount = Count(distinct (Music_Title_Code )) From #Temp          
	 If(@IsPaging = 'Y')            
		 Begin             
			 Delete From #Temp Where RowNumber < (((@PageNo - 1) * @PageSize) + 1) Or RowNumber > @PageNo * @PageSize             
		 End

                    
SELECT                 
 tmp.ID,tmp.RowNumber,tmp.Sort,  
 MT.Music_Title_Code,MT.Genres_Code,MT.Release_Year,ma.Music_Album_Name,MT.Music_Title_Name            
 ,ISNULL(Ma.Music_Album_Name, mt.Movie_Album) Movie_Album, MTV.Music_Type_Name as Music_Version_Name , MTY.Music_Type_Name,
  MT.Last_UpDated_Time            
 ,MT.Music_Tag,MTS.Masters_Value,MT.Duration_In_Min,MT.Language_Code,MT.Music_Type_Code            
 ,MT.Image_Path,MT.Is_Active,MT.Public_Domain,G.Genres_Name, 
   REVERSE(STUFF(REVERSE(  STUFF(                
      (                 
        SELECT                      
 cast(MTH.Music_Theme_Name as NVARCHAR(MAX)) + ', '                 
        FROM                 
        Music_Title_Theme MTT                
		 INNER JOIN Music_Title MT ON MT.Music_Title_Code = MTT.Music_Title_Code  
		 INNER JOIN Music_Theme MTH ON MTH.Music_Theme_Code = MTT.Music_Theme_Code            
       WHERE                 
        MT.Music_Title_Code = Tmp.Music_Title_Code                
       ORDER BY                
        MTH.Music_Theme_Name 
       FOR XML PATH(''), root('StarCast'), type                
  ).value('/StarCast[1]','Nvarchar(max)'                
 ),2,0, '')), 1, 2, '')) as Music_Theme_Name,
  REVERSE(STUFF(REVERSE(  STUFF(                
      (                 
       SELECT                 
 cast(Tal.Talent_Name  as NVARCHAR(MAX)) + ', '                 
       FROM                 
        Music_Title_Talent TT                
        INNER JOIN Role R on R.Role_Code = TT.Role_Code                
        INNER JOIN Talent Tal on tal.talent_Code = TT.Talent_code                
       WHERE                 
        TT.Music_Title_Code = Tmp.Music_Title_Code AND R.Role_Code in (@StarCast)                
       ORDER BY                
        Tal.Talent_Name                
       FOR XML PATH(''), root('StarCast'), type                
  ).value('/StarCast[1]','Nvarchar(max)'                
 ),2,0, '')), 1, 2, '')) as StarCast,                  
   REVERSE(STUFF(REVERSE(  STUFF(                
      (                 
       SELECT                 
 cast(Tal.Talent_Name  as NVARCHAR(MAX)) + ', '                 
       FROM                 
        Music_Title_Talent TT                
        INNER JOIN Role R on R.Role_Code = TT.Role_Code                
        INNER JOIN Talent Tal on tal.talent_Code = TT.Talent_code                
       WHERE                 
        TT.Music_Title_Code = Tmp.Music_Title_Code AND R.Role_Code in (@Singer)                
       ORDER BY                
        Tal.Talent_Name                
       FOR XML PATH(''), root('Singer'), type                
  ).value('/Singer[1]','Nvarchar(max)'                
 ),2,0, '')), 1, 2, '')) as Singer,                 
   REVERSE(STUFF(REVERSE(  STUFF(                
      (                 
       SELECT                 
        CAST(Tal.Talent_Name  AS NVARCHAR(MAX)) + ', '                 
       FROM                 
        Music_Title_Talent TT                
        INNER JOIN Role R ON R.Role_Code = TT.Role_Code                
        INNER JOIN Talent Tal ON tal.talent_Code = TT.Talent_code                
  WHERE                 
        TT.Music_Title_Code = Tmp.Music_Title_Code AND R.Role_Code IN (@Lyricist)                
       ORDER BY                
        Tal.Talent_Name               
       FOR XML PATH(''), root('Lyricist'), type                
  ).value('/Lyricist[1]','Nvarchar(max)'                
 ),2,0, '')), 1, 2, '')) as Lyricist,                 
 REVERSE(STUFF(REVERSE(  STUFF(                
      (                 
       SELECT                 
        CAST(Tal.Talent_Name  AS NVARCHAR(MAX)) + ', '                 
       FROM                 
        Music_Title_Talent TT                
        INNER JOIN Role R ON R.Role_Code = TT.Role_Code                
        INNER JOIN Talent Tal ON tal.talent_Code = TT.Talent_code                
       WHERE                 
        TT.Music_Title_Code = Tmp.Music_Title_Code AND R.Role_Code IN (@Composer)                
       ORDER BY                
        Tal.Talent_Name                
       FOR XML PATH(''), root('Music_Composer'), type                
  ).value('/Music_Composer[1]','Nvarchar(max)'                
 ),2,0, '')), 1, 2, ''))  as [Music Composer],                
     --REVERSE(STUFF(REVERSE(  STUFF(                
     -- (                 
       (SELECT TOP 1 TT.Music_Label_Name                
         --AS NVARCHAR(MAX)) + ', '                 
       FROM                 
        Music_Label TT                
        INNER JOIN Music_Title_Label R ON R.Music_Label_Code = TT.Music_Label_Code                 
       WHERE                 
        R.Music_Title_Code = Tmp.Music_Title_Code AND Effective_To IS NULL                
       ORDER BY                
        TT.Music_Label_Code DESC)                
     --  FOR XML PATH('')                
     -- ),1,0, ''           
     --)                
     --),1,2,''))                 
      as [Music Label] ,                
     REVERSE(STUFF(REVERSE(  STUFF(                
      (                 
       SELECT                 
        CAST(ML.Language_Name  AS NVARCHAR(MAX)) + ', '                 
       FROM                 
        Music_Title_Language TL                
        INNER JOIN Music_Language ML ON ML.Music_Language_Code=TL.Music_Language_Code                
       WHERE                 
        TL.Music_Title_Code = Tmp.Music_Title_Code                 
       ORDER BY                
        ML.Language_Name                
       FOR XML PATH(''), root('Language_Name'), type                
  ).value('/Language_Name[1]','Nvarchar(max)'                
 ),2,0, '')), 1, 2, '')) as [Language_Name]     
	 into #Temp_Header	                           
 FROM                 
  #Temp Tmp    

 INNER JOIN Music_Title MT ON Tmp.Music_Title_Code = MT.Music_Title_Code   
 LEFT JOIN Genres G ON G.Genres_Code = MT.Genres_Code                
 LEFT JOIN Music_Type (nolock) MTY ON MTY.Music_type_Code = MT.Music_type_Code   
 LEFT JOIN Music_Type (nolock) MTV ON MTV.Music_type_Code = MT.Music_Version_Code                  
 LEFT JOIN Music_Album ma on ma.Music_Album_Code = mt.Music_Album_Code            
 LEFT JOIN Music_Title_search MTS ON MT.Music_title_Code = MTS.Music_title_Code            
 WHERE                 
  (RowNumber BETWEEN (((@PageNo - 1)* @PageSize) + 1) AND (@PageNo * @PageSize)) OR ISNULL(@PageSize,'')=''                
 ORDER BY                
 Tmp.RowNumber  
         
  --Last_UpDated_Time DESC               
            
--SET @Time2 = GETDATE()            
--SELECT  DATEDIFF(MILLISECOND,@Time1,@Time2) AS Elapsed_MS     
     SELECT  
		 @Col_Head01 = CASE WHEN  SM.Message_Key = 'MusicTrackName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head01 END,
		 @Col_Head02 = CASE WHEN  SM.Message_Key = 'MovieAlbum' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head02 END,
		 @Col_Head03 = CASE WHEN  SM.Message_Key = 'MusicTypeName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head03 END, 
		 @Col_Head04 = CASE WHEN  SM.Message_Key = 'MusicTag' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head04 END,
		 @Col_Head05 = CASE WHEN  SM.Message_Key = 'Lengthmin' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head05 END,
		 @Col_Head06 = CASE WHEN  SM.Message_Key = 'MusicLanguage' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head06 END,
		 @Col_Head07 = CASE WHEN  SM.Message_Key = 'Singer' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head07 END,
		 @Col_Head08 = CASE WHEN  SM.Message_Key = 'Lyricist' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head08 END,
		 @Col_Head09 = CASE WHEN  SM.Message_Key = 'MusicComposer' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head09 END,
		 @Col_Head10 = CASE WHEN  SM.Message_Key = 'MusicLabel' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head10 END,
		 @Col_Head11 = CASE WHEN  SM.Message_Key = 'YearOfRelease' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head11 END,
		 @Col_Head12 = CASE WHEN  SM.Message_Key = 'PublicDomain' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head12 END,
		 @Col_Head13 = CASE WHEN  SM.Message_Key = 'SongStarCast' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head13 END,
		 @Col_Head14 = CASE WHEN  SM.Message_Key = 'GenresName' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head14 END,
		 @Col_Head16 = CASE WHEN  SM.Message_Key = 'MusicVersion' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head16 END,
		 @Col_Head17 = CASE WHEN  SM.Message_Key = 'MusicTheme' AND ISNULL(SLM.Message_Desc,'') <> '' THEN SLM.Message_Desc ELSE @Col_Head17 END

		    	
	  FROM System_Message SM  
		 INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code  
		 AND SM.Message_Key IN ('MusicTrackName','MovieAlbum','MusicTypeName','MusicTag','Lengthmin','MusicLanguage','Singer','Lyricist','MusicComposer','MusicLabel','YearOfRelease','PublicDomain','SongStarCast','GenresName', 'MusicVersion','MusicTheme')  
		 INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode  

    SELECT [ID],[RowNumber],[Sort],[Music_Title_Code],[Genres_Code],[Release_Year],[Music_Album_Name],[Music_Title_Name],[Movie_Album],[Music_Type_Name],[Last_UpDated_Time],
		[Music_Tag],[Masters_Value],[Duration_In_Min],[Language_Code],[Music_Type_Code],[Image_Path],[Is_Active],[Singer],[Lyricist],[Music Composer],[Music Label],[Language_Name],[Public_Domain],[StarCast],[Genres_Name],[Music_Version],[Music_Theme]
	 FROM (
		 SELECT
			   sorter = 1,
			   CAST(ID AS INT) AS [ID],CAST(RowNumber AS VARCHAR(200)) AS [RowNumber],CAST(Sort AS VARCHAR(10)) AS [Sort],
			   CAST(Music_Title_Code AS VARCHAR(200)) AS [Music_Title_Code],CAST(Genres_Code AS VARCHAR(200)) AS [Genres_Code], CAST(Release_Year AS VARCHAR(200)) AS [Release_Year],
			   CAST(Music_Album_Name AS VARCHAR(200)) AS [Music_Album_Name],CAST(Music_Title_Name AS VARCHAR(200)) AS [Music_Title_Name],CAST(Movie_Album AS VARCHAR(200)) AS [Movie_Album],
			   CAST(Music_Type_Name AS VARCHAR(200)) AS [Music_Type_Name],Last_UpDated_Time,CAST(Music_Tag AS VARCHAR(200)) AS [Music_Tag],CAST(Masters_Value AS VARCHAR(200)) AS [Masters_Value],
			   CAST(Duration_In_Min AS VARCHAR (200)) AS [Duration_In_Min],CAST(Language_Code AS VARCHAR(200)) AS [Language_Code],CAST(Music_Type_Code AS VARCHAR(200)) AS [Music_Type_Code],
			   CAST(Image_Path AS VARCHAR(200)) AS [Image_Path],CAST(Is_Active AS VARCHAR(200)) AS [Is_Active],CAST(Singer AS VARCHAR(200)) AS [Singer],CAST(Lyricist AS VARCHAR(200)) AS [Lyricist],
			   CAST([Music Composer] AS VARCHAR(200)) AS [Music Composer],CAST( [Music Label] AS VARCHAR(200)) AS [Music Label],CAST(Language_Name AS VARCHAR(200)) AS [Language_Name],
			   CAST(Public_Domain AS VARCHAR(200)) AS [Public_Domain],CAST(StarCast AS VARCHAR(MAX)) AS [StarCast],CAST(Genres_Name AS VARCHAR(MAX)) AS [Genres_Name],
			   CAST([Music_Version_Name] AS VARCHAR(MAX)) AS Music_Version, CAST([Music_Theme_Name] AS VARCHAR(MAX)) AS Music_Theme
			  
		   From #Temp_Header
	  UNION ALL
			  SELECT 0, 1,'RowNumber','Sort','Music Title Code','Genres Code',@Col_Head11,'Music Album Name',@Col_Head01,@Col_Head02,@Col_Head03,GETDATE(),
			  @Col_Head04,'Masters_Value',@Col_Head05,'Language_Code','Music_Type_Code','Image_Path','Is_Active',@Col_Head07,@Col_Head08,@Col_Head09,@Col_Head10,@Col_Head06,@Col_Head12,@Col_Head13,@Col_Head14,@Col_Head16,@Col_Head17
		) X   
		ORDER BY Sorter


	--select * from #Temp_Header
	--Select * from #Temp

       DROP TABLE #temp     
	   DROP TABLE #Temp_Header              
END 

--ID,	RowNumber,	Sort,	Music_Title_Code,	Genres_Code	Release_Year,	Music_Album_Name,	Music_Title_Name,	Movie_Album,	Music_Type_Name,	Last_UpDated_Time,	Music_Tag,	Masters_Value,	Duration_In_Min,	Language_Code,	Music_Type_Code,	Image_Path,	Is_Active,	Singer,	Lyricist,	Music Composer,	Music Label,	Language_Name 

--ID	RowNumber	Sort	Music_Title_Code	Genres_Code	Release_Year	Music_Album_Name	Music_Title_Name	Movie_Album	Music_Type_Name	Last_UpDated_Time	Music_Tag	Masters_Value	Duration_In_Min	Language_Code	Music_Type_Code	Image_Path	Is_Active	Singer	Lyricist	Music Composer	Music Label	Language_Name
--1	1	1	4990	NULL	2010	Album	Chitiya Kalayian123	Album	Album	2017-05-31 13:24:29.917	NULL	Chitiya Kalayian123 Album  Ajitt2,alka3,Farhan Akhtar,Raveena1,SonuNiiii T-Series Hindi	5.00	NULL	1	NULL	N	alka3	Farhan Akhtar	SonuNiiii	T-Series	Hindi




--Sp_Helptext USP_Export_Table_To_Excel 