CREATE TABLE [dbo].[Revenue_Vertical] (
    [Revenue_Vertical_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Revenue_Vertical_Name] NVARCHAR (MAX) NULL,
    [Type]                  CHAR (1)       NULL,
    [Is_Active]             CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([Revenue_Vertical_Code] ASC)
);

