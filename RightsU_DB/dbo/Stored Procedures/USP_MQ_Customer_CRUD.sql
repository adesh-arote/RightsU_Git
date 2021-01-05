CREATE PROCEDURE [dbo].[USP_MQ_Customer_CRUD]    
(  
	 @read nvarchar(max),  
	 @mq_config_code int  
)   
as      
 --=============================================      
 --Author:		Aditya Bandivadekar    
 --Create date: 11 JAN 2019     
 --=============================================    
BEGIN      
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
	 --@Read VARCHAR(MAX) = '74052760^C^4^C0002167^1234567890^Alan Walker^New York^3RD,305 SRD EXOTICA,^BHUBANESHWAR KHORDHA^RANGMATIA MANCHESHWAR^BHUBANESWAR^751017^Orissa^33^022-67081981^9820278469^^pavanm@setindia.com^DHAPS8168H^^^^21DHAPS8168H1Z5^1^N^NA',  
	 --@MQ_Config_Code INT = 123  
   
  
  
	 SELECT * INTO #Temp FROM  fn_Split_withdelemiter(@Read, '^')

  
	 DECLARE   
	 @Message# VARCHAR(MAX), @Operation CHAR(1), @App_ID INT, @MDM_Code NVARCHAR(MAX) = '', @RightsU_Customer_ID NVARCHAR(MAX),  @Customer_Name NVARCHAR(MAX),   
	 @Contact_Name NVARCHAR(MAX), @Address NVARCHAR(MAX), @Country_Code NVARCHAR(MAX), @Mobile_No VARCHAR(20), @Phone_No VARCHAR(20), @Fax_No VARCHAR(100), @Email NVARCHAR(MAX),   
	 @PAN_No NVARCHAR(MAX), @ST_No NVARCHAR(MAX), @VAT_No NVARCHAR(MAX), @CST_No NVARCHAR(MAX), @GST_No NVARCHAR(MAX), @Customer_Type NVARCHAR(MAX),  
	 @Is_Error CHAR(1) = 'N', @Count INT , @MQ_Log_Code INT, @SF NVARCHAR(MAX) = 'FAIL', @Customer_Block_Status CHAR(1) = 'N', @Block_Reason VARCHAR(MAX),
	 @errorMessage NVARCHAR(MAX), @RUBMSV_Vendor_ID NVARCHAR(MAX) = '';
  
	 PRINT 'Begin entry in MQ_Log'  
	 INSERT INTO MQ_Log (MQ_Config_Code , Message_Key, Request_Text , Request_Time , Module_Code , Record_Status)  
	 SELECT @MQ_Config_Code, number, @Read, GETDATE(), 211 , 'BEGIN' FROM #Temp WHERE id = 1   
 
	 SET @MQ_Log_Code = IDENT_CURRENT('MQ_Log')  
  
	 PRINT 'Insert read string into #Temp'  
	 SELECT @Count = Count(*) FROM #Temp  
  
	 PRINT ' Validation Starts'  
	 IF (@Count = 26)  
	 BEGIN  
		  SELECT @Message# =   (SELECT number FROM #Temp WHERE id = 1),
			@Operation =  (SELECT number FROM #Temp WHERE id = 2),  
			@App_ID =   (SELECT number FROM #Temp WHERE id = 3),  
			@MDM_Code =   (SELECT number FROM #Temp WHERE id = 4),  
			@RightsU_Customer_ID =(SELECT number FROM #Temp WHERE id = 5),  
			@Customer_Name =  (SELECT number FROM #Temp WHERE id = 6),  
			@Contact_Name =  (SELECT number FROM #Temp WHERE id = 7),  
			@Address =   STUFF((SELECT ', ' + ISNULL(number,'') FROM #Temp WHERE id in (8,9,10,11,12,13)
			FOR XML PATH(''),ROOT('MyString'),TYPE).value('/MyString[1]','varchar(max)'),1,2,''),  
			@Country_Code =  (SELECT number FROM #Temp WHERE id = 14),  
			@Mobile_No =  (SELECT number FROM #Temp WHERE id = 15),
			@Phone_No =   (SELECT number FROM #Temp WHERE id = 16),
			@Fax_No =   (SELECT number FROM #Temp WHERE id = 17),
			@Email =   (SELECT number FROM #Temp WHERE id = 18),
			@PAN_No =   (SELECT number FROM #Temp WHERE id = 19),  
			@ST_No =   (SELECT number FROM #Temp WHERE id = 20),  
			@VAT_No =   (SELECT number FROM #Temp WHERE id = 21),  
			@CST_No =   (SELECT number FROM #Temp WHERE id = 22),
			@GST_No =   (SELECT number FROM #Temp WHERE id = 23),  
			@Customer_Type =  (SELECT number FROM #Temp WHERE id = 24),
			@Customer_Block_Status = (SELECT number FROM #Temp WHERE id = 25),  
			@Block_Reason = (SELECT number FROM #Temp WHERE id = 26)  

		  PRINT ' Validating particular coulmns'  
		
		  SET @Customer_Block_Status = CASE @Customer_Block_Status WHEN 'Y' THEN 'N' WHEN 'N' THEN 'Y' ELSE '' END

		  IF(UPPER(@Operation) = 'U')  
		  BEGIN 

				SELECT @RightsU_Customer_ID =  REPLACE(@RightsU_Customer_ID,'RUC','')

			   SET @RUBMSV_Vendor_ID = 'RUC'+ ISNULL(@RightsU_Customer_ID,'')

			   IF(ISNUMERIC(@RightsU_Customer_ID) = 0)
			   BEGIN
			   		PRINT 'Customer Code Is not a valid code '  
			   		SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '112;Customer Code Is not a valid code;'  
			   END
			   ELSE
			   BEGIN
				   IF NOT EXISTS (SELECT * FROM Vendor WHERE Vendor_Code = @RightsU_Customer_ID AND Party_Type = 'C')--AND Is_Active = 'Y')  
				   BEGIN  
						PRINT 'Customer Code not exists'  
						SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '101;Customer Code does not exists;'  
				   END 
			   
				   PRINT 'Customer Name not exists'  
				   SELECT TOP 1 @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '108;Duplicate Customer Name;'  FROM Vendor V 
				   WHERE V.Vendor_Name = @Customer_Name  AND V.Vendor_Code <> @RightsU_Customer_ID AND V.Is_Active = 'Y' AND Party_Type = 'C'
			   END   
		  END  
		  ELSE
		  BEGIN
				PRINT 'Customer Name not exists'  
				SELECT TOP 1 @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '108;Duplicate Customer Name;'  FROM Vendor V WHERE V.Vendor_Name = @Customer_Name  AND V.Is_Active = 'Y'
		  END
		  --------------------------------------------------------------------------------------------------------------  
		  PRINT 'Customer name is blank'   
		  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '102;Customer name is blank;'  WHERE ISNULL(@Customer_Name,'') = ''  
		  --------------------------------------------------------------------------------------------------------------  
		  PRINT 'Address is blank'  
		  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '103;Address is blank;'  WHERE @Address = ''  
		  --------------------------------------------------------------------------------------------------------------  
		  PRINT 'Block Status is blank'  
		  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '113;Block Status is blank;'  WHERE @Customer_Block_Status = ''  
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
		  
		  --DECLARE @Non_Existing_Roles  NVARCHAR(MAX)  , @Non_Existing_Roles_Code NVARCHAR(MAX)  
		  --SELECT * INTO #temp_Role_Code FROM fn_Split_withdelemiter(@Customer_Type,',')  
		  --SELECT  @Non_Existing_Roles = count(*) FROM #temp_Role_Code WHERE number not in (SELECT Role_Code FROM [role] WHERE role_Type = 'V')  
		  --IF (@Non_Existing_Roles > 0)  
		  --BEGIN  
			 --  SELECT @Non_Existing_Roles_Code = STUFF((SELECT DISTINCT ', ' + CAST(number as varchar) FROM #temp_Role_Code WHERE number not in (SELECT Role_Code FROM [role] WHERE role_Type = 'V')  
				--FOR XML PATH(''),root('MyString'),type).value('/MyString[1]','varchar(max)'),1,1,'')  
			 --  PRINT 'Invalid Roles Name '+ @Non_Existing_Roles_Code + '.'  
			 --  SELECT @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '110;Invalid Roles code'+@Non_Existing_Roles_Code+';'
		  --END  
	 END  
	 ELSE  
	 BEGIN  
		  PRINT 'Total Count of rows is not equal to 26'  
		  SELECT  @Is_Error = 'Y', @errorMessage = ISNULL(@errorMessage,'') + '111;Total Count of rows is not equal to 26;'   
	 END  
	 PRINT ' Validation Ends'  
  
	 IF(@Is_Error <> 'N')  
	 BEGIN     
		   PRINT 'FAIL entry in MQ_Log'  
		   SELECT @SF = 'FAIL'
		   UPDATE MQ_Log SET 
					Request_Time = GETDATE(), 
					Record_Status = @SF, 
					Request_Text =	ISNULL(@Message#,'')+'^'+ISNULL(@MDM_Code,'') +'^'+ @RUBMSV_Vendor_ID +'^'+@SF+'^'+@SF+'^'+ ISNULL(@errorMessage,'') +'^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8))
		   WHERE MQ_Log_Code = @MQ_Log_Code  
	 END  
  
	BEGIN TRY
		 SELECT Country_Code as id INTO #temp_Country FROM Country WHERE Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Country_Code,','))  
		 PRINT ' Check if status is C -Create or U - Update'
		 	
		 IF(UPPER(@Operation) = 'C' AND @Is_Error <> 'Y')  
		 BEGIN  
			  PRINT '  CREATE Records and insert in vendor'  
			  --Select TOP 1 * from Vendor
			  --------------------------------------------------------------------------------------------------------------  
			  INSERT INTO Vendor (Vendor_Name, [Address], Phone_No, Fax_No, ST_No, VAT_No, PAN_No, Inserted_On, Inserted_By, Is_Active, CST_No, GST_No, MQ_Ref_Code, MDM_Code, Is_BV_Push,Record_Status,Party_Type)  
			  SELECT @Customer_Name, @Address, @Phone_No, @Fax_No, @ST_No, @VAT_No, @PAN_No, GETDATE(), 143, @Customer_Block_Status, @CST_No, @GST_No, @MQ_Config_Code, @MDM_Code , 'N','D','C'
			  SET @RightsU_Customer_ID = IDENT_CURRENT('Vendor')  
			  --------------------------------------------------------------------------------------------------------------  
			  INSERT INTO Vendor_Country (Vendor_Code, Country_Code, Is_Theatrical)  
			  SELECT @RightsU_Customer_ID , Country_Code , Is_Theatrical_Territory FROM Country WHERE Country_Code IN (SELECT number FROM dbo.fn_Split_withdelemiter(@Country_Code,','))  
			  --------------------------------------------------------------------------------------------------------------  
			  INSERT INTO Vendor_Contacts (Vendor_Code, Contact_Name, Phone_No, Email)  
			  SELECT @RightsU_Customer_ID, @Contact_Name, @Mobile_No, @Email  
			  --------------------------------------------------------------------------------------------------------------  
			  --INSERT INTO Vendor_Role(Vendor_Code, Role_Code, Is_Active)  
			  --SELECT @RightsU_Customer_ID, Role_Code, 'Y' FROM [Role] WHERE Role_Code IN (select number from #temp_Role_Code)  
			    DECLARE @Content_Owner INT,@Platform_Operator INT
			  SELECT @Content_Owner = Role_Code FROM Role WHERE Role_Name = 'Content Owner' AND Role_Type = 'V'
			  SELECT @Platform_Operator = Role_Code FROM Role WHERE Role_Name = 'Platform Operator' AND Role_Type = 'V'
		
			  INSERT INTO Vendor_Role(Vendor_Code, Role_Code, Is_Active)  
			  SELECT @RightsU_Customer_ID, @Content_Owner, 'Y' --Content Owner
			  UNION
			  SELECT @RightsU_Customer_ID, @Platform_Operator, 'Y' --Platform Operator

			  
			  --------------------------------------------------------------------------------------------------------------  
		 END  
		 ELSE IF(UPPER(@Operation) = 'U' AND @Is_Error <> 'Y')  
		 BEGIN  
			  PRINT '  Update Records and Update in vendor'  
			  --------------------------------------------------------------------------------------------------------------  
			  UPDATE Vendor SET Vendor_Name = @Customer_Name, [Address] = @Address, Phone_No = @Phone_No, Fax_No = @Fax_No, ST_No = @ST_No, VAT_No = @VAT_No, PAN_No = @PAN_No,  
			  Last_Updated_Time = GETDATE(), Last_Action_By = 143, Is_Active = @Customer_Block_Status, CST_No = @CST_No, GST_No = @GST_No, MQ_Ref_Code = @MQ_Config_Code,Party_Type = 'C' 
			  WHERE Vendor_Code = @RightsU_Customer_ID   
			  --------------------------------------------------------------------------------------------------------------  
			  DELETE FROM  Vendor_Country WHERE Vendor_Code  = @RightsU_Customer_ID AND Country_Code NOT IN (SELECT id FROM #temp_Country)  
			  INSERT INTO Vendor_Country (Vendor_Code, Country_Code, Is_Theatrical)  
			  SELECT @RightsU_Customer_ID , Country_Code , Is_Theatrical_Territory FROM Country WHERE Country_Code IN   
			  (SELECT id FROM #temp_Country  
			   EXCEPT  
			   SELECT country_Code FROM Vendor_Country  WHERE Vendor_Code = @RightsU_Customer_ID)  
			  --------------------------------------------------------------------------------------------------------------  
			  UPDATE Vendor_Contacts SET Contact_Name = @Contact_Name, Phone_No = @Mobile_No, Email = @Email WHERE Vendor_Code = @RightsU_Customer_ID    
			  --------------------------------------------------------------------------------------------------------------  
			  --DELETE FROM  Vendor_Role WHERE Vendor_Code  = @RightsU_Customer_ID AND Role_Code NOT IN (SELECT number FROM #temp_Role_Code)  
			  --INSERT INTO Vendor_Role(Vendor_Code, Role_Code, Is_Active)  
			  --SELECT @RightsU_Customer_ID, Role_Code, 'Y' FROM [Role] WHERE Role_Code IN   
			  --(SELECT number FROM #temp_Role_Code  
			  --EXCEPT  
			  --SELECT Role_Code FROM Vendor_Role  WHERE Vendor_Code = @RightsU_Customer_ID)  

			  --------------------------------------------------------------------------------------------------------------  
			  DROP TABLE #temp_Country    
			  DROP TABLE #temp_Role_Code 
		 END 	
	END TRY
	BEGIN CATCH
			 UPDATE MQ_Log SET Request_Time = GETDATE() , Record_Status = 'PROCESS FAIL' , Request_Text = ISNULL(@Message#,'')+'^'+ISNULL(@MDM_Code,'') +'^'+ @RUBMSV_Vendor_ID +'^'+'FAIL'+'^'+ CAST( ERROR_NUMBER() AS NVARCHAR(MAX)) +';'+ ERROR_MESSAGE() +';^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8))
			 WHERE MQ_Log_Code = @MQ_Log_Code  
			-- SELECT ISNULL(@Message#,'')+'^'+ISNULL(@MDM_Code,'') +'^'+ @RUBMSV_Vendor_ID +'^'+'FAIL'+'^'+CAST( ERROR_NUMBER() AS NVARCHAR(MAX)) +';'+ ERROR_MESSAGE() +';^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8))
	END CATCH

	 IF(@Is_Error <> 'Y')  
	 BEGIN    
		  IF (@Operation = 'C')
		  BEGIN
				SET @RUBMSV_Vendor_ID = 'RUC'+ ISNULL(@RightsU_Customer_ID,'')
		  END 
		  PRINT 'SUCCESS entry in MQ_Log'  
		  SELECT @SF = 'SUCCESS'
		  INSERT INTO MQ_Log (MQ_Config_Code , Message_Key, Request_Text , Request_Time , Module_Code , Record_Code , Record_Status)  
		  SELECT @MQ_Config_Code, @Message# , ISNULL(@MDM_Code,'') +'^'+ @RUBMSV_Vendor_ID +'^' + @SF+'^'+@SF+'^'+ ISNULL(@errorMessage,'') +'^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8)) , GETDATE(), 211 , @RightsU_Customer_ID , @SF
	 END

	 PRINT 'Drop temp table'  
	 IF(OBJECT_ID('TEMPDB..#Temp') IS NOT NULL)  
		DROP TABLE #Temp  
	 IF(OBJECT_ID('TEMPDB..#temp_Country') IS NOT NULL)  
		DROP TABLE #temp_Country  
	 IF(OBJECT_ID('TEMPDB..#temp_Role_Code') IS NOT NULL)  
		DROP TABLE #temp_Role_Code   
  
	 SELECT  ISNULL(@Message#,'')+'^'+ISNULL(@MDM_Code,'')+ '^'+ @RUBMSV_Vendor_ID +'^' +@SF+'^'+ ISNULL(@errorMessage,'')+'^'+CONVERT(VARCHAR(10), GETDATE(), 103)+'^'+ CAST(CONVERT (TIME, GETDATE())AS VARCHAR(8))
	 
	 --Select '' AS Result

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	IF OBJECT_ID('tempdb..#temp_Country') IS NOT NULL DROP TABLE #temp_Country
	IF OBJECT_ID('tempdb..#temp_Role_Code') IS NOT NULL DROP TABLE #temp_Role_Code
END  


--Select * from Vendor  order by 1 desc