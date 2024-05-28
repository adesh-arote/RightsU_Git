CREATE TABLE [dbo].[Material_Order] (
    [Material_Order_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Material_Order_No]   VARCHAR (50)  NULL,
    [Material_Order_Date] DATETIME      NULL,
    [Vendor_Code]         INT           NULL,
    [Inserted_On]         DATETIME      NOT NULL,
    [Inserted_By]         INT           NULL,
    [Lock_Time]           DATETIME      NULL,
    [Last_Updated_Time]   DATETIME      NULL,
    [Last_Action_By]      INT           NULL,
    [Is_Active]           CHAR (1)      NOT NULL,
    [Remarks]             VARCHAR (500) NULL,
    CONSTRAINT [PK_Material_Order] PRIMARY KEY CLUSTERED ([Material_Order_Code] ASC),
    CONSTRAINT [FK_Material_Order_Vendor] FOREIGN KEY ([Vendor_Code]) REFERENCES [dbo].[Vendor] ([Vendor_Code])
);

