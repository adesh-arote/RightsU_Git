CREATE PROCEDURE [dbo].[USP_IS_SAME_RIGHTS_CONTAIN_BOTH_TERRIOTORY] 
(
@territoryCode VARCHAR(MAX),
@countryCodes VARCHAR(MAX)
)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_IS_SAME_RIGHTS_CONTAIN_BOTH_TERRIOTORY]', 'Step 1', 0, 'Started Procedure', 0, ''
		--DECLARE @territoryCode VARCHAR(10), @countryCodes VARCHAR(MAX)
		--SET @territoryCode = 5
		--SET @countryCodes = '27,42,17'
	
		DECLARE @territoryGroupCodes VARCHAR(MAX)
		SET @territoryGroupCodes = ''
		SELECT @territoryGroupCodes += CAST(territory_group_code AS VARCHAR) + ',' FROM territory_group_details (NOLOCK) WHERE international_territory_code IN (SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@countryCodes,','))
		SET @territoryGroupCodes = @territoryGroupCodes + @territoryCode
		PRINT '@territoryGroupCodes : ' + @territoryGroupCodes
		CREATE TABLE #tblTerritory_Count
		(
			Deal_Code INT,
			Is_Group INT,
			Territory_Count INT
		)
	
		----- START Both territory in same right
		INSERT INTO #tblTerritory_Count
		SELECT A.deal_code, A.is_group, COUNT(A.territory_group_code) AS Territory_Count FROM 
		(
			SELECT distinct DM.deal_code, DMR.is_group, DMRT.territory_group_code
			FROM Deal_Movie_Rights_Territory DMRT (NOLOCK)
			INNER JOIN Deal_Movie_Rights DMR (NOLOCK) ON DMRT.deal_movie_rights_code = DMR.deal_movie_rights_code
			INNER JOIN Deal_Movie DM (NOLOCK) ON DM.deal_movie_code = DMR.deal_movie_code
			WHERE DMRT.territory_group_code  in (SELECT DISTINCT NUMBER FROM DBO.fn_Split_withdelemiter(@territoryGroupCodes,','))
			GROUP BY DM.deal_code, DMR.is_group, DMRT.territory_group_code
		) AS A
		GROUP BY A.deal_code, A.is_group
		ORDER BY A.deal_code, A.is_group
		----- END Both territory in same right
	
		----- START Same combination in different different right
		INSERT INTO #tblTerritory_Count
		SELECT B.deal_code, B.is_group, COUNT(B.territory_group_code) AS Territory_Count FROM 
		(
			SELECT distinct DM.deal_code, -1 as is_group, DMRT.territory_group_code
			FROM Deal_Movie_Rights DMR1 (NOLOCK)
			INNER JOIN Deal_Movie_Rights DMR2 (NOLOCK) ON DMR1.deal_movie_rights_code != DMR2.deal_movie_rights_code and DMR1.is_group != DMR2.is_group
			AND DMR1.deal_movie_code = DMR2.deal_movie_code AND DMR1.platform_code = DMR2.platform_code AND DMR1.right_start_date = DMR2.right_start_date
			AND DMR1.right_end_date = DMR2.right_end_date
			INNER JOIN Deal_Movie DM (NOLOCK) ON DM.deal_movie_code = DMR1.deal_movie_code
			INNER JOIN Deal_Movie_Rights_Territory DMRT (NOLOCK) ON DMRT.deal_movie_rights_code = DMR1.deal_movie_rights_code
			WHERE DMRT.territory_group_code  in (SELECT DISTINCT NUMBER FROM DBO.fn_Split_withdelemiter(@territoryGroupCodes,','))
			GROUP BY DM.deal_code, DMR1.is_group, DMRT.territory_group_code
		) AS B
		GROUP BY B.deal_code, B.is_group
		ORDER BY B.deal_code, B.is_group
		----- END Both territory in same right
	
		SELECT * FROM #tblTerritory_Count where Territory_Count > 1   order by Deal_Code ASC
		--DROP TABLE #tblTerritory_Count

		IF OBJECT_ID('tempdb..#tblTerritory_Count') IS NOT NULL DROP TABLE #tblTerritory_Count
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_IS_SAME_RIGHTS_CONTAIN_BOTH_TERRIOTORY]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END