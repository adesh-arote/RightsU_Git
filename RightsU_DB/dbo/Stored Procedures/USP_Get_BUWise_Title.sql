CREATE PROCEDURE [dbo].[USP_Get_BUWise_Title]
	@BuCode INT,
	@SearchKey NVARCHAR(100)
AS
BEGIN
	SELECT DISTINCT T.Title_Code, T.Title_Name FROM Acq_Deal AD
	INNER JOIN Content_Channel_Run CCR ON CCR.Acq_Deal_Code = AD.Acq_Deal_Code AND AD.Business_Unit_Code = @BuCode AND CCR.Schedule_Runs > 0
	INNER JOIN Title T ON T.Title_Code = CCR.Title_Code	AND UPPER(T.Title_Name) LIKE '%' + UPPER(@SearchKey) + '%'
END

--CREATE PROCEDURE [dbo].[USP_Get_BUWise_Title]
--	@BuCode INT,
--	@SearchKey NVARCHAR(100)
--AS
--BEGIN
--	SELECT 0 Title_Code, '' Title_Name 
--END