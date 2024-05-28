CREATE TABLE [dbo].[Territory] (
    [Territory_Code]    INT             IDENTITY (1, 1) NOT NULL,
    [Territory_Name]    NVARCHAR (1000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Ref_Acq]        CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Ref_Syn]        CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Thetrical]      CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Active]         CHAR (1)        COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Inserted_On]       DATETIME        NULL,
    [Inserted_By]       INT             NULL,
    [Lock_Time]         DATETIME        NULL,
    [Last_Updated_Time] DATETIME        NULL,
    [Last_Action_By]    INT             NULL,
    CONSTRAINT [PK_Territory] PRIMARY KEY CLUSTERED ([Territory_Code] ASC)
);

