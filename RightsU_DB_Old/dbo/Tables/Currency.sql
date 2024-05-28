CREATE TABLE [dbo].[Currency] (
    [Currency_Code]     INT           IDENTITY (1, 1) NOT NULL,
    [Currency_Name]     NVARCHAR (50) NULL,
    [Currency_Sign]     NVARCHAR (10) NULL,
    [Inserted_On]       DATETIME      NOT NULL,
    [Inserted_By]       INT           NOT NULL,
    [Lock_Time]         DATETIME      NULL,
    [Last_Updated_Time] DATETIME      NULL,
    [Last_Action_By]    INT           NULL,
    [Is_Active]         CHAR (1)      NOT NULL,
    [Is_Base_Currency]  CHAR (1)      NULL,
    [Ref_Currency_Key]  INT           NULL,
    CONSTRAINT [PK_Currency] PRIMARY KEY CLUSTERED ([Currency_Code] ASC)
);



