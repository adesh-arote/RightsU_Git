CREATE TABLE [dbo].[Channel_Cluster] (
    [Channel_Cluster_Code] INT           IDENTITY (1, 1) NOT NULL,
    [Channel_Cluster_Name] VARCHAR (MAX) NOT NULL,
    [Is_Active]            CHAR (1)      NOT NULL,
    CONSTRAINT [PK_Channel_Cluster] PRIMARY KEY CLUSTERED ([Channel_Cluster_Code] ASC)
);

