CREATE TABLE [dbo].[Country] (
    [Country_Code]                  INT            IDENTITY (1, 1) NOT NULL,
    [Country_Name]                  NVARCHAR (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Domestic_Territory]         CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Theatrical_Territory]       CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Ref_Acq]                    CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Ref_Syn]                    CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Parent_Country_Code]           INT            NULL,
    [Applicable_For_Asrun_Schedule] CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]                   DATETIME       NOT NULL,
    [Inserted_By]                   INT            NOT NULL,
    [Lock_Time]                     DATETIME       NULL,
    [Last_Updated_Time]             DATETIME       NULL,
    [Last_Action_By]                INT            NULL,
    [Is_Active]                     CHAR (1)       COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Ref_Country_Key]               INT            NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([Country_Code] ASC)
);

