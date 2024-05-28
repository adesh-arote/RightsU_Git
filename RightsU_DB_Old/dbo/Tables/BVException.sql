CREATE TABLE [dbo].[BVException] (
    [Bv_Exception_Code] INT       IDENTITY (1, 1) NOT NULL,
    [Bv_Exception_Type] CHAR (10) NULL,
    [Inserted_By]       INT       NULL,
    [Inserted_On]       DATETIME  NULL,
    [Lock_Time]         DATETIME  NULL,
    [Last_Updated_Time] DATETIME  NULL,
    [Last_Action_By]    INT       NULL,
    [Is_Active]         CHAR (1)  NULL,
    CONSTRAINT [PK_Exception] PRIMARY KEY CLUSTERED ([Bv_Exception_Code] ASC)
);

