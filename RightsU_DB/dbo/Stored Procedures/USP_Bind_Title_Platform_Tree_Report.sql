ALTER PROCEDURE [dbo].[USP_Bind_Title_Platform_Tree_Report]
	@Business_Unit_Code INT,
	@Search_Platform_Hiearachy VARCHAR(100)
AS
BEGIN
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 12 Aug 2015
-- Description: Call FROM Acquisition Deal Title Platform Report and Bind plat. tree
-- =============================================

	SET NOCOUNT ON;
--DECLARE @Business_Unit_Code INT = 1,@Platform_Hiearachy VARCHAR(100) = ''
SELECT P.Platform_Code  FROM Platform  P
WHERE Platform_Code IN
(
SELECT ADRP.Platform_Code FROM Acq_Deal_Rights_Platform ADRP
WHERE ADRP.Acq_Deal_Rights_Code
IN
(
	SELECT ADR.Acq_Deal_Rights_Code FROM Acq_Deal AD
	INNER JOIN Acq_Deal_Rights ADR ON AD.Acq_Deal_Code = ADR.Acq_Deal_Code	
	WHERE AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Business_Unit_Code = @Business_Unit_Code 
)
)
 AND ((Platform_Hiearachy LIKE '%' + @Search_Platform_Hiearachy + '%' AND @Search_Platform_Hiearachy  <> '') OR @Search_Platform_Hiearachy  =  '')
END