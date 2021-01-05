CREATE FUNCTION [UFN_GET_SELECTED_ANCILLARY_PLATFORM]
(
  @Deal_Rights_Code INT,
  @Acq_DealCode INT,
  @Title_Codes VARCHAR(MAX)
)
RETURNS VARCHAR(MAX)
AS
BEGIN
	  DECLARE @PlatformCodes VARCHAR(MAX) = '', @TitleCode VARCHAR(MAX) = ''
	  Declare @Selected_Deal_Type_Code Int ,@Deal_Type_Condition Varchar(MAX) = ''

	  Select Top 1 @Selected_Deal_Type_Code = Deal_Type_Code From Acq_Deal Where Acq_Deal_Code = @Acq_DealCode
	  Select @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)

	  DECLARE @TEMP TABLE(Title_Code INT)
	  DECLARE @TempTitle TABLE(
		Title_Code INT,
		Episode_Starts_From INT,
		Episode_End_To INT
	  )

	  IF(@Deal_Type_Condition = 'DEAL_PROGRAM')
	  BEGIN
			INSERT INTO @TempTitle (Title_Code, Episode_Starts_From, Episode_End_To)
			SELECT Title_Code, Episode_Starts_From, Episode_End_To 
			FROM Acq_Deal_Movie 
			WHERE Acq_Deal_Movie_Code IN (SELECT number  FROM dbo.fn_Split_withdelemiter(@Title_Codes,',') WHERE number <> '')

			SELECT @PlatformCodes =  STUFF((
				SELECT DISTINCT ',' + cast(AP.Platform_Code as varchar(max))
				FROM Acq_Deal_Ancillary AA 
					INNER JOIN  Acq_Deal_Ancillary_Title AT ON AA.Acq_Deal_Ancillary_Code = AT.Acq_Deal_Ancillary_Code  
					INNER JOIN  Acq_Deal_Ancillary_Platform AP ON AT.Acq_Deal_Ancillary_Code = AP.Acq_Deal_Ancillary_Code
				WHERE 
					AA.Acq_Deal_Code = @Acq_DealCode 
					AND AT.Title_Code IN (SELECT Title_Code FROM @TempTitle)
					AND AT.Episode_From IN (SELECT Episode_Starts_From FROM @TempTitle)
					AND AT.Episode_To IN (SELECT Episode_End_To FROM @TempTitle)
			FOR XML PATH('')
			), 1, 1, '');
	  END
	  ELSE
	  BEGIN
			INSERT INTO @TEMP(Title_Code)
			SELECT Title_Code  FROM acq_deal_rights_title WHERE acq_deal_rights_code =  @Deal_Rights_Code

			SELECT @PlatformCodes =  STUFF((
			SELECT DISTINCT ',' + cast(AP.Platform_Code as varchar(max))
			FROM Acq_Deal_Ancillary AA 
				INNER JOIN  Acq_Deal_Ancillary_Title AT ON AA.Acq_Deal_Ancillary_Code = AT.Acq_Deal_Ancillary_Code  
				INNER JOIN  Acq_Deal_Ancillary_Platform AP ON AT.Acq_Deal_Ancillary_Code = AP.Acq_Deal_Ancillary_Code
			WHERE 
				AA.Acq_Deal_Code = @Acq_DealCode 
				AND AT.Title_Code IN (SELECT Title_Code FROM @TEMP)
			FOR XML PATH('')
			), 1, 1, '');
	  END
	  RETURN  @PlatformCodes
END