alter PROCEDURE [dbo].[USP_Validate_Title_Talent_UDT]
(		
	@Title_Talent_Role Title_Talent_Role READONLY,
	@CallFrom  CHAR(1) 
)	
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 19 March 2015
-- Description: Call From Save Title(Title Master) Validate Talent (Star Cast ,Director and Producer etc.) IF  Sub Deal of Talent is Exist
-- =============================================
BEGIN	
	SET FMTONLY OFF
	CREATE TABLE #Temp 
	(
		Talent_Code INT,
		Role_Code INT
	)
	-- ==============================DELETE Temp Tables =============================================
	IF OBJECT_ID('tempdb..#Sub_Deal_Title_Code') IS NOT NULL
	BEGIN
		DROP TABLE #Sub_Deal_Title_Code
	END
	IF OBJECT_ID('tempdb..#Sub_Deal_Talent_Code') IS NOT NULL
	BEGIN
		DROP TABLE #Sub_Deal_Talent_Code
	END
	-- =============================Delcare Local Variable============================================	
	DECLARE @Title_Code INT =0,@Master_Deal_Movie_Code VARCHAR(1000) = ''
	SELECT 
		TOP 1 @Title_Code = Title_Code 
	FROM @Title_Talent_Role		
	-- ==========================================================================================
	
	SELECT 
		@Master_Deal_Movie_Code =STUFF(( SELECT  DISTINCT ',' +  CAST(ADM.Acq_Deal_Movie_Code AS VARCHAR) 					
	FROM Acq_Deal_Movie ADM
	WHERE ADM.Title_Code = @Title_Code
	FOR XML PATH('')), 1, 1, '') 

	IF(@Master_Deal_Movie_Code <> '')
	BEGIN
		SELECT 
			ADM.Title_Code,AD.Deal_Type_Code INTO #Sub_Deal_Title_Code 
		FROM Acq_Deal AD 
		INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
		AND AD.Deal_Type_Code IN(SELECT DISTINCT Deal_Type_Code FROM [Role] WHERE Role_Code IN(SELECT DISTINCT Role_Code FROM @Title_Talent_Role))
		WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND  AD.Master_Deal_Movie_Code_ToLink IN
		(
			SELECT number FROM fn_Split_withdelemiter(@Master_Deal_Movie_Code,',')
		)
		AND ISNULL(AD.Master_Deal_Movie_Code_ToLink,0) > 0 AND ISNULL(AD.Is_Master_Deal,'') <> 'Y'

		SELECT DISTINCT 
			 T.Reference_Key ,R.Role_Code
		INTO #Sub_Deal_Talent_Code
		FROM #Sub_Deal_Title_Code SDTC 
		INNER JOIN Title T ON  SDTC.Title_Code = T.Title_Code AND T.Deal_Type_Code = SDTC.Deal_Type_Code	
		INNER JOIN [Role] R ON R.Deal_Type_Code = SDTC.Deal_Type_Code AND R.Role_Code IN(SELECT DISTINCT Role_Code FROM @Title_Talent_Role)
		WHERE ISNULL(T.Reference_Flag,'') = 'T'

		IF(@CallFrom = 'S')
			INSERT INTO #Temp(Talent_Code,Role_Code)
			SELECT 
				  SDTC.Reference_Key,SDTC.Role_Code
			FROM #Sub_Deal_Talent_Code SDTC					
			WHERE SDTC.Reference_Key NOT IN
			(
				SELECT Talent_Code FROM @Title_Talent_Role TTR
				WHERE 1 =1 AND TTR.Role_Code = SDTC.Role_Code
			)
		ELSE	--(if Call From Row Data Bound ) 
			INSERT INTO #Temp(Talent_Code,Role_Code)
			SELECT 
				  SDTC.Reference_Key,SDTC.Role_Code
			FROM #Sub_Deal_Talent_Code SDTC					
			WHERE SDTC.Reference_Key  IN
			(
				SELECT Talent_Code FROM @Title_Talent_Role TTR
				WHERE 1 =1 AND TTR.Role_Code = SDTC.Role_Code
			)

		DROP TABLE #Sub_Deal_Title_Code
		DROP TABLE #Sub_Deal_Talent_Code		
	END

	SELECT Talent_Code,Role_Code
	FROM #Temp
	DROP TABLE #Temp
END