CREATE TABLE [dbo].[Music_Title] (
    [Music_Title_Code]   INT             IDENTITY (1, 1) NOT NULL,
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
	[Public_Domain]      CHAR (1)        NULL,
    CONSTRAINT [PK_Music_Title] PRIMARY KEY CLUSTERED ([Music_Title_Code] ASC),
    CONSTRAINT [FK_Music_Title_Language] FOREIGN KEY ([Language_Code]) REFERENCES [dbo].[Language] ([Language_Code]),
    CONSTRAINT [FK_Music_Title_Music_Album] FOREIGN KEY ([Music_Album_Code]) REFERENCES [dbo].[Music_Album] ([Music_Album_Code]),
    CONSTRAINT [FK_Music_Title_Music_Type] FOREIGN KEY ([Music_Type_Code]) REFERENCES [dbo].[Music_Type] ([Music_Type_Code]),
    CONSTRAINT [FK_Music_Title_Music_Type1] FOREIGN KEY ([Music_Version_Code]) REFERENCES [dbo].[Music_Type] ([Music_Type_Code])
);














GO
-- =============================================
-- Author:		Adesh Arote
-- Create date: 19-May-2017
-- Description:	Maintain Records for search after Insert / Update / Delete
-- =============================================
CREATE TRIGGER [dbo].[TRG_MUSIC_TITLE_SEARCH] 
   ON  [dbo].[Music_Title]
   AFTER INSERT,DELETE,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;

	Insert InTo Process_Search(Record_Code, Module_Name, Created_On)
	Select Music_Title_Code, 'MT', GETDATE() From inserted

	Delete From Music_Title_Search Where Music_Title_Code In (
		Select Music_Title_Code From deleted
	)

END