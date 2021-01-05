﻿CREATE TABLE [dbo].[Email_Notification_AsRun_Shows] (
    [Email_Notification_AsRun_Shows_Code] NUMERIC (18)   IDENTITY (1, 1) NOT NULL,
    [Asrun_Tr_Id]                         NUMERIC (18)   NULL,
    [ON_AIR]                              VARCHAR (250)  NULL,
    [Dt_Tm]                               VARCHAR (250)  NULL,
    [ID]                                  VARCHAR (1000) NULL,
    [S]                                   VARCHAR (250)  NULL,
    [TITLE]                               VARCHAR (250)  NULL,
    [DURATION]                            VARCHAR (250)  NULL,
    [STATUS]                              VARCHAR (250)  NULL,
    [DEVICE]                              VARCHAR (250)  NULL,
    [CH]                                  VARCHAR (250)  NULL,
    [RECONCILE]                           VARCHAR (250)  NULL,
    [TYP]                                 VARCHAR (250)  NULL,
    [SEC]                                 VARCHAR (250)  NULL,
    [Title_Code]                          INT            NULL,
    [File_Code]                           INT            NULL,
    [Channel_Code]                        INT            NULL,
    [Inserted_On]                         DATETIME       NULL,
    [Deal_Movie_Code]                     INT            NULL,
    [Deal_Movie_Rights_Code]              INT            NULL,
    [Email_Notification_Msg]              VARCHAR (5000) NULL,
    [IsMailSent]                          CHAR (1)       NULL,
    [IsRunCountCalculate]                 CHAR (1)       NULL,
    [Title_Name]                          VARCHAR (500)  NULL,
    [Right_Start_Date]                    DATETIME       NULL,
    [Right_End_Date]                      DATETIME       NULL,
    [No_Of_Runs_Across_Beams]             VARCHAR (50)   NULL,
    [Available_Channels]                  VARCHAR (500)  NULL,
    [Count_Of_AsRun]                      VARCHAR (50)   NULL,
    [Channel_Name]                        VARCHAR (250)  NULL,
    [Deal_Movie_Content_Code]             INT            NULL,
    [Episode_No]                          VARCHAR (100)  NULL,
    [RightsPeriod]                        VARCHAR (100)  NULL,
    CONSTRAINT [PK_Email_Notification_AsRun_Shows] PRIMARY KEY CLUSTERED ([Email_Notification_AsRun_Shows_Code] ASC)
);
