CREATE TABLE [dbo].[DM_Title_Import_Utility] (
    [DM_Title_Import_Utility_Code]    INT            IDENTITY (1, 1) NOT NULL,
    [Display_Name]                    NVARCHAR (MAX) NULL,
    [Order_No]                        INT            NULL,
    [Target_Table]                    NVARCHAR (MAX) NULL,
    [Target_Column]                   NVARCHAR (MAX) NULL,
    [Colum_Type]                      NVARCHAR (MAX) NULL,
    [Is_Multiple]                     CHAR (1)       NULL,
    [Reference_Table]                 NVARCHAR (MAX) NULL,
    [Reference_Text_Field]            NVARCHAR (MAX) NULL,
    [Reference_Value_Field]           NVARCHAR (MAX) NULL,
    [Reference_Whr_Criteria]          NVARCHAR (MAX) NULL,
    [Is_Active]                       CHAR (1)       NULL,
    [validation]                      NVARCHAR (MAX) NULL,
    [Is_Allowed_For_Resolve_Conflict] CHAR (1)       NULL,
    [ShortName]                       NVARCHAR (MAX) NULL,
    [Import_Type]                     CHAR (1)       NULL,
    PRIMARY KEY CLUSTERED ([DM_Title_Import_Utility_Code] ASC)
);



