--exec USP_Validate_Rights_Duplication_Country_Lang 1,1,'1,2043,1039,24,2054,2,22,11,6,12,10,20,13,18,21,16,4,17,8,5,7,19,15,14,9,1037,1038,2040,2044,2042,23,30,2053,2041,26,2048,2049,2050,2052,2046,3,29,25,2047,2057,2051,27,28,31,1036,2039,2045','SR'
--GO
CREATE PROCEDURE [dbo].[USP_Validate_Rights_Duplication_Country_Lang]
(
	@Selected_Territory_Codes VARCHAR(1000),
	@Selected_SubTitling_LangGroup_Codes VARCHAR(1000),
	@Selected_Dubbing_LangGroup_Codes VARCHAR(1000),
	@CallFrom CHAR(2)='A'
)
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 8 May 2015
-- Description:	Call From Acq and Syn Save Right. 
--			    Check duplication Countries,Languages is not allowed in Case of Territory and Language group(both Subtitling and dubbing)
-- =============================================
BEGIN
	SET NOCOUNT ON;
	DECLARE @Count_Dup INT = 0,@Error_msg NVARCHAR(80)=''

	IF(@Selected_Territory_Codes <> '')
	BEGIN
		SELECT TOP 1 @Count_Dup= tbl.Country_Code FROM 
		(
			SELECT TD.Country_Code FROM Territory_Details TD
			WHERE TD.Territory_Code IN(SELECT number FROM fn_Split_withdelemiter(@Selected_Territory_Codes,','))
		) AS tbl
		INNER JOIN Country C ON tbl.Country_Code = C.Country_Code
		WHERE C.Is_Active = 'Y' 
		GROUP BY tbl.Country_Code
		HAVING COUNT(tbl.Country_Code) > 1	
		IF(@Count_Dup > 0)
			SET @Error_msg = 'countries'
	END
	IF(@Count_Dup = 0 AND @Selected_SubTitling_LangGroup_Codes  <> '')
	BEGIN
		SELECT TOP 1 @Count_Dup= tbl.Language_Code FROM 
		(
			SELECT LGD.Language_Code FROM Language_Group_Details LGD
			WHERE LGD.Language_Group_Code IN(SELECT number FROM fn_Split_withdelemiter(@Selected_SubTitling_LangGroup_Codes ,','))
		) AS tbl
		INNER JOIN [Language] L ON tbl.Language_Code = L.Language_Code
		WHERE L.Is_Active = 'Y' 
		GROUP BY tbl.Language_Code
		HAVING COUNT(tbl.Language_Code) > 1	
		IF(@Count_Dup > 0)
		Begin
			If(@Error_msg <> '')
				Set @Error_msg = ', '
			SET @Error_msg = 'languages in subtitling'
		End
	END
	IF(@Count_Dup = 0 AND @Selected_Dubbing_LangGroup_Codes  <> '')
	BEGIN
		SELECT TOP 1 @Count_Dup= tbl.Language_Code FROM 
		(
			SELECT LGD.Language_Code FROM Language_Group_Details LGD
			WHERE LGD.Language_Group_Code IN(SELECT number FROM fn_Split_withdelemiter(@Selected_Dubbing_LangGroup_Codes ,','))
		) AS tbl
		INNER JOIN [Language] L ON tbl.Language_Code = L.Language_Code
		WHERE L.Is_Active = 'Y' 
		GROUP BY tbl.Language_Code
		HAVING COUNT(tbl.Language_Code) > 1	
		IF(@Count_Dup > 0)
		Begin
			If(@Error_msg <> '')
				Set @Error_msg = ', '
			SET @Error_msg = 'languages in dubbing'
		End
	END

	
	If(@Error_msg <> '')
	Begin
		Set @Error_msg = 'Duplicate ' + @Error_msg + ' are not allowed across groups'
	End

	SELECT @Error_msg  AS Error_msg

END

/*

Exec [USP_Validate_Rights_Duplication_Country_Lang] '1', '1,2', '1,2', ''

*/