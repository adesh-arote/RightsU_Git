CREATE TABLE [dbo].[Syn_Deal_Movie] (
    [Syn_Deal_Movie_Code]      INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]            INT             NULL,
    [Title_Code]               INT             NULL,
    [No_Of_Episode]            INT             NULL,
    [Is_Closed]                CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Syn_Title_Type]           CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Remark]                   NVARCHAR (4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Episode_End_To]           INT             NULL,
    [Episode_From]             INT             NULL,
    [Closing_Remarks]          NVARCHAR (MAX)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Movie_Closed_Date]        DATETIME        NULL,
    [Opening_Remarks]          NVARCHAR (MAX)  COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Movie_Opening_Date]       DATETIME        NULL,
    [Deal_Closed_By]           INT             NULL,
    [Deal_Closed_On]           DATETIME        NULL,
    [Deal_Opened_By]           INT             NULL,
    [Deal_Opened_On]           DATETIME        NULL,
    [Is_Reopen]                VARCHAR (5)     COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Movie_Opening_Start_Date] DATETIME        NULL,
    CONSTRAINT [PK_Syn_Deal_Movie] PRIMARY KEY CLUSTERED ([Syn_Deal_Movie_Code] ASC)
);



