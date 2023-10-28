CREATE PROCEDURE [dbo].[usp_GetUserEMail_Body]         
   @User_Name NVARCHAR(100)
   ,@First_Name NVARCHAR(100)
   ,@Last_Name NVARCHAR(100)          
 , @Pass_Word varchar(100)        
 , @IsLDAP_Required varchar(20)        
 , @Site_Address NVARCHAR(200)       
 , @System_Name NVARCHAR(100)      
 , @Status varchar(200)      
 ,@cur_email_id  NVARCHAR(250)
AS        
BEGIN        
 -- SET NOCOUNT ON added to prevent extra result sets from        
 -- interfering with SELECT statements.        
 SET NOCOUNT ON;        
          
BEGIN    
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from SystemParameterNew where Parameter_Name='loglevel'
	--if(@Loglevel < 2)Exec [USPLogSQLSteps] '[usp_GetUserEMail_Body]', 'Step 1', 0, 'Started Procedure', 0, '' 

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
		DECLARE @Email_Config_Code INT
		DECLARE @body  NVARCHAR(MAX)  SET @body  = ''       
		DECLARE @body1 NVARCHAR(1000) SET @body1 = ''        
		DECLARE @body2 NVARCHAR(1000) SET @body2 = ''       
		DEclare @body3 NVARCHAR(1000) SET @body2 = ''           
    
		SELECT @Email_Config_Code= Email_Config_Code FROM EmailConfig (NOLOCK) WHERE [Key]='UCFP'

		--//--------------- SELECT AND SET A PARTICULAR TEMPLATE ---------------//--        
          
					/* ========== PASSWORD CHANGED =============== */      
					print @Status
		IF(@Status = 'PC' )      
		BEGIN      
          
	   SELECT @body1 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For='EB1'       
         
	   IF (@IsLDAP_Required = 'N')      
		BEGIN      
		   SELECT @body2 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For = 'EB2'       
		END       
	   ELSE      
		BEGIN      
		   SELECT @body2 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For = 'EB3'      
             
		END      
	   END      
         
	   SELECT @body3 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For='EB4'       
         
		 END      
           
				   /* ========== END PASSWORD CHANGED =============== */      
           
				   /* ==========  NEW USER CREATED  =============== */      
		 IF(@Status = 'NUC')      
		 BEGIN        
	   SELECT @body1 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For='UB1'       
      
	   IF (@IsLDAP_Required = 'N')      
		BEGIN      
		   SELECT @body2 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For = 'UB2'       
		END       
	   ELSE      
		BEGIN      
		   SELECT @body2 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For = 'UB3'      
             
		END      
          
	   SELECT @body3 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For='UB4'       
         
		 END      
				 /* ==========  NEW USER CREATED  =============== */   
               
				 /* ========== FORGOT PASSWORD  ================= */    
	   IF(@Status = 'FP')      
	   BEGIN        
	   SELECT @body1 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For='FB1'       
      
	   IF (@IsLDAP_Required = 'N')      
		BEGIN      
		   SELECT @body2 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For = 'FB2'       
		END       
	   ELSE      
		BEGIN      
		   SELECT @body2 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For = 'FB3'      
		END      
          
	   SELECT @body3 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For='FB4'       
         
	  END   
  
	  IF(@Status = 'NP')      
	   BEGIN        
	   SELECT @body1 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For='FB1'       
      
	   IF (@IsLDAP_Required = 'N')      
		BEGIN      
		   SELECT @body2 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For = 'FB2'       
		END       
	   ELSE      
		BEGIN      
		   SELECT @body2 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For = 'FB3'      
		END      
          
	   SELECT @body3 = Template_Desc FROM EmailTemplate (NOLOCK) WHERE Template_For='FB4'       
         
	  END   
               
				 /* ========== FORGOT PASSWORD  ================= */    
                   
		 SELECT @body = @body1 + @body2 + @body3        
           
		 --REPLACE ALL THE PARAMETER VALUE        
		 SET @body = REPLACE(@body,'{username}',@User_Name)
		 SET @body = REPLACE(@body,'{first_name}',@First_Name)
		 SET @body = REPLACE(@body,'{last_name}',@Last_Name)
		 SET @body = REPLACE(@body,'{password}',@Pass_Word)        
		 SET @body = REPLACE(@body,'{isLDAPAuthReqd}',@IsLDAP_Required)        
		 SET @body = REPLACE(@body,'{SiteAddress}',@Site_Address)        
		 SET @body = REPLACE(@body,'{system_admin}',@System_Name)        
		 IF(@Status = 'NP')     
		   SET @body = REPLACE(@body,'{regenerated}','generated') 
		 ELSE IF(@Status = 'FP')     
			SET @body = REPLACE(@body,'{regenerated}','regenerated') 

		 print @User_Name
		 print @First_Name
		 print @Last_Name
		 print @Pass_Word
		 print @IsLDAP_Required
		 print @Site_Address
		 print @System_Name
           
		 --SELECT @body      
     
		 ------------Send E-Mail----------
		 declare @DefaultSiteUrl NVARCHAR(500) = ''
		 DECLARE @DatabaseEmail_Profile varchar(200)	
		 --SELECT @DatabaseEmail_Profile = parameter_value FROM SystemParameterNew WHERE parameter_name = 'DatabaseEmail_Profile'
		 SELECT @DatabaseEmail_Profile = parameter_value FROM SystemParameterNew WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'

		 declare @MailSubjectCr NVARCHAR(250) = ''
		 IF(@Status = 'FP') 
			BEGIN
			SET @MailSubjectCr = 'RightsU - New password for the system RightsU'
			END
		 ELSE IF(@Status = 'NUC') 
			BEGIN
				SET @MailSubjectCr = 'RightsU - New user created'
			END
		 ELSE IF(@Status = 'NP') 
			BEGIN
				SET @MailSubjectCr = 'RightsU - New user created'
			END
	 
		--EXEC msdb.dbo.sp_send_dbmail 
		--@profile_name = @DatabaseEmail_Profile,
		--@recipients =  @cur_email_id,
		--@subject = @MailSubjectCr,
		--@body = @body, 
		--@body_format = 'HTML'; 

		INSERT INTO @Email_Config_Users_UDT(Email_Config_Code, Email_Body, To_User_Mail_Id, [Subject])
		SELECT @Email_Config_Code, @body, ISNULL(@cur_email_id ,''),  @MailSubjectCr


		EXEC USP_Insert_Email_Notification_Log @Email_Config_Users_UDT
		------Send E-Mail END     
	 
	--if(@Loglevel < 2)Exec [USPLogSQLSteps] '[usp_GetUserEMail_Body]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''    
END