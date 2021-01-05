
CREATE PROC USP_AutoPushAcqDeal
(
	@SynDealCode INT, 
	@UserCode INT,
	@StatusFlag VARCHAR(1) OUTPUT,
	@ErrMessage VARCHAR(1) OUTPUT
)
AS
BEGIN
	--DECLARE @SynDealCode INT = 5278, @UserCode INT = 143
	--SET NOCOUNT ON
	DECLARE @AutopushAcqDeal CHAR(1) = 'N', @NewMappedBuCode INT = 0, @Message NVARCHAR(MAX)
	SELECT @StatusFlag = '', @ErrMessage = ''
	BEGIN TRY
		BEGIN TRAN
		PRINT 'Start transaction'
		SELECT TOP 1 @AutopushAcqDeal = Parameter_Value From System_Parameter_New Where Parameter_Name = 'AutopushAcqDeal'

		SELECT @NewMappedBuCode = MD.SecondaryDataCode FROM Syn_Deal SD
		INNER JOIN AcqPreReqMappingData MD ON MD.PrimaryDataCode = SD.Business_Unit_Code AND MD.MappingFor = 'BUUN'
		WHERE SD.Syn_Deal_Code = @SynDealCode

		IF (ISNULL(@NewMappedBuCode, 0) > 0 AND ISNULL(@AutopushAcqDeal, '') = 'Y')
		BEGIN
			BEGIN /*Create Temp Tables*/
				DECLARE @NewAcqDealCode INT = 0, @DealCompleteFlag VARCHAR(10), @RoleCode_Deal INT,
				@RoleCode_Deal_P INT = 27, @DealTagCode_P INT, @DealTypeCode_P INT, @CurrencyCode_P INT, @BusinessUnitCode_P INT, @VendorCode_P INT, @VendorContactCode_P INT,
				@CategoryCode_P INT,
				@RoleCode_Deal_S INT, @DealTagCode_S INT, @DealTypeCode_S INT, @CurrencyCode_S INT, @BusinessUnitCode_S INT, @VendorCode_S INT, @VendorContactCode_S INT,
				@CategoryCode_S INT

				SELECT TOP 1 @DealCompleteFlag = Parameter_Value From RightsU_Plus_S13.dbo.System_Parameter_New Where Parameter_Name = 'Deal_Complete_Flag'
				SELECT TOP 1 @RoleCode_Deal = Parameter_Value From RightsU_Plus_S13.dbo.System_Parameter_New Where Parameter_Name = 'DefaultRoleCodeForAcqInV18'
	
				BEGIN /* Get Mapped MilestoneType*/
					PRINT 'Get Mapped MilestoneType'
					IF(OBJECT_ID('TEMPDB..#CurrentMilestoneType') IS NOT NULL)
						DROP TABLE #CurrentMilestoneType

					CREATE TABLE #CurrentMilestoneType
					(
						Milestone_Type_Code		INT,
						NewMilestoneTypeCode	INT DEFAULT(0),
					)

					INSERT INTO #CurrentMilestoneType (Milestone_Type_Code)
					SELECT DISTINCT Milestone_Type_Code 
					FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @SynDealCode

					UPDATE CMT SET CMT.NewMilestoneTypeCode = ISNULL(MD.SecondaryDataCode, 0) FROM #CurrentMilestoneType CMT
					INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'MITY' AND CMT.Milestone_Type_Code = MD.PrimaryDataCode

					IF EXISTS(SELECT TOP 1 * FROM #CurrentMilestoneType WHERE NewMilestoneTypeCode = 0)
					BEGIN
						PRINT 'Found some unmapped MilestoneType'
					END
				END

				BEGIN /* Get Mapped Sub License */
					PRINT 'Get Mapped Sub License'
					IF(OBJECT_ID('TEMPDB..#CurrentSubLicense') IS NOT NULL)
						DROP TABLE #CurrentSubLicense

					CREATE TABLE #CurrentSubLicense
					(
						Sub_License_Code		INT,
						NewSubLicenseCode	INT DEFAULT(0),
					)

					INSERT INTO #CurrentSubLicense (Sub_License_Code)
					SELECT DISTINCT Sub_License_Code 
					FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @SynDealCode

					UPDATE CS SET CS.NewSubLicenseCode = ISNULL(MD.SecondaryDataCode, 0) FROM #CurrentSubLicense CS
					INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'SULI' AND CS.Sub_License_Code = MD.PrimaryDataCode

					IF EXISTS(SELECT TOP 1 * FROM #CurrentSubLicense WHERE NewSubLicenseCode = 0)
					BEGIN
						PRINT 'Found some unmapped Sub License'
					END
				END
			
				BEGIN /* Get Mapped Title */
					PRINT 'Get Mapped Title'
					IF(OBJECT_ID('TEMPDB..#CurrentTitles') IS NOT NULL)
						DROP TABLE #CurrentTitles

					CREATE TABLE #CurrentTitles
					(
						Title_Code		INT,
						NewTitleCode	INT DEFAULT(0),
						Episode_From	INT,
						Episode_To	INT
					)

					INSERT INTO #CurrentTitles (Title_Code, NewTitleCode, Episode_From, Episode_To)
					SELECT DISTINCT Title_Code, 0 AS NewTitleCode, Episode_From, Episode_End_To AS Episode_To 
					FROM Syn_Deal_Movie WHERE Syn_Deal_Code = @SynDealCode

					UPDATE CT SET CT.NewTitleCode = ISNULL(MD.SecondaryDataCode, 0) FROM #CurrentTitles CT
					INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'TITL' AND CT.Title_Code = MD.PrimaryDataCode

					IF EXISTS(SELECT TOP 1 * FROM #CurrentTitles WHERE NewTitleCode = 0)
					BEGIN
						PRINT 'Found some unmapped Title'
						IF(OBJECT_ID('TEMPDB..#NewTitles') IS NOT NULL)
							DROP TABLE #NewTitles

						CREATE TABLE #NewTitles
						(
							Title_Code					INT,
							NewTitleCode				INT,
							Title_Language_Code			INT,
							New_Title_Language_Code		INT,
							Original_Language_Code		INT,
							New_Original_Language_Code	INT,
							Deal_Type_Code				INT,
							New_Deal_Type_Code			INT,
							Original_Title				NVARCHAR(1000),
							Title_Name					NVARCHAR(1000),
							Synopsis					NVARCHAR(MAX),
							Year_Of_Production			INT,
							Duration_In_Min				DECIMAL(18, 2),
							IsProcessed					CHAR(1) DEFAULT('N')
						)

						IF(OBJECT_ID('TEMPDB..#TitleTalent') IS NOT NULL)
							DROP TABLE #TitleTalent 

						CREATE TABLE #TitleTalent
						(
							Title_Talent_Code		INT,
							New_Title_Talent_Code	INT,
							Talent_Code				INT,
							Talent_Name				NVARCHAR(MAX),
							Gender					CHAR(1),
							New_Talent_Code			INT,
							Role_Code				INT,
							Role_Name				NVARCHAR(MAX),
							Role_Type				CHAR(10),
							Is_Rate_Card			CHAR(10),
							Deal_Type_Code_Role		INT,
							New_Deal_Type_Code_Role	INT,
							New_Role_Code			INT,
							IsProcessed				CHAR(1) DEFAULT('N')
						)

						IF(OBJECT_ID('TEMPDB..#Title_Geners') IS NOT NULL)
							DROP TABLE #Title_Geners 

						CREATE TABLE #Title_Geners
						(
							Title_Geners_Code		INT,
							New_Title_Geners_Code	INT,
							Genres_Code				INT,
							Genres_Name				NVARCHAR(MAX),
							New_Genres_Code				INT,
							IsProcessed				CHAR(1) DEFAULT('N')
						)

						IF(OBJECT_ID('TEMPDB..#Title_Country') IS NOT NULL)
							DROP TABLE #Title_Country

						CREATE TABLE #Title_Country
						(
							Country_Code			INT,
							New_Country_Code		INT
						)

						IF(OBJECT_ID('TEMPDB..#Map_Extended_Columns') IS NOT NULL)
							DROP TABLE #Map_Extended_Columns

						CREATE TABLE #Map_Extended_Columns
						(
							Map_Extended_Columns_Code	INT,
							Column_Code					INT,
							New_Column_Code				INT,
							Column_Name					NVARCHAR(MAX),
							Column_Value_Code			INT,
							New_Column_Value_Code		INT,
							Column_Value_Name			NVARCHAR(MAX),
							Column_Value				NVARCHAR(MAX),
							Is_Multiple_Select			CHAR(1),
							Additional_Code				INT,
							IsProcessed					CHAR(1) DEFAULT('N')
						)

						IF(OBJECT_ID('TEMPDB..#Map_Extended_Columns_Details') IS NOT NULL)
							DROP TABLE #Map_Extended_Columns_Details

						CREATE TABLE #Map_Extended_Columns_Details
						(
							Column_Value_Code			INT,
							New_Column_Value_Code		INT,
							Column_Value_Name			NVARCHAR(MAX),
							Gender						CHAR(1),
						)

						PRINT '  Insert / update unmapped titles in destination database'
						INSERT INTO #NewTitles (
							Title_Code, Title_Language_Code, Original_Language_Code, Deal_Type_Code,
							Original_Title, Title_Name, Synopsis, Year_Of_Production, Duration_In_Min
						)
						SELECT DISTINCT 
							T.Title_Code, T.Title_Language_Code, T.Original_Language_Code, T.Deal_Type_Code, 
							T.Original_Title, T.Title_Name, T.Synopsis, T.Year_Of_Production, T.Duration_In_Min
						FROM #CurrentTitles CT 
						INNER JOIN Title T ON T.Title_Code = CT.Title_Code
						WHERE CT.NewTitleCode = 0

						UPDATE NT SET NT.New_Deal_Type_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #NewTitles NT
						INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'DLTY' AND NT.Deal_Type_Code = MD.PrimaryDataCode

						UPDATE NT SET NT.New_Title_Language_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #NewTitles NT
						INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'LANG' AND NT.Title_Language_Code = MD.PrimaryDataCode

						UPDATE NT SET NT.New_Original_Language_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #NewTitles NT
						INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'LANG' AND NT.Original_Language_Code = MD.PrimaryDataCode
					
						DECLARE @TitleCode INT = 0, @TitleName NVARCHAR(MAX) = '', @NewDealTypeCode INT = 0, @NewTitleCode INT = 0

						SELECT TOP 1 @TitleCode = Title_Code, @TitleName = Title_Name, @NewDealTypeCode = New_Deal_Type_Code FROM #NewTitles 
						WHERE IsProcessed = 'N' AND ISNULL(New_Title_Language_Code, 0) > 0 AND ISNULL(New_Deal_Type_Code, 0) > 0

						IF(@TitleCode > 0)
							PRINT '  *****************************'

						WHILE(@TitleCode > 0)
						BEGIN
							PRINT '  @TitleCode : ' + CAST(@TitleCode AS VARCHAR) + ', @NewDealTypeCode : ' + CAST(@NewDealTypeCode AS VARCHAR) + ', @TitleName : ' + @TitleName 
							PRINT '  Check, if Title already exist'
							SELECT TOP 1 @NewTitleCode = Title_Code FROM RightsU_Plus_S13.dbo.Title T
							WHERE T.Title_Name =  @TitleName AND T.Deal_Type_Code = @NewDealTypeCode

							IF (@NewTitleCode = 0)
							BEGIN	
								PRINT '  Insert new Title in ''Title'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Title(
									Original_Title, Title_Name, Synopsis, Year_Of_Production, Duration_In_Min,
									Title_Language_Code, Original_Language_Code, Deal_Type_Code,
									Is_Active, Inserted_By, Inserted_On, Last_UpDated_Time, Last_Action_By
								)
								SELECT 
									T.Original_Title, T.Title_Name, T.Synopsis, T.Year_Of_Production, T.Duration_In_Min,
									T.New_Title_Language_Code, T.New_Original_Language_Code, T.New_Deal_Type_Code,
									'Y', @UserCode, GETDATE(), GETDATE(), @UserCode 
								FROM #NewTitles T WHERE Title_Code = @TitleCode AND ISNULL(T.New_Title_Language_Code, 0) > 0

								SELECT @NewTitleCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Title')
							END		
							PRINT '  @NewTitleCode : ' + CAST(@NewTitleCode AS VARCHAR)
							IF(ISNULL(@NewTitleCode, 0) > 0)
							BEGIN
							
								IF NOT EXISTS(SELECT TOP 1 * FROM AcqPreReqMappingData WHERE SecondaryDataCode = @NewTitleCode AND MappingFor = 'TITL')
								BEGIN
									PRINT '  Insert mapping entry for Title (MappingFor = ''TITL'') in ''AcqPreReqMappingData'' table'
									INSERT INTO AcqPreReqMappingData(MappingFor, PrimaryDataCode, SecondaryDataCode)VALUES
									('TITL', @TitleCode, @NewTitleCode)
							
									BEGIN /* Title Talent */
										PRINT '    Insert / update talent and map with current title in ''Title_Talent'' table'
										DELETE FROM #TitleTalent
										INSERT INTO #TitleTalent(Title_Talent_Code, Talent_Code, Talent_Name, Gender, Role_Code, Role_Name, Role_Type, Is_Rate_Card, Deal_Type_Code_Role)
										SELECT TT.Title_Talent_Code, T.Talent_Code, T.Talent_Name, T.Gender, 
										R.Role_Code, R.Role_Name,  R.Role_Type, R.Is_Rate_Card, R.Deal_Type_Code
										FROM Title_Talent TT
										INNER JOIN Talent T ON T.Talent_Code = TT.Talent_Code
										INNER JOIN [Role] R ON R.Role_Code = TT.Role_Code
										WHERE Title_Code = @TitleCode

										UPDATE TT SET TT.New_Talent_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #TitleTalent TT
										INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'TALE' AND TT.Talent_Code = MD.PrimaryDataCode

										UPDATE TT SET TT.New_Role_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #TitleTalent TT
										INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'ROLE' AND TT.Role_Code = MD.PrimaryDataCode

										UPDATE TT SET TT.New_Deal_Type_Code_Role = ISNULL(MD.SecondaryDataCode, 0) FROM #TitleTalent TT
										INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'DLTY' AND TT.Deal_Type_Code_Role = MD.PrimaryDataCode

										UPDATE TT_P SET TT_P.New_Title_Talent_Code = TT_S.Title_Talent_Code  FROM #TitleTalent TT_P
										INNER JOIN RightsU_Plus_S13.dbo.Title_Talent TT_S ON TT_S.Talent_Code = TT_P.New_Talent_Code AND TT_S.Role_Code = TT_P.New_Role_Code
										WHERE TT_P.New_Talent_Code > 0 AND TT_P.New_Role_Code > 0 AND TT_S.Title_Code = @NewTitleCode
					
										DECLARE @TitleTalentCode INT = 0, @NewTitleTalentCode INT = 0, @TalentCode INT = 0, @TalentName NVARCHAR(MAX), @Gender CHAR(1), @NewTalentCode INT = 0, 
										@RoleCode INT = 0, @RoleName NVARCHAR(MAX), @RoleType CHAR(10), @IsRateCard	CHAR(10), @NewDealTypeCodeRole INT,  @NewRoleCode INT = 0

										SELECT TOP 1 
											@TitleTalentCode = Title_Talent_Code, @TalentCode = Talent_Code, @TalentName = Talent_Name, @Gender = Gender, @NewTalentCode = ISNULL(New_Talent_Code, 0),  
											@RoleCode = Role_Code, @RoleName = Role_Name, @RoleType = Role_Type, @IsRateCard = Is_Rate_Card, 
											@NewDealTypeCodeRole = New_Deal_Type_Code_Role,  @NewRoleCode = ISNULL(New_Role_Code, 0) 
										FROM #TitleTalent 
										WHERE IsProcessed = 'N' AND ISNULL(New_Title_Talent_Code, 0) = 0 

										IF(@TitleTalentCode > 0)
											PRINT '  ---------------------------'

										WHILE(@TitleTalentCode > 0)
										BEGIN
											IF(@NewTalentCode = 0)
											BEGIN
												PRINT '    @TalentName : ' + @TalentName + ', @Gender : ' + @Gender
												PRINT '    Check, if Talent already exist'
												SELECT TOP 1 @NewTalentCode = Talent_Code FROM RightsU_Plus_S13.dbo.Talent
												WHERE Talent_Name =  @TalentName-- AND Gender = @Gender

												IF(@NewTalentCode = 0)
												BEGIN
													PRINT '    Insert new Talent'
													INSERT INTO RightsU_Plus_S13.dbo.Talent(Talent_Name, Gender, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
													VALUES(@TalentName, @Gender, GETDATE(), @UserCode, GETDATE(), @UserCode)

													SELECT @NewTalentCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Talent')
												END
											END
											PRINT '    @NewTalentCode : ' + CAST(@NewTalentCode AS VARCHAR)

											IF(@NewRoleCode = 0)
											BEGIN
												PRINT '    @RoleName : ' + @RoleName + ', @RoleType : ' + @RoleType
												PRINT '    Check, if Role already exist'

												SELECT TOP 1 @NewRoleCode = Role_Code FROM RightsU_Plus_S13.dbo.[Role] 
												WHERE Role_Name =  @RoleName AND Role_Type = @RoleType

												IF(@NewRoleCode = 0)
												BEGIN
													PRINT '    Insert new Role'
													INSERT INTO RightsU_Plus_S13.dbo.[Role](Role_Name, Role_Type, Is_Rate_Card, Last_Updated_Time, Last_Action_By, Deal_Type_Code)
													VALUES(@RoleName, @RoleType, @IsRateCard, GETDATE(), @UserCode, @NewDealTypeCodeRole)

													SELECT @NewRoleCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Role')
												END
											END
											PRINT '    @NewRoleCode : ' + CAST(@NewRoleCode AS VARCHAR)

											IF NOT EXISTS(SELECT TOP 1 Talent_Role_Code FROM RightsU_Plus_S13.dbo.Talent_Role WHERE Talent_Code = @NewTalentCode AND Role_Code = @NewRoleCode)
											BEGIN
												PRINT '    Map Talent with Role in ''Talent_Role'' table'
												INSERT INTO RightsU_Plus_S13.dbo.Talent_Role(Talent_Code, Role_Code) VALUES(@NewTalentCode, @NewRoleCode)
											END

											IF NOT EXISTS(
												SELECT TOP 1 Title_Talent_Code FROM RightsU_Plus_S13.dbo.Title_Talent 
												WHERE Title_Code = @NewTitleCode AND Talent_Code = @NewTalentCode AND Role_Code = @NewRoleCode
											)
											BEGIN
												PRINT '    Map Talent and Role with Title in ''Title_Talent'' '
												INSERT INTO RightsU_Plus_S13.dbo.Title_Talent(Title_Code, Talent_Code, Role_Code) VALUES(@NewTitleCode,  @NewTalentCode, @NewRoleCode)

												SELECT @NewTitleTalentCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Title_Talent')
											END

											IF NOT EXISTS(SELECT TOP 1 * FROM AcqPreReqMappingData WHERE SecondaryDataCode = @NewTalentCode AND MappingFor = 'TALE')
											BEGIN
												PRINT '    Insert mapping entry for Talent (MappingFor = ''TALE'') in ''AcqPreReqMappingData'' table'
												INSERT INTO AcqPreReqMappingData(MappingFor, PrimaryDataCode, SecondaryDataCode)VALUES
												('TALE', @TalentCode, @NewTalentCode)
											END

											IF NOT EXISTS(SELECT TOP 1 * FROM AcqPreReqMappingData WHERE SecondaryDataCode = @NewRoleCode AND MappingFor = 'ROLE')
											BEGIN
												PRINT '    Insert mapping entry for Role (MappingFor = ''ROLE'') in ''AcqPreReqMappingData'' table'
												INSERT INTO AcqPreReqMappingData(MappingFor, PrimaryDataCode, SecondaryDataCode)VALUES
												('ROLE', @RoleCode, @NewRoleCode)
											END
							
											PRINT '  ---------------------------'
											/*Go For Next Record*/
											UPDATE #TitleTalent SET IsProcessed = 'Y', New_Title_Talent_Code = @NewTitleTalentCode, New_Talent_Code = @NewTitleCode, 
											New_Role_Code = @NewRoleCode
											WHERE Title_Talent_Code = @TitleTalentCode AND IsProcessed = 'N'

											SELECT @NewTitleTalentCode = NULL, @TitleTalentCode = 0, @TalentCode = 0, @TalentName = '', @Gender = '', @NewTalentCode = 0, 
											@RoleCode = 0, @RoleName = '', @RoleType = '', @IsRateCard = '', @NewDealTypeCodeRole = NULL, @NewRoleCode = 0

											SELECT TOP 1 
												@TitleTalentCode = Title_Talent_Code, @TalentCode = Talent_Code, @TalentName = Talent_Name, @Gender = Gender, @NewTalentCode = ISNULL(New_Talent_Code, 0),  
												@RoleCode = Role_Code, @RoleName = Role_Name, @RoleType = Role_Type, @IsRateCard = Is_Rate_Card, 
												@NewDealTypeCodeRole = New_Deal_Type_Code_Role,  @NewRoleCode = ISNULL(New_Role_Code, 0) 
											FROM #TitleTalent 
											WHERE IsProcessed = 'N' AND ISNULL(New_Title_Talent_Code, 0) = 0 
										END
									END

									BEGIN /* Title Genres */
										PRINT '    Insert / update genre and map with current title in ''Title_Geners'' table'
										DELETE FROM #Title_Geners
										INSERT INTO #Title_Geners(Title_Geners_Code, Genres_Code, Genres_Name)
										SELECT TG.Title_Geners_Code, TG.Genres_Code, G.Genres_Name FROM Title_Geners TG
										INNER JOIN Genres G ON G.Genres_Code = TG.Genres_Code AND TG.Title_Code = @TitleCode

										UPDATE TG SET TG.New_Genres_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #Title_Geners TG
										INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'GENR' AND TG.Genres_Code = MD.PrimaryDataCode

										UPDATE TG_P SET TG_P.New_Title_Geners_Code = TG_S.Title_Geners_Code  FROM #Title_Geners TG_P
										INNER JOIN RightsU_Plus_S13.dbo.Title_Geners TG_S ON TG_S.Genres_Code = TG_P.New_Genres_Code AND TG_S.Title_Code = @NewTitleCode
										WHERE TG_P.New_Genres_Code > 0

										INSERT INTO RightsU_Plus_S13.dbo.Genres(Genres_Name, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By, Is_Active)
										SELECT RTRIM(LTRIM(TG.Genres_Name)), GETDATE(), @UserCode, GETDATE(), @UserCode, 'Y'
										FROM #Title_Geners TG WHERE ISNULL(TG.New_Genres_Code, 0) = 0 
										AND NOT EXISTS (
												SELECT TOP 1 Genres_Code FROM RightsU_Plus_S13.dbo.Genres G 
												WHERE RTRIM(LTRIM(G.Genres_Name)) COLLATE SQL_Latin1_General_CP1_CI_AS = RTRIM(LTRIM(TG.Genres_Name)) COLLATE SQL_Latin1_General_CP1_CI_AS
										)
					
										UPDATE TG SET TG.New_Genres_Code = G.Genres_Code  FROM #Title_Geners TG
										INNER JOIN RightsU_Plus_S13.dbo.Genres G ON 
											RTRIM(LTRIM(G.Genres_Name)) COLLATE SQL_Latin1_General_CP1_CI_AS = RTRIM(LTRIM(TG.Genres_Name)) COLLATE SQL_Latin1_General_CP1_CI_AS
										WHERE ISNULL(TG.New_Genres_Code, 0) = 0 AND NOT EXISTS (
											SELECT TOP 1 * FROM AcqPreReqMappingData WHERE SecondaryDataCode = G.Genres_Code AND MappingFor = 'GENR'
										)
					
										INSERT INTO RightsU_Plus_S13.dbo.Title_Geners(Title_Code, Genres_Code)
										SELECT @NewTitleCode, TG_P.New_Genres_Code FROM #Title_Geners TG_P WHERE ISNULL(TG_P.New_Title_Geners_Code, 0) = 0 AND NOT EXISTS (
												SELECT TOP 1 Title_Geners_Code FROM RightsU_Plus_S13.dbo.Title_Geners TG_S 
												WHERE TG_S.Title_Code = @NewTitleCode AND TG_S.Genres_Code = TG_P.New_Genres_Code
										)

										INSERT INTO AcqPreReqMappingData(MappingFor, PrimaryDataCode, SecondaryDataCode)
										SELECT 'GENR', TG.Genres_Code, TG.New_Genres_Code FROM #Title_Geners TG
										WHERE NOT EXISTS (
											SELECT TOP 1 * FROM AcqPreReqMappingData 
											WHERE PrimaryDataCode = TG.Genres_Code AND SecondaryDataCode = TG.New_Genres_Code AND MappingFor = 'GENR'
										)

										UPDATE TG_P SET TG_P.New_Title_Geners_Code = TG_S.Title_Geners_Code  FROM #Title_Geners TG_P
										INNER JOIN RightsU_Plus_S13.dbo.Title_Geners TG_S ON TG_S.Genres_Code = TG_P.New_Genres_Code AND TG_S.Title_Code = @NewTitleCode
										WHERE TG_P.New_Genres_Code > 0 AND ISNULL(TG_P.New_Title_Geners_Code, 0) = 0
									END

									BEGIN /* Title Country */
										PRINT '    Insert / update country and map with current title in ''Title_Country'' table'
										DELETE FROM #Title_Country
										INSERT INTO #Title_Country(Country_Code)
										SELECT DISTINCT TC.Country_Code FROM Title_Country TC WHERE TC.Title_Code = @TitleCode

										UPDATE TC SET TC.New_Country_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #Title_Country TC
										INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'CONT' AND TC.Country_Code = MD.PrimaryDataCode

										INSERT INTO RightsU_Plus_S13.dbo.Title_Country(Title_Code, Country_Code)
										SELECT @NewTitleCode, TC_P.New_Country_Code FROM #Title_Country TC_P WHERE ISNULL(TC_P.New_Country_Code, 0) > 0 AND NOT EXISTS (
												SELECT TOP 1 Title_Country_Code FROM RightsU_Plus_S13.dbo.Title_Country TC_S 
												WHERE TC_S.Title_Code = @NewTitleCode AND TC_S.Country_Code = TC_P.New_Country_Code
										)
									END

									BEGIN /* Map Extended Columns */
										PRINT '  Map Extended Columns'
										PRINT '    Insert / update Extended Columns and map with current title in ''Map_Extended_Columns'' table'
										DELETE FROM #Map_Extended_Columns
										INSERT INTO #Map_Extended_Columns(Map_Extended_Columns_Code, Column_Code, Column_Value_Code, Column_Value, Is_Multiple_Select)
										SELECT MEC.Map_Extended_Columns_Code, MEC.Columns_Code, MEC.Columns_Value_Code, MEC.Column_Value, MEC.Is_Multiple_Select
										FROM Map_Extended_Columns MEC 
										WHERE MEC.Record_Code = @TitleCode

										UPDATE MEC SET MEC.New_Column_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #Map_Extended_Columns MEC
										INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'EXCO' AND MEC.Column_Code = MD.PrimaryDataCode

										UPDATE MEC SET MEC.New_Column_Value_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #Map_Extended_Columns MEC
										INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'EXCV' AND MEC.Column_Value_Code = MD.PrimaryDataCode

										UPDATE MEC SET MEC.IsProcessed = 'Y' FROM #Map_Extended_Columns MEC
										WHERE MEC.Is_Multiple_Select = 'N' AND ISNULL(MEC.New_Column_Code, 0) > 0 AND (
											ISNULL(MEC.New_Column_Value_Code, 0) > 0 OR ISNULL(MEC.Column_Value, '') <> ''
										)

										UPDATE MEC SET MEC.Column_Name = EC.Columns_Name, MEC.Column_Value_Name = ECV.Columns_Value, MEC.Additional_Code = EC.Additional_Condition
										FROM #Map_Extended_Columns MEC
										INNER JOIN Extended_Columns EC ON EC.Columns_Code = MEC.Column_Code
										LEFT JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MEC.Column_Value_Code
										WHERE ISNULL(MEC.IsProcessed, 'N') = 'N'

										UPDATE MEC SET MEC.New_Column_Code = EC.Columns_Code FROM #Map_Extended_Columns MEC
										INNER JOIN RightsU_Plus_S13.dbo.Extended_Columns EC ON 
											RTRIM(LTRIM(EC.Columns_Name)) COLLATE SQL_Latin1_General_CP1_CI_AS = 
											RTRIM(LTRIM(MEC.Column_Name)) COLLATE SQL_Latin1_General_CP1_CI_AS
										WHERE ISNULL(MEC.IsProcessed, 'N') = 'N' AND NOT EXISTS (
											SELECT TOP 1 * FROM AcqPreReqMappingData WHERE SecondaryDataCode = EC.Columns_Code AND MappingFor = 'EXCO'
										)

										DELETE FROM #Map_Extended_Columns WHERE ISNULL(New_Column_Code, 0) = 0

										UPDATE MEC SET MEC.IsProcessed = 'Y' FROM #Map_Extended_Columns MEC
										WHERE MEC.Is_Multiple_Select = 'N' AND ISNULL(MEC.IsProcessed, 'N') = 'N' AND ISNULL(MEC.New_Column_Code, 0) > 0 AND (
											ISNULL(MEC.New_Column_Value_Code, 0) > 0 OR ISNULL(MEC.Column_Value, '') <> ''
										)

										INSERT INTO AcqPreReqMappingData(MappingFor, PrimaryDataCode, SecondaryDataCode)
										SELECT 'EXCO', MEC.Column_Code, MEC.New_Column_Code FROM #Map_Extended_Columns MEC
										WHERE ISNULL(MEC.IsProcessed, 'N') = 'N' AND NOT EXISTS (
											SELECT TOP 1 * FROM AcqPreReqMappingData 
											WHERE PrimaryDataCode = MEC.Column_Code AND SecondaryDataCode = MEC.New_Column_Code AND MappingFor = 'EXCO'
										)

										INSERT INTO RightsU_Plus_S13.dbo.Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Columns_Value_Code, Column_Value, Is_Multiple_Select)
										SELECT @NewTitleCode, 'TITLE', New_Column_Code, New_Column_Value_Code, Column_Value, Is_Multiple_Select
										FROM #Map_Extended_Columns MEC WHERE ISNULL(IsProcessed, 'N') = 'Y' AND NOT EXISTS (
											SELECT TOP 1 Map_Extended_Columns_Code FROM RightsU_Plus_S13.dbo.Map_Extended_Columns MEC2 
											WHERE MEC2.Record_Code = @NewTitleCode AND MEC2.Columns_Code = MEC.Column_Code
										)

										DECLARE @MapExtendedColumnsCode INT = 0, @NewMapExtendedColumnsCode INT = 0, @ColumnCode INT = 0, @NewColumnCode INT = 0, 
										@ColumnsValueCode INT = 0, @NewColumnValueCode INT = 0, @ColumnValueName NVARCHAR(MAX), 
										@ColumnValue NVARCHAR(MAX), @IsMultipleSelect CHAR(1) = 'N', @AdditionalCode INT

										SELECT TOP 1 
											@MapExtendedColumnsCode = Map_Extended_Columns_Code, @ColumnCode = Column_Code, @NewColumnCode = New_Column_Code, 
											@ColumnsValueCode = Column_Value_Code, @NewColumnValueCode = New_Column_Value_Code, @ColumnValueName = Column_Value_Name, 
											@ColumnValue = Column_Value, @IsMultipleSelect = Is_Multiple_Select, @AdditionalCode = Additional_Code
										FROM #Map_Extended_Columns WHERE IsProcessed = 'N'

										IF(@TitleTalentCode > 0)
											PRINT '  ---------------------------'

										WHILE(@MapExtendedColumnsCode > 0)
										BEGIN
									
											PRINT '    @MapExtendedColumnsCode : ' + CAST(@MapExtendedColumnsCode AS VARCHAR)
											PRINT '    @ColumnCode : ' + CAST(ISNULL(@ColumnCode, 0) AS VARCHAR) + ', @NewColumnCode : ' + CAST(ISNULL(@NewColumnCode, 0) AS VARCHAR)
											PRINT '    @ColumnsValueCode : ' + CAST(ISNULL(@ColumnsValueCode, 0) AS VARCHAR) + ', @NewColumnValueCode : ' + CAST(ISNULL(@NewColumnValueCode, 0) AS VARCHAR)
											PRINT '    @@ColumnValueName : ' + ISNULL(@ColumnValueName, 'NULL') + ', @ColumnValue : ' + ISNULL(@ColumnValue, 'NULL')
											PRINT '    @IsMultipleSelect : ' + @IsMultipleSelect + ', @AdditionalCode : ' + CAST(ISNULL(@AdditionalCode, 0) AS VARCHAR)

											IF(ISNULL(@NewColumnValueCode, 0) = 0 AND ISNULL(@ColumnsValueCode, 0) > 0)
											BEGIN
												PRINT '    Check, if Column_Value already exist'
												SELECT TOP 1 @NewColumnValueCode = Columns_Value_Code FROM RightsU_Plus_S13.dbo.Extended_Columns_Value 
												WHERE Columns_Code = @ColumnCode AND Columns_Value = @ColumnValueName

												IF(ISNULL(@NewColumnValueCode, 0) = 0)
												BEGIN
													PRINT '    Insert new Column_Value in ''Extended_Columns_Value'' '
													INSERT INTO RightsU_Plus_S13.dbo.Extended_Columns_Value(Columns_Code, Columns_Value)
													VALUEs(@NewColumnCode, @ColumnValueName)

													SELECT @NewColumnValueCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Extended_Columns_Value')
												END
											END

											PRINT '    Map Extended Columns with title in ''Map_Extended_Columns'' table'
											INSERT INTO RightsU_Plus_S13.dbo.Map_Extended_Columns(
												Record_Code, Table_Name, Columns_Code, Columns_Value_Code, Column_Value, Is_Multiple_Select
											)
											SELECT @NewTitleCode, 'TITLE', @NewColumnCode, @NewColumnValueCode, @ColumnValue, @IsMultipleSelect WHERE NOT EXISTS (
												SELECT TOP 1 Map_Extended_Columns_Code FROM RightsU_Plus_S13.dbo.Map_Extended_Columns MEC2 
												WHERE MEC2.Record_Code = @NewTitleCode AND MEC2.Columns_Code = @NewColumnCode
											)

											SELECT @NewMapExtendedColumnsCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Map_Extended_Columns')

											IF(@IsMultipleSelect = 'Y')
											BEGIN
												PRINT '    Extended Column allows multiple selection for value'
												DECLARE @IsRef CHAR(1), @IsDefValue CHAR(1), @RefTableName VARCHAR(250)
												SELECT TOP 1 @IsRef = ISNULL(Is_Ref, ''), @IsDefValue = ISNULL(Is_Defined_Values, ''), @RefTableName = ISNULL(Ref_Table, '')
												FROM Extended_Columns WHERE Columns_Code = @ColumnCode

												INSERT INTO #Map_Extended_Columns_Details(Column_Value_Code)
												SELECT Columns_Value_Code FROM Map_Extended_Columns_Details WHERE Map_Extended_Columns_Code = @MapExtendedColumnsCode

												PRINT '    @IsRef : ' + @IsRef + ', @IsDefValue : ' + @IsDefValue + ', @RefTableName : ' + @RefTableName

												IF(@IsRef = 'Y' AND @IsDefValue <> 'Y')
												BEGIN
													IF(UPPER(RTRIM(LTRIM(@RefTableName))) = 'TALENT')
													BEGIN
														PRINT '    Multiple Selection of Talent'
														UPDATE MECD SET MECD.New_Column_Value_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #Map_Extended_Columns_Details MECD
														INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'TALE' AND MECD.Column_Value_Code = MD.PrimaryDataCode

														UPDATE MECD SET MECD.Column_Value_Name = T.Talent_Name, MECD.Gender = T.Gender FROM #Map_Extended_Columns_Details MECD
														INNER JOIN Talent T ON T.Talent_Code = MECD.Column_Value_Code
														WHERE ISNULL(MECD.New_Column_Value_Code, 0) = 0

														UPDATE MECD SET MECD.New_Column_Value_Code = T.Talent_Code FROM #Map_Extended_Columns_Details MECD
														INNER JOIN RightsU_Plus_S13.dbo.Talent T ON 
															T.Talent_Name COLLATE SQL_Latin1_General_CP1_CI_AS = MECD.Column_Value_Name COLLATE SQL_Latin1_General_CP1_CI_AS
														WHERE ISNULL(MECD.New_Column_Value_Code, 0) = 0 AND NOT EXISTS (
															SELECT TOP 1 * FROM AcqPreReqMappingData WHERE SecondaryDataCode = T.Talent_Code AND MappingFor = 'TALE'
														)

														INSERT INTO RightsU_Plus_S13.dbo.Talent(Talent_Name, Gender, Inserted_On, Inserted_By, Last_Updated_Time, Last_Action_By)
														SELECT Column_Value_Name, Gender, GETDATE(), @UserCode, GETDATE(), @UserCode
														FROM #Map_Extended_Columns_Details WHERE ISNULL(New_Column_Value_Code, 0) = 0 AND NOT EXISTS (
															SELECT TOP 1 Talent_Code FROM RightsU_Plus_S13.dbo.Talent WHERE Talent_Name =  @TalentName
														)

														UPDATE MECD SET MECD.New_Column_Value_Code = T.Talent_Code FROM #Map_Extended_Columns_Details MECD
														INNER JOIN RightsU_Plus_S13.dbo.Talent T ON 
															T.Talent_Name COLLATE SQL_Latin1_General_CP1_CI_AS = MECD.Column_Value_Name COLLATE SQL_Latin1_General_CP1_CI_AS
														WHERE ISNULL(MECD.New_Column_Value_Code, 0) = 0

														PRINT '    Insert mapping entry for Talent (MappingFor = ''TALE'') in ''AcqPreReqMappingData'' table, if not exists'
														INSERT INTO AcqPreReqMappingData(MappingFor, PrimaryDataCode, SecondaryDataCode)
														SELECT 'TALE', MECD.Column_Value_Code, MECD.New_Column_Value_Code FROM #Map_Extended_Columns_Details MECD
														WHERE ISNULL(MECD.New_Column_Value_Code, 0) > 0 AND NOT EXISTS (
															SELECT TOP 1 * FROM AcqPreReqMappingData 
															WHERE PrimaryDataCode = MECD.Column_Value_Code AND SecondaryDataCode = MECD.New_Column_Value_Code 
															AND MappingFor = 'TALE'
														)

														DECLARE @NewAdditionalCode INT = 0, @NewDealTypeCodeAC INT = 0
														IF(ISNULL(@AdditionalCode, 0) > 0)
														BEGIN
															PRINT '    Get mapped role (additional condition) code for talents'
															SELECT TOP 1 @NewAdditionalCode = SecondaryDataCode FROM AcqPreReqMappingData
															WHERE MappingFor = 'ROLE' AND PrimaryDataCode = @AdditionalCode

															PRINT '    @NewAdditionalCode : ' + CAST(ISNULL(@NewAdditionalCode, 0) AS VARCHAR)
															IF(ISNULL(@NewAdditionalCode, 0) = 0)
															BEGIN
																PRINT '    Check, if Role (additional condition) already exist'
																SELECT TOP 1 @NewAdditionalCode = RS.Role_Code FROM [Role] RP
																INNER JOIN RightsU_Plus_S13.dbo.[Role] RS ON RP.Role_Code = @AdditionalCode AND
																RP.Role_Name = RS.Role_Name AND RP.Role_Type = RS.Role_Type

																IF(ISNULL(@NewAdditionalCode, 0) = 0)
																BEGIN														
																	PRINT '    Insert new Role (additional condition)'
																	SELECT TOP 1 @NewDealTypeCodeAC = MD.SecondaryDataCode FROM [Role] R 
																	INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'DLTY' AND MD.PrimaryDataCode = R.Role_Code
																	WHERE R.Role_Code = @AdditionalCode

																	INSERT INTO RightsU_Plus_S13.dbo.[Role](
																		Role_Name, Role_Type, Is_Rate_Card, Last_Updated_Time, Last_Action_By, Deal_Type_Code
																	)
																	SELECT R.Role_Name, R.Role_Type, R.Is_Rate_Card, GETDATE(), @UserCode, @NewDealTypeCodeAC FROM [Role] R 
																	WHERE R.Role_Code = @AdditionalCode AND @NewDealTypeCodeAC > 0

																	SELECT @NewAdditionalCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Role')
																END

																PRINT '    @NewAdditionalCode : ' + CAST(ISNULL(@NewAdditionalCode, 0) AS VARCHAR)

																IF NOT EXISTS (SELECT * FROM AcqPreReqMappingData WHERE SecondaryDataCode = @NewAdditionalCode AND MappingFor = 'ROLE')
																BEGIN
																	PRINT '    Insert mapping entry for Role (MappingFor = ''ROLE'') (additional condition) in ''AcqPreReqMappingData'' table'
																	INSERT INTO AcqPreReqMappingData(MappingFor, PrimaryDataCode, SecondaryDataCode)
																	SELECT 'ROLE', @AdditionalCode, @NewAdditionalCode	
																END
															END

															PRINT '    Map Talent with Role in ''Talent_Role'' table, if not exists'
															INSERT INTO RightsU_Plus_S13.dbo.Talent_Role(Talent_Code, Role_Code)
															SELECT MECD.New_Column_Value_Code, @NewAdditionalCode FROM #Map_Extended_Columns_Details MECD WHERE ISNULL(MECD.New_Column_Value_Code, 0) > 0
															AND NOT EXISTS (
																SELECT * FROM RightsU_Plus_S13.dbo.Talent_Role TR WHERE TR.Role_Code = @NewAdditionalCode AND TR.Talent_Code = MECD.New_Column_Value_Code
															)
														END
													END
												END
												IF(@IsRef = 'Y' AND @IsDefValue = 'Y')
												BEGIN
													PRINT '    Multiple Selection for Defined options'
													UPDATE MECD SET MECD.New_Column_Value_Code = ISNULL(MD.SecondaryDataCode, 0) FROM #Map_Extended_Columns_Details MECD
													INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'EXCV' AND MECD.Column_Value_Code = MD.PrimaryDataCode

													UPDATE MECD SET MECD.Column_Value_Name = ECV.Columns_Value FROM #Map_Extended_Columns_Details MECD
													INNER JOIN Extended_Columns_Value ECV ON ECV.Columns_Value_Code = MECD.Column_Value_Code
													WHERE ISNULL(MECD.New_Column_Value_Code, 0) = 0

													UPDATE MECD SET MECD.New_Column_Value_Code = ECV.Columns_Value_Code FROM #Map_Extended_Columns_Details MECD
													INNER JOIN RightsU_Plus_S13.dbo.Extended_Columns_Value ECV ON ECV.Columns_Code = @NewColumnCode AND 
														ECV.Columns_Value COLLATE SQL_Latin1_General_CP1_CI_AS = MECD.Column_Value_Name COLLATE SQL_Latin1_General_CP1_CI_AS
													WHERE ISNULL(MECD.New_Column_Value_Code, 0) = 0

													INSERT INTO RightsU_Plus_S13.dbo.Extended_Columns_Value(Columns_Code, Columns_Value)
													SELECT @NewColumnCode, Column_Value_Code FROM #Map_Extended_Columns_Details WHERE ISNULL(New_Column_Value_Code, 0) = 0

													UPDATE MECD SET MECD.New_Column_Value_Code = ECV.Columns_Value_Code FROM #Map_Extended_Columns_Details MECD
													INNER JOIN RightsU_Plus_S13.dbo.Extended_Columns_Value ECV ON ECV.Columns_Code = @NewColumnCode AND 
														ECV.Columns_Value COLLATE SQL_Latin1_General_CP1_CI_AS = MECD.Column_Value_Name COLLATE SQL_Latin1_General_CP1_CI_AS
													WHERE ISNULL(MECD.New_Column_Value_Code, 0) = 0

													INSERT INTO AcqPreReqMappingData(MappingFor, PrimaryDataCode, SecondaryDataCode)
													SELECT 'EXCV', MECD.Column_Value_Code, MECD.New_Column_Value_Code FROM #Map_Extended_Columns_Details MECD
													WHERE NOT EXISTS (
														SELECT TOP 1 * FROM AcqPreReqMappingData 
														WHERE PrimaryDataCode = MECD.Column_Value_Code AND SecondaryDataCode = MECD.New_Column_Value_Code 
														AND MappingFor = 'EXCV'
													)
												END
											END

											INSERT INTO RightsU_Plus_S13.dbo.Map_Extended_Columns_Details(Map_Extended_Columns_Code, Columns_Value_Code)
											SELECT @NewMapExtendedColumnsCode, New_Column_Value_Code FROM #Map_Extended_Columns_Details

											PRINT '  ---------------------------'

											/*Go For Next Record*/		
											UPDATE #Map_Extended_Columns SET IsProcessed = 'Y' WHERE Map_Extended_Columns_Code = @MapExtendedColumnsCode

											SELECT @MapExtendedColumnsCode = 0, @ColumnCode = 0, @NewColumnCode = 0, @ColumnsValueCode = 0, @NewColumnValueCode = 0, 
											@ColumnValueName = NULL, @ColumnValue = NULL, @IsMultipleSelect = 'N' , @AdditionalCode = NULL

											SELECT TOP 1 
												@MapExtendedColumnsCode = Map_Extended_Columns_Code, @ColumnCode = Column_Code, @NewColumnCode = New_Column_Code, 
												@ColumnsValueCode = Column_Value_Code, @NewColumnValueCode = New_Column_Value_Code, @ColumnValueName = Column_Value_Name, 
												@ColumnValue = Column_Value, @IsMultipleSelect = Is_Multiple_Select, @AdditionalCode = Additional_Code
											FROM #Map_Extended_Columns WHERE IsProcessed = 'N'
										END
									END
								END
							END
						
							PRINT '  *****************************'
							/*Go For Next Record*/		
							UPDATE #CurrentTitles SET NewTitleCode = @NewTitleCode WHERE Title_Code = @TitleCode
							UPDATE #NewTitles SET NewTitleCode = @NewTitleCode, IsProcessed = 'Y' WHERE Title_Code = @TitleCode AND IsProcessed = 'N' 

							SELECT @TitleCode = 0, @TitleName = '', @NewDealTypeCode = 0, @NewTitleCode = 0

							SELECT TOP 1 @TitleCode = Title_Code, @TitleName = Title_Name, @NewDealTypeCode = New_Deal_Type_Code FROM #NewTitles 
							WHERE IsProcessed = 'N' AND ISNULL(New_Title_Language_Code, 0) > 0 AND ISNULL(New_Deal_Type_Code, 0) > 0
						END
					END
					ELSE 
					BEGIN
						PRINT 'Found all Title mapped'
					END
				END

				BEGIN /* Get Mapped Platform */
					PRINT 'Get Mapped Platform'
					IF(OBJECT_ID('TEMPDB..#CurrentPlatform') IS NOT NULL)
						DROP TABLE #CurrentPlatform

					CREATE TABLE #CurrentPlatform
					(
						Platform_Code	INT,
						NewPlatformCode	INT DEFAULT(0)
					)

					INSERT INTO #CurrentPlatform(Platform_Code)
					SELECT DISTINCT SDRP.Platform_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Platform SDRP ON SDRP.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRP.Platform_Code IS NOT NULL
					UNION 
					SELECT DISTINCT SDRH.Holdback_On_Platform_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Holdback SDRH  ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRH.Holdback_On_Platform_Code IS NOT NULL
					UNION 
					SELECT DISTINCT SDRHP.Platform_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					INNER JOIN Syn_Deal_Rights_Holdback_Platform SDRHP ON SDRHP.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRHP.Platform_Code IS NOT NULL

					UPDATE CP SET CP.NewPlatformCode = ISNULL(MD.SecondaryDataCode, 0) FROM #CurrentPlatform CP
					INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'PLAT' AND CP.Platform_Code = MD.PrimaryDataCode

					IF EXISTS(SELECT TOP 1 * FROM #CurrentPlatform WHERE NewPlatformCode = 0)
					BEGIN
						PRINT 'Found some unmapped Platform'
					END
				END 

				BEGIN /* Get Mapped Country */
					PRINT 'Get Mapped Country'
					IF(OBJECT_ID('TEMPDB..#CurrentCountry') IS NOT NULL)
						DROP TABLE #CurrentCountry

					CREATE TABLE #CurrentCountry
					(
						Country_Code	INT,
						NewCountryCode	INT DEFAULT(0)
					)

					INSERT INTO #CurrentCountry(Country_Code)
					SELECT DISTINCT SDRT.Country_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Territory SDRT ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRT.Territory_Type <> 'G' AND SDRT.Country_Code IS NOT NULL
					UNION 
					SELECT DISTINCT SDRHT.Country_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Holdback SDRH  ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					INNER JOIN Syn_Deal_Rights_Holdback_Territory SDRHT ON SDRHT.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRHT.Territory_Type <> 'G' AND SDRHT.Country_Code IS NOT NULL

					UPDATE CC SET CC.NewCountryCode = ISNULL(MD.SecondaryDataCode, 0) FROM #CurrentCountry CC
					INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'CONT' AND CC.Country_Code = MD.PrimaryDataCode

					IF EXISTS(SELECT TOP 1 * FROM #CurrentCountry WHERE NewCountryCode = 0)
					BEGIN
						PRINT 'Found some unmapped Country'
					END
				END 

				BEGIN /* Get Mapped Territory Code */
					PRINT 'Get Mapped Territory'

					IF(OBJECT_ID('TEMPDB..#CurrentTerritory') IS NOT NULL)
						DROP TABLE #CurrentTerritory

					CREATE TABLE #CurrentTerritory
					(
						Territory_Code		INT,
						NewTerritoryCode	INT DEFAULT(0)
					)

					INSERT INTO #CurrentTerritory(Territory_Code)
					SELECT DISTINCT SDRT.Territory_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Territory SDRT ON SDRT.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRT.Territory_Type = 'G' AND SDRT.Territory_Code IS NOT NULL
					UNION 
					SELECT DISTINCT SDRHT.Territory_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Holdback SDRH  ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					INNER JOIN Syn_Deal_Rights_Holdback_Territory SDRHT ON SDRHT.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRHT.Territory_Type = 'G' AND SDRHT.Territory_Code IS NOT NULL

					UPDATE CT SET CT.NewTerritoryCode = ISNULL(MD.SecondaryDataCode, 0) FROM #CurrentTerritory CT
					INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'TERR' AND CT.Territory_Code = MD.PrimaryDataCode

					IF EXISTS(SELECT TOP 1 * FROM #CurrentTerritory WHERE NewTerritoryCode = 0)
					BEGIN
						PRINT 'Found some unmapped Territory'
					END
				END

				BEGIN /* Get Mapped Language */
					PRINT 'Get Mapped Language'

					IF(OBJECT_ID('TEMPDB..#CurrentLanguage') IS NOT NULL)
						DROP TABLE #CurrentLanguage

					CREATE TABLE #CurrentLanguage
					(
						Language_Code	INT,
						NewLanguageCode	INT DEFAULT(0)
					)

					INSERT INTO #CurrentLanguage(Language_Code)
					SELECT DISTINCT SDRS.Language_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Subtitling SDRS ON SDR.Syn_Deal_Rights_Code = SDRS.Syn_Deal_Rights_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRS.Language_Type <> 'G' AND SDRS.Language_Code IS NOT NULL
					UNION 
					SELECT DISTINCT SDRD.Language_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Dubbing SDRD ON SDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code 
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRD.Language_Type <> 'G' AND SDRD.Language_Code IS NOT NULL
					UNION 
					SELECT DISTINCT SDRHS.Language_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Holdback SDRH  ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					INNER JOIN Syn_Deal_Rights_Holdback_Subtitling SDRHS ON SDRHS.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRHS.Language_Code IS NOT NULL
					UNION 
					SELECT DISTINCT SDRHD.Language_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Holdback SDRH  ON SDRH.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code
					INNER JOIN Syn_Deal_Rights_Holdback_Dubbing SDRHD ON SDRHD.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRHD.Language_Code IS NOT NULL

					UPDATE CL SET CL.NewLanguageCode = ISNULL(MD.SecondaryDataCode, 0) FROM #CurrentLanguage CL
					INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'LANG' AND CL.Language_Code = MD.PrimaryDataCode

					IF EXISTS(SELECT TOP 1 * FROM #CurrentLanguage WHERE NewLanguageCode = 0)
					BEGIN
						PRINT 'Found some unmapped Language'
					END
				END

				BEGIN /* Get Mapped Language Group */
					PRINT 'Get Mapped Language Group' 
					IF(OBJECT_ID('TEMPDB..#CurrentLanguageGroup') IS NOT NULL)
						DROP TABLE #CurrentLanguageGroup

					CREATE TABLE #CurrentLanguageGroup
					(
						Language_Group_Code		INT,
						NewLanguageGroupCode	INT DEFAULT(0)
					)

					INSERT INTO #CurrentLanguageGroup(Language_Group_Code)
					SELECT DISTINCT SDRS.Language_Group_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Subtitling SDRS ON SDR.Syn_Deal_Rights_Code = SDRS.Syn_Deal_Rights_Code
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRS.Language_Type = 'G' AND SDRS.Language_Group_Code IS NOT NULL
					UNION 
					SELECT DISTINCT SDRD.Language_Group_Code FROM Syn_Deal_Rights SDR
					INNER JOIN Syn_Deal_Rights_Dubbing SDRD ON SDRD.Syn_Deal_Rights_Code = SDR.Syn_Deal_Rights_Code 
					WHERE SDR.Syn_Deal_Code = @SynDealCode AND SDRD.Language_Type = 'G' AND SDRD.Language_Group_Code IS NOT NULL

					UPDATE CL SET CL.NewLanguageGroupCode = ISNULL(MD.SecondaryDataCode, 0) FROM #CurrentLanguageGroup CL
					INNER JOIN AcqPreReqMappingData MD ON MD.MappingFor = 'LAGR' AND CL.Language_Group_Code = MD.PrimaryDataCode

					IF EXISTS(SELECT TOP 1 * FROM #CurrentLanguageGroup WHERE NewLanguageGroupCode = 0)
					BEGIN
						PRINT 'Found some unmapped Language Group'
					END
				END

			END
			BEGIN /* Insert into Acq_Deal */
				SELECT TOP 1  @DealTagCode_P = ISNULL(Deal_Tag_Code, 0),  @DealTypeCode_P = ISNULL(Deal_Type_Code, 0), @CurrencyCode_P = ISNULL(Currency_Code, 0), 
				@CategoryCode_P = ISNULL(Category_Code, 0), @BusinessUnitCode_P = ISNULL(Business_Unit_Code, 0), 
				@VendorCode_P = ISNULL(Vendor_Code, 0), @VendorContactCode_P = ISNULL(Vendor_Contact_Code, 0)
				FROM Syn_Deal WHERE Syn_Deal_Code = @SynDealCode

				--IF(@RoleCode_Deal_P > 0)
				--BEGIN
				--	SELECT TOP 1 @RoleCode_Deal_S = SecondaryDataCode FROM AcqPreReqMappingData MD WHERE MD.MappingFor = 'ROLE' AND PrimaryDataCode = @RoleCode_Deal_P
				--END

				IF(@DealTagCode_P > 0)
				BEGIN
					PRINT 'Get Mapped Deal Tag Code'
					SELECT TOP 1 @DealTagCode_S = SecondaryDataCode FROM AcqPreReqMappingData MD WHERE MD.MappingFor = 'DETA' AND PrimaryDataCode = @DealTagCode_P
				END

				IF(@DealTypeCode_P > 0)
				BEGIN
					PRINT 'Get Mapped Deal Type Code'
					SELECT TOP 1 @DealTypeCode_S = SecondaryDataCode FROM AcqPreReqMappingData MD WHERE MD.MappingFor = 'DLTY' AND PrimaryDataCode = @DealTypeCode_P
				END

				IF(@CurrencyCode_P > 0)
				BEGIN
					PRINT 'Get Mapped Currency Code'
					SELECT TOP 1 @CurrencyCode_S = SecondaryDataCode FROM AcqPreReqMappingData MD WHERE MD.MappingFor = 'CURR' AND PrimaryDataCode = @CurrencyCode_P
				END

				IF(@CategoryCode_P > 0)
				BEGIN
					PRINT 'Get Mapped Category Code'
					SELECT TOP 1 @CategoryCode_S = SecondaryDataCode FROM AcqPreReqMappingData MD WHERE MD.MappingFor = 'CATE' AND PrimaryDataCode = @CategoryCode_P
				END

				IF(@BusinessUnitCode_P > 0)
				BEGIN
					PRINT 'Get Mapped Business Unit Code'
					SELECT TOP 1 @BusinessUnitCode_S = SecondaryDataCode FROM AcqPreReqMappingData MD WHERE MD.MappingFor = 'BUUN' AND PrimaryDataCode = @BusinessUnitCode_P
				END

				IF(@VendorCode_P > 0)
				BEGIN
					PRINT 'Get Mapped Vendor Code'
					SELECT TOP 1 @VendorCode_S = SecondaryDataCode FROM AcqPreReqMappingData MD WHERE MD.MappingFor = 'VEND' AND PrimaryDataCode = @VendorCode_P
				END

				IF(@VendorContactCode_P > 0)
				BEGIN
					PRINT 'Get Mapped Vendor Contact Code'
					SELECT TOP 1 @VendorContactCode_S = SecondaryDataCode FROM AcqPreReqMappingData MD WHERE MD.MappingFor = 'VECO' AND PrimaryDataCode = @VendorContactCode_P
				END

				PRINT 'Insert data in ''Acq_Deal'' table'
				INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal(
					[Agreement_No],
					[Version], [Agreement_Date], [Deal_Desc], [Deal_Type_Code], [Year_Type], [Entity_Code], [Is_Master_Deal], [Category_Code], [Vendor_Code], 
					[Vendor_Contacts_Code], [Currency_Code], [Exchange_Rate], [Ref_No], [Attach_Workflow], [Deal_Workflow_Status], [Work_Flow_Code], [Is_Completed], 
					[Is_Active], [Payment_Terms_Conditions], [Status], [Is_Migrated], [Deal_Tag_Code], [Business_Unit_Code], [Remarks], [Rights_Remarks], [Payment_Remarks], 
					[Role_Code], [Deal_Complete_Flag], [Inserted_By], [Inserted_On], [Last_Updated_Time], [Last_Action_By]
	
					--, [Parent_Deal_Code], [All_Channel],[Channel_Cluster_Code]
					--, [Amendment_Date], [Is_Released], [Release_On], [Release_By], [Content_Type], [Is_Auto_Generated], [Ref_BMS_Code]
					--, [Cost_Center_Id], [Master_Deal_Movie_Code_ToLink], [BudgetWise_Costing_Applicable], [Validate_CostWith_Budget]
				) 

				SELECT TOP 1
					[dbo].[UFN_Auto_Genrate_Agreement_No]('A', [Agreement_Date], 0) [Agreement_No],
					[Version], [Agreement_Date], [Deal_Description], @DealTypeCode_S, [Year_Type], [Entity_Code], 'Y', [Category_Code], @VendorCode_S,
					@VendorContactCode_S, @CurrencyCode_S, [Exchange_Rate], [Ref_No], [Attach_Workflow], 'N', NULL, [Is_Completed], 
					[Is_Active], [Payment_Terms_Conditions], [Status], [Is_Migrated], @DealTagCode_S, @BusinessUnitCode_S, [Remarks], [Rights_Remarks], [Payment_Remarks], 
					@RoleCode_Deal, @DealCompleteFlag, @UserCode, [Inserted_On], [Last_Updated_Time], @UserCode

					--, NULL, NULL, NULL
					--, NULL, NULL, NULL, NULL, NULL, NULL, NULL
					--, NULL, NULL, NULL, NULL
				FROM Syn_Deal WHERE Syn_Deal_Code = @SynDealCode

				SELECT @NewAcqDealCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Acq_Deal')
				PRINT '@NewAcqDealCode : ' + CAST(@NewAcqDealCode AS VARCHAR)
			
				IF(ISNULL(@NewAcqDealCode, 0) > 0)
				BEGIN
					PRINT '  Insert data in ''Acq_Deal_Movie'' table'
					INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Movie(
						Acq_Deal_Code, Title_Code, No_Of_Episodes, Title_Type, Episode_Starts_From, Episode_End_To
					)
					SELECT @NewAcqDealCode, CT.NewTitleCode, SDM.No_Of_Episode, SDM.Syn_Title_Type, SDM.Episode_From, SDM.Episode_End_To
					FROM Syn_Deal_Movie SDM
					INNER JOIN #CurrentTitles CT ON SDM.Title_Code = CT.Title_Code AND SDM.Episode_From = CT.Episode_From AND SDM.Episode_End_To = CT.Episode_To
					WHERE SDM.Syn_Deal_Code = @SynDealCode

					PRINT '  Insert data in ''Acq_Deal_Licensor'' table'
					INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Licensor(Acq_Deal_Code, Vendor_Code) 
					VALUES(@NewAcqDealCode, @VendorCode_S)
				END
			END

			IF(ISNULL(@NewAcqDealCode, 0) > 0)
			BEGIN 
				IF EXISTS(SELECT TOP 1 Syn_Deal_Rights_Code, ISNULL(Is_Pushback, 'N') AS IsPushback FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @SynDealCode)
				BEGIN
					PRINT '  *****************************'
					DECLARE @NewAcqDealRightsCode INT = 0, @NewAcqDealPushbackCode INT = 0, @SynDealRightsCode INT = 0, @IsPushback CHAR(1) = ''
					DECLARE rightsCursor CURSOR FOR 
						SELECT Syn_Deal_Rights_Code, ISNULL(Is_Pushback, 'N') AS IsPushback FROM Syn_Deal_Rights WHERE Syn_Deal_Code = @SynDealCode
						ORDER BY ISNULL(Is_Pushback, 'N')
					OPEN rightsCursor
					FETCH NEXT FROM rightsCursor INTO @SynDealRightsCode, @IsPushback
					WHILE @@FETCH_STATUS = 0
					BEGIN
						PRINT '  @SynDealRightsCode : '  + CAST(@SynDealRightsCode AS VARCHAR)
						IF(@IsPushback = 'N')
						BEGIN
							PRINT '  Insert data in ''Acq_Deal_Rights'' table'
							INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights (
								[Acq_Deal_Code], [Is_Exclusive], [Is_Title_Language_Right], [Is_Sub_License], [Sub_License_Code], [Is_Theatrical_Right], [Right_Type], 
								[Original_Right_Type], [Is_Tentative], [Term], [Right_Start_Date], [Right_End_Date], [Actual_Right_Start_Date], [Actual_Right_End_Date], 
								[Milestone_Type_Code], [Milestone_No_Of_Unit], [Milestone_Unit_Type], [Is_ROFR], [ROFR_Date], [ROFR_Code], [Restriction_Remarks], 
								[Effective_Start_Date], [Inserted_By], [Inserted_On], [Last_Updated_Time], [Last_Action_By], [Is_Verified]
							)
							Select @NewAcqDealCode, Is_Exclusive, Is_Title_Language_Right, Is_Sub_License, CS.NewSubLicenseCode, Is_Theatrical_Right, Right_Type, 
								Original_Right_Type, Is_Tentative, Term, Right_Start_Date, Right_End_Date, Actual_Right_Start_Date, Actual_Right_End_Date, 
								CMT.NewMilestoneTypeCode, Milestone_No_Of_Unit, Milestone_Unit_Type, Is_ROFR, ROFR_Date, ROFR_Code, Restriction_Remarks, 
								Effective_Start_Date, @UserCode, GETDATE(), GETDATE(), @UserCode, 'N'
							From Syn_Deal_Rights SDR
							LEFT JOIN #CurrentMilestoneType CMT ON CMT.Milestone_Type_Code = SDR.Milestone_Type_Code
							LEFT JOIN #CurrentSubLicense CS ON CS.Sub_License_Code = SDR.Sub_License_Code
							WHERE Syn_Deal_Rights_Code = @SynDealRightsCode AND (ISNULL(CMT.NewMilestoneTypeCode, 0) > 0 OR ISNULL(SDR.Milestone_Type_Code, 0) = 0)
							AND (ISNULL(CS.NewSubLicenseCode, 0) > 0 OR ISNULL(SDR.Sub_License_Code, 0) = 0)
					
							SELECT @NewAcqDealRightsCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Acq_Deal_Rights')
							PRINT '  @NewAcqDealRightsCode : '  + CAST(@NewAcqDealRightsCode AS VARCHAR)

							IF(ISNULL(@NewAcqDealRightsCode, 0) > 0)
							BEGIN
								PRINT '    Insert data in ''Acq_Deal_Rights_Title'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Title (Acq_Deal_Rights_Code, Title_Code, Episode_From, Episode_To)
								SELECT @NewAcqDealRightsCode, CT.NewTitleCode, SDRT.Episode_From, SDRT.Episode_To
								FROM Syn_Deal_Rights_Title SDRT
								INNER JOIN #CurrentTitles CT ON SDRT.Title_Code = CT.Title_Code AND SDRT.Episode_From = CT.Episode_From AND SDRT.Episode_To = CT.Episode_To
								Where SDRT.Syn_Deal_Rights_Code = @SynDealRightsCode AND ISNULL(CT.NewTitleCode, 0) > 0

								PRINT '      Insert data in ''Acq_Deal_Rights_Title_Eps'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Title_Eps(Acq_Deal_Rights_Title_Code, EPS_No)
								SELECT ADRT.Acq_Deal_Rights_Title_Code, SDRTE.EPS_No
								FROM Syn_Deal_Rights_Title_EPS SDRTE 
								INNER JOIN Syn_Deal_Rights_Title SDRT ON SDRTE.Syn_Deal_Rights_Title_Code = SDRT.Syn_Deal_Rights_Title_Code
									AND SDRT.Syn_Deal_Rights_Code = @SynDealRightsCode
								INNER JOIN #CurrentTitles CT ON SDRT.Title_Code = CT.Title_Code AND SDRT.Episode_From = CT.Episode_From AND SDRT.Episode_To = CT.Episode_To
								INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = @NewAcqDealRightsCode AND
								CAST(ISNULL(ADRT.Title_Code, '') AS VARCHAR) + '~' +  CAST(ISNULL(ADRT.Episode_From, '') AS VARCHAR) + '~' 
								+  CAST(ISNULL(ADRT.Episode_To, '') AS VARCHAR)
								= 
								CAST(ISNULL(CT.NewTitleCode, '') AS VARCHAR) + '~' +  CAST(ISNULL(SDRT.Episode_From, '') AS VARCHAR) + '~' 
								+  CAST(ISNULL(SDRT.Episode_To, '') AS VARCHAR)

								PRINT '    Insert data in ''Acq_Deal_Rights_Platform'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Platform (Acq_Deal_Rights_Code, Platform_Code)	
								SELECT DISTINCT @NewAcqDealRightsCode, CP.NewPlatformCode FROM Syn_Deal_Rights_Platform SDRP 
								INNER JOIN #CurrentPlatform CP ON CP.Platform_Code = SDRP.Platform_Code
								Where SDRP.Syn_Deal_Rights_Code = @SynDealRightsCode AND ISNULL(CP.NewPlatformCode, 0) > 0

								PRINT '    Insert data in ''Acq_Deal_Rights_Territory'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Territory (Acq_Deal_Rights_Code, Territory_Type, Territory_Code, Country_Code)
								SELECT DISTINCT @NewAcqDealRightsCode, SDRT.Territory_Type, 
								CASE WHEN SDRT.Territory_Type = 'G' THEN CT.NewTerritoryCode ELSE NULL END,
								CASE WHEN SDRT.Territory_Type <> 'G' THEN CC.NewCountryCode ELSE NULL END
								FROM Syn_Deal_Rights_Territory SDRT 
								LEFT JOIN #CurrentCountry CC ON CC.Country_Code = SDRT.Country_Code AND SDRT.Territory_Type <> 'G'
								LEFT JOIN #CurrentTerritory CT ON CT.Territory_Code = SDRT.Territory_Code AND SDRT.Territory_Type = 'G'
								WHERE SDRT.Syn_Deal_Rights_Code = @SynDealRightsCode AND (
									(SDRT.Territory_Type = 'G' AND ISNULL(CT.NewTerritoryCode, 0) > 0) OR
									(SDRT.Territory_Type <> 'G' AND ISNULL(CC.NewCountryCode, 0) > 0)
								)

								PRINT '    Insert data in ''Acq_Deal_Rights_Subtitling'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Subtitling (Acq_Deal_Rights_Code, Language_Type, Language_Group_Code, Language_Code)	
								SELECT DISTINCT @NewAcqDealRightsCode, SDRS.Language_Type, 
								CASE WHEN SDRS.Language_Type = 'G' THEN CLG.NewLanguageGroupCode ELSE NULL END,
								CASE WHEN SDRS.Language_Type <> 'G' THEN CL.NewLanguageCode ELSE NULL END
								FROM Syn_Deal_Rights_Subtitling SDRS
								LEFT JOIN #CurrentLanguage CL ON CL.Language_Code = SDRS.Language_Code AND SDRS.Language_Type <> 'G'
								LEFT JOIN #CurrentLanguageGroup CLG ON CLG.Language_Group_Code = SDRS.Language_Group_Code AND SDRS.Language_Type = 'G'
								WHERE SDRS.Syn_Deal_Rights_Code = @SynDealRightsCode AND (
									(SDRS.Language_Type = 'G' AND ISNULL(CLG.NewLanguageGroupCode, 0) > 0) OR
									(SDRS.Language_Type <> 'G' AND ISNULL(CL.NewLanguageCode, 0) > 0)
								)

								PRINT '    Insert data in ''Acq_Deal_Rights_Subtitling'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Dubbing(Acq_Deal_Rights_Code, Language_Type, Language_Group_Code, Language_Code)	
								SELECT DISTINCT @NewAcqDealRightsCode, SDRD.Language_Type, 
								CASE WHEN SDRD.Language_Type = 'G' THEN CLG.NewLanguageGroupCode ELSE NULL END,
								CASE WHEN SDRD.Language_Type <> 'G' THEN CL.NewLanguageCode ELSE NULL END
								FROM Syn_Deal_Rights_Dubbing SDRD
								LEFT JOIN #CurrentLanguage CL ON CL.Language_Code = SDRD.Language_Code AND SDRD.Language_Type <> 'G'
								LEFT JOIN #CurrentLanguageGroup CLG ON CLG.Language_Group_Code = SDRD.Language_Group_Code AND SDRD.Language_Type = 'G'
								WHERE SDRD.Syn_Deal_Rights_Code = @SynDealRightsCode AND (
									(SDRD.Language_Type = 'G' AND ISNULL(CLG.NewLanguageGroupCode, 0) > 0) OR
									(SDRD.Language_Type <> 'G' AND ISNULL(CL.NewLanguageCode, 0) > 0)
								)

								PRINT '    Insert data in ''Acq_Deal_Rights_Holdback'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Holdback (
									Acq_Deal_Rights_Code, Holdback_Type, HB_Run_After_Release_No, HB_Run_After_Release_Units, 
									Holdback_On_Platform_Code, Holdback_Release_Date, Holdback_Comment, Is_Title_Language_Right
								)
								SELECT DISTINCT 
									@NewAcqDealRightsCode, SDRH.Holdback_Type, SDRH.HB_Run_After_Release_No, SDRH.HB_Run_After_Release_Units, 
									CP.NewPlatformCode, SDRH.Holdback_Release_Date, SDRH.Holdback_Comment, SDRH.Is_Original_Language
								FROM Syn_Deal_Rights_Holdback SDRH 
								INNER JOIN #CurrentPlatform CP ON CP.Platform_Code = SDRH.Holdback_On_Platform_Code
								Where SDRH.Syn_Deal_Rights_Code = @SynDealRightsCode AND (ISNULL(CP.NewPlatformCode, 0) > 0 OR ISNULL(SDRH.Holdback_On_Platform_Code, 0) = 0)

								PRINT '      Insert data in ''Acq_Deal_Rights_Holdback_Platform'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Holdback_Platform (Acq_Deal_Rights_Holdback_Code, Platform_Code)
								SELECT ADRH.Acq_Deal_Rights_Holdback_Code, CPHP.NewPlatformCode
								FROM Syn_Deal_Rights_Holdback_Platform SDRHP 
								INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDRHP.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
									AND SDRH.Syn_Deal_Rights_Code = @SynDealRightsCode
								INNER JOIN #CurrentPlatform CPH ON CPH.Platform_Code = SDRH.Holdback_On_Platform_Code
								INNER JOIN #CurrentPlatform CPHP ON CPHP.Platform_Code = SDRHP.Platform_Code
								INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = @NewAcqDealRightsCode AND
									CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
									=
									CAST(ISNULL(SDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(SDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(SDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(CPH.NewPlatformCode, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(SDRH.Holdback_Type, '') + '~' + ISNULL(SDRH.Is_Original_Language, '') 
								WHERE ISNULL(CPHP.NewPlatformCode, 0) > 0

								PRINT '      Insert data in ''Acq_Deal_Rights_Holdback_Territory'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Holdback_Territory (Acq_Deal_Rights_Holdback_Code, Territory_Type, Territory_Code, Country_Code)
								SELECT DISTINCT ADRH.Acq_Deal_Rights_Holdback_Code, SDRHT.Territory_Type, 
								CASE WHEN SDRHT.Territory_Type = 'G' THEN CT.NewTerritoryCode ELSE NULL END,
								CASE WHEN SDRHT.Territory_Type <> 'G' THEN CC.NewCountryCode ELSE NULL END
								FROM Syn_Deal_Rights_Holdback_Territory SDRHT 
								INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDRHT.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
									AND SDRH.Syn_Deal_Rights_Code = @SynDealRightsCode
								INNER JOIN #CurrentPlatform CPH ON CPH.Platform_Code = SDRH.Holdback_On_Platform_Code
								LEFT JOIN #CurrentCountry CC ON CC.Country_Code = SDRHT.Country_Code AND SDRHT.Territory_Type <> 'G'
								LEFT JOIN #CurrentTerritory CT ON CT.Territory_Code = SDRHT.Territory_Code AND SDRHT.Territory_Type = 'G'
								INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = @NewAcqDealRightsCode AND
									CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
									=
									CAST(ISNULL(SDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(SDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(SDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(CPH.NewPlatformCode, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(SDRH.Holdback_Type, '') + '~' + ISNULL(SDRH.Is_Original_Language, '') 
								WHERE ((SDRHT.Territory_Type = 'G' AND ISNULL(CT.NewTerritoryCode, 0) > 0) OR
									(SDRHT.Territory_Type <> 'G' AND ISNULL(CC.NewCountryCode, 0) > 0)
								)

								PRINT '      Insert data in ''Acq_Deal_Rights_Holdback_Dubbing'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Holdback_Dubbing (Acq_Deal_Rights_Holdback_Code, Language_Code)
								SELECT DISTINCT ADRH.Acq_Deal_Rights_Holdback_Code, CL.NewLanguageCode
								FROM Syn_Deal_Rights_Holdback_Dubbing SDRHD
								INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDRHD.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
									AND SDRH.Syn_Deal_Rights_Code = @SynDealRightsCode
								INNER JOIN #CurrentPlatform CPH ON CPH.Platform_Code = SDRH.Holdback_On_Platform_Code
								INNER JOIN #CurrentLanguage	CL ON CL.Language_Code = SDRHD.Language_Code
								INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = @NewAcqDealRightsCode AND
									CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
									=
									CAST(ISNULL(SDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(SDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(SDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(CPH.NewPlatformCode, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(SDRH.Holdback_Type, '') + '~' + ISNULL(SDRH.Is_Original_Language, '') 
								WHERE ISNULL(CL.NewLanguageCode, 0) > 0

								PRINT '      Insert data in ''Acq_Deal_Rights_Holdback_Subtitling'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Holdback_Subtitling(Acq_Deal_Rights_Holdback_Code, Language_Code)
								SELECT DISTINCT ADRH.Acq_Deal_Rights_Holdback_Code, CL.NewLanguageCode
								FROM Syn_Deal_Rights_Holdback_Subtitling SDRHS
								INNER JOIN Syn_Deal_Rights_Holdback SDRH ON SDRHS.Syn_Deal_Rights_Holdback_Code = SDRH.Syn_Deal_Rights_Holdback_Code
									AND SDRH.Syn_Deal_Rights_Code = @SynDealRightsCode
								INNER JOIN #CurrentPlatform CPH ON CPH.Platform_Code = SDRH.Holdback_On_Platform_Code
								INNER JOIN #CurrentLanguage	CL ON CL.Language_Code = SDRHS.Language_Code
								INNER JOIN Acq_Deal_Rights_Holdback ADRH ON ADRH.Acq_Deal_Rights_Code = @NewAcqDealRightsCode AND
									CAST(ISNULL(ADRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(ADRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(ADRH.Holdback_Comment, '') + '~' + CAST(ISNULL(ADRH.Holdback_On_Platform_Code, '') AS VARCHAR) + '~' +
									CAST(ISNULL(ADRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(ADRH.Holdback_Type, '') + '~' + ISNULL(ADRH.Is_Title_Language_Right, '')
									=
									CAST(ISNULL(SDRH.HB_Run_After_Release_No, '') AS VARCHAR) + '~' + ISNULL(SDRH.HB_Run_After_Release_Units, '') + '~' +
									ISNULL(SDRH.Holdback_Comment, '') + '~' + CAST(ISNULL(CPH.NewPlatformCode, '') AS VARCHAR) + '~' +
									CAST(ISNULL(SDRH.Holdback_Release_Date, '') AS VARCHAR) + '~' + ISNULL(SDRH.Holdback_Type, '') + '~' + ISNULL(SDRH.Is_Original_Language, '') 
								WHERE ISNULL(CL.NewLanguageCode, 0) > 0

								PRINT '    Insert data in ''Acq_Deal_Rights_Blackout'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Rights_Blackout ( 
									Acq_Deal_Rights_Code, [Start_Date], [End_Date], Inserted_By, Inserted_On, 
									Last_Updated_Time, Last_Action_By
								)
								SELECT DISTINCT
									@NewAcqDealRightsCode, SDRB.[Start_Date], SDRB.[End_Date], SDRB.Inserted_By, SDRB.Inserted_On, 
									SDRB.Last_Updated_Time, SDRB.Last_Action_By
								FROM Syn_Deal_Rights_Blackout SDRB WHERE SDRB.Syn_Deal_Rights_Code = @SynDealRightsCode
							END
							ELSE
							BEGIN
								SET @Message = 'ERROR 02 : Could not inserted new Right for @SynDealRightsCode : ' + CAST(@SynDealRightsCode AS VARCHAR)
								PRINT @Message
								RAISERROR (@Message, -1, -1 )
							END
						END
						ELSE
						BEGIN
							PRINT '  Insert data in ''Acq_Deal_Pushback'' table'
							INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Pushback(
								[Acq_Deal_Code], [Right_Type], [Is_Tentative], [Term], [Right_Start_Date], [Right_End_Date], 
								[Milestone_Type_Code], [Milestone_No_Of_Unit], [Milestone_Unit_Type], [Is_Title_Language_Right], [Remarks], 
								[Inserted_By], [Inserted_On], [Last_Updated_Time], [Last_Action_By]
							)
							SELECT DISTINCT
								@NewAcqDealCode, SDR.Right_Type, SDR.Is_Tentative, SDR.Term, SDR.Right_Start_Date, SDR.Right_End_Date, 
								CMT.NewMilestoneTypeCode, SDR.Milestone_No_Of_Unit, SDR.Milestone_Unit_Type,  SDR.Is_Title_Language_Right, SDR.Restriction_Remarks, 
								@UserCode, GETDATE(), GETDATE(), @UserCode
							From Syn_Deal_Rights SDR
							LEFT JOIN #CurrentMilestoneType CMT ON CMT.Milestone_Type_Code = SDR.Milestone_Type_Code
							WHERE Syn_Deal_Rights_Code = @SynDealRightsCode AND (ISNULL(CMT.NewMilestoneTypeCode, 0) > 0 OR ISNULL(SDR.Milestone_Type_Code, 0) = 0)

							SELECT @NewAcqDealPushbackCode = IDENT_CURRENT('RightsU_Plus_S13.dbo.Acq_Deal_Pushback')
							PRINT '  @NewAcqDealPushbackCode : '  + CAST(@NewAcqDealPushbackCode AS VARCHAR)

							IF(ISNULL(@NewAcqDealPushbackCode, 0) > 0)
							BEGIN
								PRINT '    Insert data in ''Acq_Deal_Pushback_Title'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Pushback_Title (Acq_Deal_Pushback_Code, Title_Code, Episode_From, Episode_To)
								SELECT DISTINCT @NewAcqDealPushbackCode, CT.NewTitleCode, SDRT.Episode_From, SDRT.Episode_To
								FROM Syn_Deal_Rights_Title SDRT
								INNER JOIN #CurrentTitles CT ON SDRT.Title_Code = CT.Title_Code AND SDRT.Episode_From = CT.Episode_From AND SDRT.Episode_To = CT.Episode_To
								Where SDRT.Syn_Deal_Rights_Code = @SynDealRightsCode AND ISNULL(CT.NewTitleCode, 0) > 0

								PRINT '    Insert data in ''Acq_Deal_Pushback_Platform'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Pushback_Platform (Acq_Deal_Pushback_Code, Platform_Code)	
								SELECT DISTINCT @NewAcqDealPushbackCode, CP.NewPlatformCode FROM Syn_Deal_Rights_Platform SDRP 
								INNER JOIN #CurrentPlatform CP ON CP.Platform_Code = SDRP.Platform_Code
								Where SDRP.Syn_Deal_Rights_Code = @SynDealRightsCode AND ISNULL(CP.NewPlatformCode, 0) > 0

								PRINT '    Insert data in ''Acq_Deal_Pushback_Territory'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Pushback_Territory (Acq_Deal_Pushback_Code, Territory_Type, Territory_Code, Country_Code)
								SELECT DISTINCT @NewAcqDealPushbackCode, SDRT.Territory_Type, 
								CASE WHEN SDRT.Territory_Type = 'G' THEN CT.NewTerritoryCode ELSE NULL END,
								CASE WHEN SDRT.Territory_Type <> 'G' THEN CC.NewCountryCode ELSE NULL END
								FROM Syn_Deal_Rights_Territory SDRT 
								LEFT JOIN #CurrentCountry CC ON CC.Country_Code = SDRT.Country_Code AND SDRT.Territory_Type <> 'G'
								LEFT JOIN #CurrentTerritory CT ON CT.Territory_Code = SDRT.Territory_Code AND SDRT.Territory_Type = 'G'
								WHERE SDRT.Syn_Deal_Rights_Code = @SynDealRightsCode AND (
									(SDRT.Territory_Type = 'G' AND ISNULL(CT.NewTerritoryCode, 0) > 0) OR
									(SDRT.Territory_Type <> 'G' AND ISNULL(CC.NewCountryCode, 0) > 0)
								)

								PRINT '    Insert data in ''Acq_Deal_Pushback_Subtitling'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Pushback_Subtitling (Acq_Deal_Pushback_Code, Language_Type, Language_Group_Code, Language_Code)	
								SELECT DISTINCT @NewAcqDealPushbackCode, SDRS.Language_Type, 
								CASE WHEN SDRS.Language_Type = 'G' THEN CLG.NewLanguageGroupCode ELSE NULL END,
								CASE WHEN SDRS.Language_Type <> 'G' THEN CL.NewLanguageCode ELSE NULL END
								FROM Syn_Deal_Rights_Subtitling SDRS
								LEFT JOIN #CurrentLanguage CL ON CL.Language_Code = SDRS.Language_Code AND SDRS.Language_Type <> 'G'
								LEFT JOIN #CurrentLanguageGroup CLG ON CLG.Language_Group_Code = SDRS.Language_Group_Code AND SDRS.Language_Type = 'G'
								WHERE SDRS.Syn_Deal_Rights_Code = @SynDealRightsCode AND (
									(SDRS.Language_Type = 'G' AND ISNULL(CLG.NewLanguageGroupCode, 0) > 0) OR
									(SDRS.Language_Type <> 'G' AND ISNULL(CL.NewLanguageCode, 0) > 0)
								)

								PRINT '    Insert data in ''Acq_Deal_Pushback_Dubbing'' table'
								INSERT INTO RightsU_Plus_S13.dbo.Acq_Deal_Pushback_Dubbing(Acq_Deal_Pushback_Code, Language_Type, Language_Group_Code, Language_Code)	
								SELECT DISTINCT @NewAcqDealPushbackCode, SDRD.Language_Type, 
								CASE WHEN SDRD.Language_Type = 'G' THEN CLG.NewLanguageGroupCode ELSE NULL END,
								CASE WHEN SDRD.Language_Type <> 'G' THEN CL.NewLanguageCode ELSE NULL END
								FROM Syn_Deal_Rights_Dubbing SDRD
								LEFT JOIN #CurrentLanguage CL ON CL.Language_Code = SDRD.Language_Code AND SDRD.Language_Type <> 'G'
								LEFT JOIN #CurrentLanguageGroup CLG ON CLG.Language_Group_Code = SDRD.Language_Group_Code AND SDRD.Language_Type = 'G'
								WHERE SDRD.Syn_Deal_Rights_Code = @SynDealRightsCode AND (
									(SDRD.Language_Type = 'G' AND ISNULL(CLG.NewLanguageGroupCode, 0) > 0) OR
									(SDRD.Language_Type <> 'G' AND ISNULL(CL.NewLanguageCode, 0) > 0)
								)
							END
							ELSE
							BEGIN
								SET @Message = 'ERROR 02 : Could not inserted new Pushback Right for @SynDealRightsCode : ' + CAST(@SynDealRightsCode AS VARCHAR)
								PRINT @Message
								RAISERROR (@Message, -1, -1 )
							END
						END

						PRINT '  *****************************'
						FETCH NEXT FROM rightsCursor INTO @SynDealRightsCode, @IsPushback
					END
					CLOSE rightsCursor;
					DEALLOCATE rightsCursor;

					DECLARE @dbName VARCHAR(200) = '', @AgreementNo VARCHAR(30)  = ''
					SELECT TOP 1 @AgreementNo = Agreement_No, @dbName = DB_NAME() FROM Syn_Deal WHERE Syn_Deal_Code = @SynDealCode

					PRINT '  Insert data in ''Module_Status_History'' table just for auto push remark'
					INSERT INTO RightsU_Plus_S13.dbo.Module_Status_History(
						Module_Code, Record_Code, [Status], Status_Changed_By, Status_Changed_On, Remarks
					)VALUES(
						35, @NewAcqDealCode, 'AP', @UserCode, GETDATE(), 'Auto pushed deal from ''' + @dbName + ''' database, Ref Syn Agreement No is ''' + @AgreementNo +''''
					)
				END
			END
			ELSE
			BEGIN
				PRINT 'ERROR 01 : Could not inserted new deal'
				RAISERROR ('ERROR 01 : Could not inserted new deal', -1, -1 )
			END
		END
		ELSE
		BEGIN
			IF(ISNULL(@NewMappedBuCode, 0) = 0)
				PRINT 'Business Unit is not linked Autopush is not allowed'
			IF(ISNULL(@AutopushAcqDeal, '') = 'Y')
				PRINT 'Autopush is not allowed'
		END
		PRINT 'Commit transaction'
		COMMIT
		SELECT @StatusFlag = 'S' , @ErrMessage = ''
	END TRY
	BEGIN CATCH
		PRINT 'Rollback transaction'
		ROLLBACK
		SELECT @StatusFlag = 'E' , @ErrMessage = ERROR_MESSAGE()
	END CATCH

	IF OBJECT_ID('tempdb..#CurrentCountry') IS NOT NULL DROP TABLE #CurrentCountry
	IF OBJECT_ID('tempdb..#CurrentLanguage') IS NOT NULL DROP TABLE #CurrentLanguage
	IF OBJECT_ID('tempdb..#CurrentLanguageGroup') IS NOT NULL DROP TABLE #CurrentLanguageGroup
	IF OBJECT_ID('tempdb..#CurrentMilestoneType') IS NOT NULL DROP TABLE #CurrentMilestoneType
	IF OBJECT_ID('tempdb..#CurrentPlatform') IS NOT NULL DROP TABLE #CurrentPlatform
	IF OBJECT_ID('tempdb..#CurrentSubLicense') IS NOT NULL DROP TABLE #CurrentSubLicense
	IF OBJECT_ID('tempdb..#CurrentTerritory') IS NOT NULL DROP TABLE #CurrentTerritory
	IF OBJECT_ID('tempdb..#CurrentTitles') IS NOT NULL DROP TABLE #CurrentTitles
	IF OBJECT_ID('tempdb..#Map_Extended_Columns') IS NOT NULL DROP TABLE #Map_Extended_Columns
	IF OBJECT_ID('tempdb..#Map_Extended_Columns_Details') IS NOT NULL DROP TABLE #Map_Extended_Columns_Details
	IF OBJECT_ID('tempdb..#NewTitles') IS NOT NULL DROP TABLE #NewTitles
	IF OBJECT_ID('tempdb..#Title_Country') IS NOT NULL DROP TABLE #Title_Country
	IF OBJECT_ID('tempdb..#Title_Geners') IS NOT NULL DROP TABLE #Title_Geners
	IF OBJECT_ID('tempdb..#TitleTalent') IS NOT NULL DROP TABLE #TitleTalent
END
