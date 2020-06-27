CREATE TABLE [dbo].[IPR_Opp_Status] (
    [IPR_Opp_Status_Code] INT            IDENTITY (1, 1) NOT NULL,
    [Opp_Status]          NVARCHAR (200) NULL,
    [Is_Active]           CHAR (1)       NULL,
    CONSTRAINT [PK_IPR_Opp_Status] PRIMARY KEY CLUSTERED ([IPR_Opp_Status_Code] ASC)
);



