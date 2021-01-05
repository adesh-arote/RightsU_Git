CREATE TABLE [dbo].[HouseID_Type] (
    [HouseID_Type_Code]    INT           IDENTITY (1, 1) NOT NULL,
    [HouseID_Type_Name]    VARCHAR (100) NULL,
    [HouseID_Type_BV_Name] VARCHAR (100) NULL,
    [Inserted_On]          DATETIME      NULL,
    [Inserted_By]          INT           NULL,
    [Lock_Time]            DATETIME      NULL,
    [Last_Updated_Time]    DATETIME      NULL,
    [Last_Action_By]       INT           NULL,
    [Is_Active]            CHAR (1)      NULL,
    CONSTRAINT [PK_HouseId_Type] PRIMARY KEY CLUSTERED ([HouseID_Type_Code] ASC)
);

