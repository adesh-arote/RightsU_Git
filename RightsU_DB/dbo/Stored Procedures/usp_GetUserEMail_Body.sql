-----usp_GetUserEMail_Body 'ramb','ramb','ramb','s12345','N','http://192.168.0.114/RIGHTSU_Plus/','U-To','FPL','ramchandrabobhate@uto.in'  
  
CREATE PROCEDURE [dbo].[usp_GetUserEMail_Body]   

    @User_Name NVARCHAR(100) = '',         
	@First_Name NVARCHAR(100) = '',         
	@Last_Name NVARCHAR(100) = '',        
	@Pass_Word varchar(100) = '',     
	@IsLDAP_Required varchar(20) = '',           
	@Site_Address NVARCHAR(200) = '',       
	@System_Name NVARCHAR(100) = '',        
	@Status varchar(200) = '',   
	@cur_email_id  NVARCHAR(250) = ''     
	
AS                  
BEGIN              
	Declare @Loglevel int          
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'          
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[usp_GetUserEMail_Body]', 'Step 1', 0, 'Started Procedure', 0, ''           
	         
	--DECLARE          
	--   @User_Name NVARCHAR(100) = 'stefan'          
	-- , @First_Name NVARCHAR(100)  = 'stefan'          
	-- , @Last_Name NVARCHAR(100)  = 'Gaikwad'                   
	-- , @Pass_Word varchar(100)  = 's12345'                 
	-- , @IsLDAP_Required varchar(20)='N'                  
	-- , @Site_Address NVARCHAR(200)    ='http://192.168.0.114/RIGHTSU_Plus/'             
	-- , @System_Name NVARCHAR(100)    ='U-To'            
	-- , @Status varchar(200) ='NP'          
	-- , @cur_email_id  NVARCHAR(250) = 'stefan@uto.in'  
	
	DECLARE @Email_Config_Users_UDT Email_Config_Users_UDT  

	DECLARE @Email_Config_Code INT, @Notification_Subject VARCHAR(2000) = '', @Notification_Body VARCHAR(MAX) = '', @Event_Platform_Code INT = 0, @Event_Template_Type CHAR(1) = ''	
	DECLARE curNotificationPlatforms CURSOR FOR 																																	
			SELECT ec.Email_Config_Code, et.[Subject], et.Template, ect.Event_Platform_Code, ect.Event_Template_Type FROM Email_Config ec												
			INNER JOIN Email_Config_Template ect ON ec.Email_Config_Code = ect.Email_Config_Code																					
			INNER JOIN Event_Template et ON ect.Event_Template_Code = et.Event_Template_Code																						
			WHERE ec.[Key] = @Status																																				
																																													
	OPEN curNotificationPlatforms																																					
	FETCH NEXT FROM curNotificationPlatforms INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type							
	WHILE @@FETCH_STATUS = 0 																																						
	BEGIN	              

	DECLARE @MainRowBody VARCHAR(MAX) = '', @ReplaceRowBody VARCHAR(MAX) = '', @PerRowBody VARCHAR(MAX) = '', @StartIndex INT = 0, @EndIndex INT = 0	
	SET @MainRowBody = @Notification_Body
	
	DELETE FROM @Email_Config_Users_UDT

	SELECT @PerRowBody = ''																												
																																		
	SET @PerRowBody = @MainRowBody																							
																															
	SET @PerRowBody = REPLACE(@PerRowBody, '{User_Name}', CAST(ISNULL(@User_Name, ' ') AS NVARCHAR(1000)))					
	SET @PerRowBody = REPLACE(@PerRowBody, '{first_name}', CAST(ISNULL(@First_Name, ' ') AS NVARCHAR(1000)))				
	SET @PerRowBody = REPLACE(@PerRowBody, '{last_name}', CAST(ISNULL(@Last_Name, ' ') AS NVARCHAR(1000)))					
	SET @PerRowBody = REPLACE(@PerRowBody, '{password}', CAST(ISNULL(@Pass_Word, ' ') AS NVARCHAR(1000)))					
	SET @PerRowBody = REPLACE(@PerRowBody, '{isLDAPAuthReqd}', CAST(ISNULL(@IsLDAP_Required, ' ') AS NVARCHAR(1000)))		
	SET @PerRowBody = REPLACE(@PerRowBody, '{SiteAddress}', CAST(ISNULL(@Site_Address, ' ') AS NVARCHAR(1000)))				
	SET @PerRowBody = REPLACE(@PerRowBody, '{system_admin}', CAST(ISNULL(@System_Name, ' ') AS NVARCHAR(1000)))		
	SET @PerRowBody = REPLACE(@PerRowBody, '{RoPSiteAddress}', CAST(ISNULL((SELECT ISNULL(Parameter_Value,'') FROM System_Parameter_New WHERE Parameter_Name = 'RoPSiteAddress'), ' ') AS NVARCHAR(1000)))
	
																															
	IF(@Status = 'NUP') 																										
		SET @PerRowBody = REPLACE(@PerRowBody, '{regenerated}', 'generated')												
	ELSE IF(@Status = 'FPW')   																								
		SET @PerRowBody = REPLACE(@PerRowBody, '{regenerated}', 'regenerated')	
	       
	DECLARE @MailSubjectCr NVARCHAR(250) = '' 
	      
	SET @MailSubjectCr = @Notification_Subject	
	
	INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_User_Mail_Id, [Subject])          
	SELECT @Email_Config_Code, @PerRowBody, ISNULL(@cur_email_id ,''),  @MailSubjectCr  
	 
	EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT          
	 ----Send E-Mail END               

	FETCH NEXT FROM curNotificationPlatforms INTO @Email_Config_Code, @Notification_Subject, @Notification_Body, @Event_Platform_Code, @Event_Template_Type 
	END																																						
	CLOSE curNotificationPlatforms																															
	DEALLOCATE curNotificationPlatforms																														
	           																																				
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[usp_GetUserEMail_Body]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''              
END