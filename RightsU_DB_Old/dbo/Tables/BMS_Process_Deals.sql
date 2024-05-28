CREATE TABLE [dbo].[BMS_Process_Deals]
(
	[BMS_Process_Deals_Code] INT NOT NULL PRIMARY KEY IDENTITY, 
    [Acq_Deal_Code] INT NULL, 
    [Record_Status] CHAR NULL, 
    [Created_On] DATETIME NULL, 
    [Process_Start] DATETIME NULL, 
    [Process_End] DATETIME NULL
)
