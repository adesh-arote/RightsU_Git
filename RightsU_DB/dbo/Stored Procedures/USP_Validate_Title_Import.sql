CREATE PROCEDURE [dbo].[USP_Validate_Title_Import]  
@DM_Master_Import_Code INt  
AS  
-- =============================================  
-- Author:  SAGAR MAHAJAN  
-- Create date: 9 Sept 2015  
-- Description: Insert Record into Dm_Title  
-- =============================================  
BEGIN  
  SET NOCOUNT ON;    
  DECLARE @Error_Message  NVARCHAR(MAX) , @IsAllowProgramCategory VARCHAR(2), @IsTitleDurationMandatory VARCHAR(10) 
  PRINT 'validation Proc. Start' 
  IF EXISTS (SELECT [Excel_Line_No] FROM  DM_Title WHERE ISNULL(RTRIM(LTRIM([Excel_Line_No])),'') = '')
  BEGIN  
   UPDATE Dm_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '') + '~Sr. No. is Mandatory in Excel'   
   WHERE ISNULL(Record_Status,'') <> 'C' AND ISNULL(RTRIM(LTRIM([Excel_Line_No])),'') = '' AND DM_Master_Import_Code = @DM_Master_Import_Code  
  END   
  --Validate Title Name blank  
  IF EXISTS (SELECT [Original Title (Tanil/Telugu)] FROM  DM_Title WHERE ISNULL(RTRIM(LTRIM([Original Title (Tanil/Telugu)])),'') = '')  
  BEGIN  
   UPDATE Dm_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '') + '~Title Name is Mandatory in Excel'   
   WHERE ISNULL(Record_Status,'') <> 'C' AND ISNULL(RTRIM(LTRIM([Original Title (Tanil/Telugu)])),'') = '' AND DM_Master_Import_Code = @DM_Master_Import_Code  
  END  
  --Validate Title Type blank  
  IF EXISTS (SELECT [Title Type] FROM  DM_Title WHERE ISNULL(RTRIM(LTRIM([Title Type])),'') = '')  
  BEGIN  
   UPDATE Dm_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '')  +  '~Title Type is Mandatory in Excel'   
   WHERE ISNULL(Record_Status,'') <> 'C'  AND ISNULL(RTRIM(LTRIM([Title Type])),'') = ''  AND DM_Master_Import_Code = @DM_Master_Import_Code  
  END  
  --Validate Title Lang. blank  
  IF EXISTS (SELECT [Original Language (Hindi)] FROM  DM_Title WHERE ISNULL(RTRIM(LTRIM([Original Language (Hindi)])),'') = '')  
  BEGIN  
   UPDATE Dm_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') +  '~Title Language is Mandatory in Excel'  
   WHERE ISNULL(Record_Status,'') <> 'C'  AND ISNULL(RTRIM(LTRIM([Original Language (Hindi)])),'') = ''  AND DM_Master_Import_Code = @DM_Master_Import_Code  
  END    
  
  SELECT @IsAllowProgramCategory = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'Is_Allow_Program_Category'
	IF(@IsAllowProgramCategory = 'Y')
	BEGIN
		UPDATE Dm_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '')  +  '~Program Category is Mandatory in Excel'   
		WHERE ISNULL(Record_Status,'') <> 'C'  AND ISNULL(RTRIM(LTRIM([Program Category])),'') = ''  AND DM_Master_Import_Code = @DM_Master_Import_Code  

		--UPDATE DM_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') + '~Duration(Min) is Mandatory in Excel'
		--WHERE ISNULL(Record_Status,'') <> 'C'  AND ISNULL(RTRIM(LTRIM([Duration (Min)])),'') = ''  AND DM_Master_Import_Code = @DM_Master_Import_Code  
 	END

  SELECT @IsTitleDurationMandatory = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'IsTitleDurationMandatory'
	IF(@IsTitleDurationMandatory = 'Y')
	BEGIN
		UPDATE DM_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') + '~Duration(Min) is Mandatory in Excel'
		WHERE ISNULL(Record_Status,'') <> 'C'  AND ISNULL(RTRIM(LTRIM([Duration (Min)])),'') = ''  AND DM_Master_Import_Code = @DM_Master_Import_Code  
 	END

  --validate Year of release  
  UPDATE Dm_Title SET Record_Status = 'E' ,[Error_Message] = ISNULL([Error_Message], '') +  '~Year of Relase should be Numeric Value in Excel'  
  WHERE ISNUMERIC([Year of Release] + '.0e0') != 1  AND ISNULL([Year of Release],'') <> '' AND Record_Status = 'N'  AND DM_Master_Import_Code = @DM_Master_Import_Code  
  
  UPDATE Dm_Title SET Record_Status = 'E' ,[Error_Message] = ISNULL([Error_Message], '') +  '~Year of Relase should be Maximum with 4 Numeric Value in Excel'  
  WHERE ISNUMERIC([Year of Release] + '.0e0') = 1  AND  LEN([Year of Release]) != '4'  AND ISNULL([Year of Release],'') <> '' AND ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code  
  
  UPDATE Dm_Title SET [Year of Release] = null  
  WHERE [Year of Release]=''  
  -- validate synopsis
 
  --validate duration  
  UPDATE Dm_Title SET Record_Status = 'E' ,[Error_Message] = ISNULL([Error_Message], '') +  '~Duration should be a number in Excel'  
  WHERE ISNUMERIC([Duration (Min)] + 'e0') != 1  AND ISNULL([Duration (Min)],'') <> '' AND ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code  
  
  UPDATE Dm_Title SET [Duration (Min)]=null  
  WHERE [Duration (Min)]=''  
  
 
  --Validate Title Type blank  
  DECLARE @TitleType VARCHAR(500)  
  SELECT @TitleType = Parameter_Value from System_Parameter_New where Parameter_Name='Title_Type_Music'  
  IF EXISTS (SELECT  [Music_Label] FROM  DM_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code and ISNULL(RTRIM(LTRIM([Music_Label])),'') = '' AND [Title Type]=@TitleType)   
  BEGIN  
   UPDATE Dm_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '')  +  '~Music Lable is Mandatory For Embedded Music'   
   WHERE ISNULL(Record_Status,'') <> 'C'  AND ISNULL(RTRIM(LTRIM([Music_Label])),'') = '' AND [Title Type]='Embedded Music' AND DM_Master_Import_Code = @DM_Master_Import_Code   
  END  
  
  --Title Name Duplicate IN Excel  
  UPDATE DM_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') + '~' + [Original Title (Tanil/Telugu)] + ' - Title Name Is duplicate In excel sheet'  
  WHERE [Original Title (Tanil/Telugu)] IN   
  (  
   SELECT [Original Title (Tanil/Telugu)] FROM DM_Title  
   WHERE ISNULL(Record_Status,'') <> 'C'  AND DM_Master_Import_Code = @DM_Master_Import_Code    
   GROUP BY [Original Title (Tanil/Telugu)]  
   HAVING COUNT([Original Title (Tanil/Telugu)]) > 1  
  )  
  AND ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code   --AND ISNULL(RTRIM(LTRIM([Error_Message])),'') = ''  

   -- Original Title Name Duplicate IN Excel  
  --UPDATE DM_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') + '~' + [Title/ Dubbed Title (Hindi)] + ' - Original Title Name Is duplicate In excel sheet'  
  --WHERE [Title/ Dubbed Title (Hindi)] IN   
  --(  
  -- SELECT [Title/ Dubbed Title (Hindi)] FROM DM_Title  
  -- WHERE ISNULL(Record_Status,'') <> 'C'  AND DM_Master_Import_Code = @DM_Master_Import_Code    
  -- GROUP BY [Title/ Dubbed Title (Hindi)]  
  -- HAVING COUNT([Title/ Dubbed Title (Hindi)]) > 1  
  --)  
  --AND ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code   --AND ISNULL(RTRIM(LTRIM([Error_Message])),'') = ''  


  
