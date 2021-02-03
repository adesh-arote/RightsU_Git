CREATE TABLE [dbo].[Report_Territory] (
    [Report_Territory_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Report_Territory_Name] VARCHAR (1000) NULL,
    [Is_Active]             CHAR (1)       NULL,
    [Is_Language_Cluster]   CHAR (1)       NULL,
    [Parent_Territory_Code] INT            NULL
);

