CREATE TABLE [dbo].[Syn_Deal_Movie] (
    [Syn_Deal_Movie_Code] INT             IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]       INT             NULL,
    [Title_Code]          INT             NULL,
    [No_Of_Episode]       INT             NULL,
    [Is_Closed]           CHAR (1)        NULL,
    [Syn_Title_Type]      CHAR (1)        NULL,
    [Remark]              NVARCHAR (4000) NULL,
    [Episode_End_To]      INT             NULL,
    [Episode_From]        INT             NULL,
    CONSTRAINT [PK_Syn_Deal_Movie] PRIMARY KEY CLUSTERED ([Syn_Deal_Movie_Code] ASC)
);



