CREATE TABLE [dbo].[Paf_Cost_Type_Mapping] (
    [Paf_Ctm_Code]       INT            IDENTITY (1, 1) NOT NULL,
    [Paf_Cost_Type]      VARCHAR (5000) NULL,
    [Ams_Cost_Type_Code] INT            NULL,
    [Is_Mapped]          CHAR (1)       NULL,
    [Upload_File_Code]   INT            NULL,
    [Upload_Type]        VARCHAR (5)    NULL,
    CONSTRAINT [PK_Paf_Cost_Type_Mapping] PRIMARY KEY CLUSTERED ([Paf_Ctm_Code] ASC)
);

