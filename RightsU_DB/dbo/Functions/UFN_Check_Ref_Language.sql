CREATE FUNCTION UFN_Check_Ref_Language
(
	@Lang_Code_Or_Lang_Group_Code INT,
	@Lang_type CHAR(1)

)
RETURNS VARCHAR(3)
AS
-- =============================================
-- Author:		SAGAR MAHAJAN
-- Create date: 17 July 2015
-- Description:	Check Reference Lang. is Exist in Acq. Deal or Lang. group Call from 
-- =============================================
BEGIN
	-- Declare the return variable here
	DECLARE @IsRef VARCHAR(3) ='N'	
	IF(@Lang_type = 'L')
	BEGIN
			IF EXISTS(SELECT TOP 1 Language_Code FROM Language_Group_Details WHERE Language_Code = @Lang_Code_Or_Lang_Group_Code)
			BEGIN
				RETURN  'LG'
			END
			IF EXISTS(SELECT TOP 1 Language_Code FROM Acq_Deal_Rights_Subtitling WHERE Language_Code = @Lang_Code_Or_Lang_Group_Code AND Language_Type = @Lang_type )
			BEGIN
				RETURN  'AD'
			END		
			IF EXISTS(SELECT TOP 1 Language_Code FROM Acq_Deal_Rights_Dubbing WHERE Language_Code = @Lang_Code_Or_Lang_Group_Code  AND Language_Type = @Lang_type )
			BEGIN
				RETURN  'AD'
			END
			IF EXISTS(SELECT TOP 1 Language_Code FROM Syn_Deal_Rights_Subtitling WHERE Language_Code = @Lang_Code_Or_Lang_Group_Code  AND Language_Type = @Lang_type )
			BEGIN
				RETURN  'SD'
			END		
			IF EXISTS(SELECT TOP 1 Language_Code FROM Syn_Deal_Rights_Dubbing WHERE Language_Code = @Lang_Code_Or_Lang_Group_Code  AND Language_Type = @Lang_type )
			BEGIN
				RETURN  'SD'
			END
		END
		ELSE
		BEGIN			
			IF EXISTS(SELECT TOP 1 Language_Group_Code FROM Acq_Deal_Rights_Subtitling WHERE Language_Group_Code = @Lang_Code_Or_Lang_Group_Code AND Language_Type = @Lang_type )
			BEGIN
				RETURN  'AD'
			END		
			IF EXISTS(SELECT TOP 1 Language_Group_Code FROM Acq_Deal_Rights_Dubbing WHERE Language_Group_Code = @Lang_Code_Or_Lang_Group_Code  AND Language_Type = @Lang_type )
			BEGIN
				RETURN  'AD'
			END
			IF EXISTS(SELECT TOP 1 Language_Group_Code FROM Syn_Deal_Rights_Subtitling WHERE Language_Group_Code = @Lang_Code_Or_Lang_Group_Code  AND Language_Type = @Lang_type )
			BEGIN
				RETURN  'SD'
			END		
			IF EXISTS(SELECT TOP 1 Language_Group_Code FROM Syn_Deal_Rights_Dubbing WHERE Language_Group_Code = @Lang_Code_Or_Lang_Group_Code  AND Language_Type = @Lang_type )
			BEGIN
				RETURN  'SD'
			END			
		END
	-- Return the result of the function
	RETURN @IsRef
END
