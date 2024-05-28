CREATE TABLE [dbo].[Acq_Deal_Rights_Error_Details] (
    [Acq_Deal_Rights_Error_Details_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]               INT            NULL,
    [Title_Name]                         NVARCHAR (MAX) NULL,
    [Platform_Name]                      VARCHAR (MAX)  NULL,
    [Right_Start_Date]                   DATETIME       NULL,
    [Right_End_Date]                     DATETIME       NULL,
    [Right_Type]                         VARCHAR (MAX)  NULL,
    [Is_Sub_License]                     VARCHAR (MAX)  NULL,
    [Is_Title_Language_Right]            VARCHAR (MAX)  NULL,
    [Country_Name]                       NVARCHAR (MAX) NULL,
    [Subtitling_Language]                NVARCHAR (MAX) NULL,
    [Dubbing_Language]                   NVARCHAR (MAX) NULL,
    [Agreement_No]                       VARCHAR (MAX)  NULL,
    [ErrorMSG]                           VARCHAR (MAX)  NULL,
    [Episode_From]                       INT            NULL,
    [Episode_To]                         INT            NULL,
    [Is_Updated]                         VARCHAR (2)    NULL,
    [Inserted_On]                        DATETIME       NULL,
    PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Error_Details_Code] ASC)
);

