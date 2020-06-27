CREATE PROCEDURE [dbo].[USP_SendMail_Page_Crashed]
(
	@User_Name NVARCHAR(100),	
	@Site_Address NVARCHAR(200),       
	@Entity_Name NVARCHAR(100),
	@Controller_Name VARCHAR(50),
	@Action_Name VARCHAR(50),
	@View_Name VARCHAR(50), --Here ViewNAme = id
	@Error_Desc NVARCHAR(MAX),
	@Error_Type NVARCHAR(100),
	@IP_Address VARCHAR(50),
	@FromMailId NVARCHAR(500),
	@ToMailId NVARCHAR(500)
)
AS
 --=============================================
 --Author:		SAGAR MAHAJAN
 --Create DATE: 02 Feb 2016
 --Description:	Send Exception Email When Page Crash
 --=============================================
BEGIN
	SET NOCOUNT ON;
	DECLARE @body  NVARCHAR(MAX)  SET @body  = 'Page Crashed Dev Environment body'       
	SELECT TOP 1 @body = Template_Desc FROM Email_template WHERE Template_For = 'Exception_Page_Crash'

	 ------------Send E-Mail----------
     DECLARE @DefaultSiteUrl VARCHAR(500) = ''
     DECLARE @DatabaseEmail_Profile VARCHAR(200)	
	 SELECT @DatabaseEmail_Profile = parameter_value FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
	 SELECT TOP 1 @ToMailId = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'ToMailID_Page_Crash' 
	 DECLARE @MailSubjectCr VARCHAR(250) = 'Page Crashed Dev Environment'
	-- DECLARE @cur_email_id  VARCHAR(100)= 'sagar@uto.in'
	 
	 SET @body  = REPLACE(@body ,'{UserName}',@User_Name)
	 --SET @body  = REPLACE(@body ,'{First_Name}',@First_Name)
	 --SET @body  = REPLACE(@body ,'{Last_Name}',@Last_Name)
	 SET @body  = REPLACE(@body ,'{Directoryname}',@Site_Address)
	 SET @body  = REPLACE(@body ,'{entityName}',@Entity_Name)
	 SET @body  = REPLACE(@body ,'{Controller_Name}',@Controller_Name)
	 SET @body  = REPLACE(@body ,'{Error_Type}',@Error_Type)
	 
	 SET @body  = REPLACE(@body ,'{Action_Name}',@Action_Name)
	 SET @body  = REPLACE(@body ,'{Search_ID}',@View_Name)
	 SET @body  = REPLACE(@body ,'{Error_Desc}',@Error_Desc)
	 SET @body  = REPLACE(@body ,'{ipAddress}',@IP_Address)
	 SET @body  = REPLACE(@body ,'{Getdate}',GETDATE())

	EXEC msdb.dbo.sp_send_dbmail 
	@profile_name = @DatabaseEmail_Profile,
	@recipients =  @ToMailId,
	@subject = @MailSubjectCr,
	@body = @body, 
	@body_format = 'HTML';  
    ------Send E-Mail END         
END

/*
SELECT * FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin',  'http://UTO2008R2-SQLR2/RIGHTSU_NEO/','RU','','','','','',''
 EXEC [dbo].[USP_SendMail_Page_Crashed] 'admin',  'http://UTO2008R2-SQLR2/RIGHTSU_NEO/','RU','CN','AN','VN','ED','ET','IP','FR','TI'
/****************Insert Email Template******************************
IF NOT EXISTS(SELECT TOP 1 * FROM Email_template WHERE Template_For = 'Exception_Page_Crash')
BEGIN
DECLARE @Temp VARCHAR(MAX)=
'
<table  width="90%" style="border: 1px solid #df4a40; background:"#f7eaea";>
<tr> 
<td style="height: 30px;width:20%;border: 1px solid #df4a40;"> 
Error Ocurred in : 
</td>
<td  style="height: 30px;border: 1px solid #df4a40">{Directoryname}
</td>
</tr> 
<tr>
<td style="height: 30px;width:20%;border: 1px solid #df4a40;"> 
Page Name  : 
</td>
<td style="height: 30px;border: 1px solid #df4a40">
                    Controller Name  : {Controller_Name} &nbsp;&nbsp;&nbsp;
					Action Name  : {Action_Name} &nbsp;&nbsp;&nbsp;
					Id  : {Search_ID}					
</td> 
</tr>
<tr> 
<td style="height: 30px;width:20%;border: 1px solid #df4a40;">
LogIn User Name/User NTID :
</td>
<td style="height: 30px;border: 1px solid #df4a40">{UserName}
</td>
</tr>
<tr> 
<td style="height: 30px;width:20%;border: 1px solid #df4a40;"> Entity :</td>
<td style="height: 30px;border: 1px solid #df4a40">{entityName}
</td> 
</tr>
<tr> 
<td style="height: 30px;width:20%;border: 1px solid #df4a40;"> 
 Error occured on :
 </td>
 <td style="height: 30px;border: 1px solid #df4a40">
 {Getdate} 
 </td> 
 </tr>
 <tr>
 <td style="height: 30px;border: 1px solid #df4a40">
Error Type : </td> 
 <td style="height: 30px;border: 1px solid #df4a40">{Error_Type} 
</td>
</tr>
<tr> 
<td valign="top" style="height: 30px;border: 1px solid #df4a40"> Error Info: 
</td> 
<td style="height: 30px;border: 1px solid #df4a40"> {Error_Desc}]   
</td> 
</tr>
</table>
'
INSERT INTO Email_template(Template_Desc,Template_For)
SELECT @Temp ,'Exception_Page_Crash'
--SELECT @Temp
END
--DELETE FROM Email_template WHERE Template_For = 'Exception_Page_Crash'
IF NOT EXISTS(SELECT TOP 1 Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'ToMailID_Page_Crash' )
INSERT INTO System_Parameter_New(Parameter_Name,Parameter_Value,IsActive,Inserted_On)
SELECT 'ToMailID_Page_Crash','sagarm@uto.in','Y',GETDATE()

*/
*/




