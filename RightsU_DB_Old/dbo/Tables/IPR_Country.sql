CREATE TABLE [dbo].[IPR_Country] (
    [IPR_Country_Code]      INT            IDENTITY (1, 1) NOT NULL,
    [IPR_Country_Name]      NVARCHAR (200) NULL,
    [Is_Domestic_Territory] CHAR (1)       NULL,
    [Inserted_On]           DATETIME       NULL,
    [Inserted_By]           INT            NULL,
    [Lock_Time]             DATETIME       NULL,
    [Last_Updated_Time]     DATETIME       NULL,
    [Last_Action_By]        INT            NULL,
    [Is_Active]             CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([IPR_Country_Code] ASC)
);



