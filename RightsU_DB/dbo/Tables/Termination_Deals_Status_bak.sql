CREATE TABLE [dbo].[Termination_Deals_Status_bak] (
    [Deal_Code]        INT           NULL,
    [Title_Code]       INT           NULL,
    [Episode_No]       INT           NULL,
    [Termination_Date] DATETIME      NULL,
    [Is_Error]         CHAR (1)      NULL,
    [Error_Details]    VARCHAR (MAX) NULL
);

