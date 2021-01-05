CREATE PROCEDURE USP_BMS_Integration_Send_Exception_Email
(
	@BMS_Log_Id INT,
	@BMS_Schedule_Log_Id INT,
	@Integration_Log_Id  INT,
	@Module_Name VARCHAR(20) 
)
AS
--    ==========================
--    Author		:   Sagar Mahajan
--    Created On    :   05 Oct 2016
--    Description   :   Send Exception Email - When RU BV or RU FPC Integration SSIS Package threw Exception
--    ==========================
BEGIN	
	SET NOCOUNT ON;
	
	IF OBJECT_ID('tempdb..#Log_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Log_Data
	END	

	CREATE TABLE #Log_Data
	(		
		Log_Id VARCHAR(30),
		Module_Name VARCHAR(20),
		Request_Type VARCHAR(10),
		Request_Xml VARCHAR(MAX),
		Request_Time DATETIME,
		Response_Time DATETIME,
		Error_Description VARCHAR(MAX)
	)
	DECLARE @Log_Id VARCHAR(50) = ''
	 
	IF(ISNULL(@BMS_Log_Id,0) > 0)
	BEGIN
		SET @Log_Id = 'RUBMSDeal'+ CAST(@BMS_Log_Id AS VARCHAR(20))
		INSERT INTO #Log_Data
		(
			Log_Id,
			Module_Name,
			Request_Type,
			Request_Time,
			Request_Xml,
			Response_Time,
			Error_Description
		)
		SELECT @Log_Id AS Log_ID,
		BL.Module_Name,
		BL.Method_Type AS Request_Type,
		BL.Request_Time,
		ISNULL(BL.Request_Xml,'') AS Request_Xml ,
		BL.Response_Time,
		BL.Error_Description 
		FROM BMS_Log BL WHERE BL.BMS_Log_Code = @BMS_Log_Id AND Record_Status = 'E'
	END
	ELSE IF(ISNULL(@BMS_Schedule_Log_Id,0) > 0)
	BEGIN
		SET @Log_Id = 'RUBMSSchedule'+ CAST(@BMS_Schedule_Log_Id AS VARCHAR(20))
		INSERT INTO #Log_Data
		(
			Log_Id,Module_Name,
			Request_Type,Request_Time,
			Request_Xml,
			Response_Time,Error_Description
		)
		SELECT @Log_Id AS LogId, 'BMS_Schedule' AS Module_Name,
		BSL.Method_Type AS Request_Type ,BSL.Request_Time,
		ISNULL(BSL.Request_Xml,'') AS Request_Xml,
		ISNULL(BSL.Response_Time,'31DEC9999') AS  Response_Time, BSL.Error_Description
		FROM BMS_Schedule_Log BSL WHERE BSL.BMS_Schedule_Log_Code= @BMS_Schedule_Log_Id AND BSL.Record_Status = 'E'
	END
	ELSE IF(ISNULL(@Integration_Log_Id,0) > 0)
	BEGIN
		SET @Log_Id = 'RUFPC'+ CAST(@Integration_Log_Id AS VARCHAR(20))
		DECLARE @Int_Module_Name  VARCHAR(50) = ''
		SELECT TOP 1  @Int_Module_Name = IC.Module_Name 
		FROM Integration_Config IC WHERE IC.Integration_Config_Code IN(
			SELECT TOP 1 IL.Intergration_Config_Code FROM Integration_Log IL WHERE IL.Integration_Log_Code = @Integration_Log_Id
		)
		INSERT INTO #Log_Data
		(
			Log_Id,Module_Name,
			Request_Type,Request_Time,
			Request_Xml,
			Response_Time,Error_Description
		)
		SELECT @Log_Id AS LogId,ISNULL(@Int_Module_Name,'NA') AS Module_Name,
		IL.Request_Type AS Request_Type ,IL.Request_DateTime,
		ISNULL(IL.Request_XML,'') AS Request_Xml,
		ISNULL(IL.Response_DateTime,'31DEC9999') AS  Response_Time, ISNULL(IL.[Error_Message],'NA')
		FROM Integration_Log IL WHERE IL.Integration_Log_Code= @Integration_Log_Id AND IL.Record_Status = 'E'
	END

	IF EXISTS(SELECT 1 FROM #Log_Data LD)
	BEGIN 
		DECLARE @DatabaseEmail_Profile VARCHAR(200)	,@EmailUser_Body VARCHAR(MAX)=''		
		DECLARE @Users_Email_Id VARCHAR(1000)='',@MailSubjectCr VARCHAR(500)='',@tblBody VARCHAR(MAX)=''	
		DECLARE @LogId VARCHAR(50),@ModuleName VARCHAR(50) ,@Request_Type VARCHAR(20),@Request_Time DATETIME,
		@Request_Xml VARCHAR(MAX),@Response_Time DATETIME,@Error_Description VARCHAR(MAX)
		/*****************Set Database Profile***/
		SELECT @DatabaseEmail_Profile = parameter_value 
		FROM system_parameter_new WHERE parameter_name = 'DatabaseEmail_Profile'
		/*****************Set Email Subject***/
		SELECT  @Users_Email_Id = 'sagar@uto.in',@MailSubjectCr = 'RightsU-Broad View or RightsU-FPC Integration Error' 
		
		/*****************Set Email body***************************/
		SELECT TOP 1  @EmailUser_Body = Template_Desc 
		FROM Email_Template WHERE Template_For = 'RU_BMS_Integration_Exception'
		/*****************/
		SELECT @tblBody = @tblBody + '<table class="tblFormat">     
										 <tr>      
										 <td align="center" width="15%" class="tblHead"><b>Log Id<b></td> 
										 <td align="center" width="15%" class="tblHead"><b>Module Name<b></td>  
										 <td align="center" width="15%" class="tblHead"><b>Request Type<b></td>  
										 <td align="center" width="15%" class="tblHead"><b>Request Time<b></td> 
										 <td align="center" width="15%" class="tblHead"><b>Request XML<b></td>
										 <td align="center" width="15%" class="tblHead"><b>Response Time<b></td>  
										 <td align="center" width="25%" class="tblHead"><b>Error Description<b></td>   
										 </tr>  '
		/********************************************/
		DECLARE CUR_tblbody CURSOR FOR 
				SELECT DISTINCT Log_Id,Module_Name,Request_Type,Request_Time,Request_Xml,Response_Time,Error_Description 
				FROM #Log_Data ORDER BY Request_Time,Response_Time
		OPEN CUR_tblbody
				FETCH NEXT FROM CUR_tblbody 
					INTO @LogId,@ModuleName,@Request_Type,@Request_Time,@Request_Xml,@Response_Time,@Error_Description
			WHILE (@@FETCH_STATUS = 0)
			BEGIN			
					SELECT @tblBody = @tblBody + '<tr>      
												  <td align="center" class="tblData">'+@LogId+'</td>   
												  <td align="center" class="tblData">'+@ModuleName+'</td> 
												  <td align="center" class="tblData">'+@Request_Type+'</td> 
												  <td align="center" class="tblData">'+CONVERT(VARCHAR,@Request_Time,113)+'</td>
												  <td align="center" class="tblData">'+@Request_Xml+'</td>
												  <td align="center" class="tblData">'+ CONVERT(VARCHAR,@Response_Time,113)+'</td>
												 <td align="center" class="tblData">'+@Error_Description+'</td>
												 </tr>'												 
					FETCH NEXT FROM CUR_tblbody  
					INTO @LogId,@ModuleName,@Request_Type,@Request_Time,@Request_Xml,@Response_Time,@Error_Description
			END
		CLOSE CUR_tblbody
		DEALLOCATE CUR_tblbody
	/**********************************************/
		SET  @tblBody =  @tblBody + '</table>'
		SELECT  @EmailUser_Body = REPLACE(@EmailUser_Body,'{tblbodyData}',@tblBody)

		--/*
		print '@databaseemail_profile : - ' + @databaseemail_profile
		print '@users_email_id : - ' + @users_email_id		
		print '@mailsubjectcr  : - ' + @mailsubjectcr
		print 'emailuser_body : - ' + @emailuser_body
		--*/	
	/*****************************************/

		EXEC msdb.dbo.sp_send_dbmail 
					@profile_name = @DatabaseEmail_Profile,
					@recipients =  @Users_Email_Id,
					@subject = @MailSubjectCr,
					@body = @EmailUser_Body, 
					@body_format = 'HTML';  				
	END

	IF OBJECT_ID('tempdb..#Log_Data') IS NOT NULL DROP TABLE #Log_Data
END
/*
IF NOT EXISTS (SELECT 1 FROM Email_Template WHERE Template_For = 'RU_BMS_Integration_Exception')
BEGIN
--DELETE FROM  Email_Template WHERE Template_For = 'RU_BMS_Integration_Exception'
INSERT INTO Email_Template(Template_For,Template_Desc)
SELECT 'RU_BMS_Integration_Exception',
'<html> <head><style type="text/css"> table.tblFormat {border:1px solid black;border-collapse:collapse;} td.tblHead {border:1px solid black;color: #ffffff ; background-color: #585858;font-family:verdana;font-size:12px; } td.tblData {border:1px solid black; vertical-align:top;font-family:verdana;font-size:12px; }.textFont {color: black ; font-family:verdana;font-size:12px; } #divFooter{ color: gray;} </style></head><body> <div class="textFont">Dear &nbsp;admin, <br /><br />Mention below is the error description in RightsU - Broad View or RightsU - FPC Integration <br /><br /></div> <table class="tblFormat" > {tblbodyData} </table><br /> <div id="divFooter" class="textFont"> <br>Please feel free to reach our Client Support team at rightsusupport@uto.in , if you have any questions or need assistance.<br><br> Warm Regards,<Br><b>U-TO Client Services</b> <BR>022- 43 222 222 Extn 213</Font> </font> </div></body> </html>'
PRINT  'New Row Inserted'
END
ELSE
BEGIN
PRINT  'Already Inserted'
END
--EXEC USP_BMS_Integration_Send_Exception_Email 	41,0,0,'' 
*/