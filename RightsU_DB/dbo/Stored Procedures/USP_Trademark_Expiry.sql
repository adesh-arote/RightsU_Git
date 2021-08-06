CREATE PROCEDURE [dbo].[USP_Trademark_Expiry]
-- --=============================================
-- --Author:		Ayush Dubey
-- --Create date: 05 AUgust 2021
-- --Description:	Email Notification
-- --=============================================	
AS
BEGIN
	SET NOCOUNT ON
	--Notification of all trademarks exiring in the course of' + {@Days}
	DECLARE @MailSubject VARCHAR(MAX)= '' , @Days INT = '' ,@Trademark_No VARCHAR(MAX) = '' , @TradeMark_Name VARCHAR(MAX) = '',@Applicant_Name VARCHAR(MAX) = '',@Expiring_On VARCHAR(MAX)
	,@Created_By VARCHAR(MAX) = '',@Creation_Date VARCHAR(MAX),@Class VARCHAR(MAX) = '',@Email_Table NVARCHAR(MAX), @Body NVARCHAR(MAX)

	DECLARE @Business_Unit_Code INT,
	@To_Users_Code NVARCHAR(MAX),
	@To_User_Mail_Id  NVARCHAR(MAX),
	@CC_Users_Code  NVARCHAR(MAX),
	@CC_User_Mail_Id  NVARCHAR(MAX),
	@BCC_Users_Code  NVARCHAR(MAX),
	@BCC_User_Mail_Id  NVARCHAR(MAX)

	DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT 

	DECLARE @Tbl2 TABLE (
		Id INT,
		BuCode INT,
		To_Users_Code NVARCHAR(MAX),
		To_User_Mail_Id  NVARCHAR(MAX),
		CC_Users_Code  NVARCHAR(MAX),
		CC_User_Mail_Id  NVARCHAR(MAX),
		BCC_Users_Code  NVARCHAR(MAX),
		BCC_User_Mail_Id  NVARCHAR(MAX),
		Channel_Codes NVARCHAR(MAX)
	)
	DECLARE @DatabaseEmail_Profile varchar(200)	
	SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'

	DECLARE @Email_Config_Code INT
	SELECT @Email_Config_Code = Email_Config_Code FROM Email_Config where [Key] = 'TE'

	INSERT INTO @Tbl2( Id,BuCode,To_Users_Code ,To_User_Mail_Id  ,CC_Users_Code  ,CC_User_Mail_Id  ,BCC_Users_Code  ,BCC_User_Mail_Id  ,Channel_Codes)
	EXEC USP_Get_EmailConfig_Users 'TE', 'N'

	DECLARE @Days_Freq INT

	SELECT @Days_Freq = ECDA.Mail_Alert_Days FROM email_config EC
	INNER JOIN Email_Config_Detail ECD ON ECD.Email_Config_Code = EC.Email_Config_Code
	INNER JOIN Email_Config_Detail_Alert ECDA ON ECDA.Email_Config_Detail_Code = ECD.Email_Config_Detail_Code
	WHERE EC.[Key] = 'TE'

	SET @MailSubject = 'Notification of all trademarks expiring in the course of the next ' +CAST(@Days_Freq AS varchar(100))+ ' days'
	SELECT 
		@Trademark_No = Trademark_No,
		@TradeMark_Name = IR.Trademark,
		@Applicant_Name = Applicant,
		@Expiring_On = Renewed_Until,
		@Created_By = U.Login_Name,
		@Creation_Date = Creation_Date,
		@Class = Class_Comments
		FROM IPR_REP IR
	INNER JOIN DM_IPR DI ON IR.Applicant_Code = DI.ID
	INNER JOIN Users U ON IR.Created_By = U.Users_Code

	DECLARE curOuter CURSOR FOR 
					SELECT BuCode, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id  FROM @Tbl2
	
		OPEN curOuter 
		FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id--, @Channel_Codes
		WHILE @@FETCH_STATUS = 0
		BEGIN	

			SELECT @Body = Template_Desc FROM Email_Template WHERE Template_For = 'Trademark'
			
			SET @Body = REPLACE(@Body,'{Trademark No}',@Trademark_No)  
			SET @Body = REPLACE(@Body,'{Trademark Name}',@TradeMark_Name)  
			SET @Body = REPLACE(@Body,'{Applicant Name}',@Applicant_Name)  
			SET @Body = replace(@Body,'{Expiry On}',@Expiring_On)  
			SET @Body = replace(@Body,'{Created By}',@Created_By)  
			SET @Body = replace(@Body,'{Creation Date}',@Creation_Date)
			SET @Body = replace(@Body,'{Class}',@Class)
		IF(@Body != '')
		BEGIN
			----select @To_User_Mail_Id, @CC_User_Mail_Id, @BCC_User_Mail_Id, @Body, @MailSubject
			EXEC msdb.dbo.sp_send_dbmail 
						@profile_name = @DatabaseEmail_Profile,
						@recipients =  @To_User_Mail_Id,
						@copy_recipients = @CC_User_Mail_Id,
						@blind_copy_recipients = @BCC_User_Mail_Id,
						@subject = @MailSubject,
						@body = @Body,
						@body_format = 'HTML';

			 INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_Users_Code, To_User_Mail_Id, CC_Users_Code, CC_User_Mail_Id, BCC_Users_Code, BCC_User_Mail_Id, [Subject])
			 SELECT @Email_Config_Code,@Body, ISNULL(@To_Users_Code,''), ISNULL(@To_User_Mail_Id ,''), ISNULL(@CC_Users_Code,''), ISNULL(@CC_User_Mail_Id,''), ISNULL(@BCC_Users_Code,''), ISNULL(@BCC_User_Mail_Id,''),  ' Trademark Expiry'


		END

		FETCH NEXT FROM curOuter INTO @Business_Unit_Code, @To_Users_Code, @To_User_Mail_Id, @CC_Users_Code, @CC_User_Mail_Id, @BCC_Users_Code, @BCC_User_Mail_Id--, @Channel_Codes
		END --End of Fetch outer
		CLOSE curOuter
		DEALLOCATE curOuter	

		EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT
END






