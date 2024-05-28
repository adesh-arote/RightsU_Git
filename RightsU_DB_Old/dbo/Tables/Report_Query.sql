CREATE TABLE [dbo].[Report_Query] (
    [Query_Code]            INT             IDENTITY (1, 1) NOT NULL,
    [Query_Name]            NVARCHAR (1000) NULL,
    [View_Name]             VARCHAR (50)    NULL,
    [Created_By]            VARCHAR (50)    NULL,
    [Last_Update_Time]      SMALLDATETIME   NULL,
    [Business_Unit_Code]    INT             NULL,
    [Security_Group_Code]   INT             NULL,
    [Visibility]            VARCHAR (2)     CONSTRAINT [DF_Report_Query_Visibility1] DEFAULT ('PR') NULL,
    [Theatrical_Territory]  VARCHAR (2)     CONSTRAINT [DF_Report_Query_Theatrical_Territory1] DEFAULT ('N') NOT NULL,
    [Expired_Deals]         VARCHAR (2)     CONSTRAINT [DF_Report_Query_Expired_Deals1] DEFAULT ('N') NOT NULL,
    [Alternate_Config_Code] VARCHAR (50)    NULL,
    CONSTRAINT [PK_Report_Query] PRIMARY KEY CLUSTERED ([Query_Code] ASC)
);





