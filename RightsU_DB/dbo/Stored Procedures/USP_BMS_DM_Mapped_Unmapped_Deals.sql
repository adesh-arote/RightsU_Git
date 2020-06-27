ALTER PROCEDURE [dbo].[USP_BMS_DM_Mapped_Unmapped_Deals]
	@Acq_Deal_Code INT,
	@BMS_Asset_Ref_Key INT,
	@Title_Name VARCHAR(1000)  
AS
BEGIN
SET @Acq_Deal_Code = 0
/*
TRUNCATE TABLE [DM_BMS_Mapped_UnMapped_Deal] 
TRUNCATE TABLE [DM_BMS_Mapped_UnMapped_Content] 
TRUNCATE TABLE [DM_BMS_Mapped_UnMapped_Content_Rights] 
EXEC [dbo].[USP_BMS_DM_Mapped_Unmapped_Deals] 0,0,''
--SELECT * FROM DM_BMS_Mapped_UnMapped_Content  WHERE DCO_DEAL_ID = 38324536
SELECT Title,Start_Date,End_Date,DCO_Start_Date,DCO_End_Date,IS_MApped,Error_Description,* 
FROM DM_BMS_Mapped_UnMapped_Content
SELECT *
FROM DM_BMS_Mapped_UnMapped_Content_Rights
--WHERE 
--DCO_DEAL_ID = 38324536 
*/
	/********************************DELETE Temp Table if Exists ****************/
IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content') IS NOT NULL
BEGIN
	DROP TABLE #Temp_BMS_Deal_Content
END			
IF OBJECT_ID('tempdb..#Temp_DM_BMS_Deal_Content') IS NOT NULL
BEGIN
	DROP TABLE #Temp_DM_BMS_Deal_Content	
END			
IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content_Rights') IS NOT NULL
BEGIN
DROP TABLE #Temp_BMS_Deal_Content_Rights
END
IF OBJECT_ID('tempdb..#Temp_DM_Deal_Content_Rights') IS NOT NULL
BEGIN
DROP TABLE #Temp_DM_Deal_Content_Rights
END
IF OBJECT_ID('tempdb..#Temp_DM_BMS_Mapped_UnMapped_Deal_Content') IS NOT NULL
BEGIN
DROP TABLE #Temp_DM_BMS_Mapped_UnMapped_Deal_Content
END
IF OBJECT_ID('tempdb..#Temp_DM_BMS_Mapped_Rights') IS NOT NULL
BEGIN
	DROP TABLE #Temp_DM_BMS_Mapped_Rights
END;
IF OBJECT_ID('tempdb..#Temp_Rights_RP_Mismatch') IS NOT NULL
BEGIN
	DROP TABLE #Temp_Rights_RP_Mismatch
END;
IF OBJECT_ID('tempdb..#Temp_Rights_Channel_NOT_IN_BV') IS NOT NULL
BEGIN
	DROP TABLE #Temp_Rights_Channel_NOT_IN_BV
END;


/********************************Cursor On BMS_Deal *************************/
DECLARE @BMS_Deal_Code INT = 0,@Counter_loop INT = 0,@Deal_Type_Code INT = 1
DECLARE BMS_Deal_Cursor CURSOR FOR
SELECT DISTINCT  BD.BMS_Deal_Code 
FROM BMS_Deal BD 
INNER JOIN Acq_Deal AD ON BD.Acq_Deal_Code = AD.Acq_Deal_Code  
INNER JOIN BMS_Deal_Content BDS ON BD.BMS_Deal_Code = BDS.BMS_Deal_Code
INNER JOIN DM_BMS_Deal_Content BDC ON BDC.DCO_ASS_ID = BDS.BMS_Asset_Ref_Key
WHERE
AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
AD.Deal_Type_Code = @Deal_Type_Code --244 Movies
--AND (AD.Acq_Deal_Code = @Acq_Deal_Code OR ISNULL(@Acq_Deal_Code,0) = 0 )
--AND (BDS.BMS_Asset_Ref_Key = @BMS_Asset_Ref_Key OR ISNULL(@BMS_Asset_Ref_Key,0) = 0 )
GROUP BY BD.BMS_Deal_Code  
--HAVING  COUNT(DISTINCT BDS.BMS_Asset_Ref_Key) = COUNT(DISTINCT BDC.DCO_ASS_ID) 
--AND COUNT(DISTINCT BDS.BMS_Deal_Code) = 1 AND COUNT(DISTINCT BDC.DCO_DEA_ID) = 1
ORDER BY BD.BMS_Deal_Code  
OPEN BMS_Deal_Cursor
		FETCH NEXT FROM BMS_Deal_Cursor INTO @BMS_Deal_Code
		WHILE @@FETCH_STATUS = 0
		BEGIN				
			SET  @Counter_loop = @Counter_loop + 1				
/***********************************--Drop Table if Exist************************************************************************************************/
			IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content') IS NOT NULL
			BEGIN				
				DROP TABLE #Temp_BMS_Deal_Content
			END				
			IF OBJECT_ID('tempdb..#Temp_DM_BMS_Deal_Content') IS NOT NULL
			BEGIN				
				DROP TABLE #Temp_DM_BMS_Deal_Content
			END
			IF OBJECT_ID('tempdb..#Temp_BMS_Deal') IS NOT NULL
			BEGIN				
				DROP TABLE #Temp_BMS_Deal
			END
			IF OBJECT_ID('tempdb..#Temp_DM_BMS_Deal') IS NOT NULL
			BEGIN				
				DROP TABLE #Temp_DM_BMS_Deal
			END
			IF OBJECT_ID('tempdb..#Temp_DM_BMS_Mapped_UnMapped_Deal_Content') IS NOT NULL
			BEGIN
			DROP TABLE #Temp_DM_BMS_Mapped_UnMapped_Deal_Content
			END
			IF OBJECT_ID('tempdb..#Temp_BMS_Deal_Content_Rights') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_BMS_Deal_Content_Rights
			END
			IF OBJECT_ID('tempdb..#Temp_DM_Deal_Content_Rights') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_DM_Deal_Content_Rights
			END
			IF OBJECT_ID('tempdb..#Temp_DM_BMS_Mapped_Rights') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_DM_BMS_Mapped_Rights
			END;
			IF OBJECT_ID('tempdb..#Temp_Mapped_Deal_Code') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_Mapped_Deal_Code
			END;
			IF OBJECT_ID('tempdb..#Temp_Rights_RP_Mismatch') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_Rights_RP_Mismatch
			END;
				IF OBJECT_ID('tempdb..#Temp_Rights_Channel_NOT_IN_BV') IS NOT NULL
			BEGIN
				DROP TABLE #Temp_Rights_Channel_NOT_IN_BV
			END;
