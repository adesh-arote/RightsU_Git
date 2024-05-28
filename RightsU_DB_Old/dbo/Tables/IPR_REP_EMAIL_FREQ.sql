CREATE TABLE [dbo].[IPR_REP_EMAIL_FREQ] (
    [IPR_Rep_Email_Freq_Code] INT IDENTITY (1, 1) NOT NULL,
    [IPR_Rep_Code]            INT NULL,
    [Days]                    INT NULL,
    CONSTRAINT [PK_IPR_EMAIL_FREQ] PRIMARY KEY CLUSTERED ([IPR_Rep_Email_Freq_Code] ASC),
    CONSTRAINT [FK_IPR_EMAIL_FREQ_IPR_REP] FOREIGN KEY ([IPR_Rep_Code]) REFERENCES [dbo].[IPR_REP] ([IPR_Rep_Code])
);

