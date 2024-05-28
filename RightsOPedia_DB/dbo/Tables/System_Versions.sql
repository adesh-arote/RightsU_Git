CREATE TABLE [dbo].[System_Versions] (
    [Version_Code]           INT            IDENTITY (1, 1) NOT NULL,
    [Version_No]             VARCHAR (50)   NULL,
    [System_Name]            VARCHAR (50)   NULL,
    [Version_Published_Date] DATETIME       NULL,
    [Version_Details]        NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_IT_System_Versions] PRIMARY KEY CLUSTERED ([Version_Code] ASC)
);

