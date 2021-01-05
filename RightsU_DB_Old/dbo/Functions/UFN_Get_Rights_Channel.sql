CREATE FUNCTION [dbo].[UFN_Get_Rights_Channel](@Title_Code INT,@Acq_Deal_Code INT, @selectedChannelCodes VARCHAR(2000), @InNotIn VARCHAR(10))
RETURNS NVARCHAR(MAX)
AS
-- =============================================
-- Author:		Abhaysingh N. Rajpurohit
-- Create DATE: 16-Sep-2016
-- Description:	Return Channels added for title
-- =============================================
BEGIN
	DECLARE @Channel_Name NVARCHAR(MAX)= '', @Run_Type VARCHAR(2000)
	SELECT @Channel_Name = '', @Run_Type = '', @selectedChannelCodes = LTRIM(RTRIM(@selectedChannelCodes))

	IF(@InNotIn = 'IN' AND @selectedChannelCodes != '')
	BEGIN
		SELECT @Channel_Name = @Channel_Name + ISNULL(C.Channel_Name, '') + ', ' FROM Acq_Deal_Run ADR 
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADRT.Title_Code = @Title_Code
		INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
		INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code
		WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code AND ADRC.Channel_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@selectedChannelCodes, ','))

		SELECT @Run_Type = @Run_Type + (CASE WHEN ADR.Run_Type = 'C' THEN 'Limited' ELSE 'Unlimited' END) + ', ' FROM Acq_Deal_Run ADR 
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADRT.Title_Code = @Title_Code
		INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
		WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code AND ADRC.Channel_Code IN (SELECT number FROM DBO.fn_Split_withdelemiter(@selectedChannelCodes, ','))

	END
	ELSE IF(@InNotIn = 'NOT IN' AND @selectedChannelCodes != '')
	BEGIN
		SELECT @Channel_Name = @Channel_Name + ISNULL(C.Channel_Name, '') + ', ' FROM Acq_Deal_Run ADR 
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADRT.Title_Code = @Title_Code
		INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
		INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code
		WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code AND ADRC.Channel_Code NOT IN (SELECT number FROM DBO.fn_Split_withdelemiter(@selectedChannelCodes, ','))

		SELECT @Run_Type = @Run_Type + (CASE WHEN ADR.Run_Type = 'C' THEN 'Limited' ELSE 'Unlimited' END) + ', ' FROM Acq_Deal_Run ADR 
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADRT.Title_Code = @Title_Code
		INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
		WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code AND ADRC.Channel_Code NOT IN (SELECT number FROM DBO.fn_Split_withdelemiter(@selectedChannelCodes, ','))
	END
	ELSE
	BEGIN
		SELECT @Channel_Name = @Channel_Name + ISNULL(C.Channel_Name, '') + ', ' FROM Acq_Deal_Run ADR 
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADRT.Title_Code = @Title_Code
		INNER JOIN Acq_Deal_Run_Channel ADRC ON ADRC.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code
		INNER JOIN Channel C ON C.Channel_Code = ADRC.Channel_Code
		WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code

		SELECT @Run_Type = @Run_Type + (CASE WHEN ADR.Run_Type = 'C' THEN 'Limited' ELSE 'Unlimited' END) + ', ' FROM Acq_Deal_Run ADR 
		INNER JOIN Acq_Deal_Run_Title ADRT ON ADRT.Acq_Deal_Run_Code = ADR.Acq_Deal_Run_Code AND ADRT.Title_Code = @Title_Code
		WHERE ADR.Acq_Deal_Code = @Acq_Deal_Code
	END

	IF(LEN(@Channel_Name) >= 1)
		SET @Channel_Name = LEFT(@Channel_Name, LEN(@Channel_Name) - 1)
	ELSE
		SET @Channel_Name = 'No'

	IF(LEN(@Run_Type) >= 1)
		SET @Run_Type = LEFT(@Run_Type, LEN(@Run_Type) - 1)
	ELSE
		SET @Run_Type = 'No'

	RETURN (@Channel_Name + '~' + @Run_Type)
END
