CREATE ProcEDURE [dbo].[USP_Get_Data_Restriction_Remark_UDT]
(
	@Deal_Rights Deal_Rights READONLY,
	@Deal_Rights_Title Deal_Rights_Title  READONLY,
	@Deal_Rights_Platform Deal_Rights_Platform READONLY,
	@Deal_Rights_Territory Deal_Rights_Territory READONLY,	
	@Deal_Rights_Subtitling Deal_Rights_Subtitling READONLY,
	@Deal_Rights_Dubbing Deal_Rights_Dubbing READONLY,
	@Debug CHAR(1)='N'
)
As
-- =============================================
-- Author:		Sagar Mahajan
-- Create date:	3 March 2015
-- Description:	(1) Call From Syn Save Rights.(2)Get distinct data For Restriction Remark and Sub Licensing Pop.
-- =============================================
BEGIN
	SET FMTONLY OFF
	SET NOCOUNT ON
	-- =============================================Delete Temp Tables =============================================

	IF OBJECT_ID('tempdb..#Temp_Rights_Title') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Rights_Title
	END
	IF OBJECT_ID('tempdb..#Temp_Rights_Platform') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Rights_Platform
	END
	IF OBJECT_ID('tempdb..#Temp_Rights_Country') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Rights_Country
	END
	IF OBJECT_ID('tempdb..#Temp_Rights_SubTitle') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Rights_SubTitle
	END
	IF OBJECT_ID('tempdb..#Temp_Rights_Dubb') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Rights_Dubb
	END
	
	IF OBJECT_ID('tempdb..#Temp_Restriction_Remark_Popup') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Restriction_Remark_Popup 
	END
	IF OBJECT_ID('tempdb..#Temp_Restriction_Remark_Popup') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Restriction_Remark_Popup 
	END
	IF OBJECT_ID('tempdb..#Temp_Selected_Region_Code') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Selected_Region_Code
	END
	IF OBJECT_ID('tempdb..#Temp_Selected_Lang_Code') IS NOT NULL
	BEGIN
		DROP TABLE #Temp_Selected_Lang_Code
	END
	IF OBJECT_ID('tempdb..#Acq_Rights_Code_Lang') IS NOT NULL
	BEGIN
		DROP TABLE #Acq_Rights_Code_Lang
	END
	
	
	-- =============================================Create Temp Tables =============================================	
	CREATE TABLE #Temp_Rights_Title
	(
		Deal_Rights_Code INT,
		Is_Theatrical_Right CHAR(1),
		Title_Code INT,
		Episode_From INT,
		Episode_To INT,
		Sub_License_Code INT,
		Is_Title_Language_Right CHAR(1),
		Restriction_Remarks NVARCHAR(4000)
	)
	CREATE TABLE #Temp_Rights_Platform
	(
		Deal_Rights_Code INT,
		Platform_Code INT		
	)
	CREATE TABLE #Temp_Rights_Country
	(
		Deal_Rights_Code INT,
		Country_Territory_Code INT
	)
	CREATE TABLE #Temp_Rights_SubTitle
	(
		Deal_Rights_Code INT,
		SubTitle_Lang_Code INT		
	)
	CREATE TABLE #Temp_Rights_Dubb
	(
		Deal_Rights_Code INT,
		Dubb_Lang_Code INT
	)
	CREATE TABLE #Temp_Restriction_Remark_Popup 
	(		
		Title_Name NVARCHAR(MAX),
		Platform_Name NVARCHAR(MAX),
		Country_Name NVARCHAR(MAX),
		Is_Title_Language_Right Varchar(3),
		SubTitle_Lang_Name NVARCHAR(MAX),
		Dubb_Lang_Name  NVARCHAR(MAX), 
		Restriction_Remarks NVARCHAR(MAX),
		SubLicensing NVARCHAR(100)	--Prior Approval OR No Restriction
	)
	CREATE TABLE #Acq_Rights_Code_Lang
	(
		Deal_Rights_Code INT
	)
	CREATE TABLE #Temp_Selected_Region_Code
	(
		Country_Code INT
	)
	CREATE TABLE  #Temp_Selected_Lang_Code
	(
		Lang_Code INT
	)	
	DECLARE @Count_SubTitle INT = 0,@Count_Dub INT = 0
	
    -- =============================================Declare Local Variables(Rights) =============================================						
	DECLARE @Right_Start_Date DATETIME,
			@Right_End_Date DATETIME,
			@Right_Type CHAR(1),			
			@Is_Title_Language_Right CHAR(1),			
			@Sub_License_Code INT,
			@Deal_Rights_Code INT,
			@Deal_Pushback_Code INT,						
			@Is_Theatrical_Right CHAR(1)			
	-- =============================================Assign Values To Local Variable =============================================	        
		SELECT 		
		@Deal_Rights_Code=dr.Deal_Rights_Code,
		@Right_Start_Date=dr.Right_Start_Date,
		@Right_End_Date=dr.Right_End_Date,
		@Right_Type=dr.Right_Type,		
		@Sub_License_Code=dr.Sub_License_Code,
		@Is_Title_Language_Right=dr.Is_Title_Language_Right,					
		@Is_Theatrical_Right=ISNULL(dr.Is_Theatrical_Right,'N')				
		FROM @Deal_Rights dr

		IF EXISTS(SELECT TOP 1 * FROM @Deal_Rights_Subtitling WHERE ISNULL(Subtitling_Code,0) > 0 OR ISNULL(Language_Group_Code,0) > 0)
			SET @Count_SubTitle = 1	
        IF EXISTS(SELECT TOP 1 * FROM @Deal_Rights_Dubbing WHERE ISNULL(Dubbing_Code,0) > 0 OR ISNULL(Language_Group_Code,0) > 0)
			SET @Count_Dub = 1		
	-- =============================================Insert Into Temp Tables ========================================		
		INSERT INTO  #Temp_Rights_Title
		(
			Deal_Rights_Code ,
			Is_Theatrical_Right,
			Title_Code ,
			Episode_From ,
			Episode_To ,
			Sub_License_Code ,
			Is_Title_Language_Right ,
			Restriction_Remarks
		)
		SELECT DISTINCT
		    ADR.Acq_Deal_Rights_Code ,
			ADR.Is_Theatrical_Right,
			ADRT.Title_Code ,
			DRT.Episode_From ,
			DRT.Episode_To ,
			ADR.Sub_License_Code ,
			ADR.Is_Title_Language_Right ,
			ADR.Restriction_Remarks
		FROM Acq_Deal AD
		INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code 
			AND ADR.Is_Sub_License='Y' AND ADR.Is_Tentative = 'N' 
		INNER JOIN Acq_Deal_Rights_Title ADRT ON  ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code 		
		INNER JOIN @Deal_Rights_Title DRT ON ADRT.Title_Code = DRT.Title_Code 
			AND 
			(
				(
					DRT.Episode_From  BETWEEN ADRT.Episode_From AND ADRT.Episode_To
					AND DRT.Episode_To BETWEEN ADRT.Episode_From AND ADRT.Episode_To
				)
				OR
				(
					ADRT.Episode_From  BETWEEN DRT.Episode_From AND DRT.Episode_To
					AND ADRT.Episode_To BETWEEN DRT.Episode_From AND DRT.Episode_To
				)
			)
		WHERE 1 =1 AND  AD.Deal_Workflow_Status NOT IN ('AR', 'WA')		
		AND 
		( 	
			(
				(ADR.Right_Type ='Y'  OR ADR.Right_Type ='M')
				AND
				(
					(
					CONVERT(DATETIME, @Right_Start_Date, 103)  BETWEEN 
					CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103) 
					AND Convert(DATETIME, ADR.Actual_Right_End_Date, 103)										
					)			
					OR
					(
					CONVERT(DATETIME, @Right_End_Date, 103)   BETWEEN 
					CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103) 
					AND CONVERT(DATETIME, ADR.Actual_Right_End_Date, 103)
					)
					OR
					(
					CONVERT(DATETIME, ADR.Actual_Right_Start_Date, 103)   BETWEEN 
					CONVERT(DATETIME, @Right_Start_Date, 103) 
					AND CONVERT(DATETIME, @Right_End_Date, 103)
					)
					OR
					(
					CONVERT(DATETIME, ADR.Actual_Right_End_Date, 103)    BETWEEN 
					CONVERT(DATETIME, @Right_Start_Date, 103) 
					AND CONVERT(DATETIME, @Right_End_Date, 103)
					)
				)
			)
			OR
			(
				ADR.Right_Type ='U' 							
			)
		)
		--AND ((ADR.Is_Title_Language_Right = @Is_Title_Language_Right AND @Is_Title_Language_Right <> 'N') OR @Is_Title_Language_Right = 'N')

		INSERT INTO  #Temp_Rights_Platform
		(
			Deal_Rights_Code,
			Platform_Code 		
		)		
		SELECT DISTINCT 
			ADRP.Acq_Deal_Rights_Code,ADRP.Platform_Code 
		FROM Acq_Deal_Rights_Platform ADRP
		INNER JOIN #Temp_Rights_Title TRT ON ADRP.Acq_Deal_Rights_Code = TRT.Deal_Rights_Code
		INNER JOIN @Deal_Rights_Platform DRP ON ADRP.Platform_Code = DRP.Platform_Code

		 DELETE TRT FROM  #Temp_Rights_Title TRT  
		 WHERE TRT.Deal_Rights_Code NOT IN(SELECT  DISTINCT TRP.Deal_Rights_Code FROM  #Temp_Rights_Platform TRP)

		INSERT INTO #Temp_Selected_Region_Code(Country_Code)
		SELECT DISTINCT
			CASE 
				WHEN DRT.Territory_Type ='G' THEN TD.Country_Code ELSE DRT.Country_Code
			END 
		AS Country_Code 
		FROM @Deal_Rights_Territory DRT
		LEFT JOIN Territory_Details TD ON DRT.Territory_Code = TD.Territory_Code  			
		INSERT INTO #Temp_Rights_Country
		(
			Deal_Rights_Code,
			Country_Territory_Code 
		)
		SELECT DISTINCT
			ADRT.Acq_Deal_Rights_Code,
			TSRC.Country_Code
		FROM Acq_Deal_Rights_Territory  ADRT
		INNER JOIN #Temp_Selected_Region_Code TSRC ON 
			ADRT.Country_Code = TSRC.Country_Code 
			OR 
			(
				@Is_Theatrical_Right = 'Y' AND 
				(
					ADRT.Country_Code IN
					(
						SELECT C.Parent_Country_Code FROM Country C WHERE C.Country_Code=TSRC.Country_Code
					)
				)
			)
			OR
			TSRC.Country_Code IN
			(
				SELECT CC.Country_Code FROM 
				(
					SELECT DISTINCT c.Country_Code	
					FROM  Country C
					INNER JOIN Territory_Details TD ON C.Country_Code = TD.Country_Code
					WHERE TD.Territory_Code = ADRT.Territory_Code 
						AND ((C.Is_Domestic_Territory = 'Y' AND @Is_Theatrical_Right = 'Y') OR @Is_Theatrical_Right = 'N')
				) AS tbl 
				INNER JOIN Country CC ON CC.Country_Code = tbl.Country_Code OR (CC.Parent_Country_Code = tbl.Country_Code AND  @Is_Theatrical_Right = 'Y')
			)
		WHERE ADRT.Acq_Deal_Rights_Code IN
		(
			SELECT TRT.Deal_Rights_Code FROM #Temp_Rights_Title  TRT
		)
		
		DELETE TRP FROM #Temp_Rights_Platform TRP
		WHERE TRP.Deal_Rights_Code NOT IN(SELECT DISTINCT TRC.Deal_Rights_Code FROM   #Temp_Rights_Country TRC)
		
		DELETE TRT FROM  #Temp_Rights_Title TRT  
		WHERE TRT.Deal_Rights_Code NOT IN(SELECT  DISTINCT TRP.Deal_Rights_Code FROM  #Temp_Rights_Platform TRP)

		IF(@Count_SubTitle > 0)
		BEGIN
			INSERT INTO #Temp_Selected_Lang_Code(Lang_Code)
			SELECT DISTINCT 
				CASE WHEN DRS.Language_Type ='G' THEN LGD.Language_Code  ELSE DRS.Subtitling_Code END AS Lang_Code
			FROM  @Deal_Rights_Subtitling DRS
			LEFT JOIN Language_Group_Details LGD  ON DRS.Language_Group_Code =  LGD.Language_Group_Code

			INSERT INTO #Temp_Rights_SubTitle
			(
				Deal_Rights_Code ,
				SubTitle_Lang_Code 
			)
			SELECT Acq_Deal_Rights_Code,Sub_Lang_Code FROM 
			(
				SELECT DISTINCT
					ADRS.Acq_Deal_Rights_Code,				
					CASE WHEN ADRS.Language_Type ='G' THEN LGD.Language_Code  ELSE ADRS.Language_Code END AS Sub_Lang_Code
				FROM Acq_Deal_Rights_Subtitling ADRS
				LEFT JOIN Language_Group_Details LGD ON ADRS.Language_Group_Code = LGD.Language_Group_Code 										
				WHERE ADRS.Acq_Deal_Rights_Code IN
				(
					SELECT DISTINCT DRT.Deal_Rights_Code FROM   #Temp_Rights_Title DRT
				)
			) AS tbl WHERE tbl.Sub_Lang_Code IN
			(
				SELECT Lang_Code FROM #Temp_Selected_Lang_Code
			)
		END

		IF(@Count_Dub > 0)
		BEGIN
			TRUNCATE TABLE #Temp_Selected_Lang_Code

			INSERT INTO #Temp_Selected_Lang_Code(Lang_Code)
			SELECT DISTINCT
				CASE WHEN DRD.Language_Type ='G' THEN LGD.Language_Code  ELSE DRD.Dubbing_Code END AS Lang_Code
			FROM  @Deal_Rights_Dubbing DRD
			LEFT JOIN Language_Group_Details LGD ON DRD.Language_Group_Code =  LGD.Language_Group_Code

			INSERT INTO #Temp_Rights_Dubb
			(
				Deal_Rights_Code ,
				Dubb_Lang_Code 
			)
			SELECT Acq_Deal_Rights_Code,Dubb_Lang_Code FROM 
			(
				SELECT DISTINCT
					ADRD.Acq_Deal_Rights_Code,					
					CASE WHEN ADRD.Language_Type ='G' THEN LGD.Language_Code  ELSE ADRD.Language_Code END  AS Dubb_Lang_Code
				FROM Acq_Deal_Rights_Dubbing ADRD 			
				LEFT JOIN Language_Group_Details LGD ON ADRD.Language_Group_Code = LGD.Language_Group_Code 										
				WHERE ADRD.Acq_Deal_Rights_Code IN
				(
					SELECT DISTINCT DRT.Deal_Rights_Code FROM  #Temp_Rights_Title DRT
				)
			) AS tbl WHERE tbl.Dubb_Lang_Code IN
			(
				SELECT Lang_Code FROM #Temp_Selected_Lang_Code
			)			

		END				
		IF(@Count_Dub = 0 AND @Count_SubTitle = 0)
			DELETE  FROM #Temp_Rights_Title WHERE Is_Title_Language_Right = 'N'		
		ELSE --means IF(@Count_Dub > 0 OR @Count_SubTitle > 0)
			BEGIN
				INSERT INTO #Acq_Rights_Code_Lang
				SELECT 
					Deal_Rights_Code 
				FROM #Temp_Rights_Title
				WHERE Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y'
				UNION
				SELECT 
					Deal_Rights_Code 
				FROM #Temp_Rights_SubTitle
				UNION
				SELECT 
					Deal_Rights_Code 
				FROM #Temp_Rights_Dubb

				DELETE TRC FROM #Temp_Rights_Country TRC
				WHERE TRC.Deal_Rights_Code NOT IN(SELECT DISTINCT TRD.Deal_Rights_Code FROM  #Acq_Rights_Code_Lang TRD)

				DELETE TRP FROM #Temp_Rights_Platform TRP
				WHERE TRP.Deal_Rights_Code NOT IN(SELECT DISTINCT TRC.Deal_Rights_Code FROM   #Acq_Rights_Code_Lang TRC)
		
				DELETE TRT FROM  #Temp_Rights_Title TRT  
				WHERE TRT.Deal_Rights_Code NOT IN(SELECT  DISTINCT TRP.Deal_Rights_Code FROM  #Acq_Rights_Code_Lang TRP)
			END

		DECLARE @Cur_Rights_Code INT,@Deal_Type_Code INT				
		SET @Cur_Rights_Code = 0
		SET @Deal_Type_Code = 0

		BEGIN 
			DECLARE CR_Rights_Data CURSOR                   
			FOR               
				SELECT DISTINCT 		
					TRT.Deal_Rights_Code
				FROM #Temp_Rights_Title TRT				
			OPEN CR_Rights_Data             
			FETCH NEXT FROM CR_Rights_Data INTO  @Cur_Rights_Code
			WHILE @@FETCH_STATUS<>-1             
			BEGIN            
				IF(@@FETCH_STATUS<>-2)                                                          
				BEGIN 
					DECLARE @PName NVARCHAR(MAX) = '',@TName NVARCHAR(MAX) = '',@Res_Remarks NVARCHAR(MAX)=''
					,@Sub_Lang_Name NVARCHAR(MAX)='',@Dubb_Lang_Name NVARCHAR(MAX)=''
					,@Country_Territory_Name NVARCHAR(MAX) = '',@SubLicnesing NVARCHAR(100)=''					

					IF(@Deal_Type_Code=0)
						SELECT 
							@Deal_Type_Code = Deal_Type_Code
						FROM Acq_Deal WHERE  Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = (SELECT TOP 1 Acq_Deal_Code FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Cur_Rights_Code)

						SELECT  @TName = STUFF(( SELECT  DISTINCT ',' +  tbl.Title_Name
						 FROM 
							(
								SELECT dbo.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](@Deal_Type_Code), T.Title_Name, TARC.Episode_From, TARC.Episode_To) As Title_Name
								FROM Title T								
								INNER JOIN #Temp_Rights_Title TARC ON T.Title_Code = TARC.Title_Code						
								WHERE TARC.Deal_Rights_Code = @Cur_Rights_Code												
							) as tbl
						FOR XML PATH('')), 1, 1, '') 
												
						SELECT @PName= STUFF(( SELECT  DISTINCT  ',' +  CAST(TARP.Platform_Code AS VARCHAR) 					
						FROM #Temp_Rights_Platform TARP						
						WHERE TARP.Deal_Rights_Code = @Cur_Rights_Code					
						FOR XML PATH('')), 1, 1, '')
						
						--USP_Get_Platform_With_Parent
						SELECT @PName= STUFF(( Select ', ' + '(' + CAST(ROW_NUMBER() over (ORDER BY Platform_Hiearachy) AS VARCHAR) + ')' + Platform_Hiearachy 
						From [dbo].[UFN_Get_Platform_With_Parent](@PName)
						FOR XML PATH(''), root('Platform_Hiearachy'), type 
     ).value('/Platform_Hiearachy[1]','varchar(max)'), 1, 1, '') 

						IF EXISTS(SELECT TOP 1 Territory_Code FROM @Deal_Rights_Territory  WHERE Territory_Type = 'G' )
						BEGIN
							SELECT  @Country_Territory_Name = STUFF(( SELECT  DISTINCT ', ' +   T.Territory_Name 
							FROM Territory T 
							INNER JOIN Territory_Details TD ON T.Territory_Code = TD.Territory_Code
								AND TD.Territory_Code IN(SELECT Territory_Code FROM @Deal_Rights_Territory)
							WHERE TD.Country_Code IN
							(
								SELECT TRC.Country_Territory_Code  FROM  #Temp_Rights_Country TRC WHERE
								TRC.Deal_Rights_Code = @Cur_Rights_Code
							)
							FOR XML PATH('')), 1, 1, '') 
						END
						ELSE 
						BEGIN
							SELECT DISTINCT @Country_Territory_Name =STUFF(( SELECT  DISTINCT ', ' +  C.Country_Name
							FROM Country C 
							INNER JOIN #Temp_Rights_Country TRC ON C.Country_Code = TRC.Country_Territory_Code
							WHERE TRC.Deal_Rights_Code = @Cur_Rights_Code
							FOR XML PATH('')), 1, 1, '') 
						END		

						IF(@Count_SubTitle > 0)
						BEGIN
							IF EXISTS(SELECT TOP 1 DRS.Language_Group_Code FROM @Deal_Rights_Subtitling DRS  WHERE Language_Type = 'G')							
								SELECT @Sub_Lang_Name= STUFF(( SELECT  DISTINCT ', ' +  LG.Language_Group_Name
								FROM  Language_Group  LG								
								INNER JOIN  Language_Group_Details  LGD ON LG.Language_Group_Code = LGD.Language_Group_Code
									 AND LG.Language_Group_Code IN(SELECT DRS.Language_Group_Code FROM @Deal_Rights_Subtitling DRS)
								WHERE LGD.Language_Code IN
								(
									SELECT TRS.SubTitle_Lang_Code FROM  #Temp_Rights_SubTitle  TRS 
									WHERE TRS.Deal_Rights_Code = @Cur_Rights_Code					
								)
								FOR XML PATH('')), 1, 1, '') 
							ELSE
								SELECT @Sub_Lang_Name= STUFF(( SELECT  DISTINCT ', ' +  L.Language_Name  					
								FROM  Language  L
								INNER JOIN #Temp_Rights_SubTitle TRS ON L.Language_Code = TRS.SubTitle_Lang_Code						
								WHERE TRS.Deal_Rights_Code = @Cur_Rights_Code					
								FOR XML PATH('')), 1, 1, '') 					
						END
					

						IF(@Count_Dub > 0)
						BEGIN
							IF EXISTS(SELECT TOP 1 DRD.Language_Group_Code FROM @Deal_Rights_Dubbing DRD  WHERE Language_Type = 'G' )							
								SELECT @Dubb_Lang_Name= STUFF(( SELECT  DISTINCT ', ' +  LG.Language_Group_Name
								FROM  Language_Group  LG								
								INNER JOIN  Language_Group_Details  LGD ON LG.Language_Group_Code = LGD.Language_Group_Code
									 AND LG.Language_Group_Code IN(SELECT DRD.Language_Group_Code FROM @Deal_Rights_Dubbing DRD)
								WHERE LGD.Language_Code IN
								(
									SELECT TRD.Dubb_Lang_Code FROM  #Temp_Rights_Dubb  TRD 
									WHERE TRD.Deal_Rights_Code = @Cur_Rights_Code					
								)
								FOR XML PATH('')), 1, 1, '') 
							ELSE
								SELECT @Dubb_Lang_Name= STUFF(( SELECT  DISTINCT ', ' +  L.Language_Name  					
								FROM  Language  L
								WHERE L.Language_Code IN
								(
									SELECT TRD.Dubb_Lang_Code FROM  #Temp_Rights_Dubb  TRD
									WHERE TRD.Deal_Rights_Code = @Cur_Rights_Code					
								)
								FOR XML PATH('')), 1, 1, '') 
						END

						SELECT DISTINCT @Res_Remarks=ISNULL(Restriction_Remarks,'') FROM 
						#Temp_Rights_Title	TRT				
						WHERE TRT.Deal_Rights_Code = @Cur_Rights_Code
					
						SELECT @SubLicnesing = 
							CASE   TRT.Sub_License_Code 										
								WHEN 2 THEN 'Prior Approval is required to sublicensing these Rights'
								WHEN 3 THEN 'Prior Notice is required to sublicensing these Rights'
								ELSE 'No Restriction'
							END
						FROM #Temp_Rights_Title  TRT 
						WHERE TRT.Deal_Rights_Code = @Cur_Rights_Code
						
						INSERT INTO #Temp_Restriction_Remark_Popup
						(				
							Title_Name,			
							Platform_Name,
							Country_Name,
							Is_Title_Language_Right,
							SubTitle_Lang_Name,
							Dubb_Lang_Name,
							Restriction_Remarks,
							SubLicensing						
						)
						SELECT 
							@TName,@PName,@Country_Territory_Name
							,CASE  @Is_Title_Language_Right
							WHEN 'Y' THEN 'Yes'
							ELSE 'No'
							END
							,@Sub_Lang_Name,@Dubb_Lang_Name,@Res_Remarks,@SubLicnesing
					IF(@Is_Title_Language_Right='N' AND ISNULL(@Sub_Lang_Name,'')='' AND ISNULL(@Dubb_Lang_Name,'') = '')
						DELETE FROM #Temp_Restriction_Remark_Popup 
						WHERE Is_Title_Language_Right = 'No' AND ISNULL(SubTitle_Lang_Name,'')= '' AND ISNULL(Dubb_Lang_Name,'') =''
				END            
			FETCH NEXT FROM CR_Rights_Data INTO   @Cur_Rights_Code
			END                                                       
			CLOSE CR_Rights_Data            
			DEALLOCATE CR_Rights_Data			
		END

		IF(@Debug='D')
		BEGIN
			SELECT * FROM #Temp_Rights_Title
			SELECT * FROM @Deal_Rights_Platform
			SELECT * FROM #Temp_Rights_Platform
			SELECT * FROM #Temp_Rights_Country
			SELECT * FROM #Temp_Rights_SubTitle
			SELECT * FROM #Temp_Rights_Dubb		
			SELECT * FROM #Acq_Rights_Code_Lang	
		END

		SELECT * FROM #Temp_Restriction_Remark_Popup

	-- =============================================Drop Temp Tables ========================================
		--DROP TABLE #Temp_Rights_Title
		--DROP TABLE #Temp_Rights_Platform	
		--DROP TABLE #Temp_Rights_Country	
		--DROP TABLE #Temp_Rights_SubTitle
		--DROP TABLE #Temp_Rights_Dubb	
		--DROP TABLE #Temp_Restriction_Remark_Popup		
		--DROP TABLE #Acq_Rights_Code_Lang
		--DROP TABLE #Temp_Selected_Lang_Code
		--DROP TABLE #Temp_Selected_Region_Code		

	IF OBJECT_ID('tempdb..#Acq_Rights_Code_Lang') IS NOT NULL DROP TABLE #Acq_Rights_Code_Lang
	IF OBJECT_ID('tempdb..#Temp_Restriction_Remark_Popup') IS NOT NULL DROP TABLE #Temp_Restriction_Remark_Popup
	IF OBJECT_ID('tempdb..#Temp_Rights_Country') IS NOT NULL DROP TABLE #Temp_Rights_Country
	IF OBJECT_ID('tempdb..#Temp_Rights_Dubb') IS NOT NULL DROP TABLE #Temp_Rights_Dubb
	IF OBJECT_ID('tempdb..#Temp_Rights_Platform') IS NOT NULL DROP TABLE #Temp_Rights_Platform
	IF OBJECT_ID('tempdb..#Temp_Rights_SubTitle') IS NOT NULL DROP TABLE #Temp_Rights_SubTitle
	IF OBJECT_ID('tempdb..#Temp_Rights_Title') IS NOT NULL DROP TABLE #Temp_Rights_Title
	IF OBJECT_ID('tempdb..#Temp_Selected_Lang_Code') IS NOT NULL DROP TABLE #Temp_Selected_Lang_Code
	IF OBJECT_ID('tempdb..#Temp_Selected_Region_Code') IS NOT NULL DROP TABLE #Temp_Selected_Region_Code
END