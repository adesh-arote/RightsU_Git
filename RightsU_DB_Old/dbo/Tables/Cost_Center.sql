CREATE TABLE [dbo].[Cost_Center] (
    [Cost_Center_Id]    INT          IDENTITY (1, 1) NOT NULL,
    [Cost_Center_Code]  VARCHAR (50) NULL,
    [Cost_Center_Name]  VARCHAR (50) NULL,
    [Inserted_On]       DATETIME     NULL,
    [Inserted_By]       INT          NULL,
    [Lock_Time]         DATETIME     NULL,
    [Last_Updated_Time] DATETIME     NULL,
    [Last_Action_By]    INT          NULL,
    [Is_Active]         CHAR (1)     NULL,
    CONSTRAINT [PK_Cost_Center] PRIMARY KEY CLUSTERED ([Cost_Center_Id] ASC)
);

