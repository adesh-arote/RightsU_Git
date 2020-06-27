CREATE TYPE [dbo].[Platform_Group] AS TABLE (
    [Platform_Code]        INT            NULL,
    [Parent_Platform_Code] INT            NULL,
    [Base_Platform_Code]   INT            NULL,
    [Is_Display]           VARCHAR (2)    NULL,
    [Is_Last_Level]        VARCHAR (2)    NULL,
    [TempCnt]              INT            NULL,
    [TableCnt]             INT            NULL,
    [Platform_Name]        VARCHAR (1000) NULL,
    [Holdback_Status]      VARCHAR (10)   NULL,
    [Right_Code]           INT            NULL);

