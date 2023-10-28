CREATE TABLE [dbo].[ssis_monitor_configure] (
    [package_name]       NVARCHAR (100) NOT NULL,
    [environment_name]   NVARCHAR (100) NULL,
    [threshold_time_sec] INT            NULL,
    [monitored]          BIT            NULL,
    [alert_email]        VARCHAR (100)  NULL
);


GO
CREATE CLUSTERED INDEX [ix_ssis_monitor_configure_package_name_env_name_monitored]
    ON [dbo].[ssis_monitor_configure]([package_name] ASC, [environment_name] ASC, [monitored] ASC);

