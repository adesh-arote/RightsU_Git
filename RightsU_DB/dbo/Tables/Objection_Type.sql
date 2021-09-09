CREATE TABLE [dbo].[Objection_Type]
(
	Objection_Type_Code INT IDENTITY(1,1) PRIMARY KEY,
	Objection_Type_Name VARCHAR(MAX),
	Is_Active CHAR(1),
	Inserted_On DATETIME,
	Inserted_By int,
	Last_Updated_Time Datetime,
	Last_Action_By int
)
