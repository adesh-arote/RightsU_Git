CREATE TABLE [dbo].[ssis_monitor_configure] (
    [package_name]       NVARCHAR (100) NOT NULL,
    [environment_name]   NVARCHAR (100) NULL,
    [threshold_time_sec] INT            NULL,
    [monitored]          BIT            NULL,
    [alert_email]        VARCHAR (100)  NULL
);

