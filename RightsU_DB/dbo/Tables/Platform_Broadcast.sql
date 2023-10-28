CREATE TABLE [dbo].[Platform_Broadcast] (
    [Platform_Broadcast_Code] INT IDENTITY (1, 1) NOT NULL,
    [Platform_Code]           INT NULL,
    [Broadcast_Mode_Code]     INT NULL,
    PRIMARY KEY CLUSTERED ([Platform_Broadcast_Code] ASC)
);

