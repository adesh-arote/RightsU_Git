
CREATE Procedure [dbo].[Usp_CreateIndexes_AcqSyn]
AS
BEGIN
BEGIN TRANSACTION

/*Approved_Deal_Process
*/
Insert into Approved_Deal_Process(Record_Code, Deal_Type, Deal_Status, Inserted_On, Is_Amend, Deal_Rights_Code)
Select distinct Record_Code, Deal_Type,Deal_Status, Inserted_On, Is_Amend, ISNULL(Deal_Rights_Code, 0) from Approved_Deal

/*---------------------------------------ACQUISITION------------------------------------*/
/*Acq_Deal_Rights_Dubbing
*/

IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Dubbing' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Dubbing ON dbo.Acq_Deal_Rights_Dubbing
	(
	Acq_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Dubbing_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Dubbing_1 ON dbo.Acq_Deal_Rights_Dubbing
	(
	Language_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Dubbing_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Dubbing_2 ON dbo.Acq_Deal_Rights_Dubbing
	(
	Acq_Deal_Rights_Code,
	Language_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END


/*Acq_Deal_Rights_Platform
*/
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Platform' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Platform ON dbo.Acq_Deal_Rights_Platform
	(
	Acq_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Platform_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Platform_1 ON dbo.Acq_Deal_Rights_Platform
	(
	Platform_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Platform_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Platform_2 ON dbo.Acq_Deal_Rights_Platform
	(
	Acq_Deal_Rights_Code,
	Platform_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

/*Acq_Deal_Rights_Subtitling
*/
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Subtitling' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Subtitling ON dbo.Acq_Deal_Rights_Subtitling
	(
	Acq_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Subtitling_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Subtitling_1 ON dbo.Acq_Deal_Rights_Subtitling
	(
	Language_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Subtitling_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Subtitling_2 ON dbo.Acq_Deal_Rights_Subtitling
	(
	Acq_Deal_Rights_Code,
	Language_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

/*Acq_Deal_Rights_Territory
*/
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Territory' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Territory ON dbo.Acq_Deal_Rights_Territory
	(
	Acq_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Territory_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Territory_1 ON dbo.Acq_Deal_Rights_Territory
	(
	Country_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Territory_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Territory_2 ON dbo.Acq_Deal_Rights_Territory
	(
	Acq_Deal_Rights_Code,
	Country_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

ALTER TABLE dbo.Acq_Deal_Rights_Territory SET (LOCK_ESCALATION = TABLE)

/*Acq_Deal_Rights_Title
*/
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Title' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Title ON dbo.Acq_Deal_Rights_Title
	(
	Acq_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Title_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Title_1 ON dbo.Acq_Deal_Rights_Title
	(
	Title_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Acq_Deal_Rights_Title_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Acq_Deal_Rights_Title_2 ON dbo.Acq_Deal_Rights_Title
	(
	Acq_Deal_Rights_Code,
	Title_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
ALTER TABLE dbo.Acq_Deal_Rights_Title SET (LOCK_ESCALATION = TABLE)



/*---------------------------------------SYNDICATION------------------------------------*/
/*Syn_Deal_Rights_Dubbing
*/
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Dubbing' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Dubbing ON dbo.Syn_Deal_Rights_Dubbing
	(
	Syn_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Dubbing_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Dubbing_1 ON dbo.Syn_Deal_Rights_Dubbing
	(
	Language_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Dubbing_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Dubbing_2 ON dbo.Syn_Deal_Rights_Dubbing
	(
	Syn_Deal_Rights_Code,
	Language_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
ALTER TABLE dbo.Syn_Deal_Rights_Dubbing SET (LOCK_ESCALATION = TABLE)

/*Syn_Deal_Rights_Platform
*/
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Platform' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Platform ON dbo.Syn_Deal_Rights_Platform
	(
	Syn_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Platform_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Platform_1 ON dbo.Syn_Deal_Rights_Platform
	(
	Platform_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Platform_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Platform_2 ON dbo.Syn_Deal_Rights_Platform
	(
	Syn_Deal_Rights_Code,
	Platform_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
ALTER TABLE dbo.Syn_Deal_Rights_Platform SET (LOCK_ESCALATION = TABLE)

/*Syn_Deal_Rights_Subtitling
*/
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Subtitling' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Subtitling ON dbo.Syn_Deal_Rights_Subtitling
	(
	Syn_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Subtitling_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Subtitling_1 ON dbo.Syn_Deal_Rights_Subtitling
	(
	Language_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Subtitling_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Subtitling_2 ON dbo.Syn_Deal_Rights_Subtitling
	(
	Syn_Deal_Rights_Code,
	Language_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
ALTER TABLE dbo.Syn_Deal_Rights_Subtitling SET (LOCK_ESCALATION = TABLE)

/*Syn_Deal_Rights_Territory
*/
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Territory' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Territory ON dbo.Syn_Deal_Rights_Territory
	(
	Syn_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END

IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Territory_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Territory_1 ON dbo.Syn_Deal_Rights_Territory
	(
	Country_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Territory_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Territory_2 ON dbo.Syn_Deal_Rights_Territory
	(
	Syn_Deal_Rights_Code,
	Country_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
ALTER TABLE dbo.Syn_Deal_Rights_Territory SET (LOCK_ESCALATION = TABLE)


/*Syn_Deal_Rights_Title
*/
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Title' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Title ON dbo.Syn_Deal_Rights_Title
	(
	Syn_Deal_Rights_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Title_1' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Title_1 ON dbo.Syn_Deal_Rights_Title
	(
	Title_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
IF NOT EXISTS (SELECT *  FROM sys.indexes  WHERE name='IX_Syn_Deal_Rights_Title_2' )
BEGIN
	CREATE NONCLUSTERED INDEX IX_Syn_Deal_Rights_Title_2 ON dbo.Syn_Deal_Rights_Title
	(
	Syn_Deal_Rights_Code,
	Title_Code
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
END
ALTER TABLE dbo.Syn_Deal_Rights_Title SET (LOCK_ESCALATION = TABLE)


COMMIT

  


END



