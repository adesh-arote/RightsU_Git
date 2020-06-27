CREATE TABLE [dbo].[AsRun_FileStatus] (
    [AsRun_FileStatus_Code] INT           IDENTITY (1, 1) NOT NULL,
    [BVChannel_Code]        INT           NULL,
    [Channel_Code]          INT           NULL,
    [Channel_Name]          VARCHAR (50)  NULL,
    [File_Name]             VARCHAR (50)  NULL,
    [AsRun_Date]            DATETIME      NULL,
    [File_Status]           VARCHAR (10)  NULL,
    [Remarks]               VARCHAR (250) NULL,
    [IsMail_Sent]           CHAR (1)      NULL,
    [AsRun_Execution_Date]  DATETIME      NULL,
    [File_Code]             INT           NULL,
    CONSTRAINT [PK_AsRun_FileStatus] PRIMARY KEY CLUSTERED ([AsRun_FileStatus_Code] ASC)
);

