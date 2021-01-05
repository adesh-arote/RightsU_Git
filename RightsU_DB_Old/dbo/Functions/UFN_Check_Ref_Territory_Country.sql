CREATE FUNCTION [dbo].[UFN_Check_Ref_Territory_Country]
(
	@Territory_Code_Or_Country_Code INT,
	@type CHAR(1)

)
RETURNS VARCHAR(3)
AS
-- =============================================
-- Author:		Anchal sikarwar
-- Create date: 30 October 2015
-- Description:	Check Reference Country and Territory is Exist in Acq. Deal or Lang. group Call from 
-- =============================================
BEGIN
	-- Declare the return variable here
	DECLARE @IsRef VARCHAR(3) ='N'	
	IF(@type = 'I')
	BEGIN
			IF EXISTS(SELECT TOP 1 Country_Code FROM Territory_Details WHERE Country_Code = @Territory_Code_Or_Country_Code)
			BEGIN
				RETURN  'TD'
			END
			IF EXISTS(SELECT TOP 1 Country_Code FROM Acq_Deal_Pushback_Territory WHERE Country_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'AD'
			END		
			IF EXISTS(SELECT TOP 1 Country_Code FROM Acq_Deal_Rights_Blackout_Territory WHERE Country_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'AD'
			END
			IF EXISTS(SELECT TOP 1 Country_Code FROM Acq_Deal_Rights_Holdback_Territory WHERE Country_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'AD'
			END	
			IF EXISTS(SELECT TOP 1 Country_Code FROM Acq_Deal_Rights_Territory WHERE Country_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'AD'
			END		
			IF EXISTS(SELECT TOP 1 Country_Code FROM Syn_Deal_Rights_Blackout_Territory WHERE Country_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'SD'
			END	
			IF EXISTS(SELECT TOP 1 Country_Code FROM Syn_Deal_Rights_Holdback_Territory WHERE Country_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'SD'
			END		
			IF EXISTS(SELECT TOP 1 Country_Code FROM Syn_Deal_Rights_Territory WHERE Country_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'SD'
			END
		END
		ELSE
		BEGIN
			IF EXISTS(SELECT TOP 1 Territory_Code FROM Acq_Deal_Mass_Territory_Update_Details WHERE Territory_Code= @Territory_Code_Or_Country_Code)
			BEGIN
				RETURN  'AD'
			END		
			IF EXISTS(SELECT TOP 1 Territory_Code FROM Acq_Deal_Pushback_Territory WHERE Territory_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'AD'
			END		
			IF EXISTS(SELECT TOP 1 Territory_Code FROM Acq_Deal_Rights_Blackout_Territory WHERE Territory_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'AD'
			END
			IF EXISTS(SELECT TOP 1 Territory_Code FROM Acq_Deal_Rights_Holdback_Territory WHERE Territory_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'AD'
			END	
			IF EXISTS(SELECT TOP 1 Territory_Code FROM Acq_Deal_Rights_Territory WHERE Territory_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'AD'
			END		
			IF EXISTS(SELECT TOP 1 Territory_Code FROM Syn_Deal_Mass_Territory_Update_Details WHERE Territory_Code= @Territory_Code_Or_Country_Code)
			BEGIN
				RETURN  'SD'
			END
			IF EXISTS(SELECT TOP 1 Territory_Code FROM Syn_Deal_Rights_Blackout_Territory WHERE Territory_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'SD'
			END	
			IF EXISTS(SELECT TOP 1 Territory_Code FROM Syn_Deal_Rights_Holdback_Territory WHERE Territory_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'SD'
			END		
			IF EXISTS(SELECT TOP 1 Territory_Code FROM Syn_Deal_Rights_Territory WHERE Territory_Code = @Territory_Code_Or_Country_Code AND  Territory_Type= @type)
			BEGIN
				RETURN  'SD'
			END
		END
	-- Return the result of the function
	RETURN @IsRef
END
