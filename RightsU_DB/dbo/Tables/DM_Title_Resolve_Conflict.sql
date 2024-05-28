CREATE TABLE DM_Title_Resolve_Conflict
(
	DM_Title_Resolve_Conflict_Code INT PRIMARY KEY IDENTITY(1,1),
	Tab_Name NVARCHAR(MAX),
	Master_Type NVARCHAR(MAX),
	Roles  CHAR(1),
	Create_New CHAR(1),
	Order_No INT
)
