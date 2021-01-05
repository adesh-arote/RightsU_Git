CREATE TABLE [dbo].[Channel] (
    [Channel_Code]                 INT            IDENTITY (1, 1) NOT NULL,
    [Channel_Name]                 NVARCHAR (100) NULL,
    [Channel_Id]                   VARCHAR (20)   NULL,
    [Genres_Code]                  INT            NULL,
    [Entity_Code]                  INT            NULL,
    [Entity_Type]                  CHAR (1)       CONSTRAINT [DF_Channel_Entity_Type] DEFAULT ('O') NULL,
    [Schedule_Source_FilePath]     NVARCHAR (500) NULL,
    [BV_Channel_Code]              INT            NULL,
    [AsRun_Source_FilePath]        NVARCHAR (500) NULL,
    [HouseID_Prefix]               VARCHAR (50)   NULL,
    [HouseID_Digits_AfterPrefix]   INT            NULL,
    [HouseIdRange_From]            VARCHAR (50)   NULL,
    [HouseIdRange_To]              VARCHAR (50)   NULL,
    [OffsetTime_Schedule]          VARCHAR (50)   NULL,
    [OffsetTime_AsRun]             VARCHAR (50)   NULL,
    [Schedule_Source_FilePath_Pkg] NVARCHAR (500) NULL,
    [IsUseForAsRun]                CHAR (1)       NULL,
    [Inserted_On]                  DATETIME       NOT NULL,
    [Inserted_By]                  INT            NOT NULL,
    [Lock_Time]                    DATETIME       NULL,
    [Last_Updated_Time]            DATETIME       NULL,
    [Last_Action_By]               INT            NULL,
    [Is_Active]                    CHAR (1)       NOT NULL,
    [Order_For_schedule]           INT            NULL,
    [Channel_Group]                INT            NULL,
    [Channel_Format_Code]          INT            NULL,
    [Is_Parent_Child]              CHAR (1)       NULL,
    [Parent_Channel_Code]          INT            NULL,
    [Ref_Channel_Key]              INT            NULL,
    [Ref_Station_Key]              INT            NULL,
    [Channel_Category_Code]        INT            NULL,
    [Is_Get]                       CHAR (1)       NULL,
    [Is_Put]                       CHAR (1)       NULL,
    CONSTRAINT [PK_Channel] PRIMARY KEY CLUSTERED ([Channel_Code] ASC),
    CONSTRAINT [FK_Channel_Channel_Category] FOREIGN KEY ([Channel_Category_Code]) REFERENCES [dbo].[Channel_Category] ([Channel_Category_Code]),
    CONSTRAINT [FK_Channel_Channel_Format] FOREIGN KEY ([Channel_Format_Code]) REFERENCES [dbo].[Channel_Format] ([Channel_Format_Code]),
    CONSTRAINT [FK_Channel_Genres] FOREIGN KEY ([Genres_Code]) REFERENCES [dbo].[Genres] ([Genres_Code])
);







