CREATE PROCEDURE [dbo].[USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode]
	@Deal_Movie_Rights_Code int
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode]', 'Step 1', 0, 'Started Procedure', 0, '' 
		-- SET NOCOUNT ON added to prevent extra result sets from
		-- interfering with SELECT statements.
		SET NOCOUNT ON;

	   --SELECT Min(CAST(Schedule_Item_Log_Date  as Date)) as Start_Date,Max(CAST(Schedule_Item_Log_Date  as Date)) as End_Date 
	   --FROM BV_Schedule_Transaction (NOLOCK)
	   --WHERE Deal_Movie_Rights_Code = @Deal_Movie_Rights_Code

	   DECLARE @Deal_Type_Code INT = 0, @Deal_Type_Name VARCHAR(100) = ''
	   SELECT @Deal_Type_Code = ad.Deal_Type_Code
	   FROM Acq_Deal_Rights (NOLOCK) adr
	   INNER JOIN Acq_Deal (NOLOCK) ad ON adr.Acq_Deal_Code = ad.Acq_Deal_Code
	   WHERE adr.Acq_Deal_Rights_Code = @Deal_Movie_Rights_Code

	   SELECT @Deal_Type_Name = DBO.UFN_GetDealTypeCondition(@Deal_Type_Code)

	   IF(@Deal_Type_Name = 'DEAL_MOVIE')
	   BEGIN

		   SELECT MIN(CAST(Schedule_Item_Log_Date AS DATE)) AS Start_Date, MAX(CAST(Schedule_Item_Log_Date AS DATE)) AS End_Date 
		   FROM Acq_Deal_Rights (NOLOCK) adr
		   INNER JOIN Acq_Deal_Rights_Title (NOLOCK) adrt ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		   INNER JOIN BV_Schedule_Transaction (NOLOCK) bv ON bv.Deal_Code = adr.Acq_Deal_Code AND adrt.Title_Code = bv.Title_Code
		   WHERE CAST(Schedule_Item_Log_Date AS DATE) BETWEEN adr.Actual_Right_Start_Date AND adr.Actual_Right_End_Date
				 AND adr.Acq_Deal_Rights_Code = @Deal_Movie_Rights_Code

		END
		ELSE
		BEGIN
		
		   SELECT MIN(CAST(Schedule_Item_Log_Date AS DATE)) AS Start_Date, MAX(CAST(Schedule_Item_Log_Date AS DATE)) AS End_Date 
		   FROM Acq_Deal_Rights (NOLOCK) adr
		   INNER JOIN Acq_Deal_Rights_Title (NOLOCK) adrt ON adr.Acq_Deal_Rights_Code = adrt.Acq_Deal_Rights_Code
		   INNER JOIN BV_Schedule_Transaction (NOLOCK) bv ON bv.Deal_Code = adr.Acq_Deal_Code AND adrt.Title_Code = bv.Title_Code
					  AND CAST(bv.Program_Episode_Number AS INT) BETWEEN adrt.Episode_From AND adrt.Episode_To
		   WHERE CAST(Schedule_Item_Log_Date AS DATE) BETWEEN adr.Actual_Right_Start_Date AND adr.Actual_Right_End_Date
				 AND adr.Acq_Deal_Rights_Code = @Deal_Movie_Rights_Code

		END
  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_BV_Schedule_MinMaxDate_BasedOn_RightCode]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
END
