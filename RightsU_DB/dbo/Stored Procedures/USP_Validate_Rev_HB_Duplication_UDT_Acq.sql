CREATE PROCEDURE [dbo].[USP_Validate_Rev_HB_Duplication_UDT_Acq]
(
	@Deal_Rights Deal_Rights READONLY,
	@Deal_Rights_Title Deal_Rights_Title  READONLY,
	@Deal_Rights_Platform Deal_Rights_Platform READONLY,
	@Deal_Rights_Territory Deal_Rights_Territory READONLY,
	@Deal_Rights_Subtitling Deal_Rights_Subtitling READONLY,
	@Deal_Rights_Dubbing Deal_Rights_Dubbing READONLY,
	@Debug CHAR(1)='D'
)
As
Begin
	Declare @Loglevel int  
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Rev_HB_Duplication_UDT_Acq]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		--DECLARE 
			--	@Deal_Rights Deal_Rights ,
			--	@Deal_Rights_Title Deal_Rights_Title  ,
			--	@Deal_Rights_Platform Deal_Rights_Platform ,
			--	@Deal_Rights_Territory Deal_Rights_Territory ,
			--	@Deal_Rights_Subtitling Deal_Rights_Subtitling ,
			--	@Deal_Rights_Dubbing Deal_Rights_Dubbing ,
			--	@Debug CHAR(1)='D'

			SET FMTONLY OFF
			SET NOCOUNT ON
			BEGIN /*Delete temp table if exists */
				IF OBJECT_ID('tempdb..#Acq_Deal_Pushback') IS NOT NULL
				BEGIN
					DROP TABLE #Acq_Deal_Pushback
				END
				IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Title') IS NOT NULL
				BEGIN
					DROP TABLE #Acq_Deal_Pushback_Title
				END
				IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Territory') IS NOT NULL
				BEGIN
					DROP TABLE #Acq_Deal_Pushback_Territory
				END
				IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Platform') IS NOT NULL
				BEGIN
					DROP TABLE #Acq_Deal_Pushback_Platform
				END
				IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Subtitling') IS NOT NULL
				BEGIN
					DROP TABLE #Acq_Deal_Pushback_Subtitling
				END
				IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Dubbing') IS NOT NULL
				BEGIN
					DROP TABLE #Acq_Deal_Pushback_Dubbing
				END
				IF OBJECT_ID('tempdb..#TempDupComb') IS NOT NULL
				BEGIN
					DROP TABLE #TempDupComb
				END
				
				IF OBJECT_ID('tempdb..#Dup_Records_Language1') IS NOT NULL
				BEGIN
					DROP TABLE #Dup_Records_Language1	
				END			
				IF OBJECT_ID('tempdb..#Dup_Records_Language') IS NOT NULL
				BEGIN
					DROP TABLE #Dup_Records_Language	
				END			
	
				IF OBJECT_ID('tempdb..#Deal_Rights_Territory') IS NOT NULL
				BEGIN
					DROP TABLE #Deal_Rights_Territory
				END
	
				IF OBJECT_ID('tempdb..#Acq_Rights_Code_Lang') IS NOT NULL
				BEGIN
					DROP TABLE #Acq_Rights_Code_Lang
				END
				IF OBJECT_ID('tempdb..#Deal_Rights_Subtitling') IS NOT NULL
				BEGIN
					DROP TABLE #Deal_Rights_Subtitling
				END
				IF OBJECT_ID('tempdb..#Deal_Rights_Dubbing') IS NOT NULL
				BEGIN
					DROP TABLE #Deal_Rights_Dubbing
				END
				IF OBJECT_ID('tempdb..#ACQ_RIGHTS_NEW') IS NOT NULL
				BEGIN
					DROP TABLE #ACQ_RIGHTS_NEW
				END
			
			
			END
			Create table #Deal_Rights_Territory
			(
				Deal_Rights_Code int,
				Territory_Type char(2),
				Territory_Code int,
				Country_Code int
			)
			Create table #Deal_Rights_Subtitling
			(
					Deal_Rights_Code int 
					,Language_Type varchar(100)
					,Language_Group_Code int 
					,Subtitling_Code int
			)
			
			Create table #Deal_Rights_Dubbing
			(
					Deal_Rights_Code int 
					,Language_Type varchar(100)
					,Language_Group_Code int 
					,Dubbing_Code int
			)
			create table #Acq_Rights_Code_Lang
			(
				Deal_Rights_Code int
			)
			--FOR UDT TESTING
			--INSERT INTO @Deal_Rights (Deal_Rights_Code,Deal_Code,Is_Exclusive,Is_Title_Language_Right,Is_Sub_License
			--,Sub_License_Code
			--,Is_Theatrical_Right
			--,Right_Type,Is_Tentative,Term,Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type
			--,Is_ROFR
			--,Restriction_Remarks,
			--Right_Start_Date,Right_End_Date,Platform_Code,Title_Code,Check_For)
			--SELECT 0,22678,null,'Y',null,null,null,'Y',null,'',null,null,null,null,null,Convert(DateTime,'01JUL2021', 103) ,Convert(DateTime,'31JUL2021', 103),0,37549,null

			--INSERT INTO @Deal_Rights_Title (Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
			--SELECT 0,37549,1,1
			--SELECT * FROM @Deal_Rights_Title

			--INSERT INTO @Deal_Rights_Platform(Deal_Rights_Code,Platform_Code)
			--VALUES (0,1),(0,209),(0,210),(0,394) 

			--SELECT * FROM @Deal_Rights_Platform

			--INSERT INTO @Deal_Rights_Territory (Deal_Rights_Code,Territory_Type,Territory_Code,Country_Code)
			--SELECT 0,'G',1066,0
			--SELECT * FROM @Deal_Rights_Territory

			--INSERT INTO @Deal_Rights_Subtitling(Deal_Rights_Code,Language_Type,Language_Group_Code,Subtitling_Code)
			--VALUES  (0,'L',0,24 ),(0,'L',0,135)
			--SELECT * FROM @Deal_Rights_Subtitling

			--INSERT INTO @Deal_Rights_Dubbing(Deal_Rights_Code,Language_Type,Language_Group_Code,Dubbing_Code)
			--VALUES (0,'L',0,1143),(0,'L',0,24)

			--SELECT * FROM @Deal_Rights_Dubbing

			--SELECT 1 AS X
			--INSERT INTO Deal_Rights_Title()
			--SELECT 


			----SELECT 0,16545,null,null,null,null,null,'N',null,null,null,1,null,null,null,'Y',null,'',31241,null
			--SELECT * FroM @Deal_Rights
			DECLARE @ValidatePUSHBACK_YN CHAR(1),@SKIP_PUSHBACK CHAR(1)='N',@Is_Country_Domestic char(1),@Is_Platform_Thetrical char(1)
	
			set @Is_Country_Domestic = 'N'
			set @Is_Platform_Thetrical= 'N'
	
			SELECT @ValidatePUSHBACK_YN=  Parameter_Value FROM System_Parameter_New WHERE Parameter_NAME='Pushback_Validation_YN'

    

			--IF(@ValidatePUSHBACK_YN='N') 
			--BEGIN
			--	IF(@CallFrom='AP')	RETURN
			--	ELSE SET  @SKIP_PUSHBACK='Y'
			--END
	
			IF(EXISTS (select * from @Deal_Rights_Territory where Territory_Type = 'G' AND ISNULL(Country_Code,0) = 0 ))
			BEGIN
				insert into #Deal_Rights_Territory (Deal_Rights_Code,Territory_Type,Territory_Code,Country_Code)
				select td.Deal_Rights_Code, 'I' Territory_Type, 0 Territory_Code, TGD.Country_Code from @Deal_Rights_Territory TD
				inner join Territory_Details TGD (NOLOCK)  on TGD.Territory_Code = TD.Territory_Code
				inner join Country C (NOLOCK)  on C.Country_Code = TGD.Country_Code
			END
			ELSE
			BEGIN
				insert into #Deal_Rights_Territory (Deal_Rights_Code,Territory_Type,Territory_Code,Country_Code)
				select td.Deal_Rights_Code,td.Territory_Type,td.Territory_Code,td.Country_Code From @Deal_Rights_Territory TD
			END
	
			IF (EXISTS (select  Country_Code from Country (NOLOCK)  where Country_Code in  (select Country_Code from #Deal_Rights_Territory)
								AND (Is_Domestic_Territory='Y' )
			 ))
			BEGIN
				set @Is_Country_Domestic = 'Y'
			END
			IF (EXISTS (select Platform_Code from Platform (NOLOCK)  where Applicable_For_Demestic_Territory = 'Y'))
			BEGIN
				set @Is_Platform_Thetrical = 'Y'
			END
	
			
			IF(EXISTS (select * from @Deal_Rights_Subtitling where Language_Type = 'G' AND ISNULL(Subtitling_Code,0) = 0 ))
			BEGIN
				insert into #Deal_Rights_Subtitling (Deal_Rights_Code,Language_Type,Language_Group_Code,Subtitling_Code)
				select Distinct s.Deal_Rights_Code,'L' Language_Type,0 Language_Group_Code, lgd.Language_Code from @Deal_Rights_Subtitling s
				inner join Language_Group_Details LGD (NOLOCK)  on LGD.Language_Group_Code = s.Language_Group_Code
				--inner join Country C on C.Country_Code = TGD.Country_Code
			END
			ELSE
			BEGIN
				insert into #Deal_Rights_Subtitling (Deal_Rights_Code,Language_Type,Language_Group_Code,Subtitling_Code)
				select Distinct s.Deal_Rights_Code, Language_Type, Language_Group_Code, s.Subtitling_Code  from @Deal_Rights_Subtitling s
			END
		
			IF(EXISTS (select * from @Deal_Rights_Dubbing where Language_Type = 'G' AND ISNULL(Dubbing_Code,0) = 0 ))
			BEGIN
				insert into #Deal_Rights_Dubbing (Deal_Rights_Code,Language_Type,Language_Group_Code,Dubbing_Code)
				select Distinct s.Deal_Rights_Code,'L' Language_Type,0 Language_Group_Code, lgd.Language_Code from @Deal_Rights_Dubbing s
				inner join Language_Group_Details LGD (NOLOCK)  on LGD.Language_Group_Code = s.Language_Group_Code
				--inner join Country C on C.Country_Code = TGD.Country_Code
			END
			ELSE
			BEGIN
				insert into #Deal_Rights_Dubbing (Deal_Rights_Code,Language_Type,Language_Group_Code,Dubbing_Code)
				select Distinct s.Deal_Rights_Code, Language_Type, Language_Group_Code, s.Dubbing_Code  from @Deal_Rights_Dubbing s
			END
				
			BEGIN /*Create temp table*/
			
			
			Create table #Acq_Deal_Pushback_Subtitling
			(
				Acq_Deal_Pushback_Code int 
				,Language_Type varchar(100)
				,Language_Group_Code int 
				,Language_Code int
			)
			
			Create table #Acq_Deal_Pushback_Dubbing
			(
				Acq_Deal_Pushback_Code int 
				,Language_Type varchar(100)
				,Language_Group_Code int 
				,Language_Code int
			)
			END
	
			BEGIN /*Declare variables*/
			DECLARE @Right_Start_Date DATETIME,
					@Right_End_Date DATETIME,
					@Right_Type CHAR(1),
					@Is_Exclusive CHAR(1),
					@Is_Title_Language_Right CHAR(1),
					@Is_Sub_License CHAR(1),
					@Is_Tentative CHAR(1),
					@Sub_License_Code INT,
					@Deal_Rights_Code INT,
					@Deal_Pushback_Code INT,
					@Deal_Code INT,
					@Title_Code INT,
					@Platform_Code INT = 0,
					@Check_For CHAR(1),
					@Is_Theatrical_Right CHAR(1)
			END
       
			SELECT 
			@Deal_Code=dr.Deal_Code,
			@Deal_Rights_Code =  dr.Deal_Rights_Code ,--CASE WHEN @CallFrom = 'AR' THEN ELSE 0 END,
			@Deal_Pushback_Code=  dr.Deal_Rights_Code, --CASE WHEN @CallFrom = 'AP' THEN ELSE 0 END,
			@Right_Start_Date=dr.Right_Start_Date,
			@Right_End_Date=dr.Right_End_Date,
			--@Right_End_Date=ISNULL(dr.Right_End_Date,DATEADD(YEAR,100,dr.Right_Start_Date)),
			@Right_Type=dr.Right_Type,
			@Is_Exclusive=dr.Is_Exclusive,
			@Is_Tentative=dr.Is_Tentative,
			--@Is_Sub_License=dr.Is_Sub_License,
			@Sub_License_Code=dr.Sub_License_Code,
			@Is_Title_Language_Right=dr.Is_Title_Language_Right,	
			@Title_Code=ISNULL(dr.Title_Code,0),
			@Platform_Code=ISNULL(dr.Platform_Code,0),
			@Check_For = dr.Check_For,
			@Is_Theatrical_Right=ISNULL(dr.Is_Theatrical_Right,'N')
			FROM @Deal_Rights dr
	


			DECLARE @Deal_Type_Code INT =0
			SELECT TOP 1 @Deal_Type_Code = ISNULL(Parameter_Value,5) FROM System_Parameter_New WHERE Parameter_Name like 'Deal_Type_Music'
			BEGIN  /* insert in temporary tables*/

				Select    ADR.Acq_Deal_Code
				, ADR.Acq_Deal_Pushback_Code
				, ADR.Right_Type
				, ADR.Right_Start_Date
				, ADR.Right_End_Date
				--, ADR.Is_Sub_License
				, ADR.Is_Title_Language_Right
				,(Select Count(*) From Acq_Deal_Pushback_Subtitling a (NOLOCK)  Where a.Acq_Deal_Pushback_Code = ADR.Acq_Deal_Pushback_Code) Sub_Cnt
				,(Select Count(*) From Acq_Deal_Pushback_Dubbing a (NOLOCK)  Where a.Acq_Deal_Pushback_Code = ADR.Acq_Deal_Pushback_Code) Dub_Cnt
				, 'Combination Conflict with other Rights' ErrorMSG
					InTo #Acq_Deal_Pushback
				From Acq_Deal_Pushback ADR (NOLOCK) 
				Where 
				ADR.Acq_Deal_Code is not null	
				And ADR.Acq_Deal_Code In (
					Select AD.Acq_Deal_Code From Acq_Deal AD (NOLOCK)  Where 
					AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND
					(
						AD.Is_Master_Deal = 'Y'
						OR (ISNULL(AD.Deal_Type_Code,1) = @Deal_Type_Code AND Is_Master_Deal = 'N')
					)
				)
				AND ((ADR.Acq_Deal_Code=@Deal_Code ) )
				--AND ((ISNULL(@Check_For,'') = 'M' AND ADR.Acq_Deal_Code <> @Deal_Code) OR ISNULL(@Check_For,'') = '')
				AND(  
					(@Is_Title_Language_Right = 'Y' AND (ADR.Is_Title_Language_Right = 'Y' OR ADR.Is_Title_Language_Right = 'N'))
					OR @Is_Title_Language_Right = 'N'
				)
				AND
				(
					/******************Case 1***********************************/
					--In Case of Right 1 is YearBased with no tentative and Current Right is Unlimited
					--In Case of Right 1 is YearBased with no tentative and Current Right is MileStone
					--In Case of Right 1 is YearBased with no tentative and Current Right is YearBase With no tentative
					/******************Case 2***********************************/
					--In Case of Right 1 is MileStone and Current Right is Yearbased with no tentative
					--In Case of Right 1 is MileStone and Current Right is Unlimited
					--In Case of Right 1 is MileStone and Current Right is MileStone
					/******************Case 3***********************************/
					--In Case of Right 1 is Unlimited and Current Right is Yearbased and no tentative 
					--In Case of Right 1 is Unlimited and Current Right is MileStone 
					(
						(
							((ADR.Right_Type = 'Y'  ) AND ( @Right_Type = 'M' OR (@Right_Type = 'Y' ))) -- Case 1
							OR
							((ADR.Right_Type = 'M'  AND ((@Right_Type = 'Y' )  OR @Right_Type = 'M'))) -- Case 2
							OR 
							(( ((@Right_Type = 'Y') OR @Right_Type = 'M'))) -- Case 3
						)
						
						AND
						(		
							Convert(DateTime, @Right_Start_Date, 103) between Convert(DateTime, ADR.Right_Start_Date, 103) and Convert(DateTime, ISNULL(ADR.Right_End_Date,'31DEC9999'), 103)
							OR
							Convert(DateTime, ISNULL(@Right_End_Date,'31DEC9999'), 103) between Convert(DateTime, ADR.Right_Start_Date, 103) and Convert(DateTime, ISNULL(ADR.Right_End_Date,'31DEC9999'), 103)
							OR
							Convert(DateTime, ADR.Right_Start_Date, 103) between Convert(DateTime, @Right_Start_Date, 103) and Convert(DateTime, ISNULL(@Right_End_Date,'31DEC9999'), 103)
							OR
							Convert(DateTime,ISNULL(ADR.Right_End_Date,'31DEC9999'), 103) between Convert(DateTime, @Right_Start_Date, 103) and Convert(DateTime, ISNULL(@Right_End_Date,'31DEC9999'), 103)							
						)
						OR
						(				
					
						/******************Case 4***********************************/
							--In Case of Right 1 is YearBased with tentative and Current Right is Unlimited
							--In Case of Right 1 is YearBased with tentative and Current Right is MileStone
							--In Case of Right 1 is YearBased with tentative and Current Right is YearBased with No tentative
							--In Case of Right 1 is YearBased with tentative and Current Right is YearBased with tentative
							(
								ADR.Right_Type = 'Y' AND  ADR.Is_Tentative = 'Y' 
								AND 
								(
									@Right_Type = 'U' 
									OR 
									(
										(@Right_Type = 'M' OR (@Right_Type= 'Y' AND @Is_Tentative = 'N'))
										AND  
										Convert(DateTime, @Right_End_Date, 103) >= Convert(DateTime,ADR.Right_Start_Date, 103)
									)
									OR
									(@Right_Type= 'Y' AND @Is_Tentative = 'Y')
								)
							) -- case 4					
							OR
							/******************Case 5***********************************/
							--In Case of Right 1 is MileStone and Current Right is Yearbased with tentative					
							--In case of Right 1 is Yearbased with no tentative and Current Right is Yearbased with tentative
							((ADR.Right_Type = 'M' OR (ADR.Right_Type = 'Y' AND ADR.Is_Tentative = 'N'))
							AND
							(
							 (@Right_Type='Y' AND @Is_Tentative = 'Y')
							 OR
							 (@Right_Type='U')
							)
							AND Convert(DateTime,ADR.Right_End_Date, 103) >= Convert(DateTime, @Right_Start_Date, 103)) --Case 5
							/******************Case 6***********************************/
							--In Case of Right 1 is Unlimited and Current Right is unlimited 
							--In Case of Right 1 is Unlimited and Current Right is Yearbased and tentative 					
							OR
							(ADR.Right_Type = 'U' AND  ((@Right_Type = 'U') OR (@Right_Type = 'Y' AND @Is_Tentative = 'Y')))  --Case 6
							--OR
							--(ADR.Right_Type = 'U' AND @Right_Type = 'M' AND Convert(DateTime,ADR.Actual_Right_Start_Date, 103) <= Convert(DateTime, @Right_End_Date, 103)) --Case 6)																				

						)
					)
				)
			
				AND
				(
					 (ISNULL(@Title_Code,0) = 0 AND ISNULL(@Platform_Code,0) = 0) AND ADR.Acq_Deal_Pushback_Code not in (@Deal_Rights_Code) 
					 OR
					 (ISNULL(@Title_Code,0) <> 0)
				
				)

	
				select ADR.Acq_Deal_Pushback_Code
						,ADRT.Title_Code
						,ADRT.Episode_From
						,ADRT.Episode_To 
				into #Acq_Deal_Pushback_Title 
				from #Acq_Deal_Pushback ADR 
				inner join Acq_Deal_Pushback_Title ADRT (NOLOCK)  on ADR.Acq_Deal_Pushback_Code = ADRT.Acq_Deal_Pushback_Code
				AND ADRT.Acq_Deal_Pushback_Code NOT IN
				(
					SELECT A.Acq_Deal_Pushback_Code FROM 
					(	SELECT @Deal_Rights_Code Acq_Deal_Pushback_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
					) AS A 
					WHERE (A.Title_Code=ADRT.Title_Code AND A.Title_Code > 1 AND @Platform_Code < 1) 
				)
				where 1=1 AND Title_Code in (
					SELECT Title_Code FROM @Deal_Rights_Title inTitle
					Where 
						(inTitle.Episode_From Between ADRT.Episode_From And ADRT.Episode_To) 
					Or	(inTitle.Episode_To Between ADRT.Episode_From And ADRT.Episode_To) 
					Or	(ADRT.Episode_From Between inTitle.Episode_From And inTitle.Episode_To) 
					Or  (ADRT.Episode_To Between inTitle.Episode_From And inTitle.Episode_To)
				)
		

		
				delete from #Acq_Deal_Pushback where Acq_Deal_Pushback_Code not in (
					select Acq_Deal_Pushback_Code from #Acq_Deal_Pushback_Title
				)
		


				select DISTINCT ADR.Acq_Deal_Pushback_Code 
						,ADRP.Platform_Code 
						into #Acq_Deal_Pushback_Platform 
				from #Acq_Deal_Pushback_Title ADR 
				inner join Acq_Deal_Pushback_Platform ADRP (NOLOCK)  on ADRP.Acq_Deal_Pushback_Code = ADR.Acq_Deal_Pushback_Code 
				AND ADRP.Acq_Deal_Pushback_Code NOT IN
				(
					SELECT A.Acq_Deal_Pushback_Code FROM 
					(	SELECT @Deal_Rights_Code Acq_Deal_Pushback_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
					) AS A 
					WHERE ((A.Platform_Code=ADRP.Platform_Code OR A.Platform_Code < 1) AND (A.Title_Code=ADR.Title_Code Or A.Title_Code < 1)) 
				)
				where 1=1 AND Platform_Code in (SELECT Platform_Code FROM @Deal_Rights_Platform)
			
				DECLARE @allowSatelliteRightsOverlapping CHAR(1) = ''
				SELECT TOP 1 @allowSatelliteRightsOverlapping = Parameter_Value FROM System_Parameter_New WHERE Parameter_Name = 'AllowSatelliteRightsOverlapping'

				IF(@allowSatelliteRightsOverlapping = 'Y')
				BEGIN
					DELETE FROM #Acq_Deal_Pushback_Platform WHERE Platform_Code IN (SELECT Platform_Code FROM [Platform] (NOLOCK)  WHERE ISNULL(Is_No_Of_Run, '') = 'Y')
				END
		
				delete from #Acq_Deal_Pushback_Title where Acq_Deal_Pushback_Code not in (
					select Acq_Deal_Pushback_Code from #Acq_Deal_Pushback_Platform
				)

				delete from #Acq_Deal_Pushback where Acq_Deal_Pushback_Code not in (
					select Acq_Deal_Pushback_Code from #Acq_Deal_Pushback_Title
				)

				select a.Acq_Deal_Pushback_Code 
					   ,a.Territory_Type
					   ,a.Territory_Code
					   ,a.Country_Code 
				into #Acq_Deal_Pushback_Territory 
				From (
					Select ADR.Acq_Deal_Pushback_Code 
						   ,ADRT.Territory_Type
						   ,ADRT.Territory_Code
						   , Case When ADRT.Territory_Type = 'I' Then ADRT.Country_Code Else TD.Country_Code End Country_Code
					from #Acq_Deal_Pushback ADR 
					Inner Join Acq_Deal_Pushback_Territory ADRT (NOLOCK)  on ADRT.Acq_Deal_Pushback_Code = ADR.Acq_Deal_Pushback_Code
					Left Join Territory_Details TD (NOLOCK)  On ADRT.Territory_Code = TD.Territory_Code
				) As a
				where 1=1 AND
				( 
					(  
						@Is_Theatrical_Right = 'Y'  
						AND 
						(
							a.Country_Code IN
							(
								select Country_Code from Country  (NOLOCK) where (Is_Theatrical_Territory = 'Y' OR Is_Domestic_Territory ='Y')
									AND Country_code in (select Country_Code from #Deal_Rights_Territory)
							)
							OR a.Country_Code in (select Country_Code from Country  (NOLOCK) where Is_Domestic_Territory ='Y')
						)
					)
					OR
					(		
						@Is_Theatrical_Right = 'N' AND @Is_Country_Domestic = 'Y' AND @Is_Platform_Thetrical = 'Y'
						AND ISNULL(a.Country_Code,0)>0
						AND ( 
								a.Country_Code in 
								(
									select Country_Code from Country  (NOLOCK) where (Is_Theatrical_Territory = 'Y' OR Is_Domestic_Territory = 'Y')
								)
							)
								
					)
					OR (ISNULL(a.Country_Code,0)>0 AND a.Country_Code in (SELECT tr.Country_Code FROM #Deal_Rights_Territory tr) AND @Is_Theatrical_Right = 'N')
				)	

				delete from #Acq_Deal_Pushback_Platform where Acq_Deal_Pushback_Code not in (
					select Acq_Deal_Pushback_Code from #Acq_Deal_Pushback_Territory
				)
				delete from #Acq_Deal_Pushback_Title where Acq_Deal_Pushback_Code not in (
					select Acq_Deal_Pushback_Code from #Acq_Deal_Pushback_Platform
				)

				delete from #Acq_Deal_Pushback where Acq_Deal_Pushback_Code not in (
					select Acq_Deal_Pushback_Code from #Acq_Deal_Pushback_Title
				)
		
		
		
				IF((SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM #Deal_Rights_Subtitling)>0)
				BEGIN

					insert into #Acq_Deal_Pushback_Subtitling(Acq_Deal_Pushback_Code,Language_Type ,Language_Group_Code,Language_Code)
					Select Acq_Deal_Pushback_Code, a.Language_Type, a.Language_Group_Code, Language_Code From (
						select ADR.Acq_Deal_Pushback_Code,ADRS.Language_Type,ADRS.Language_Group_Code,
							   Case When ADRS.Language_Type = 'L' Then ADRS.Language_Code  Else LGD.Language_Code End Language_Code
						From #Acq_Deal_Pushback ADR 
						inner join Acq_Deal_Pushback_Subtitling ADRS  (NOLOCK) on ADRS.Acq_Deal_Pushback_Code = ADR.Acq_Deal_Pushback_Code
						Left Join Language_Group_Details LGD (NOLOCK)  On ADRS.Language_Group_Code = LGD.Language_Group_Code
					) as a
					Inner Join #Deal_Rights_Subtitling DRS ON DRS.Subtitling_Code=a.Language_Code

				END


				IF((SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM #Deal_Rights_Dubbing)>0)
				BEGIN
					insert into #Acq_Deal_Pushback_Dubbing(Acq_Deal_Pushback_Code,Language_Type ,Language_Group_Code,Language_Code)
					Select Acq_Deal_Pushback_Code,a.Language_Type, a.Language_Group_Code, Language_Code 
					From (
						select ADR.Acq_Deal_Pushback_Code,ADRD.Language_Type,ADRD.Language_Group_Code, 
							   Case When ADRD.Language_Type = 'L' Then ADRD.Language_Code Else LGD.Language_Code End Language_Code
						From #Acq_Deal_Pushback ADR
						inner join Acq_Deal_Pushback_Dubbing ADRD (NOLOCK)  on ADRD.Acq_Deal_Pushback_Code = ADR.Acq_Deal_Pushback_Code
						Left Join Language_Group_Details LGD (NOLOCK)  On ADRD.Language_Group_Code = LGD.Language_Group_Code
					) as a
					INNER JOIN #Deal_Rights_Dubbing DRD ON DRD.Dubbing_Code=a.Language_Code

				END

		
	

				IF(
					(SELECT COUNT(ISNULL(Subtitling_Code,0)) FROM #Deal_Rights_Subtitling) = 0 AND 
					(SELECT COUNT(ISNULL(Dubbing_Code,0)) FROM #Deal_Rights_Dubbing) = 0
				)
				BEGIN
					DELETE  FROM #Acq_Deal_Pushback WHERE Is_Title_Language_Right = 'N'
				END
				ELSE 
				BEGIN
					INSERT INTO #Acq_Rights_Code_Lang
					SELECT Distinct R.Acq_Deal_Pushback_Code
					FROM #Acq_Deal_Pushback R
					WHERE (R.Is_Title_Language_Right = 'Y' AND @Is_Title_Language_Right = 'Y')
				
					INSERT INTO #Acq_Rights_Code_Lang
					SELECT Distinct Acq_Deal_Pushback_Code
					FROM #Acq_Deal_Pushback_Subtitling where ( ISnull(Language_Code,0) <> 0 OR Isnull(Language_Group_Code,0) <> 0 )
				
					INSERT INTO #Acq_Rights_Code_Lang	
					SELECT Distinct Acq_Deal_Pushback_Code
					FROM #Acq_Deal_Pushback_Dubbing where ( ISnull(Language_Code,0) <> 0 OR Isnull(Language_Group_Code,0) <> 0 )

					DELETE FROM #Acq_Deal_Pushback
					WHERE Acq_Deal_Pushback_Code NOT IN(SELECT Deal_Rights_Code FROM #Acq_Rights_Code_Lang)
			
				END
		
				delete from #Acq_Deal_Pushback_Title where Acq_Deal_Pushback_Code not in (
					select Acq_Deal_Pushback_Code from #Acq_Deal_Pushback
				)
				delete from #Acq_Deal_Pushback_Territory where Acq_Deal_Pushback_Code not in (
					select Acq_Deal_Pushback_Code from #Acq_Deal_Pushback
				)
				delete from #Acq_Deal_Pushback_Platform where Acq_Deal_Pushback_Code not in (
					select Acq_Deal_Pushback_Code from #Acq_Deal_Pushback
				)
		
				/*Newly added on 30march2015 For Detail condition on RightsList page*/
				-- IF(ISNULL(@Title_Code,0) <> 0 AND ISNULL(@Platform_Code,0) <> 0 AND @Deal_Rights_Code <> 0)
				--BEGIN
				--	delete ADR from #Acq_Deal_Pushback ADR WHERE ADR.Acq_Deal_Pushback_Code IN
				--	(
				--		select  ADRP.Acq_Deal_Pushback_Code from #Acq_Deal_Pushback_Title ADRT
				--		INNER JOIN #Acq_Deal_Pushback_Platform ADRP ON ADRT.Acq_Deal_Pushback_Code = ADRP.Acq_Deal_Pushback_Code
				--		where Title_Code = @Title_Code AND ADRP.Acq_Deal_Pushback_Code = @Deal_Rights_Code AND Platform_Code = @Platform_Code
				--	)
				-- END
				--IF(ISNULL(@Title_Code,0) = 0 AND ISNULL(@Platform_Code,0) = 0 AND @Deal_Rights_Code <> 0)
				--BEGIN
				--	delete from #Acq_Deal_Pushback where Acq_Deal_Pushback_Code in (@Deal_Rights_Code)
				--END
				--ELSE IF(ISNULL(@Title_Code,0) <> 0 AND ISNULL(@Platform_Code,0) = 0 AND @Deal_Rights_Code <> 0)
				--BEGIN
				--	delete from #Acq_Deal_Pushback_Title where Title_Code  = @Title_Code 
				--	AND Acq_Deal_Pushback_Code in (
				--			select  Acq_Deal_Pushback_code from #Acq_Deal_Pushback_Title
				--			where Title_Code = @Title_Code AND Acq_Deal_Pushback_Code = @Deal_Rights_Code
				--	)
				--END
				--ELSE IF(ISNULL(@Title_Code,0) <> 0 AND ISNULL(@Platform_Code,0) <> 0 AND @Deal_Rights_Code <> 0)
				--BEGIN
				--	delete from #Acq_Deal_Pushback_Platform where Platform_Code = @Platform_Code
				--	AND Acq_Deal_Pushback_Code in (
				--			select  Acq_Deal_Pushback_code from #Acq_Deal_Pushback_Title
				--			where Title_Code = @Title_Code AND Acq_Deal_Pushback_Code = @Deal_Rights_Code
				--	)
			
				--	delete from #Acq_Deal_Pushback_Title where Title_Code  = @Title_Code 
				--	AND Acq_Deal_Pushback_Code in (
				--			select  Acq_Deal_Pushback_code from #Acq_Deal_Pushback_Title
				--			where Title_Code = @Title_Code AND Acq_Deal_Pushback_Code = @Deal_Rights_Code
				--	)
			
				--	--delete from #Acq_Deal_Pushback where Acq_Deal_Pushback_Code NOT In 
				--	--(
				--	--	SELECT A.Acq_Deal_Pushback_Code FROM 
				--	--	(	SELECT @Deal_Rights_Code Acq_Deal_Pushback_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
				--	--	) AS A
				--	--	WHERE (A.Platform_Code=Platform_Code OR A.Platform_Code < 1)AND (A.Title_Code=Title_Code Or A.Title_Code < 1) 
				--	--)
				--END
		
		
		
		
				--delete from #Acq_Deal_Pushback_Platform where Platform_Code  In 
				--(
				--	Isnull(@Platform_Code,0)
				--)
				--AND EXISTS(
				--	SELECT A.Acq_Deal_Pushback_Code FROM 
				--		(	SELECT @Deal_Rights_Code Acq_Deal_Pushback_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
				--		) AS A 
				--		WHERE (A.Platform_Code=Platform_Code OR A.Platform_Code < 1)AND (A.Title_Code=Title_Code Or A.Title_Code < 1) 
				--)
				/*End of add on 30 march2015*/
		
		

			END
	

			--select ADR.*,ADRT.Title_Code,ADRT.Episode_From,ADRT.Episode_To 
			--into #ACQ_RIGHTS_NEW
			--from  #Acq_Deal_Pushback ADR 
			--inner join #Acq_Deal_Pushback_Title ADRT on ADR.Acq_Deal_Pushback_Code = ADRT.Acq_Deal_Pushback_Code

			SELECT ADR.*,ADRT.Title_Code,ADRT.Episode_From,ADRT.Episode_To,ADRP.Platform_Code
			INTO #ACQ_RIGHTS_NEW
			FROM  #Acq_Deal_Pushback ADR 
			INNER JOIN #Acq_Deal_Pushback_Title ADRT ON ADR.Acq_Deal_Pushback_Code = ADRT.Acq_Deal_Pushback_Code
			INNER JOIN #Acq_Deal_Pushback_Platform ADRP ON ADR.Acq_Deal_Pushback_Code = ADRT.Acq_Deal_Pushback_Code
			AND ADR.Acq_Deal_Pushback_Code NOT IN
			(
				SELECT A.Acq_Deal_Pushback_Code FROM 
					(	SELECT @Deal_Rights_Code Acq_Deal_Pushback_Code,@Title_Code Title_Code,@Platform_Code Platform_Code
					) AS A 
					WHERE ((A.Platform_Code=ADRP.Platform_Code OR A.Platform_Code < 1) AND (A.Title_Code=ADRT.Title_Code Or A.Title_Code < 1)) 
			)
		

			--IF(@Debug = 'D')
			--BEGIN
			--Select 'sagar', * FROM #Acq_Deal_Pushback
			--Select 'sagar', * FROM #Acq_Deal_Pushback
			--Select 'sagar', * FROM #Acq_Deal_Pushback_Title
			--Select 'sagar', * FROM #Acq_Deal_Pushback_Platform
			--Select 'sagar', * FROM #ACQ_RIGHTS_NEW
			--END

			Select Title_Name, abcd.Platform_Hiearachy Platform_Name, Right_Start_Date as Right_Start_Date, Right_End_Date as Right_End_Date,
				CASE WHEN Right_Type = 'Y' THEN 'Year Based' WHEN Right_Type = 'U' THEN 'Perpetuity' ELSE 'Milestone' END Right_Type,
				--CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License,
				CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right,
				Country_Name,
				CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language,
				CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language,
				Agreement_No, ISNULL(ErrorMSG ,'NA') ErrorMSG, Episode_From, Episode_To
			From(
				Select *,
				STUFF
				(
					(
					Select ', ' + C.Country_Name From Country C  (NOLOCK) 
					Where c.Country_Code In(
						Select t.Country_Code From #Acq_Deal_Pushback_Territory t 
						Where t.Acq_Deal_Pushback_Code In (
							Select adrn.Acq_Deal_Pushback_Code From #ACQ_RIGHTS_NEW adrn Where 
								a.Title_Code = adrn.Title_Code And a.Right_Start_Date = adrn.Right_Start_Date 
								AND ISNULL(a.Right_End_Date,'')=ISNULL(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
								--and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
								and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
						)
					) --AND C.Country_Code in (select distinct Country_Code from #Deal_Rights_Territory)
					FOR XML PATH('')), 1, 1, ''
				) as Country_Name,
				STUFF
				(
					(
					Select ',' + CAST(P.Platform_Code as Varchar) 
					From Platform p (NOLOCK)  Where p.Platform_Code In
					(
						Select adrn.Platform_Code 
						FROM #ACQ_RIGHTS_NEW adrn 
						WHERE a.Title_Code = adrn.Title_Code
						AND adrn.Platform_Code = p.Platform_Code
						AND ISNULL(a.Right_End_Date,'')=ISNULL(adrn.Right_End_Date,'')
						And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
						--and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
						and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
						--Select t.Platform_Code From #Acq_Deal_Pushback_Platform t Where t.Acq_Deal_Pushback_Code In 
						--(
						--		Select adrn.Acq_Deal_Pushback_Code From #ACQ_RIGHTS_NEW adrn Where 
						--		a.Title_Code = adrn.Title_Code And a.Actual_Right_Start_Date = adrn.Actual_Right_Start_Date 
						--		AND ISNULL(a.Actual_Right_End_Date,'')=ISNULL(adrn.Actual_Right_End_Date,'')
						--		And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
						--		and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
						--		and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
						--)
					)
					FOR XML PATH('')), 1, 1, ''
				) as Platform_Code,
				STUFF
				(
					(
					Select ', ' + l.Language_Name From Language l (NOLOCK)  
					Where l.Language_Code In(
						Select t.Language_Code From #Acq_Deal_Pushback_Subtitling t 
						Where t.Acq_Deal_Pushback_Code In (
							Select adrn.Acq_Deal_Pushback_Code From #ACQ_RIGHTS_NEW adrn 
							Where a.Title_Code = adrn.Title_Code And a.Right_Start_Date = adrn.Right_Start_Date
								AND ISNULL(a.Right_End_Date,'')=ISNULL(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
								--and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
								and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
						)
					)
					FOR XML PATH('')), 1, 1, ''
				) as Subtitling_Language,
				STUFF
				(
					(
					Select ', ' + l.Language_Name From Language l  (NOLOCK) 
					Where l.Language_Code In(
						Select t.Language_Code From #Acq_Deal_Pushback_Dubbing t Where t.Acq_Deal_Pushback_Code In (
							Select adrn.Acq_Deal_Pushback_Code From #ACQ_RIGHTS_NEW adrn 
							Where a.Title_Code = adrn.Title_Code And a.Right_Start_Date = adrn.Right_Start_Date 
								AND ISNULL(a.Right_End_Date,'')=ISNULL(adrn.Right_End_Date,'')
								And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
								--and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
								and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
						)
					)
					FOR XML PATH('')), 1, 1, ''
				) as Dubbing_Language,
				STUFF
				(
					(
					Select ', ' + t.Agreement_No From Acq_Deal t (NOLOCK) 
					Where t.Deal_Workflow_Status NOT IN ('AR', 'WA') AND t.Acq_Deal_Code In (
						Select adrn.Acq_Deal_Code From #ACQ_RIGHTS_NEW adrn
						Where a.Title_Code = adrn.Title_Code And a.Right_Start_Date = adrn.Right_Start_Date
							AND ISNULL(a.Right_End_Date,'')=ISNULL(adrn.Right_End_Date,'')
							And a.Episode_From = adrn.Episode_From And a.Episode_To = adrn.Episode_To 
							--and isnull(a.Is_Sub_License,'')=isnull(adrn.Is_Sub_License,'') 
							and isnull(a.Is_Title_Language_Right,'')=isnull(adrn.Is_Title_Language_Right,'')
					)
					FOR XML PATH('')), 1, 1, ''
				) as Agreement_No
				From (
					Select T.Title_Code,
						DBO.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name,
						ADR.Right_Start_Date, ADR.Right_End_Date
						, Is_Title_Language_Right, ADR.ErrorMSG, Right_Type, Episode_From, Episode_To
					from #ACQ_RIGHTS_NEW ADR
					--inner join #Acq_Deal_Pushback_Title ADRT on ADR.Acq_Deal_Pushback_Code = ADRT.Acq_Deal_Pushback_Code
					INNER JOIN Title T (NOLOCK)  ON T.Title_Code=ADR.Title_Code
					Group By T.Title_Code, T.Title_Name, Right_Start_Date, Right_End_Date, --Is_Sub_License,
						Is_Title_Language_Right,ADR.ErrorMSG, Right_Type,Episode_From,Episode_To,Deal_Type_Code
				) as a
			) as MainOutput
			Cross Apply
			(
				Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
			) as abcd
	

		IF OBJECT_ID('tempdb..#Acq_Deal_Pushback') IS NOT NULL DROP TABLE #Acq_Deal_Pushback
		IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Dubbing') IS NOT NULL DROP TABLE #Acq_Deal_Pushback_Dubbing
		IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Platform') IS NOT NULL DROP TABLE #Acq_Deal_Pushback_Platform
		IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Subtitling') IS NOT NULL DROP TABLE #Acq_Deal_Pushback_Subtitling
		IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Territory') IS NOT NULL DROP TABLE #Acq_Deal_Pushback_Territory
		IF OBJECT_ID('tempdb..#Acq_Deal_Pushback_Title') IS NOT NULL DROP TABLE #Acq_Deal_Pushback_Title
		IF OBJECT_ID('tempdb..#Acq_Rights_Code_Lang') IS NOT NULL DROP TABLE #Acq_Rights_Code_Lang
		IF OBJECT_ID('tempdb..#ACQ_RIGHTS_NEW') IS NOT NULL DROP TABLE #ACQ_RIGHTS_NEW
		IF OBJECT_ID('tempdb..#Deal_Rights_Dubbing') IS NOT NULL DROP TABLE #Deal_Rights_Dubbing
		IF OBJECT_ID('tempdb..#Deal_Rights_Subtitling') IS NOT NULL DROP TABLE #Deal_Rights_Subtitling
		IF OBJECT_ID('tempdb..#Deal_Rights_Territory') IS NOT NULL DROP TABLE #Deal_Rights_Territory
		IF OBJECT_ID('tempdb..#Dup_Records_Language') IS NOT NULL DROP TABLE #Dup_Records_Language
		IF OBJECT_ID('tempdb..#Dup_Records_Language1') IS NOT NULL DROP TABLE #Dup_Records_Language1
		IF OBJECT_ID('tempdb..#TempDupComb') IS NOT NULL DROP TABLE #TempDupComb
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Validate_Rev_HB_Duplication_UDT_Acq]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''
END