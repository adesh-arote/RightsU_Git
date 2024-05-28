
CREATE FUNCTION [dbo].[UFN_Get_Platform_With_Parent]
(
	@PFCodes as varchar(2000)	
)
Returns @TempPF Table(
		Platform_Code Int,
		Parent_Platform_Code Int,
		Base_Platform_Code Int,
		Is_Display Varchar(2),
		Is_Last_Level Varchar(2),
		TempCnt Int,
		TableCnt Int,
		Platform_Hiearachy NVARCHAR(1000),
		Platform_Count Int
	)
AS
-- =============================================
-- Author:		Pavitar Dua/Adesh Arote
-- Create DATE: 31-October-2014
-- Description:	INLINE TABLE VALUED FUNC TO GROUP PLATFORM
-- =============================================
BEGIN

	Declare @TempPFParent As Table(
		Parent_Platform_Code Int,
		IsUse Varchar(1)
	)

	Insert InTo @TempPF
	Select platform_code, ISNULL(Parent_Platform_Code, 0), ISNULL(base_platform_code, 0), 'Y', Is_Last_Level, 0, 0, Platform_Hiearachy, 0
	From [Platform] Where platform_code in (Select number From DBO.fn_Split_withdelemiter(IsNull(@PFCodes, ''), ',')) order by platform_name 

	Insert InTo @TempPFParent
	Select Distinct ISNULL(Parent_Platform_Code, 0), 'N' From @TempPF
	
	Insert InTo @TempPF
	Select platform_code, ISNULL(Parent_Platform_Code, 0), ISNULL(base_platform_code, 0), 'N', Is_Last_Level, 0, 0, Platform_Hiearachy, 0
	From [Platform] p 
	Where platform_code In (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent) order by platform_name 
	
	DECLARE CUR_UPDATE_GRP CURSOR
	READ_ONLY
	FOR 
	WITH ABC AS(			
			SELECT 
			(Select Count(*) From @TempPF B Where B.Parent_Platform_Code = A.Platform_Code And Is_Display = 'Y') AS TempCnt,
			(Select Count(*) From [Platform] C Where C.Parent_Platform_Code = A.Platform_Code) AS TableCnt,
			A.Platform_Code Platform_Code			
			FROM @TempPF A
	)
	SELECT DISTINCT Platform_Code,TempCnt,TableCnt FROM ABC

	DECLARE @Platform_Code_CUR INT, @TempCnt_CUR INT, @TableCnt_CUR INT
	OPEN CUR_UPDATE_GRP

	FETCH NEXT FROM CUR_UPDATE_GRP INTO @Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
	WHILE (@@fetch_status <> -1)
	BEGIN
			IF (@@fetch_status <> -2)
			BEGIN
					UPDATE @TempPF SET TempCnt=@TempCnt_CUR,TableCnt=@TableCnt_CUR
					WHERE Platform_Code=@Platform_Code_CUR
			END
			FETCH NEXT FROM CUR_UPDATE_GRP INTO @Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
	END

	CLOSE CUR_UPDATE_GRP
	DEALLOCATE CUR_UPDATE_GRP
	
	Update @TempPF Set Is_Display = 'U' Where Parent_Platform_Code In (
		Select platform_code From @TempPF Where TempCnt = TableCnt
	) 
	And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent)
	
	Update @TempPF Set Is_Display = 'Y' Where TempCnt = TableCnt And Is_Display <> 'U'--And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent)

	While((Select COUNT(*) From @TempPFParent Where ISNULL(Parent_Platform_Code, 0) > 0) > 0)
	Begin
		Update @TempPFParent Set IsUse = 'Y'
		-- select 'a'
		Insert InTo @TempPFParent
		Select Distinct ISNULL(Parent_Platform_Code, 0), 'N' From [Platform]
		Where platform_code In (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent) --order by platform_name 
		
		Delete From @TempPFParent Where IsUse = 'Y'
		
		Insert InTo @TempPF
		Select platform_code, ISNULL(Parent_Platform_Code, 0),ISNULL(base_platform_code, 0), 'N', Is_Last_Level, 0, 0, Platform_Hiearachy, 0
		From [Platform] p
		Where platform_code in (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent) And 
			  platform_code not in (Select platform_code From @TempPF) order by platform_name ;
	
	
		DECLARE CUR_UPDATE_GRP CURSOR
		READ_ONLY
		FOR 
		WITH ABC AS(			
				SELECT 
				(Select Count(*) From @TempPF B Where B.Parent_Platform_Code = A.Platform_Code And Is_Display = 'Y') AS TempCnt,
				(Select Count(*) From [Platform] C Where C.Parent_Platform_Code = A.Platform_Code) AS TableCnt,
				A.Platform_Code Platform_Code			
				FROM @TempPF A
		)
		SELECT DISTINCT Platform_Code,TempCnt,TableCnt FROM ABC
		
		OPEN CUR_UPDATE_GRP

		FETCH NEXT FROM CUR_UPDATE_GRP INTO @Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
		WHILE (@@fetch_status <> -1)
		BEGIN
				IF (@@fetch_status <> -2)
				BEGIN
						UPDATE @TempPF SET TempCnt=@TempCnt_CUR,TableCnt=@TableCnt_CUR
						WHERE Platform_Code=@Platform_Code_CUR
				END
				FETCH NEXT FROM CUR_UPDATE_GRP INTO @Platform_Code_CUR, @TempCnt_CUR, @TableCnt_CUR
		END

		CLOSE CUR_UPDATE_GRP
		DEALLOCATE CUR_UPDATE_GRP
	
		Update @TempPF Set Is_Display = 'U' Where Parent_Platform_Code In (
			Select platform_code From @TempPF Where TempCnt = TableCnt
		) And Parent_Platform_Code in (Select ISNULL(Parent_Platform_Code, 0) From @TempPFParent)
		
		Update @TempPF Set Is_Display = 'Y' Where TempCnt = TableCnt And Is_Display <> 'U'
		
	End
	 
	DELETE FROM @TempPF Where Is_Display <> 'Y'
	
	Declare @RowCnt Int = 0
	Select @RowCnt = Count(*) From @TempPF
	
	Update @TempPF Set Platform_Count = @RowCnt
	--SELECT * FROM @TempPF where Is_Display='Y'
	RETURN
END

