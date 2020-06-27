CREATE PROCEDURE USP_Get_Title_Content_Data
(
	@Data_For varchar(max)
)
As
BEGIN
CREATE TABLE #PreReqData
	(
		RowID INT IDENTITY(1,1),
		Display_Value INT,
		Display_Text NVARCHAR(MAX),
	)
	IF(@Data_For = 'TC')
	BEGIN
		INsert into #PreReqData (Display_Value,Display_Text)
		select MIN(Title_Content_Code),Episode_Title From Title_Content
		group by Episode_Title
	END
		select * from #PreReqData
END

