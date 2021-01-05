CREATE TABLE [dbo].[Avail_Syn] (
    [Avail_Syn_Code] NUMERIC (38) IDENTITY (1, 1) NOT NULL,
    [Title_Code]     INT          NULL,
    [Platform_Code]  INT          NULL,
    [Country_Code]   INT          NULL,
    CONSTRAINT [PK_Avail_Syn_Code] PRIMARY KEY CLUSTERED ([Avail_Syn_Code] ASC),
    CONSTRAINT [FK_Country_Avail_Syn] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Platform_Avail_Syn] FOREIGN KEY ([Platform_Code]) REFERENCES [dbo].[Platform] ([Platform_Code]),
    CONSTRAINT [FK_Title_Avail_Syn] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);

