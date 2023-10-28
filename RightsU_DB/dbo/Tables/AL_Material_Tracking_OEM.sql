CREATE TABLE [dbo].[AL_Material_Tracking_OEM] (
    [AL_Material_Tracking_OEM_Code] INT          IDENTITY (1, 1) NOT NULL,
    [AL_Material_Tracking_Code]     INT          NULL,
    [AL_OEM_Code]                   INT          NULL,
    [Data_For]                      CHAR (1)     NULL,
    [Column_Value]                  VARCHAR (50) NULL,
    [Delivery_Date]                 DATE         NULL,
    [Updated_By]                    INT          NULL,
    [Updated_On]                    DATETIME     NULL,
    CONSTRAINT [PK_AL_Material_Tracking_OEM] PRIMARY KEY CLUSTERED ([AL_Material_Tracking_OEM_Code] ASC),
    CONSTRAINT [FK_AL_Material_Tracking_OEM_AL_Material_Tracking] FOREIGN KEY ([AL_Material_Tracking_Code]) REFERENCES [dbo].[AL_Material_Tracking] ([AL_Material_Tracking_Code]),
    CONSTRAINT [FK_AL_Material_Tracking_OEM_AL_OEM] FOREIGN KEY ([AL_OEM_Code]) REFERENCES [dbo].[AL_OEM] ([AL_OEM_Code])
);

