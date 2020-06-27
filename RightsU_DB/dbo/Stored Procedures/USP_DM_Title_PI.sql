CREATE PROCEDURE [dbo].[USP_DM_Title_PI]  
(  
	@Title_Import Title_Import READONLY,  
	@User_Code INT= 143  
)  
AS  
-- =============================================  
-- Author:  SAGAR MAHAJAN  
-- Create date: 9 Sept 2015  
-- Description: Insert Record into Dm_Title  
-- =============================================  
BEGIN  
  
  SET NOCOUNT ON;    
  --TRUNCATE TABLE DM_Title   
  DECLARE @Error_Message NVARCHAR(MAX), @DM_Master_Import_Code INT  
  Select Top 1 @DM_Master_Import_Code = DM_Master_Import_Code From @Title_Import       
  INSERT INTO DM_Title  
  (  
	   [Original Title (Tanil/Telugu)], 
	   [Title/ Dubbed Title (Hindi)],
	   [Title Type] ,  
	   [Original Language (Hindi)] ,
	   [Original_Language],
	   [Year of Release],  
	   [Duration (Min)] ,  
	   [Key Star Cast],  
	   [Director Name],  
	   [Music_Label],  
	   [Synopsis],  
	   [Record_Status],  
	   [DM_Master_Import_Code],  
	   [Excel_Line_No],
	   [Is_Ignore],
	   [Program Category]
  )  
  SELECT    
	   [Title_Name],  
	   [Original_Title],
	   [Title_Type] ,  
	   [Title_Language] , 
	   [Original_Language],
	   [Year_of_Release],  
	   [Duration],  
	   [Key_Star_Cast],     
	   [Director],  
	   [Music_Label],  
	   [Synopsis],  
	   'N',  
	   [DM_Master_Import_Code],  
	   [Excel_Line_No],
	   'N',
	   [Program_Category]
  FROM @Title_Import   
  
  DECLARE @Title_Type_Music VARCHAR(500)  
    
  SELECT @Title_Type_Music = Parameter_Value from System_Parameter_New where Parameter_Name='Title_Type_Music'  
  select @Title_Type_Music  
  UPDATE DM_Title SET [Music_Label]='' where [Title Type]!=@Title_Type_Music  
  --select * from DM_Title  
  
  EXEC USP_Validate_Title_Import  @DM_Master_Import_Code     
   
   IF EXISTS(SELECT Record_Status FROM DM_Title WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
	BEGIN
		SELECT   
		  [Original Title (Tanil/Telugu)] AS Title_Name,  
		  [Title/ Dubbed Title (Hindi)] AS Original_Title,
		  [Title Type] AS Title_Type,  
		  [Original Language (Hindi)] AS Title_Language,  
		  [Original_Language] AS Original_Language,
		  [Year of Release] AS Year_of_Release,  
		  [Duration (Min)]  AS Duration,  
		  [Director Name] AS Director,  
		  [Key Star Cast] AS Key_Star_Cast,  
		  [Synopsis] AS Synopsis,  
		  [Music_Label] AS Music_Label,  
		  (ISNULL([Error_Message],'')) AS Error_Messages   
	   FROM DM_Title   
	   WHERE [Record_Status] = 'E'  
	UPDATE DM_Master_Import Set [Status] = 'E' where DM_Master_Import_Code  = @DM_Master_Import_Code
	END
	ELSE
	BEGIN
		UPDATE DM_Master_Import Set [Status] = 'Q' where DM_Master_Import_Code  = @DM_Master_Import_Code
	END


 -- IF NOT EXISTS(SELECT Record_Status FROM DM_Title WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
 -- BEGIN  
 --  EXEC USP_DM_Title_PIV @DM_Master_Import_Code  
 --  IF((Select [Status] From DM_Master_Import Where DM_Master_Import_Code = @DM_Master_Import_Code) = 'P')  
 -- BEGIN  
 --  EXEC USP_DM_Title_PIII @DM_Master_Import_Code  
 -- END  
  
 -- END  
 --ELSE  
 --BEGIN   
 -- SELECT   
 -- [Original Title (Tanil/Telugu)] AS Title_Name,  
 -- [Title Type] AS Title_Type,  
 -- [Original Language (Hindi)] AS Title_Language,  
 -- [Year of Release] AS Year_of_Release,  
 -- [Duration (Min)]  AS Duration,  
 -- [Director Name] AS Director,  
 -- [Key Star Cast] AS Key_Star_Cast,  
 -- [Synopsis] AS Synopsis,  
 -- [Music_Label] AS Music_Label,  
 -- (ISNULL([Error_Message],'')) AS Error_Messages   
 -- FROM DM_Title   
 -- WHERE [Record_Status] = 'E'  
 -- UPDATE DM_Master_Import Set [Status] = 'E' Where DM_Master_Import_Code = @DM_Master_Import_Code  
 --END  
END   
  