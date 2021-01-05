--USP_CheckIfTitleReleaseDateExist 12743,1,1498
CREATE PROC USP_CheckIfTitleReleaseDateExist
(
	@Title_Code VARCHAR(100),
	@Holdback_Country_Code VARCHAR(100),
	@Holdback_Code VARCHAR(100)
)
AS
--@Holdback_Country_Code = '33'
--SET @Holdback_Code = 1494
--SET @Title_Code = 12743

select Count(*) from Acq_Deal_Rights_Holdback ADRH
INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT ON ADRH.Acq_Deal_Rights_Holdback_Code = ADRHT.Acq_Deal_Rights_Holdback_Code
where 
Holdback_On_Platform_Code IN 
(
	select Platform_Code from Title_Release_Platforms where Title_Release_Code in 
	(
		select Title_Release_Code from Title_Release Tr 
		where Title_code IN 
		(
			Select number from dbo.fn_Split_withdelemiter(@Title_Code,',')
		)
	)
) 
and ADRHT.Country_Code IN 
(
	SELECT DISTINCT Country_Code FROM 
	(
		SELECT Country_Code FROM Territory_details where Territory_Code IN 
		(
			SELECT Territory_Code from Title_Release_Region TRR where TRR.Title_Release_Code IN 
			(
				SELECT title_Release_Code FROM Title_Release where Title_Code IN 
				(
					Select number from dbo.fn_Split_withdelemiter(@Title_Code,',')
				)
			)
			AND ISNULL(TRR.Territory_Code,0) !=0
		)
		UNION
		SELECT Country_Code FROM Title_Release_Region TRR where TRR.Title_Release_Code IN 
		(
			SELECT title_Release_Code FROM Title_Release where Title_Code IN 
			(
				SELECT number from dbo.fn_Split_withdelemiter(@Title_Code,',')
			)
		)
	) A WHERE A.Country_Code IN (select number from dbo.fn_Split_withdelemiter(@Holdback_Country_Code,','))
) and ADRHT.Acq_Deal_Rights_Holdback_Code = @Holdback_Code