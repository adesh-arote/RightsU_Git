CREATE TABLE [dbo].[Master_Log]
(
	[Log_Code] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Module_Code] INT NULL, 
    [IntCode] INT NULL, 
    [Log_Data] NVARCHAR(MAX) NULL, 
    [Action_By] INT NULL, 
    [Action_On] DATETIME NULL, 
    [Action_Type] VARCHAR(50) NULL
)
