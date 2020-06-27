

--DROP VIEW [dbo].[VW_Acq_Approved_Data]
CREATE VIEW [dbo].[VW_Acq_Approved_Data]
AS
--WITH SCHEMABINDING AS 
-- =============================================
-- Author:		Sagar Mahajan/Abhaysingh N. Rajpurohit
-- Create date:	30 Jan 2015
-- Description:	Get distinct DATA of Titles that are approved
-- =============================================

SELECT 			
		ADRT.Title_Code
		--,ISNULL(ADRTE.EPS_No,0) AS EPS_No
		,ADRT.Episode_From
		,ADRT.Episode_To
		,ADR.Is_Title_Language_Right
		,ADR.Is_Exclusive,ADR.Right_Type
		,ADR.Actual_Right_Start_Date
		,ADR.Actual_Right_End_Date
		,ADRP.Platform_Code
		,AD.Deal_Type_Code,
		ADRC.Territory_Type
		,ADRC.Country_Code
		,ISNULL(ADRC.Territory_Code,0) AS Territory_Code
		,0 AS SubTitle_Lang_Code
		,0 AS Dubb_Lang_Code
FROM dbo.Acq_Deal AD
INNER JOIN dbo.Acq_Deal_Rights ADR  ON AD.Acq_Deal_Code=ADR.Acq_Deal_Code 
INNER JOIN dbo.Acq_Deal_Rights_Title ADRT  ON ADR.Acq_Deal_Rights_Code=ADRT.Acq_Deal_Rights_Code
--INNER JOIN dbo.Acq_Deal_Rights_Title_EPS ADRTE  ON ADRT.Acq_Deal_Rights_Title_Code=ADRTE.Acq_Deal_Rights_Title_Code
INNER JOIN dbo.Acq_Deal_Rights_Platform ADRP  ON ADR.Acq_Deal_Rights_Code = ADRP.Acq_Deal_Rights_Code
INNER JOIN dbo.Acq_Deal_Rights_Territory ADRC ON ADR.Acq_Deal_Rights_Code = ADRC.Acq_Deal_Rights_Code
AND ISNULL(AD.Deal_Workflow_Status,'')='A' 
AND ADR.Is_Sub_License='Y'
AND ADR.Is_Tentative='N'
AND ADR.Actual_Right_Start_Date IS NOT NULL