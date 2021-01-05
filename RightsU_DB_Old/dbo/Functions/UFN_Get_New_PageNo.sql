CREATE FUNCTION DBO.UFN_Get_New_PageNo
(
	@RecordCount INT = 0,
	@PageNo INT = 1,
	@PageSize INT = 10
)
RETURNS INT
AS
BEGIN
	IF(@RecordCount > 0)
	BEGIN
		DECLARE @cnt INT = 0
	
		IF(@PageSize > @RecordCount)
			SET @PageSize = @RecordCount

		SET @cnt = (@PageNo * @PageSize)
		IF(@cnt >= @RecordCount)
		BEGIN
			DECLARE @v1 INT = 0 
			SET @PageNo = @RecordCount / @PageSize
			IF ((@PageNo * @PageSize) < @RecordCount)
				SET @PageNo = @PageNo + 1
		END
	END

	RETURN @PageNo
END