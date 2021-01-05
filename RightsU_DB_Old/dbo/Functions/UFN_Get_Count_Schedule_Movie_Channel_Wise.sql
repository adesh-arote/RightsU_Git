CREATE FUNCTION UFN_Get_Count_Schedule_Movie_Channel_Wise
(
	@Deal_Movie_Code INT,
	@Channel_Code INT
	--,@BV_Schedule_Transaction_Codes VARCHAR(MAX)
)
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 16 Sept 2015
-- Description:	Call From USP_Last_Month_Utilization_Report(Task ID - 3508) 
-- =============================================
RETURNS  INT
AS
BEGIN
	 DECLARE @Count_Schedule_Movie_Channel INT	
	 SET @Count_Schedule_Movie_Channel = 0
	SELECT
		 @Count_Schedule_Movie_Channel  = COUNT(Deal_Movie_Code) 
	FROM BV_Schedule_Transaction 
	WHERE 1 =1 	
	--AND BV_Schedule_Transaction_Code IN(SELECT number FROM fn_Split_withdelemiter(@BV_Schedule_Transaction_Codes,','))
	AND Deal_Movie_Code = @Deal_Movie_Code
	AND Channel_Code = @Channel_Code
	GROUP BY Deal_Movie_Code ,Channel_Code

RETURN @Count_Schedule_Movie_Channel

END