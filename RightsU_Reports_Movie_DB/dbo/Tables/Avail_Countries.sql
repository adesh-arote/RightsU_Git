CREATE TABLE [dbo].[Avail_Countries] (
    [Avail_Country_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Country_Codes]      NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Avail_Country] PRIMARY KEY CLUSTERED ([Avail_Country_Code] ASC)
);

