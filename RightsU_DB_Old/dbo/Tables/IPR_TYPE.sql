CREATE TABLE [dbo].[IPR_TYPE] (
    [IPR_Type_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Type]          NVARCHAR (100) NULL,
    CONSTRAINT [PK_IPR_TYPE] PRIMARY KEY CLUSTERED ([IPR_Type_Code] ASC)
);



