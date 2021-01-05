CREATE PROCEDURE [dbo].[USP_Import_SubDeal_Insert]
(
	@UserCode INT
)
AS
BEGIN
	SET NOCOUNT ON

	IF(OBJECT_ID('TEMPDB..#TempImportSubDeal') IS NOT NULL)
		DROP TABLE #TempImportSubDeal

	IF(OBJECT_ID('TEMPDB..#Temp_Talent') IS NOT NULL)
		DROP TABLE #Temp_Talent

	IF(OBJECT_ID('TEMPDB..#Temp_Title_Talent') IS NOT NULL)
		DROP TABLE #Temp_Title_Talent
		
	IF(OBJECT_ID('TEMPDB..#ErrorForRights') IS NOT NULL)
		DROP TABLE #ErrorForRights

	IF(OBJECT_ID('TEMPDB..#TempErrorDetails') IS NOT NULL)
		DROP TABLE #TempErrorDetails

	IF(OBJECT_ID('TEMPDB..#Temp_Test_Talent') IS NOT NULL)
		DROP TABLE #Temp_Test_Talent

	CREATE TABLE #TempErrorDetails
	(
		[RowNo]					INT IDENTITY(1,1),
		[DealDesc]              NVARCHAR (MAX) NULL,
		[AgreementDate]         DATETIME       NULL,
		[ModeOfAcquisition]     NVARCHAR (100) NULL,
		[MasterDealAgreementNo] VARCHAR  (20)  NULL,
		[MasterDealTitle]       NVARCHAR (MAX) NULL,
		[YearOfDefinition]      CHAR	 (2)   NULL,
		[DealFor]               NVARCHAR (500) NULL,
		[BusinessUnit]          NVARCHAR (500) NULL,
		[Talent]                NVARCHAR (MAX) NULL,
		[Remarks]               NVARCHAR (MAX) NULL,
		[Error_Details]         NVARCHAR (MAX) NULL
	)

	CREATE TABLE #ErrorForRights (
	Rights_Error NVARCHAR(MAX)  NULL
	)

	SELECT ROW_NUMBER() OVER (ORDER BY [MasterDealAgreementNo]) AS RowNo, [ImportSubDeal_Code],  [DealDesc], [AgreementDate], [ModeOfAcquisition], [MasterDealAgreementNo],
	[MasterDealTitle], [YearOfDefinition], [DealFor], [BusinessUnit],[Talent],[Remarks], [IsProcessed] 
	INTO #TempImportSubDeal 
	FROM  ImportSubDeal
	WHERE  [IsProcessed] = 'I'

	DECLARE @RowNo INT = 0, @RowCounter INT = 0 ,@Current_Status CHAR(1) = ''
	SELECT TOP 1 @RowNo = RowNo FROM #TempImportSubDeal WHERE IsProcessed = 'I'

	BEGIN TRY 
		BEGIN TRANSACTION 
		PRINT '  Transaction started'
		WHILE(@RowNo > 0)
		BEGIN
	

					IF(OBJECT_ID('TEMPDB..#Temp_Talent') IS NOT NULL)
						DROP TABLE #Temp_Talent

					SET @RowCounter =(@RowCounter + 1)

					PRINT '  Declare all variable which will be needed'
					DECLARE @isErrorInRow CHAR(1) = 'N' ,  @errorMessage NVARCHAR(MAX) = ''

					DECLARE @ImportSubDeal_Code INT = 0, @Deal_Type_Code_Sub_Deal INT = 0, @Deal_Type_Name VARCHAR(MAX) = '',  @Talent_Name NVARCHAR(MAX) = '',
					@Remarks NVARCHAR(MAX) = '',@YearOfDefinition CHAR(2) = '', @DealDesc NVARCHAR(MAX) = '', @AgreementDate DATETIME = NULL, 
					@MasterDealAgreementNo VARCHAR(20) = '', @MasterDealTitle NVARCHAR(MAX) = '', @ModeOfAcquisition  NVARCHAR (100) = '',
					@BusinessUnit  NVARCHAR (500) = '' , @Acq_Deal_Code INT = 0 , @Title_Name NVARCHAR(MAX) = '', @Business_Unit_Code INT = 0 , @RoleCode INT = 0,
					@MasterDealTitleCode INT = 0,@Master_Deal_Movie_Code_ToLink INT = 0 ,  @Vendor_Code INT = 0

					DECLARE @Title_Code INT = 0 , @Deal_Type_Code INT = 0, @Acq_Deal_Code_Sub_Deal INT = 0 ,@Agreement_No_Sub_Deal VARCHAR(200) = ''

					PRINT '  Get the current particular row in temp varaible'
					SELECT @ImportSubDeal_Code = ImportSubDeal_Code, @Deal_Type_Name = DealFor, @Talent_Name = Talent,  @Remarks = Remarks,
					@YearOfDefinition = YearOfDefinition, @DealDesc = DealDesc, @AgreementDate = AgreementDate, @MasterDealAgreementNo = MasterDealAgreementNo,
					 @MasterDealTitle = MasterDealTitle ,@ModeOfAcquisition = ModeOfAcquisition,@BusinessUnit = BusinessUnit
					FROM #TempImportSubDeal WHERE IsProcessed = 'I' AND RowNo = @RowNo

					----Status to 'W'
					UPDATE ImportSubDeal  SET IsProcessed = 'P' WHERE ImportSubDeal_Code = @ImportSubDeal_Code

					SELECT @RoleCode = ISNULL(Role_Code,0) FROM Role where Role_Name = @ModeOfAcquisition AND Role_Type = 'A'
					SELECT @Business_Unit_Code = ISNULL(Business_Unit_Code,0) FROM Business_Unit WHERE Business_Unit_Name = @BusinessUnit AND Is_Active = 'Y'
					SELECT @Deal_Type_Code_Sub_Deal =  ISNULL(Deal_Type_Code,0) FROM Deal_Type WHERE Deal_Type_Name = @Deal_Type_Name AND Is_Active = 'Y'
					SELECT @MasterDealTitleCode = ISNULL(Title_Code,0) FROM Title where Title_name = @MasterDealTitle AND Is_Active = 'Y'
					SELECT ROW_NUMBER() OVER (ORDER BY talent_code) AS Id, S.Talent_Code,S.Talent_Name ,t.Title_Code , t.Title_Name
							INTO #Temp_Talent
							FROM fn_Split_withdelemiter(@Talent_Name, ',') AS C 
							INNER JOIN Talent AS S ON S.Talent_Name = C.number
							INNER JOIN Title T ON T.Reference_Key  = s.Talent_Code
							where T.Reference_Flag= 'T' and T.deal_type_code = @Deal_Type_Code_Sub_Deal AND T.Is_Active = 'Y'
					SELECT 	@Acq_Deal_Code = Acq_Deal_Code , @Vendor_Code = Vendor_Code, @Deal_Type_Code =  Deal_Type_Code FROM Acq_Deal 															
							WHERE Agreement_No = @MasterDealAgreementNo AND Is_Active = 'Y'																							
					SELECT @Title_Code = T.Title_Code, @Master_Deal_Movie_Code_ToLink = ADM.Acq_Deal_Movie_Code , @Title_Name = T.Title_Name
							FROM Acq_Deal_Movie ADM INNER JOIN Title T on T.Title_Code = ADM.Title_Code 
							WHERE ADM.Acq_Deal_Code = @Acq_Deal_Code AND T.Title_Name = @MasterDealTitle	


					PRINT '  Insert in [Acq_Deal] table'
					INSERT INTO [Acq_Deal]
					([Agreement_No],
					[Version],[Agreement_Date],[Deal_Desc],[Deal_Type_Code],[Year_Type],[Entity_Code],[Is_Master_Deal],[Category_Code],[Vendor_Code],
					[Vendor_Contacts_Code],[Currency_Code],[Exchange_Rate],[Ref_No],[Attach_Workflow],[Deal_Workflow_Status],[Parent_Deal_Code],[Work_Flow_Code],
					[Amendment_Date],[Is_Released],[Release_On],[Release_By],[Is_Completed],[Is_Active],[Content_Type],[Payment_Terms_Conditions],[Status],
					[Is_Auto_Generated],
					[Is_Migrated],[Cost_Center_Id],[Master_Deal_Movie_Code_ToLink],[BudgetWise_Costing_Applicable],[Validate_CostWith_Budget],[Deal_Tag_Code],
					[Business_Unit_Code],[Ref_BMS_Code],
					[Remarks],[Rights_Remarks],[Payment_Remarks],[Deal_Complete_Flag],
					[Inserted_By],[Inserted_On],[Last_Updated_Time],[Last_Action_By],[Lock_Time],[Role_Code],[Channel_Cluster_Code])
					SELECT 
					[dbo].[UFN_Auto_Genrate_Agreement_No]('A', @AgreementDate, ISNULL(@Master_Deal_Movie_Code_ToLink, 0)) [Agreement_No],
					'0001',@AgreementDate,@DealDesc,@Deal_Type_Code_Sub_Deal,@YearOfDefinition,Entity_Code,'N',Category_Code,@Vendor_Code,
					Vendor_Contacts_Code,Currency_Code,Exchange_Rate,Ref_No,Attach_Workflow,'N',Parent_Deal_Code,Work_Flow_Code,
					Amendment_Date,Is_Released,Release_On,Release_By,Is_Completed,'Y',Content_Type,Payment_Terms_Conditions,'O',
					Is_Auto_Generated,
					Is_Migrated,Cost_Center_Id,@Master_Deal_Movie_Code_ToLink,BudgetWise_Costing_Applicable,Validate_CostWith_Budget,Deal_Tag_Code,
					Business_Unit_Code,NULL,--@Ref_BMS_Code
					@Remarks,Rights_Remarks,Payment_Remarks,(Select Parameter_Value From System_Parameter_New Where Parameter_Name = 'Deal_Complete_Flag'),
					@UserCode,GETDATE(),GETDATE(),@UserCode,NULL,@RoleCode,Channel_Cluster_Code
					FROM Acq_deal
					WHERE Acq_Deal_Code = @Acq_Deal_Code

					SELECT @Acq_Deal_Code_Sub_Deal =  Acq_Deal_Code, @Agreement_No_Sub_Deal = Agreement_No
					FROM Acq_Deal WHERE Acq_Deal_Code = SCOPE_IDENTITY()
					-------------------------------------------------------------
					PRINT ' Insert into [Acq_Deal_Licensor] table'
					INSERT INTO  [Acq_Deal_Licensor] (Acq_Deal_Code, Vendor_Code)
					SELECT @Acq_Deal_Code_Sub_Deal , @Vendor_Code
					-------------------------------------------------------------
					PRINT ' Insert into [Acq_Deal_Movie] table'
					INSERT INTO [Acq_Deal_Movie]
					(Acq_Deal_Code, Title_Code,  No_Of_Episodes, Is_Closed, Title_Type , Episode_Starts_From , Episode_End_To, 
					Inserted_By, Inserted_On, Last_UpDated_Time , Last_Action_By)
					SELECT
					@Acq_Deal_Code_Sub_Deal, Title_Code,
					CASE WHEN @Deal_Type_Code = 1 THEN 1 ELSE NULL END AS No_Of_Episodes,
					'N','N',1,1,@UserCode,GETDATE(),GETDATE(),@UserCode
					FROM #Temp_Talent		
					-------------------------------------------------------------
					PRINT 'Insert the Right For Sub_Deal'

					DECLARE @Comma_Sep_TitleCode NVARCHAR(MAX) = '' , @errorCopy_Right_For_Sub_Deal NVARCHAR(MAX) = ''
					SELECT  @Comma_Sep_TitleCode = STUFF((SELECT Distinct ',' + CAST(Title_Code AS NVARCHAR)  FROM #Temp_Talent FOR XML PATH('')),1,1,'') 

					INSERT INTO #ErrorForRights
					EXEC USP_Acq_Copy_Right_For_Sub_Deal @Acq_Deal_Code_Sub_Deal, @Master_Deal_Movie_Code_ToLink, @UserCode, @Comma_Sep_TitleCode

					SELECT top 1 @errorCopy_Right_For_Sub_Deal = Rights_Error FROM #ErrorForRights

					TRUNCATE TABLE #ErrorForRights

					IF (@errorCopy_Right_For_Sub_Deal <> '')  
					BEGIN
						--Status to 'E'
						UPDATE ImportSubDeal  SET IsProcessed = 'E' WHERE ImportSubDeal_Code = @ImportSubDeal_Code
						SET @errormessage = @errorCopy_Right_For_Sub_Deal	

						INSERT INTO #TempErrorDetails
						([DealDesc],[AgreementDate],[ModeOfAcquisition],[MasterDealAgreementNo],[MasterDealTitle],[YearOfDefinition],[DealFor],
						[BusinessUnit],[Talent],[Remarks],[Error_Details])  
						SELECT DealDesc,AgreementDate,ModeOfAcquisition,MasterDealAgreementNo,MasterDealTitle,YearOfDefinition,DealFor,
						BusinessUnit,Talent,Remarks,@errormessage
						FROM #TempImportSubDeal WHERE IsProcessed = 'I' AND RowNo = @RowNo  
						  
					END
					ELSE
					BEGIN
						--Status to 'R'
						UPDATE ImportSubDeal  SET IsProcessed = 'R',  Acq_Deal_Code = @Acq_Deal_Code_Sub_Deal WHERE ImportSubDeal_Code = @ImportSubDeal_Code
					END


			   UPDATE #TempImportSubDeal SET IsProcessed  = 'R' WHERE IsProcessed = 'I' AND RowNo = @RowNo  
			   SELECT @RowNo = 0  
			   SELECT TOP 1 @RowNo = RowNo FROM #TempImportSubDeal WHERE IsProcessed = 'I'  
					-------------------------------------------------------------
		END
	PRINT '  Transaction Commited'
	COMMIT
		SELECT @Current_Status = 'Y'
		SELECT @Current_Status AS [Status] , * FROM #TempErrorDetails
	END TRY
	BEGIN CATCH  
	ROLLBACK
		PRINT '  Transaction Rollbacked'
		SELECT @Current_Status = 'E',@errorMessage = ERROR_MESSAGE()
		SELECT @Current_Status AS Status ,@errorMessage AS [Error_Message]
	END CATCH 

	IF OBJECT_ID('tempdb..#ErrorForRights') IS NOT NULL DROP TABLE #ErrorForRights
	IF OBJECT_ID('tempdb..#Temp_Talent') IS NOT NULL DROP TABLE #Temp_Talent
	IF OBJECT_ID('tempdb..#Temp_Test_Talent') IS NOT NULL DROP TABLE #Temp_Test_Talent
	IF OBJECT_ID('tempdb..#Temp_Title_Talent') IS NOT NULL DROP TABLE #Temp_Title_Talent
	IF OBJECT_ID('tempdb..#TempErrorDetails') IS NOT NULL DROP TABLE #TempErrorDetails
	IF OBJECT_ID('tempdb..#TempImportSubDeal') IS NOT NULL DROP TABLE #TempImportSubDeal
END