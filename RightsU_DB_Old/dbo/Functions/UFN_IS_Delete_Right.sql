
CREATE FUNCTION [dbo].[UFN_IS_Delete_Right]
(
	@Platform_code int, 
	@Acq_Deal_Rights_Code int, 
	@Title_Code int, 
	@Episode_From int, 
	@Episode_To int
)
RETURNS VARCHAR(5)
AS 
BEGIN

--set @Platform_code = '0'
--set @Title_Code = '0'
--set @Acq_Deal_Rights_Code = 1051
		
		DECLARE @Result VARCHAR(5),@Platform_Codes varchar(max)
		set @Result = 'Y'
		set @Platform_Codes = '0'
		
		--if(@Title_Code IS NULL OR @Title_Code = '')
		--	set @Title_Code = 0
		--if(@Platform_code = 0 OR @Platform_code IS NULL OR @Platform_code = '')
		--BEGIN
		--	SELECT @Platform_Codes = stuff(
		--				(	
		--					select  cast(P.Platform_Code  as varchar(MAX)) + ', '
		--					from Platform P
		--					inner join Acq_Deal_Rights_Platform ADRP on ADRP.Acq_Deal_Rights_Code = @Acq_Deal_Rights_Code AND p.Platform_Code = ADRp.Platform_Code
		--					where Is_No_Of_Run = 'Y'
							
		--					FOR XML PATH('')
		--				),1,0, ''
		--			)
		--END
		--ELSE
		--BEGIN	
		--	--set @Platform_Codes = CAST(@Platform_code as varchar)
		--	select @Platform_Codes = CASE WHEN COUNT(PLATFORM_code) > 0 THEN @Platform_code ELSE '0' END from Platform where Platform_Code in (@Platform_code) AND Is_No_Of_Run = 'Y' AND Is_Last_Level = 'Y'
		--END
		
		--select  @Result = case when  COUNT(ADRP.Acq_Deal_Rights_Code) > 0 THEN 'N' ELSE 'Y' END 
		--from Acq_Deal_Rights ADR 
		--inner join Acq_Deal_Rights_Title ADRTT on ADRTT.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code AND 
		--									( 
		--										(@Title_Code <> 0 and ADRTT.Title_Code in (select number from dbo.fn_Split_withdelemiter(@Title_Code,',')))
		--										OR
		--										1=1
		--									)AND ADR.Acq_Deal_Rights_Code in (@Acq_Deal_Rights_Code)
		--inner join Acq_Deal_Rights_Platform ADRP on ADRp.Acq_Deal_Rights_Code = ADRTT.Acq_Deal_Rights_Code 
		--											--AND(   ( (@Platform_code <> 0) AND ADRP.Platform_Code in (select number from dbo.fn_Split_withdelemiter(@Platform_Codes,',') ) )
		--											--		--OR
		--											--		--(@Platform_code = 0)
		--											--)
		--inner join Acq_Deal_Run ADRR on ADRR.Acq_Deal_Code = ADR.Acq_Deal_Code
		--inner join Acq_Deal_Run_Title ADRT on ADRT.Acq_Deal_Run_Code = ADRR.Acq_Deal_Run_Code 
		--											AND( 
		--												(@Title_Code <> 0 and ADRT.Title_Code in (select number from dbo.fn_Split_withdelemiter(@Title_Code,',')))
		--												--OR
		--												--(@Title_Code = 0)
													--)
		IF(@Platform_code = 0 AND @Title_Code= 0)	
		BEGIN
			select  @Result= CASE 
						WHEN COUNT(ADR.Acq_Deal_Rights_Code) > 1 THEN 'N' Else 'Y' 
					END
			 from Acq_Deal_Rights ADR 
			inner join Acq_Deal_Rights_Title ADRT on ADRT. Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code  AND ADR.Acq_Deal_Rights_Code in (@Acq_Deal_Rights_Code)
			inner join Acq_Deal_Run ADRR on ADRR.Acq_Deal_Code = ADR.Acq_Deal_Code 
			inner join Acq_Deal_Run_Title ADRTT on ADRTT.Acq_Deal_Run_Code = ADRR.Acq_Deal_Run_Code
												AND ADRTT.Title_Code = ADRT.Title_Code
		END
		ELSE IF(@Platform_code = 0 AND @Title_Code <> 0)	
		BEGIN
			select  @Result= CASE 
						WHEN COUNT(ADR.Acq_Deal_Rights_Code) > 1 THEN 'N' Else 'Y' 
					END
			 from Acq_Deal_Rights ADR 
			inner join Acq_Deal_Rights_Title ADRT on ADRT. Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code  AND ADR.Acq_Deal_Rights_Code in (@Acq_Deal_Rights_Code) AND ADRT.Title_Code in (@Title_Code)
			inner join Acq_Deal_Rights_Platform ADRP on ADRp.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
										AND ADRP.Platform_Code in (select p.Platform_Code from Platform P where Is_Last_Level  = 'Y' AND Is_No_Of_Run = 'Y'
																--AND P.Platform_Code in(@Platform_code) 
										)
			inner join Acq_Deal_Run ADRR on ADRR.Acq_Deal_Code = ADR.Acq_Deal_Code 
			inner join Acq_Deal_Run_Title ADRTT on ADRTT.Acq_Deal_Run_Code = ADRR.Acq_Deal_Run_Code  AND ADRTT.Title_Code in (@Title_Code)
		End
		ELSE IF(@Platform_code <> 0 AND @Title_Code <> 0)	
		BEGIN
			select  @Result= CASE 
						WHEN COUNT(ADR.Acq_Deal_Rights_Code) > 1 THEN 'N' Else 'Y' 
					END
			 from Acq_Deal_Rights ADR 
			inner join Acq_Deal_Rights_Title ADRT on ADRT. Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code  AND ADR.Acq_Deal_Rights_Code in (@Acq_Deal_Rights_Code) AND ADRT.Title_Code in (@Title_Code)
			inner join Acq_Deal_Rights_Platform ADRP on ADRp.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
														AND ADRP.Platform_Code in (select p.Platform_Code from Platform P where Is_Last_Level  = 'Y' AND Is_No_Of_Run='Y' AND P.Platform_Code in(@Platform_code) )
			inner join Acq_Deal_Run ADRR on ADRR.Acq_Deal_Code = ADR.Acq_Deal_Code 
			inner join Acq_Deal_Run_Title ADRTT on ADRTT.Acq_Deal_Run_Code = ADRR.Acq_Deal_Run_Code  AND ADRTT.Title_Code in (@Title_Code)
		END
		
		RETURN ISNULL(@Result, 'N')
		--select ISNULL(@Result, 'N')
END

/*
3263	2973	3
select [dbo].[UFN_IS_Delete_Right] (3,3263,2973,1,1)
*/

