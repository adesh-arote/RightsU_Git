CREATE PROCEDURE [dbo].[USP_Validate_General_Delete_For_Title]
(
	@Syn_Deal_Code INT,
	@Title_Code INT,
	@Episode_From INT,
	@Episode_To INT,
	@CheckFor varchar(1)
)
AS
-- =============================================
-- Author:		Rajesh Godse
-- Create date: <Create Date,,>
-- Description:	Check before deleting title from deal movie if it is assigned anywhere in deals
-- =============================================
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_General_Delete_For_Title]', 'Step 1', 0, 'Started Procedure', 0, '' 
		Declare @status CHAR(1) = 'S', @tabNames NVARCHAR(MAX) = NULL
		IF(@CheckFor = 'S')
		BEGIN
			IF EXISTS(
				SELECT TOP 1 SDRT.Syn_Deal_Rights_Title_Code from Syn_Deal_Rights_Title SDRT (NOLOCK)
				INNER JOIN Syn_Deal_Rights SDR (NOLOCK) ON   SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
				WHERE SDR.Syn_Deal_Code = @Syn_Deal_Code AND SDRT.Title_Code = @Title_Code AND SDRT.Episode_From = @Episode_From AND SDRT.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Rights', 'Rights')
			END

			IF EXISTS(
				SELECT TOP 1 SDAT.Syn_Deal_Ancillary_Title_Code from Syn_Deal_Ancillary_Title SDAT (NOLOCK)
				INNER JOIN Syn_Deal_Ancillary SDA (NOLOCK) ON SDAT.Syn_Deal_Ancillary_Code = SDA.Syn_Deal_Ancillary_Code
				WHERE SDA.Syn_Deal_Code = @Syn_Deal_Code AND SDAT.Title_Code = @Title_Code AND SDAT.Episode_From = @Episode_From AND SDAT.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Ancillary', 'Ancillary')
			END
		
			IF EXISTS (
				SELECT TOP 1 SDRT.Syn_Deal_Revenue_Title_Code from Syn_Deal_Revenue_Title SDRT (NOLOCK)
				INNER JOIN Syn_Deal_Revenue SDR (NOLOCK) ON SDRT.Syn_Deal_Revenue_Code = SDR.Syn_Deal_Revenue_Code
				WHERE SDR.Syn_Deal_Code = @Syn_Deal_Code AND SDRT.Title_Code = @Title_Code AND SDRT.Episode_From = @Episode_From AND SDRT.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Revenue', 'Revenue')
			END
		
			IF EXISTS(
				SELECT TOP 1 SDA.Syn_Deal_Attachment_Code from Syn_Deal_Attachment SDA (NOLOCK)
				WHERE SDA.Syn_Deal_Code = @Syn_Deal_Code AND SDA.Title_Code = @Title_Code AND SDA.Episode_From = @Episode_From AND SDA.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Attachment', 'Attachment')
			END
	
			IF EXISTS(
				SELECT TOP 1 SDM.Syn_Deal_Material_Code from Syn_Deal_Material SDM (NOLOCK)
				WHERE SDM.Syn_Deal_Code = @Syn_Deal_Code AND SDM.Title_Code = @Title_Code AND SDM.Episode_From = @Episode_From AND SDM.Episode_To = @Episode_To
			) 
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Material', 'Material')			
			END
		
			IF EXISTS(
				SELECT TOP 1 SDM.Syn_Deal_Supplementary_Code from Syn_Deal_Supplementary SDM (NOLOCK)
				WHERE SDM.Syn_Deal_Code = @Syn_Deal_Code AND SDM.Title_Code = @Title_Code AND SDM.Episode_From = @Episode_From AND SDM.Episode_To = @Episode_To
			) 
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Supplementary', 'Supplementary')			
			END
		END
		ELSE
		BEGIN
			DECLARE @Deal_Type_Condition VARCHAR(MAX) = ''
			SELECT TOP 1 @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code) FROM Acq_Deal_Movie ADM (NOLOCK)
			INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Acq_Deal_Movie_Code = @Syn_Deal_Code

			IF EXISTS(
				SELECT TOP 1 ADRT.Acq_Deal_Rights_Title_Code from Acq_Deal_Rights_Title ADRT (NOLOCK)
				INNER JOIN Acq_Deal_Rights SDR (NOLOCK) ON ADRT.Acq_Deal_Rights_Code = SDR.Acq_Deal_Rights_Code
				WHERE SDR.Acq_Deal_Code = @Syn_Deal_Code AND ADRT.Title_Code = @Title_Code AND ADRT.Episode_From = @Episode_From AND ADRT.Episode_To = @Episode_To 
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Rights', 'Rights')	
			END
		
			IF EXISTS(
				SELECT TOP 1 ADAT.Acq_Deal_Ancillary_Title_Code from Acq_Deal_Ancillary_Title ADAT (NOLOCK)
				INNER JOIN Acq_Deal_Ancillary SDA (NOLOCK) ON ADAT.Acq_Deal_Ancillary_Code = SDA.Acq_Deal_Ancillary_Code
				WHERE SDA.Acq_Deal_Code = @Syn_Deal_Code AND ADAT.Title_Code = @Title_Code AND ADAT.Episode_From = @Episode_From AND ADAT.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Ancillary', 'Ancillary')	
			END

			IF EXISTS(
				SELECT TOP 1 ADRT.Acq_Deal_Run_Title_Code from Acq_Deal_Run_Title ADRT (NOLOCK)
				INNER JOIN Acq_Deal_Run SDR (NOLOCK) ON   ADRT.Acq_Deal_Run_Code = SDR.Acq_Deal_Run_Code
				WHERE SDR.Acq_Deal_Code = @Syn_Deal_Code AND ADRT.Title_Code = @Title_Code AND ADRT.Episode_From = @Episode_From AND ADRT.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Run', 'Run')	
			END

			IF EXISTS(
				SELECT TOP 1 ADPT.Acq_Deal_Pushback_Title_Code from Acq_Deal_Pushback_Title ADPT (NOLOCK)
				INNER JOIN Acq_Deal_Pushback SDR (NOLOCK) ON ADPT.Acq_Deal_Pushback_Code = SDR.Acq_Deal_Pushback_Code
				WHERE SDR.Acq_Deal_Code = @Syn_Deal_Code AND ADPT.Title_Code = @Title_Code AND ADPT.Episode_From = @Episode_From AND ADPT.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Pushback', 'Pushback')	
			END

			IF EXISTS(
				SELECT TOP 1 ADCT.Acq_Deal_Cost_Title_Code from Acq_Deal_Cost_Title ADCT (NOLOCK)
				INNER JOIN Acq_Deal_Cost SDR (NOLOCK) ON ADCT.Acq_Deal_Cost_Code = SDR.Acq_Deal_Cost_Code
				WHERE SDR.Acq_Deal_Code = @Syn_Deal_Code AND ADCT.Title_Code = @Title_Code AND ADCT.Episode_From = @Episode_From AND ADCT.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Cost', 'Cost')
			END

			IF EXISTS(
				SELECT TOP 1 ADST.Acq_Deal_Sport_Title_Code from Acq_Deal_Sport_Title ADST (NOLOCK)
				INNER JOIN Acq_Deal_Sport SDR (NOLOCK) ON   ADST.Acq_Deal_Sport_Code = SDR.Acq_Deal_Sport_Code
				WHERE SDR.Acq_Deal_Code = @Syn_Deal_Code AND ADST.Title_Code = @Title_Code AND ADST.Episode_From = @Episode_From AND ADST.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Sports', 'Sports')
			END

			IF EXISTS(
				SELECT ADSAT.Acq_Deal_Sport_Ancillary_Title_Code from Acq_Deal_Sport_Ancillary_Title ADSAT (NOLOCK)
				INNER JOIN Acq_Deal_Sport_Ancillary SDR (NOLOCK) ON   ADSAT.Acq_Deal_Sport_Ancillary_Code = SDR.Acq_Deal_Sport_Ancillary_Code
				WHERE SDR.Acq_Deal_Code = @Syn_Deal_Code AND ADSAT.Title_Code = @Title_Code AND ADSAT.Episode_From = @Episode_From AND ADSAT.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Sport ancillary', 'Sport ancillary')
			END
		
			IF EXISTS(
				SELECT TOP 1 ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Title_Code from Acq_Deal_Sport_Monetisation_Ancillary_Title ADSMA (NOLOCK)
				INNER JOIN Acq_Deal_Sport_Monetisation_Ancillary SDR (NOLOCK) ON   ADSMA.Acq_Deal_Sport_Monetisation_Ancillary_Code = SDR.Acq_Deal_Sport_Monetisation_Ancillary_Code
				WHERE SDR.Acq_Deal_Code = @Syn_Deal_Code AND ADSMA.Title_Code = @Title_Code AND ADSMA.Episode_From = @Episode_From AND ADSMA.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Sport monetisation ancillary', 'Sport monetisation ancillary')
			END

			IF EXISTS(
				SELECT  TOP 1 ADSSAT.Acq_Deal_Sport_Sales_Ancillary_Title_Code from Acq_Deal_Sport_Sales_Ancillary_Title ADSSAT (NOLOCK)
				INNER JOIN Acq_Deal_Sport_Sales_Ancillary SDR (NOLOCK) ON   ADSSAT.Acq_Deal_Sport_Sales_Ancillary_Code = SDR.Acq_Deal_Sport_Sales_Ancillary_Code
				WHERE SDR.Acq_Deal_Code = @Syn_Deal_Code AND ADSSAT.Title_Code = @Title_Code AND ADSSAT.Episode_From = @Episode_From AND ADSSAT.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Sport sales ancillary', 'Sport sales ancillary')
			END
		
			IF EXISTS(
				SELECT TOP 1 ADA.Acq_Deal_Attachment_Code from Acq_Deal_Attachment ADA (NOLOCK)
				WHERE ADA.Acq_Deal_Code = @Syn_Deal_Code AND ADA.Title_Code = @Title_Code AND ADA.Episode_From = @Episode_From AND ADA.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Attachment', 'Attachment')
			END
	    
			IF EXISTS(
				SELECT TOP 1 ADM.Acq_Deal_Material_Code from Acq_Deal_Material ADM (NOLOCK)
				WHERE ADM.Acq_Deal_Code = @Syn_Deal_Code AND ADM.Title_Code = @Title_Code AND ADM.Episode_From = @Episode_From AND ADM.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Material', 'Material')
			END
	   
			IF EXISTS(
				SELECT TOP 1 Acq_Deal_Code FROM Acq_Deal (NOLOCK) WHERE Master_Deal_Movie_Code_ToLink IN (SELECT Acq_Deal_Movie_Code FROM Acq_Deal_Movie (NOLOCK)
				WHERE Title_Code = @Title_Code AND Acq_Deal_Code  in (@Syn_Deal_Code))
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Sub deal', 'Sub deal')
			END
		
			IF EXISTS(
				SELECT TOP 1 ADB.Acq_Deal_Budget_Code from Acq_Deal_Budget ADB (NOLOCK)
				WHERE ADB.Acq_Deal_Code = @Syn_Deal_Code AND ADB.Title_Code = @Title_Code AND ADB.Episode_From = @Episode_From AND ADB.Episode_To = @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Budget', 'Budget')
			END
		
			IF EXISTS(
				SELECT TOP 1 SDM.Acq_Deal_Supplementary_Code from Acq_Deal_Supplementary SDM (NOLOCK)
				WHERE SDM.Acq_Deal_Code = @Syn_Deal_Code AND SDM.Title_Code = @Title_Code AND SDM.Episode_From = @Episode_From AND SDM.Episode_To = @Episode_To
			) 
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Supplementary', 'Supplementary')			
			END

			IF EXISTS( 
				SELECT * FROM (
					SELECT TCM.Title_Content_Code, COUNT(DISTINCT CML.Content_Music_Link_Code) AS Linked_Count, COUNT(DISTINCT TCM2.Title_Content_Mapping_Code) AS Deal_Count
					FROM  Acq_Deal_Movie ADM (NOLOCK)
					INNER JOIN Title_Content_Mapping TCM (NOLOCK) ON TCM.Acq_Deal_Movie_Code = ADM.Acq_Deal_Movie_Code
						AND ADM.Acq_Deal_Code = @Syn_Deal_Code AND ADM.Title_Code = @Title_Code 
						AND ADM.Episode_Starts_From = @Episode_From AND ADM.Episode_End_To = @Episode_To
					INNER JOIN  Content_Music_Link CML (NOLOCK) ON CML.Title_Content_Code = TCM.Title_Content_Code
					INNER JOIN Title_Content_Mapping TCM2 (NOLOCK) ON TCM2.Title_Content_Code = TCM.Title_Content_Code
					GROUP BY TCM.Title_Content_Code
				) AS A
				WHERE Linked_Count > 0 AND Deal_Count <= 1
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Music', 'Music')
			END

			IF EXISTS( 
			--	SELECT top 1 bst.BV_Schedule_Transaction_Code FROM BV_Schedule_Transaction BST
			--	INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = @Syn_Deal_Code
			--	where BST.Deal_Movie_Code = ADM.Acq_Deal_Movie_Code and BST.Title_Code = @Title_Code and BST.Program_Episode_Number between @Episode_From and @Episode_To
				SELECT top 1 bst.BV_Schedule_Transaction_Code FROM BV_Schedule_Transaction BST (NOLOCK)
				INNER JOIN Content_Channel_Run CCR (NOLOCK) ON CCR.Acq_Deal_Code = @Syn_Deal_Code
				where BST.Content_Channel_Run_Code = CCR.Content_Channel_Run_Code and BST.Title_Code = @Title_Code and BST.Program_Episode_Number between @Episode_From and @Episode_To
			)
			BEGIN
				SELECT @status = 'E', @tabNames = COALESCE(@tabNames + ', Schedule', 'Schedule')
			END
		END

		IF(@status = 'E')
			SET @tabNames = 'Can not delete this title as it is being used in ' + @tabNames
		
		SELECT  @status AS [Status], ISNULL(@tabNames, '') AS [Message]
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_General_Delete_For_Title]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END
