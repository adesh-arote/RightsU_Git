

CREATE PROCEDURE [dbo].[USP_Validate_Rights_Duplication_UDT_Generic_BAK]
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
	DECLARE CUR_DUP_RIGHTS_COMBI CURSOR
	READ_ONLY
	FOR SELECT DISTINCT Title_Code,Right_Start_Date,Right_End_Date FROM @Dup_Records_Language

	DECLARE @Title_Code_CUR INT,@Right_Start_Date_CUR DATETIME,@Right_End_Date_CUR DATETIME
	OPEN CUR_DUP_RIGHTS_COMBI

	FETCH NEXT FROM CUR_DUP_RIGHTS_COMBI INTO @Title_Code_CUR,@Right_Start_Date_CUR,@Right_End_Date_CUR
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
			
			SELECT 
			@PFCodes = @PFCodes + Cast(Platform_Code AS VARCHAR) + ',' ,
			@CCodes = @CCodes + Cast(Country_Code AS VARCHAR) + ',',
			@SCodes = @SCodes + Cast(Subtitling_Language AS VARCHAR) + ', ',
			@DCodes = @DCodes + Cast(Dubbing_Language AS VARCHAR) + ', ' 
			FROM @Dup_Records_Language 
			WHERE Title_Code=@Title_Code_CUR 
			AND Right_Start_Date=@Right_Start_Date_CUR
			AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
			
			
			SELECT  @Agreement_Nos = @Agreement_Nos + Cast(Agreement_No AS VARCHAR) + ', ' FROM (
				SELECT DISTINCT Agreement_No
				FROM @Dup_Records
				WHERE Title_Code=@Title_Code_CUR 
				AND Right_Start_Date=@Right_Start_Date_CUR
				--AND (Right_End_Date=@Right_End_Date_CUR OR @Right_End_Date_CUR is NULL)
				AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
			) A
			
			SELECT @CNAMES  = @CNAMES + Cast(Country_Name AS VARCHAR) + ', '
			FROM Country WHERE Country_Code IN 
			(
				SELECT number FROM dbo.fn_Split_withdelemiter(@CCodes,',') 
			)
						
			SELECT @SNAMES  = @SNAMES + Cast(Language_Name AS VARCHAR) + ', '
			FROM [Language] WHERE Language_Code IN 
			(
				SELECT number FROM dbo.fn_Split_withdelemiter(@SCodes,',') 
			)
			
			SELECT @DNAMES  = @DNAMES + Cast(Language_Name AS VARCHAR) + ', '
			FROM [Language] WHERE Language_Code IN 
			(
				SELECT number FROM dbo.fn_Split_withdelemiter(@DCodes,',') 
			)
			
			SET @CNAMES = SUBSTRING(@CNAMES,0,LEN(@CNAMES))    
			SET @SNAMES = SUBSTRING(@SNAMES,0,LEN(@SNAMES))    
			SET @DNAMES = SUBSTRING(@DNAMES,0,LEN(@DNAMES))    
			SET @Agreement_Nos = SUBSTRING(@Agreement_Nos,0,LEN(@Agreement_Nos))    
						
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
				FROM @Platform_Group TPC
				INNER JOIN [Platform] P ON P.Parent_Platform_Code=TPC.Platform_Code OR P.Base_Platform_Code=TPC.Platform_Code
				RIGHT JOIN
				(
					SELECT
					 Title_Code
					,Platform_Code				
					,Right_Start_Date,Right_End_Date,Right_Type
					,Is_Sub_License, Is_Title_Language_Right
					,Deal_Code,Deal_Rights_Code,ErrorMSG
					FROM @Dup_Records
					WHERE Title_Code=@Title_Code_CUR 
					AND Right_Start_Date=@Right_Start_Date_CUR
					AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')				
				) A	ON A.Platform_Code=P.Platform_Code
				--OR dbo.fn_getParentPlatform_Recursive(CAST (A.Platform_Code as varchar),'','') LIKE '%'+CAST (TPC.Platform_Code as varchar)+'%' 
				OR 
					TPC.Platform_Code IN (SELECT number FROM  dbo.fn_Split_withdelemiter(dbo.fn_getParentPlatform_Recursive(CAST (A.Platform_Code as varchar),'',''),'~'))
			) B
			
			IF(@Debug='L')
			BEGIN
				SELECT Platform_Code,dbo.fn_getParentPlatform_Recursive(CAST (A.Platform_Code as varchar),'','') --LIKE '%'+CAST (A.Platform_Code as varchar)+'%'
				FROM @Dup_Records A
					WHERE Title_Code=@Title_Code_CUR 
					AND Right_Start_Date=@Right_Start_Date_CUR
					AND ISNULL(Right_End_Date,'')=ISNULL(@Right_End_Date_CUR,'')
			END
			
			DELETE FROM @Platform_Group
		END
		FETCH NEXT FROM CUR_DUP_RIGHTS_COMBI INTO @Title_Code_CUR,@Right_Start_Date_CUR,@Right_End_Date_CUR
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
			,T.Title_Name
			,Right_Start_Date 
			,Right_End_Date 			
			,CASE 
			 WHEN Right_Type = 'Y' THEN 'Year Based' 
			 WHEN Right_Type = 'U' THEN 'Perpetuity' 
			 ELSE 'Milestone' END Right_Type
			,CASE WHEN Is_Sub_License = 'Y'	THEN 'Yes' ELSE 'No' END Is_Sub_License			
			,CASE WHEN Is_Title_Language_Right = 'Y' THEN 'Yes' ELSE 'No' END Is_Title_Language_Right
		FROM @Dup_Records_After_Cursor DP
		INNER JOIN Title T ON T.Title_Code=DP.Title_Code
		INNER JOIN [Platform] P ON P.Platform_Code=DP.Platform_Code
		
		
END