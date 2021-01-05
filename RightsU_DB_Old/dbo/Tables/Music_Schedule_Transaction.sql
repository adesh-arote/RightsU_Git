CREATE TABLE [dbo].[Music_Schedule_Transaction] (
    [Music_Schedule_Transaction_Code] NUMERIC (18)    IDENTITY (1, 1) NOT NULL,
    [BV_Schedule_Transaction_Code]    NUMERIC (18)    NULL,
    [Content_Music_Link_Code]         INT             NULL,
    [Music_Deal_Code]                 INT             NULL,
    [Channel_Code]                    INT             NULL,
    [Music_Label_Code]                INT             NULL,
    [Is_Ignore]                       CHAR (1)        NULL,
    [Is_Exception]                    CHAR (1)        NULL,
    [Is_Processed]                    CHAR (1)        NULL,
    [Inserted_On]                     DATETIME        NULL,
    [Inserted_By]                     INT             NULL,
    [Initial_Response]                CHAR (1)        NULL,
    [Music_Override_Reason_Code]      INT             NULL,
    [Remarks]                         NVARCHAR (4000) NULL,
    [Workflow_Status]                 NVARCHAR (2)    NULL,
    [Is_Mail_Sent]                    CHAR (1)        NULL,
    CONSTRAINT [PK_Music_Schedule_Tansaction] PRIMARY KEY CLUSTERED ([Music_Schedule_Transaction_Code] ASC)
);








GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'I- Ignore, O- Override', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Music_Schedule_Transaction', @level2type = N'COLUMN', @level2name = N'Initial_Response';

