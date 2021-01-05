
CREATE Function [dbo].[UFN_Get_Rights_Holdback_YN](@PlatformCode Int, @Rights_Code Int, @Deal_Type Char(1))
Returns Varchar(10)
As
-- =============================================
-- Author:		Adesh P Arote
-- Create DATE: 14-October-2014
-- Description:	Return Holdback Yes / No
-- =============================================
Begin

	Declare @Child_Codes Table (
		Platform_Codes Int,
		Parent_Platform_Code Int
	)

	Declare @Parent_Codes Table (
		Platform_Codes Int
	)

	Insert Into @Parent_Codes
	Select Platform_Code From Platform Where Parent_Platform_Code = @PlatformCode And Is_Last_Level = 'N'

	Insert Into @Child_Codes
	Select Platform_Code, Parent_Platform_Code From Platform Where (Parent_Platform_Code = @PlatformCode Or Platform_Code = @PlatformCode) And Is_Last_Level = 'Y'

	While((Select Count(*) From @Parent_Codes Where Platform_Codes Not In (Select Parent_Platform_Code From @Child_Codes)) > 0)
	Begin
		Insert Into @Parent_Codes
		Select Platform_Code From Platform Where Parent_Platform_Code In (
			Select Platform_Codes From @Parent_Codes Where Platform_Codes Not In (Select Parent_Platform_Code From @Child_Codes)
		) And Is_Last_Level = 'N'

		Insert Into @Child_Codes
		Select Platform_Code, Parent_Platform_Code From [Platform] Where Parent_Platform_Code In (
			Select Platform_Codes From @Parent_Codes Where Platform_Codes Not In (Select Parent_Platform_Code From @Child_Codes)
		) --And Is_Last_Level = 'Y'
	End

	Declare @RetVal Varchar(10) = ''
	If(@Deal_Type = 'A')
	Begin
		Select @RetVal = Case When Count(*) > 0 Then 'Y' Else 'N' End 
		From Acq_Deal_Rights_Holdback adrh 
		Inner Join Acq_Deal_Rights_Holdback_Platform adrhp On adrh.Acq_Deal_Rights_Holdback_Code = adrhp.Acq_Deal_Rights_Holdback_Code
		And  adrh.Acq_Deal_Rights_Code = @Rights_Code And adrhp.Platform_Code In (Select Platform_Codes From @Child_Codes)
	End
	Else
	Begin
		Select @RetVal = Case When Count(*) > 0 Then 'Y' Else 'N' End 
		From Syn_Deal_Rights_Holdback adrh 
		Inner Join Syn_Deal_Rights_Holdback_Platform adrhp On adrh.Syn_Deal_Rights_Holdback_Code = adrhp.Syn_Deal_Rights_Holdback_Code
		And  adrh.Syn_Deal_Rights_Code = @Rights_Code And adrhp.Platform_Code In (Select Platform_Codes From @Child_Codes)
	End

	Return @RetVal
	
End