CREATE TABLE [dbo].[Users_Detail] (
    [Users_Detail_Code] INT         IDENTITY (1, 1) NOT NULL,
    [Users_Code]        INT         NULL,
    [Attrib_Group_Code] INT         NULL,
    [Attrib_Type]       VARCHAR (4) NULL,
    CONSTRAINT [PK_Users_Detail] PRIMARY KEY CLUSTERED ([Users_Detail_Code] ASC),
    CONSTRAINT [FK_Users_Detail_Attrib_Group] FOREIGN KEY ([Attrib_Group_Code]) REFERENCES [dbo].[Attrib_Group] ([Attrib_Group_Code]),
    CONSTRAINT [FK_Users_Detail_Users] FOREIGN KEY ([Users_Code]) REFERENCES [dbo].[Users] ([Users_Code])
);

