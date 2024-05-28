CREATE PROCEDURE [dbo].[USP_Delete_Approved_Deal_Records] 
@Deal_Type_Code INT --Movie = 1 / Program  = 11
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Approved_Deal_Records]', 'Step 1', 0, 'Started Procedure', 0, ''
			DELETE FROM dbo.Approved_Deal 
			WHERE 
				(Record_Code IN (SELECT adm.Acq_Deal_Code FROM Acq_Deal_Movie adm (NOLOCK)
				INNER JOIN Title t (NOLOCK) ON adm.Title_Code = t.Title_Code
				WHERE t.Deal_Type_Code = @Deal_Type_Code
				) AND Deal_Type = 'A')
			OR
				(Record_Code IN (SELECT sdm.Syn_Deal_Code FROM Syn_Deal_Movie sdm (NOLOCK)
					INNER JOIN Title t  (NOLOCK) ON sdm.Title_Code = t.Title_Code
					WHERE t.Deal_Type_Code = @Deal_Type_Code
				) AND Deal_Type = 'S')
			
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Approved_Deal_Records]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''		
END
