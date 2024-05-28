CREATE PROCEDURE [dbo].[USP_MQ_Vendor_CRUD]    
(  
	 @read nvarchar(max),  
	 @mq_config_code int  
)   
as      
 --=============================================      
 --Author:		Akshay Rane     
 --Create date: 16 Nov 2017     
 --=============================================    
BEGIN      
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_MQ_Vendor_CRUD]', 'Step 1', 0, 'Started Procedure', 0, ''
		 SET NOCOUNT ON      
		 --U = UPDATE  
		 --C = CREATE  
  
		 PRINT 'Drop temp table'  
		 IF(OBJECT_ID('TEMPDB..#Temp') IS NOT NULL)    
			DROP TABLE #Temp  
		 IF(OBJECT_ID('TEMPDB..#temp_Country') IS NOT NULL)  
			DROP TABLE #temp_Country   
		 IF(OBJECT_ID('TEMPDB..#temp_Role_Code') IS NOT NULL)  
			DROP TABLE #temp_Role_Code 

		 --DECLARE  
		 --@Read VARCHAR(MAX) = '1003^C^1^V0000001^^^Manoj Vipuk Surve^Rajesh Shabnam^A-1907, Yash Pinncale^Upper Chembur^Near Govandi Station^Mumbai^400054^Maharashtra^1,2,3,999^9221234567^22222222^Test^akshay@gmail.com^AAAAM9876G^^^^23AAAAAA1234567G^8^N^THIS IS TESTING',  
		 --@MQ_Config_Code INT = 134  
  
		 SELECT * INTO #Temp FROM  fn_Split_withdelemiter(@Read, '^')  
  
		 DECLARE   
		 @Message# VARCHAR(MAX), @Operation CHAR(1), @App_ID INT, @MDM_Code NVARCHAR(MAX), @RightsU_Vendor_ID NVARCHAR(MAX), @BV_ID NVARCHAR(MAX), @Vendor_Name NVARCHAR(MAX),   
		 @Contact_Name NVARCHAR(MAX), @Address NVARCHAR(MAX), @Country_Code NVARCHAR(MAX), @Mobile_No VARCHAR(20), @Phone_No VARCHAR(20), @Fax_No VARCHAR(100), @Email NVARCHAR(MAX),   
		 @PAN_No NVARCHAR(MAX), @ST_No NVARCHAR(MAX), @VAT_No NVARCHAR(MAX), @CST_No NVARCHAR(MAX), @GST_No NVARCHAR(MAX), @Venor_Type_Name NVARCHAR(MAX),  
		 @Is_Error CHAR(1) = 'N', @Count INT , @MQ_Log_Code INT, @SF NVARCHAR(MAX) = 'FAIL', @Block_Status CHAR(1) = 'N', @Block_Reason VARCHAR(MAX),
		 @errorMessage NVARCHAR(MAX), @RUBMSV_Vendor_ID NVARCHAR(MAX) = '';
  
		 PRINT 'Begin entry in MQ_Log'  
		 INSERT INTO MQ_Log (MQ_Config_Code , Message_Key, Request_Text , Request_Time , Module_Code , Record_Status)  
		 SELECT @MQ_Config_Code, number, @Read, GETDATE(), 71 , 'BEGIN' FROM #Temp WHERE id = 1   
  
		 SET @MQ_Log_Code = IDENT_CURRENT('MQ_Log')  
  
		 PRINT 'Insert read string into #Temp'  
		 SELECT @Count = Count(*) FROM #Temp  
  
		 PRINT ' Validation Starts'  
		 IF (@Count = 27)  
		 BEGIN  
			  SELECT @Message# =   (SELECT number FROM #Temp WHERE id = 1),
				@Operation =  (SELECT number FROM #Temp WHERE id = 2),  
				@App_ID =   (SELECT number FROM #Temp WHERE id = 3),  
				@MDM_Code =   (SELECT number FROM #Temp WHERE id = 4),  
				@RightsU_Vendor_ID =(SELECT number FROM #Temp WHERE id = 5),  
				@BV_ID =   (SELECT number FROM #Temp WHERE id = 6),  
				@Vendor_Name =  (SELECT number FROM #Temp WHERE id = 7),  
				@Contact_Name =  (SELECT number FROM #Temp WHERE id = 8),  
				@Address =   STUFF((SELECT ', ' + ISNULL(number,'') FROM #Temp WHERE id in (9,10,11,12,13,14)
				FOR XML PATH(''),ROOT('MyString'),TYPE).value('/MyString[1]','varchar(max)'),1,2,''),  
				@Country_Code =  (SELECT number FROM #Temp WHERE id = 15),  
				@Mobile_No =  (SELECT number FROM #Temp WHERE id = 16),
				@Phone_No =   (SELECT number FROM #Temp WHERE id = 17),
				@Fax_No =   (SELECT number FROM #Temp WHERE id = 18),
				@Email =   (SELECT number FROM #Temp WHERE id = 19),
				@PAN_No =   (SELECT number FROM #Temp WHERE id = 20),  
				@ST_No =   (SELECT number FROM #Temp WHERE id = 21),  
				@VAT_No =   (SELECT number FROM #Temp WHERE id = 22),  
				@CST_No =   (SELECT number FROM #Temp WHERE id = 23),
				@GST_No =   (SELECT number FROM #Temp WHERE id = 24),  
				@Venor_Type_Name =  (SELECT number FROM #Temp WHERE id = 25),
				@Block_Status = (SELECT number FROM #Temp WHERE id = 26),  
				@Block_Reason = (SELECT number FROM #Temp WHERE id = 27)  

			  PRINT ' Validating particular coulmns'  
		
			  SET @Block_Status = CASE @Block_Status WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE '' END

			  IF(UPPER(@Operation) = 'U')  
			  BEGIN 
					SELECT @RightsU_Vendor_ID =  REPLACE(@RightsU_Vendor_ID,'RUVIDRUBMSV','')
					SELECT @RightsU_Vendor_ID =  REPLACE(@RightsU_Vendor_ID,'RUVID','')
					SELECT @RightsU_Vendor_ID =  REPLACE(@RightsU_Vendor_ID,'RUBMSVRUBMSV','')
					SELECT @RightsU_Vendor_ID =  REPLACE(@RightsU_Vendor_ID,'RUBMSV','')

				   SET @RUBMSV_Vendor_ID = 'RUBMSV'+ ISNULL(@RightsU_Vendor_ID,'')

				   IF(ISNUMERIC(@RightsU_Vendor_ID) = 0)
				   BEGIN
			   			PRINT 'Vendor Code Is not a valid code '  
			   			SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '112;Vendor Code Is not a valid code;'  
				   END
				   ELSE
				   BEGIN
					   IF NOT EXISTS (SELECT * FROM Vendor (NOLOCK) WHERE Vendor_Code = @RightsU_Vendor_ID AND Party_Type = 'V')--AND Is_Active = 'Y')  
					   BEGIN  
							PRINT 'Vendor Code not exists'  
							SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '101;Vendor Code does not exists;'  
					   END 
			   
					   PRINT 'Vendor Name not exists'  
					   SELECT TOP 1 @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '108;Duplicate Vendor Name;'  FROM Vendor V  (NOLOCK)
					   WHERE V.Vendor_Name = @Vendor_Name  AND V.Vendor_Code <> @RightsU_Vendor_ID AND V.Is_Active = 'Y' AND Party_Type = 'V'
				   END   
			  END  
			  ELSE
			  BEGIN
					PRINT 'Vendor Name not exists'  
					SELECT TOP 1 @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '108;Duplicate Vendor Name;'  FROM Vendor V (NOLOCK) WHERE V.Vendor_Name = @Vendor_Name  AND V.Is_Active = 'Y'
			  END
			  --------------------------------------------------------------------------------------------------------------  
			  PRINT 'Vendor name is blank'   
			  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '102;Vendor name is blank;'  WHERE ISNULL(@Vendor_Name,'') = ''  
			  --------------------------------------------------------------------------------------------------------------  
			  PRINT 'Address is blank'  
			  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '103;Address is blank;'  WHERE @Address = ''  
			  --------------------------------------------------------------------------------------------------------------  
			  PRINT 'Block Status is blank'  
			  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '113;Block Status is blank;'  WHERE @Block_Status = ''  
			  -------------------------------------------------------------------------------------------------------------- 
			  PRINT 'Phone No is blank OR IS NUMERIC'  
			  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '104;Phone No Should Not Be Blank And No Special Characters Or Space Will Be Accepted;' WHERE  ISNULL(@Phone_No,'') = ''  
			  --------------------------------------------------------------------------------------------------------------  
 
			  PRINT 'Invalid email id'  

			  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '107;Invalid email id;'   WHERE @Email <> '' AND NOT (  
				CHARINDEX(' ',LTRIM(RTRIM(@Email))) = 0  
				AND  LEFT(LTRIM(@Email),1) <> '@'  
				AND  RIGHT(RTRIM(@Email),1) <> '.'  
				AND  CHARINDEX('.',@Email , CHARINDEX('@',@Email))- CHARINDEX('@',@Email ) > 1  
				AND  LEN(LTRIM(RTRIM(@Email )))- LEN(REPLACE(LTRIM(RTRIM(@Email)),'@','')) = 1  
				AND  CHARINDEX('.',REVERSE(LTRIM(RTRIM(@Email)))) >= 3  
				AND  (CHARINDEX('.@',@Email ) = 0  
				AND  CHARINDEX('..',@Email ) = 0))-- VALIDATE EMAIL ID   
			  --------------------------------------------------------------------------------------------------------------  
			  --DECLARE @Non_Existing_Country INT , @Non_Existing_Country_Code NVARCHAR(MAX)  
			  --SELECT number as id INTO #temp_Country FROM dbo.fn_Split_withdelemiter(@Country_Code,',')  
			  --SELECT @Non_Existing_Country = COUNT(*) FROM #temp_Country WHERE id not in (SELECT country_Code FROM Country)  
			  --IF (@Non_Existing_Country > 0)  
			  --BEGIN  
				 --  SELECT  @Non_Existing_Country_Code =  STUFF((SELECT DISTINCT ', ' + CAST(id as varchar) FROM #temp_Country WHERE id not in (SELECT country_Code FROM Country)  
					--FOR XML PATH(''),root('MyString'),type).value('/MyString[1]','varchar(max)'),1,1,'')  
				 --  PRINT 'Invalid country code '+ @Non_Existing_Country_Code + '.'  
				 --  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '109;Invalid country code'+ @Non_Existing_Country_Code + ';'
			  --END  
			  -------------------------------------------------------------------------------------------------------------- 
			  --Update  role code 1,2,3,4 as 8,9,11,12
			  --SELECT number INTO #temp_Role_Code FROM fn_Split_withdelemiter(@Venor_Type_Name,',')  WHERE number <> ''
			  --UPDATE #temp_Role_Code SET number = CASE number WHEN '1' THEN '8' WHEN '2' THEN '9' WHEN '3' THEN '11' WHEN '4' THEN '12' ELSE number END
		   
			  DECLARE @Non_Existing_Roles  NVARCHAR(MAX)  , @Non_Existing_Roles_Code NVARCHAR(MAX)  
			  SELECT * INTO #temp_Role_Code FROM fn_Split_withdelemiter(@Venor_Type_Name,',')  
			  SELECT  @Non_Existing_Roles = count(*) FROM #temp_Role_Code WHERE number not in (SELECT Role_Code FROM [role] (NOLOCK) WHERE role_Type = 'V')  
			  IF (@Non_Existing_Roles > 0)  
			  BEGIN  
				   SELECT @Non_Existing_Roles_Code = STUFF((SELECT DISTINCT ', ' + CAST(number as varchar) FROM #temp_Role_Code WHERE number not in (SELECT Role_Code FROM [role] (NOLOCK) WHERE role_Type = 'V')  
					FOR XML PATH(''),root('MyString'),type).value('/MyString[1]','varchar(max)'),1,1,'')  
				   PRINT 'Invalid Roles Name '+ @Non_Existing_Roles_Code + '.'  
				   SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '110;Invalid Roles code'+@Non_Existing_Roles_Code+';'
			  END  
		 END  
		 ELSE  
		 BEGIN  
			  PRINT 'Total Count of rows is not equal to 27'  
			  SELECT  @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '111;Total Count of rows is not equal to 27;'   
		 END  
		 PRINT ' Validation Ends'  
  
		 IF(@Is_Error <> 'N')  
		 BEGIN     
			   PRINT 'FAIL entry in MQ_Log'  
			   SELECT @SF = 'FAIL'
			   UPDATE MQ_Log SET Request_Time = GETDATE(), Record_Status = @SF, Request_Text =	ISNULL(@Message#,'')+'^'+ISNULL(@MDM_Code,'') +'^'+ @RUBMSV_Vendor_ID +'^'+ISNULL(@BV_ID,'')+'^'+@SF+'^'+@SF+'^'+ ISNULL(@errorMessage,'') +'^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8)) +'^'+ 'R' 
			   WHERE MQ_Log_Code = @MQ_Log_Code  
		 END  
  
		BEGIN TRY
			 SELECT Country_Code as id INTO #temp_Country FROM Country (NOLOCK) WHERE Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Country_Code,','))  
			 PRINT ' Check if status is C -Create or U - Update'  
			 IF(UPPER(@Operation) = 'C' AND @Is_Error <> 'Y')  
			 BEGIN  
				  PRINT '  CREATE Records and insert in vendor'  
				  --------------------------------------------------------------------------------------------------------------  
				  INSERT INTO Vendor (Vendor_Name, [Address], Phone_No, Fax_No, ST_No, VAT_No, PAN_No, Inserted_On, Inserted_By, Is_Active, CST_No, GST_No, MQ_Ref_Code, MDM_Code, Is_BV_Push,Record_Status)  
				  SELECT @Vendor_Name, @Address, @Phone_No, @Fax_No, @ST_No, @VAT_No, @PAN_No, GETDATE(), 143, @Block_Status, @CST_No, @GST_No, @MQ_Config_Code, @MDM_Code , 'N','P'
				  SET @RightsU_Vendor_ID = IDENT_CURRENT('Vendor')  
				  --------------------------------------------------------------------------------------------------------------  
				  INSERT INTO Vendor_Country (Vendor_Code, Country_Code, Is_Theatrical)  
				  SELECT @RightsU_Vendor_ID , Country_Code , Is_Theatrical_Territory FROM Country (NOLOCK) WHERE Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Country_Code,','))  
				  --------------------------------------------------------------------------------------------------------------  
				  INSERT INTO Vendor_Contacts (Vendor_Code, Contact_Name, Phone_No, Email)  
				  SELECT @RightsU_Vendor_ID, @Contact_Name, @Mobile_No, @Email  
				  --------------------------------------------------------------------------------------------------------------  
				  INSERT INTO Vendor_Role(Vendor_Code, Role_Code, Is_Active)  
				  SELECT @RightsU_Vendor_ID, Role_Code, 'Y' FROM [Role] (NOLOCK) WHERE Role_Code IN (select number from #temp_Role_Code)  
				  --------------------------------------------------------------------------------------------------------------  
			 END  
			 ELSE IF(UPPER(@Operation) = 'U' AND @Is_Error <> 'Y')  
			 BEGIN  
				  PRINT '  Update Records and Update in vendor'  
				  --------------------------------------------------------------------------------------------------------------  
				  UPDATE Vendor SET Vendor_Name = @Vendor_Name, [Address] = @Address, Phone_No = @Phone_No, Fax_No = @Fax_No, ST_No = @ST_No, VAT_No = @VAT_No, PAN_No = @PAN_No,  
				  Last_Updated_Time = GETDATE(), Last_Action_By = 143, Is_Active = @Block_Status, CST_No = @CST_No, GST_No = @GST_No, MQ_Ref_Code = @MQ_Config_Code 
				  WHERE Vendor_Code = @RightsU_Vendor_ID   
				  --------------------------------------------------------------------------------------------------------------  
				  DELETE FROM  Vendor_Country WHERE Vendor_Code  = @RightsU_Vendor_ID AND Country_Code NOT IN (SELECT id FROM #temp_Country)  
				  INSERT INTO Vendor_Country (Vendor_Code, Country_Code, Is_Theatrical)  
				  SELECT @RightsU_Vendor_ID , Country_Code , Is_Theatrical_Territory FROM Country (NOLOCK) WHERE Country_Code IN   
				  (SELECT id FROM #temp_Country  
				   EXCEPT  
				   SELECT country_Code FROM Vendor_Country  (NOLOCK) WHERE Vendor_Code = @RightsU_Vendor_ID)  
				  --------------------------------------------------------------------------------------------------------------  
				  UPDATE Vendor_Contacts SET Contact_Name = @Contact_Name, Phone_No = @Mobile_No, Email = @Email WHERE Vendor_Code = @RightsU_Vendor_ID    
				  --------------------------------------------------------------------------------------------------------------  
				  DELETE FROM  Vendor_Role WHERE Vendor_Code  = @RightsU_Vendor_ID AND Role_Code NOT IN (SELECT number FROM #temp_Role_Code)  
				  INSERT INTO Vendor_Role(Vendor_Code, Role_Code, Is_Active)  
				  SELECT @RightsU_Vendor_ID, Role_Code, 'Y' FROM [Role] (NOLOCK) WHERE Role_Code IN   
				  (SELECT number FROM #temp_Role_Code  
				  EXCEPT  
				  SELECT Role_Code FROM Vendor_Role (NOLOCK)  WHERE Vendor_Code = @RightsU_Vendor_ID)  
				  --------------------------------------------------------------------------------------------------------------  
				  DROP TABLE #temp_Country    
				  DROP TABLE #temp_Role_Code 
			 END 	
		END TRY
		BEGIN CATCH
				 UPDATE MQ_Log SET Request_Time = GETDATE() , Record_Status = 'PROCESS FAIL' , Request_Text = ISNULL(@Message#,'')+'^'+ISNULL(@MDM_Code,'') +'^'+ @RUBMSV_Vendor_ID +'^'+ISNULL(@BV_ID,'')+'^'+'FAIL'+'^'+ ERROR_NUMBER() +';'+ ERROR_MESSAGE() +';^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8)) +'^'+ 'R' 
				 WHERE MQ_Log_Code = @MQ_Log_Code  

				 SELECT ISNULL(@Message#,'')+'^'+ISNULL(@MDM_Code,'') +'^'+ @RUBMSV_Vendor_ID +'^'+ISNULL(@BV_ID,'')+'^'+'FAIL'+'^'+ ERROR_NUMBER() +';'+ ERROR_MESSAGE() +';^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8)) +'^'+ 'R' 
		END CATCH

		 IF(@Is_Error <> 'Y')  
		 BEGIN    
			  IF (@Operation = 'C')
			  BEGIN
					SET @RUBMSV_Vendor_ID = 'RUBMSV'+ ISNULL(@RightsU_Vendor_ID,'')
			  END 
			  PRINT 'SUCCESS entry in MQ_Log'  
			  SELECT @SF = 'SUCCESS'
			  INSERT INTO MQ_Log (MQ_Config_Code , Message_Key, Request_Text , Request_Time , Module_Code , Record_Code , Record_Status)  
			  SELECT @MQ_Config_Code, @Message# , ISNULL(@MDM_Code,'') +'^'+ @RUBMSV_Vendor_ID +'^' + ISNULL(@BV_ID,'')+'^'+@SF+'^'+@SF+'^'+ ISNULL(@errorMessage,'') +'^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8)) +'^'+ 'R'  , GETDATE(), 71 , @RightsU_Vendor_ID , @SF
		 END

		 PRINT 'Drop temp table'  
	  
		 SELECT  ISNULL(@Message#,'')+'^'+ISNULL(@MDM_Code,'')+ '^'+ @RUBMSV_Vendor_ID +'^' +ISNULL(@BV_ID,'')+'^'+@SF+'^'+ ISNULL(@errorMessage,'')+'^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8)) +'^'+ 'R' 

	 
		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
		IF OBJECT_ID('tempdb..#temp_Country') IS NOT NULL DROP TABLE #temp_Country
		IF OBJECT_ID('tempdb..#temp_Role_Code') IS NOT NULL DROP TABLE #temp_Role_Code
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_MQ_Vendor_CRUD]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END