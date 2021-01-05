CREATE TABLE [dbo].[IPR_CLASS] (
    [IPR_Class_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [Description]       NVARCHAR (200) NULL,
    [Parent_Class_Code] INT            NULL,
    [Is_Last_Level]     CHAR (1)       NULL,
    [Position]          NVARCHAR (20)  NULL,
    [Is_Active]         VARCHAR (1)    NULL,
    CONSTRAINT [PK_IPR_CLASS] PRIMARY KEY CLUSTERED ([IPR_Class_Code] ASC)
);



