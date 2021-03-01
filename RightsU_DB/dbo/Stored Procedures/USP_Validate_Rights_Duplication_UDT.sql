


CREATE PROCEDURE [dbo].[USP_Validate_Rights_Duplication_UDT]
(
	@Deal_Rights Deal_Rights READONLY,
	@Deal_Rights_Title Deal_Rights_Title  READONLY,
	@Deal_Rights_Platform Deal_Rights_Platform READONLY,
	@Deal_Rights_Territory Deal_Rights_Territory READONLY,
	@Deal_Rights_Subtitling Deal_Rights_Subtitling READONLY,
	@Deal_Rights_Dubbing Deal_Rights_Dubbing READONLY,
	@CallFrom CHAR(2)='AR',	
	@Debug CHAR(1)='N'
)
As
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 21-October-2014
-- Description:	Checks If User is trying to enter a Duplicate Deal
-- =============================================
Begin
   SET NOCOUNT ON
   DECLARE @RC int 
   
   
   IF(UPPER(@CallFrom)='AR' OR UPPER(@CallFrom)='AP')
   BEGIN
		If(UPPER(@CallFrom)='AR')
		Begin
			EXECUTE @RC = [USP_Validate_Rights_Duplication_UDT_ACQ] 
			 @Deal_Rights
			,@Deal_Rights_Title
			,@Deal_Rights_Platform
			,@Deal_Rights_Territory
			,@Deal_Rights_Subtitling
			,@Deal_Rights_Dubbing
			,@CallFrom
			,@Debug
			,0
		End
  END
 --  ELSE
	--BEGIN
	--	--IF(UPPER(@CallFrom)='SR')
	--	----BEGIN
	--	--EXECUTE @RC = [USP_Syn_Rights_Not_Acquire_And_Duplicate] 
	--	--   @Deal_Rights
	--	--  ,@Deal_Rights_Title
	--	--  ,@Deal_Rights_Platform
	--	--  ,@Deal_Rights_Territory
	--	--  ,@Deal_Rights_Subtitling
	--	--  ,@Deal_Rights_Dubbing
	--	--  ,@CallFrom
	--	--  ,@Debug	  
	--  -- EXECUTE @RC = [USP_Validate_Rights_Duplication_UDT_Syn] 
	--  -- @Deal_Rights
	--  --,@Deal_Rights_Title
	--  --,@Deal_Rights_Platform
	--  --,@Deal_Rights_Territory
	--  --,@Deal_Rights_Subtitling
	--  --,@Deal_Rights_Dubbing
	--  --,@CallFrom
	--  --,@Debug

	  
 -- END
  
End
