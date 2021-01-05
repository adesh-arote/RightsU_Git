CREATE TABLE [dbo].[DM_Sale] (
    [IntCode]                               INT            NULL,
    [Deal_No]                               INT            NULL,
    [Title]                                 VARCHAR (1000) NULL,
    [Title_Sponsor]                         VARCHAR (1000) NULL,
    [Official_Sponsor]                      VARCHAR (1000) NULL,
    [FRO_To_Given_Title]                    VARCHAR (1000) NULL,
    [FRO_To_Given_Official]                 VARCHAR (1000) NULL,
    [FRO_Title_Sponsor_Tournament]          VARCHAR (1000) NULL,
    [FRO_Title_Sponsor_Validity]            VARCHAR (1000) NULL,
    [FRO_Offical_Sponsor]                   VARCHAR (1000) NULL,
    [FRO_Offical_Sponsor_Validity]          VARCHAR (1000) NULL,
    [Price_Protection_Title]                VARCHAR (1000) NULL,
    [Price_Protection_Official]             VARCHAR (1000) NULL,
    [Last_Matching_Rights_Title]            VARCHAR (1000) NULL,
    [Last_Matching_Rights_Official]         VARCHAR (1000) NULL,
    [Last_Matching_Rights_Tiltle_Validity]  VARCHAR (1000) NULL,
    [Last_Matching_Rights_offical_Validity] VARCHAR (1000) NULL,
    [Excluded_Catagories]                   VARCHAR (1000) NULL
);

