CREATE TABLE [dbo].[Sql_Job_Parameters] (
    [Id]                               INT            IDENTITY (1, 1) NOT NULL,
    [Proc_Name]                        VARCHAR (100)  NULL,
    [Is_Process]                       CHAR (1)       NULL,
    [Process_Type]                     VARCHAR (10)   NULL,
    [Inserted_On]                      DATETIME       NULL,
    [Updated_On]                       DATETIME       NULL,
    [Param_DealCode]                   VARCHAR (1000) NULL,
    [Param_BV_HouseId_Data_Shows_Code] VARCHAR (8000) NULL,
    [Param_MaapedBvTitle]              VARCHAR (8000) NULL,
    CONSTRAINT [PK_Sql_Job_Parameters] PRIMARY KEY CLUSTERED ([Id] ASC)
);

