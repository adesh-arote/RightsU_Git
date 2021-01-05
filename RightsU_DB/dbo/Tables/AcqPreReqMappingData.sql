CREATE TABLE [dbo].[AcqPreReqMappingData] (
    [AcqPreReqMappingDataCode] INT          IDENTITY (1, 1) NOT NULL,
    [MappingFor]               VARCHAR (20) NULL,
    [PrimaryDataCode]          INT          NULL,
    [SecondaryDataCode]        INT          NULL,
    PRIMARY KEY CLUSTERED ([AcqPreReqMappingDataCode] ASC)
);

