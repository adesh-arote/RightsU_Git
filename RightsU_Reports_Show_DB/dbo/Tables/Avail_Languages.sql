CREATE TABLE [dbo].[Avail_Languages] (
    [Avail_Languages_Code] NUMERIC (38)  IDENTITY (1, 1) NOT NULL,
    [Language_Codes]       VARCHAR (MAX) NULL,
    CONSTRAINT [PK_Avail_Languages] PRIMARY KEY CLUSTERED ([Avail_Languages_Code] ASC)
);

