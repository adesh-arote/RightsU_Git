alter PROCEDURE [dbo].[USP_Title_Details_Report_Filter]      
(    
	 @Title_Code VARCHAR(MAX) ='0',  
	 @Deal_Type_Code VARCHAR(MAX) = '0',
	 @Title_Language_Code Varchar(Max)='0',
	 @KeyStarcastCode Varchar(Max)='0',
	 @Director_Code Varchar(Max)='0',
	 @Producer_Code Varchar(Max)='0',
	 @YearofRelease Varchar(Max)='0',
	 @Genres_Code VARCHAR(MAX)='0',
	 @OriginalTitle_Code VARCHAR(MAX) ='0',  
	 @OriginalLanguage_Code VARCHAR(MAX)='0',
	 @User_Code VARCHAR(MAX)='0'
)      
AS
BEGIN

	
	SET NOCOUNT ON;      
	SET FMTONLY OFF;      
      
	SELECT  @Title_Code = ISNULL(@Title_Code,' ') ,
			@Deal_Type_Code = ISNULL(@Deal_Type_Code,' ') ,
			@Title_Language_Code = ISNULL(@Title_Language_Code,' ') ,
			@KeyStarcastCode = ISNULL(@KeyStarcastCode,' ') ,
			@Director_Code = ISNULL(@Director_Code,' ') ,
			@Producer_Code = ISNULL(@Producer_Code,' ') ,
			@YearofRelease = ISNULL(@YearofRelease,' ') ,
			@Genres_Code = ISNULL(@Genres_Code,' ') ,
			@OriginalTitle_Code = ISNULL(@OriginalTitle_Code,' ') ,
			@OriginalLanguage_Code = ISNULL(@OriginalLanguage_Code,' '),
			@User_Code = ISNULL(@User_Code,' ') 

	 
	 DECLARE  @Title_Names NVARCHAR(MAX), @Original_Title_Names NVARCHAR(MAX), @TitleLanguage_Names  NVARCHAR(MAX), @OrigionalTitleLanguage_Names  NVARCHAR(MAX),
			  @Deal_Type_Name NVARCHAR(MAX), @GenreName NVARCHAR(MAX),  @KeyStarcast_Name NVARCHAR(MAX), @Director_Name NVARCHAR(MAX), @Producer_Name NVARCHAR(MAX),
			  @UserNames NVARCHAR(MAX)


	 SET @Title_Names =ISNULL(STUFF((SELECT DISTINCT ',' + t.Title_Name       
	 FROM Title t       
	 WHERE t.Title_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Title_Code,',') WHERE number NOT IN('0', ''))      
	 FOR XML PATH(''), TYPE      
		).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '') 

	 SET @Title_Names = Case when @Title_Code = '' Then 'NA' ELSE @Title_Names END

	 SET @Original_Title_Names =ISNULL(STUFF((SELECT DISTINCT ',' + t.Original_Title       
	 FROM Title t       
	 WHERE t.Title_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@OriginalTitle_Code,',') WHERE number NOT IN('0', ''))      
	 FOR XML PATH(''), TYPE      
		).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '') 

	 SET @Original_Title_Names = Case when @OriginalTitle_Code = '' Then 'NA' ELSE @Original_Title_Names END

	 SET @TitleLanguage_Names =ISNULL(STUFF((SELECT DISTINCT ',' + l.Language_Name      
	 FROM Language l      
	 WHERE l.Language_Code IN (select number from dbo.fn_Split_withdelemiter(@Title_Language_Code,',') Where number NOT IN ('0',''))      
	 FOR XML PATH(''), TYPE      
	 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')     
 
	 SET @TitleLanguage_Names = Case when @Title_Language_Code = '' Then 'NA' ELSE @TitleLanguage_Names END

	 SET @OrigionalTitleLanguage_Names =ISNULL(STUFF((SELECT DISTINCT ',' + l.Language_Name      
	 FROM Language l      
	 WHERE l.Language_Code IN (select number from dbo.fn_Split_withdelemiter(@OriginalLanguage_Code,',') Where number NOT IN ('0',''))      
	 FOR XML PATH(''), TYPE      
	 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')     
 
	 SET @OrigionalTitleLanguage_Names = Case when @OriginalLanguage_Code = '' Then 'NA' ELSE @OrigionalTitleLanguage_Names END

	 SET @Deal_Type_Name =ISNULL(STUFF((SELECT DISTINCT ',' + DT.Deal_Type_Name 
	 FROM Deal_Type DT     
	 WHERE DT.Deal_Type_Code IN (select number from dbo.fn_Split_withdelemiter(@Deal_Type_Code,',') Where number NOT IN ('0',''))      
	 FOR XML PATH(''), TYPE      
	 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    

	 SET @Deal_Type_Name = Case when @Deal_Type_Code = '' Then 'NA' ELSE @Deal_Type_Name END
	 
	 SET @GenreName =ISNULL(STUFF((SELECT DISTINCT ',' + g.Genres_Name
	 FROM Genres g     
	 WHERE g.Genres_Code IN (select number from dbo.fn_Split_withdelemiter(@Genres_Code,',') Where number NOT IN ('0',''))      
	 FOR XML PATH(''), TYPE      
	 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    

	 SET @GenreName = Case when @Genres_Code = '' Then 'NA' ELSE @GenreName END

	 SET @KeyStarcast_Name =ISNULL(STUFF((SELECT DISTINCT ',' + t.Talent_Name
	 FROM Talent t     
	 WHERE t.Talent_Code IN (select number from dbo.fn_Split_withdelemiter(@KeyStarcastCode,',') Where number NOT IN ('0',''))      
	 FOR XML PATH(''), TYPE      
	 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    
	 
	 SET @KeyStarcast_Name = Case when @KeyStarcastCode = '' Then 'NA' ELSE @KeyStarcast_Name END
	 
	 SET @Director_Name =ISNULL(STUFF((SELECT DISTINCT ',' + t.Talent_Name
	 FROM Talent t     
	 WHERE t.Talent_Code IN (select number from dbo.fn_Split_withdelemiter(@Director_Code,',') Where number NOT IN ('0',''))      
	 FOR XML PATH(''), TYPE      
	 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    
	 
	 SET @Director_Name = Case when @Director_Code = '' Then 'NA' ELSE @Director_Name END
	 
	 SET @Producer_Name =ISNULL(STUFF((SELECT DISTINCT ',' + t.Talent_Name
	 FROM Talent t     
	 WHERE t.Talent_Code IN (select number from dbo.fn_Split_withdelemiter(@Producer_Code,',') Where number NOT IN ('0',''))      
	 FOR XML PATH(''), TYPE      
	 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')    
	 
	 SET @Producer_Name = Case when @Producer_Code = '' Then 'NA' ELSE @Producer_Name END

	 SET @UserNames =ISNULL(STUFF((SELECT DISTINCT ',' + U.Login_Name      
	 FROM Users U      
	 WHERE U.Users_Code IN (select number from dbo.fn_Split_withdelemiter(@User_Code,',') Where number NOT IN ('0',''))      
	 FOR XML PATH(''), TYPE      
	 ).value('.', 'NVARCHAR(MAX)'),1,1,''), '')      

	 SET @UserNames = Case when @User_Code = '' Then 'NA' ELSE @UserNames END

	 SET @YearofRelease = Case when @YearofRelease = '' Then 'NA' ELSE @YearofRelease END


	 SELECT  @Title_Names Title_Name, @Original_Title_Names Original_Title_Names, @TitleLanguage_Names TitleLanguage_Names, @OrigionalTitleLanguage_Names OrigionalTitleLanguage_Names,
			 @Deal_Type_Name Deal_Type_Name, @GenreName GenreName, @KeyStarcast_Name KeyStarcast_Name, @Director_Name Director_Name, @Producer_Name Producer_Name, @UserNames UserNames,
			 Parameter_Value AS 'BGColor', GETDATE() AS CreatedOn,   @YearofRelease YearofRelease,
			 (SELECT  TOP (1) Parameter_Value  FROM  System_Parameter_New  WHERE  (Parameter_Name = 'FontColor')) AS 'FontColor'    
	FROM     System_Parameter_New AS System_Parameter_New_1    
	WHERE    (Parameter_Name = 'ReportBGColor') 

END

