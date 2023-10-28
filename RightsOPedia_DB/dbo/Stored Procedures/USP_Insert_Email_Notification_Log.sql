CREATE PROCEDURE [dbo].[USP_Insert_Email_Notification_Log]
(
	@Email_Config_Users_UDT Email_Config_Users_UDT  READONLY,
	@Module_Code INT = 0,
	@Record_Code INT = 0
)
As
-- =============================================
-- Author:		Akshay Rane
-- Create Date:   22-October-2021
-- Description:	
-- =============================================
BEGIN
	Declare @Loglavel int
--if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Email_Notification_Log]', 'Step 1', 0, 'Started Procedure', 0, ''
	--DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT ,
	--@Module_Code INT = 0,
	--@Record_Code INT = 0

	--INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
	--SELECT 1,'Table 1', '', '','','utosupport_uto@uto.in;viraj_Bhagat@uto.in','204,208','Jatin_Patel@uto.in;Deepak_Kurian@uto.in','Subject'
	--UNION
	--SELECT 1,'Table 2', '1319,1324', 'sds_daf@uto.in;Test_K@uto.in','136,1319','Ragnar_Tygerian@uto.in;sds_daf@uto.in','','Uto_Cs@uto.in;sds_daf@uto.in','Subject'

	-- SELECT 1,	'Table 2','137,258'		,'ralph_Fernandes@uto.in;test_test@uto.in'	,'143,254' ,'utosupport_uto@uto.in;viraj_Bhagat@uto.in'	,'204,208'	,'Jatin_Patel@uto.in;Deepak_Kurian@uto.in','Channel Unutilized Run'
	--UNION ALL SELECT 1,	'Table 3','1319,1324'	,'sds_daf@uto.in;Test_K@uto.in'				,'136,1319','Ragnar_Tygerian@uto.in;sds_daf@uto.in'		,'1319'		,'sds_daf@uto.in','Channel Unutilized Run'
	--UNION ALL SELECT 1,	'Table 4','1319'		,'sds_daf@uto.in'							,'136,1319','Ragnar_Tygerian@uto.in;sds_daf@uto.in'		,'1319'		,'sds_daf@uto.in','Channel Unutilized Run'


	IF OBJECT_ID('tempdb..#Email_Config_Users_UDT') IS NOT NULL  
		DROP TABLE #Email_Config_Users_UDT 
	IF OBJECT_ID('tempdb..#Tmp_Email_Notification_Log') IS NOT NULL  
		DROP TABLE #Tmp_Email_Notification_Log 

	--CREATE TABLE #Tmp_Email_Notification_Log (
	--	[Email_Notification_Log_Code] INT             IDENTITY (1, 1) NOT NULL,
	--	[Email_Config_Code]           INT             NULL,
	--	[Created_Time]                DATETIME        NULL,
	--	[Is_Read]                     CHAR (1)        NULL,
	--	[Email_Body]                  NVARCHAR (MAX)  NULL,
	--	[User_Code]                   INT             NULL,
	--	[Subject]                     NVARCHAR (1000) NULL,
	--	[Email_Id]                    NVARCHAR (MAX)  NULL,
	--	[User_Type] CHAR(2) NULL, 
	--);

	SELECT DISTINCT  * INTO #Email_Config_Users_UDT FROM @Email_Config_Users_UDT

	--BEGIN
	--		INSERT INTO #Tmp_Email_Notification_Log(Email_Config_Code, Created_Time, Is_Read, Email_Body, [Subject], Email_Id, User_Type)
	--		SELECT  C.Email_Config_Code, GETDATE(), 'N', C.Email_Body, C.[Subject], D.number, 'TO'
	--		FROM #Email_Config_Users_UDT C
	--			CROSS APPLY dbo.fn_Split_withdelemiter(C.To_User_Mail_Id,';')  AS D 
	--		WHERE ISNULL(C.To_Users_Code,'') = '' AND ISNULL(C.To_User_Mail_Id,'') <> ''
	--		UNION ALL
	--		SELECT  C.Email_Config_Code, GETDATE(), 'N', C.Email_Body, C.[Subject], D.number, 'CC'
	--		FROM #Email_Config_Users_UDT C
	--			CROSS APPLY dbo.fn_Split_withdelemiter(C.CC_User_Mail_Id,';')  AS D 
	--		WHERE ISNULL(C.CC_Users_Code,'') = '' AND ISNULL(C.CC_User_Mail_Id,'') <> ''
	--		UNION ALL
	--		SELECT  C.Email_Config_Code, GETDATE(), 'N', C.Email_Body, C.[Subject], D.number, 'BC'
	--		FROM #Email_Config_Users_UDT C
	--			CROSS APPLY dbo.fn_Split_withdelemiter(C.BCC_User_Mail_Id,';')  AS D 
	--		WHERE ISNULL(C.BCC_Users_Code,'') = '' AND ISNULL(C.BCC_User_Mail_Id,'') <> ''
	--END
	

	--BEGIN

	--	DELETE FROM #Email_Config_Users_UDT WHERE To_Users_Code = '' AND BCC_Users_Code = '' AND CC_Users_Code = ''

	--	UPDATE #Email_Config_Users_UDT SET To_User_Mail_Id = '' WHERE To_Users_Code = ''
	--	UPDATE #Email_Config_Users_UDT SET CC_User_Mail_Id = '' WHERE CC_Users_Code = ''
	--	UPDATE #Email_Config_Users_UDT SET BCC_User_Mail_Id = '' WHERE BCC_Users_Code = ''

		
	--	INSERT INTO #Tmp_Email_Notification_Log(Email_Config_Code,Created_Time,Is_Read,Email_Body,User_Code,[Subject],Email_Id, User_Type)
	--	SELECT tbl1.Email_Config_Code, GETDATE(), 'N', Tbl1.Email_Body, Tbl2.number, Tbl1.Subject ,Tbl1.number, 'TO' FROM 
	--	(
	--		SELECT  ROW_NUMBER() OVER (ORDER BY A.Email_Config_Users_UDT_Code) AS RowNo, B.number
	--		, A.Email_Config_Code, A.Email_Body, A.[Subject]
	--		FROM #Email_Config_Users_UDT A
	--		CROSS APPLY dbo.fn_Split_withdelemiter(A.To_User_Mail_Id,';') AS B  
	--		WHERE ISNULL(A.To_User_Mail_Id,'') <> ''
	--	) AS Tbl1
	--	INNER JOIN 
	--	(
	--		SELECT  ROW_NUMBER() OVER (ORDER BY  C.Email_Config_Users_UDT_Code) AS RowNo, D.number 
	--		, C.Email_Config_Code, C.Email_Body, C.[Subject]
	--		FROM #Email_Config_Users_UDT C
	--		CROSS APPLY dbo.fn_Split_withdelemiter(C.To_Users_Code,',')  AS D 
	--		WHERE ISNULL(C.To_User_Mail_Id,'') <> ''
	--	) as Tbl2 ON Tbl1.RowNo = Tbl2.RowNo

	--	UNION ALL 

	--	SELECT tbl1.Email_Config_Code, GETDATE(), 'N', Tbl1.Email_Body, Tbl2.number, Tbl1.Subject ,Tbl1.number, 'CC' FROM 
	--	(
	--		SELECT  ROW_NUMBER() OVER (ORDER BY A.Email_Config_Users_UDT_Code) AS RowNo, B.number
	--		, A.Email_Config_Code, A.Email_Body, A.[Subject]
	--		FROM #Email_Config_Users_UDT A
	--		CROSS APPLY dbo.fn_Split_withdelemiter(A.CC_User_Mail_Id,';') AS B 
	--		WHERE ISNULL(A.CC_User_Mail_Id,'') <> ''
	--	) AS Tbl1
	--	INNER JOIN 
	--	(
	--		SELECT  ROW_NUMBER() OVER (ORDER BY  C.Email_Config_Users_UDT_Code) AS RowNo, D.number 
	--		, C.Email_Config_Code, C.Email_Body, C.[Subject]
	--		FROM #Email_Config_Users_UDT C
	--		CROSS APPLY dbo.fn_Split_withdelemiter(C.CC_Users_Code,',')  AS D 
	--		WHERE ISNULL(C.CC_User_Mail_Id,'') <> ''
	--	) as Tbl2 ON Tbl1.RowNo = Tbl2.RowNo

	--	UNION ALL 

	--	SELECT tbl1.Email_Config_Code, GETDATE(), 'N', Tbl1.Email_Body, Tbl2.number, Tbl1.Subject ,Tbl1.number, 'BC' FROM 
	--	(
	--		SELECT  ROW_NUMBER() OVER (ORDER BY A.Email_Config_Users_UDT_Code) AS RowNo, B.number
	--		, A.Email_Config_Code, A.Email_Body, A.[Subject]
	--		FROM #Email_Config_Users_UDT A
	--		CROSS APPLY dbo.fn_Split_withdelemiter(A.BCC_User_Mail_Id,';') AS B  
	--		WHERE ISNULL(A.BCC_User_Mail_Id,'') <> ''
	--	) AS Tbl1
	--	INNER JOIN 
	--	(
	--		SELECT  ROW_NUMBER() OVER (ORDER BY  C.Email_Config_Users_UDT_Code) AS RowNo, D.number 
	--		, C.Email_Config_Code, C.Email_Body, C.[Subject]
	--		FROM #Email_Config_Users_UDT C
	--		CROSS APPLY dbo.fn_Split_withdelemiter(C.BCC_Users_Code,',')  AS D 
	--		WHERE ISNULL(C.BCC_User_Mail_Id,'') <> ''
	--	) as Tbl2 ON Tbl1.RowNo = Tbl2.RowNo
	--END

	INSERT INTO Notifications (NotificationType, EventCategory, TransCode, TransType, UserCode, Email, CC, BCC, [Subject], HtmlBody, CreatedOn, ModifiedOn, NoOfRetry, API_Status, IsReminderMail, IsSend, IsRead, IsAutoEscalated)
	SELECT distinct 'Email_NTF', 'Feedback Mail', @Module_Code, @Record_Code, 0, To_User_Mail_Id, CC_User_Mail_Id, BCC_User_Mail_Id, [Subject], Email_Body, GETDATE(), GETDATE(),0 ,'P' , 0, 0, 0, 0 
	FROM  #Email_Config_Users_UDT A
	--INNER JOIN EmailConfig EC ON EC.Email_Config_Code = A.Email_Config_Code
 
--if(@Loglavel < 2)Exec [USPLogSQLSteps] '[USP_Insert_Email_Notification_Log]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END