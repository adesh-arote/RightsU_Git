CREATE Procedure [dbo].[USP_Ancillary_Validate_Udt]	
	@Acq_Deal_Code INT,
	@Acq_Deal_Ancillary_Code INT,
	@Ancillary_Type_code INT,
	@Catch_Up_From VARCHAR(1),
	@Ancillary_Title [Ancillary_Title] READONLY,
	@Ancillary_Platform [Ancillary_Platform] READONLY,
	@Ancillary_Platform_Medium [Ancillary_Platform_Medium] READONLY	
AS
-- =============================================
-- Author:		Pavitar Dua / Akshay Rane
-- Create Date: 10-October-2014
-- Description:	AcqDeal Ancillary Validations RnD WITH UDT
-- Last Updated Date: 04-March-2018
-- Last Updated By: Akshay Rane
-- =============================================
BEGIN
	SET FMTONLY OFF
	SET ANSI_NULLS ON

	IF OBJECT_ID('tempdb..#Adv_Acq_Ancillary_Validate_UDT') IS NOT NULL
		DROP TABLE #Adv_Acq_Ancillary_Validate_UDT
	IF OBJECT_ID('tempdb..#Acq_Ancillary_Validate_UDT') IS NOT NULL
		DROP TABLE #Acq_Ancillary_Validate_UDT

	DECLARE @System_Parameter_New CHAR(1) = 'N'
	SELECT @System_Parameter_New = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_Ancillary_Advanced'

	IF(@System_Parameter_New <> 'N')
	BEGIN
		CREATE TABLE #Adv_Acq_Ancillary_Validate_UDT
		(
			[Acq_Deal_Ancillary_Code] [int] NULL,
			[Title_Code] [int] NULL,
			[Platform_Code] [int] NULL
		)
		INSERT INTO #Acq_Ancillary_Validate_UDT
		SELECT 
			AT.Deal_Ancillary_Code,
			AT.Title_Code,
			AP.Platform_Code
		FROM @Ancillary_Title AT 	
		INNER JOIN @Ancillary_Platform AP ON AP.Deal_Ancillary_Code=AT.Deal_Ancillary_Code

		Select COUNT(A.Title_Code) dup_Count
		FROM (
			Select 
				ADAT.Acq_Deal_Ancillary_Code,
				ADAT.Title_Code,
				ADAP.Platform_Code
			 FROM Acq_Deal_Ancillary ADA	
			Inner Join Acq_Deal_Ancillary_Title	ADAT ON ADA.Acq_Deal_Ancillary_Code=ADAT.Acq_Deal_Ancillary_Code
			Inner Join Acq_Deal_Ancillary_Platform ADAP ON ADA.Acq_Deal_Ancillary_Code=ADAP.Acq_Deal_Ancillary_Code
			WHERE ADA.Ancillary_Type_code = @Ancillary_Type_code AND ISNULL(ADA.Catch_Up_From,'') = ISNULL(@Catch_Up_From,'')
			AND ADA.Acq_Deal_Ancillary_Code<>@Acq_Deal_Ancillary_Code	
			AND ADA.Acq_Deal_Code=@Acq_Deal_Code
		) AS A
		INNER JOIN #Acq_Ancillary_Validate_UDT UDT ON 
		A.Title_Code=UDT.Title_Code AND A.Platform_code = UDT.Platform_Code
	END
	ELSE
	BEGIN
		CREATE TABLE #Acq_Ancillary_Validate_UDT
		(
			[Acq_Deal_Ancillary_Code] [int] NULL,
			[Title_Code] [int] NULL,
			[Ancillary_Platform_Code] [int] NULL,
			[Ancillary_Platform_Medium_Code] [int] NULL
		)
		INSERT INTO #Acq_Ancillary_Validate_UDT
		SELECT 
			AT.Deal_Ancillary_Code,
			AT.Title_Code,
			AP.Ancillary_Platform_Code,
			APM.Ancillary_Platform_Medium_Code
		FROM @Ancillary_Title AT 	
		INNER JOIN @Ancillary_Platform AP ON AP.Deal_Ancillary_Code=AT.Deal_Ancillary_Code
		--LEFT JOIN  @Ancillary_Platform_Medium APM ON AP.Deal_Ancillary_Code=AT.Deal_Ancillary_Code
		LEFT JOIN  (
			SELECT X.Ancillary_Platform_Code,X.Ancillary_Platform_Medium_Code 
			FROM @Ancillary_Platform_Medium X
			INNER JOIN Ancillary_Platform_Medium APMM ON X.Ancillary_Platform_Medium_Code=APMM.Ancillary_Platform_Medium_Code
			AND X.Deal_Ancillary_Code=@Acq_Deal_Ancillary_Code
		)APM 
		ON APM.Ancillary_Platform_Code=Ap.Ancillary_Platform_Code
		
		Select COUNT(A.Title_Code) dup_Count
		FROM (
			Select 
				ADAT.Acq_Deal_Ancillary_Code,
				ADAT.Title_Code,
				ADAP.Ancillary_Platform_Code,
				ADAPM.Ancillary_Platform_Medium_Code
			 FROM Acq_Deal_Ancillary ADA	
			Inner Join Acq_Deal_Ancillary_Title	ADAT ON ADA.Acq_Deal_Ancillary_Code=ADAT.Acq_Deal_Ancillary_Code
			Inner Join Acq_Deal_Ancillary_Platform ADAP ON ADA.Acq_Deal_Ancillary_Code=ADAP.Acq_Deal_Ancillary_Code
			--LEFT Join Acq_Deal_Ancillary_Platform_Medium ADAPM ON  ADAP.Acq_Deal_Ancillary_Platform_Code=ADAPM.Acq_Deal_Ancillary_Platform_Code
			LEFT JOIN  (
				SELECT Y.Acq_Deal_Ancillary_Code,Y.Ancillary_Platform_Code,X.Ancillary_Platform_Medium_Code 
				FROM Acq_Deal_Ancillary_Platform Y 
				INNER JOIN Acq_Deal_Ancillary_Platform_Medium  X ON X.Acq_Deal_Ancillary_Platform_Code=Y.Acq_Deal_Ancillary_Platform_Code 
				INNER JOIN Ancillary_Platform_Medium APMM ON X.Ancillary_Platform_Medium_Code=APMM.Ancillary_Platform_Medium_Code			
			) ADAPM 
			ON ADAPM.Ancillary_Platform_Code=ADAP.Ancillary_Platform_Code AND ADAPM.Acq_Deal_Ancillary_Code=ADA.Acq_Deal_Ancillary_Code
			WHERE ADA.Ancillary_Type_code = @Ancillary_Type_code AND ISNULL(ADA.Catch_Up_From,'') = ISNULL(@Catch_Up_From,'')
			AND ADA.Acq_Deal_Ancillary_Code<>@Acq_Deal_Ancillary_Code	
			AND ADA.Acq_Deal_Code=@Acq_Deal_Code
		) AS A
		INNER JOIN #Acq_Ancillary_Validate_UDT UDT ON 
		--(A.Title_Code=UDT.Title_Code AND A.Ancillary_Platform_code = UDT.Ancillary_Platform_Code )OR 
		(ISNULL(A.Ancillary_Platform_Medium_Code, 0)=IsNull(UDT.Ancillary_Platform_Medium_Code, 0) AND A.Title_Code=UDT.Title_Code AND A.Ancillary_Platform_code = UDT.Ancillary_Platform_Code)
	END
END