UPDATE DM_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') + '~' + [Original Title (Tanil/Telugu)] + ' - Title Name is Duplicate in Database'  
  WHERE [Original Title (Tanil/Telugu)] IN   
  (  
   SELECT Title_Name FROM [Title] T   Where DM_Title.[Title Type] = (SELECT Deal_Type_Name FROM Deal_Type DT where DT.Deal_Type_Code  = T.Deal_Type_Code)   
   GROUP BY Title_Name  
   HAVING COUNT(Title_Name) >= 1   
  )  
  AND ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code      --AND ISNULL(RTRIM(LTRIM([Error_Message])),'') = ''  
  

  --UPDATE DM_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') + '~' + [Title/ Dubbed Title (Hindi)] + ' - Original Title Name is Duplicate in Database'  
  --WHERE [Title/ Dubbed Title (Hindi)] IN   
  --(  
  -- SELECT Original_Title FROM [Title] T   Where DM_Title.Title_Type = (SELECT Deal_Type_Name FROM Deal_Type DT where DT.Deal_Type_Code  = T.Deal_Type_Code)   
  -- GROUP BY Original_Title  
  -- HAVING COUNT(Original_Title) >= 1   
  --)  
  --AND ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code      --AND ISNULL(RTRIM(LTRIM([Error_Message])),'') = '' 
  
  
  
  PRINT 'Validation PRoc. END'  
    
  END