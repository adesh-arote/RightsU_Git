CREATE FunctiON [dbo].[UFN_Get_Platform_Group]
(
	@PFCodes AS VARCHAR(2000)	
)
RETURNS @Temp TABLE(
	Platform_Type VARCHAR(2000),
	Media_Platform VARCHAR(200),
	ExploitatiON_Platform VARCHAR(2000)
)
AS
-- =============================================
-- Author:		Sachin KarANDe
-- Create DATE: 04-Feb-2019
-- DescriptiON:	Group Wise Platform SELECTiON
-- =============================================
BEGIN
	
	--DECLARE @PFCodes AS VARCHAR(2000) = '32,29,44,46,26,34,20,23,30,25,27,33,43,21'
		
	DECLARE @TempPF TABLE(
		Platform_Code INT,
		Parent_Platform_Code INT,
		Base_Platform_Code INT,
		Is_Display VARCHAR(2),
		Is_Last_Level VARCHAR(2),
		TempCnt INT,
		TableCnt INT,
		Platform_Hiearachy NVARCHAR(1000),
		Platform_Count INT
	)

	
	DECLARE @TempPF_1 TABLE(
		Platform_Name VARCHAR(500),
		Parent_Platform_Code INT,
		Attrib_Group_Name VARCHAR(100),
		Attrib_Group_Code INT
	)

	DECLARE @TempPF_2 TABLE(
		Platform_Name VARCHAR(500),
		Parent_Platform_Code INT,
		Attrib_Group_Name VARCHAR(100),
		Attrib_Group_Code INT
	)

	DECLARE @TempPF_3 TABLE(
		Platform_Code INT
	)
	
	DECLARE @TempPF_4 TABLE(
		Platform_Code INT
	)

	DECLARE @TempPF_5 TABLE(
		Platform_Code INT
	)

	DECLARE @TempPF_6 TABLE(
		Platform_Code INT
	)

	DECLARE @TempPF_7 TABLE(
		Platform_Name VARCHAR(500),
		Parent_Platform_Code INT,
		Platform_Code INT
	)

	DECLARE @TempPF_8 TABLE(
		Platform_Name VARCHAR(500),
		Platform_Code INT
	)

	DECLARE @TempOutput TABLE(
		IntCode INT IDENTITY(1 ,1),
		IntOrder INT,
		Platform_Type VARCHAR(2000),
		Media_Platform VARCHAR(200),
		ExploitatiON_Platform VARCHAR(2000)
	)

	IF(RTRIM(LTRIM(ISNULL(@PFCodes,''))) <> '')
	BEGIN

		INSERT INTO @TempPF
		SELECT * FROM DBO.UFN_Get_Platform_With_Parent(@PFCodes)

	END

	BEGIN

		INSERT INTO @TempPF_3
		SELECT Platform_Code FROM @TempPF WHERE Is_Last_Level = 'Y'

		INSERT INTO @TempPF_4
		SELECT Parent_Platform_Code FROM @TempPF WHERE Is_Last_Level = 'Y'
		UNION
		SELECT Platform_Code FROM @TempPF WHERE Is_Last_Level = 'N' 

		INSERT INTO @TempPF_7
		SELECT DISTINCT p.Platform_Name,p.Parent_Platform_Code,p.Platform_Code 
		FROM [Platform] p WITH (NOLOCK) 
		INNER JOIN @TempPF_3 p1 ON p.Platform_Code = p1.Platform_Code

		INSERT INTO @TempPF_8
		SELECT DISTINCT  p.Platform_Name, p.Platform_Code 
		FROM [Platform] p WITH (NOLOCK) 
		INNER JOIN @TempPF_4 p1 ON p.Platform_Code = p1.Platform_Code

		INSERT INTO @TempPF_5
		SELECT Parent_Platform_Code 
		FROM @TempPF tpl 
		INNER JOIN Platform_Attrib_Group pag WITH (NOLOCK) ON tpl.Platform_Code = pag.Platform_Code AND pag.Attrib_Group_Code = 3 AND tpl.Is_Last_Level = 'Y'
		UNION
		SELECT Platform_Code FROM @TempPF WHERE Is_Last_Level = 'N'

		INSERT INTO @TempPF_6
		SELECT Parent_Platform_Code 
		FROM @TempPF tpl 
		INNER JOIN Platform_Attrib_Group pag WITH (NOLOCK) ON tpl.Platform_Code = pag.Platform_Code AND pag.Attrib_Group_Code = 4 AND tpl.Is_Last_Level = 'Y'
		UNION
		SELECT Platform_Code FROM @TempPF WHERE Is_Last_Level = 'N'

	END

	BEGIN

		INSERT INTO @TempPF_1
		SELECT A.Platform_Name, A.Parent_Platform_Code,ag.Attrib_Group_Name,ag.Attrib_Group_Code 
		FROM @TempPF_7 A
		INNER JOIN Platform_Attrib_Group g  WITH (NOLOCK) ON A.Platform_Code = g.Platform_Code AND g.Attrib_Group_Code = 3 
		INNER JOIN Attrib_Group ag  WITH (NOLOCK) ON g.Attrib_Group_Code = ag.Attrib_Group_Code

		INSERT INTO @TempPF_2
		SELECT A.Platform_Name, A.Parent_Platform_Code,ag.Attrib_Group_Name,ag.Attrib_Group_Code 
		FROM @TempPF_7 A 
		INNER JOIN Platform_Attrib_Group g WITH (NOLOCK) ON A.Platform_Code = g.Platform_Code AND g.Attrib_Group_Code = 4
		INNER JOIN Attrib_Group ag WITH (NOLOCK) ON g.Attrib_Group_Code = ag.Attrib_Group_Code
	
	END

	BEGIN

		INSERT INTO @TempOutput(Platform_Type, Media_Platform, ExploitatiON_Platform)
		SELECT l.Attrib_Group_Name, l.Platform_Name,
		CASE 
			WHEN EXISTS(
				SELECT TOP 1 T.Platform_Name FROM @TempPF_1 T
				WHERE T.Parent_Platform_Code = l.Platform_Code AND T.Attrib_Group_Code = l.Attrib_Group_Code
			) 
			THEN
				STUFF((
					SELECT ', ' + T.Platform_Name FROM @TempPF_1 T
					WHERE T.Parent_Platform_Code = l.Platform_Code AND T.Attrib_Group_Code = l.Attrib_Group_Code
					ORDER BY T.Platform_Name
					FOR XML PATH('')), 1, 1, ''
				) 
			WHEN EXISTS(
				SELECT TOP 1 T1.Platform_Name FROM @TempPF_2 T1
				WHERE T1.Parent_Platform_Code = l.Platform_Code AND T1.Attrib_Group_Code = l.Attrib_Group_Code
			)
			THEN
				STUFF((
					SELECT ', ' + T1.Platform_Name FROM @TempPF_2 T1
					WHERE T1.Parent_Platform_Code = l.Platform_Code AND T1.Attrib_Group_Code = l.Attrib_Group_Code
					ORDER BY T1.Platform_Name
					FOR XML PATH('')), 1, 1, ''
				)
			ELSE '' 
		END AS [Mode_Of_ExpoitatiON]
		FROM (
			SELECT A.Platform_Name, A.Platform_Code,ag.Attrib_Group_Name,ag.Attrib_Group_Code 
			FROM @TempPF_8 A
			INNER JOIN Platform_Attrib_Group g WITH (NOLOCK) ON A.Platform_Code = g.Platform_Code AND g.Attrib_Group_Code = 3
			INNER JOIN Attrib_Group ag  WITH (NOLOCK) ON g.Attrib_Group_Code = ag.Attrib_Group_Code
			INNER JOIN @TempPF_5 t5 ON A.Platform_Code = t5.Platform_Code
			UNION ALL
			SELECT A.Platform_Name, A.Platform_Code,ag.Attrib_Group_Name,ag.Attrib_Group_Code 
			FROM @TempPF_8 A
			INNER JOIN Platform_Attrib_Group g WITH (NOLOCK) ON A.Platform_Code = g.Platform_Code AND g.Attrib_Group_Code = 4
			INNER JOIN Attrib_Group ag WITH (NOLOCK) ON g.Attrib_Group_Code = ag.Attrib_Group_Code 
			INNER JOIN @TempPF_6 t6 ON A.Platform_Code = t6.Platform_Code
		) AS l 
		ORDER BY l.Platform_Name
	
		UPDATE b SET b.IntOrder = a.GroupOrder
		FROM (
			SELECT ROW_NUMBER() OVER(PARTITION BY Platform_Type ORDER BY Media_Platform ASC) GroupOrder, IntCode
			FROM @TempOutput
		)AS a
		INNER JOIN @TempOutput b ON a.IntCode = b.IntCode
		
		INSERT INTO @Temp(Platform_Type, Media_Platform, ExploitatiON_Platform)
		SELECT Platform_Type,
		STUFF((
			SELECT '~' + CAST(T1.IntOrder AS VARCHAR) + ') '+ t1.Media_Platform FROM @TempOutput T1
			WHERE T1.Platform_Type = t2.Platform_Type
			FOR XML PATH('')), 1, 1, ''
		) AS Media_Platform,
		STUFF((
			SELECT '~' + CAST(T1.IntOrder AS VARCHAR) + ') '+ t1.ExploitatiON_Platform FROM @TempOutput T1
			WHERE T1.Platform_Type = t2.Platform_Type
			FOR XML PATH('')), 1, 1, ''
		) AS ExploitatiON_Platform
		FROM (
			SELECT DISTINCT Platform_Type FROM @TempOutput
		) AS t2
	END

	RETURN

END
