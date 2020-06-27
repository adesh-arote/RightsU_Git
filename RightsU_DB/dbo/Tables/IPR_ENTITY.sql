CREATE TABLE [dbo].[IPR_ENTITY] (
    [IPR_Entity_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Entity]          NVARCHAR (200) NULL,
    CONSTRAINT [PK_IPR_ENTITY] PRIMARY KEY CLUSTERED ([IPR_Entity_Code] ASC)
);



