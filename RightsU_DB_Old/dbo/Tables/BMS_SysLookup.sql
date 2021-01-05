CREATE TABLE [dbo].[BMS_SysLookup] (
    [BMS_SysLookup_Id]  INT          IDENTITY (1, 1) NOT NULL,
    [BMS_Key]           INT          NULL,
    [SysLookupClassId]  INT          NULL,
    [BMS_Description]   VARCHAR (80) NULL,
    [Code]              VARCHAR (20) NULL,
    [Inserted_By]       INT          NULL,
    [Inserted_On]       DATETIME     NULL,
    [Last_Updated_Time] DATETIME     NULL,
    [Last_Action_By]    INT          NULL
);

