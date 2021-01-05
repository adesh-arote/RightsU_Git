ALTER Function [dbo].[UFN_Get_Deal_IsComplete](@Acq_Deal_Code Int)
Returns Varchar(20)
As
-- =============================================
-- Author:		Adesh P Arote
-- Create DATE: 27-October-2014
-- Description:	Return related dependencies added or not for a deal
-- Last Updated By : Akshay Rane
-- Updated Change : Check Deal complete flag from system param new for Rights and Cost
-- =============================================
Begin

	--Declare @Acq_Deal_Code Int = 345
	Declare @Deal_Complete_Flag Varchar(100) = '', @RetVal Varchar(20) = '', @Title_Count Int = 0, @SysParam_Deal_Complete_Flag Varchar(100) = ''

	Select @SysParam_Deal_Complete_Flag = Parameter_Value From System_Parameter_New With(NoLock) Where Parameter_Name = 'Deal_Complete_Flag'
	Select @Deal_Complete_Flag = Deal_Complete_Flag From Acq_Deal With(NoLock) Where Deal_Workflow_Status NOT IN ('AR', 'WA') AND  Acq_Deal_Code = @Acq_Deal_Code

	Select @Title_Count = Count(*) From Acq_Deal_Movie With(NoLock) Where Acq_Deal_Code = @Acq_Deal_Code AND Is_Closed <> 'X'AND Is_Closed <> 'Y'

	Declare @DealFlag Table (Deal_Flag Varchar(10))
	Insert InTo @DealFlag
	Select number From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',')

	Declare @SysParam_DealFlag Table (Deal_Flag Varchar(10))
	Insert InTo @SysParam_DealFlag
	Select number From DBO.fn_Split_withdelemiter(@SysParam_Deal_Complete_Flag, ',')

	If((Select Count(*) From @DealFlag Where LTRIM(Deal_Flag) = 'R') > 0 AND (Select Count(*) From @SysParam_DealFlag Where LTRIM(Deal_Flag) = 'R') > 0 )
	Begin
		If((
			
			select count(*) from(
				Select Distinct Title_Code, Episode_From, Episode_To
				From Acq_Deal_Rights_Title With(NoLock) Where Acq_Deal_Rights_Code In (
					Select Acq_Deal_Rights_Code From Acq_Deal_Rights With(NoLock) Where Acq_Deal_Code = @Acq_Deal_Code
				)
			) as temp
		) < @Title_Count)
		Begin
			Set @RetVal = 'R'
		End
	End
	
	If((Select Count(*) From @DealFlag Where LTRIM(Deal_Flag) = 'C') > 0 AND (Select Count(*) From @SysParam_DealFlag Where LTRIM(Deal_Flag) = 'C') > 0)
	Begin
		If((
			select count(*) from(
				Select Distinct Title_Code, Episode_From, Episode_To
				From Acq_Deal_Cost_Title With(NoLock) Where Acq_Deal_Cost_Code In (
					Select Acq_Deal_Cost_Code From Acq_Deal_Cost With(NoLock) Where Acq_Deal_Code = @Acq_Deal_Code
				)
			) as temp
			
		) < @Title_Count)
		Begin
			If(@RetVal != '')
				Set @RetVal = @RetVal + ','
			Set @RetVal = @RetVal + 'C'
		End
	End
	
	If((Select Count(*) From @DealFlag Where Deal_Flag = 'P') > 0)
	Begin
		If((
			select count(*) from(
				Select Distinct Title_Code, Episode_From, Episode_To
				From Acq_Deal_Pushback_Title With(NoLock) Where Acq_Deal_Pushback_Code In (
					Select Acq_Deal_Pushback_Code From Acq_Deal_Pushback With(NoLock) Where Acq_Deal_Code = @Acq_Deal_Code
				)
			) as temp
		) < @Title_Count)
		Begin
			If(@RetVal != '')
				Set @RetVal = @RetVal + ','
			Set @RetVal = @RetVal + 'P'
		End
	End
	
	If((Select Count(*) From @DealFlag Where Deal_Flag = 'A') > 0)
	Begin
		If((
			Select Count(Distinct Title_Code) From Acq_Deal_Ancillary_Title With(NoLock) Where Acq_Deal_Ancillary_Code In (
				Select Acq_Deal_Ancillary_Code From Acq_Deal_Ancillary With(NoLock) Where Acq_Deal_Code = @Acq_Deal_Code
			)
		) < @Title_Count)
		Begin
			If(@RetVal != '')
				Set @RetVal = @RetVal + ','
			Set @RetVal = @RetVal + 'A'
		End
	End
	
	If((Select Count(*) From @DealFlag Where Deal_Flag = 'D') > 0)
	Begin
		If((
			Select Count(Distinct Title_Code) From Acq_Deal_Run_Title With(NoLock) Where Acq_Deal_Run_Code In (
				Select Acq_Deal_Run_Code From Acq_Deal_Run With(NoLock) Where Acq_Deal_Code = @Acq_Deal_Code
			)
		) < @Title_Count)
		Begin
			If(@RetVal != '')
				Set @RetVal = @RetVal + ','
			Set @RetVal = @RetVal + 'D'
		End
	End

	If((Select Count(*) From @DealFlag Where Deal_Flag = 'B') > 0)
	Begin
		If((
			Select Count(Distinct Title_Code) From Acq_Deal_Budget With(NoLock) Where Acq_Deal_Code = @Acq_Deal_Code
		) < @Title_Count)
		Begin
			If(@RetVal != '')
				Set @RetVal = @RetVal + ','
			Set @RetVal = @RetVal + 'B'
		End
	End
	
	if(@RetVal = '')
		Set @RetVal = 'Y'
	--Select @RetVal
	Return @RetVal
End

/*

Select [dbo].[UFN_Get_Deal_IsComplete](49)

*/