CREATE TABLE [dbo].[TblHouseIdMap] (
    [Map_Code]         INT          IDENTITY (1, 1) NOT NULL,
    [Map_House_Id_Unk] VARCHAR (20) NULL,
    [Map_House_Id]     VARCHAR (20) NULL,
    [Title]            VARCHAR (50) NULL,
    [Last_Updated_By]  INT          NULL,
    [Last_Updated_On]  DATETIME     NULL,
    [Src]              CHAR (1)     NULL,
    [FileID]           INT          NULL,
    CONSTRAINT [PK_TblHouseIdMap] PRIMARY KEY CLUSTERED ([Map_Code] ASC)
);

