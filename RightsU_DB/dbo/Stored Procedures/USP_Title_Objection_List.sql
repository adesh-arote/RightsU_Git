CREATE PROC [dbo].[USP_Title_Objection_List]
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
	Declare @Loglevel int 
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel' 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Title_Objection_List]', 'Step 1', 0, 'Started Procedure', 0, ''   
		--DECLARE
		--@CallFrom CHAR(1) = 'X',
		--@Title_Codes VARCHAR(1000) = '',
		--@Licensor_Codes VARCHAR(1000) = ''

		IF OBJECT_ID('tempdb..#FinalResult') IS NOT NULL DROP TABLE #FinalResult

		CREATE TABLE #FinalResult
		(
			Acq_Deal_Code INT,
			Agreement_No NVARCHAR(MAX),
			Deal_Desc NVARCHAR(MAX),
			Licensor NVARCHAR(MAX),
			Title NVARCHAR(MAX),
			Year_Of_Production INT,
			Title_Code INT,
			Licensor_Code INT
		)

		IF @CallFrom = 'X'
		BEGIN
			INSERT INTO #FinalResult (Acq_Deal_Code, Agreement_No, Deal_Desc, Licensor, Title, Year_Of_Production, Title_Code, Licensor_Code)
			SELECT DISTINCT 
					AD.Acq_Deal_Code, 
					AD.Agreement_No,
					AD.Deal_Desc, 
					V.Vendor_Name AS 'Licensor',
					--CASE
					--	WHEN T.Deal_Type_Code = 11 THEN RTRIM(LTRIM(T.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR)+' - '+ CAST(ADRT.Episode_To AS VARCHAR) +')'))
					--	ELSE RTRIM(LTRIM(T.Title_Name))
					--END AS 'Title',
					RTRIM(LTRIM(T.Title_Name)) AS 'Title',
					T.Year_Of_Production,
					ADRT.Title_Code,
					V.Vendor_Code AS 'Licensor_Code'
				FROM Acq_Deal AD (NOLOCK)
					INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
					INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
					INNER JOIN Acq_Deal_Licensor ADL (NOLOCK) ON ADL.Acq_Deal_Code = AD.Acq_Deal_Code
					INNER JOIN Vendor V (NOLOCK) ON V.Vendor_Code = ADL.Vendor_Code
					INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADRT.Title_Code
				WHERE ADR.Actual_Right_End_Date >= GETDATE()  AND ADR.Right_Status = 'C' 
				AND (
					CAST(AD.[Version] AS decimal) > 1 
					OR (CAST(AD.[Version] AS decimal) = 1 AND AD.Deal_Workflow_Status = 'A')
				)
		END
		ELSE IF @CallFrom = 'A'
		BEGIN
			IF(@Title_Codes = ''  AND @Licensor_Codes = '' )
				GOTO Final_Result;

			INSERT INTO #FinalResult (Acq_Deal_Code, Agreement_No, Deal_Desc, Licensor, Title, Year_Of_Production, Title_Code, Licensor_Code)
			SELECT DISTINCT 
				AD.Acq_Deal_Code, 
				AD.Agreement_No,
				AD.Deal_Desc, 
				V.Vendor_Name AS 'Licensor',
				--CASE
				--	WHEN T.Deal_Type_Code = 11 THEN RTRIM(LTRIM(T.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR)+' - '+ CAST(ADRT.Episode_To AS VARCHAR) +')'))
				--	ELSE RTRIM(LTRIM(T.Title_Name))
				--END AS 'Title',
				RTRIM(LTRIM(T.Title_Name)) AS 'Title',
				T.Year_Of_Production,
				ADRT.Title_Code,
				V.Vendor_Code AS 'Licensor_Code'
			FROM Acq_Deal AD (NOLOCK)
				INNER JOIN Acq_Deal_Rights ADR (NOLOCK) ON ADR.Acq_Deal_Code = AD.Acq_Deal_Code
				INNER JOIN Acq_Deal_Rights_Title ADRT (NOLOCK) ON ADRT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
				INNER JOIN Acq_Deal_Licensor ADL (NOLOCK) ON ADL.Acq_Deal_Code = AD.Acq_Deal_Code
				INNER JOIN Vendor V (NOLOCK) ON V.Vendor_Code = ADL.Vendor_Code
				INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADRT.Title_Code
			WHERE --ADR.Actual_Right_End_Date >= GETDATE() AND 
			ADR.Right_Status = 'C'
				AND (
					CAST(AD.[Version] AS decimal) > 1 
					OR (CAST(AD.[Version] AS decimal) = 1 AND AD.Deal_Workflow_Status = 'A')
				)
				AND (
						( @Title_Codes = '' OR ADRT.Title_Code IN (SELECT number from dbo.fn_Split_withdelemiter(@Title_Codes,','))   )
						AND
						( @Licensor_Codes = '' OR ADL.Vendor_Code IN (SELECT number from dbo.fn_Split_withdelemiter(@Licensor_Codes,',')))
					)
		END
		ELSE IF @CallFrom = 'S'
		BEGIN
			IF(@Title_Codes = ''  AND @Licensor_Codes = '' )
				GOTO Final_Result;

			INSERT INTO #FinalResult (Acq_Deal_Code, Agreement_No, Deal_Desc, Licensor, Title, Year_Of_Production, Title_Code, Licensor_Code)
			SELECT DISTINCT 
				AD.Syn_Deal_Code AS Acq_Deal_Code, 
				AD.Agreement_No,
				AD.Deal_Description as 'Deal_Desc', 
				V.Vendor_Name AS 'Licensor',
				--CASE
				--	WHEN T.Deal_Type_Code = 11 THEN RTRIM(LTRIM(T.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR)+' - '+ CAST(ADRT.Episode_To AS VARCHAR) +')'))
				--	ELSE RTRIM(LTRIM(T.Title_Name))
				--END AS 'Title',
				RTRIM(LTRIM(T.Title_Name)) AS 'Title',
				T.Year_Of_Production,
				ADRT.Title_Code,
				V.Vendor_Code AS 'Licensor_Code'
			FROM Syn_Deal AD (NOLOCK)
				INNER JOIN Syn_Deal_Rights ADR (NOLOCK) ON ADR.Syn_Deal_Code = AD.Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Title ADRT (NOLOCK) ON ADRT.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
				INNER JOIN Vendor V (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
				INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADRT.Title_Code
			WHERE ADR.Actual_Right_End_Date >= GETDATE()  AND ADR.Right_Status = 'C' 
				AND (
					CAST(AD.[Version] AS decimal) > 1 
					OR (CAST(AD.[Version] AS decimal) = 1 AND AD.Deal_Workflow_Status = 'A')
				)
				AND (
						( @Title_Codes = '' OR ADRT.Title_Code IN (SELECT number from dbo.fn_Split_withdelemiter(@Title_Codes,',')))
						AND
						( @Licensor_Codes = '' OR AD.Vendor_Code IN (SELECT number from dbo.fn_Split_withdelemiter(@Licensor_Codes,',')))
					)
		END
		ELSE IF @CallFrom = 'Y'
		BEGIN
			INSERT INTO #FinalResult (Acq_Deal_Code, Agreement_No, Deal_Desc, Licensor, Title, Year_Of_Production, Title_Code, Licensor_Code)
			SELECT DISTINCT 
				AD.Syn_Deal_Code AS Acq_Deal_Code, 
				AD.Agreement_No,
				AD.Deal_Description as 'Deal_Desc', 
				V.Vendor_Name AS 'Licensor',
				--CASE
				--	WHEN T.Deal_Type_Code = 11 THEN RTRIM(LTRIM(T.Title_Name +' ('+ CAST(ADRT.Episode_From AS VARCHAR)+' - '+ CAST(ADRT.Episode_To AS VARCHAR) +')'))
				--	ELSE RTRIM(LTRIM(T.Title_Name))
				--END AS 'Title',
				RTRIM(LTRIM(T.Title_Name)) AS 'Title',
				T.Year_Of_Production,
				ADRT.Title_Code,
				V.Vendor_Code AS 'Licensor_Code'
			FROM Syn_Deal AD (NOLOCK)
				INNER JOIN Syn_Deal_Rights ADR (NOLOCK) ON ADR.Syn_Deal_Code = AD.Syn_Deal_Code
				INNER JOIN Syn_Deal_Rights_Title ADRT (NOLOCK) ON ADRT.Syn_Deal_Rights_Code = ADR.Syn_Deal_Rights_Code
				INNER JOIN Vendor V (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
				INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADRT.Title_Code
			WHERE ADR.Actual_Right_End_Date >= GETDATE()  AND ADR.Right_Status = 'C'
				AND (
					CAST(AD.[Version] AS decimal) > 1 
					OR (CAST(AD.[Version] AS decimal) = 1 AND AD.Deal_Workflow_Status = 'A')
				)
		END

		Final_Result:
		SELECT  Acq_Deal_Code, Agreement_No, Deal_Desc, Licensor, Title, Year_Of_Production, Title_Code, Licensor_Code FROM #FinalResult
   
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Title_Objection_List]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''   
END
