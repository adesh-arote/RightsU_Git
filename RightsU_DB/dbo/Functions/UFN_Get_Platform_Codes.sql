CREATE Function [dbo].[UFN_Get_Platform_Codes]
(
	@Rights_Code Int
)
Returns NVarchar(MAX)
As
Begin

	DECLARE @PlatformCode VARCHAR(MAX) = ''
	BEGIN
		--IF EXISTS(SELECT TOP 1 Acq_Deal_Rights_Code FROM Acq_Deal_Rights With (NOLOCK) WHERE Acq_Deal_Rights_Code = @Rights_Code) --AND PA_Right_Type = 'AR')
		--BEGIN		
		--	SELECT DISTINCT @PlatformCode = @PlatformCode + CAST(Platform_Code AS VARCHAR) + ',' 
		--	FROM Syn_Deal_Rights_Ancillary With (NOLOCK)
		--	WHERE Syn_Deal_Rights_Code = @Rights_Code
		--END
		--ELSE
		BEGIN
			SELECT @PlatformCode = @PlatformCode + CAST(Platform_Code AS VARCHAR) + ',' 
		    FROM Syn_Deal_Rights_Platform With (NOLOCK)
			WHERE Syn_Deal_Rights_Code = @Rights_Code
		END 
	END
	
	--INSERT INTO @TempPF
	--Select Platform_Code,Platform_Name As PlatformName,Parent_Platform_Code,
	--Case When ISNULL(Parent_Platform_Code,0) > 0 Then (Select Platform_Name From [Platform] WITH(NOLOCK) Where Platform_Code = Parent_Platform_Code) ELSE '' END [ParentPlatformName] 
	--From [Platform] WITH (NOLOCK) Where PLATFORM_CODE in (Select number From DBO.fn_Split_withdelemiter(IsNull(@PlatformCode, ''), ',')) order by PLATFORM_NAME 

	--	SELECT  @PlatformName =  STUFF((SELECT  ',' + PlatformName
	--				FROM @TempPF 
	--				ORDER BY PlatformName
	--			FOR XML PATH('')), 1, 1, '') ,
	--			@ParentPlatformName = STUFF((SELECT  ',' + ParentPlatformName
	--				FROM @TempPF 
	--				ORDER BY ParentPlatformName
	--			FOR XML PATH('')), 1, 1, '')
	--	FROM @TempPF 
 
 Return @PlatformCode
	
End