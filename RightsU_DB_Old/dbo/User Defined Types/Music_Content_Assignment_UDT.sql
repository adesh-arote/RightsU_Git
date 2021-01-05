CREATE TYPE [dbo].[Music_Content_Assignment_UDT] AS TABLE
(
	[Music_Title_Code] INT,
	[Title_Content_Code] INT NULL,
	[From] VARCHAR (12) NULL,--TCN INT
	[From_Frame] INT NULL,
	[To_Frame] INT NULL,  
	[To] VARCHAR (12) NULL,--TCN INT
	[Duration] VARCHAR (12) NULL,--duration INT
	[Duration_Frame] INT NULL,
	[Content_Music_Link_Code] INT NULL
)
