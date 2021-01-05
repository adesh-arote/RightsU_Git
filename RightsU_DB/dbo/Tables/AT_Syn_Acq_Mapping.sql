CREATE TABLE [dbo].[AT_Syn_Acq_Mapping] (
    [AT_Syn_Acq_Mapping_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Syn_Acq_Mapping_Code]    INT      NOT NULL,
    [Syn_Deal_Code]           INT      NOT NULL,
    [Syn_Deal_Movie_Code]     INT      NOT NULL,
    [Syn_Deal_Rights_Code]    INT      NOT NULL,
    [AT_Acq_Deal_Code]        INT      NOT NULL,
    [Deal_Movie_Code]         INT      NOT NULL,
    [Deal_Rights_Code]        INT      NOT NULL,
    [Right_Start_Date]        DATETIME NULL,
    [Right_End_Date]          DATETIME NULL
);

