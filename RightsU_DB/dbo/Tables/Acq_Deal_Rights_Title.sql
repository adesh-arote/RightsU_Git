CREATE TABLE [dbo].[Acq_Deal_Rights_Title] (
    [Acq_Deal_Rights_Title_Code] INT IDENTITY (1, 1) NOT NULL,
    [Acq_Deal_Rights_Code]       INT NULL,
    [Title_Code]                 INT NULL,
    [Episode_From]               INT NULL,
    [Episode_To]                 INT NULL,
    CONSTRAINT [PK_Acq_Deal_Rights_Title] PRIMARY KEY CLUSTERED ([Acq_Deal_Rights_Title_Code] ASC),
    CONSTRAINT [FK_Acq_Deal_rights_title_Acq_Deal_rights] FOREIGN KEY ([Acq_Deal_Rights_Code]) REFERENCES [dbo].[Acq_Deal_Rights] ([Acq_Deal_Rights_Code]),
    CONSTRAINT [FK_Acq_Deal_Rights_Title_Title] FOREIGN KEY ([Title_Code]) REFERENCES [dbo].[Title] ([Title_Code])
);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Title]
    ON [dbo].[Acq_Deal_Rights_Title]([Acq_Deal_Rights_Code] ASC);


GO
CREATE NONCLUSTERED INDEX [IX_Acq_Deal_Rights_Title_1]
    ON [dbo].[Acq_Deal_Rights_Title]([Title_Code] ASC);


GO

CREATE TRIGGER TRG_Acq_Deal_Rights_Title_EPS_Insert
   ON Acq_Deal_Rights_Title
   AFTER Insert, Update
AS 
-- =============================================
-- Author:		Adesh Arote
-- Create date: 28 Feb 2015
-- Description:	Create trigger for generate episodes
-- =============================================
BEGIN
	
	Create Table #TmpNums(
		EpsNum Int
	)
	DECLARE @StartNum INT = 0, @EndNum INT = 0, @Right_Title_Code Int = 0
	Select @Right_Title_Code = Acq_Deal_Rights_Title_Code, @StartNum = Episode_From, @EndNum = Episode_To From Inserted

	;
	WITH gen AS (
		SELECT @StartNum AS num
		UNION ALL
		SELECT num+1 FROM gen WHERE num+1<=@EndNum
	)
	Insert InTo #TmpNums
	Select * From gen
	Option (maxrecursion 10000)

	Delete From Acq_Deal_Rights_Title_EPS Where Acq_Deal_Rights_Title_Code = @Right_Title_Code

	Insert InTo Acq_Deal_Rights_Title_EPS
	Select @Right_Title_Code, EpsNum From #TmpNums 

	Drop Table #TmpNums

END

GO


CREATE TRIGGER TRG_Acq_Deal_Rights_Title_EPS_Delete
   ON Acq_Deal_Rights_Title
   After Delete
AS 
-- =============================================
-- Author:		Adesh Arote
-- Create date: 28 Feb 2015
-- Description:	Create trigger for generate episodes
-- =============================================
BEGIN
	
	DECLARE @Right_Title_Code Int = 0
	Select @Right_Title_Code = Acq_Deal_Rights_Title_Code From Deleted

	Delete From Acq_Deal_Rights_Title_EPS Where Acq_Deal_Rights_Title_Code = @Right_Title_Code

END
