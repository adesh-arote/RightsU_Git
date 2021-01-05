CREATE TABLE [dbo].[Music_Title_temp] (
    [Music_Title_Code]   INT             NULL,
    [Music_Title_Name]   NVARCHAR (1000) NULL,
    [Duration_In_Min]    DECIMAL (18, 2) NULL,
    [Movie_Album]        NVARCHAR (400)  NULL,
    [Release_Year]       INT             NULL,
    [Language_Code]      INT             NULL,
    [Music_Type_Code]    INT             NULL,
    [Image_Path]         VARCHAR (2000)  NULL,
    [Music_Version_Code] INT             NULL,
    [Is_Active]          CHAR (1)        NULL,
    [Inserted_By]        INT             NULL,
    [Inserted_On]        DATETIME        NULL,
    [Last_UpDated_Time]  DATETIME        NULL,
    [Last_Action_By]     INT             NULL,
    [Lock_Time]          DATETIME        NULL,
    [Genres_Code]        INT             NULL,
    [Music_Album_Code]   INT             NULL,
    [Music_Tag]          NVARCHAR (200)  NULL,
    [Public_Domain]      CHAR (1)        NULL
);

