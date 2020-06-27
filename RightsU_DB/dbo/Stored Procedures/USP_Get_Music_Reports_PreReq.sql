Create PROC USP_Get_Music_Reports_PreReq
AS
BEGIN	
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
	SELECT DISTINCT T.Title_Code, T.Title_Name, 'TIT' FROM Music_Schedule_Transaction MST 
	INNER JOIN BV_Schedule_Transaction BV ON BV.BV_Schedule_Transaction_Code = MST.BV_Schedule_Transaction_Code
	INNER JOIN Title T ON T.Title_Code = BV.Title_Code

	INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
	SELECT DISTINCT ML.Music_Label_Code, ML.Music_Label_Name, 'MLBL' FROM Music_Schedule_Transaction MST 
	INNER JOIN Music_Label ML ON ML.Music_Label_Code = MST.Music_Label_Code

	INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)
	SELECT DISTINCT C.Channel_Code, C.Channel_Name, 'CHNL' FROM Music_Schedule_Transaction MST 
	INNER JOIN Channel C ON C.Channel_Code = MST.Channel_Code

	SELECT RowID, Display_Value, Display_Text, Data_For FROM #PreReqData
END
