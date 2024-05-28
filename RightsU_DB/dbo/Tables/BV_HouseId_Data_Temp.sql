CREATE TABLE [dbo].[BV_HouseId_Data_Temp] (
    [BV_HouseId_Data_Code]        INT            IDENTITY (1, 1) NOT NULL,
    [House_Ids]                   VARCHAR (5000) NULL,
    [BV_Title]                    VARCHAR (5000) NULL,
    [No_Of_Episode]               VARCHAR (500)  NULL,
    [House_Type]                  VARCHAR (500)  NULL,
    [Mapped_Deal_Title_Code]      INT            NULL,
    [Is_Mapped]                   CHAR (1)       NULL,
    [Parent_BV_HouseId_Data_Code] INT            NULL,
    [Upload_File_Code]            BIGINT         NULL
);

