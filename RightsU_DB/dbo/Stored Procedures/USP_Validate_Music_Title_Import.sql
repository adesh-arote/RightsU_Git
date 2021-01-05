CREATE PROCEDURE [dbo].[USP_Validate_Music_Title_Import]
@DM_Master_Import_Code INt
AS
BEGIN
	SET NOCOUNT ON;		
	DECLARE @Error_Message		varchar(5000)
	PRINT 'validation Proc. Start'
	--Validate Music Title Name blank
	IF EXISTS (SELECT [Excel_Line_No] FROM  DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(RTRIM(LTRIM([Excel_Line_No])),'') = '') 
	BEGIN
		UPDATE DM_Music_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '') + '~ Sr. No. is Mandatory in Excel' 
		WHERE ISNULL(Record_Status,'') <> 'C' AND ISNULL(RTRIM(LTRIM([Excel_Line_No])),'') = '' AND DM_Master_Import_Code = @DM_Master_Import_Code
	END
	IF EXISTS (SELECT [Music_Title_Name] FROM  DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(RTRIM(LTRIM([Music_Title_Name])),'') = '')
	BEGIN
		UPDATE DM_Music_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '') + '~ Music Track Name is Mandatory in Excel' 
		WHERE ISNULL(Record_Status,'') <> 'C' AND ISNULL(RTRIM(LTRIM([Music_Title_Name])),'') = '' AND DM_Master_Import_Code = @DM_Master_Import_Code
	END
	--Music Label can't be Multiple
	UPDATE DM_Music_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') + '~ Music Label is Mandatory in Excel'
	WHERE ISNULL(Record_Status,'') <> 'C' AND ISNULL(RTRIM(LTRIM([Music_Label])),'') = '' AND DM_Master_Import_Code = @DM_Master_Import_Code

	IF EXISTS (SELECT [Music_Version] FROM DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(RTRIM(LTRIM([Music_Version])),'')
	 NOT IN(SELECT Music_Type_Name FROM Music_Type WHERE [Type]='MV') AND ISNULL(RTRIM(LTRIM([Music_Version])),'')<>'')
	BEGIN
		UPDATE DM_Music_Title SET  Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') +  '~ Music Version Does Not Exist' 
		WHERE ISNULL(Record_Status,'') <> 'C' AND ISNULL(RTRIM(LTRIM([Music_Version])),'') <>''  AND DM_Master_Import_Code = @DM_Master_Import_Code AND (ISNULL(RTRIM(LTRIM([Music_Version])),'') 
	 NOT IN(SELECT Music_Type_Name FROM Music_Type WHERE [Type]='MV'))
		 --AND RTRIM(LTRIM([Music_Version]))!=''
	END
	 
	IF EXISTS (SELECT [Music_Album_Type] FROM DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(RTRIM(LTRIM([Music_Album_Type])),'')
	 NOT IN(SELECT Music_Album_Type FROM DM_Music_Title WHERE [Music_Album_Type]='Movie' OR [Music_Album_Type]='Album') AND ISNULL(RTRIM(LTRIM([Music_Album_Type])),'')<>'')
	BEGIN
		UPDATE DM_Music_Title SET  Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') +  '~ Music/Album Type Must be "Movie" OR "Album"' 
		WHERE ISNULL(Record_Status,'') <> 'C' AND ISNULL(RTRIM(LTRIM([Music_Album_Type])),'') <>'' AND DM_Master_Import_Code = @DM_Master_Import_Code AND (ISNULL(RTRIM(LTRIM([Music_Album_Type])),'')
	 NOT IN(SELECT Album_Type FROM Music_Album WHERE [Album_Type]='M'  OR [Album_Type]='A'))
		 --AND RTRIM(LTRIM([Music_Version]))!=''
	END 
	
	IF EXISTS (SELECT  [Effective_Start_Date] FROM  DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISDATE(RTRIM(LTRIM([Effective_Start_Date])))=0
	 AND ISNULL(RTRIM(LTRIM([Effective_Start_Date])),'') <> '')
	BEGIN
		
			UPDATE DM_Music_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '') + '~ Effective Start Date is not in Proper Format' 
			WHERE ISNULL(Record_Status,'') <> 'C' AND ISNULL(RTRIM(LTRIM([Effective_Start_Date])),'') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code 
			AND ISDATE(RTRIM(LTRIM([Effective_Start_Date])))=0
		  
	END
	IF EXISTS (SELECT [Effective_Start_Date] FROM  DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code)
	BEGIN
		BEGIN TRY
		print 'try'
				DECLARE @dt datetime, @EffectiveStartDate VARCHAR(20) 
				SELECT @EffectiveStartDate=[Effective_Start_Date] FROM  DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISDATE(RTRIM(LTRIM([Effective_Start_Date])))= 1 
				AND ISNULL(RTRIM(LTRIM([Effective_Start_Date])),'') <> ''
				SET @dt=Convert(datetime,ISNULL(LTRIM(RTRIM(@EffectiveStartDate)),''),103)
				print @EffectiveStartDate
		END TRY
		BEGIN CATCH  
		print 'Catch'
				UPDATE DM_Music_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '') + '~ Effective Start Date is not in Proper Format' 
				WHERE ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(RTRIM(LTRIM([Effective_Start_Date])),'') <> '' 
		END CATCH
	END

	IF EXISTS (SELECT [Movie_Album] FROM  DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(RTRIM(LTRIM([Movie_Album])),'') = '')
	BEGIN
		UPDATE DM_Music_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '')  +  '~ Movie or Album Name is Mandatory in Excel' 
		WHERE ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code  AND ISNULL(RTRIM(LTRIM([Movie_Album])),'') = ''
	END

	--Validate Music_Album_Type--
	IF EXISTS (SELECT [Music_Album_Type] FROM  DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(RTRIM(LTRIM([Music_Album_Type])),'') = '')
	BEGIN
		UPDATE DM_Music_Title SET  Record_Status = 'E', [Error_Message] =  ISNULL([Error_Message], '')  +  '~ Movie/Album Type is Mandatory in Excel' 
		WHERE ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code  AND ISNULL(RTRIM(LTRIM([Music_Album_Type])),'') = ''
	END

	--Validate Title Lang. blank
	IF EXISTS (SELECT  [Title_Language] FROM  DM_Music_Title WHERE DM_Master_Import_Code = @DM_Master_Import_Code AND ISNULL(RTRIM(LTRIM([Title_Language])),'') = '')
	BEGIN
		UPDATE DM_Music_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') +  '~ Music Track Language is Mandatory in Excel'
		WHERE ISNULL(Record_Status,'') <> 'C'  AND ISNULL(RTRIM(LTRIM([Title_Language])),'') = '' AND DM_Master_Import_Code = @DM_Master_Import_Code
	END		
	----validate Year of release
	UPDATE DM_Music_Title SET Record_Status = 'E' ,[Error_Message] = ISNULL([Error_Message], '') +  '~ Year of Release should be Numeric Value in Excel'
	WHERE ISNUMERIC([Year_of_Release] + '.0e0') != 1  AND ISNULL([Year_of_Release],'') <> '' AND Record_Status = 'N' AND DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE DM_Music_Title SET Record_Status = 'E' ,[Error_Message] = ISNULL([Error_Message], '') +  '~ Year of Release should be greater than 1900 in Excel'
	WHERE ISNUMERIC([Year_of_Release] + '.0e0') = 1  AND  LEN([Year_of_Release]) != '4'  AND ISNULL([Year_of_Release],'') <> '' AND ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE DM_Music_Title SET [Year_of_Release] = null
		WHERE [Year_of_Release]='' AND DM_Master_Import_Code = @DM_Master_Import_Code
	--validate duration
	UPDATE DM_Music_Title SET Record_Status = 'E' ,[Error_Message] = ISNULL([Error_Message], '') +  '~ Duration should be Decimal or Integer in Excel'
	WHERE ISNUMERIC([Duration] + 'e0') != 1  AND ISNULL([Duration],'') <> '' AND ISNULL(Record_Status,'') <> 'C'  AND DM_Master_Import_Code = @DM_Master_Import_Code

		UPDATE DM_Music_Title SET [Duration]=null
		WHERE [Duration]=''
		
	--Music Title Type IS NOT available IN database
	UPDATE DM_Music_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') + '~' + [Title_Type] + '- Music Type is not Available in Database.'
	WHERE ISNULL([Title_Type], '') <> '' AND DM_Master_Import_Code = @DM_Master_Import_Code
	AND [Title_Type] NOT IN
	(
		SELECT Music_Type_Name FROM Music_Type
	) AND Record_Status <> 'C'

	--Music Title Name Duplicate IN Excel
	UPDATE DM_Music_Title SET Record_Status = 'E', [Error_Message] = ISNULL([Error_Message], '') + '~' + [Music_Title_Name] + ' - Music Track Name is duplicate in excel sheet.'
	WHERE ([Music_Title_Name] IN 
	(
		SELECT [Music_Title_Name] FROM DM_Music_Title
		WHERE ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code
		GROUP BY [Music_Title_Name], [Movie_Album]
		HAVING COUNT([Music_Title_Name]) > 1
	) AND
	[Movie_Album] IN 
	(
		SELECT [Movie_Album] FROM DM_Music_Title
		WHERE ISNULL(Record_Status,'') <> 'C' AND DM_Master_Import_Code = @DM_Master_Import_Code
		GROUP BY [Music_Title_Name], [Movie_Album]
		HAVING COUNT([Movie_Album]) > 1
	) )
	AND ISNULL(Record_Status,'') <> 'C'  AND DM_Master_Import_Code = @DM_Master_Import_Code --AND ISNULL(RTRIM(LTRIM([Error_Message])),'') = ''

	UPDATE DMT SET DMT.Record_Status = 'E', DMT.[Error_Message] = ISNULL(DMT.[Error_Message], '') + '~' + DMT.[Music_Title_Name] + ' - Music Track Name is Duplicate in system.'
	FROM Music_Title MT
	INNER JOIN DM_Music_Title DMT ON DMT.Music_Title_Name = MT.Music_Title_Name AND DMT.Movie_Album = MT.Movie_Album
	WHERE ISNULL (DMT.Record_Status,'') <> 'C' AND DMT.DM_Master_Import_Code = @DM_Master_Import_Code

	PRINT 'Validation PRoc. END'
		
END




