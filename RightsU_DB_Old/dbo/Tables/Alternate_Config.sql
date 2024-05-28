CREATE TABLE [dbo].[Alternate_Config] (
    [Alternate_Config_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Alternate_Name]        NVARCHAR (200) NULL,
    [Language_Code]         INT            NULL,
    [Display_Order]         INT            NULL,
    [Direction]             VARCHAR (10)   NULL,
    [Is_Active]             CHAR (1)       NULL,
    CONSTRAINT [PK_Alternate_Config] PRIMARY KEY CLUSTERED ([Alternate_Config_Code] ASC)
);

