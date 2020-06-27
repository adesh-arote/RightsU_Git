CREATE TABLE [dbo].[IPR_Opp_Email_Freq] (
    [IPR_Opp_Email_Freq_Code] INT IDENTITY (1, 1) NOT NULL,
    [IPR_Opp_Code]            INT NULL,
    [Days]                    INT NULL,
    CONSTRAINT [PK_IPR_Opp_Email_Freq] PRIMARY KEY CLUSTERED ([IPR_Opp_Email_Freq_Code] ASC),
    CONSTRAINT [FK_IPR_Opp_Email_Freq_IPR_Opp] FOREIGN KEY ([IPR_Opp_Code]) REFERENCES [dbo].[IPR_Opp] ([IPR_Opp_Code])
);

