CREATE TABLE [dbo].[Record_Locking] (
    [Record_Locking_Code] INT          IDENTITY (1, 1) NOT NULL,
    [Record_Code]         INT          NULL,
    [User_Code]           INT          NULL,
    [Module_Code]         INT          NULL,
    [Lock_Time]           DATETIME     NULL,
    [Release_Time]        DATETIME     NULL,
    [Is_Active]           CHAR (1)     NULL,
    [IP_Address]          VARCHAR (15) NULL,
    PRIMARY KEY CLUSTERED ([Record_Locking_Code] ASC)
);

