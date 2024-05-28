CREATE TABLE [dbo].[AL_Recommendation_Content] (
    [AL_Recommendation_Content_Code] INT      IDENTITY (1, 1) NOT NULL,
    [AL_Recommendation_Code]         INT      NULL,
    [AL_Vendor_Rule_Code]            INT      NULL,
    [Title_Code]                     INT      NULL,
    [Title_Content_Code]             INT      NULL,
    [Content_Type]                   CHAR (1) NULL,
    [Content_Status]                 CHAR (1) NULL,
    CONSTRAINT [PK_AL_Recommendation_Content] PRIMARY KEY CLUSTERED ([AL_Recommendation_Content_Code] ASC),
    CONSTRAINT [FK_AL_Recommendation_Content_AL_Recommendation] FOREIGN KEY ([AL_Recommendation_Code]) REFERENCES [dbo].[AL_Recommendation] ([AL_Recommendation_Code]),
    CONSTRAINT [FK_AL_Recommendation_Content_AL_Vendor_Rule] FOREIGN KEY ([AL_Vendor_Rule_Code]) REFERENCES [dbo].[AL_Vendor_Rule] ([AL_Vendor_Rule_Code]),
    CONSTRAINT [FK_AL_Recommendation_Content_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code]),
    CONSTRAINT [FK_AL_Recommendation_Content_Title_Content] FOREIGN KEY ([Title_Content_Code]) REFERENCES [dbo].[Title_Content] ([Title_Content_Code])
);

