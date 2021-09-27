CREATE PROC USP_Title_Objection_List
(
	@CallFrom CHAR(1) = 'A',
	@Title_Codes VARCHAR(1000) = '',
	@Licensor_Codes VARCHAR(1000) = ''
)
AS
--========================================
--Author :- Akshay Rane
--Creation Date :- 24 August 2021 
--========================================
BEGIN

	--DECLARE
	--@CallFrom CHAR(1) = 'Y',
	--@Title_Codes VARCHAR(1000) = '473,3272',
	--@Licensor_Codes VARCHAR(1000) = '23,22'

	IF @CallFrom = 'X'
	BEGIN
		SELECT DISTINCT 
				AD.Acq_Deal_Code, 
				AD.Agreement_No,
				AD.Deal_Desc, 
				V.Vendor_Name AS 'Licensor',
				CASE
					WHEN T.Deal_Type_Code = 11 THEN RTRIM(LTRIM(T.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR)+' - '+ CAST(ADRT.Episode_To AS VARCHAR) +')'))
					ELSE RTRIM(LTRIM(T.Title_Name))
				END AS 'Title',
				T.Year_Of_Production,
				ADRT.Title_Code,
				V.Vendor_Code AS 'Licensor_Code'
			FROM Acq_Deal AD
				INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
				INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Licensor ADL ON ADL.Acq_Deal_Code = AD.Acq_Deal_Code
				INNER JOIN Vendor V ON V.Vendor_Code = ADL.Vendor_Code
				INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code
			WHERE ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U'
	END
	ELSE IF @CallFrom = 'A'
	BEGIN
		SELECT DISTINCT 
			AD.Acq_Deal_Code, 
			AD.Agreement_No,
			AD.Deal_Desc, 
			V.Vendor_Name AS 'Licensor',
			CASE
				WHEN T.Deal_Type_Code = 11 THEN RTRIM(LTRIM(T.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR)+' - '+ CAST(ADRT.Episode_To AS VARCHAR) +')'))
				ELSE RTRIM(LTRIM(T.Title_Name))
			END AS 'Title',
			T.Year_Of_Production,
			ADRT.Title_Code,
			V.Vendor_Code AS 'Licensor_Code'
		FROM Acq_Deal AD
			INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
			INNER JOIN Acq_Deal_Rights_Title ADRT ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
			INNER JOIN Acq_Deal_Licensor ADL ON ADL.Acq_Deal_Code = AD.Acq_Deal_Code
			INNER JOIN Vendor V ON V.Vendor_Code = ADL.Vendor_Code
			INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code
		WHERE ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U'
		AND (
				( ADRT.Title_Code IN (SELECT number from dbo.fn_Split_withdelemiter(@Title_Codes,',')) )
				OR
				( ADL.Vendor_Code IN (SELECT number from dbo.fn_Split_withdelemiter(@Licensor_Codes,',')))
			)
	END
	ELSE IF @CallFrom = 'S'
	BEGIN
		SELECT DISTINCT 
			AD.Syn_Deal_Code AS Acq_Deal_Code, 
			AD.Agreement_No,
			AD.Deal_Description as 'Deal_Desc', 
			V.Vendor_Name AS 'Licensor',
			CASE
				WHEN T.Deal_Type_Code = 11 THEN RTRIM(LTRIM(T.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR)+' - '+ CAST(ADRT.Episode_To AS VARCHAR) +')'))
				ELSE RTRIM(LTRIM(T.Title_Name))
			END AS 'Title',
			T.Year_Of_Production,
			ADRT.Title_Code,
			V.Vendor_Code AS 'Licensor_Code'
		FROM Syn_Deal AD
			INNER JOIN Syn_Deal_Rights ADR ON ADR.Syn_Deal_Code = AD.Syn_Deal_Code
			INNER JOIN Syn_Deal_Rights_Title ADRT ON ADRT.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
			INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
			INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code
		WHERE ADR.Actual_Right_End_Date >= GETDATE() OR Right_Type = 'U'
		AND (
				(ADRT.Title_Code IN (SELECT number from dbo.fn_Split_withdelemiter(@Title_Codes,',')))
				OR
				(AD.Vendor_Code IN (SELECT number from dbo.fn_Split_withdelemiter(@Licensor_Codes,',')))
			)
	END
	ELSE IF @CallFrom = 'Y'
	BEGIN
		SELECT DISTINCT 
			AD.Syn_Deal_Code AS Acq_Deal_Code, 
			AD.Agreement_No,
			AD.Deal_Description as 'Deal_Desc', 
			V.Vendor_Name AS 'Licensor',
			CASE
				WHEN T.Deal_Type_Code = 11 THEN RTRIM(LTRIM(T.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR)+' - '+ CAST(ADRT.Episode_To AS VARCHAR) +')'))
				ELSE RTRIM(LTRIM(T.Title_Name))
			END AS 'Title',
			T.Year_Of_Production,
			ADRT.Title_Code,
			V.Vendor_Code AS 'Licensor_Code'
		FROM Syn_Deal AD
			INNER JOIN Syn_Deal_Rights ADR ON ADR.Syn_Deal_Code = AD.Syn_Deal_Code
			INNER JOIN Syn_Deal_Rights_Title ADRT ON ADRT.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
			INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
			INNER JOIN Title T ON T.Title_Code = ADRT.Title_Code
		WHERE ADR.Actual_Right_End_Date >= GETDATE()
	END
END
