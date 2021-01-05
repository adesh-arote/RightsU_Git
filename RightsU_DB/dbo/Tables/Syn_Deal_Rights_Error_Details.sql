CREATE TABLE [dbo].[Syn_Deal_Rights_Error_Details] (
    [Syn_Deal_Rights_Error_Details_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Syn_Deal_Rights_Code]               INT            NULL,
    [Title_Name]                         NVARCHAR (MAX) NULL,
    [Platform_Name]                      NVARCHAR (MAX) NULL,
    [Right_Start_Date]                   DATETIME       NULL,
    [Right_End_Date]                     DATETIME       NULL,
    [Right_Type]                         VARCHAR (100)  NULL,
    [Is_Sub_Licence]                     VARCHAR (10)   NULL,
    [Is_Title_Language_Right]            VARCHAR (10)   NULL,
    [Country_Name]                       NVARCHAR (MAX) NULL,
    [Subtitling_Language]                NVARCHAR (MAX) NULL,
    [Dubbing_Language]                   NVARCHAR (MAX) NULL,
    [Agreement_No]                       VARCHAR (MAX)  NULL,
    [ErrorMsg]                           VARCHAR (MAX)  NULL,
    [Episode_From]                       INT            NULL,
    [Episode_To]                         INT            NULL,
    [Inserted_On]                        DATETIME       NULL,
    [IsPushback]                         VARCHAR (100)  NULL,
    [Promoter_Group_Name]                NVARCHAR (MAX) NULL,
    [Promoter_Remark_DESC]               NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_Syn_Deal_Rights_Error_Details] PRIMARY KEY CLUSTERED ([Syn_Deal_Rights_Error_Details_Code] ASC)
);

