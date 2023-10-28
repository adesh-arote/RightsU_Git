CREATE PROCEDURE [dbo].[USP_Get_Title_Content_Data]
(
	@Data_For varchar(max)
)
As
BEGIN
	Declare @Loglevel int;
	
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Title_Content_Data]', 'Step 1', 0, 'Started Procedure', 0, ''
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
	
		IF OBJECT_ID('tempdb..#PreReqData') IS NOT NULL DROP TABLE #PreReqData
		 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Title_Content_Data]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END