CREATE TABLE [dbo].[Language_Group_Details] (
    [Language_Group_Details_Code] INT IDENTITY (1, 1) NOT NULL,
    [Language_Group_Code]         INT NULL,
    [Language_Code]               INT NULL,
    CONSTRAINT [PK_Language_Group_Details\] PRIMARY KEY CLUSTERED ([Language_Group_Details_Code] ASC)
);

