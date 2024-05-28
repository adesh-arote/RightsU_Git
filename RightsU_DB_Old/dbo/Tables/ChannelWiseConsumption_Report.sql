CREATE TABLE [dbo].[ChannelWiseConsumption_Report] (
    [Deal_No]         VARCHAR (50)   NULL,
    [English_Title]   VARCHAR (250)  NULL,
    [Rights_Period]   VARCHAR (MAX)  NULL,
    [Deal_Movie_Code] INT            NOT NULL,
    [Channel_Code]    INT            NULL,
    [ChannelBeam]     VARCHAR (100)  NULL,
    [Channels]        VARCHAR (MAX)  NULL,
    [Run_Definition]  CHAR (2)       NULL,
    [Runs]            VARCHAR (5000) NULL,
    [Balance]         VARCHAR (5000) NULL,
    [ParameterName]   VARCHAR (5000) NULL,
    [ParameterValue]  VARCHAR (5000) NULL,
    [Id]              INT            NULL
);

