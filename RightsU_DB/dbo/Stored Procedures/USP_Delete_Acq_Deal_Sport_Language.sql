﻿CREATE Proc [dbo].[USP_Delete_Acq_Deal_Sport_Language](@Acq_Deal_Sport_Code Int, @Language_Code Int, @Language_Group_Code Int, @Language_Type Char(1))
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Deal_Sport_Language]', 'Step 1', 0, 'Started Procedure', 0, ''
		If(@Language_Type = 'G')
			Delete From Acq_Deal_Sport_Language Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code And IsNull(Language_Group_Code, 0) = IsNull(@Language_Group_Code, 0)
		Else
			Delete From Acq_Deal_Sport_Language Where Acq_Deal_Sport_Code = @Acq_Deal_Sport_Code And IsNull(Language_Code, 0) = IsNull(@Language_Code, 0)
		
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Delete_Acq_Deal_Sport_Language]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End
