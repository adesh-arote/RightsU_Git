CREATE PROCEDURE [dbo].[USP_DM_Music_Title_PI]   
	@Music_Title_Import Music_Title_Import READONLY,  
	@User_Code INT=143  
AS  
BEGIN  
  
 /* -- RECORD_STATUS  
 N = No Error  
 E = File Level Error  
 R = Records are in Conflict  
 P = No Conflict (Proper and ready to process)  
 S = Sucess  
 */  
  
	SET NOCOUNT ON;    
	DECLARE @Error_Message NVARCHAR(MAX), @DM_Master_Import_Code Int  
	Select Top 1 @DM_Master_Import_Code = DM_Master_Import_Code From @Music_Title_Import  
	INSERT INTO DM_Music_Title  
	(  
		[Music_Title_Name],   
		[Movie_Album],  
		[Title_Type] ,  
		[Title_Language] ,  
		[Year_of_Release],  
		[Duration] ,  
		[Singers],  
		[Lyricist],  
		[Music_Director],  
		[Music_Label],  
		[Record_Status],  
		[Genres],  
		[Star_Cast],  
		[Music_Version],  
		[Effective_Start_Date],  
		[Theme],  
		[Music_Tag] ,  
		[Movie_Star_Cast],  
		[Music_Album_Type],  
		[DM_Master_Import_Code],  
		[Excel_Line_No],
		[Is_Ignore]
	)    
	SELECT    
		LTRIM(RTRIM(Replace([Music_Title_Name], ' ', ' '))),  
		LTRIM(RTRIM(Replace([Movie_Album], ' ', ' '))),  
		[Title_Type],  
		[Title_Language],  
		[Year_of_Release],  
		[Duration],  
		[Singers],  
		[Lyricist],  
		[Music_Director],  
		[Music_Label],  
		'N',  
		[Genres],  
		[Star_Cast],  
		[Music_Version],  
		[Effective_Start_Date],  
		[Theme],  
		[Music_Tag],  
		[Movie_Star_Cast],  
		[Music_Album_Type],  
		[DM_Master_Import_Code],  
		[Excel_Line_No] ,
		'N' 
	FROM @Music_Title_Import   
    
		EXEC USP_Validate_Music_Title_Import @DM_Master_Import_Code 
		 
   IF EXISTS(SELECT Record_Status FROM DM_Music_Title WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
	BEGIN
		SELECT   
		   [IntCode]+1 AS Line_Number,  
		   [Music_Title_Name] ,   
		   [Movie_Album],  
		   [Title_Language] ,  
		   [Year_of_Release],  
		   [Music_Label],  
		   [Star_Cast],  
		   [Movie_Star_Cast],  
		   [Music_Album_Type],  
		Substring([Error_Message],2,len([Error_Message])-1) AS Error_Messages  FROM DM_Music_Title   
	WHERE [Record_Status] = 'E'  
	UPDATE DM_Master_Import Set [Status] = 'E' where DM_Master_Import_Code  = @DM_Master_Import_Code
	END
	ELSE
	BEGIN
		UPDATE DM_Master_Import Set [Status] = 'Q' where DM_Master_Import_Code  = @DM_Master_Import_Code
	END
END   
     
  
  
  
  
  
  
  
  
  
  