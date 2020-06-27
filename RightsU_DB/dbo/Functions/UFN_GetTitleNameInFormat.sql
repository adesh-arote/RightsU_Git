CREATE FUNCTION [dbo].[UFN_GetTitleNameInFormat]
(
	@dealTypeCondition VARCHAR(MAX), 
	@titleName NVARCHAR(MAX), 
	@episodeFrom INT, 
	@episodeTo INT
)
RETURNS NVARCHAR(MAX)
AS
BEGIN
	DECLARE  @Return_Value NVARCHAR(MAX) = ''

	IF(@titleName IS NULL)
		SET @titleName = ''

    IF (@dealTypeCondition = 'DEAL_MUSIC')
    BEGIN
        IF (@episodeFrom = 0 AND @episodeTo = 0)
		BEGIN
			IF(LTRIM(RTRIM(@titleName)) = '')
				SET @Return_Value = 'Unlimited'
			ELSE
				SET @Return_Value = @titleName + ' ( Unlimited )'
		END
        ELSE
		BEGIN
			IF(LTRIM(RTRIM(@titleName)) = '')
				SET @Return_Value = CAST(@episodeTo AS VARCHAR)
			ELSE
				SET @Return_Value = @titleName + ' ( ' + CAST(@episodeTo AS VARCHAR) + ' )'
		END
    END
    ELSE IF (@dealTypeCondition = 'DEAL_PROGRAM')
	BEGIN
		IF(LTRIM(RTRIM(@titleName)) = '')
			SET @Return_Value = CAST(@episodeFrom AS VARCHAR) + ' - ' + CAST(@episodeTo AS VARCHAR)
		ELSE
			SET @Return_Value = @titleName + ' ( ' + CAST(@episodeFrom AS VARCHAR) + ' - ' + CAST(@episodeTo AS VARCHAR) + ' )'
	END
    ELSE
        SET @Return_Value = @titleName

	RETURN @Return_Value
END

