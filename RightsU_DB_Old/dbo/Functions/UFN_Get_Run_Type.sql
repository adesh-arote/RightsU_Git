ALTER Function [dbo].[UFN_Get_Run_Type](@ACQ_Deal_Code INT, @Acq_Deal_Rights_code INT, @Title_Code varchar(100))
Returns Varchar(100)
As
Begin
	--DECLARE @ACQ_Deal_Code INT = 3136, @Acq_Deal_Rights_code INT = 3346, @Title_Code varchar(100) = ''

	DECLARE @Retrn_str varchar(100)
	set @Retrn_str = ''
		
	select @Retrn_str =
		CASE WHEN ADRun.Run_Type = 'C' THEN 'Limited'
		ELSE  CASE WHEN ADRun.Run_Type = 'U' THEN 'Unlimited' END
		END 
		from Acq_Deal AD
		INNER JOIN Acq_Deal_Rights ADRight ON AD.Acq_Deal_Code = ADRight.Acq_Deal_Code
		INNER JOIN Acq_Deal_Rights_Platform ADRightPlat ON ADRight.Acq_Deal_Rights_Code = ADRightPlat.Acq_Deal_Rights_Code
		INNER JOIN Platform P ON P.Platform_Code = ADRightPlat.Platform_Code AND p.Is_No_Of_Run = 'Y'
		INNER JOIN Acq_Deal_Rights_Title ADRightTit ON ADRight.Acq_Deal_Rights_Code = ADRightTit.Acq_Deal_Rights_Code
		INNER JOIN Acq_Deal_Run ADRun ON AD.Acq_Deal_Code = ADRun.Acq_Deal_Code AND ADRight.Acq_Deal_Code = ADRun.Acq_Deal_Code
		INNER JOIN Acq_Deal_Run_Title ADRT ON Adrt.Acq_Deal_Run_Code = ADRun.Acq_Deal_Run_Code 
		where AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND ADRun.Acq_Deal_Code = @ACQ_Deal_Code AND ADRight.Acq_Deal_Rights_Code = @Acq_Deal_Rights_code AND 
		(
			(@Title_Code <> '' AND ADRT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Code,','))) 
			OR @Title_Code = ''
		)

	IF (@Retrn_str = '')
	BEGIN
		set @Retrn_str = 'NA'
	END
	
	return @Retrn_str
End


--select Business_Unit_Code,* from ACQ_DEAL where Acq_Deal_Code not in (select  distinct Acq_Deal_Code from Acq_Deal_Run )


--select * from Acq_Deal_Movie where Acq_Deal_Code in (191)