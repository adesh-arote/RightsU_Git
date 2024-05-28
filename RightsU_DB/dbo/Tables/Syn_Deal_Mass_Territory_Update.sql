CREATE TABLE [dbo].[Syn_Deal_Mass_Territory_Update] (
    [Syn_Deal_Mass_Update_Code] INT         IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Code]             INT         NULL,
    [Date]                      DATETIME    CONSTRAINT [DF_Syn_Deal_Mass_Territory_Update_Date] DEFAULT (getdate()) NULL,
    [Status]                    VARCHAR (2) NULL,
    [Processed_Date]            DATETIME    NULL,
    [Can_Process]               VARCHAR (2) NULL,
    [Created_By]                INT         NULL,
    CONSTRAINT [PK_Syn_Deal_Mass_Territory_Update] PRIMARY KEY CLUSTERED ([Syn_Deal_Mass_Update_Code] ASC),
    CONSTRAINT [FK_Syn_Deal_Mass_Territory_Update_Syn_Deal] FOREIGN KEY ([Syn_Deal_Code]) REFERENCES [dbo].[Syn_Deal] ([Syn_Deal_Code])
);

