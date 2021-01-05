CREATE Procedure USP_Ancillary_Validate
	@Acq_Deal_Code INT,@Acq_Deal_Ancillary_Code INT,@Ancillary_Type_code INT,@Title_Code Varchar(5000),
	@Ancillary_Platform_Code Varchar(5000),@Ancillary_Platform_Medium_Code varchar(5000)
AS
BEGIN		
	
	Select ISNULL(ADA.Acq_Deal_Ancillary_Code,0) as Acq_Deal_Ancillary_Code from Acq_Deal AD
	Inner Join Acq_Deal_Ancillary ADA ON AD.Acq_Deal_Code=ADA.Acq_Deal_Code AND ADA.Ancillary_Type_code = @Ancillary_Type_code
	Inner Join Acq_Deal_Ancillary_Title	ADAT ON ADA.Acq_Deal_Ancillary_Code=ADAT.Acq_Deal_Ancillary_Code 
	AND ADAT.Title_Code IN(Select number from dbo.fn_Split_withdelemiter(@Title_Code,','))
	Inner Join Acq_Deal_Ancillary_Platform ADAP ON ADA.Acq_Deal_Ancillary_Code=ADAP.Acq_Deal_Ancillary_Code 
	AND ADAP.Ancillary_Platform_code IN(Select number from dbo.fn_Split_withdelemiter(@Ancillary_Platform_Code,','))
	Left Join Acq_Deal_Ancillary_Platform_Medium ADAPM ON  ADAP.Acq_Deal_Ancillary_Platform_Code=ADAPM.Acq_Deal_Ancillary_Platform_Code
	AND ADAPM.Ancillary_Platform_Medium_Code IN(Select number from dbo.fn_Split_withdelemiter(@Ancillary_Platform_Medium_Code,','))
	Where AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND AD.Acq_Deal_Code=@Acq_Deal_Code AND ADA.Acq_Deal_Ancillary_Code <> @Acq_Deal_Ancillary_Code
	
END