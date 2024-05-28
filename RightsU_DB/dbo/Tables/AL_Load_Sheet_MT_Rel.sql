CREATE TABLE [dbo].[AL_Load_Sheet_MT_Rel] (
    [AL_Load_Sheet_MT_Rel_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AL_Load_Sheet_Code]        INT      NULL,
    [AL_Booking_Sheet_Code]     INT      NULL,
    [AL_Material_Tracking_Code] INT      NULL,
    [Content_Status]            CHAR (1) NULL,
    [AL_OEM_Code]               INT      NULL,
    CONSTRAINT [PK_AL_Load_Sheet_MT_Rel] PRIMARY KEY CLUSTERED ([AL_Load_Sheet_MT_Rel_Code] ASC),
    CONSTRAINT [FK_AL_Load_Sheet_MT_Rel_AL_Booking_Sheet] FOREIGN KEY ([AL_Booking_Sheet_Code]) REFERENCES [dbo].[AL_Booking_Sheet] ([AL_Booking_Sheet_Code]),
    CONSTRAINT [FK_AL_Load_Sheet_MT_Rel_AL_Load_Sheet_MT_Rel] FOREIGN KEY ([AL_Load_Sheet_Code]) REFERENCES [dbo].[AL_Load_Sheet] ([AL_Load_Sheet_Code]),
    CONSTRAINT [FK_AL_Load_Sheet_MT_Rel_AL_Material_Tracking] FOREIGN KEY ([AL_Material_Tracking_Code]) REFERENCES [dbo].[AL_Material_Tracking] ([AL_Material_Tracking_Code])
);

