CREATE TYPE [dbo].[Avail_Data_UDT] AS TABLE (
    [Acq_Deal_Code]        INT           NULL,
    [Acq_Deal_Rights_Code] INT           NULL,
    [Start_Date]           DATE          NULL,
    [End_Date]             DATE          NULL,
    [Is_Exclusive]         BIT           NULL,
    [Title_Code]           INT           NULL,
    [Episode_From]         INT           NULL,
    [Episode_To]           INT           NULL,
    [Is_Theatrical]        BIT           NULL,
    [Platform_Codes]       VARCHAR (MAX) NULL,
    [Country_Codes]        VARCHAR (MAX) NULL,
    [Is_Title_Language]    BIT           NULL,
    [Sub_Language_Codes]   VARCHAR (MAX) NULL,
    [Dub_Language_Codes]   VARCHAR (MAX) NULL);

