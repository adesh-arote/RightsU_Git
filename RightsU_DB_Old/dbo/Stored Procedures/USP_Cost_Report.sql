 alter procedure [dbo].[USP_Cost_Report]      
(      
 @Agreement_No varchar(50)='',      
 @Title_Codes Varchar(100)='',       
 @Start_Date Varchar(30)='',         
 @End_Date Varchar(30)='',      
 @ModuleCode varchar(10)='',  
 @IncludeExpiredDeals CHAR(1) = 'N'  
 --30 Acq      
 --35 syn      
)      
AS      
Begin     
  
SET @Agreement_No = ISNULL(@Agreement_No,' ')  
SET @Title_Codes = ISNULL(@Title_Codes,' ')  
SET @Start_Date = ISNULL(@Start_Date,' ')  
SET @End_Date = ISNULL(@End_Date,' ')  
SET @ModuleCode = ISNULL(@ModuleCode,' ')  
SET @IncludeExpiredDeals = ISNULL(@IncludeExpiredDeals,' ')  
    
-- EXEC [USP_Cost_Report] 'S-2014-00038','','','','35','N'  
if(@ModuleCode = 30)  
begin  
  select DISTINCT AD.Agreement_No,T.Title_Name,Dt.Deal_Type_Name,ADR.Right_Start_Date,ADR.Right_End_Date,C.Currency_Name,ADCC.Amount,ADC.Additional_Cost      
  ,CT.Cost_Type_Name,Ad.Acq_Deal_Code As DealCode,T.Title_Code
  ,STUFF((SELECT distinct ',' +  CAST(v.Vendor_Name AS VARCHAR)  FROM Vendor  v  
   inner join Acq_deal_Licensor ADL on ADC.Acq_Deal_Code = ADL.Acq_Deal_Code    
     where ADL.Vendor_Code = V.Vendor_Code    
     --where dbo.[UFN_Get_Rights_Term]('','', Term) = '2 Years '    
           FOR XML PATH('')),1,1,'') As [Vendor_Name]    
  ,(Case ADR.Right_Type  
  when 'Y' Then  dbo.[UFN_Get_Rights_Term](ADR.Right_Start_Date,ADR.Right_End_Date, Term)   
  When 'U' Then 'Perpetuity'   
  --,STUFF((SELECT distinct ',' +  CAST(v.Vendor_Name AS VARCHAR)  FROM Vendor    
  --   where ADL.Vendor_Code = V.Vendor_Code    
  --   --where dbo.[UFN_Get_Rights_Term]('','', Term) = '2 Years '    
  --         FOR XML PATH('')),1,1,'') As [VendorName]    
  End) AS Term  
  from Acq_Deal AD    
  inner join Acq_Deal_Cost ADC on AD.Acq_Deal_Code = ADC.Acq_Deal_Code      
  inner join Acq_Deal_Cost_Title ADCT on ADC.Acq_Deal_Cost_Code = ADCT.Acq_Deal_Cost_Code      
  inner join Title T on ADCT.Title_Code = T.Title_Code     
  inner join Acq_deal_Licensor ADL on ADC.Acq_Deal_Code = ADL.Acq_Deal_Code    
  inner join Vendor V on ADL.Vendor_Code = V.Vendor_Code    
  inner join Deal_Type DT on Ad.Deal_Type_Code = DT.Deal_Type_Code      
  inner join Acq_Deal_Rights ADR on Ad.Acq_Deal_Code= ADR.Acq_Deal_Code      
  INNER JOIN Acq_Deal_Rights_Title adrt ON adrt.Acq_Deal_Rights_Code = adr.Acq_Deal_Rights_Code AND adrt.Title_Code = ADCT.Title_Code      
  inner join Currency C on ADC.Currency_Code = C.Currency_Code      
  inner join Acq_Deal_Cost_Costtype ADCC on ADC.Acq_Deal_Cost_Code = ADCC.Acq_Deal_Cost_Code      
  inner join Cost_Type CT on ADCC.Cost_Type_Code = CT.Cost_Type_Code      
  where        AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND 
  --AD.Agreement_No = 'A-2015-00089'    
  
  (ISNULL (CONVERT(date,ADR.Right_Start_Date,103),'')>= CONVERT(date,@Start_Date,103) OR @Start_Date = '')          
  AND (ISNULL(CONVERT(date,ADR.Right_End_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')        
  AND AD.Agreement_No like '%' + @Agreement_No + '%'      
  AND (@Title_Codes = '' OR ADCT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Codes,',')))        
  AND (@IncludeExpiredDeals = 'Y' OR (@IncludeExpiredDeals ='N' AND ISNULL(CONVERT(datetime,ADR.Right_End_Date,103), GETDATE()) >= GETDATE()))      
End  
    
  else if(@ModuleCode=35)  
  begin  
  select DISTINCT AD.Agreement_No,T.Title_Name,Dt.Deal_Type_Name,ADR.Right_Start_Date,ADR.Right_End_Date,C.Currency_Name,ADCC.Amount,ADC.Additional_Cost      
  ,CT.Cost_Type_Name ,Ad.Syn_Deal_Code As DealCode,T.Title_Code 
  , V.Vendor_Name  
  ,(Case ADR.Right_Type  
  when 'Y' Then  dbo.[UFN_Get_Rights_Term](ADR.Right_Start_Date,ADR.Right_End_Date, Term)   
  When 'U' Then 'Perpetuity'   
  --,STUFF((SELECT distinct ',' +  CAST(v.Vendor_Name AS VARCHAR)  FROM Vendor    
  --   where ADL.Vendor_Code = V.Vendor_Code    
  --   --where dbo.[UFN_Get_Rights_Term]('','', Term) = '2 Years '    
  --         FOR XML PATH('')),1,1,'') As [VendorName]    
  End) AS Term  
  from Syn_Deal AD  
  inner join Syn_Deal_Revenue ADC on AD.Syn_Deal_Code = ADC.Syn_Deal_Code    
  inner join Syn_Deal_Revenue_Title ADCT on ADC.Syn_Deal_Revenue_Code = ADCT.Syn_Deal_Revenue_Code    
  inner join Title T on ADCT.Title_Code = T.Title_Code   
  inner join Deal_Type DT on Ad.Deal_Type_Code = DT.Deal_Type_Code    
  inner join Syn_Deal_Rights ADR on Ad.Syn_Deal_Code= ADR.Syn_Deal_Code    
  INNER JOIN Syn_Deal_Rights_Title adrt ON adrt.Syn_Deal_Rights_Code = adr.Syn_Deal_Rights_Code AND adrt.Title_Code = ADCT.Title_Code    
  inner join Currency C on ADC.Currency_Code = C.Currency_Code    
  inner join Syn_Deal_Revenue_Costtype ADCC on ADC.Syn_Deal_Revenue_Code = ADCC.Syn_Deal_Revenue_Code    
  inner join Cost_Type CT on ADCC.Cost_Type_Code = CT.Cost_Type_Code  
  inner join Vendor V on AD.Vendor_Code = V.Vendor_Code   
  
  where       
  --AD.Agreement_No = 'S-2014-00038'    
    
  (ISNULL (CONVERT(date,ADR.Right_Start_Date,103),'')>= CONVERT(date,@Start_Date,103) OR @Start_Date = '')          
  AND (ISNULL(CONVERT(date,ADR.Right_End_Date,103), '') <= CONVERT(date,@End_Date,103) OR @End_Date = '')     
  AND AD.Agreement_No like '%' + @Agreement_No + '%'      
  AND (@Title_Codes = '' OR ADCT.Title_Code in (select number from fn_Split_withdelemiter(@Title_Codes,',')))        
  AND (@IncludeExpiredDeals = 'Y' OR (@IncludeExpiredDeals ='N' AND ISNULL(CONVERT(datetime,ADR.Right_End_Date,1), GETDATE()) >= GETDATE()))    
  End   
End