/***********************************-Delete Records if Exist************************************************************************************************/			
			DELETE FROM DM_BMS_Mapped_UnMapped_Content_Rights 
			WHERE BMS_Deal_Content_Code IN
			(
				SELECT BDC.BMS_Deal_Content_Code FROM BMS_Deal_Content BDC 
				WHERE BDC.BMS_Deal_Code = @BMS_Deal_Code
			)			
			DELETE FROM DM_BMS_Mapped_UnMapped_Content WHERE BMS_Deal_Code = @BMS_Deal_Code
			DELETE FROM DM_BMS_Mapped_UnMapped_Deal WHERE BMS_Deal_Code = @BMS_Deal_Code
/****************Insert into Temp table #Temp_BMS_Deal_Content and #Temp_DM_BMS_Deal_Content from BMS_Deal_Content using BMS_Deal_Code****************/				
				SELECT DISTINCT * 
					INTO #Temp_BMS_Deal_Content
				FROM BMS_Deal_Content BDS 
				WHERE BDS.BMS_Deal_Code = @BMS_Deal_Code				
				AND (BDS.BMS_Asset_Ref_Key = @BMS_Asset_Ref_Key OR ISNULL(@BMS_Asset_Ref_Key,0) = 0 )

				--Insert into Temp table from DM_BMS_Deal_Content using Asset Code
				SELECT DISTINCT DM_BDS.* 
					INTO #Temp_DM_BMS_Deal_Content 
				FROM DM_BMS_Deal_Content DM_BDS 
				INNER JOIN #Temp_BMS_Deal_Content temp_BMS ON temp_BMS.BMS_Asset_Ref_Key=DM_BDS.DCO_Ass_ID
				AND ISNULL(DCO_DEA_ID,'0') <> '0' AND ISNULL(DCO_Ass_ID,'0') <> '0' AND ISNULL(BMS_Asset_Ref_Key,'0') <> '0'	
				--AND
				--(
				--	Convert(varchar,DM_BDS.DCO_DateAvailableFrom,106) BETWEEN Convert(varchar,temp_BMS.Start_Date ,106) AND Convert(varchar,temp_BMS.End_Date ,106)
				--	OR
				--	Convert(varchar,DM_BDS.DCO_DateAvailableTo ,106) BETWEEN Convert(varchar,temp_BMS.Start_Date ,106) AND Convert(varchar,temp_BMS.End_Date  ,106)
				--	OR
				--	Convert(varchar, temp_BMS.Start_Date ,106) BETWEEN Convert(varchar ,DM_BDS.DCO_DateAvailableFrom ,106)  AND Convert(varchar ,DM_BDS.DCO_DateAvailableTo ,106)
				--	OR
				--	Convert(varchar,temp_BMS.End_Date ,106) BETWEEN Convert(varchar,DM_BDS.DCO_DateAvailableFrom ,106)  AND Convert(varchar,DM_BDS.DCO_DateAvailableTo ,106)
				--	OR
				--	DM_BDS.DCO_DateAvailableFrom  IS NULL
				--	OR
				--	DM_BDS.DCO_DateAvailableTo IS NULL
				--)			
