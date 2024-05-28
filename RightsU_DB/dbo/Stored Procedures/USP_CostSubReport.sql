CREATE PROCEDURE [dbo].[USP_CostSubReport]    
(    
	@Deal_Code VARCHAR(10),
	@ModuleCode varchar(10),
	@Title_Codes Varchar(100)='', 
	@IncludeExpiredDeals CHAR(1) = 'N'  
)    
AS    
BEGIN    
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_CostSubReport]', 'Step 1', 0, 'Started Procedure', 0, ''
	 -- SET NOCOUNT ON added to prevent extra result sets from    
	 -- interfering with SELECT statements.    
	 SET NOCOUNT ON;    
	 SET FMTONLY OFF;    
    
		SET @Deal_Code = ISNULL(@Deal_Code,' ')
		--print @Acq_Deal_Code
		if(@ModuleCode = 30)
		begin
		select distinct ADR.Actual_Right_Start_Date Right_Start_Date,ADR.Actual_Right_End_Date Right_End_Date,
			(Case ADR.Right_Type
			when 'Y' Then  dbo.[UFN_Get_Rights_Term](ADR.Right_Start_Date,ADR.Right_End_Date, Term) 
			When 'U' Then 'Perpetuity' 
			End) AS Term
			 from Acq_Deal_Rights ADR  (NOLOCK)
			 inner join Acq_Deal AD (NOLOCK) on Ad.Acq_Deal_Code= ADR.Acq_Deal_Code 
			 --inner join Acq_Deal_Rights ADR on Ad.Acq_Deal_Code= ADR.Acq_Deal_Code    
			 inner join Acq_Deal_Cost ADC (NOLOCK) on AD.Acq_Deal_Code = ADC.Acq_Deal_Code    
			 inner join Acq_Deal_Cost_Title ADCT (NOLOCK) on ADC.Acq_Deal_Cost_Code = ADCT.Acq_Deal_Cost_Code    
			 inner join Title T (NOLOCK) on ADCT.Title_Code = T.Title_Code   
			 inner join Acq_deal_Licensor ADL (NOLOCK) on ADC.Acq_Deal_Code = ADL.Acq_Deal_Code  
			 inner join Vendor V  (NOLOCK) on ADL.Vendor_Code = V.Vendor_Code  
			 inner join Deal_Type DT (NOLOCK) on Ad.Deal_Type_Code = DT.Deal_Type_Code    
			 INNER JOIN Acq_Deal_Rights_Title adrt (NOLOCK) ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code AND adrt.Title_Code = ADCT.Title_Code    
			 inner join Currency C (NOLOCK) on ADC.Currency_Code = C.Currency_Code    
			 inner join Acq_Deal_Cost_Costtype ADCC (NOLOCK) on ADC.Acq_Deal_Cost_Code = ADCC.Acq_Deal_Cost_Code    
			 inner join Cost_Type CT (NOLOCK) on ADCC.Cost_Type_Code = CT.Cost_Type_Code  	
			where ADR.Acq_Deal_Code = @Deal_Code AND AD.Deal_Workflow_Status NOT IN ('AR', 'WA') 
			AND (ADR.Actual_Right_Start_Date Is Not null)
			AND (@Title_Codes = '' OR ADCT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Codes,','))) 
			AND (@IncludeExpiredDeals = 'Y' OR (@IncludeExpiredDeals ='N' AND ISNULL(CONVERT(datetime,ADR.Actual_Right_End_Date,103), GETDATE()) >= GETDATE()))      
		End
		 else if(@ModuleCode=35)
		 begin
		 select distinct ADR.Actual_Right_Start_Date Right_Start_Date,ADR.Actual_Right_End_Date Right_End_Date,
			(Case ADR.Right_Type
			when 'Y' Then  dbo.[UFN_Get_Rights_Term](ADR.Right_Start_Date,ADR.Right_End_Date, Term) 
			When 'U' Then 'Perpetuity' 
			End) AS Term
		 from Syn_Deal_Rights ADR  (NOLOCK)
			inner join Syn_Deal AD (NOLOCK) on Ad.Syn_Deal_Code= ADR.Syn_Deal_Code
			inner join Syn_Deal_Revenue ADC (NOLOCK) on AD.Syn_Deal_Code = ADC.Syn_Deal_Code  
			inner join Syn_Deal_Revenue_Title ADCT (NOLOCK) on ADC.Syn_Deal_Revenue_Code = ADCT.Syn_Deal_Revenue_Code  
			inner join Title T (NOLOCK) on ADCT.Title_Code = T.Title_Code 
			inner join Deal_Type DT (NOLOCK) on Ad.Deal_Type_Code = DT.Deal_Type_Code  
			--inner join Syn_Deal_Rights ADR on Ad.Syn_Deal_Code= ADR.Syn_Deal_Code  
			INNER JOIN Syn_Deal_Rights_Title adrt (NOLOCK) ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code AND adrt.Title_Code = ADCT.Title_Code  
			inner join Currency C (NOLOCK) on ADC.Currency_Code = C.Currency_Code  
			inner join Syn_Deal_Revenue_Costtype ADCC (NOLOCK) on ADC.Syn_Deal_Revenue_Code = ADCC.Syn_Deal_Revenue_Code  
			inner join Cost_Type CT (NOLOCK) on ADCC.Cost_Type_Code = CT.Cost_Type_Code
			inner join Vendor V (NOLOCK) on AD.Vendor_Code = V.Vendor_Code  	
			where ADR.Syn_Deal_Code = @Deal_Code
			AND (ADR.Actual_Right_Start_Date Is Not null)
			AND (@Title_Codes = '' OR ADCT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Codes,',')))
			AND (@IncludeExpiredDeals = 'Y' OR (@IncludeExpiredDeals ='N' AND ISNULL(CONVERT(datetime,ADR.Actual_Right_End_Date,103), GETDATE()) >= GETDATE()))  
		 End
	  
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_CostSubReport]', 'Step 2', 0, 'Procedure Excution completed', 0, ''
END