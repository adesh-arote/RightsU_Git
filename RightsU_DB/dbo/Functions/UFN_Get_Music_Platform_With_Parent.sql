CREATE Function [dbo].[UFN_Get_Music_Platform_With_Parent]
(
	@MPFCodes as varchar(2000)	
)
Returns @TempMPF Table(
		Music_Platform_Code Int,
		Parent_Code Int,
		Is_Display Varchar(2),
		Is_Last_Level Varchar(2),
		TempCnt Int,
		TableCnt Int,
		Platform_Hierarchy NVARCHAR(1000),
		Platform_Count Int
	)
AS
--=============================================
-- Author:	Aditya Bandivadekar
-- Create DATE: 09-JAN-2018
-- Description:	INLINE TABLE VALUED FUNC TO GROUP MUSIC_PLATFORM
-- =============================================
BEGIN
	--DECLARE @MPFCodes as varchar(2000)='2,46,47,48,6,7,8,29,'
	
	--SELECT @MPFCodes= @MPFCodes+ ',' + CAST( Music_Platform_Code as varchar)
	--FROM Music_Platform where Platform_Hierarchy like '%Sound Recording(Audio)-Edit Rights(restricted only to duration)-Non-Commercial(Synchronisation)-Right to use Lyrics%' AND IS_LAST_LEVEL='Y'
	
	--SELECT @MPFCodes
	
	--Declare @TempMPF As Table(
	--	Music_Platform_Code Int,
	--	Parent_Code Int,
	--	Is_Display Varchar(2),
	--	Is_Last_Level Varchar(2),
	--	TempCnt Int,
	--	TableCnt Int,
	--	Platform_Hierarchy Varchar(1000),
	--	Platform_Count Int
	--)

	Declare @TempMPFParent As Table(
		Parent_Code Int,
		IsUse Varchar(1)
	)

	Insert InTo @TempMPF
	Select Music_Platform_Code, ISNULL(Parent_Code, 0), 'Y', Is_Last_Level, 0, 0, Platform_Hierarchy, 0
	From [Music_Platform] Where Music_Platform_Code in (Select number From DBO.fn_Split_withdelemiter(IsNull(@MPFCodes, ''), ',')) order by Platform_Name 

	Insert InTo  @TempMPFParent
	Select Distinct ISNULL(Parent_Code, 0), 'N' From @TempMPF
	
	Insert InTo @TempMPF
	Select Music_Platform_Code, ISNULL(Parent_Code, 0), 'N', Is_Last_Level, 0, 0, Platform_Hierarchy, 0
	From [Music_Platform] MP 
	Where Music_Platform_Code In (Select ISNULL(Parent_Code, 0) From  @TempMPFParent) order by Platform_Name   
	
	
			--SELECT 
			--(Select Count(*) From @TempMPF B Where B.Parent_Platform_Code = A.Platform_Code And Is_Display = 'Y') AS TempCnt,
			--(Select Count(*) From [Platform] C Where C.Parent_Platform_Code = A.Platform_Code) AS TableCnt,
			--A.Platform_Code Platform_Code,
			--'N' IS_UPDATE			
			--INTO #ABC FROM @TempMPF A
	
	
	
	--SELECT  X.One,X.Two,X.Platform_Code	
	DECLARE CUR_UPDATE_GRP CURSOR
	READ_ONLY
	FOR 
	WITH ABC AS(			
			SELECT 
			(Select Count(*) From @TempMPF B Where B.Parent_Code = A.Music_Platform_Code And Is_Display = 'Y') AS TempCnt,
			(Select Count(*) From [Music_Platform] C Where C.Parent_Code = A.Music_Platform_Code) AS TableCnt,
			A.Music_Platform_Code Music_Platform_Code			
			FROM @TempMPF A
	)
	SELECT DISTINCT Music_Platform_Code,TempCnt,TableCnt FROM ABC

	DECLARE @Music_Platform_Code_CUR INT, @TempCnt_CUR INT, @TableCnt_CUR INT
	OPEN CUR_UPDATE_GRP

	FETCH NEXT FROM CUR_UPDATE_GRP INTO @Music_Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
	WHILE (@@fetch_status <> -1)
	BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
					UPDATE @TempMPF SET TempCnt=@TempCnt_CUR,TableCnt=@TableCnt_CUR
					WHERE Music_Platform_Code= @Music_Platform_Code_CUR
			END
			FETCH NEXT FROM CUR_UPDATE_GRP INTO @Music_Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
	END

	CLOSE CUR_UPDATE_GRP
	DEALLOCATE CUR_UPDATE_GRP
	
	--;WITH ABC AS(			
	--		SELECT 
	--		(Select Count(*) From @TempMPF B Where B.Parent_Platform_Code = A.Platform_Code And Is_Display = 'Y') AS One,
	--		(Select Count(*) From [Platform] C Where C.Parent_Platform_Code = A.Platform_Code) AS Two,
	--		A.Platform_Code Platform_Code
	--		FROM @TempMPF A
	--	) 
	--	UPDATE @TempMPF SET TempCnt = (SELECT ONE FROM ABC WHERE Platform_Code=ABC.Platform_Code),
	--	TableCnt = (SELECT Two FROM ABC WHERE Platform_Code=ABC.Platform_Code)
		
  --    	Update t Set 
		--	t.TempCnt = (Select Count(*) From @TempMPF Where Parent_Platform_Code = t.Platform_Code And Is_Display = 'Y'),
		--	t.TableCnt = (Select Count(*) From [Platform] Where Parent_Platform_Code = t.Platform_Code)
		--From @TempMPF t
	--	SELECT * FROM @TempMPF
	--return
	Update @TempMPF Set Is_Display = 'U' Where Parent_Code In (
		Select Music_Platform_Code From @TempMPF Where TempCnt = TableCnt
	) 
	And Parent_Code in (Select ISNULL(Parent_Code, 0) From  @TempMPFParent)
	
	Update @TempMPF Set Is_Display = 'Y' Where TempCnt = TableCnt And Is_Display <> 'U'--And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From  @TempMPFParent)

	While((Select COUNT(*) From  @TempMPFParent Where ISNULL(Parent_Code, 0) > 0) > 0)
	Begin
		Update  @TempMPFParent Set IsUse = 'Y'
		-- select 'a'
		Insert InTo  @TempMPFParent
		Select Distinct ISNULL(Parent_Code, 0), 'N' From [Music_Platform]
		Where Music_Platform_Code In (Select ISNULL(Parent_Code, 0) From  @TempMPFParent) --order by Platform_Name 
		
		Delete From  @TempMPFParent Where IsUse = 'Y'
		
		Insert InTo @TempMPF
		Select Music_Platform_Code, ISNULL(Parent_Code, 0), 'N', Is_Last_Level, 0, 0, Platform_Hierarchy, 0
		From [Music_Platform] p
		Where Music_Platform_Code in (Select ISNULL(Parent_Code, 0) From  @TempMPFParent) And 
			  Music_Platform_Code not in (Select Music_Platform_Code From @TempMPF) order by Platform_Name;
	
	
		DECLARE CUR_UPDATE_GRP CURSOR
		READ_ONLY
		FOR 
		WITH ABC AS(			
				SELECT 
				(Select Count(*) From @TempMPF B Where B.Parent_Code = A.Music_Platform_Code And Is_Display = 'Y') AS TempCnt,
				(Select Count(*) From [Music_Platform] C Where C.Parent_Code = A.Music_Platform_Code) AS TableCnt,
				A.Music_Platform_Code Music_Platform_Code			
				FROM @TempMPF A
		)
		SELECT DISTINCT Music_Platform_Code,TempCnt,TableCnt FROM ABC
		
		OPEN CUR_UPDATE_GRP

		FETCH NEXT FROM CUR_UPDATE_GRP INTO @Music_Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
		WHILE (@@fetch_status <> -1)
		BEGIN
				IF (@@fetch_status <> -2)
				BEGIN
						UPDATE @TempMPF SET TempCnt=@TempCnt_CUR,TableCnt=@TableCnt_CUR
						WHERE Music_Platform_Code=@Music_Platform_Code_CUR
				END
				FETCH NEXT FROM CUR_UPDATE_GRP INTO @Music_Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
		END

		CLOSE CUR_UPDATE_GRP
		DEALLOCATE CUR_UPDATE_GRP
	
		------Update t Set 
		------	t.TempCnt = (Select Count(*) From @TempMPF Where Parent_Platform_Code = t.Platform_Code And Is_Display = 'Y'),
		------	t.TableCnt = (Select Count(*) From [Platform] Where Parent_Platform_Code = t.Platform_Code)
		------From @TempMPF t
		--;WITH ABC AS(			
		--	SELECT 
		--	(Select Count(*) From @TempMPF B Where B.Parent_Platform_Code = A.Platform_Code And Is_Display = 'Y') AS One,
		--	(Select Count(*) From [Platform] C Where C.Parent_Platform_Code = A.Platform_Code) AS Two,
		--	A.Platform_Code Platform_Code			
		--	FROM @TempMPF A
		--) 
		----SELECT  X.One,X.Two,X.Platform_Code	
		--UPDATE Y
		--SET Y.TempCnt=X.One,Y.TableCnt=X.Two
		--FROM ABC X 
		--INNER JOIN @TempMPF Y ON X.Platform_Code=Y.Platform_Code
		
		
		Update @TempMPF Set Is_Display = 'U' Where Parent_Code In (
			Select Music_Platform_Code From @TempMPF Where TempCnt = TableCnt
		) And Parent_Code in (Select ISNULL(Parent_Code, 0) From  @TempMPFParent)
		
		Update @TempMPF Set Is_Display = 'Y' Where TempCnt = TableCnt And Is_Display <> 'U'
		
	End
	 
	DELETE FROM @TempMPF Where Is_Display <> 'Y'
	
	Declare @RowCnt Int = 0
	Select @RowCnt = Count(*) From @TempMPF
	
	Update @TempMPF Set Platform_Count = @RowCnt
	--SELECT * FROM @TempMPF where Is_Display='Y'
	--Select * from @TempMPF
	RETURN
	
END
/*


SELECT Platform_Hierarchy,*
FROM Platform where 1=1 AND IS_LAST_LEVEL='Y' --Platform_Hierarchy like '%non sta%'

DECLARE @MPFCodesas varchar(2000)='0'
	
SELECT @MPFCodes= @MPFCodes+ ',' + CAST( platform_Code as varchar)
FROM Platform where 1=1 AND IS_LAST_LEVEL='Y' --Platform_Hierarchy like '%non sta%'

SELECT * FROM [dbo].[UFN_Get_Music_Platform_With_Parent](@PFCodes)

EXEC [dbo].[UFN_Get_Music_Platform_With_Parent]
'2,16,17,18,19,22,23,24,25,26,27,46,47,48,'
*/

