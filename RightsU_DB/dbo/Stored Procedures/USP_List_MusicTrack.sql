CREATE PROCEDURE [dbo].[USP_List_MusicTrack]    
(    
 @searchText NVARCHAR(500) = NULL    
)    
AS    
BEGIN    
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_MusicTrack]', 'Step 1', 0, 'Started Procedure', 0, ''  
	
		SELECT MT.Music_Title_Code, MT.Music_Title_Name, MT.Release_Year, MT.Duration_In_Min, 
		CASE WHEN LEN(MT.Movie_Album) > 0 THEN MT.Movie_Album ELSE MA.Music_Album_Name END AS [Movie_Album], ML.Music_Label_Name 
		FROM Music_Title MT  (NOLOCK)   
		INNER JOIN Music_Title_Label MTL (NOLOCK) ON MT.Music_Title_Code = MTL.Music_Title_Code    
		INNER JOIN Music_Label ML (NOLOCK) ON MTL.Music_Label_Code = ML.Music_Label_Code    
		LEFT JOIN Music_Album MA (NOLOCK) ON MA.Music_Album_Code = MT.Music_Album_Code
		WHERE (
			(MT.Music_Title_Name LIKE N'%' + @searchText + '%' OR     
			MT.Movie_Album LIKE N'%' + @searchText + '%' OR    
			MA.Music_Album_Name LIKE N'%' + @searchText + '%' OR    
			ML.Music_Label_Name LIKE N'%' + @searchText + '%') AND MT.Is_Active = 'Y'
		)
		AND  MTL.Effective_To IS NULL  
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_MusicTrack]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''  
END 