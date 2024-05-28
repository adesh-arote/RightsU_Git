CREATE TABLE [dbo].[Attrib_Group] (
    [Attrib_Group_Code]  INT            NOT NULL,
    [Attrib_Group_Name]  NVARCHAR (100) NULL,
    [Attrib_Type]        VARCHAR (4)    NULL,
    [Comment_Name]       NVARCHAR (100) NULL,
    [Is_Multiple_Select] CHAR (1)       NULL,
    [Is_Active]          CHAR (1)       NULL,
    [Icon]               VARCHAR (100)  NULL,
    CONSTRAINT [PK_Attrib_Group] PRIMARY KEY CLUSTERED ([Attrib_Group_Code] ASC)
);

