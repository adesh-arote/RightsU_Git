CREATE Function [dbo].[UFN_Get_Run_Channel](@Run_Code Int)
Returns Varchar(MAX)
As
-- =============================================
-- Author:		Adesh P Arote
-- Create DATE: 14-October-2014
-- Description:	Return Countrys added for right
-- =============================================
Begin

	Declare @RetVal Varchar(MAX) = ''

	Select @RetVal = @RetVal + C.Channel_Name + ', ' from Acq_Deal_Run_Channel ADRC
	INNER JOIN Channel C ON ADRC.Channel_Code = C.Channel_Code
	WHERE ADRC.Acq_Deal_Run_Code = @Run_Code

	Return Substring(@RetVal, 0, Len(@RetVal))
	
End