CREATE TABLE [dbo].[Music_Deal_DealType] (
    [Music_Deal_Type_Code] INT IDENTITY (1, 1) NOT NULL,
    [Music_Deal_Code]      INT NOT NULL,
    [Deal_Type_Code]       INT NOT NULL,
    PRIMARY KEY CLUSTERED ([Music_Deal_Type_Code] ASC),
    FOREIGN KEY ([Deal_Type_Code]) REFERENCES [dbo].[Deal_Type] ([Deal_Type_Code]),
    FOREIGN KEY ([Music_Deal_Code]) REFERENCES [dbo].[Music_Deal] ([Music_Deal_Code])
);

