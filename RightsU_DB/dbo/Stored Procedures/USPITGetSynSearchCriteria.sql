CREATE PROCEDURE [dbo].[USPITGetSynSearchCriteria] 
@UsersCode INT,
@DepartmentCode INT,
@BVCode INT,
@Type VARCHAR(10) = 'PR'
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetSynSearchCriteria]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		--DECLARE
		--@UsersCode INT = 168,
		--@DepartmentCode INT = 17,
		--@BVCode INT = 19,
		--@Type VARCHAR(10) = 'PR'

		IF OBJECT_ID('tempdb..#TempSearchCriteria') IS NOT NULL DROP TABLE #TempSearchCriteria

		CREATE TABLE #TempSearchCriteria
		(
			ColumnCode INT,
			DisplayName VARCHAR(1000), 
			Display_Order INT, 
			Icon VARCHAR(100),
			Is_Mandatory CHAR(2),
			Css_Class NVARCHAR(1000),
			Config_Key VARCHAR(10)
		)

		INSERT INTO #TempSearchCriteria
		SELECT arc.Column_Code,rcs.Display_Name,arc.Display_Order,arc.Icon,arc.Is_Mandatory,rcs.Max_Length AS Css_Class, rcs.Alternate_Config_Code AS Config_Key 
		FROM Attrib_Report_Column arc WITH(NOLOCK)
		INNER JOIN Report_Column_Setup_IT rcs WITH(NOLOCK) ON rcs.Column_Code = arc.Column_Code AND rcs.IsPartofSelectOnly = 'N'
		WHERE arc.DP_Attrib_Group_Code = @DepartmentCode AND arc.BV_Attrib_Group_Code = @BVCode
		AND arc.Type = @Type

		SELECT * FROM #TempSearchCriteria

		IF OBJECT_ID('tempdb..#TempSearchCriteria') IS NOT NULL DROP TABLE #TempSearchCriteria
	
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPITGetSynSearchCriteria]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END