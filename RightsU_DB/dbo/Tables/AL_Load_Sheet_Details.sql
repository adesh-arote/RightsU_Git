CREATE TABLE [dbo].[AL_Load_Sheet_Details] (
    [AL_Load_Sheet_Details_Code] INT IDENTITY (1, 1) NOT NULL,
    [AL_Load_Sheet_Code]         INT NULL,
    [AL_Booking_Sheet_Code]      INT NULL,
    CONSTRAINT [PK_AL_Load_Sheet_Details] PRIMARY KEY CLUSTERED ([AL_Load_Sheet_Details_Code] ASC),
    CONSTRAINT [FK_AL_Load_Sheet_Details_AL_Booking_Sheet] FOREIGN KEY ([AL_Booking_Sheet_Code]) REFERENCES [dbo].[AL_Booking_Sheet] ([AL_Booking_Sheet_Code]),
    CONSTRAINT [FK_AL_Load_Sheet_Details_AL_Load_Sheet] FOREIGN KEY ([AL_Load_Sheet_Code]) REFERENCES [dbo].[AL_Load_Sheet] ([AL_Load_Sheet_Code])
);

