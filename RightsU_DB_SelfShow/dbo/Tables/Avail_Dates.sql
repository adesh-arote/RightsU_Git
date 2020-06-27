CREATE TABLE [dbo].[Avail_Dates] (
    [Avail_Dates_Code] NUMERIC (38) IDENTITY (1, 1) NOT NULL,
    [Start_Date]       DATE         NULL,
    [End_Date]         DATE         NULL,
    CONSTRAINT [PK_Avail_Dates] PRIMARY KEY CLUSTERED ([Avail_Dates_Code] ASC)
);


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Avail_Dates', @level2type = N'COLUMN', @level2name = N'Avail_Dates_Code';

