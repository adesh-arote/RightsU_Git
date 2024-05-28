CREATE TYPE [dbo].[Music_Content_Assignment_UDT] AS TABLE (
    [Music_Title_Code]        INT          NULL,
    [Title_Content_Code]      INT          NULL,
    [From]                    VARCHAR (12) NULL,
    [From_Frame]              INT          NULL,
    [To_Frame]                INT          NULL,
    [To]                      VARCHAR (12) NULL,
    [Duration]                VARCHAR (12) NULL,
    [Duration_Frame]          INT          NULL,
    [Content_Music_Link_Code] INT          NULL);

