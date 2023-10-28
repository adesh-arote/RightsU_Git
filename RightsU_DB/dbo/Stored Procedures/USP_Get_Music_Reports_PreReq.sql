CREATE PROC [dbo].[USP_Get_Music_Reports_PreReq]
AS
BEGIN	
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Music_Reports_PreReq]', 'Step 1', 0, 'Started Procedure', 0, ''


		SET NOCOUNT ON;
		SET FMTONLY OFF;
		IF(OBJECT_ID('TEMPDB..#PreReqData') IS NOT NULL)
			DROP TABLE #PreReqData

		CREATE TABLE #PreReqData
		(
			RowID INT IDENTITY(1,1),
			Display_Value INT,
			Display_Text NVARCHAR(MAX),
			Data_For VARCHAR(5)
		)

		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT T.Title_Code, T.Title_Name, 'TIT' FROM Music_Schedule_Transaction MST (NOLOCK)
		INNER JOIN BV_Schedule_Transaction BV (NOLOCK) ON BV.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
		INNER JOIN Title T (NOLOCK) ON T.Title_Code = BV.Title_Code

		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT ML.Music_Label_Code, ML.Music_Label_Name, 'MLBL' FROM Music_Schedule_Transaction MST (NOLOCK)
		INNER JOIN Music_Label ML (NOLOCK) ON ML.Music_Label_Code = MST.Music_Label_Code

		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
		SELECT DISTINCT C.Channel_Code, C.Channel_Name, 'CHNL' FROM Music_Schedule_Transaction MST (NOLOCK)
		INNER JOIN Channel C (NOLOCK) ON C.Channel_Code = MST.Channel_Code

		SELECT RowID, Display_Value, Display_Text, Data_For FROM #PreReqData

		IF OBJECT_ID('tempdb..#PreReqData') IS NOT NULL DROP TABLE #PreReqData

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Music_Reports_PreReq]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END