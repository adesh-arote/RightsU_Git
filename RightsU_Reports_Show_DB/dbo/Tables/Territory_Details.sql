CREATE TABLE [dbo].[Territory_Details] (
    [Territory_Details_Code] INT      IDENTITY (1, 1) NOT NULL,
    [Country_Code]           INT      NOT NULL,
    [Territory_Code]         INT      NOT NULL,
    [Is_Ref_Acq]             CHAR (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    [Is_Ref_Syn]             CHAR (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
    CONSTRAINT [PK_Territory_Details_1] PRIMARY KEY CLUSTERED ([Territory_Details_Code] ASC)
);

