CREATE TABLE [dbo].[Acq_Deal_Ancillary_Platform] (
    [Acq_Deal_Ancillary_Platform_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Ancillary_Code]          INT NULL,
    [Ancillary_Platform_code]          INT NULL,
    [Platform_Code]                    INT NULL,
    CONSTRAINT [PK_Acq_Deal_Ancillary_Platform] PRIMARY KEY CLUSTERED ([Acq_Deal_Ancillary_Platform_Code] ASC)
);

