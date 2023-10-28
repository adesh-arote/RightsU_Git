CREATE TABLE [dbo].[TestParam] (
    [Params]     VARCHAR (MAX) NULL,
    [ProcType]   VARCHAR (MAX) NULL,
    [InsertedOn] DATETIME      DEFAULT (getdate()) NULL
);

