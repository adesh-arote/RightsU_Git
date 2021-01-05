CREATE TABLE [dbo].[System_Versions] (
    [Version_Code]           INT           IDENTITY (1, 1) NOT NULL,
    [Version_No]             VARCHAR (50)  NULL,
    [System_Name]            VARCHAR (50)  NULL,
    [Version_Published_Date] DATETIME      NULL,
    [Version_Details]        VARCHAR (MAX) NULL,
    CONSTRAINT [PK_System_Versions] PRIMARY KEY CLUSTERED ([Version_Code] ASC)
);



