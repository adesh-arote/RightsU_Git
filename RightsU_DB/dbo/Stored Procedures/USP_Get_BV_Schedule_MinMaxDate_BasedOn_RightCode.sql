-- =============================================
-- Author:		Rajesh Godse
-- Create date: 6th August2015
-- Description:	Get Min max schedule log date based on right code
-- =============================================
CREATE PROCEDURE USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode
	@Deal_Movie_Rights_Code int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   Select Min(CAST(Schedule_Item_Log_Date  as Date)) as Start_Date,Max(CAST(Schedule_Item_Log_Date  as Date)) as End_Date from BV_Schedule_Transaction
   Where Deal_Movie_Rights_Code = @Deal_Movie_Rights_Code

END
