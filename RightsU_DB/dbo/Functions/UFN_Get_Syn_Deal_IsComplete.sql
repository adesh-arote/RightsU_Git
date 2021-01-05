CREATE Function [dbo].[UFN_Get_Syn_Deal_IsComplete](@Syn_Deal_Code Int)
Returns Varchar(20)
As
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create DATE: 12-Feb-2015
-- Description:	Return related dependencies added or not for a deal
-- =============================================
Begin

	--Declare @Syn_Deal_Code Int = 345

	DECLARE @Deal_Complete_Flag Varchar(100) = '', @RetVal Varchar(20) = '', @Title_Count Int = 0
	Select @Deal_Complete_Flag = Deal_Complete_Flag From Syn_Deal WITH(NOLOCK) Where Syn_Deal_Code = @Syn_Deal_Code

	Select @Title_Count = Count(*) From Syn_Deal_Movie WITH(NOLOCK) Where Syn_Deal_Code = @Syn_Deal_Code

	Declare @DealFlag Table (Deal_Flag Varchar(10))
	Insert InTo @DealFlag
	Select number From DBO.fn_Split_withdelemiter(@Deal_Complete_Flag, ',')

	If((Select Count(*) From @DealFlag Where Deal_Flag = 'R') > 0)
	Begin
		If((
			
			select count(*) from(
				Select Distinct Title_Code, Episode_From, Episode_To
				From Syn_Deal_Rights_Title WITH(NOLOCK) Where Syn_Deal_Rights_Code In (
					Select Syn_Deal_Rights_Code From Syn_Deal_Rights WITH(NOLOCK) Where Syn_Deal_Code = @Syn_Deal_Code AND ISNULL(Is_Pushback,'N') = 'N'
				)
			) as temp
		) < @Title_Count)
		Begin
			Set @RetVal = 'R'
		End
	End
	
	If((Select Count(*) From @DealFlag Where Deal_Flag = 'C') > 0)
	Begin
		If((
			select count(*) from(
				Select Distinct Title_Code, Episode_From, Episode_To
				From Syn_Deal_Revenue_Title WITH(NOLOCK) Where Syn_Deal_Revenue_Code In (
					Select Syn_Deal_Revenue_Code  From Syn_Deal_Revenue WITH(NOLOCK) Where Syn_Deal_Code = @Syn_Deal_Code
				)
			) as temp

		) < @Title_Count)
		Begin
			If(@RetVal != '')
				Set @RetVal = @RetVal + ','
			Set @RetVal = @RetVal + 'C'
		End
	End
	
	If((Select Count(*) From @DealFlag Where Deal_Flag = 'A') > 0)
	Begin
		If((
			Select Count(Distinct Title_Code) From Syn_Deal_Ancillary_Title WITH(NOLOCK) Where Syn_Deal_Ancillary_Code In (
				Select Syn_Deal_Ancillary_Code From Syn_Deal_Ancillary WITH(NOLOCK) Where Syn_Deal_Code = @Syn_Deal_Code
			)
		) < @Title_Count)
		Begin
			If(@RetVal != '')
				Set @RetVal = @RetVal + ','
			Set @RetVal = @RetVal + 'A'
		End
	End
	
	if(@RetVal = '')
		Set @RetVal = 'Y'
	--Select @RetVal
	Return @RetVal
End

/*
Select * from Syn_Deal Where Agreement_No like 'S-2015-00028'
Select Is_Completed,* from Syn_Deal 
Select  [dbo].[UFN_Get_Syn_Deal_IsComplete] (30)
*/
