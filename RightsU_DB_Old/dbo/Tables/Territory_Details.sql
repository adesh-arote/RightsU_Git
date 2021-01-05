CREATE TABLE [dbo].[Territory_Details] (
    [Territory_Details_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Country_Code]           INT      NOT NULL,
    [Territory_Code]         INT      NOT NULL,
    [Is_Ref_Acq]             CHAR (1) CONSTRAINT [DF_Territory_Details_Is_Ref_Acq] DEFAULT ('N') NULL,
    [Is_Ref_Syn]             CHAR (1) CONSTRAINT [DF_Territory_Details_Is_Ref_Syn] DEFAULT ('N') NULL,
    CONSTRAINT [PK_Territory_Details_1] PRIMARY KEY CLUSTERED ([Territory_Details_Code] ASC),
    CONSTRAINT [FK_Territory_Details_Country] FOREIGN KEY ([Country_Code]) REFERENCES [dbo].[Country] ([Country_Code]),
    CONSTRAINT [FK_Territory_Details_Territory] FOREIGN KEY ([Territory_Code]) REFERENCES [dbo].[Territory] ([Territory_Code])
);

