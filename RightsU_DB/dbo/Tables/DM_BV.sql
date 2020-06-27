CREATE TABLE [dbo].[DM_BV] (
    [IntCode]                     INT            IDENTITY (1, 1) NOT NULL,
    [DM_Deal_Code]                VARCHAR (10)   NULL,
    [Title_Name]                  VARCHAR (1000) NULL,
    [BV_Id]                       VARCHAR (100)  NULL,
    [Acq_Deal_Movie_Content_Code] INT            NULL,
    CONSTRAINT [PK_DM_BV] PRIMARY KEY CLUSTERED ([IntCode] ASC)
);

