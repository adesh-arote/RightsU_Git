CREATE Procedure [dbo].[USP_GetPromoterCodes]         
(         
    @Title_Code VARCHAR(MAX),         
    @Platform_Code VARCHAR(MAX),         
    @Country_Code VARCHAR(MAX),         
    @Subtitle_Code VARCHAR(MAX),         
    @Dubbing_Code VARCHAR(MAX),         
    @Title_Language CHAR(1),         
    @Deal_Type_Code INT,       
    @Period_Type CHAR(1),       
    @Start_Date VARCHAR(20),       
    @End_Date VARCHAR(20)     
)         
AS     
BEGIN   
     --DECLARE   
     --@Title_Code VARCHAR(MAX) = '1535'  ,       
     --@Platform_Code VARCHAR(MAX) ='0,0,0,60,258,61,62,259,63,64,65,66,67,69,0,71,72,73,0,262,263,75,76,0,145,146,265,78,79,147,152,154,0,0,38,256,39,40,257,41,42,43,44,45,47,0,49,50,51,0,260,261,53,54,0,149,150,264,56,57,151,155,157,0,0,268,269,270,271,272,273,274,275,276,277,278,0,280,281,282,0,284,285,286,287,0,291,292,293,288,289,294,295,296,0,0,299,300,301,302,303,304,305,306,307,308,309,0,311,312,313,0,315,316,317,318,0,322,323,324,319,320,325,326,327',         
     --@Country_Code VARCHAR(MAX) = '23',         
     --@Subtitle_Code VARCHAR(MAX)= '',         
     --@Dubbing_Code VARCHAR(MAX)= '',         
     --@Title_Language CHAR(1) = 'Y',         
     --@Deal_Type_Code INT =11,       
     --@Period_Type CHAR(1)= 'Y',       
     --@Start_Date VARCHAR(20) = '02/02/2018',       
     --@End_Date VARCHAR(20) = '03/01/2018'      

    SET NOCOUNT ON         
       
    IF OBJECT_ID('TEMPDB..#TempTitle') IS NOT NULL       
        DROP TABLE #TempTitle 
		
	IF OBJECT_ID('TEMPDB..#TempTitle_temp') IS NOT NULL       
        DROP TABLE #TempTitle_temp 
             
    IF OBJECT_ID('TEMPDB..#TempHoldback') IS NOT NULL       
        DROP TABLE #TempHoldback       

    IF OBJECT_ID('TEMPDB..#TempHoldback_TL') IS NOT NULL       
        DROP TABLE #TempHoldback_TL       
       
    IF OBJECT_ID('TEMPDB..#TempHoldbackCodes') IS NOT NULL         
        DROP TABLE #TempHoldbackCodes         
         
    IF OBJECT_ID('TEMPDB..#CountryHoldback') IS NOT NULL         
        DROP TABLE #CountryHoldback         
         
    IF OBJECT_ID('TEMPDB..#TerritoryHoldback') IS NOT NULL         
        DROP TABLE #TerritoryHoldback     
   
    IF OBJECT_ID('TEMPDB..#Temp_ADRC') IS NOT NULL         
        DROP TABLE #Temp_ADRC

    IF OBJECT_ID('TEMPDB..#Temp_Syn_Deal_Movie') IS NOT NULL         
        DROP TABLE #Temp_Syn_Deal_Movie

    IF OBJECT_ID('TEMPDB..#Temp_Promoter_Group') IS NOT NULL         
        DROP TABLE #Temp_Promoter_Group
   
    IF OBJECT_ID('TEMPDB..#Sub_Dub_Holdback') IS NOT NULL         
        DROP TABLE #Sub_Dub_Holdback

    IF OBJECT_ID('TEMPDB..#LanguageHoldback') IS NOT NULL         
        DROP TABLE #LanguageHoldback         
         
    IF OBJECT_ID('TEMPDB..#Language_GroupHoldback') IS NOT NULL         
        DROP TABLE #Language_GroupHoldback         

    BEGIN TRY     
    DECLARE @Dubbing  CHAR(1) = 'N', @Subtitling  CHAR(1) ='N', @TitleLanguage CHAR(1) = 'N', @Acq_Deal_Rights_Code INT = 0  , @Acq_Deal_Rights_Promoter_Code VARCHAR(MAX),   
    @Rights_Start_Date VARCHAR(20) , @Rights_End_Date VARCHAR(20), @Promoter_Group_Code VARCHAR(MAX) = '', @Is_Perpetuity CHAR(1) = 'N' , @CountDown INT = 0
        
    DECLARE @Deal_Type_Condition VARCHAR(MAX) = '', @Rec_Count INT = 0         
    SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Deal_Type_Code)        
         
    CREATE TABLE #TempTitle(       
      Title_Code VARCHAR(MAX),       
      Episode_FROM INT,       
      Episode_To INT       
    )

	 CREATE TABLE #TempTitle_temp(       
      Title_Code VARCHAR(MAX),       
      Episode_FROM INT,       
      Episode_To INT       
    )
           
    CREATE TABLE #TempHoldbackCodes(           
      Acq_Deal_Rights_Code INT             
    )  

    CREATE TABLE #Temp_Promoter_Group(           
      PGC VARCHAR(MAX)           
    ) 

    CREATE TABLE #Sub_Dub_Holdback(           
      Language_Code INT         
    )

    CREATE TABLE #LanguageHoldback(           
      Language_Code INT         
    )

    CREATE TABLE #Language_GroupHoldback(           
      Language_Group_Code INT         
    )
   
    IF(@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'Deal_Music')       
    BEGIN  
            DECLARE @Title_Code_tmp VARCHAR(MAX) = '', @Episode_From_tmp VARCHAR(MAX) = '', @Episode_End_To_tmp VARCHAR(MAX) = ''

            SELECT Title_Code, Episode_From, Episode_End_To INTO #Temp_Syn_Deal_Movie FROM Syn_Deal_Movie
            WHERE Syn_Deal_Movie_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Title_Code, ','))  
        
            DECLARE Title_cursor CURSOR FOR 
            SELECT Title_Code, Episode_From, Episode_End_To FROM #Temp_Syn_Deal_Movie

            OPEN Title_cursor  
            FETCH NEXT FROM Title_cursor INTO @Title_Code_tmp, @Episode_From_tmp, @Episode_End_To_tmp  

            WHILE @@FETCH_STATUS = 0  
            BEGIN  
                    INSERT INTO #TempTitle_temp(Title_Code, Episode_From, Episode_To)       
                    SELECT Title_Code, Episode_FROM, Episode_To FROM Acq_Deal_Rights_Title       
                    WHERE Title_Code = @Title_Code_tmp -- AND  @Episode_From_tmp >= Episode_FROM AND @Episode_End_To_tmp <= Episode_To 

                    FETCH NEXT FROM Title_cursor INTO @Title_Code_tmp, @Episode_From_tmp, @Episode_End_To_tmp  
            END  

            CLOSE Title_cursor  
            DEALLOCATE Title_cursor

			INSERT INTO #TempTitle(Title_Code, Episode_From, Episode_To)  
			SELECT * FROM #TempTitle_temp WHERE 
			Episode_FROM BETWEEN @Episode_From_tmp AND @Episode_End_To_tmp 
			OR 
			Episode_To BETWEEN @Episode_End_To_tmp AND @Episode_End_To_tmp

    END       
    ELSE        
    BEGIN       
          INSERT INTO #TempTitle(Title_Code,Episode_FROM,Episode_To)       
          SELECT NUMBER AS Title_Code, 1, 1 FROM fn_Split_withdelemiter(@Title_Code, ',') WHERE NUMBER <> ''       
    END       
     
    IF(RIGHT(@Country_Code,1) <> 'T')
    BEGIN
          PRINT 'Country'
          INSERT INTO #TempHoldbackCodes
          SELECT Acq_Deal_Rights_Code  FROM ( 
     
              SELECT Acq_Deal_Rights_Code from Acq_Deal_Rights_Platform WHERE Platform_Code IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Platform_Code, ','))                   
              INTERSECT   
              SELECT ADR.Acq_Deal_Rights_Code   from Acq_Deal_Rights_Territory ADR
              LEFT JOIN  Territory_Details TD ON TD.Territory_Code = ADR.Territory_Code
              WHERE TD.country_code  IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Code ,','))            
              UNION
              SELECT DISTINCT ADR.Acq_Deal_Rights_Code   from Acq_Deal_Rights_Territory ADR
              LEFT JOIN  Territory_Details TD ON TD.Territory_Code = ADR.Territory_Code
              WHERE ADR.country_code  IN(SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Code ,','))

          ) AS Rights_Code
    END     
    ELSE
    BEGIN
        PRINT 'Territory'
        SELECT @Country_Code =   REPLACE(@Country_Code,'T','')

        PRINT 'Getting all the Country Code which has been assigned in particular territory by user'
        SELECT DISTINCT Country_Code INTO #CountryHoldback FROM Territory_Details WHERE Territory_Code  IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Code, ','))

        PRINT 'Getting all the Territory Code which has been assigned with the Country Code'
        SELECT DISTINCT td.Territory_Code INTO #TerritoryHoldback FROM Territory_Details td WHERE td.country_code IN (SELECT country_code FROM  #CountryHoldback)

        IF EXISTS( SELECT TOP 1 * FROM #TerritoryHoldback WHERE Territory_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Country_Code, ',')))
        BEGIN
            SELECT Acq_Deal_Rights_Code INTO #Temp_ADRC FROM Acq_Deal_Rights_Territory         
            WHERE Territory_Code IN (SELECT Territory_Code FROM #TerritoryHoldback)

            PRINT 'TERITORY CODE EXIST'
            INSERT INTO #TempHoldbackCodes
            SELECT Acq_Deal_Rights_Code FROM (        
                SELECT Acq_Deal_Rights_Code from Acq_Deal_Rights_Platform WHERE Platform_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Platform_Code, ','))         
                INTERSECT                       
                SELECT Acq_Deal_Rights_Code from #Temp_ADRC     
            ) AS Rights_Code

        END
        ELSE
        BEGIN
            PRINT 'TERITORY CODE DOES NOT EXIST'
            INSERT INTO #TempHoldbackCodes SELECT 0
        END
    END   
     

    SELECT AR.Acq_Deal_Rights_Code,  AR.Is_Title_Language_Right, AR.Actual_Right_Start_Date , AR.Actual_Right_End_Date, AR.Right_Type INTO #TempHoldback FROM #TempHoldbackCodes T       
    INNER JOIN Acq_Deal_Rights AR On T.Acq_Deal_Rights_Code = AR.Acq_Deal_Rights_Code       

    SELECT @Is_Perpetuity = Parameter_Value FROM System_Parameter_New WHERE UPPER(Parameter_Name) = 'ENABLED_PERPETUITY'
    UPDATE #TempHoldback SET Actual_Right_End_Date = '9999-12-31 00:00:00.000' WHERE Right_Type = 'U' AND @Is_Perpetuity = 'N'

    SELECT
        ROW_NUMBER() OVER(ORDER BY AR.Acq_Deal_Rights_Code ASC) AS RowNumber,
        AR.Acq_Deal_Rights_Code,
        AR.Is_Title_Language_Right,
        AR.Actual_Right_Start_Date,
        AR.Actual_Right_End_Date,
        CAST('' AS VARCHAR(1000)) AS ADR_Codes
     INTO #TempHoldback_TL
     FROM #TempHoldbackCodes T       
     INNER JOIN #TempHoldback AR On T.Acq_Deal_Rights_Code = AR.Acq_Deal_Rights_Code 
     INNER JOIN Acq_Deal_Rights ADR On ADR.Acq_Deal_Rights_Code = T.Acq_Deal_Rights_Code             
     INNER JOIN Acq_Deal_Rights_Title RT On AR.Acq_Deal_Rights_Code = RT.Acq_Deal_Rights_Code       
     INNER JOIN #TempTitle THB ON THB.Title_Code = RT.Title_Code AND (       
          (THB.Episode_FROM BETWEEN RT.Episode_FROM AND RT.Episode_To) OR        
          (THB.Episode_To BETWEEN RT.Episode_FROM AND RT.Episode_To) OR       
          (RT.Episode_FROM BETWEEN THB.Episode_FROM AND THB.Episode_To) OR       
          (RT.Episode_To BETWEEN THB.Episode_FROM AND THB.Episode_To)       
     )  

    DECLARE @index INT = 1

    DECLARE @RowNumber_Temp INT, @Acq_Deal_Rights_Code_Temp INT, @Is_Title_Language_Right_Temp CHAR(1), @Right_Start_Date_Temp DATETIME,-- @Right_Type CHAR(1),
    @Right_End_Date_Temp DATETIME, @ADR_Codes VARCHAR(1000) , @StartDate_Hold DATETIME , @EndDate_Hold DATETIME, @ADRC VARCHAR(1000)

    IF(@Period_Type = 'Y' OR @Period_Type = 'M')       
    BEGIN
            DECLARE db_cursor CURSOR FOR 
            SELECT RowNumber, Acq_Deal_Rights_Code, Is_Title_Language_Right, Actual_Right_Start_Date, Actual_Right_End_Date, ADR_Codes FROM #TempHoldback_TL

            OPEN db_cursor  
            FETCH NEXT FROM db_cursor INTO @RowNumber_Temp, @Acq_Deal_Rights_Code_Temp, @Is_Title_Language_Right_Temp, @Right_Start_Date_Temp, @Right_End_Date_Temp, @ADR_Codes

            WHILE @@FETCH_STATUS = 0  
            BEGIN         
                  IF (@index = 1)
                  BEGIN
                        SELECT @StartDate_Hold = @Right_Start_Date_Temp , @EndDate_Hold = @Right_End_Date_Temp, @ADRC = @Acq_Deal_Rights_Code_Temp
                        UPDATE #TempHoldback_TL SET Actual_Right_Start_Date = @StartDate_Hold ,Actual_Right_End_Date = @EndDate_Hold , ADR_Codes = @ADRC  WHERE RowNumber = @index
                  END
                  ELSE
                  BEGIN
                        IF( DATEDIFF(DAY , @EndDate_Hold , @Right_Start_Date_Temp) = 1)
                        BEGIN
                                SELECT @EndDate_Hold = @Right_End_Date_Temp , @ADRC = @ADRC +','+ CAST(@Acq_Deal_Rights_Code_Temp AS VARCHAR(1000))       
                        END
                        ELSE
                        BEGIN
                                SELECT @StartDate_Hold = @Right_Start_Date_Temp , @EndDate_Hold = @Right_End_Date_Temp, @ADRC = @Acq_Deal_Rights_Code_Temp
                        END
                        UPDATE #TempHoldback_TL SET Actual_Right_Start_Date = @StartDate_Hold ,Actual_Right_End_Date = @EndDate_Hold , ADR_Codes = @ADRC  WHERE RowNumber = @index
                  END

                  SET @index= @index + 1
                  FETCH NEXT FROM db_cursor INTO @RowNumber_Temp, @Acq_Deal_Rights_Code_Temp, @Is_Title_Language_Right_Temp, @Right_Start_Date_Temp, @Right_End_Date_Temp, @ADR_Codes
            END  

            CLOSE db_cursor  
            DEALLOCATE db_cursor
    END          

    DECLARE @RowNo INT = 1 , @Count INT = 0, @temp_Promo_Codes NVARCHAR(MAX) = '';
    SELECT @Count =  COUNT(*) FROM #TempHoldback_TL

    PRINT '#TempHoldback_TL Count - ' + CAST(@Count AS VARCHAR(100))

    IF EXISTS (SELECT Acq_Deal_Rights_Code FROM #TempHoldback_TL )         
    BEGIN         
        WHILE (SELECT COUNT(Acq_Deal_Rights_Code) FROM #TempHoldback_TL) > 0
        BEGIN 
                PRINT '*********************************************************************************'
                DECLARE  @Is_Date_Valid  CHAR(1) = 'N' , @Is_Start_Date_Valid CHAR(1)= 'N' , @Is_End_Date_Valid CHAR(1) = 'N'
                SELECT @ADR_Codes = '' , @Dubbing = 'N' , @Subtitling = 'N', @TitleLanguage = 'Y' , @Is_Date_Valid = 'N'

                PRINT 'Row No - ' +  CAST(@RowNo AS VARCHAR(100))

                SELECT  @Acq_Deal_Rights_Code =  Acq_Deal_Rights_Code, @ADR_Codes = ADR_Codes FROM #TempHoldback_TL  where RowNumber = @RowNo

                SELECT @TitleLanguage = Is_Title_Language_Right FROM Acq_Deal_Rights WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code   

                PRINT 'Title Language From #temp ' + @TitleLanguage +' Acq_Deal_Rights_Code '+ CAST(@Acq_Deal_Rights_Code AS VARCHAR(1000)) +' Title Language From Parameter '+ @Title_Language

                IF(@Title_Language <> 'N' AND  @TitleLanguage <> 'N')
                    SET @TitleLanguage = 'Y'       
                ELSE
                    SET @TitleLanguage = 'N'

                PRINT 'Calculating period in between '

                IF(@Period_Type = 'P' OR @Period_Type = 'T')       
                BEGIN       
                    SELECT @Rights_Start_Date = Convert(date,Actual_Right_Start_Date,101) from Acq_Deal_Rights where Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code       
                    IF(CONVERT(date,@Start_Date,101) >= @Rights_Start_Date Or CONVERT(date,@Start_Date,101) <= @Rights_End_Date)     
                    BEGIN     
                        SET @Is_Date_Valid = 'Y'     
                    END     
                END    
   
                IF(@Period_Type = 'Y' OR @Period_Type = 'M')       
                BEGIN           
                    SELECT @Rights_Start_Date = Convert(DATE,Actual_Right_Start_Date,101) ,@Rights_End_Date = Convert(DATE,Actual_Right_End_Date,101) FROM #TempHoldback_TL
                    WHERE Acq_Deal_Rights_Code =  @Acq_Deal_Rights_Code       
   
                    PRINT 'Start Date ' + @Rights_Start_Date +' | End Date '+ @Rights_End_Date
   
                    IF(@Start_Date != '')       
                    BEGIN 
                        PRINT  CONVERT(date,@Start_Date,101)
						   
                        IF(CONVERT(date,@Start_Date,101) >= @Rights_Start_Date AND CONVERT(date,@Start_Date,101) <= @Rights_End_Date)     
                        BEGIN   
                            SET @Is_Start_Date_Valid = 'Y'     
                        END     
                    END   
                   
                    IF(@End_Date != '')       
                    BEGIN   
                         PRINT  CONVERT(date,@End_Date,101)
                           
                         IF(CONVERT(date,@End_Date,101) >= @Rights_Start_Date AND CONVERT(date,@End_Date,101) <= @Rights_End_Date)     
                         BEGIN   
                            SET @Is_End_Date_Valid = 'Y'     
                         END      
                    END
                   
                    IF(@Is_Start_Date_Valid = 'Y' AND @Is_End_Date_Valid = 'Y')     
                    BEGIN     
                        SET @Is_Date_Valid = 'Y'     
                    END     
                    PRINT  'Date Valid ' + @Is_Date_Valid      
                END       
      
                IF(RIGHT(@Subtitle_Code,1) <> 'T')     
                BEGIN 
                     PRINT  'Subtitling For language '
                     INSERT INTO #Sub_Dub_Holdback
                     SELECT Language_Code FROM (     
                        SELECT DISTINCT Language_Code FROM Language_Group_Details WHERE Language_Group_Code IN
                        (SELECT Language_Group_Code FROM Acq_Deal_Rights_Subtitling  WHERE  Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
                        UNION
                        SELECT DISTINCT Language_Code FROM Acq_Deal_Rights_Subtitling  WHERE  Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
                     ) AS Language_Code


                     IF EXISTS(SELECT Language_Code FROM #Sub_Dub_Holdback WHERE Language_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Subtitle_Code, ',')))
                     BEGIN
                         SET @Subtitling = 'Y'
                     END

                     TRUNCATE TABLE #Sub_Dub_Holdback
                END
                ELSE
                BEGIN
                    PRINT  'Subtitling For language Group '
                    SELECT @Subtitle_Code =   REPLACE(@Subtitle_Code,'T','')

                    INSERT INTO #LanguageHoldback
                    SELECT DISTINCT Language_Code FROM Language_Group_Details WHERE Language_Group_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Subtitle_Code, ','))

                    INSERT INTO #Language_GroupHoldback
                    SELECT DISTINCT td.Language_Group_Code FROM Language_Group_Details td WHERE td.Language_Code IN
                    (SELECT Language_Code FROM  #LanguageHoldback)


                    IF EXISTS( SELECT TOP 1 * FROM #Language_GroupHoldback WHERE Language_Group_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Subtitle_Code, ',')))
                    BEGIN   
                        IF EXISTS ( SELECT Acq_Deal_Rights_Code  FROM Acq_Deal_Rights_Subtitling   WHERE Language_Group_Code IN
                        (SELECT Language_Group_Code FROM #Language_GroupHoldback) and Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
                        BEGIN
                             SET @Subtitling = 'Y'
                        END 
						IF EXISTS ( SELECT Acq_Deal_Rights_Code  FROM Acq_Deal_Rights_Subtitling   WHERE Language_Code IN
                        (SELECT Language_Code FROM #LanguageHoldback) and Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
                        BEGIN
                             SET @Subtitling = 'Y'
                        END              
                    END   

					SET @Subtitle_Code = @Subtitle_Code +'T'
                    TRUNCATE TABLE     #LanguageHoldback
                    TRUNCATE TABLE     #Language_GroupHoldback   
                END        

                IF(RIGHT(@Dubbing_Code,1) <> 'T')     
                BEGIN
                     PRINT  'Dubbing For language '
                     INSERT INTO #Sub_Dub_Holdback
                     SELECT Language_Code FROM (     
                        SELECT DISTINCT Language_Code FROM Language_Group_Details WHERE Language_Group_Code IN
                        (SELECT Language_Group_Code FROM Acq_Deal_Rights_Dubbing  WHERE  Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
                        UNION
                        SELECT DISTINCT Language_Code FROM Acq_Deal_Rights_Dubbing WHERE  Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
                     ) AS Language_Code

                     IF EXISTS(SELECT Language_Code FROM #Sub_Dub_Holdback WHERE Language_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Dubbing_Code, ',')))
                     BEGIN
                         SET @Dubbing = 'Y'
                     END
                     TRUNCATE TABLE #Sub_Dub_Holdback
                END
                ELSE
                BEGIN       
                     PRINT  'Dubbing For language Group'   
                    SELECT @Dubbing_Code =   REPLACE(@Dubbing_Code,'T','')

                    INSERT INTO #LanguageHoldback
                    SELECT DISTINCT Language_Code FROM Language_Group_Details WHERE Language_Group_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Dubbing_Code, ','))

                    INSERT INTO #Language_GroupHoldback
                    SELECT DISTINCT td.Language_Group_Code FROM Language_Group_Details td WHERE td.Language_Code IN (SELECT Language_Code FROM  #LanguageHoldback)

                    IF EXISTS( SELECT TOP 1 * FROM #Language_GroupHoldback WHERE Language_Group_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(@Dubbing_Code, ',')))
                    BEGIN   
                        IF EXISTS ( SELECT Acq_Deal_Rights_Code  FROM Acq_Deal_Rights_Dubbing  WHERE Language_Group_Code IN
                        (SELECT Language_Group_Code FROM #Language_GroupHoldback) and Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
                        BEGIN
                             SET @Dubbing = 'Y'
                        END    
						 IF EXISTS ( SELECT Acq_Deal_Rights_Code  FROM Acq_Deal_Rights_Dubbing  WHERE Language_Code IN
                        (SELECT Language_Code FROM #LanguageHoldback) and Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code)
                        BEGIN
                             SET @Dubbing = 'Y'
                        END                
                    END   

					SET @Dubbing_Code = @Dubbing_Code +'T'
                    TRUNCATE TABLE     #LanguageHoldback
                    TRUNCATE TABLE     #Language_GroupHoldback
                END

                PRINT '@Dubbing - '+ @Dubbing +' OR @Subtitling - '+ @Subtitling +' OR @TitleLanguage - '+ @TitleLanguage +' AND @Is_Date_Valid - '+ @Is_Date_Valid

                IF((@Dubbing = 'Y' OR @Subtitling = 'Y' OR @TitleLanguage = 'Y') AND @Is_Date_Valid = 'Y')         
                BEGIN
                   
                    PRINT 'Satifaction SUCCEED V V V V V V'
					PRINT '---------------------------------------------------------------------------------'
					  
                    IF(@Period_Type = 'Y' OR @Period_Type = 'M')       
                    BEGIN            
                        SELECT @Acq_Deal_Rights_Promoter_Code = STUFF((SELECT Distinct ',' + CAST(Acq_Deal_Rights_Promoter_Code AS NVARCHAR(MAX)) 
                        FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code IN (SELECT NUMBER FROM fn_Split_withdelemiter(CAST(@ADR_Codes AS VARCHAR(1000)), ','))          
                        FOR XML PATH('')),1,1,'')
                    END
                    ELSE
                    BEGIN
                        SELECT @Acq_Deal_Rights_Promoter_Code = STUFF((SELECT Distinct ',' + CAST(Acq_Deal_Rights_Promoter_Code AS NVARCHAR(MAX)) 
                        FROM Acq_Deal_Rights_Promoter WHERE Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code
                        FOR XML PATH('')),1,1,'')
                    END

                    PRINT 'Acq_Deal_Rights_Promoter_Code - ' + @Acq_Deal_Rights_Promoter_Code

                    IF ISNULL(@Acq_Deal_Rights_Promoter_Code, '') <> ''
                    BEGIN
                        SELECT  @Promoter_Group_Code = STUFF((SELECT Distinct ',' + CAST(Promoter_Group_Code AS NVARCHAR(MAX)) 
                        FROM Acq_Deal_Rights_Promoter_Group WHERE Acq_Deal_Rights_Promoter_Code in (SELECT NUMBER FROM fn_Split_withdelemiter(@Acq_Deal_Rights_Promoter_Code ,','))    
                        FOR XML PATH('')),1,1,'') 
                    END

					PRINT 'Promoter_Group_Code - ' + CAST(@Promoter_Group_Code AS NVARCHAR(MAX)) + ' temp_Promo_Codes - ' + CAST(@temp_Promo_Codes AS NVARCHAR(MAX))

                    SET @CountDown += 1

                    IF(@Deal_Type_Condition = 'DEAL_PROGRAM' OR @Deal_Type_Condition = 'DEAL_MUSIC'  OR @Deal_Type_Condition = 'DEAL_MOVIE')
                    BEGIN
						
						PRINT 'CountDown - ' + CAST(@CountDown AS VARCHAR(100)) +' RowNo - '+ CAST(@RowNo AS VARCHAR(100)) + ' Count - ' + CAST(@Count AS VARCHAR(100))

                        IF (@RowNo < @Count)
                        BEGIN   
                                IF @CountDown = 1
                                BEGIN
                                    SELECT @temp_Promo_Codes = CAST(@Promoter_Group_Code AS NVARCHAR(MAX))
                                END
                                ELSE
                                BEGIN
                                    IF (@temp_Promo_Codes <> ''AND @Promoter_Group_Code <> '' )
                                    BEGIN
                                        INSERT INTO #Temp_Promoter_Group
                                        SELECT PGC FROM (                  
                                            SELECT NUMBER AS PGC FROM fn_Split_withdelemiter(@temp_Promo_Codes, ',')  WHERE NUMBER <> ''                 
                                            INTERSECT                           
                                            SELECT NUMBER AS PGC FROM fn_Split_withdelemiter(@Promoter_Group_Code ,',') WHERE NUMBER <> ''
                                        )  AS PGC   


                                        SELECT @temp_Promo_Codes = ISNULL(STUFF((SELECT Distinct ',' + CAST(PGC AS NVARCHAR) FROM #Temp_Promoter_Group FOR XML PATH('')),1,1,''),'')       
                                       
                                        TRUNCATE TABLE #Temp_Promoter_Group
                                    END       
                                END
                                SET @RowNo = @RowNo + 1
                            CONTINUE
                        END   
                        ELSE
                        BEGIN   
                                IF @CountDown = 1
                                BEGIN
                                    SELECT  CAST(@Promoter_Group_Code AS NVARCHAR(MAX))  AS Promoter_Group_Code
                                END
                                ELSE IF (@temp_Promo_Codes <> ''AND @Promoter_Group_Code <> '' )
                                BEGIN
                                    PRINT @temp_Promo_Codes +' - '+ CAST(@Promoter_Group_Code AS NVARCHAR(MAX))
                                    INSERT INTO #Temp_Promoter_Group
                                    SELECT PGC FROM (                  
                                        SELECT NUMBER AS PGC FROM fn_Split_withdelemiter(@temp_Promo_Codes, ',') WHERE NUMBER <> ''                  
                                        INTERSECT                           
                                        SELECT NUMBER AS PGC FROM fn_Split_withdelemiter(@Promoter_Group_Code ,',') WHERE NUMBER <> ''     
                                    )  AS PGC   
                           
                                    SELECT ISNULL(STUFF((SELECT Distinct ',' + CAST(PGC AS NVARCHAR) FROM #Temp_Promoter_Group FOR XML PATH('')),1,1,''),'') AS Promoter_Group_Code            
                                    TRUNCATE TABLE #Temp_Promoter_Group
                                END
                                ELSE
                                BEGIN
                                    IF(@RowNo > 1 AND @Count > 1)
                                        SELECT  CAST('' AS NVARCHAR(MAX))  AS Promoter_Group_Code
                                    ELSE
                                        SELECT  CAST(@Promoter_Group_Code AS NVARCHAR(MAX))  AS Promoter_Group_Code
                                END
                                BREAK
                        END   
                    END
                END
                ELSE
                BEGIN
                    PRINT 'Satifaction FAILED X X X X X X'
                    IF (@RowNo < @Count)
                    BEGIN
                        SET @RowNo = @RowNo + 1
                        CONTINUE
                    END   
                    ELSE
                    BEGIN
                        IF @CountDown = 1
                            SELECT CAST(@Promoter_Group_Code AS NVARCHAR(MAX))   AS Promoter_Group_Code
                        ELSE
                            SELECT  CAST(@temp_Promo_Codes AS NVARCHAR(MAX))  AS Promoter_Group_Code

                        BREAK
                    END             
                END
        END
    END
    ELSE
    BEGIN
            SELECT CAST(@Promoter_Group_Code AS NVARCHAR(MAX)) AS Promoter_Group_Code 
    END  
    END TRY
    BEGIN CATCH
            SELECT ERROR_MESSAGE() AS Promoter_Group_Code
    END CATCH
        
END      

--exec USP_GetPromoterCodes '34077','0,30,0,138,139,140,141,142,143','148','','','Y',1,'Y','01/01/2018','01/31/2018'   

--Select * from Acq_Deal_Rights_Territory    WHERE  Acq_Deal_Rights_Code = 24857
--Select * from Territory_Details   
--Select * from Acq_Deal_Rights_Dubbing where Acq_Deal_Rights_Code = 24867   
--Select * from Acq_Deal_Rights_Subtitling where Acq_Deal_Rights_Code = 24867   
--Select * from Acq_Deal_Rights_Title where Title_Code = 27367   
--Select * from Acq_Deal_Rights_Platform where Acq_Deal_Rights_Code = 39748   
--Select * from Acq_Deal_Rights_Territory where Acq_Deal_Rights_Code = 39748   
--Select * from Title  where Title_Name like '%DB Super%'   
--Select * from Acq_Deal_Rights_Promoter where Acq_Deal_Rights_Code in( 24911)   
--Select * from Acq_Deal_Rights_Promoter_Group where Acq_Deal_Rights_Promoter_Code in(3754)   

--SELECT * FROM Language_Group WHERE Language_Group_name = 'All excluding Thai'
--select * from language where language_name  like '%All Indian%'

--select * from promoter_group where promoter_Group_Code in (3,4,5,6,9)



