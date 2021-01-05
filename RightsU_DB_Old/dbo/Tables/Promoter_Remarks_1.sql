CREATE TABLE [dbo].[Promoter_Remarks] (
    [Promoter_Remarks_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Promoter_Remark_Desc]  NVARCHAR (400) NULL,
    [Inserted_On]           DATETIME       NULL,
    [Inserted_By]           INT            NULL,
    [Last_Updated_Time]     DATETIME       NULL,
    [Last_Action_By]        INT            NULL,
    [Is_Active]             CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([Promoter_Remarks_Code] ASC)
);

