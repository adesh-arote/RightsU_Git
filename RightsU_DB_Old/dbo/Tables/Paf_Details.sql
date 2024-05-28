CREATE TABLE [dbo].[Paf_Details] (
    [Id]                                     INT             IDENTITY (1, 1) NOT NULL,
    [Paf_Code]                               INT             NULL,
    [Paf_Cost_Type_Code]                     INT             NULL,
    [Ams_Cost_Type_Code]                     INT             NULL,
    [P_Amount]                               NUMERIC (22, 2) NULL,
    [P_Utilized]                             NUMERIC (22, 2) NULL,
    [P_Balance]                              NUMERIC (22, 2) NULL,
    [Ct_Amount]                              NUMERIC (22, 2) NULL,
    [Ct_Utilized]                            NUMERIC (22, 2) NULL,
    [Ct_Balance]                             NUMERIC (22, 2) NULL,
    [IsCostTypeMatching]                     VARCHAR (5000)  NULL,
    [PAF_Level_Balance_Available]            VARCHAR (5000)  NULL,
    [Cost_Type_Level_Balance_Available]      VARCHAR (5000)  NULL,
    [UsedInTransaction]                      VARCHAR (20)    NULL,
    [PAF_Level_Utilised_Amt_Available]       VARCHAR (5000)  NULL,
    [Cost_Type_Level_Utilised_Amt_Available] VARCHAR (5000)  NULL,
    [Entry_Type]                             VARCHAR (20)    NULL,
    [User_Code]                              INT             NULL
);

