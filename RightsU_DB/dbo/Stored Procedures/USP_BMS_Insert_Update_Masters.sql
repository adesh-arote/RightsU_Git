CREATE PROCEDURE [dbo].[USP_BMS_Insert_Update_Masters]
(	
	@XML NVARCHAR(Max),
	@Module_Name VARCHAR(50),
	@User_Code INT,
	@Is_Error VARCHAR(1),
    @Error_Details VARCHAR(MAX),
    @BMS_Log_Code INT
)
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 23 Sept 2015
-- Description:	Insert Or Update Record Into All Master 
-- =============================================
AS
BEGIN
	--SET NOCOUNT ON	
	
	IF(UPPER(ISNULL(@Is_Error,'N')) = 'N')
	BEGIN
	
	-------------------------DROP Temp Tables if Exist---------------------
	IF OBJECT_ID('tempdb..#BMS_XML') IS NOT NULL
	BEGIN
		DROP TABLE #BMS_XML
	END	
	IF OBJECT_ID('tempdb..#BMS_Licensor') IS NOT NULL
	BEGIN
		DROP TABLE #BMS_Licensor
	END	
	IF OBJECT_ID('tempdb..#Temp_BMS_SysLookup') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_BMS_SysLookup
	END	
	IF OBJECT_ID('tempdb..#Temp_BMS_Media_Type_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_BMS_Media_Type_Data
	END
	IF OBJECT_ID('tempdb..#Temp_BMS_Payee_Data') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_BMS_Payee_Data
	END			
	------------------------Insert Into BMS_Temp Tables-----------------------------------------	
		--DECLARE @Batch_Id INT = 0		
		--SELECT TOP 1 @Batch_Id = ISNULL(Batch_Id,0) FROM BMS_Temp_Data_All_Masters ORDER BY 1 DESC
		--SET @Batch_Id = @Batch_Id + 1
		--INSERT INTO BMS_Temp_Data_All_Masters
		--(
		--	Batch_Id,Module_Name,BMS_XML_Data,Inserted_On
		--)
		--SELECT @Batch_Id,@Module_Name,@XML,GETDATE()		
		--SELECT * FROM BMS_Temp_Data_All_Masters	
	-------------------------Create Temp Table---------------------
	CREATE TABLE #BMS_XML
	(
		BMS_Key  INT,
		ParentStationId INT,
		BMS_Desc NVARCHAR(80), 
		Code VARCHAR(20),
		IsArchived VARCHAR(5),
		ForeignId VARCHAR(40)
	)
	
	-------------------------Start Channel Master Logic---------------------
	IF(UPPER(@Module_Name) = 'CHANNEL')
	BEGIN 	
		PRINT 'In Channel'		
		INSERT INTO #BMS_XML (BMS_Key,ParentStationId,BMS_Desc)		
		SELECT DISTINCT   COL2,COL3,COL4 FROM  BMS_Masters_Import WHERE UPPER(COL1) = 'CHANNEL'
	-------------------------Insert Or Update Logic For Channel Master------
		MERGE [Channel] Ch 
		USING  #BMS_XML BV		
			ON BV.BMS_Key = Ch.Ref_Channel_Key
			WHEN MATCHED  THEN
				UPDATE SET Ch.Channel_Name = BV.BMS_Desc ,Last_Updated_Time=GETDATE(),Last_Action_By=@User_Code ,Ref_Station_Key = BV.ParentStationId
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (Ref_Channel_Key,Ref_Station_Key,Channel_Name,Is_Active,Inserted_By,Inserted_On)
			  VALUES (BV.BMS_Key,BV.ParentStationId, BV.BMS_Desc,'Y',@User_Code,GETDATE());
	END	
	-------------------------Start LANGUAGE Master Logic---------------------
	IF(UPPER(@Module_Name) = 'LANGUAGE')
	BEGIN 
		PRINT 'In LANGUAGE'		
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc)		
		SELECT DISTINCT   COL2,COL3 FROM  BMS_Masters_Import WHERE UPPER(COL1) = 'LANGUAGE'		
		-------------------------Insert Or Update Logic For LANGUAGE Master------
		  MERGE [Language] L 
		  USING  #BMS_XML BV
			ON BV.BMS_Key = L.Ref_Language_Key
			WHEN MATCHED  THEN
			  UPDATE SET L.Language_Name = BV.BMS_Desc ,Last_Updated_Time=GETDATE(),Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (Ref_Language_Key,Language_Name,Is_Active,Inserted_By,Inserted_On)
			  VALUES (BV.BMS_Key, BV.BMS_Desc,'Y',@User_Code,GETDATE());
			--SELECT * FROM  Language-- ORDER BY 1 desc
			--WHERE Ref_Language_Key IN(SELECT BMS_Key FROM  #BMS_XML)
	END
	-------------------------Start COUNTRY Master Logic---------------------
	IF(UPPER(@Module_Name) = 'COUNTRY')
	BEGIN 
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc)		
		SELECT DISTINCT   COL2,COL3 FROM    BMS_Masters_Import WHERE UPPER(COL1) = 'COUNTRY'		
	-------------------------Insert Or Update Logic For COUNTRY Master------
	  MERGE [Country] C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.Ref_Country_Key
			WHEN MATCHED  THEN
			  UPDATE SET C.Country_Name = BV.BMS_Desc ,Last_Updated_Time=GETDATE(),Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (Ref_Country_Key,Country_Name,Is_Active,Inserted_By,Inserted_On,Is_Theatrical_Territory)
			  VALUES (BV.BMS_Key, BV.BMS_Desc,'Y',@User_Code,GETDATE(),'N');	  
			--SELECT * FROM  COUNTRY  ORDER BY 1 desc
	END
	-------------------------Start Genre Master Logic---------------------
	IF(UPPER(@Module_Name) = 'GENRE')--GENRES
	BEGIN 
	PRINT 'IN GENRE'
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc)		
		SELECT DISTINCT   COL2,COL3 FROM    BMS_Masters_Import WHERE UPPER(COL1) = 'GENRE'		
	-------------------------Insert Or Update Logic For Genre Master------
	 MERGE [Genres] C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.Ref_Genres_Key
			WHEN MATCHED  THEN
			  UPDATE SET C.Genres_Name = BV.BMS_Desc ,Last_Updated_Time=GETDATE(),Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (Ref_Genres_Key,Genres_Name,Is_Active,Inserted_By,Inserted_On)
			  VALUES (BV.BMS_Key, BV.BMS_Desc,'Y',@User_Code,GETDATE());	  
			--SELECT * FROM  [Genres]  ORDER BY 1 desc			
	END
	-------------------------Start CURRENCY Master Logic---------------------
	IF(UPPER(@Module_Name) = 'CURRENCY')
	BEGIN 
	INSERT INTO #BMS_XML (BMS_Key,BMS_Desc)		
		SELECT DISTINCT   COL2,COL3 FROM    BMS_Masters_Import WHERE UPPER(COL1) = 'CURRENCY'		
	-------------------------Insert Or Update Logic For CURRENCY Master------
	 MERGE Currency C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.Ref_Currency_Key
			WHEN MATCHED  THEN
			  UPDATE SET C.Currency_Name = BV.BMS_Desc ,Last_Updated_Time=GETDATE(),Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (Ref_Currency_Key,Currency_Name,Is_Active,Inserted_By,Inserted_On,Is_Base_Currency)
			  VALUES (BV.BMS_Key, BV.BMS_Desc,'Y',@User_Code,GETDATE(),'N');	  
			--SELECT * FROM  [Currency]  ORDER BY 1 desc			
			
	END
	-------------------------Start Category Master Logic---------------------
	IF(UPPER(@Module_Name) = 'CATEGORY')
	BEGIN 
	INSERT INTO #BMS_XML (BMS_Key,BMS_Desc)		
		SELECT DISTINCT   COL2,COL3  FROM  BMS_Masters_Import WHERE UPPER(COL1) = 'CATEGORY'		
	-------------------------Insert Or Update Logic For Category Master------
	 MERGE Category C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.Ref_Category_Key
			WHEN MATCHED  THEN
			  UPDATE SET C.Category_Name = BV.BMS_Desc ,Last_Updated_Time=GETDATE(),Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (Ref_Category_Key,Category_Name,Is_Active,Inserted_By,Inserted_On)
			  VALUES (BV.BMS_Key, BV.BMS_Desc,'Y',@User_Code,GETDATE());	  
			--SELECT * FROM  [Category]  ORDER BY 1 desc			
			
	END
	-------------------------Start ENTITY or Licensee Master Logic---------------------
	IF(UPPER(@Module_Name) = 'ENTITY')
	BEGIN 
	INSERT INTO #BMS_XML (BMS_Key,BMS_Desc)		
	SELECT DISTINCT   COL2,COL3 FROM BMS_Masters_Import WHERE UPPER(COL1) = 'ENTITY'		
	-------------------------Insert Or Update Logic For ENTITY or Licensee Master------
	 MERGE Entity C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.Ref_Entity_Key
			WHEN MATCHED  THEN
			  UPDATE SET C.Entity_Name = BV.BMS_Desc ,Last_Updated_Time=GETDATE(),Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (Ref_Entity_Key,Entity_Name,Is_Active,Inserted_By,Inserted_On)
			  VALUES (BV.BMS_Key, BV.BMS_Desc,'Y',@User_Code,GETDATE());	  
			--SELECT * FROM  [Entity]  ORDER BY 1 desc						
	END
	-------------------------Start Right Rule Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'RIGHT_RULE')
	BEGIN 
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc)		
		SELECT DISTINCT   COL2,COL3 FROM BMS_Masters_Import WHERE UPPER(COL1) = 'RIGHT_RULE'		
	-------------------------Insert Or Update Logic For ENTITY or Licensee Master------
	 MERGE Right_Rule C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.Ref_Right_Rule_Key
			WHEN MATCHED  THEN
			  UPDATE SET C.Right_Rule_Name = BV.BMS_Desc ,Last_Updated_Time=GETDATE(),Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (Ref_Right_Rule_Key,Right_Rule_Name,Is_Active,Inserted_By,Inserted_On)
			  VALUES (BV.BMS_Key, BV.BMS_Desc,'Y',@User_Code,GETDATE());	  
			--SELECT * FROM  [Entity]  ORDER BY 1 desc						
	END	
	-------------------------Start BV MEDIA CATEGORY Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'BMS_MEDIACATEGORY')
	BEGIN 
		PRINT 'BMS_MEDIACATEGORY'
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc,Code,IsArchived ,ForeignId)		
		SELECT DISTINCT   COL2,COL3,COL4,		
		 CASE 
					WHEN RTRIM(LTRIM(UPPER(COL5))) = 'TRUE'
					THEN 'Y'
					ELSE 'N' END AS ISArc
		,COL6 FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_MEDIACATEGORY'				
		
	-------------------------Insert Or Update Logic For BV MEDIA CATEGORY Master------
	 MERGE BMS_MediaCategoy C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET 
			  C.BMS_Description = BV.BMS_Desc,
			  C.Code=BV.Code,
			  C.IsArchived = BV.IsArchived,
			  C.ForeignId = BV.ForeignId,
			  Last_Updated_Time=GETDATE(),
			  Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (BMS_Key,BMS_Description,Code,IsArchived ,ForeignId,Inserted_By,Inserted_On)
			  VALUES 
			  (
				  BV.BMS_Key, BV.BMS_Desc,BV.Code,BV.IsArchived,BV.ForeignId, @User_Code,GETDATE()
			  );	  	
	END	
	-------------------------Start BV MEDIA CATEGORY Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'BMS_MEDIAFRAMERATES')
	BEGIN 
		PRINT 'BMS_MediaFrameRates'
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc,Code,IsArchived)		
		SELECT DISTINCT   COL2,COL3,COL4,		
		 CASE 
					WHEN RTRIM(LTRIM(UPPER(COL5))) = 'TRUE'
					THEN 'Y'
					ELSE 'N' END AS ISArc
		FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_MEDIAFRAMERATES'		
	-------------------------Insert Or Update Logic For BV MEDIA CATEGORY Master------
	 MERGE BMS_MEDIAFRAMERATES C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET 
			  C.BMS_Description = BV.BMS_Desc,
			  C.Code = BV.Code,
			  C.IsArchived = BV.IsArchived,			  
			  Last_Updated_Time=GETDATE(),
			  Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (BMS_Key,BMS_Description,Code,IsArchived ,Inserted_By,Inserted_On)
			  VALUES 
			  (
				  BV.BMS_Key, BV.BMS_Desc,BV.Code,BV.IsArchived,@User_Code,GETDATE()
			  );	  	
	END	
	-------------------------Start BV MEDIA CATEGORY Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'BMS_PROGRAMCATEGORY')
	BEGIN 
		PRINT 'BMS_PROGRAMCATEGORY'
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc,Code,IsArchived ,ForeignId)		
		SELECT DISTINCT   COL2,COL3,COL4,		
		 CASE 
					WHEN RTRIM(LTRIM(UPPER(COL5))) = 'TRUE'
					THEN 'Y'
					ELSE 'N' END AS ISArc
		,COL6 FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_PROGRAMCATEGORY'		
	-------------------------Insert Or Update Logic For BV MEDIA CATEGORY Master------
	 MERGE BMS_ProgramCategory C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET 
			  C.BMS_Description = BV.BMS_Desc,
			  --C.Code = BV.Code,
			  C.IsArchived = BV.IsArchived,			  
			  C.ForeignId = BV.ForeignId,
			  Last_Updated_Time=GETDATE(),
			  Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (BMS_Key,BMS_Description,IsArchived ,ForeignId,Inserted_By,Inserted_On)
			  VALUES 
			  (
				  BV.BMS_Key, BV.BMS_Desc,BV.IsArchived,BV.ForeignId, @User_Code,GETDATE()
			  );	  	
	END	
	-------------------------Start BV MEDIA CATEGORY Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'BMS_STATION')
	BEGIN 
		PRINT 'BMS_Station'
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc,IsArchived ,ForeignId)		
		SELECT DISTINCT   COL2,COL3,		
		 CASE 
					WHEN RTRIM(LTRIM(UPPER(COL4))) = 'TRUE'
					THEN 'Y'
					ELSE 'N' END AS ISArc
		,COL5 FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_STATION'		
	-------------------------Insert Or Update Logic For BV MEDIA CATEGORY Master------
	 MERGE BMS_Station C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET 
			  C.BMS_Description = BV.BMS_Desc,
			  C.IsArchived = BV.IsArchived,
			  C.ForeignId = BV.ForeignId,
			  Last_Updated_Time=GETDATE(),
			  Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (BMS_Key,BMS_Description,IsArchived ,ForeignId,Inserted_By,Inserted_On)
			  VALUES 
			  (
				  BV.BMS_Key, BV.BMS_Desc,BV.IsArchived,BV.ForeignId, @User_Code,GETDATE()
			  );	  	
	END	
	
	-------------------------Start BV SYSLOOKUP Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'BMS_SYSLOOKUP')
	BEGIN 
	CREATE TABLE #Temp_BMS_SysLookup
	(		
		BMS_Key INT,
		BMS_Description NVARCHAR(80),
		Code VARCHAR(20),
		SysLookupClassId INT
		
	)	
	PRINT ' BMS_SYSLookups'
	INSERT INTO #Temp_BMS_SysLookup (BMS_Key,BMS_Description,Code,SysLookupClassId)		
	SELECT DISTINCT   COL2,COL4,COL5,				 
	COL3 FROM BMS_Masters_Import 
	WHERE UPPER(COL1) = 'BMS_SYSLOOKUP'				
		
	-------------------------Insert Or Update Logic For BV SYSLOOKUP Master------
	 MERGE BMS_SYSLOOKUP C 
	  USING  #Temp_BMS_SysLookup BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET 
			  C.BMS_Description = BV.BMS_Description,
			  C.Code=BV.Code,		
			  C.SysLookupClassId = BV.SysLookupClassId,	  			  
			  Last_Updated_Time=GETDATE(),
			  Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (BMS_Key,BMS_Description,Code,SysLookupClassId,Inserted_By,Inserted_On)
			  VALUES 
			  (
				  BV.BMS_Key, BV.BMS_Description,BV.Code,BV.SysLookupClassId, @User_Code,GETDATE()
			  );	  	
	END	

	
	-------------------------Start BMS SYSLOOKUPCLASSE Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'BMS_SYSLOOKUPCLASS')
	BEGIN 	
		PRINT 'BMS_SYSLOOKUPCLASS'
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc)		
		SELECT DISTINCT   COL2,COL3
		FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_SYSLOOKUPCLASS'				

	-------------------------Insert Or Update Logic For BMS_SysLookupClass Master------
	 MERGE BMS_SysLookupClass C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET 
			  C.BMS_Description = BV.BMS_Desc,			 
			  Last_Updated_Time=GETDATE(),
			  Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (BMS_Key,BMS_Description,Inserted_By,Inserted_On)
			  VALUES 
			  (
				  BV.BMS_Key, BV.BMS_Desc,@User_Code,GETDATE()
			  );	  			
	END	
	-------------------------Start BV BMS_TRAFFICCATEGORY Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'BMS_TRAFFICCATEGORY')
	BEGIN 
		PRINT 'BMS_TrafficCategory'
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc,IsArchived ,ForeignId)		
		SELECT DISTINCT   COL2,COL3,		
		 CASE 
					WHEN RTRIM(LTRIM(UPPER(COL4))) = 'TRUE'
					THEN 'Y'
					ELSE 'N' END AS ISArc
		,COL5 FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_TRAFFICCATEGORY'		
	-------------------------Insert Or Update Logic For BMS_TrafficCategory Master------
	 MERGE BMS_TrafficCategory C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET 
			  C.BMS_Description = BV.BMS_Desc,
			  C.IsArchived = BV.IsArchived,
			  C.ForeignId = BV.ForeignId,
			  Last_Updated_Time=GETDATE(),
			  Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (BMS_Key,BMS_Description,IsArchived ,ForeignId,Inserted_By,Inserted_On)
			  VALUES 
			  (
				  BV.BMS_Key, BV.BMS_Desc,BV.IsArchived,BV.ForeignId, @User_Code,GETDATE()
			  );	  	
	END	
	-------------------------Start BV BMS_VersionType Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'BMS_VERSIONTYPE')
	BEGIN 
		PRINT 'BV VersionType'
		INSERT INTO #BMS_XML (BMS_Key,BMS_Desc,Code,IsArchived ,ForeignId)		
		SELECT DISTINCT   COL2,COL3,COL4,		
		 CASE 
					WHEN RTRIM(LTRIM(UPPER(COL5))) = 'TRUE'
					THEN 'Y'
					ELSE 'N' END AS IsArchived
		,COL6 FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_VERSIONTYPE'		
	-------------------------Insert Or Update Logic For BV MEDIA CATEGORY Master------
	 MERGE BMS_VersionType C 
	  USING  #BMS_XML BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET 
			  C.BMS_Description = BV.BMS_Desc,
			  C.IsArchived = BV.IsArchived,
			  C.Code = BV.Code,
			  C.ForeignId = BV.ForeignId,
			  Last_Updated_Time=GETDATE(),
			  Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (BMS_Key,BMS_Description,Code,IsArchived ,ForeignId,Inserted_By,Inserted_On)
			  VALUES 
			  (
				  BV.BMS_Key, BV.BMS_Desc,BV.Code,BV.IsArchived,BV.ForeignId, @User_Code,GETDATE()
			  );	  	
	END		
	-------------------------Start BV MEDIA Type Master Logic---------------------	
	IF(UPPER(@Module_Name) = 'BMS_MEDIA_TYPE')
	BEGIN 		
		PRINT 'BV Media Type'
		CREATE TABLE #Temp_BMS_Media_Type_Data
		(			
			BMS_Key INT,
			Code VARCHAR(6)	,
			BMS_Description NVARCHAR(40),
			MediaFrameRateId NVARCHAR(1000),
			MediaClassSLUId NVARCHAR(1000),
			IsArchived Char(1),
			ForeignId VARCHAR(40)			
		)
		INSERT INTO #Temp_BMS_Media_Type_Data(BMS_Key,Code,MediaFrameRateId,MediaClassSLUId ,BMS_Description,IsArchived,ForeignId)		
		SELECT DISTINCT   COL2,COL6,COL3,COL4,COL5,		
		 CASE 
					WHEN RTRIM(LTRIM(UPPER(COL7))) = 'TRUE'
					THEN 'Y'
					ELSE 'N' END AS IsArchived
		,COL8 FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_MEDIA_TYPE'		
	-------------------------Insert Or Update Logic For BV MEDIA CATEGORY Master------
	 MERGE BMS_Media_Type C 
	  USING  #Temp_BMS_Media_Type_Data BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET 
			  C.BMS_Description = BV.BMS_Description,
			  MediaFrameRateId=BV.MediaFrameRateId,
			  MediaClassSLUId = BV.MediaClassSLUId,
			  C.IsArchived = BV.IsArchived,			  
			  C.ForeignId = BV.ForeignId,
			  Last_Updated_Time=GETDATE(),
			  Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT (BMS_Key,BMS_Description,Code,MediaFrameRateId ,MediaClassSLUId,IsArchived,ForeignId,Inserted_By,Inserted_On)
			  VALUES 
			  (
				  BV.BMS_Key, BV.BMS_Description,BV.Code,BV.MediaFrameRateId ,BV.MediaClassSLUId ,BV.IsArchived,BV.ForeignId, @User_Code,GETDATE()
			  );	  	
	END		
	IF(UPPER(@Module_Name) = 'BMS_PAYEE')
	BEGIN 
	CREATE TABLE #Temp_BMS_Payee_Data
	(		
		BMS_Key INT,
		Name NVARCHAR(80),
		AddressLine1 NVARCHAR(80),
		AddressLine2 NVARCHAR(80),
		AddressLine3 NVARCHAR(80),
		
		City NVARCHAR(40),
		Province NVARCHAR(40),
		Country NVARCHAR(40),
		PostalCode NVARCHAR(10),--COL10
		
		Phone VARCHAR(20),
		Fax VARCHAR(20),
		Email NVARCHAR(252),
		ExternalId VARCHAR(20),	
		UpdateDateTime VARCHAR(30),
		UpdateUserId VARCHAR(20),	
		IsArchived CHAR(1),
		ForeignId VARCHAR(40)
	)	
	INSERT INTO #Temp_BMS_Payee_Data 
	(BMS_Key ,Name
	 ,AddressLine1,AddressLine2,AddressLine3 
	 ,City ,Province ,Country
	 ,PostalCode
	 ,Phone,Fax ,Email
	 ,ExternalId,UpdateDateTime,UpdateUserId
	 ,IsArchived,ForeignId)
		SELECT   COL2,COL3
			,COL4,COL5,COL6
			,COL7,COL8,COL9
			,COL10
			,COL11,COL12,COL13
			,COL14,COL13,COL14
			,CASE 
						WHEN RTRIM(LTRIM(UPPER(COL13))) = 'TRUE'
						THEN 'Y'
						ELSE 'N' END AS IsArchived
		,COL14		
		FROM BMS_Masters_Import WHERE UPPER(COL1) = 'BMS_PAYEE'		
	-------------------------Insert Or Update Logic For ENTITY or Licensee Master------
	 MERGE BMS_Payee C 
	  USING  #Temp_BMS_Payee_Data BV
		  ON BV.BMS_Key = C.BMS_Key
			WHEN MATCHED  THEN
			  UPDATE SET C.Name = BV.Name 
			  ,C.AddressLine1 = BV.AddressLine1
			  ,C.AddressLine2 = BV.AddressLine2
			  ,C.AddressLine3 = BV.AddressLine3
			  ,C.City=BV.City			  
			  ,C.Province = BV.Province			  
			  ,C.Country=BV.Country			  
			  ,C.PostalCode = BV.PostalCode
			  ,C.Phone = BV.Phone
			  ,C.Fax=BV.Fax			  
			  ,C.Email=BV.Email
			  ,UpdateDateTime=BV.UpdateDateTime
			  ,UpdateUserId=BV.UpdateUserId
			  ,Last_Updated_Time=GETDATE()
			  ,Last_Action_By=@User_Code 
			WHEN NOT MATCHED BY TARGET THEN	
			  INSERT 
			  (
					BMS_Key ,Name
				 ,AddressLine1,AddressLine2,AddressLine3 
				 ,City ,Province ,Country
				 ,PostalCode
				 ,Phone,Fax ,Email
				 ,ExternalId,UpdateDateTime,UpdateUserId
				 ,IsArchived,ForeignId
				 ,[Inserted_By] 
				,[Inserted_On] 
			  )
			  VALUES 
			  (
				BMS_Key ,Name
				 ,AddressLine1,AddressLine2,AddressLine3 
				 ,City ,Province ,Country
				 ,PostalCode
				 ,Phone,Fax ,Email
				 ,ExternalId,UpdateDateTime,UpdateUserId
				 ,IsArchived,ForeignId
				 ,@User_Code
				 ,GETDATE()
			  );	  
	END
	
	DELETE FROM BMS_Masters_Import
	WHERE UPPER(COL1) = UPPER(@Module_Name)
	
	-------------------------SELECT Temp Tables-----
	--SELECT * FROM #BMS_XML 	
	--SELECT * FROM Channel ORDER BY 1 DESC 
	--SELECT * FROM [Language] ORDER BY 1 DESC 	
	--SELECT * FROM Entity ORDER BY 1 DESC 
	--SELECT * FROM RIGHT_RULE ORDER BY 1 DESC 
	--SELECT * FROM BMS_MediaCategoy ORDER BY 1 DESC 
	--SELECT * FROM BMS_MEDIAFRAMERATES ORDER BY 1 DESC 
	--SELECT * FROM BMS_STATION ORDER BY 1 DESC 
	--SELECT * FROM BMS_ProgramCategory ORDER BY 1 DESC 
	--SELECT * FROM BMS_SYSLOOKUP--  WHERE BMS_Key= 12106
	--ORDER BY 1 DESC 
	--SELECT * FROM BMS_SysLookupClass ORDER BY 1 DESC 
	--SELECT * FROM BMS_TRAFFICCATEGORY ORDER BY 1 DESC 
	---SELECT * FROM BMS_VersionType ORDER BY 1 DESC 	
	--SELECT * FROM BMS_Media_Type ORDER BY 1 DESC 	
	-------------------------DROP Temp Tables-----	
		DROP TABLE #BMS_XML
		IF OBJECT_ID('tempdb..#BMS_Licensor') IS NOT NULL
		BEGIN
			DROP TABLE #BMS_Licensor
		END	
		IF OBJECT_ID('tempdb..#Temp_BMS_SysLookup') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_BMS_SysLookup
		END	
		IF OBJECT_ID('tempdb..#Temp_BMS_Payee_Data') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_BMS_Payee_Data
		END	
		
	-------------------------END------------------------------	
	END
	
	UPDATE BMS_Log SET
    Response_Time = GETDATE(),
    Response_Xml = CASE WHEN UPPER(@Is_Error) = 'Y' THEN '' ELSE @XML END,
    Record_Status = CASE WHEN UPPER(@Is_Error) = 'Y' THEN 'E' ELSE 'D' END,
    Error_Description = @Error_Details
    WHERE  BMS_Log_Code = @BMS_Log_Code

END


--EXEC [dbo].[USP_BMS_Insert_Update_Masters] 'CHANNEL',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] 'LANGUAGE',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] 'ASSETRIGHTRULE',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] '', 'BMS_MEDIACATEGORY',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] '', 'BMS_MEDIAFRAMERATES',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] '', 'BMS_STATION',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] '', 'BMS_SYSLOOKUP',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] '', 'BMS_SYSLOOKUPCLASS',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] '', 'BMS_TRAFFICCATEGORY',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] '', 'BMS_VERSIONTYPE',143
--EXEC [dbo].[USP_BMS_Insert_Update_Masters] '', 'BMS_Media_Type',143
