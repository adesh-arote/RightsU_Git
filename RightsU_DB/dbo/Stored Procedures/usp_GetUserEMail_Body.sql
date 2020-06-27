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
      
    DECLARE @body  NVARCHAR(MAX)  SET @body  = ''       
    DECLARE @body1 NVARCHAR(1000) SET @body1 = ''        
    DECLARE @body2 NVARCHAR(1000) SET @body2 = ''       
    DEclare @body3 NVARCHAR(1000) SET @body2 = ''           
       
    --//--------------- SELECT AND SET A PARTICULAR TEMPLATE ---------------//--        
          
                /* ========== PASSWORD CHANGED =============== */      
                print @Status
    IF(@Status = 'PC' )      
    BEGIN      
          
   SELECT @body1 = Template_Desc FROM Email_template WHERE Template_For='EB1'       
         
   IF (@IsLDAP_Required = 'N')      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'EB2'       
    END       
   ELSE      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'EB3'      
             
    END      
   END      
         
   SELECT @body3 = Template_Desc FROM Email_template WHERE Template_For='EB4'       
         
     END      
           
               /* ========== END PASSWORD CHANGED =============== */      
           
               /* ==========  NEW USER CREATED  =============== */      
     IF(@Status = 'NUC')      
     BEGIN        
   SELECT @body1 = Template_Desc FROM Email_template WHERE Template_For='UB1'       
      
   IF (@IsLDAP_Required = 'N')      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'UB2'       
    END       
   ELSE      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'UB3'      
             
    END      
          
   SELECT @body3 = Template_Desc FROM Email_template WHERE Template_For='UB4'       
         
     END      
             /* ==========  NEW USER CREATED  =============== */   
               
             /* ========== FORGOT PASSWORD  ================= */    
             IF(@Status = 'FP')      
     BEGIN        
   SELECT @body1 = Template_Desc FROM Email_template WHERE Template_For='FB1'       
      
   IF (@IsLDAP_Required = 'N')      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'FB2'       
    END       
   ELSE      
    BEGIN      
       SELECT @body2 = Template_Desc FROM Email_template WHERE Template_For = 'FB3'      
             
    END      
          
   SELECT @body3 = Template_Desc FROM Email_template WHERE Template_For='FB4'       
         
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
	 --SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
	 SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile_User_Master'

	 declare @MailSubjectCr NVARCHAR(250) = ''
	 IF(@Status = 'FP') 
		BEGIN
		SET @MailSubjectCr = 'RightsU_Live :- New password for the system RightsU'
		END
	 IF(@Status = 'NUC') 
		BEGIN
			SET @MailSubjectCr = 'RightsU_Live :- New user created'
		END
	 
	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name = @DatabaseEmail_Profile,
	@recipients =  @cur_email_id,
	@subject = @MailSubjectCr,
	@body = @body, 
	@body_format = 'HTML';  
    ------Send E-Mail END         
END       
          
		  
		    
/*      
IF NOT EXISTS(SELECT * FROM System_Parameter_New WHERE Parameter_Name like 'DatabaseEmail_Profile_User_Master')
INSERT INTO system_parameter_new(parameter_name,Parameter_Value,IsActive,Last_Updated_Time)
VALUES('DatabaseEmail_Profile_User_Master','RightsU_UTO','Y',GETDATE())
        
EXEC usp_GetUserEMail_Body 'sharad', 'welcome', 'N' ,'ClickHere','CarryU','NUC'         
      
*/