CREATE TABLE [dbo].[AL_Purchase_Order_Rel] (
    [AL_Purchase_Order_Rel_Code]     INT      IDENTITY (1, 1) NOT NULL,
    [AL_Purchase_Order_Code]         INT      NULL,
    [AL_Purchase_Order_Details_Code] INT      NULL,
    [Status]                         CHAR (1) NULL,
    CONSTRAINT [PK_AL_Purchase_Order_Rel] PRIMARY KEY CLUSTERED ([AL_Purchase_Order_Rel_Code] ASC),
    CONSTRAINT [FK_AL_Purchase_Order_Rel_AL_Purchase_Order] FOREIGN KEY ([AL_Purchase_Order_Code]) REFERENCES [dbo].[AL_Purchase_Order] ([AL_Purchase_Order_Code]),
    CONSTRAINT [FK_AL_Purchase_Order_Rel_AL_Purchase_Order_Details] FOREIGN KEY ([AL_Purchase_Order_Details_Code]) REFERENCES [dbo].[AL_Purchase_Order_Details] ([AL_Purchase_Order_Details_Code])
);

