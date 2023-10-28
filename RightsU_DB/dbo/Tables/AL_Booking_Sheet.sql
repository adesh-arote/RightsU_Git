CREATE TABLE [dbo].[AL_Booking_Sheet] (
    [AL_Booking_Sheet_Code]  INT            IDENTITY (1, 1) NOT NULL,
    [AL_Recommendation_Code] INT            NULL,
    [Vendor_Code]            INT            NULL,
    [Booking_Sheet_No]       VARCHAR (50)   NULL,
    [Version_No]             INT            NULL,
    [Movie_Content_Count]    INT            NULL,
    [Show_Content_Count]     INT            NULL,
    [Remarks]                NVARCHAR (MAX) NULL,
    [Record_Status]          VARCHAR (5)    NULL,
    [Excel_File]             VARCHAR (100)  NULL,
    [Inserted_By]            INT            NULL,
    [Inserted_On]            DATETIME       NULL,
    [Last_Updated_Time]      DATETIME       NULL,
    [Last_Action_By]         INT            NULL,
    [Lock_Time]              DATETIME       NULL,
    CONSTRAINT [PK_AL_Booking_Sheet] PRIMARY KEY CLUSTERED ([AL_Booking_Sheet_Code] ASC),
    CONSTRAINT [FK_AL_Booking_Sheet_AL_Recommendation] FOREIGN KEY ([AL_Recommendation_Code]) REFERENCES [dbo].[AL_Recommendation] ([AL_Recommendation_Code]),
    CONSTRAINT [FK_AL_Booking_Sheet_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

