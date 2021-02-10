CREATE TABLE [dbo].[Avail_Acq_Theatrical] (
    [Avail_Acq_Theatrical_Code] NUMERIC (38) IDENTITY (1, 1) NOT NULL,
    [Title_Code]                INT          NULL,
    [Platform_Code]             INT          NULL,
    [Country_Code]              INT          NULL,
    CONSTRAINT [PK_Avail_Acq_Theatrical] PRIMARY KEY CLUSTERED ([Avail_Acq_Theatrical_Code] ASC)
);

