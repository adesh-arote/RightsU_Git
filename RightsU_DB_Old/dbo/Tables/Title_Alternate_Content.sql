CREATE TABLE [dbo].[Title_Alternate_Content] (
    [Title_Alternate_Content_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Alternate_Config_Code]        INT             NULL,
    [Title_Alternate_Code]         INT             NULL,
    [Episode_No]                   INT             NULL,
    [Content_Name]                 NVARCHAR (2000) NULL,
    [Language_Code]                INT             NULL,
    [Synopsis]                     NVARCHAR (4000) NULL,
    [Duration]                     DECIMAL (18, 2) NULL,
    [Title_Image]                  VARCHAR (2000)  NULL,
    [Is_Active]                    CHAR (1)        NULL,
    [Inserted_By]                  INT             NULL,
    [Inserted_On]                  DATETIME        NULL,
    [Last_UpDated_Time]            DATETIME        NULL,
    [Last_Action_By]               INT             NULL,
    [Lock_Time]                    DATETIME        NULL,
    CONSTRAINT [PK_Title_Alternate_Content] PRIMARY KEY CLUSTERED ([Title_Alternate_Content_Code] ASC),
    CONSTRAINT [FK_Title_Alternate_Content_Alternate_Config] FOREIGN KEY ([Alternate_Config_Code]) REFERENCES [dbo].[Alternate_Config] ([Alternate_Config_Code]),
    CONSTRAINT [FK_Title_Alternate_Content_Title_Alternate] FOREIGN KEY ([Title_Alternate_Code]) REFERENCES [dbo].[Title_Alternate] ([Title_Alternate_Code])
);

