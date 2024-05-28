
CREATE FUNCTION [dbo].[UFN_Get_Rights_NoOfRuns](@Rights_Code INT)
RETURNS VARCHAR(MAX)
AS
-- =============================================
-- Author:		Reshma Kunjal
-- Create DATE: 17-Aug-2015
-- Description:	Return NoOfRuns added for Rights related Run
-- =============================================
BEGIN

	DECLARE @RetVal VARCHAR(MAX) = ''
		
	SELECT @RetVal = @RetVal + A.No_Of_Runs + ', ' 
	FROM 
	(
		SELECT DISTINCT CASE WHEN adrun.Run_Type = 'C' THEN 'Limited' ELSE 'Unlimited' END No_Of_Runs
		FROM Acq_Deal_Rights adr
		INNER JOIN Acq_Deal_Rights_Title adrt ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Rights_Platform adrp ON adrp.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Run adrun ON adr.Acq_Deal_Code = adrun.Acq_Deal_Code
		INNER JOIN Acq_Deal_Run_Title adrunt ON adrunt.Title_Code = adrt.Title_Code AND adrunt.Acq_Deal_Run_Code = adrun.Acq_Deal_Run_Code
		INNER JOIN Platform p on p.Platform_Code = adrp.Platform_Code
		WHERE adrt.Acq_Deal_Rights_Code IN (@Rights_Code)
		AND p.Is_No_Of_Run = 'Y'
	) AS A
	
	RETURN SUBSTRING(@RetVal, 0, LEN(@RetVal))
	
END



--SELECT dbo.[UFN_Get_Rights_NoOfRuns](39)

--select * from Acq_Deal_Run where acq_deal_code=12
--select * from Acq_Deal_Rights where acq_deal_code=12
--select * from Acq_Deal where Agreement_no='A-2008-00006'