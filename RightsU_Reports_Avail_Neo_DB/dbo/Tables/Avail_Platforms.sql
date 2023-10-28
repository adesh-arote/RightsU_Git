CREATE TABLE [dbo].[Avail_Platforms] (
    [Avail_Platform_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Platform_Codes]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Avail_Platform] PRIMARY KEY CLUSTERED ([Avail_Platform_Code] ASC)
);

