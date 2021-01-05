CREATE TABLE [dbo].[BMS_ProgramCategory] (
    [BMS_ProgramCategory_Id] INT          IDENTITY (1, 1) NOT NULL,
    [BMS_Key]                INT          NULL,
    [BMS_Description]        VARCHAR (80) NULL,
    [IsArchived]             CHAR (1)     NULL,
    [ForeignId]              VARCHAR (40) NULL,
    [Inserted_By]            INT          NULL,
    [Inserted_On]            DATETIME     NULL,
    [Last_Updated_Time]      DATETIME     NULL,
    [Last_Action_By]         INT          NULL
);

