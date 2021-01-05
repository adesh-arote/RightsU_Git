CREATE PROCEDURE [dbo].[USP_Validate_Rights_Duplication_UDT_Generic]
(
	@Dup_Records Dup_Records READONLY,
	@Dup_Records_Language Dup_Records_Language READONLY,
	@CallFrom CHAR(2)='AR',
	@Debug CHAR(1)='N'
)
As
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 29-October-2014
-- Description:	GENERIC Code to Process Final Output of Duplication
-- =============================================
Begin
	IF(@Debug='D') SELECT DISTINCT Title_Code,Right_Start_Date,Right_End_Date FROM @Dup_Records_Language
	DECLARE @Platform_Group Platform_Group,
	        @Dup_Records_After_Cursor Dup_Records_After_Cursor
    -- JUMP_TO_CURSOR_GROUP: SECTION
	-- =============================================
	-- Declare and using a READ_ONLY cursor
	-- =============================================
	

	--SELECT DISTINCT Title_Code,Right_Start_Date,Right_End_Date, Episode_From, Episode_To FROM @Dup_Records_Language
	--select * into tmp_Dup_Lan from @Dup_Records_Language

	--DECLARE @Deal_Type_Content Int
	--SELECT @Deal_Type_Content=Cast(Parameter_Value As Int) FROM System_Parameter_New WHERE Parameter_NAME='Deal_Type_Content'
	IF(@Debug='k')
	BEGIN 
		DECLARE CUR_DUP_RIGHTS_COMBI CURSOR
		READ_ONLY
		FOR SELECT DISTINCT Title_Code,Right_Start_Date,Right_End_Date, Episode_From, Episode_To FROM @Dup_Records_Language

		DECLARE @Title_Code_CUR INT,@Right_Start_Date_CUR DATETIME,@Right_End_Date_CUR DATETIME, @Episode_From Int, @Episode_To Int
		OPEN CUR_DUP_RIGHTS_COMBI

		FETCH NEXT FROM CUR_DUP_RIGHTS_COMBI INTO @Title_Code_CUR,@Right_Start_Date_CUR,@Right_End_Date_CUR,@Episode_From,@Episode_To
		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
				DECLARE 
				@PFCodes VARCHAR(5000) = '0',
				
				@CCodes VARCHAR(5000) = '',
				@CNAMES VARCHAR(MAX) = '',
				
				@SCodes VARCHAR(5000) = '',
				@SNAMES VARCHAR(MAX) = '',
				
				@DCodes VARCHAR(5000) = '',
				@DNAMES VARCHAR(MAX) = '',
				
				@Agreement_Nos VARCHAR(MAX) = ''
				
				--SELECT 
				--@PFCodes = @PFCodes + Cast(Platform_Code AS VARCHAR) + ',' ,
				--@CCodes = @CCodes + Cast(Country_Code AS VARCHAR) + ',',
				--@SCodes = @SCodes + Cast(Subtitling_Language AS VARCHAR) + ', ',
				--@DCodes = @DCodes + Cast(Dubbing_Language AS VARCHAR) + ', ' 
				--FROM @Dup_Records_Language 
				--WHERE
				--Title_Code=@Title_Code_CUR 
				--AND Right_Start_Date=@Right_Start_Date_CUR
				--AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
				--And Episode_From = @Episode_From
				--And Episode_To = @Episode_To
				
				SELECT @PFCodes = @PFCodes + Cast(Platform_Code AS VARCHAR) + ','
				FROM 
				(select distinct Platform_code from
				@Dup_Records_Language 
				WHERE
				Title_Code=@Title_Code_CUR 
				AND Right_Start_Date=@Right_Start_Date_CUR
				AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
				And Episode_From = @Episode_From
				And Episode_To = @Episode_To
				) as a
				
				SELECT @CCodes = @CCodes + Cast(Country_code AS VARCHAR) + ','
				FROM 
				(select distinct Country_code from
				@Dup_Records_Language 
				WHERE
				Title_Code=@Title_Code_CUR 
				AND Right_Start_Date=@Right_Start_Date_CUR
				AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
				And Episode_From = @Episode_From
				And Episode_To = @Episode_To
				) as a
				

				SELECT @SCodes = @SCodes + Cast(Subtitling_Language AS VARCHAR) + ','
				FROM 
				(select distinct Subtitling_Language from
				@Dup_Records_Language 
				WHERE
				Title_Code=@Title_Code_CUR 
				AND Right_Start_Date=@Right_Start_Date_CUR
				AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
				And Episode_From = @Episode_From
				And Episode_To = @Episode_To
				) as a

				
				SELECT @DCodes = @DCodes + Cast(Dubbing_Language AS VARCHAR) + ','
				FROM 
				(select distinct Dubbing_Language from
				@Dup_Records_Language 
				WHERE
				Title_Code=@Title_Code_CUR 
				AND Right_Start_Date=@Right_Start_Date_CUR
				AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
				And Episode_From = @Episode_From
				And Episode_To = @Episode_To
				) as a
				

				SELECT  @Agreement_Nos = @Agreement_Nos + Cast(Agreement_No AS VARCHAR) + ', ' FROM (
					SELECT DISTINCT Agreement_No
					FROM @Dup_Records
					WHERE Title_Code=@Title_Code_CUR 
					AND Right_Start_Date=@Right_Start_Date_CUR
					--AND (Right_End_Date=@Right_End_Date_CUR OR @Right_End_Date_CUR is NULL)
					AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
					And Episode_From = @Episode_From
					And Episode_To = @Episode_To
				) A
				Set @CNAMES = ''
				If(IsNull(@CCodes, '') <> '')
					SELECT @CNAMES = @CNAMES + Cast(Country_Name AS NVARCHAR) + ', '
					FROM Country WHERE Country_Code IN 
					(
						SELECT number FROM dbo.fn_Split_withdelemiter(@CCodes,',') 
					)
							
				Set @SNAMES = ''
				If(IsNull(@SCodes, '') <> '')
					SELECT @SNAMES = @SNAMES + Cast(Language_Name AS NVARCHAR) + ', '
					FROM [Language] WHERE Language_Code IN 
					(
						SELECT number FROM dbo.fn_Split_withdelemiter(@SCodes,',') 
					)
				
				Set @DNAMES = ''
				If(IsNull(@DCodes, '') <> '')
					SELECT @DNAMES  = @DNAMES + Cast(Language_Name AS NVARCHAR) + ', '
					FROM [Language] WHERE Language_Code IN 
					(
						SELECT number FROM dbo.fn_Split_withdelemiter(@DCodes,',') 
					)
				
				SET @CNAMES = SUBSTRING(@CNAMES,0,LEN(@CNAMES))    
				SET @SNAMES = SUBSTRING(@SNAMES,0,LEN(@SNAMES))    
				SET @DNAMES = SUBSTRING(@DNAMES,0,LEN(@DNAMES))    
				SET @Agreement_Nos = SUBSTRING(@Agreement_Nos,0,LEN(@Agreement_Nos))    
							
							--select @PFCodes PfCodes

				INSERT INTO @Platform_Group(Platform_Code, Parent_Platform_Code, Base_Platform_Code
				, Is_Display, Is_Last_Level, TempCnt, TableCnt, Platform_Name)
				EXEC USP_Get_Platform_With_Parent @PFCodes
							
				/*
				DECLARE CUR_DUP_PLATFORM_GRP CURSOR
				READ_ONLY
				FOR SELECT DISTINCT Platform_Code FROM @Platform_Group

				DECLARE @Platform_Code_CUR INT
				OPEN CUR_DUP_PLATFORM_GRP

				FETCH NEXT FROM CUR_DUP_PLATFORM_GRP INTO @Platform_Code_CUR
				WHILE (@@fetch_status <> -1)
				BEGIN
						IF (@@fetch_status <> -2)
						BEGIN
							INSERT @Dup_Records_After_Cursor(
								 Title_Code
								,Platform_Code				
								,Right_Start_Date,Right_End_Date,Right_Type
								,Is_Sub_License,Is_Title_Language_Right
								,Deal_Code,Deal_Rights_Code,ErrorMSG
								,Country_Name			
								,Subtitling_Language
								,Dubbing_Language
								,Agreement_No
							)
							SELECT Title_Code
								,@Platform_Code_CUR Platform_Code							
								,Right_Start_Date,Right_End_Date,Right_Type
								,Is_Sub_License, Is_Title_Language_Right
								,Deal_Code,Deal_Rights_Code,ErrorMSG
								,@CNAMES Country_Name
								,@SNAMES Subtitling_Language
								,@DNAMES Dubbing_Language
								,@Agreement_Nos Agreement_No
								
							FROM @Dup_Records
							WHERE Title_Code=@Title_Code_CUR 
								AND Right_Start_Date=@Right_Start_Date_CUR
								AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
						END
						FETCH NEXT FROM CUR_DUP_PLATFORM_GRP INTO @Platform_Code_CUR
				END

				CLOSE CUR_DUP_PLATFORM_GRP
				DEALLOCATE CUR_DUP_PLATFORM_GRP
				*/
				INSERT @Dup_Records_After_Cursor(
								 Title_Code
								,Platform_Code				
								,Right_Start_Date,Right_End_Date,Right_Type
								,Is_Sub_License,Is_Title_Language_Right
								,Deal_Code,Deal_Rights_Code,ErrorMSG
								,Country_Name			
								,Subtitling_Language
								,Dubbing_Language
								,Agreement_No
								,Episode_From
								,Episode_To
								,IsPushback
							)
				SELECT   B.Title_Code
						,B.Platform_Code				
						,B.Right_Start_Date,B.Right_End_Date,B.Right_Type
						,B.Is_Sub_License,B.Is_Title_Language_Right
						,B.Deal_Code,B.Deal_Rights_Code,B.ErrorMSG
						,B.Country_Name
						,B.Subtitling_Language
						,B.Dubbing_Language
						,B.Agreement_No 
						,B.Episode_From
						,B.Episode_To
						,B.IsPushback
				FROM (
					SELECT Title_Code
						,ISNULL(TPC.Platform_Code,A.Platform_Code) Platform_Code
						,Right_Start_Date,Right_End_Date,Right_Type
						,Is_Sub_License,Is_Title_Language_Right
						,Deal_Code,Deal_Rights_Code,ErrorMSG
						,@CNAMES Country_Name
						,@SNAMES Subtitling_Language
						,@DNAMES Dubbing_Language
						,@Agreement_Nos Agreement_No
						,@Episode_From Episode_From
						,@Episode_To Episode_To
						,A.IsPushback
					FROM @Platform_Group TPC
					INNER JOIN [Platform] P ON P.Parent_Platform_Code=TPC.Platform_Code OR P.Base_Platform_Code=TPC.Platform_Code
					RIGHT JOIN
					(
						SELECT
						 Title_Code
						,Platform_Code
						,Right_Start_Date,Right_End_Date,Right_Type
						,Is_Sub_License, Is_Title_Language_Right
						,Deal_Code,Deal_Rights_Code,ErrorMSG,IsPushback
						FROM @Dup_Records
						WHERE Title_Code=@Title_Code_CUR
						AND Right_Start_Date=@Right_Start_Date_CUR
						AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
						And Episode_From = @Episode_From
						And Episode_To = @Episode_To
					) A	ON A.Platform_Code=P.Platform_Code
					--OR dbo.fn_getParentPlatform_Recursive(CAST (A.Platform_Code as varchar),'','') LIKE '%'+CAST (TPC.Platform_Code as varchar)+'%' 
					OR 
						TPC.Platform_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(IsNull(dbo.fn_getParentPlatform_Recursive(CAST (A.Platform_Code as varchar),'',''), ''),'~'))
				) B
				
				IF(@Debug='L')
				BEGIN
					SELECT Platform_Code,dbo.fn_getParentPlatform_Recursive(CAST (A.Platform_Code as varchar),'','') --LIKE '%'+CAST (A.Platform_Code as varchar)+'%'
					FROM @Dup_Records A
						WHERE Title_Code=@Title_Code_CUR 
						AND Right_Start_Date=@Right_Start_Date_CUR
						AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
						And Episode_From = @Episode_From
						And Episode_To = @Episode_To
				END
				
				DELETE FROM @Platform_Group
			END
			FETCH NEXT FROM CUR_DUP_RIGHTS_COMBI INTO @Title_Code_CUR,@Right_Start_Date_CUR,@Right_End_Date_CUR,@Episode_From,@Episode_To
		END

		CLOSE CUR_DUP_RIGHTS_COMBI
		DEALLOCATE CUR_DUP_RIGHTS_COMBI
		
		 -- Final OutPut
		 
		 
		 

	  SELECT  DISTINCT
			 ISNULL(ErrorMSG ,'NA')  ErrorMSG
	        ,Agreement_no
	        ,Country_Name
			,CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language
			,CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language
			,P.Platform_Code
			,P.Platform_Hiearachy Platform_Name
			,dbo.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name
			,Right_Start_Date 
			,Right_End_Date 			
			,CASE 
			 WHEN Right_Type = 'Y' THEN 'Year Based' 
			 WHEN Right_Type = 'U' THEN 'Perpetuity' 
			 ELSE 'Milestone' END Right_Type
			,CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License			
			,CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right
			,Episode_From,Episode_To
			,case when isnull(IsPushback,'N') = 'Y' THEN 'Pushback'
				  ELSE 'RIGHTS'
				  END as IsPushback
		FROM @Dup_Records_After_Cursor DP
		INNER JOIN Title T ON T.Title_Code=DP.Title_Code
		INNER JOIN [Platform] P ON P.Platform_Code=DP.Platform_Code
	END
	ELSE
	--IF(@Debug='N')
	BEGIN


	
	--Select T.Title_Code
	--			,Case 
	--				When T.Deal_Type_Code = @Deal_Type_Content
	--					Then T.Title_Name + ' ( ' + Cast(Episode_From as Varchar(10)) + ' - ' + Cast(Episode_To as Varchar(10)) + ' ) '
	--				Else T.Title_Name 
	--			 End Title_Name
	--			,Right_Start_Date, Right_End_Date 
	--			,Is_Sub_License,Is_Title_Language_Right,ErrorMSG,Right_Type,Episode_From,Episode_To--,Deal_Rights_Code
	--			From @Dup_Records_Language DRL
	--			INNER JOIN Title T ON T.Title_Code=DRL.Title_Code
	--			--WHERE (DRL.Is_Title_Language_Right <> 'N' AND DRL.Dubbing_Language is not null AND DRL.Subtitling_Language is not null)
	--			Group By T.Title_Code, T.Title_Name, Right_Start_Date, Right_End_Date,Is_Sub_License,Is_Title_Language_Right
	--					 ,ErrorMSG,Right_Type,Episode_From,Episode_To,Deal_Type_Code

		--INSERT @Dup_Records_After_Cursor(
		--	 Title_Code
		--	,Platform_Hiearachy				
		--	,Right_Start_Date,Right_End_Date,Right_Type
		--	,Is_Sub_License,Is_Title_Language_Right			
		--	,Country_Name			
		--	,Subtitling_Language
		--	,Dubbing_Language
		--	,Agreement_No
		--	,ErrorMSG
		--)	
		Select Title_Name
			,abcd.Platform_Hiearachy Platform_Name
			,Right_Start_Date,Right_End_Date
			,CASE
			 WHEN Right_Type = 'Y' THEN 'Year Based'
			 WHEN Right_Type = 'U' THEN 'Perpetuity'
			 ELSE 'Milestone' END Right_Type
			,CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License
			,CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right
			,Country_Name
			,CASE WHEN ISNULL(Subtitling_Language,'')='' THEN 'NA' ELSE Subtitling_Language END Subtitling_Language
			,CASE WHEN ISNULL(Dubbing_Language,'')='' THEN 'NA' ELSE Dubbing_Language END Dubbing_Language
			--,ISNULL(ABCD.Platform_Code,0) Platform_Code
			,Agreement_No
			,ISNULL(ErrorMSG ,'NA')  ErrorMSG
			,Episode_From,Episode_To
			,case when isnull(IsPushback,'N') = 'Y' THEN 'Pushback'
				  ELSE 'RIGHTS'
				  END as IsPushback
			From 
			(
			Select *,
			STUFF(
			(Select Distinct ', ' + C.Country_Name
				From @Dup_Records_Language b
				INNER JOIN Country C ON b.Country_Code=C.Country_Code
				Where a.Title_Code = b.Title_Code And a.Right_Start_Date = b.Right_Start_Date AND ISNULL(a.Right_End_Date,'')=ISNULL(b.Right_End_Date,'')
				And a.Episode_From = b.Episode_From And a.Episode_To = b.Episode_To and isnull(a.Is_Sub_License,'')=isnull(b.Is_Sub_License,'') and isnull(a.Is_Title_Language_Right,'')=isnull(b.Is_Title_Language_Right,'')
				And a.ErrorMSG = b.ErrorMSG
			FOR XML PATH('')), 1, 1, '') as Country_Name,
			STUFF(
			(Select Distinct ', ' + CAST(Platform_Code as Varchar) From @Dup_Records_Language b
				Where a.Title_Code = b.Title_Code And a.Right_Start_Date = b.Right_Start_Date AND ISNULL(a.Right_End_Date,'')=ISNULL(b.Right_End_Date,'')
				And a.Episode_From = b.Episode_From And a.Episode_To = b.Episode_To and isnull(a.Is_Sub_License,'')=isnull(b.Is_Sub_License,'') and isnull(a.Is_Title_Language_Right,'')=isnull(b.Is_Title_Language_Right,'')
				And a.ErrorMSG = b.ErrorMSG
			FOR XML PATH('')), 1, 1, '') as Platform_Code,
			STUFF(
			(Select Distinct ', ' + CAST(L.Language_Name as NVARCHAR)
				From @Dup_Records_Language b
				INNER JOIN [Language] L ON b.Subtitling_Language=L.Language_Code
				Where a.Title_Code = b.Title_Code And a.Right_Start_Date = b.Right_Start_Date AND ISNULL(a.Right_End_Date,'')=ISNULL(b.Right_End_Date,'')
				And a.Episode_From = b.Episode_From And a.Episode_To = b.Episode_To  and isnull(a.Is_Sub_License,'')=isnull(b.Is_Sub_License,'') and isnull(a.Is_Title_Language_Right,'')=isnull(b.Is_Title_Language_Right,'')
				And a.ErrorMSG = b.ErrorMSG
			FOR XML PATH('')), 1, 1, '') as Subtitling_Language,
			STUFF(
			(Select Distinct ', ' + CAST(L.Language_Name as NVARCHAR) 
				From @Dup_Records_Language b 
				INNER JOIN [Language] L ON b.Dubbing_Language=L.Language_Code
				Where a.Title_Code = b.Title_Code And a.Right_Start_Date = b.Right_Start_Date AND ISNULL(a.Right_End_Date,'')=ISNULL(b.Right_End_Date,'')
				And a.Episode_From = b.Episode_From And a.Episode_To = b.Episode_To and isnull(a.Is_Sub_License,'')=isnull(b.Is_Sub_License,'') and isnull(a.Is_Title_Language_Right,'')=isnull(b.Is_Title_Language_Right,'')
				And a.ErrorMSG = b.ErrorMSG
			FOR XML PATH('')), 1, 1, '') as Dubbing_Language,
			STUFF(
			(Select Distinct ', ' + CAST(Agreement_No as Varchar) From @Dup_Records_Language b 
				Where a.Title_Code = b.Title_Code And a.Right_Start_Date = b.Right_Start_Date AND ISNULL(a.Right_End_Date,'')=ISNULL(b.Right_End_Date,'')
				And a.Episode_From = b.Episode_From And a.Episode_To = b.Episode_To and isnull(a.Is_Sub_License,'')=isnull(b.Is_Sub_License,'') and isnull(a.Is_Title_Language_Right,'')=isnull(b.Is_Title_Language_Right,'')
				And a.ErrorMSG = b.ErrorMSG
			FOR XML PATH('')), 1, 1, '') as Agreement_No
			From (
				Select T.Title_Code
				,dbo.UFN_GetTitleNameInFormat([dbo].[UFN_GetDealTypeCondition](Deal_Type_Code), T.Title_Name, Episode_From, Episode_To) AS Title_Name
				,Right_Start_Date, Right_End_Date 
				,Is_Sub_License,Is_Title_Language_Right,ErrorMSG,Right_Type,Episode_From,Episode_To--,Deal_Rights_Code
				,DRL.IsPushback
				From @Dup_Records_Language DRL
				INNER JOIN Title T ON T.Title_Code=DRL.Title_Code
				--WHERE (DRL.Is_Title_Language_Right <> 'N' AND DRL.Dubbing_Language is not null AND DRL.Subtitling_Language is not null)
				Group By T.Title_Code, T.Title_Name, Right_Start_Date, Right_End_Date,Is_Sub_License,Is_Title_Language_Right
						 ,ErrorMSG,Right_Type,Episode_From,Episode_To,Deal_Type_Code,DRL.IsPushback--, Deal_Rights_Code
			) as a
		) as MainOutput
		Cross Apply(	
			Select * From [dbo].[UFN_Get_Platform_With_Parent](MainOutput.Platform_Code)
		) as abcd
	END
END