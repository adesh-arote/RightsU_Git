
CREATE PROCEDURE [dbo].[USPGetAcqTabsList]
(
	@BVCode INT,
	@DepartmentCode INT
)
AS
BEGIN
	SELECT DISTINCT rcs.ValidOpList 
	from Attrib_report_Column arc 
	INNER JOIN Report_Column_Setup_IT rcs ON rcs.Column_Code = arc.Column_Code
	WHERE arc.BV_attrib_Group_Code = @BVCode AND arc.DP_attrib_Group_Code = @DepartmentCode AND ValidOpList IS NOT NULL
END

