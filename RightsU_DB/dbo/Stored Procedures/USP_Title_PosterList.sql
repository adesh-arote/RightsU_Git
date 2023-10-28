CREATE PROCEDURE [dbo].[USP_Title_PosterList]
	@Title_Code  VARCHAR(MAX),
	@Title_language_Code  VARCHAR(MAX),
	@Title_Star_Cast VARCHAR(MAX),
	@Title_Genre_Code VARCHAR(MAX),
	@Title_Type  VARCHAR(MAX),
	@Poster_Status  VARCHAR(MAX)
AS
--Declare @Title_Code  VARCHAR(MAX) = '',--'46088',
--	@Title_language_Code  VARCHAR(MAX) = '',
--	@Title_Star_Cast VARCHAR(MAX) = '',--'8516,14735,13612,22695,5084,18633',
--	@Title_Genre_Code VARCHAR(MAX) = '1109',
--	@Title_Type  VARCHAR(MAX) = '',
--	@Poster_Status  VARCHAR(MAX) = ''
BEGIN
Declare @Where Nvarchar(MAX)= '',@Genre_Code Nvarchar(MAX)= '';
  SET @Where = @Where + ' Where 1=1'

  IF(ISNULL(@Title_Code,'') <> '')
    Begin
     SET @Where = @Where + ' AND T.Title_Code in('+@Title_Code+')'
    End
   
   IF(ISNULL(@Title_language_Code,'') <> '')
    Begin
     SET @Where = @Where + ' AND T.Title_Language_Code in('+@Title_language_Code+')'
    End

	IF(ISNULL(@Title_Star_Cast,'') <> '')
    Begin
     SET @Where = @Where + ' AND TL.Talent_Code in('+@Title_Star_Cast+')'
    End

	IF(ISNULL(@Title_Genre_Code,'') <> '')
    Begin
     SET @Genre_Code = @Genre_Code + ' AND G.Genres_Code in('+@Title_Genre_Code+')'
	 SET @Where = @Where + ' AND TG1.Genres_Code in('+@Title_Genre_Code+')'
	 print @Genre_Code
    End

	IF(ISNULL(@Title_Type,'') <> '')
    Begin
     SET @Where = @Where + ' AND DT.Deal_Type_Code in('+@Title_Type+')'
    End

	IF(ISNULL(@Poster_Status,'') <> '')
    Begin
	  IF(@Poster_Status = 'Y')
	  begin
	  SET @Where = @Where + ' AND T.Title_Image IS NOT NULL'
	  end
	  else
	  begin
	  SET @Where = @Where + ' AND T.Title_Image IS NULL'
	  end
    End
	print @Where
     EXEC('select DISTINCT T.Title_Code as Title_Code,T.Title_Name as Title_Name,T.Title_Image as Title_Image,DT.Deal_Type_Name as Deal_Type_Name,DT.Deal_Type_Code as Deal_Type_Code,LT.Language_Name as Language_Name,
		  stuff(
				(select '',''+g.genres_name from Genres g
				inner join Title_Geners tg on tg.Genres_Code = g.Genres_Code where  t.Title_Code = tg.Title_Code AND 1=1 '+@Genre_Code+'
				for xml path(''''), type).value(''(./text())[1]'',''varchar(max)''), 1, 1, '''') as Genres_Name,
			Case When T.Title_Image is Not null Then ''Y'' Else ''N'' End as Title_Poster
		  from title T
		Inner Join Deal_Type DT On DT.Deal_Type_Code = T.Deal_Type_Code
        Inner Join Language LT On LT.Language_Code = T.Title_Language_Code
		Inner Join Title_Geners TG1 On TG1.Title_code = T.Title_Code
		left Join Title_Talent TL On TL.Title_Code = T.Title_Code' + @where+' Order by T.Title_Code Desc')
END