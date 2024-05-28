CREATE TABLE [dbo].[Broadcast_Mode] (
    [Broadcast_Mode_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Broadcast_Mode_Name] VARCHAR (1000) NULL,
    [Mode_Key]            NCHAR (10)     NULL,
    CONSTRAINT [PK_Broadcast_Mode] PRIMARY KEY CLUSTERED ([Broadcast_Mode_Code] ASC)
);

