CREATE TABLE [dbo].[Syn_Deal_Rights_Process_Validation] (
    [Syn_Deal_Rights_Process_Validation_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]                    INT      NULL,
    [Status]                                  CHAR (1) NULL,
    [Created_On]                              DATETIME DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Process_Validation] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Process_Validation_Code] ASC)
);

