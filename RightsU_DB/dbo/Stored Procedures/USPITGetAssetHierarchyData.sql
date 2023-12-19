CREATE PROCEDURE [dbo].[USPITGetAssetHierarchyData] 
(
	@ProgramCode VARCHAR(MAX)	
)
AS
BEGIN    
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[USPITGetAssetHierarchyData]', 'Step 1', 0, 'Started Procedure', 0, ''
		SELECT p.Program_Code AS ProgramCode, p.Program_Name AS ProgramName,t.Title_Code AS TitleCode, t.Title_Name AS TitleName, 'Ep:' + CAST(tc.Episode_No AS NVARCHAR(max)) AS EpisodeNo, tc.Episode_Title AS EpisodeName, tcv.Version_Code AS VersionCode, v.Version_Name AS VersionName FROM Program p (NOLOCK)
				INNER JOIN Title t (NOLOCK) ON t.Program_Code=p.Program_Code
				INNER JOIN Title_Content tc (NOLOCK) ON tc.Title_Code=t.Title_Code
				LEFT JOIN Title_Content_Version tcv (NOLOCK) ON tcv.Title_Content_Code=tc.Title_Content_Code
				INNER JOIN Version v (NOLOCK) ON v.Version_Code=tcv.Version_Code
		WHERE p.Program_Code = @ProgramCode
		ORDER BY p.Program_Code,t.Title_Code, tc.Episode_No
		--IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	
		--CREATE TABLE #temp(
		--	Program_Code INT,
		--	Program_Name	NVARCHAR(MAX),
		--	Title_Code	INT,
		--	Title_Name	NVARCHAR(MAX),
		--	Episode_No	INT,
		--	Episode_Title	NVARCHAR(MAX),
		--	Version_Code INT, 	
		--	Version_Name NVARCHAR(MAX)
		--)

		--INSERT INTO #temp VALUES(5,'Boss Ep 1',12075,'Aisha',1,'Aisha',1,'Standard')
		--INSERT INTO #temp VALUES(5,'Boss Ep 1',12075,'Aisha',1,'Aisha',3,'Prime Time')
		--INSERT INTO #temp VALUES(5,'Boss Ep 1',12075,'Aisha',2,'Aisha',2,'Edited')
		--INSERT INTO #temp VALUES(5,'Boss Ep 1',12075,'Aisha',3,'Aisha',1,'Standard')
		--INSERT INTO #temp VALUES(5,'Boss Ep 1',12075,'Aisha',4,'Aisha',1,'Standard')
		--INSERT INTO #temp VALUES(5,'Boss Ep 1',12075,'Aisha',5,'Aisha',1,'Standard')
		--INSERT INTO #temp VALUES(5,'Boss Ep 1',15585,'Ishq Bulava',1,'Ishq Bulava',1,'Standard')
		--INSERT INTO #temp VALUES(5,'Boss Ep 1',15585,'Ishq Bulava',2,'Ishq Bulava',1,'Standard')

		--Select  Program_Code AS ProgramCode, Program_Name AS ProgramName,Title_Code AS TitleCode, Title_Name AS TitleName, Episode_No AS EpisodeNo, Episode_Title AS EpisodeName, Version_Code AS VersionCode, Version_Name AS VersionName 
		--from #temp 

		--IF OBJECT_ID('tempdb..#temp') IS NOT NULL DROP TABLE #temp
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USPITGetAssetHierarchyData]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''	
END