CREATE PROCEDURE [dbo].[USPITGetDealRemarks]
@TitleCode INT,
@TypeOfDeal NVARCHAR(10)
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetDealRemarks]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		--DECLARE
		--@TitleCode INT = 37468,
		--@TypeOfDeal NVARCHAR(10) = 'ACQ'


		IF(OBJECT_ID('tempdb..#tempRemarks') IS NOT NULL) DROP TABLE #tempRemarks

		CREATE TABLE #tempRemarks(
			Label NVARCHAR(MAX),
			Agreement_No NVARCHAR(100),
			Rights NVARCHAR(MAX),
			Licensor NVARCHAR(MAX),
			GeneralRemarks NVARCHAR(MAX),
			RightsRemarks NVARCHAR(MAX)

		)
	
		--DECLARE @Rights NVARCHAR(MAX) = '', @LinearCount INT, @NonLinearCount INT, @AncillaryCount INT 
	
		--IF(@TypeOfDeal = 'ACQ')
		--BEGIN
		--	SET @LinearCount =  (Select COUNT(*) from 
		--					Acq_Deal ad
		--					INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
		--					INNER JOIN Acq_Deal_Rights_Platform adrp ON adrp.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		--					INNER JOIN Platform_Attrib_Group pag ON pag.Platform_Code = adrp.Platform_Code
		--					INNER JOIN Attrib_Group ag ON ag.Attrib_Group_Code = pag.Attrib_Group_Code AND ag.Attrib_Group_Code = 3
		--					where ad.Acq_Deal_Code = @DealCode
		--					)

		--	SET @NonLinearCount = (Select COUNT(*) from 
		--						Acq_Deal ad
		--						INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
		--						INNER JOIN Acq_Deal_Rights_Platform adrp ON adrp.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		--						INNER JOIN Platform_Attrib_Group pag ON pag.Platform_Code = adrp.Platform_Code
		--						INNER JOIN Attrib_Group ag ON ag.Attrib_Group_Code = pag.Attrib_Group_Code AND ag.Attrib_Group_Code = 4
		--						where ad.Acq_Deal_Code = @DealCode
		--						)

		--	SET @AncillaryCount = (Select COUNT(*) from 
		--						Acq_Deal ad
		--						INNER JOIN Acq_Deal_Rights adr ON adr.Acq_Deal_Code = ad.Acq_Deal_Code 
		--						where ad.Acq_Deal_Code = @DealCode --AND adr.PA_Right_Type = 'AR'
		--					)

		--END
		--ELSE
		--BEGIN
		--		SET @LinearCount =  (Select COUNT(*) from 
		--					Syn_Deal ad
		--					INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code
		--					INNER JOIN Syn_Deal_Rights_Platform adrp ON adrp.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
		--					INNER JOIN Platform_Attrib_Group pag ON pag.Platform_Code = adrp.Platform_Code
		--					INNER JOIN Attrib_Group ag ON ag.Attrib_Group_Code = pag.Attrib_Group_Code AND ag.Attrib_Group_Code = 3
		--					where ad.Syn_Deal_Code = @DealCode
		--					)

		--	SET @NonLinearCount = (Select COUNT(*) from 
		--						Syn_Deal ad
		--						INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code
		--						INNER JOIN Syn_Deal_Rights_Platform adrp ON adrp.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code
		--						INNER JOIN Platform_Attrib_Group pag ON pag.Platform_Code = adrp.Platform_Code
		--						INNER JOIN Attrib_Group ag ON ag.Attrib_Group_Code = pag.Attrib_Group_Code AND ag.Attrib_Group_Code = 4
		--						where ad.Syn_Deal_Code = @DealCode
		--						)

		--	SET @AncillaryCount = (Select COUNT(*) from 
		--						Syn_Deal ad
		--						INNER JOIN Syn_Deal_Rights adr ON adr.Syn_Deal_Code = ad.Syn_Deal_Code 
		--						where ad.Syn_Deal_Code = @DealCode --AND adr.PA_Right_Type = 'AR'
		--					)

		--END


		--	IF(@LinearCount > 0)
		--	BEGIN
		--		SET @Rights += 'Linear, '
		--	END

		--	IF(@NonLinearCount > 0)
		--	BEGIN
		--		SET @Rights += 'Non-Linear, '
		--	END

		--	IF(@AncillaryCount > 0)
		--	BEGIN
		--		SET @Rights += 'Ancillary, '
		--	END



		IF(@TypeOfDeal = 'ACQ')
		BEGIN
			INSERT INTO #tempRemarks
			SELECT DISTINCT 'Acquisition Deal Remarks' AS Label, Agreement_No, '', V.Vendor_Name, --(select left(@Rights, len(@Rights)-1))
			CASE WHEN ISNULL(ad.Remarks,'') = '' THEN 'No Remarks' ELSE ad.Remarks END AS GeneralRemarks, 
			CASE WHEN ISNULL(ad.Rights_Remarks,'') = '' THEN 'No Remarks' ELSE ad.Rights_Remarks END AS RightsRemarks
			from Acq_Deal ad (NOLOCK) 
			INNER JOIN Vendor v (NOLOCK)  ON v.Vendor_Code = ad.Vendor_Code
			INNER JOIN Acq_Deal_Rights adr (NOLOCK)  ON adr.Acq_Deal_Code = ad.Acq_Deal_Code AND adr.Is_Sub_License = 'Y'
			INNER JOIN Acq_Deal_Rights_Title adrt (NOLOCK)  ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code AND adrt.Title_Code = @TitleCode
		END
		ELSE
		BEGIN
			INSERT INTO #tempRemarks
			SELECT DISTINCT 'Syndication Deal Remarks' AS Label, Agreement_No, '', V.Vendor_Name, --(select left(@Rights, len(@Rights)-1))
			CASE WHEN ISNULL(ad.Remarks,'') = '' THEN 'No Remarks' ELSE ad.Remarks END AS GeneralRemarks, 
			CASE WHEN ISNULL(ad.Rights_Remarks,'') = '' THEN 'No Remarks' ELSE ad.Rights_Remarks END AS RightsRemarks
			from Syn_Deal ad (NOLOCK) 
			INNER JOIN Vendor v  (NOLOCK) ON v.Vendor_Code = ad.Vendor_Code
			INNER JOIN Syn_Deal_Rights adr (NOLOCK)  ON adr.Syn_Deal_Code = ad.Syn_Deal_Code AND adr.Is_Sub_License = 'Y'
			INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK)  ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code AND adrt.Title_Code = @TitleCode
		END

		SELECT * FROM #tempRemarks
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetDealRemarks]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END