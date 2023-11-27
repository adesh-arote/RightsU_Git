CREATE TABLE [dbo].[Acq_Deal_Run_LP](
	[Acq_Deal_Run_MultiYear_Code] [int] IDENTITY(1,1) NOT NULL,
	[Acq_Deal_Run_Code] [int] NULL,
	[Year_Start] [datetime] NULL,
	[Year_End] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Acq_Deal_Run_MultiYear_Code] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Acq_Deal_Run_LP]  WITH CHECK ADD FOREIGN KEY([Acq_Deal_Run_Code])
REFERENCES [dbo].[Acq_Deal_Run] ([Acq_Deal_Run_Code])
GO