CREATE TABLE [dbo].[AvailData] (
    [AvailData_Code]       BIGINT         IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Code]        INT            NULL,
    [Acq_Deal_Rights_Code] INT            NULL,
    [Start_Date]           DATE           NULL,
    [End_Date]             DATE           NULL,
    [Is_Exclusive]         BIT            NULL,
    [Title_Code]           INT            NULL,
    [Platform_Codes]       NVARCHAR (MAX) NULL,
    [Country_Codes]        NVARCHAR (MAX) NULL,
    [Is_Title_Language]    BIT            NULL,
    [Sub_Language_Codes]   NVARCHAR (MAX) NULL,
    [Dub_Language_Codes]   NVARCHAR (MAX) NULL,
    [Episode_From]         INT            NULL,
    [Episode_To]           INT            NULL,
    [Is_Theatrical]        BIT            NULL,
    [Is_Processed]         CHAR (1)       NULL
);

