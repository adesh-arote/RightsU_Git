CREATE PROC [dbo].[USP_CheckIfTitleReleaseDateExist]
(
	@Title_Code VARCHAR(100),
	@Holdback_Country_Code VARCHAR(100),
	@Holdback_Code VARCHAR(100)
)
AS
BEGIN 
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_CheckIfTitleReleaseDateExist]', 'Step 1', 0, 'Started Procedure', 0, '' 
	--@Holdback_Country_Code = '33'
	--SET @Holdback_Code = 1494
	--SET @Title_Code = 12743

	select Count(*) from Acq_Deal_Rights_Holdback ADRH (NOLOCK)
	INNER JOIN Acq_Deal_Rights_Holdback_Territory ADRHT (NOLOCK) ON ADRH.Acq_Deal_Rights_Holdback_Code = ADRHT.Acq_Deal_Rights_Holdback_Code
	where 
	Holdback_On_Platform_Code IN 
	(
		select Platform_Code from Title_Release_Platforms (NOLOCK) where Title_Release_Code in 
		(
			select Title_Release_Code from Title_Release Tr (NOLOCK)
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
			SELECT Country_Code FROM Territory_details (NOLOCK) where Territory_Code IN 
			(
				SELECT Territory_Code from Title_Release_Region TRR (NOLOCK) where TRR.Title_Release_Code IN 
				(
					SELECT title_Release_Code FROM Title_Release (NOLOCK) where Title_Code IN 
					(
						Select number from dbo.fn_Split_withdelemiter(@Title_Code,',')
					)
				)
				AND ISNULL(TRR.Territory_Code,0) !=0
			)
			UNION
			SELECT Country_Code FROM Title_Release_Region TRR where TRR.Title_Release_Code IN 
			(
				SELECT title_Release_Code FROM Title_Release (NOLOCK) where Title_Code IN 
				(
					SELECT number from dbo.fn_Split_withdelemiter(@Title_Code,',')
				)
			)
		) A WHERE A.Country_Code IN (select number from dbo.fn_Split_withdelemiter(@Holdback_Country_Code,','))
	) and ADRHT.Acq_Deal_Rights_Holdback_Code = @Holdback_Code

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_CheckIfTitleReleaseDateExist]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
End
