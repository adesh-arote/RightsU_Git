CREATE FUNCTION [dbo].[UFN_Get_Disable_Deactive_Message]
(
	@Code INT,
	@ModuleCode INT,
	@SysLanguageCode INT,
	@MasterType VARCHAR(20)
) 
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE @returnMessage NVARCHAR(MAX) = ''
	IF(@MasterType = 'COUNTRY')
	BEGIN
		
		IF EXISTS(SELECT * FROM Territory_Details WHERE Country_Code = @Code)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Countryalreadyusedinterritory'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
		ELSE IF EXISTS(SELECT * FROM Acq_Deal_Rights_Territory WHERE Country_Code = @Code)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Countryalreadyusedinacquisitiondeal'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
		ELSE IF EXISTS(SELECT * FROM Syn_Deal_Rights_Territory WHERE Country_Code = @Code)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Countryalreadyusedinsyndicationdeal'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
		ELSE IF EXISTS(SELECT * FROM Music_Deal_Country WHERE Country_Code = @Code)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Countryalreadyusedinmusicdeal'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
	END
	ELSE IF(@MasterType = 'TERRITORY')
	BEGIN
		
		IF EXISTS(SELECT * FROM Acq_Deal_Rights_Territory WHERE Territory_Code = @Code)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Territoryalreadyusedinacquisitiondeal'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
		ELSE IF EXISTS(SELECT * FROM Syn_Deal_Rights_Territory WHERE Territory_Code = @Code)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Territoryalreadyusedinsyndicationdeal'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
	END
	ELSE IF(@MasterType = 'LANGUAGE')
	BEGIN
		
		IF EXISTS(SELECT * FROM Language_Group_Details WHERE Language_Code = @Code)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Languagealreadyusedinlanguagegroup'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
		ELSE IF EXISTS(
			SELECT Language_Code FROM Acq_Deal_Rights_Subtitling WHERE Language_Code = @Code
			UNION
			SELECT Language_Code FROM Acq_Deal_Rights_Dubbing WHERE Language_Code = @Code
			)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Languagealreadyusedinacquisitiondeal'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
		ELSE IF EXISTS(
			SELECT Language_Code FROM Syn_Deal_Rights_Subtitling WHERE Language_Code = @Code
			UNION
			SELECT Language_Code FROM Syn_Deal_Rights_Dubbing WHERE Language_Code = @Code
			)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Languagealreadyusedinsyndicationdeal'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
	END
	ELSE IF(@MasterType = 'LANGUAGE_GROUP')
	BEGIN
		
		IF EXISTS(
			SELECT Language_Code FROM Acq_Deal_Rights_Subtitling WHERE Language_Code = @Code
			UNION
			SELECT Language_Code FROM Acq_Deal_Rights_Dubbing WHERE Language_Code = @Code
			)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Languagegroupalreadyusedinacquisitiondeal'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
		ELSE IF EXISTS(
			SELECT Language_Code FROM Syn_Deal_Rights_Subtitling WHERE Language_Group_Code = @Code
			UNION
			SELECT Language_Code FROM Syn_Deal_Rights_Dubbing WHERE Language_Group_Code = @Code
			)
		BEGIN
			SELECT @returnMessage = SLM.Message_Desc FROM System_Message SM
			INNER JOIN System_Module_Message SMM ON SMM.System_Message_Code = SM.System_Message_Code AND (SMM.Module_Code = @ModuleCode OR ISNULL(@ModuleCode, 0) = 0) 
			AND SM.Message_Key =  'Languagegroupalreadyusedinsyndicationdeal'
			INNER JOIN System_Language_Message SLM ON SLM.System_Module_Message_Code = SMM.System_Module_Message_Code AND SLM.System_Language_Code = @SysLanguageCode
		END
	END

	RETURN @returnMessage
END