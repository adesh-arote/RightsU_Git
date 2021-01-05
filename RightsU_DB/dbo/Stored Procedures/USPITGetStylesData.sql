CREATE Procedure USPITGetStylesData
@ViewName NVARCHAR(50)
AS
BEGIN

	Select ValidOpList AS GroupName,Display_Name AS [Key], Column_Code AS [Value] 
	FROM Report_Column_Setup where Display_Type = 'CR'
	AND IsPartofSelectonly IN ('Y','B') 
	AND View_Name =  CASE WHEN @ViewName = 'Acquisition' Then 'VW_ACQ_DEALS' ELSE 'VW_SYN_DEALS' END
	AND ValidOpList IS NOT NULL
	Order by 1 

END
