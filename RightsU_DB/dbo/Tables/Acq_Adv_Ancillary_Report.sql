CREATE TABLE [dbo].[Acq_Adv_Ancillary_Report]
(
	[Acq_Adv_Ancillary_Report_Code] INT NOT NULL PRIMARY KEY IDENTITY (1, 1), 
    [Agreement_No] VARCHAR(MAX) NULL, 
    [Title_Codes] VARCHAR(MAX) NULL, 
    [Platform_Codes] VARCHAR(MAX) NULL, 
    [Business_Unit_Code] INT NULL, 
    [IncludeExpired] VARCHAR(MAX) NULL, 
    [Date_Format] NVARCHAR(2000) NULL, 
    [DateTime_Format] NVARCHAR(2000) NULL, 
    [Created_By] NVARCHAR(2000) NULL, 
    [SysLanguageCode] INT NULL, 
    [Report_Name] NVARCHAR(2000) NULL, 
    [Accessibility] CHAR(10) NULL, 
    [File_Name] NVARCHAR(2000) NULL, 
    [Process_Start] DATETIME NULL, 
    [Process_End] DATETIME NULL, 
    [Report_Status] CHAR NULL, 
    [Error_Message] NVARCHAR(MAX) NULL, 
    [Generated_By] INT NULL, 
    [Generated_On] DATETIME NULL
)
