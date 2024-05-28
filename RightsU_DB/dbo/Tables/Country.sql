CREATE TABLE [dbo].[Country] (
    [Country_Code]                  INT            IDENTITY (1, 1) NOT NULL,
    [Country_Name]                  NVARCHAR (100) NULL,
    [Is_Domestic_Territory]         CHAR (1)       CONSTRAINT [DF_Country_Is_Domestic_Territory] DEFAULT ('N') NULL,
    [Is_Theatrical_Territory]       CHAR (1)       NULL,
    [Is_Ref_Acq]                    CHAR (1)       CONSTRAINT [DF_Country_Is_Acq] DEFAULT ('N') NULL,
    [Is_Ref_Syn]                    CHAR (1)       CONSTRAINT [DF_Country_Is_Syn] DEFAULT ('N') NULL,
    [Parent_Country_Code]           INT            NULL,
    [Applicable_For_Asrun_Schedule] CHAR (1)       NULL,
    [Inserted_On]                   DATETIME       NOT NULL,
    [Inserted_By]                   INT            NOT NULL,
    [Lock_Time]                     DATETIME       NULL,
    [Last_Updated_Time]             DATETIME       NULL,
    [Last_Action_By]                INT            NULL,
    [Is_Active]                     CHAR (1)       CONSTRAINT [DF_Country_Is_Active] DEFAULT ('Y') NULL,
    [Ref_Country_Key]               INT            NULL,
    CONSTRAINT [PK_Country] PRIMARY KEY CLUSTERED ([Country_Code] ASC)
);

