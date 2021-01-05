CREATE PROCEDURE [dbo].[USPTATList]
	@PageNo INT = 1,
	@PageSize INT = 100,
	@RecordCount INT OUT
AS
BEGIN
	IF(OBJECT_ID('TEMPDB..#TempTAT') IS NOT NULL)
		DROP TABLE #TempTAT
	CREATE TABLE #TempTAT 
	(
		Row_No INT IDENTITY(1,1),
		TATCode INT,
		DraftName NVARCHAR(100),
		[Type] CHAR(4),
		BusinessUnitName NVARCHAR(100),
		[User] NVARCHAR(100),
		IsAmend CHAR(4),
		DealType NVARCHAR(50),
		TATSLAName NVARCHAR(100),
		TATSLAStatusName NVARCHAR(50)
	)
	if(@PageNo = 0)
        Set @PageNo = 1

	INSERT INTO #TempTAT (TATCode, DraftName, [Type], BusinessUnitName, [User], IsAmend, DealType, TATSLAName, TATSLAStatusName)
	select T.TATCode,
		DraftName, 
		Case When [Type] = 'A' THEN 'Acq' ELSE CASE WHEN [Type] = 'S' THEN 'Syn' END END [Type],
		BU.Business_Unit_Name,
		U.First_Name,
		T.IsAmend,
		DT.Deal_Type_Name,
		TSA.TATSLAName,
		TS.TATSLAStatusName
	from TAT T
	LEFT JOIN Business_Unit BU ON BU.Business_Unit_Code = T.BusinessUnitCode
	LEFT JOIN Users U ON U.Users_Code = T.UserCode
	LEFT JOIN Deal_Type DT ON DT.Deal_Type_Code = T.DealType
	INNER JOIN TATSLAStatus TS ON TS.TATSLAStatusCode = T.TATSLAStatusCode
	LEFT JOIN TATSLA TSA ON T.TATSLACode = TSA.TATSLACode
	Order by T.InsertedOn

	SELECT @RecordCount = COUNT(*) FROM #TempTAT

	DELETE from #TempTAT
	WHERE Row_No > (@PageNo * @PageSize) OR Row_No <= ((@PageNo - 1) * @PageSize)
	
	select TATCode, DraftName, [Type], BusinessUnitName, [User], IsAmend, DealType, TATSLAName, TATSLAStatusName from #TempTAT

	IF OBJECT_ID('tempdb..#TempTAT') IS NOT NULL DROP TABLE #TempTAT
END


--ALTER PROCEDURE [dbo].[USPTATList]
--	@PageNo INT = 1,
--	@PageSize INT = 100,
--	@RecordCount INT OUT
--AS
--BEGIN
--DECLARE @TATCode INT=1,
--		@DraftName NVARCHAR(100)='',
--		@Type CHAR(4)='Y',
--		@User NVARCHAR(100)='',
--		@BusinessUnitName NVARCHAR(100)='',
--		@IsAmend CHAR(4)='Y',
--		@DealType NVARCHAR(50)='',
--		@TATSLAName NVARCHAR(100)='',
--		@TATSLAStatusName NVARCHAR(50)=''

--	select  @TATCode TATCode,
--		@DraftName DraftName ,
--		@Type [Type],
--		@User [User],
--		@BusinessUnitName BusinessUnitName,
--		@IsAmend IsAmend,
--		@DealType DealType,
--		@TATSLAName TATSLAName,
--		@TATSLAStatusName TATSLAStatusName

--END

--DECLARE @C INT=0
--exec USPTATList 1,100,@C