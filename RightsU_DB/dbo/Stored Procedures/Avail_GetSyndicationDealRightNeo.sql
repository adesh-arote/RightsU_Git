CREATE PROC [dbo].[Avail_GetSyndicationDealRightNeo]
(    
 --@Syn_Deal_Code  INT,
 @Syn_Deal_Rights_Code INT,
  @Title_Code INT
)     
AS       
BEGIN  

	Declare @Loglevel int;
	 
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetSyndicationDealRightNeo]', 'Step 1', 0, 'Started Procedure', 0, ''
		--Country: this will return all country codes for given Syn_Deal_Rights_Code
	SELECT CountryCode
	--, Country_Name CountryName
	FROM 
	(SELECT DISTINCT 
					CASE 
						WHEN sorter.Territory_Type = 'G' THEN TD.Country_Code 
						ELSE sorter.Country_Code
					END
					CountryCode 
	FROM	(
				SELECT Syn_Deal_Rights_Code, Territory_Code, Country_Code, Territory_Type 
				FROM Syn_Deal_Rights_Territory  (NOLOCK)
				WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As sorter
	LEFT JOIN Territory_Details TD (NOLOCK) On sorter.Territory_Code = TD.Territory_Code) CountryCodes
	INNER JOIN Country C (NOLOCK)
	ON C.Country_Code = CountryCodes.CountryCode
	ORDER BY C.Country_Code;

	--Platform: this will return all platform codes for given Syn_Deal_Rights_Code till level 4 from level 1
	SELECT Platform_Code PlatformCode--, Platform_Hiearachy PlatformName 
	FROM [Platform] (NOLOCK)
	WHERE Platform_Code IN(SELECT Platform_Code FROM Syn_Deal_Rights_Platform (NOLOCK) WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code);

	--LP

	--ST
	SELECT LanguageCode SubTitleCode--, Language_Name SubTitleName
	FROM 
	(SELECT DISTINCT 
					CASE 
						WHEN sorter.Language_Type = 'G' THEN LGD.Language_Code 
						ELSE sorter.Language_Code
					END
					LanguageCode 
	FROM	(
				SELECT Syn_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type 
				FROM Syn_Deal_Rights_Subtitling (NOLOCK)  
				WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As sorter
	LEFT JOIN Language_Group_Details LGD (NOLOCK) On sorter.Language_Group_Code = LGD.Language_Group_Code) LanguageCodes
	INNER JOIN [Language] L (NOLOCK)
	ON L.Language_Code = LanguageCodes.LanguageCode
	ORDER BY L.Language_Code;

	--DUB
	SELECT LanguageCode DubbingCode--, Language_Name DubbingName 
	FROM 
	(SELECT DISTINCT 
					CASE 
						WHEN sorter.Language_Type = 'G' THEN LGD.Language_Code 
						ELSE sorter.Language_Code
					END
					LanguageCode 
	FROM	(
				SELECT Syn_Deal_Rights_Code, Language_Group_Code, Language_Code, Language_Type 
				FROM Syn_Deal_Rights_Dubbing (NOLOCK) 
				WHERE Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code
			) As sorter
	LEFT JOIN Language_Group_Details LGD(NOLOCK) On sorter.Language_Group_Code = LGD.Language_Group_Code) LanguageCodes
	INNER JOIN [Language] L (NOLOCK)
	ON L.Language_Code = LanguageCodes.LanguageCode
	ORDER BY L.Language_Code;

	--IsTitleLanguage: true,
	--IsSubLicensing: true,
	--IsSelfConsumption: false,
	--IsExclusive: true,
	--IsNonExclusive: false

	select	Is_Exclusive IsExclusive, 
			Is_Title_Language_Right IsTitleLanguageRight, 
			Is_Sub_License IsSubLicense,
			--(SELECT SL.Sub_License_Name from Sub_License SL where SL.Sub_License_Code = ADR.Sub_License_Code) SubLicensing,
			Sub_License_Code SubLicensing,
			Is_Theatrical_Right IsTheatricalRight,
			Is_Tentative IsTentative,
			Actual_Right_Start_Date ActualRightStartDate,
			Actual_Right_End_Date ActualRightEndDate,
			ADR.Syn_Deal_Rights_Code As RightCode
	from Syn_Deal_Rights ADR (NOLOCK) where 
	--Syn_Deal_Code = @Syn_Deal_Code and 
	Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code;

	select Distinct Episode_From As EpisodeFrom,Episode_To AS EpisodeTo from Syn_Deal_Rights_Title t (NOLOCK)
	Where  Syn_Deal_Rights_Code = @Syn_Deal_Rights_Code and Title_Code = @Title_Code order by Episode_From

	 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Avail_GetSyndicationDealRightNeo]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END