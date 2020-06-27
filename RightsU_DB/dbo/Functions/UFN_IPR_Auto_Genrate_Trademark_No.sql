-- =============================================
-- Author:		Sagar Mahajan
-- Create date: 30-OCT-2014
-- Description:	Gets New Trademark No.
-- =============================================
Create FUNCTION [dbo].[UFN_IPR_Auto_Genrate_Trademark_No]
(
)
RETURNS VARCHAR(100)
AS
BEGIN	
	DECLARE @Prefix Varchar(100),@Trademark_No Varchar(100)
	SET @Prefix='TRD-'	
	SET @Trademark_No = ''
	SELECT @Trademark_No=@Prefix+Right('000000'+Cast(IsNull(Cast(Right(Max(Trademark_No),6) As Int),0)+1 As Varchar(10)),6)  from IPR_REP 	
	RETURN IsNull(@Trademark_No,'ERROR')
END
/*
 Select  [dbo].[UFN_IPR_Auto_Genrate_Trademark_No] () as Trademark_No
 
*/