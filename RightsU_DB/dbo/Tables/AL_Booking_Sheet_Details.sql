CREATE TABLE [dbo].[AL_Booking_Sheet_Details] (
    [AL_Booking_Sheet_Details_Code] INT            IDENTITY (1, 1) NOT NULL,
    [AL_Booking_Sheet_Code]         INT            NULL,
    [Title_Code]                    INT            NULL,
    [Title_Content_Code]            INT            NULL,
    [Extended_Group_Code]           INT            NULL,
    [Columns_Code]                  INT            NULL,
    [Group_Control_Order]           INT            NULL,
    [Validations]                   VARCHAR (50)   NULL,
    [Additional_Condition]          VARCHAR (MAX)  NULL,
    [Display_Name]                  VARCHAR (100)  NULL,
    [Allow_Import]                  CHAR (1)       NULL,
    [Columns_Value]                 NVARCHAR (MAX) NULL,
    [Cell_Status]                   CHAR (1)       NULL,
    [Action_By]                     INT            NULL,
    [Action_Date]                   DATETIME       NULL,
    CONSTRAINT [PK_AL_Booking_Sheet_Details] PRIMARY KEY CLUSTERED ([AL_Booking_Sheet_Details_Code] ASC),
    CONSTRAINT [FK_AL_Booking_Sheet_Details_AL_Booking_Sheet] FOREIGN KEY ([AL_Booking_Sheet_Code]) REFERENCES [dbo].[AL_Booking_Sheet] ([AL_Booking_Sheet_Code]),
    CONSTRAINT [FK_AL_Booking_Sheet_Details_Extended_Columns] FOREIGN KEY ([Columns_Code]) REFERENCES [dbo].[Extended_Columns] ([Columns_Code]),
    CONSTRAINT [FK_AL_Booking_Sheet_Details_Extended_Group] FOREIGN KEY ([Extended_Group_Code]) REFERENCES [dbo].[Extended_Group] ([Extended_Group_Code]),
    CONSTRAINT [FK_AL_Booking_Sheet_Details_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code]),
    CONSTRAINT [FK_AL_Booking_Sheet_Details_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code])
);

