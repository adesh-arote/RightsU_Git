CREATE TABLE [dbo].[Acq_Deal_Movie] (
    [Acq_Deal_Movie_Code]  INT             IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]        INT             NULL,
    [Title_Code]           INT             NULL,
    [No_Of_Episodes]       INT             NULL,
    [Notes]                NVARCHAR (1000) NULL,
    [No_Of_Files]          INT             NULL,
    [Is_Closed]            CHAR (1)        NULL,
    [Title_Type]           CHAR (1)        NULL,
    [Amort_Type]           VARCHAR (10)    NULL,
    [Episode_Starts_From]  INT             NULL,
    [Closing_Remarks]      NVARCHAR (MAX)  NULL,
    [Movie_Closed_Date]    DATETIME        NULL,
    [Remark]               NVARCHAR (4000) NULL,
    [Ref_BMS_Movie_Code]   VARCHAR (100)   NULL,
    [Inserted_By]          INT             NULL,
    [Inserted_On]          DATETIME        NULL,
    [Last_UpDated_Time]    DATETIME        NULL,
    [Last_Action_By]       INT             NULL,
    [Episode_End_To]       INT             NULL,
    [Duration_Restriction] DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_Acq_Deal_Movie] PRIMARY KEY NONCLUSTERED ([Acq_Deal_Movie_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_Movie_Acq_Deal] FOREIGN KEY ([Acq_Deal_Code]) REFERENCES [dbo].[Acq_Deal] ([Acq_Deal_Code]),
    CONSTRAINT [FK_Acq_Deal_Movie_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);






GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Movie_1]
    ON [dbo].[Acq_Deal_Movie]([Acq_Deal_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Movie_2]
    ON [dbo].[Acq_Deal_Movie]([Title_Code] ASC);

