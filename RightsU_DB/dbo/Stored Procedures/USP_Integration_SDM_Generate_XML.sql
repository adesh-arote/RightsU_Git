CREATE PROCEDURE [dbo].[USP_Integration_SDM_Generate_XML]
--DECLARE
@Module_Name VARCHAR(100)='Title',
@Date_Since DateTime=null
AS        
-- =============================================        
-- Author:  <Anchal Sikarwar>        
-- Create date: <22 Feb 2017>        
-- Description: <Call From RightsU Plus Web Api and Generate XML>        
-- =============================================                    
BEGIN         
	SET NOCOUNT ON;  
	DECLARE @Error_Desc VARCHAR(5000) = '',@Is_Error CHAR(1) = 'N' ,@Record_Status VARCHAR(5) = 'D'    
	DECLARE @Integration_Config_Code INT,@xmlData NVARCHAR(MAX)
    
	/********************************Check Module Name****************/        
	BEGIN TRY
	SELECT TOP 1 @Integration_Config_Code=Integration_Config_Code FROM Integration_Config IC        
			WHERE 1 =1  AND UPPER(IC.Module_Name) = UPPER(@Module_Name) AND Foreign_System_Name='SDM'                 
		IF EXISTS(SELECT * from Integration_Config WHERE Integration_Config_Code=@Integration_Config_Code AND Is_Active='Y')        
		BEGIN
			/***************************************************Title*********************************************************************/        
			IF(UPPER(@Module_Name) = 'TITLE')        
			BEGIN
				IF OBJECT_ID('tempdb..#Temp_Title') IS NOT NULL        
				BEGIN
					DROP TABLE #Temp_Title        
				END           
				SELECT
				DISTINCT
				 T.Title_Code
				,T.Title_Name
				,T.Title_Language_Code
				,T.Year_Of_Production
				,T.Deal_Type_Code
				INTO #Temp_Title    
				FROM
				Acq_Deal AD         
				INNER JOIN Acq_Deal_Rights ADRight ON AD.Acq_Deal_Code = ADRight.Acq_Deal_Code
				AND ISNULL(ADRight.Actual_Right_Start_Date,'') <> ''  
				INNER JOIN Acq_Deal_Rights_Title ADRTitle ON  ADRight.Acq_Deal_Rights_Code =ADRTitle.Acq_Deal_Rights_Code 
				INNER JOIN Title T ON T.Title_Code= ADRTitle.Title_Code   
				WHERE AD.Deal_Workflow_Status='A' AND ADRight.Is_Sub_License='Y'
				AND         
				(        
					ISNULL(T.Last_UpDated_Time,ISNULL(T.Inserted_On,GETDATE())) >= ISNULL(@Date_Since,
					(
						SELECT TOP 1 Request_DateTime
						FROM 
						(
							SELECT TOP 1 ESL.Request_DateTime
							FROM Integration_SDM_Log ESL 
							WHERE ESL.Integration_Config_Code = @Integration_Config_Code  AND Record_Status='D'
							ORDER BY ESL.Request_DateTime DESC
							UNION
							SELECT CAST('01Jan1900' AS DATETIME) AS Request_DateTime			
						) AS A
						ORDER BY Request_DateTime DESC
					))
					OR         
					ISNULL(@Integration_Config_Code,0) = 0        
				)      
       
				SELECT @xmlData =         
				(
					SELECT
					(        
						SELECT T.Title_Code AS Title 
						,T.Title_Name AS TitleName
						,T.Title_Language_Code AS TitleLanguage
						,ISNULL(         
							(        
							SELECT STUFF((SELECT DISTINCT  ',' + CAST(ISNULL(TT.Talent_Code,0) AS VARCHAR(MAX))         
							FROM Title_Talent TT    
							WHERE TT.Title_Code = T.Title_Code  AND TT.Role_Code=2      
							FOR XML PATH('')), 1, 1, '')         
							),'0')        
							AS Talent
						,ISNULL(T.Year_Of_Production, 0) AS YearOfRelease
						,ISNULL(         
							(        
							SELECT STUFF((SELECT DISTINCT  ',' + CAST(ISNULL(TG.Genres_Code,0) AS VARCHAR(MAX))         
							FROM Title_Geners TG    
							WHERE TG.Title_Code = T.Title_Code      
							FOR XML PATH('')), 1, 1, '')         
							),'0')        
							AS TitleGeners
						,T.Deal_Type_Code AS TitleType
						FROM #Temp_Title T
						FOR XML PATH('Title')
						,TYPE        
					)     
					FOR XML PATH(''),        
					ROOT('TitleData')         
				)      
				IF OBJECT_ID('tempdb..#Temp_Title') IS NOT NULL        
				BEGIN        
				DROP TABLE #Temp_Title        
				END      
			END    
			   SET @xmlData = '<?xml version="1.0" ?>' + ISNULL(@xmlData,'')  + ''          
		END
		ELSE
		BEGIN
			SET @Is_Error = 'Y'  
			SET @Error_Desc = 'Module is not Configured'
			SET @xmlData = ''
			SET @Record_Status = 'E'
		END
		   
		/***************************************************Drop Tables *******************************/   
		         
        
	END TRY        
	BEGIN CATCH            
		SET @Is_Error   = 'Y'         
		SET @Error_Desc = 'Error In USP_Integration_SDM_Generate_XML : Error_Desc : ' +  ERROR_MESSAGE() 
							+ ' ;ErrorNumber : ' + CAST(ERROR_NUMBER() AS VARCHAR)        
		SET @Error_Desc =  @Error_Desc + ';ErrorLine : '+ CAST(ERROR_LINE() AS VARCHAR) + ' ;'         
		SET @Error_Desc =  @Error_Desc + ' ;USP Input Parameters : ' +';@Module_Name : ' +@Module_Name 
		SET @Record_Status = 'E'
        SET @xmlData = ''

	END CATCH        
	/********************************Log File Code ****************/        
	IF(ISNULL(@Integration_Config_Code,0) = 0)        
	  SELECT @Integration_Config_Code = Integration_Config_Code FROM Integration_Config WHERE UPPER(Module_Name) = @Module_Name 
	  AND Foreign_System_Name='SDM'         
        
	--INSERT INTO Deal_Demo_Integration_Log(Deal_Demo_Integration_Config_Code,Request_XML,Request_Type,Request_DateTime,Response_DateTime
	--,Response_XML,[Error_Message],        
	--[Record_Status]             
	--)  
	--SELECT ISNULL(@Integration_Config_Code,0),@xmlData,'G',GETDATE(),NULL,NULL,@Error_Desc,@Record_Status
        
	/********************************Result****************/        
	SELECT @xmlData AS XML_Data, @Error_Desc AS Error_Desc,@Is_Error AS IS_Error

	IF OBJECT_ID('tempdb..#Temp_Title') IS NOT NULL DROP TABLE #Temp_Title
END