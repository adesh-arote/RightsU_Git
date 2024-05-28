CREATE TABLE [dbo].[BMS_Schedule_Exception] (
    [BMS_Schedule_Exception_Code]         INT      IDENTITY (1, 1) NOT NULL,
    [BMS_Schedule_Process_Data_Temp_Code] INT      NULL,
    [Email_Notification_Msg_Code]         INT      NULL,
    [BV_Schedule_Transaction_Code]        INT      NULL,
    [IsMailSent]                          CHAR (1) NULL,
    CONSTRAINT [PK_BMS_Schedule_Exception] PRIMARY KEY CLUSTERED ([BMS_Schedule_Exception_Code] ASC)
);



