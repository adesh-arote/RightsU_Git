CREATE TABLE [dbo].[BV_HouseId_Data_Shows] (
    [BV_HouseId_Data_Shows_Code]  INT            IDENTITY (1, 1) NOT NULL,
    [House_Ids]                   VARCHAR (5000) NULL,
    [BV_Title]                    VARCHAR (5000) NULL,
    [Episode_No]                  VARCHAR (500)  NULL,
    [HouseID_Type_Code]           INT            NULL,
    [Mapped_Deal_Title_Code]      INT            NULL,
    [Is_Mapped]                   CHAR (1)       CONSTRAINT [DF_BV_HouseId_Data_Shows_Is_Mapped] DEFAULT ('N') NULL,
    [Parent_BV_HouseId_Data_Code] INT            NULL,
    [Upload_File_Code]            BIGINT         NULL,
    [IsIgnore]                    CHAR (1)       NULL,
    [Upload_Type]                 VARCHAR (10)   NULL,
    CONSTRAINT [PK_BV_HouseId_Data_Shows] PRIMARY KEY CLUSTERED ([BV_HouseId_Data_Shows_Code] ASC)
);

