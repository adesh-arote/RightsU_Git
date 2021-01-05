CREATE TABLE [dbo].[PAF_Detail_Import_Temp] (
    [PAF_Detail_Import_Temp_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Master_PAF_No]               NVARCHAR (500) NULL,
    [Sub_PAF_No]                  NVARCHAR (500) NULL,
    [Date_Of_Creation]            NVARCHAR (500) NULL,
    [Show_Name]                   NVARCHAR (500) NULL,
    [Type_Of_Program]             NVARCHAR (500) NULL,
    [Nature_Of_Program]           NVARCHAR (500) NULL,
    [Department_Code]             NVARCHAR (500) NULL,
    [Channel_Code]                NVARCHAR (500) NULL,
    [Cost_Type]                   NVARCHAR (500) NULL,
    [Amount]                      NVARCHAR (500) NULL,
    [Service_Tax_Amount]          NVARCHAR (500) NULL,
    [Vat_Amount]                  NVARCHAR (500) NULL,
    [Total_Amount]                NVARCHAR (500) NULL,
    [Amount_Including_VAT]        NVARCHAR (500) NULL,
    [UserCode]                    INT            NULL,
    [FileCode]                    INT            NULL,
    CONSTRAINT [PK_PAF_Detail_Temp] PRIMARY KEY CLUSTERED ([PAF_Detail_Import_Temp_Code] ASC)
);

