ALTER function UFN_GetAGreement_No 
(    
 @Deal_Code  INT,
 @Type Char(1)   
)   

Returns NVarchar(MAX)
-- =============================================
-- Author:		Vipul surve
-- Create DATE: 23-September-2017
-- Description:	Return Acquistion or Provisonal Deal Agreement No
-- =============================================
AS 
BEGIN
DECLARE @RetVal Nvarchar(MAX) = ''
  IF(@Type = 'A')
	BEGIN
		Select @RetVal = Agreement_No From Acq_Deal where Deal_Workflow_Status NOT IN ('AR', 'WA') AND Acq_Deal_Code = @Deal_Code
	END
	Else
	BEGIN
		Select @RetVal = Agreement_No From Provisional_Deal where Provisional_Deal_Code = @Deal_Code
	END
	Return @RetVal
END