/**************Insert into Temp_DM_BMS_Mapped_UnMapped_Deal_Content using Asset Code***********************************************************************************/
				--Insert into Temp_DM_BMS_Mapped_UnMapped_Deal_Content using Asset Code					
					SELECT DISTINCT 
					T1.BMS_Deal_Code,T1.BMS_Deal_Content_Code,T1.BMS_Asset_Code,T1.BMS_Asset_Ref_Key,T1.Title,
					T1.[Start_Date],T1.End_Date,T2.DCO_ID,T2.DCO_Ass_ID AS DCO_Asset_ID,
					CAST(T2.DCO_DateAvailableFrom AS VARCHAR) AS DCO_Start_Date,
					CAST(T2.DCO_DateAvailableTo AS VARCHAR) AS DCO_End_Date,
					T2.DCO_DEA_ID,
					'X' AS IS_Mapped,
					'X' AS IS_Error,
					'' AS [Error_Description],					
					'X' AS IS_Deleted	
						INTO #Temp_DM_BMS_Mapped_UnMapped_Deal_Content	--Temp Table
					FROM #Temp_BMS_Deal_Content  T1 
					INNER JOIN #Temp_DM_BMS_Deal_Content T2 ON T1.BMS_Asset_Ref_Key= T2.DCO_Ass_ID
					
					--Alter temp table 
					ALTER TABLE #Temp_DM_BMS_Mapped_UnMapped_Deal_Content ALTER COLUMN [Error_Description]  VARCHAR (MAX) NULL
					/*
					SELECT 'sagar_BMS_Content',* FROM #Temp_BMS_Deal_Content				
					SELECT 'sagar_DM_BMS_Content',* FROM #Temp_DM_BMS_Deal_Content				
					*/
	/*******************************************UPDATE DM_BMS_Mapped_UnMapped_Content****************************************************************/
					--Set Error_Description 	
					--UPDATE DM_BMS_Mapped_UnMapped_Content SET Error_Description = '',[Request_Time] =GETDATE() 
					--WHERE BMS_Deal_Code = @BMS_Deal_Code
					--AND (BMS_Asset_Ref_Key = @BMS_Asset_Ref_Key OR ISNULL(@BMS_Asset_Ref_Key,0) = 0 )

					--Update Mapped Records
					UPDATE #Temp_DM_BMS_Mapped_UnMapped_Deal_Content SET IS_Mapped='Y', IS_Error = 'N',IS_Deleted = 'N',
															Error_Description = '' 
					WHERE BMS_Asset_Ref_Key= DCO_Asset_ID 
					AND CAST([Start_Date] AS DATE) = CAST(DCO_Start_Date AS DATE) 
					AND CAST([End_Date] AS DATE) = CAST(DCO_End_Date AS DATE)
					AND ISNULL([Start_Date],'') <> '' AND ISNULL([End_Date],'') <> ''
					AND ISNULL(DCO_End_Date,'') <> '' AND ISNULL(DCO_End_Date,'') <> ''
					/****************************************Content RP Mismatch**********************************/				
					UPDATE #Temp_DM_BMS_Mapped_UnMapped_Deal_Content SET IS_Mapped='N', IS_Error = 'Y',IS_Deleted = 'N',
						Error_Description =
							CASE 
								WHEN (CAST([Start_Date] AS DATE) <> CAST(DCO_Start_Date AS DATE) AND CAST([End_Date] AS DATE) = CAST(DCO_End_Date AS DATE))
									THEN ' Content Start Date Mismatch'
								WHEN (CAST([Start_Date] AS DATE) = CAST(DCO_Start_Date AS DATE) AND CAST([End_Date] AS DATE) <> CAST(DCO_End_Date AS DATE))
									THEN ' Content End Date Mismatch'
								WHEN (CAST([Start_Date] AS DATE) <> CAST(DCO_Start_Date AS DATE) AND CAST([End_Date] AS DATE) <> CAST(DCO_End_Date AS DATE))
									THEN ' Content  Start & End Date Mismatch'
								ELSE
									'Content RP Mismatch'
							END						
					WHERE BMS_Asset_Ref_Key= DCO_Asset_ID 
					AND 
					(
						CAST([Start_Date] AS DATE) BETWEEN  CAST(DCO_Start_Date AS DATE) AND CAST(DCO_End_Date AS DATE)
						OR
						CAST([End_Date] AS DATE) BETWEEN  CAST(DCO_Start_Date AS DATE) AND CAST(DCO_End_Date AS DATE)
						OR
						CAST(DCO_Start_Date AS DATE) BETWEEN  CAST([Start_Date] AS DATE) AND CAST([End_Date] AS DATE)
						OR
						CAST(DCO_End_Date AS DATE) BETWEEN  CAST([Start_Date] AS DATE) AND CAST([End_Date] AS DATE)
					)				
					AND ISNULL([Start_Date],'') <> '' AND ISNULL([End_Date],'') <> ''
					AND ISNULL(DCO_Start_Date,'') <> '' AND ISNULL(DCO_End_Date,'') <> ''
					AND ISNULL(IS_Mapped,'') <> 'Y'
					
					--Check Content Start & End Date blank 
					UPDATE #Temp_DM_BMS_Mapped_UnMapped_Deal_Content SET IS_Mapped='N', IS_Error = 'Y',IS_Deleted = 'N',
						Error_Description =
							CASE 
								WHEN (ISNULL(DCO_Start_Date ,'') = '' AND ISNULL(DCO_End_Date ,'') <> '')
									THEN 'Content Start Date Blank'
								WHEN (ISNULL(DCO_Start_Date ,'') <> '' AND ISNULL(DCO_End_Date,'') = '')
									THEN 'Content End Date blank'
								WHEN (ISNULL(DCO_Start_Date,'') = '' AND ISNULL(DCO_End_Date,'') = '')
									THEN 'Content  Start & End Date blank'
								ELSE
									'Content RP Blank'
							END						
					WHERE BMS_Asset_Ref_Key= DCO_Asset_ID 
					AND ISNULL(IS_Mapped,'') <> 'Y'
					AND 
					(						
						 ISNULL(DCO_Start_Date,'') = '' 
						OR 
						 ISNULL(DCO_End_Date,'') = ''
					)

					--Set Is Delete "Y"  if Any BU deal is mapp or unmapped
					UPDATE #Temp_DM_BMS_Mapped_UnMapped_Deal_Content SET IS_Deleted = 'Y'
					WHERE 1 = 1 
					AND IS_Mapped = 'X' 
					AND DCO_DEA_ID NOT IN
					(
						SELECT DISTINCT DCO_DEA_ID 
						FROM #Temp_DM_BMS_Mapped_UnMapped_Deal_Content T1
						WHERE T1.IS_Mapped IN('Y','N')
						AND (ISNULL(T1.DCO_Start_Date,'') <> '' AND ISNULL(T1.DCO_End_Date,'') <> '')
					)
					--SELECT 'Sagar_Content' as Sagar_Content,* FROM  #Temp_DM_BMS_Mapped_UnMapped_Deal_Content
					--Insert into _DM_BMS_Mapped_UnMapped_Deal_Content 
					INSERT INTO DM_BMS_Mapped_UnMapped_Content
					(
						[BMS_Deal_Code] ,[BMS_Deal_Content_Code] ,[BMS_Asset_Code] ,
						[BMS_Asset_Ref_Key],[Title],
						[Start_Date],[End_Date] ,																								
						DCO_ID ,DCO_Asset_ID,
						DCO_Start_Date ,DCO_End_Date ,
						DCO_Deal_Id ,
						IS_Mapped ,IS_Error ,
						[Error_Description],Exact_Deal_Match 
					)																
					SELECT DISTINCT 
						TDBMDC.BMS_Deal_Code,TDBMDC.[BMS_Deal_Content_Code] ,TDBMDC.BMS_Asset_Code,
						TDBMDC.BMS_Asset_Ref_Key,TDBMDC.Title,
						TDBMDC.[Start_Date],TDBMDC.End_Date,
						TDBMDC.DCO_ID,TDBMDC.DCO_ASSET_ID,
						CAST(TDBMDC.DCO_Start_Date AS VARCHAR) AS DCO_Start_Date,CAST(TDBMDC.DCO_End_Date AS VARCHAR) AS DCO_End_Date,
						TDBMDC.DCO_DEA_ID,TDBMDC.IS_Mapped,
						TDBMDC.IS_Error,TDBMDC.[Error_Description],'N' AS  Exact_Deal_Match					
					FROM #Temp_DM_BMS_Mapped_UnMapped_Deal_Content	 TDBMDC		
					WHERE IS_Deleted IN('N') 
										
					IF NOT EXISTS(SELECT TOP 1 IS_Deleted FROM #Temp_DM_BMS_Mapped_UnMapped_Deal_Content WHERE IS_Deleted IN('Y','N'))
					BEGIN					
						INSERT INTO DM_BMS_Mapped_UnMapped_Content
						(
							[BMS_Deal_Code],BMS_Deal_Content_Code ,[BMS_Asset_Code] ,
							[BMS_Asset_Ref_Key],[Title],
							[Start_Date],[End_Date] ,
							IS_Mapped ,IS_Error ,
							[Error_Description],Exact_Deal_Match 
						)																
						SELECT DISTINCT 
							TDBMDC.BMS_Deal_Code,TDBMDC.BMS_Deal_Content_Code ,TDBMDC.BMS_Asset_Code,
							TDBMDC.BMS_Asset_Ref_Key,TDBMDC.Title,
							TDBMDC.[Start_Date],TDBMDC.End_Date,						
							TDBMDC.IS_Mapped,TDBMDC.IS_Error,
							'No Content Found in BV' AS [Error_Description],'N' AS  Exact_Deal_Match					
						FROM #Temp_DM_BMS_Mapped_UnMapped_Deal_Content	TDBMDC	
						WHERE IS_Deleted = 'X'
					END -- Validation of Content End
--				SELECT 'Sagar_Content' as Sagar_Content,* FROM  #Temp_DM_BMS_Mapped_UnMapped_Deal_Content
/***************************************Start Rights******************************************************************************************/	

				/***********************Insert into Temp tables For Rights******************************************/
				--Select from BMS_Deal_Content_Rights using RU Content Code
				SELECT DISTINCT BDCR.*,'N' AS Is_Error,'N' AS IS_Mapped_Rights
					INTO #Temp_BMS_Deal_Content_Rights --Insert into Temp table
				FROM BMS_Deal_Content_Rights BDCR
				INNER JOIN #Temp_BMS_Deal_Content TBDC ON BDCR.BMS_Deal_Content_Code = TBDC.BMS_Deal_Content_Code AND ISNULL(TBDC.BMS_Deal_Content_Code,0) > 0	
				--AND ISNULL(BDCR.Acq_Deal_Run_Yearwise_Run_Code,0) > 0				
				
				--Select From DM_BMS_Deal_Content_Rights
				SELECT DISTINCT 'X' AS IS_Error,'X' AS IS_DM_Mapped_Rights ,DM_BDRS.* 
					INTO #Temp_DM_Deal_Content_Rights --Insert into Temp table
				FROM DM_BMS_Deal_Content_Rights DM_BDRS
				INNER JOIN #Temp_BMS_Deal_Content_Rights TBDCR ON DM_BDRS.DCO_ASS_ID = DM_BDRS.DCO_ASS_ID
				WHERE DM_BDRS.DCO_DEA_ID IN
				(
					SELECT DISTINCT temp_DMC.DCO_DEA_ID
					FROM #Temp_DM_BMS_Deal_Content temp_DMC
					WHERE ISNULL(temp_DMC.DCO_DEA_ID,'0') <> '0'
				)
				AND ISNULL(DM_BDRS.DCO_ASS_ID,'0') <> '0'
							
				--Insert mapped Rights(only Channel ,date and Asset Code) into #Temp_DM_BMS_Mapped_Rights 
				SELECT DISTINCT
					BDCR .[BMS_Deal_Content_Rights_Code],DMDCR.DCO_ID,
					BDCR.[BMS_Deal_Content_Code],BDCR.[RU_Channel_Code],
					BDCR.BMS_Station_Code,BDCR.RU_Right_Rule_Code,
					BDCR.BMS_Right_Rule_Ref_Key,BDCR.[SAP_WBS_Code],
					BDCR.[SAP_WBS_Ref_Key],BDCR.[BMS_Asset_Code] ,
					BDCR.[BMS_Asset_Ref_Key],BDCR.[Title],
					--BDCR.[License_Fees],
					BDCR.[Total_Runs],BDCR.[Utilised_Run],
					BDCR.[Start_Date],BDCR.[End_Date],  
					BDCR.[YearWise_No],BDCR.[Min_Runs],
					BDCR.[Max_Runs],
					BDCR.Acq_Deal_Rights_Code ,
					BDCR.Acq_Deal_Run_Code ,
					BDCR.Acq_Deal_Run_Channel_Code ,
					BDCR.Acq_Deal_Run_YearWise_Run_Code ,
					ISNULL(DMDCR.[DCO_Dea_ID],0)  AS DCO_Dea_ID,
					--0
					ISNULL(DMDCR.[DCO_Ass_ID],0)  AS DCO_Ass_ID,ISNULL(DMDCR.[DCO_ID_RIGHTSHEADER],0) AS DCO_ID_RIGHTSHEADER,
					DMDCR.[DCO_Cha_ID],DMDCR.DCO_ARR_ID,
					DMDCR.[DCO_DAYSAVAILABLE],DMDCR.[DCO_DAYSUSED],
					DMDCR.DCO_DATEAVAILABLEFROM,DMDCR.DCO_DATEAVAILABLETO,
					ISNULL(DMDCR.DCO_BUC_ID,0) AS DCO_BUC_ID,
					'N' AS IS_Error,
					CAST (' ' AS VARCHAR(MAX)) AS Error_Description,
					'N' AS Mapped_Rights_Content, --if Mapped deal in both Content & Rights
					'Y' AS Is_Mapped_Rights
				INTO #Temp_DM_BMS_Mapped_Rights 
				FROM #Temp_BMS_Deal_Content_Rights BDCR 
				INNER JOIN #Temp_DM_Deal_Content_Rights  DMDCR ON BDCR.BMS_Asset_Ref_Key = DMDCR.DCO_ASS_ID 
					AND BDCR.BMS_Station_Code = DMDCR.DCO_Cha_ID
					AND CAST(DMDCR.DCO_DATEAVAILABLEFROM AS DATE) = CAST(BDCR.[Start_Date] AS DATE)
					AND CAST(DMDCR.DCO_DATEAVAILABLETo AS DATE) = CAST(BDCR.[End_Date] AS DATE) 								
					AND ISNULL(BDCR.[Start_Date],'') <> '' AND ISNULL(BDCR.[End_Date],'') <> ''
					AND ISNULL(DMDCR.DCO_DATEAVAILABLEFROM,'') <> '' AND ISNULL(DMDCR.DCO_DateAvailableTo,'') <> ''
					AND ISNULL(DMDCR.DCO_Cha_ID,'0') <> '0' 
					--AND ISNULL(DMDCR.[DCO_ID_RIGHTSHEADER],'') <> '' 
									
		/***************************************End Insert Rights into temp table**************************************************************/
				--Update Error Descritption if Rights header Code null in BV temp Table
				--#Temp_DM_Deal_Content_Rights
				UPDATE #Temp_DM_Deal_Content_Rights SET  IS_Error = 'Y',IS_DM_Mapped_Rights='N',Error_Description = 
				CASE
					WHEN ISNULL(DCO_ID_RIGHTSHEADER,'0') = '0' AND ISNULL(DCO_DATEAVAILABLEFROM,'')  = '' AND ISNULL(DCO_DATEAVAILABLETO,'')  = ''
						THEN  ISNULL(Error_Description,'') + 'DCO_ID_RIGHTSHEADER and BV Start date & End Date is null' 
					WHEN ISNULL(DCO_DATEAVAILABLEFROM,'')  = '' AND ISNULL(DCO_DATEAVAILABLETO,'')  <> ''
						THEN  ISNULL(Error_Description,'') + 'BV Start date is null'
					WHEN ISNULL(DCO_DATEAVAILABLEFROM,'')  <> '' AND ISNULL(DCO_DATEAVAILABLETO,'')  = ''
						THEN  ISNULL(Error_Description,'') + 'BV End date is null'
					WHEN ISNULL(DCO_ID_RIGHTSHEADER,'0') <> '0' AND ISNULL(DCO_DATEAVAILABLEFROM,'')  = '' AND ISNULL(DCO_DATEAVAILABLETO,'')  = ''
						THEN  ISNULL(Error_Description,'') + 'BV Start date & End date is null'
					ELSE
						ISNULL(Error_Description,'') + 'DCO_ID_RIGHTSHEADER is null'
				END 
				WHERE ISNULL(DCO_ID_RIGHTSHEADER,'0') = '0' 
				AND 
				(
					ISNULL(DCO_DATEAVAILABLEFROM,'')  = ''
					OR
					ISNULL(DCO_DATEAVAILABLETO,'')  = ''
				)
				--Run mismatch update mapped Temp table
				UPDATE #Temp_DM_BMS_Mapped_Rights SET Is_Mapped_Rights = 'N',IS_Error = 'Y',Error_Description = ISNULL(Error_Description,'')  +  ' ~Ru runs and bv runs mismatch'
				WHERE [DCO_DAYSAVAILABLE] <> Total_Runs 
				--AND Mapped_Rights_Content = 'Y'

				--Right Rule Mismatch
				--Note Here Set Is_Mapped_Rights = 'N' once Right Rule Mapped in RU
				UPDATE #Temp_DM_BMS_Mapped_Rights SET Is_Mapped_Rights = 'Y',IS_Error = 'Y',Error_Description =ISNULL(Error_Description,'')  +  ' ~Ru Right Rule and bv Right Rule mismatch'
				WHERE  ISNULL(DCO_ARR_ID,'0') <> ISNULL(BMS_Right_Rule_Ref_Key,0)
				--AND Mapped_Rights_Content = 'Y'

				--Budget Code Mismatch
				--Note Here Set Is_Mapped_Rights = 'N' once Right Rule Mapped in RU
				UPDATE #Temp_DM_BMS_Mapped_Rights SET Is_Mapped_Rights = 'N',IS_Error = 'Y',Error_Description = ISNULL(Error_Description,'')  + '~RU Budget Code and bv Budget Code mismatch'
				WHERE  ISNULL([SAP_WBS_Ref_Key],0) <> ISNULL(DCO_BUC_ID,0)
				--AND Mapped_Rights_Content = 'Y'
			---SELECT 'sagar_mapped_Rights_Data',* FROM #Temp_DM_BMS_Mapped_Rights
				/******************************************Update IS_Mapped_Rights ************************************************************/
				--IS_Mapped_Rights
				--#Temp_DM_BMS_Mapped_Rights
				UPDATE BDCR SET BDCR.IS_Mapped_Rights = 'Y'
				FROM #Temp_BMS_Deal_Content_Rights BDCR 
				INNER JOIN #Temp_DM_BMS_Mapped_Rights DMDCR ON BDCR.BMS_Deal_Content_Rights_Code = DMDCR.BMS_Deal_Content_Rights_Code

				UPDATE TDBDC SET TDBDC.IS_DM_Mapped_Rights = 'Y'
				FROM #Temp_DM_Deal_Content_Rights TDBDC
				INNER JOIN #Temp_DM_BMS_Mapped_Rights DMDCR ON TDBDC.DCO_ID = DMDCR.DCO_ID
				
				/******************************************Channel NOT Found in BV************************************************************/
				
				SELECT DISTINCT
					TBR.[BMS_Deal_Content_Rights_Code],
					TBR.[BMS_Deal_Content_Code],TBR.[RU_Channel_Code],
					TBR.BMS_Station_Code,TBR.RU_Right_Rule_Code,
					TBR.BMS_Right_Rule_Ref_Key,TBR.[SAP_WBS_Code],
					TBR.[SAP_WBS_Ref_Key],TBR.[BMS_Asset_Code] ,
					TBR.[BMS_Asset_Ref_Key],TBR.[Title],
					--TBR.[License_Fees],
					TBR.[Total_Runs],TBR.[Utilised_Run],
					TBR.[Start_Date],TBR.[End_Date],  
					TBR.[YearWise_No],TBR.[Min_Runs],
					TBR.[Max_Runs],
					TBR.Acq_Deal_Rights_Code ,
					TBR.Acq_Deal_Run_Code ,
					TBR.Acq_Deal_Run_Channel_Code ,
					TBR.Acq_Deal_Run_YearWise_Run_Code, 
					'Y' AS IS_Error,
					'Channel NOT Found in BV' AS Error_Description,
					'N' AS Mapped_Rights_Content, 
					'N' AS Is_Mapped_Rights
					INTO #Temp_Rights_Channel_NOT_IN_BV
				FROM #Temp_BMS_Deal_Content_Rights TBR
				INNER JOIN #Temp_DM_Deal_Content_Rights TDR ON TBR.BMS_Asset_Ref_Key = TDR.DCO_ASS_ID				
				INNER JOIN Channel C ON ISNULL(C.Ref_Station_Key,0) = TDR.DCO_CHA_ID
				AND TBR.IS_Mapped_Rights <> 'Y' AND TDR.IS_DM_Mapped_Rights <> 'Y'
				AND CAST(TDR.DCO_DATEAVAILABLEFROM AS DATE) = CAST(TBR.[Start_Date] AS DATE)
				AND CAST(TDR.DCO_DATEAVAILABLETo AS DATE) = CAST(TBR.[End_Date] AS DATE) 								
				AND ISNULL(TDR.DCO_DATEAVAILABLEFROM,'') <> '' AND ISNULL(TDR.DCO_DATEAVAILABLETO,'') <> ''
				AND ISNULL(TBR.[Start_Date],'') <> '' AND ISNULL(TBR.[End_Date],'') <> ''				
				AND ISNULL(TDR.DCO_CHA_ID,'') <> ''  AND ISNULL(C.Ref_Station_Key,0) > 0

				
				/**************************************************New RP Mismatch********************************/
				SELECT DISTINCT  
					TBR .[BMS_Deal_Content_Rights_Code],TDR.DCO_ID,
					TBR.[BMS_Deal_Content_Code],TBR.[RU_Channel_Code],
					TBR.BMS_Station_Code,TBR.RU_Right_Rule_Code,
					TBR.BMS_Right_Rule_Ref_Key,TBR.[SAP_WBS_Code],
					TBR.[SAP_WBS_Ref_Key],TBR.[BMS_Asset_Code] ,
					TBR.[BMS_Asset_Ref_Key],TBR.[Title],
					TBR.[License_Fees],
					TBR.[Total_Runs],TBR.[Utilised_Run],
					TBR.[Start_Date],TBR.[End_Date],  
					TBR.[YearWise_No],TBR.[Min_Runs],
					TBR.[Max_Runs],
					TBR.Acq_Deal_Rights_Code ,
					TBR.Acq_Deal_Run_Code ,
					TBR.Acq_Deal_Run_Channel_Code ,
					TBR.Acq_Deal_Run_YearWise_Run_Code ,
					ISNULL(TDR.[DCO_Dea_ID],0)  AS DCO_Dea_ID,
					--0
					ISNULL(TDR.[DCO_Ass_ID],0)  AS DCO_Ass_ID,ISNULL(TDR.[DCO_ID_RIGHTSHEADER],0) AS DCO_ID_RIGHTSHEADER,
					TDR.[DCO_Cha_ID],TDR.DCO_ARR_ID,
					TDR.[DCO_DAYSAVAILABLE],TDR.[DCO_DAYSUSED],
					TDR.DCO_DATEAVAILABLEFROM,TDR.DCO_DATEAVAILABLETO,
					ISNULL(TDR.DCO_BUC_ID,0) AS DCO_BUC_ID,
					'Y' AS IS_Error,
					'RU and BV Rights Period Mismatch' AS Error_Description,
					'N' AS Mapped_Rights_Content, --if Mapped deal in both Content & Rights
					'N' AS Is_Mapped_Rights
					INTO #Temp_Rights_RP_Mismatch
				FROM #Temp_BMS_Deal_Content_Rights TBR
				INNER JOIN #Temp_DM_Deal_Content_Rights TDR ON TBR.BMS_Asset_Ref_Key = TDR.DCO_ASS_ID
				AND ISNULL(TDR.DCO_DATEAVAILABLEFROM,'') <> ''
				AND ISNULL(TDR.DCO_DATEAVAILABLETO,'') <> ''
				AND ISNULL(TDR.DCO_CHA_ID,'') <> '' 
				AND TBR.IS_Mapped_Rights <> 'Y'
				AND TDR.IS_DM_Mapped_Rights <> 'Y'
				AND TBR.BMS_Station_Code = TDR.DCO_CHA_ID

				/**************************************************End RP Mismatch********************************/
				--SELECT 'sagar_RU',* FROM #Temp_BMS_Deal_Content_Rights
				--SELECT 'sagar_BV',* FROM #Temp_DM_Deal_Content_Rights 
			/******************************************End Channel & RP Mismatch**************************************************/

			/**********************************Insert Records into DM_BMS_Mapped_UnMapped_Content_Rights *************************/						
				--Insert Mapped Rights Or Error like mismatch Runs ,Right Rule & Budget Code
						INSERT  INTO DM_BMS_Mapped_UnMapped_Content_Rights
						(
							[BMS_Deal_Content_Rights_Code],[DCO_ID],
							[BMS_Deal_Content_Code],[RU_Channel_Code],
							[BMS_Station_Code],[RU_Right_Rule_Code],
							[BMS_Right_Rule_Ref_Key],[SAP_WBS_Code],
							[SAP_WBS_Ref_Key],[BMS_Asset_Code] ,
							[BMS_Asset_Ref_Key],[Title],
							[Total_Runs],[Utilised_Run],
							[Start_Date],[End_Date],  
							[YearWise_No],
							[Min_Runs],[Max_Runs],
							Acq_Deal_Rights_Code ,
							Acq_Deal_Run_Code ,
							Acq_Deal_Run_Channel_Code ,
							Acq_Deal_Run_YearWise_Run_Code ,
							[DCO_Deal_ID],DCO_Asset_ID,
							[DCO_ID_RIGHTSHEADER],[DCO_Channel_ID],
							DCO_ARR_ID,[DCO_DAYSAVAILABLE],
							[DCO_DAYSUSED],
							DCO_Start_Date,DCO_End_Date,
							DCO_BUC_ID,IS_Mapped ,
							IS_Error ,[Error_Description],Exact_Deal_Match 
						)
						SELECT DISTINCT
							temp_DBR .[BMS_Deal_Content_Rights_Code],temp_DBR.DCO_ID,
							temp_DBR.[BMS_Deal_Content_Code],temp_DBR.[RU_Channel_Code],								
							temp_DBR.BMS_Station_Code,temp_DBR.RU_Right_Rule_Code,temp_DBR.BMS_Right_Rule_Ref_Key,
							temp_DBR.[SAP_WBS_Code],temp_DBR.[SAP_WBS_Ref_Key],
							temp_DBR.[BMS_Asset_Code] ,temp_DBR.[BMS_Asset_Ref_Key],									
							temp_DBR.[Title],temp_DBR.[Total_Runs],
							temp_DBR.[Utilised_Run],
							temp_DBR.[Start_Date],temp_DBR.[End_Date],  
							temp_DBR.[YearWise_No],
							temp_DBR.[Min_Runs],temp_DBR.[Max_Runs],
							temp_DBR.Acq_Deal_Rights_Code ,
							temp_DBR.Acq_Deal_Run_Code ,
							temp_DBR.Acq_Deal_Run_Channel_Code ,
							temp_DBR.Acq_Deal_Run_YearWise_Run_Code ,
							temp_DBR.[DCO_Dea_ID],temp_DBR.DCO_Ass_ID,
							ISNULL(temp_DBR.[DCO_ID_RIGHTSHEADER],0),temp_DBR.[DCO_Cha_ID],
							temp_DBR.DCO_ARR_ID,temp_DBR.[DCO_DAYSAVAILABLE],
							temp_DBR.[DCO_DAYSUSED],temp_DBR.DCO_DATEAVAILABLEFROM,temp_DBR.DCO_DATEAVAILABLETO,
							temp_DBR.DCO_BUC_ID,temp_DBR.Is_Mapped_Rights AS Is_Mapped,
							temp_DBR.IS_Error,temp_DBR.Error_Description AS Error_Description,'N' AS 	Exact_Deal_Match							
							FROM  #Temp_DM_BMS_Mapped_Rights temp_DBR						
							WHERE 1 =1	
							--Insert RP mismatch
							INSERT  INTO DM_BMS_Mapped_UnMapped_Content_Rights
							(
								[BMS_Deal_Content_Rights_Code],[DCO_ID],
								[BMS_Deal_Content_Code],[RU_Channel_Code],
								[BMS_Station_Code],[RU_Right_Rule_Code],
								[BMS_Right_Rule_Ref_Key],[SAP_WBS_Code],
								[SAP_WBS_Ref_Key],[BMS_Asset_Code] ,
								[BMS_Asset_Ref_Key],[Title],
								[Total_Runs],[Utilised_Run],
								[Start_Date],[End_Date],  
								[YearWise_No],
								[Min_Runs],[Max_Runs],
								Acq_Deal_Rights_Code ,
								Acq_Deal_Run_Code ,
								Acq_Deal_Run_Channel_Code ,
								Acq_Deal_Run_YearWise_Run_Code ,
								[DCO_Deal_ID],DCO_Asset_ID,
								[DCO_ID_RIGHTSHEADER],[DCO_Channel_ID],
								DCO_ARR_ID,[DCO_DAYSAVAILABLE],
								[DCO_DAYSUSED],
								DCO_Start_Date,DCO_End_Date,
								DCO_BUC_ID,IS_Mapped ,
								IS_Error ,[Error_Description],Exact_Deal_Match 
							)
							SELECT DISTINCT
								temp_DBR .[BMS_Deal_Content_Rights_Code],temp_DBR.DCO_ID,
								temp_DBR.[BMS_Deal_Content_Code],temp_DBR.[RU_Channel_Code],								
								temp_DBR.BMS_Station_Code,temp_DBR.RU_Right_Rule_Code,temp_DBR.BMS_Right_Rule_Ref_Key,
								temp_DBR.[SAP_WBS_Code],temp_DBR.[SAP_WBS_Ref_Key],
								temp_DBR.[BMS_Asset_Code] ,temp_DBR.[BMS_Asset_Ref_Key],									
								temp_DBR.[Title],temp_DBR.[Total_Runs],
								temp_DBR.[Utilised_Run],
								temp_DBR.[Start_Date],temp_DBR.[End_Date],  
								temp_DBR.[YearWise_No],
								temp_DBR.[Min_Runs],temp_DBR.[Max_Runs],
								temp_DBR.Acq_Deal_Rights_Code ,
								temp_DBR.Acq_Deal_Run_Code ,
								temp_DBR.Acq_Deal_Run_Channel_Code ,
								temp_DBR.Acq_Deal_Run_YearWise_Run_Code ,
								temp_DBR.[DCO_Dea_ID],temp_DBR.DCO_Ass_ID,
								ISNULL(temp_DBR.[DCO_ID_RIGHTSHEADER],0),temp_DBR.[DCO_Cha_ID],
								temp_DBR.DCO_ARR_ID,temp_DBR.[DCO_DAYSAVAILABLE],
								temp_DBR.[DCO_DAYSUSED],temp_DBR.DCO_DATEAVAILABLEFROM,temp_DBR.DCO_DATEAVAILABLETO,
								temp_DBR.DCO_BUC_ID,temp_DBR.Is_Mapped_Rights AS Is_Mapped,
								temp_DBR.IS_Error,temp_DBR.Error_Description AS Error_Description,'N' AS Exact_Deal_Match							
							FROM  #Temp_Rights_RP_Mismatch temp_DBR						
							WHERE 1 =1	 
							
							--INsert Channel Not Found
							INSERT  INTO DM_BMS_Mapped_UnMapped_Content_Rights
							(
								[BMS_Deal_Content_Rights_Code],
								[BMS_Deal_Content_Code],[RU_Channel_Code],
								[BMS_Station_Code],[RU_Right_Rule_Code],
								[BMS_Right_Rule_Ref_Key],[SAP_WBS_Code],
								[SAP_WBS_Ref_Key],[BMS_Asset_Code] ,
								[BMS_Asset_Ref_Key],[Title],
								[Total_Runs],[Utilised_Run],
								[Start_Date],[End_Date],  
								[YearWise_No],
								[Min_Runs],[Max_Runs],
								Acq_Deal_Rights_Code ,
								Acq_Deal_Run_Code ,
								Acq_Deal_Run_Channel_Code ,
								Acq_Deal_Run_YearWise_Run_Code ,
								DCO_Asset_ID,
								[DCO_Channel_ID],
								IS_Mapped ,
								IS_Error ,[Error_Description],Exact_Deal_Match 
							)
							SELECT DISTINCT
								temp_DBR .[BMS_Deal_Content_Rights_Code],
								temp_DBR.[BMS_Deal_Content_Code],temp_DBR.[RU_Channel_Code],								
								temp_DBR.BMS_Station_Code,temp_DBR.RU_Right_Rule_Code,temp_DBR.BMS_Right_Rule_Ref_Key,
								temp_DBR.[SAP_WBS_Code],temp_DBR.[SAP_WBS_Ref_Key],
								temp_DBR.[BMS_Asset_Code] ,temp_DBR.[BMS_Asset_Ref_Key],									
								temp_DBR.[Title],temp_DBR.[Total_Runs],
								temp_DBR.[Utilised_Run],
								temp_DBR.[Start_Date],temp_DBR.[End_Date],  
								temp_DBR.[YearWise_No],
								temp_DBR.[Min_Runs],temp_DBR.[Max_Runs],
								temp_DBR.Acq_Deal_Rights_Code ,
								temp_DBR.Acq_Deal_Run_Code ,
								temp_DBR.Acq_Deal_Run_Channel_Code ,
								temp_DBR.Acq_Deal_Run_YearWise_Run_Code ,
								temp_DBR.[BMS_Asset_Ref_Key],
								temp_DBR.BMS_Station_Code,
								temp_DBR.Is_Mapped_Rights AS Is_Mapped,
								temp_DBR.IS_Error,temp_DBR.Error_Description AS Error_Description,'N' AS Exact_Deal_Match							
							FROM  #Temp_Rights_Channel_NOT_IN_BV temp_DBR						
							WHERE 1 =1	 
																																	
/***************************************End Rights**************************************************************/

FETCH NEXT FROM BMS_Deal_Cursor INTO @BMS_Deal_Code --Deal Cursor
			END	--While loop BMS_Deal_Cursor
CLOSE BMS_Deal_Cursor;
DEALLOCATE BMS_Deal_Cursor;

--Delete After Insert Record if BV Rights Period match with RU RP and Channels (For multiple Deals)
DELETE 
--SELECT * 
FROM DM_BMS_Mapped_UnMapped_Content_Rights 
WHERE DCO_ID IN
(
	SELECT DBMCR1.DCO_ID
	FROM DM_BMS_Mapped_UnMapped_Content_Rights DBMCR1
	INNER JOIN  DM_BMS_Mapped_UnMapped_Content_Rights DBMCR2 
	ON DBMCR1.DCO_Asset_ID = DBMCR2.BMS_Asset_Ref_Key 
	AND DBMCR1.DCO_Channel_ID= DBMCR2.BMS_Station_Code
	AND DBMCR1.DCO_Start_Date= DBMCR2.Start_Date
	AND DBMCR1.DCO_End_Date = DBMCR2.End_Date
	--AND DBMCR1.IS_Mapped = 'Y'
)
AND Error_Description like '%RU and BV Rights Period Mismatch%'
--AND TITLE like '%Amaanat%' --AND  
--ORDER BY Title

END	





/*
--SELECT DISTINCT DM.Error_Description FROM DM_BMS_Mapped_UnMapped_Content_Rights DM

SELECT DISTINCT AD.Agreement_No,DBMCR.Title,BU.Business_Unit_Name,V.Vendor_NAme,C.Channel_Name,DBMCR.Error_Description
FROM DM_BMS_Mapped_UnMapped_Content_Rights DBMCR
INNER JOIN Channel C ON C.Ref_Station_Key = DBMCR.BMS_Station_Code
INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = DBMCR.BMS_Deal_Content_Code AND ISNULL(DBMCR.BMS_Deal_Content_Code,0) > 0
INNER JOIN BMS_Deal  BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code
INNER JOIN Acq_Deal  AD ON AD.Acq_Deal_Code = BD.Acq_Deal_Code
INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code 
INNER JOIN Business_Unit  BU  ON BU.Business_Unit_Code = AD.Business_Unit_Code
WHERE DBMCR.IS_Mapped = 'N' AND DBMCR.IS_Error = 'Y'
AND DBMCR.Error_Description like 'Channel Not Found in BV'
ORDER BY BU.Business_Unit_Name,DBMCR.Title,AD.Agreement_No,C.Channel_Name,V.Vendor_NAme

SELECT DISTINCT AD.Agreement_No,DBMCR.Title,BU.Business_Unit_Name,V.Vendor_NAme,
--C.Channel_Name,
DBMCR.Start_Date AS RU_Right_Start_Date
,DBMCR.End_Date AS RU_Right_End_Date 
,DBMCR.DCO_Start_Date AS BV_Right_Start_Date
,DBMCR.DCO_End_Date AS BV_Right_End_Date 
,'RP Mismatch' Error_Description
FROM DM_BMS_Mapped_UnMapped_Content_Rights DBMCR
INNER JOIN Channel C ON C.Ref_Station_Key = DBMCR.BMS_Station_Code
INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = DBMCR.BMS_Deal_Content_Code AND ISNULL(DBMCR.BMS_Deal_Content_Code,0) > 0
INNER JOIN BMS_Deal  BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code
INNER JOIN Acq_Deal  AD ON AD.Acq_Deal_Code = BD.Acq_Deal_Code
INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code 
INNER JOIN Business_Unit  BU  ON BU.Business_Unit_Code = AD.Business_Unit_Code
--INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code IN
--(
--SELECT * 
--FROM BMS_Deal_Content BDC 
--INNER JOIN BMS_Deal BD
--WHERE BDC.BMS_Deal_Content_Code = DBMCR.BMS_Deal_Content_Code
--)
WHERE DBMCR.IS_Mapped = 'N' AND DBMCR.IS_Error = 'Y'
AND DBMCR.Error_Description like 'Channel Not Found in BV & RP Mismatch in BV'
--AND DBMCR.Error_Description like 'RP Mismatch in BV'
ORDER BY BU.Business_Unit_Name,DBMCR.Title,AD.Agreement_No,
--C.Channel_Name,
V.Vendor_NAme

SELECT DISTINCT AD.Agreement_No,DBMCR.Title,BU.Business_Unit_Name
,DBMCR.Total_Runs AS RU_Runs,DBMCR.DCO_DAYSAVAILABLE AS BV_Runs
,V.Vendor_NAme,
C.Channel_Name,
DBMCR.Start_Date AS RU_Right_Start_Date
,DBMCR.End_Date AS RU_Right_End_Date 
,DBMCR.DCO_Start_Date AS BV_Right_Start_Date
,DBMCR.DCO_End_Date AS BV_Right_End_Date  
--,DBMCR.Error_Description
,'Ru runs and bv runs mismatch' AS Error_Description
FROM DM_BMS_Mapped_UnMapped_Content_Rights DBMCR
INNER JOIN Channel C ON C.Ref_Station_Key = DBMCR.BMS_Station_Code
INNER JOIN BMS_Deal_Content BDC ON BDC.BMS_Deal_Content_Code = DBMCR.BMS_Deal_Content_Code AND ISNULL(DBMCR.BMS_Deal_Content_Code,0) > 0
INNER JOIN BMS_Deal  BD ON BD.BMS_Deal_Code = BDC.BMS_Deal_Code
INNER JOIN Acq_Deal  AD ON AD.Acq_Deal_Code = BD.Acq_Deal_Code
INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code 
INNER JOIN Business_Unit  BU  ON BU.Business_Unit_Code = AD.Business_Unit_Code
--INNER JOIN Acq_Deal AD ON AD.Acq_Deal_Code IN
--(
--SELECT * 
--FROM BMS_Deal_Content BDC 
--INNER JOIN BMS_Deal BD
--WHERE BDC.BMS_Deal_Content_Code = DBMCR.BMS_Deal_Content_Code
--)
WHERE  1 =1 
--DBMCR.IS_Mapped = 'N' AND DBMCR.IS_Error = 'Y'
AND DBMCR.Error_Description like '%Ru runs and bv runs mismatch%'
--AND DBMCR.Error_Description like 'RP Mismatch in BV'
ORDER BY BU.Business_Unit_Name,DBMCR.Title,AD.Agreement_No,
--C.Channel_Name,
V.Vendor_NAme
*/