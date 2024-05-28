CREATE TABLE [dbo].[IPR_APP_STATUS] (
    [IPR_App_Status_Code] INT            IDENTITY (1, 1) NOT NULL,
    [App_Status]          NVARCHAR (200) NULL,
    [Is_Active]           CHAR (1)       NULL,
    CONSTRAINT [PK_IPR_APP_STATUS] PRIMARY KEY CLUSTERED ([IPR_App_Status_Code] ASC)
);



