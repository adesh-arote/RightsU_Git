--DROP TABLE Integration_Runs
CREATE TABLE Integration_Runs
(
	Integration_Runs_Code INT IDENTITY (1, 1) NOT NULL,
	[Acq_Deal_Run_Code] INT,
	Title_Code INT,
	Channel_Code INT NULL,
	[Start_Date] DATETIME NULL,
	[End_Date]  DATETIME NULL,
	Schedule_Run INT NULL,
	Prime_Runs_Sched  INT NULL ,
	Off_Prime_Runs_Sched  INT NULL,
	InsertedOn DATETIME DEFAULT GETDATE(),
	IsRead CHAR(1) DEFAULT 'N'
	CONSTRAINT [PK_Integration_Runs] PRIMARY KEY CLUSTERED ([Integration_Runs_Code] ASC),	
	CONSTRAINT [FK_Integration_Runs_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code]),
	CONSTRAINT [FK_Integration_Runs_Channel] FOREIGN KEY ([Channel_Code]) REFERENCES [dbo].[Channel] ([Channel_Code])
)

