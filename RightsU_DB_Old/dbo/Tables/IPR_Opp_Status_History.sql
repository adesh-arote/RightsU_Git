CREATE TABLE [dbo].[IPR_Opp_Status_History] (
    [IPR_Opp_Status_History_Code] INT             IDENTITY (1, 1) NOT NULL,
    [IPR_Opp_Code]                INT             NULL,
    [IPR_Status]                  VARCHAR (50)    NULL,
    [Changed_On]                  DATETIME        NULL,
    [Changed_By]                  INT             NULL,
    [Remarks]                     NVARCHAR (1000) NULL,
    CONSTRAINT [PK_IPR_Opp_Status_History] PRIMARY KEY CLUSTERED ([IPR_Opp_Status_History_Code] ASC)
);



