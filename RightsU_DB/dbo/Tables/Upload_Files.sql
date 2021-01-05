CREATE TABLE [dbo].[Upload_Files] (
    [File_Code]           BIGINT        IDENTITY (1, 1) NOT NULL,
    [File_Name]           VARCHAR (500) NULL,
    [Err_YN]              CHAR (10)     NULL,
    [Upload_Date]         DATETIME      NULL,
    [Uploaded_By]         INT           NULL,
    [Upload_Type]         VARCHAR (100) NULL,
    [Pending_Review_YN]   CHAR (1)      NULL,
    [Upload_Record_Count] INT           NULL,
    [Bank_Code]           INT           NULL,
    [Records_Inserted]    INT           NULL,
    [Records_Updated]     INT           NULL,
    [Total_Errors]        INT           NULL,
    [ChannelCode]         INT           NULL,
    [StartDate]           DATETIME      NULL,
    [EndDate]             DATETIME      NULL
);

