CREATE PROCEDURE [dbo].[USP_Content_Music_PI]
(
	@Content_Music_Link_UDT Content_Music_Link_UDT READONLY,
	@UserCode INT
)
AS
------ =============================================
---- Author:  Sayali Surve
---- Create date: 07 October 2017
---- Description: This usp call from Title_Content_ImportExportController  and check Error and Insert into Content_Music_Link_UDT
---- =============================================
BEGIN
	SET NOCOUNT ON;

	DECLARE	@DM_Master_Import_Code INT ,@Sql NVARCHAR(1000),@DB_Name VARCHAR(1000); 
	Select Top 1 @DM_Master_Import_Code = DM_Master_Import_Code From @Content_Music_Link_UDT    

	INSERT INTO DM_Content_Music([DM_Master_Import_Code],[From],[To],[Duration],[From_Frame],[To_Frame],[Duration_Frame],[Is_Ignore],[Record_Status],[Music_Track],
			[Title_Content_Code],[Version_Name],[Excel_Line_No],[Error_Tags])
		SELECT  [DM_Master_Import_Code], [From], [To], [Duration],[From_Frame],  [To_Frame], [Duration_Frame], 'N','N', [Music_Track], [Title_Content_Code],
		  [Version_Name], [Excel_Line_No], '' As Error_Tags
	    FROM @Content_Music_Link_UDT  

	/* Update Version Code */
	UPDATE T SET T.Version_Code = V.Version_Code, T.Version_Name = V.Version_Name FROM DM_Content_Music T
	INNER JOIN [Version] V ON UPPER(RTRIM(LTRIM(T.Version_Name)))
	COLLATE SQL_Latin1_General_CP1_CI_AS = UPPER(RTRIM(LTRIM(V.Version_Name))) COLLATE SQL_Latin1_General_CP1_CI_AS 
		AND LTRIM(RTRIM(T.Version_Name)) != '' 

	/* Update Content Name */
	UPDATE TMP SET TMP.Content_Name = CASE WHEN ISNULL(TC.Episode_Title, '') = '' THEN T.Title_Name ELSE TC.Episode_Title END,
	TMP.Episode_No = TC.Episode_No FROM DM_Content_Music TMP
	INNER JOIN Title_Content TC ON CAST(TC.Title_Content_Code AS VARCHAR) COLLATE SQL_Latin1_General_CP1_CI_AS = 
	CAST(RTRIM(LTRIM(TMP.Title_Content_Code)) AS VARCHAR) COLLATE SQL_Latin1_General_CP1_CI_AS
	INNER JOIN Title T ON T.Title_Code = TC.Title_Code
	--END

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL([Error_Message], '') + 'Sr. No cannot be blank~' 
	FROM DM_Content_Music T
	WHERE T.Excel_Line_No = '' AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL([Error_Message], '') + 'Music Track cannot be blank~' 
	FROM DM_Content_Music T
	WHERE T.Music_Track = '' AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL(T.[Error_Message], '') + '~' + T.[Music_Track] + ' - Music Track Name is Deactivated in system.'
	FROM Music_Title MT
	INNER JOIN DM_Content_Music T ON T.Music_Track = MT.Music_Title_Name
	WHERE ISNULL (T.Record_Status,'') <> 'C' AND MT.Is_Active = 'N' AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL([Error_Message], '') + 'Either TC IN, TC OUT or Duration cannot be zero~' 
	FROM DM_Content_Music T
	WHERE ((T.[From] = '' AND T.[To] = '' AND T.[Duration] = '') OR (T.[From] != '' AND T.[To] = '') OR (T.[From] = '' AND T.[To] != '')) AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE T SET T.[Record_Status] = 'E', T.[Error_Message] = ISNULL([Error_Message], '') + 'Invalid Title Content Code~' 
	FROM DM_Content_Music T
	WHERE T.Title_Content_Code Not In(select Title_Content_Code From Title_Content) AND T.DM_Master_Import_Code = @DM_Master_Import_Code

	UPDATE DM_Content_Music SET [Record_Status] = 'E' , [Error_Message] = ISNULL([Error_Message], '') + 'Invalid Version Name'
	WHERE ISNULL([Version_Code],'') = '' AND DM_Master_Import_Code = @DM_Master_Import_Code

	--IF NOT EXISTS(SELECT TOP 1 Record_Status FROM DM_Content_Music WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
	--BEGIN  
	--print '1'
	--EXEC USP_Validate_Content_Music_Import @DM_Master_Import_Code     
	----IF NOT EXISTS(SELECT TOP 1 Record_Status FROM DM_Content_Music WHERE RTRIM(LTRIM(ISNULL(Record_Status,''))) = 'OR' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
	----print '2'
	----	BEGIN  
	--		EXEC USP_Content_Music_PIV @DM_Master_Import_Code 
	    
	--		IF((Select [Status] From DM_Master_Import Where DM_Master_Import_Code = @DM_Master_Import_Code) = 'P')
	--		BEGIN  
	--			EXEC USP_Content_Music_PIII @DM_Master_Import_Code
	--		END
	--	--END
	--END
	--ELSE
	--BEGIN
		IF EXISTS(SELECT Record_Status FROM DM_Content_Music WHERE ISNULL(RTRIM(LTRIM(Record_Status)),'') = 'E' AND DM_Master_Import_Code = @DM_Master_Import_Code)  
		BEGIN
			SELECT [Excel_Line_No], [Content_Name], [Episode_No], [Music_Track], [From], [To], [From_Frame], [To_Frame], [Duration], [Duration_Frame], Version_Name, [Error_Message]
			FROM DM_Content_Music Where [Record_Status] = 'E'
			UPDATE DM_Master_Import Set [Status] = 'E' where DM_Master_Import_Code  = @DM_Master_Import_Code

			DECLARE @File_Name VARCHAR(MAX)
			SELECT @File_Name = File_Name FROM DM_Master_Import WHere DM_Master_Import_Code = @DM_Master_Import_Code AND [Status] = 'E'
			INSERT INTO UTO_ExceptionLog(Exception_Log_Date,Controller_Name,Action_Name,ProcedureName,Exception,Inner_Exception,StackTrace,Code_Break)
			SELECT GETDATE(),NULL,NULL,'USP_Content_Music_PI','Error in file: '+ @File_Name,'NA','NA','DB'

			SELECT @sql = 'Error in file: '+ @File_Name
			SELECT @DB_Name = DB_Name()
			EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin', @DB_Name,'RU','USP_Content_Music_PI','AN','VN',@sql,'DB','IP','FR','TI'
		END
	--END
END