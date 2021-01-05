CREATE TABLE [dbo].[Aired_Details] (
    [Aired_Details_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Aired_Code]         INT      NULL,
    [Aired_On_Channel]   INT      NULL,
    [Start_Time]         DATETIME NULL,
    [End_Time]           DATETIME NULL,
    [Duration]           INT      NULL,
    [Amorted_On]         DATETIME NULL,
    CONSTRAINT [PK_Aired_Details] PRIMARY KEY CLUSTERED ([Aired_Details_Code] ASC),
    CONSTRAINT [FK_Aired_Details_Aired] FOREIGN KEY ([Aired_Code]) REFERENCES [dbo].[Aired] ([Aired_Code])
);

