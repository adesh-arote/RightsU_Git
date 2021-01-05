CREATE TABLE [dbo].[Amort_Rule_Details] (
    [Amort_Rule_Details_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Amort_Rule_Code]         INT            NULL,
    [From_Range]              INT            NULL,
    [To_Range]                INT            NULL,
    [Per_Cent]                DECIMAL (7, 3) NULL,
    [Month]                   INT            NULL,
    [Year]                    INT            NULL,
    [Period_Type]             CHAR (1)       NULL,
    [End_Of_Year]             INT            NULL,
    CONSTRAINT [PK_Amort_Rule_Details] PRIMARY KEY CLUSTERED ([Amort_Rule_Details_Code] ASC),
    CONSTRAINT [FK_Amort_Rule_Details_Amort_Rule] FOREIGN KEY ([Amort_Rule_Code]) REFERENCES [dbo].[Amort_Rule] ([Amort_Rule_Code])
);



