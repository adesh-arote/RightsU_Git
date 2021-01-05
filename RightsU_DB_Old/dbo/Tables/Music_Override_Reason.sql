CREATE TABLE [dbo].[Music_Override_Reason] (
    [Music_Override_Reason_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Music_Override_Reason_Name] NVARCHAR (200) NULL,
    CONSTRAINT [PK_Music_Override_Reason] PRIMARY KEY CLUSTERED ([Music_Override_Reason_Code] ASC)
);

