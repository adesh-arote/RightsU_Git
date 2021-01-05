CREATE TYPE [dbo].[Content_Music_Link_UDT] AS TABLE (
    [Title_Content_Code]    VARCHAR (MAX)  NULL,
    [From]                  VARCHAR (MAX)  NULL,
    [From_Frame]            VARCHAR (MAX)  NULL,
    [To]                    VARCHAR (MAX)  NULL,
    [To_Frame]              VARCHAR (MAX)  NULL,
    [Music_Track]           NVARCHAR (MAX) NULL,
    [Duration]              VARCHAR (MAX)  NULL,
    [Duration_Frame]        VARCHAR (MAX)  NULL,
    [Version_Name]          NVARCHAR (MAX) NULL,
    [DM_Master_Import_Code] VARCHAR (50)   NULL,
    [Excel_Line_No]         NVARCHAR (50)  NULL);


GO
