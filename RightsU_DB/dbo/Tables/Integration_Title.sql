CREATE TABLE [dbo].[Integration_Title] (
    [Integration_Title_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Title_Code]             INT             NULL,
    [Foreign_System_Code]    INT             NULL,
    [Title_Name]             NVARCHAR (1000) NULL,
    [Duration]               DECIMAL (18)    NULL,
    [Year_Of_Production]     INT             NULL,
    [Deal_Type_Code]         INT             NULL,
    [Original_Dub]           CHAR (1)        NULL,
    [Title_Language_Code]    INT             NULL,
    [Process_Date]           DATETIME        NULL,
    [Inserted_On]            DATETIME        NULL,
    [Record_Status]          CHAR (1)        NULL,
    CONSTRAINT [PK_Integration_Title] PRIMARY KEY CLUSTERED ([Integration_Title_Code] ASC)
);

