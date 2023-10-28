CREATE PROCEDURE [dbo].[USP_Get_Content_Cost]  
(   
 @Title_Code int,  
 @Episode_No int,  
 @Cost_Type_Code varchar(500)  
)  
AS  
BEGIN  
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Content_Cost]', 'Step 1', 0, 'Started Procedure', 0, '' 

		SELECT AD.Agreement_No AS [Agreement No] , CT.Cost_Type_Name AS [Cost Type],ISNULL(CAST(SUM(ADCTE.Per_Eps_Amount) as numeric (36,3)),0) AS [Cost per Episode]  
		FROM  Acq_Deal_Cost ADC (NOLOCK)  
			INNER JOIN Acq_Deal_Cost_Title ADCT (NOLOCK) ON ADCT.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code  
			INNER JOIN Acq_Deal_Cost_Costtype ADCCT (NOLOCK) ON ADCCT.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code  
			INNER JOIN Acq_Deal_Cost_Costtype_Episode ADCTE (NOLOCK) ON ADCTE.Acq_Deal_Cost_Costtype_Code = ADCCT.Acq_Deal_Cost_Costtype_Code   
			INNER JOIN Cost_Type CT (NOLOCK) ON CT.Cost_Type_Code = ADCCT.Cost_Type_Code  
			INNER JOIN Acq_Deal AD (NOLOCK) ON AD.Acq_Deal_Code = ADC.Acq_Deal_Code  
		WHERE   AD.Deal_Workflow_Status NOT IN ('AR', 'WA')  AND ADCT.Title_Code = @Title_Code AND @Episode_No between ADCTE.Episode_From AND ADCTE.Episode_To AND   
			(ADCCT.Cost_Type_Code IN(SELECT NUMBER FROM DBO.fn_Split_withdelemiter(@Cost_Type_Code, ',') WHERE NUMBER <> '') OR @Cost_Type_Code = '')  
		GROUP BY ADCCT.Cost_Type_Code, AD.Agreement_No, CT.Cost_Type_Name 
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Content_Cost]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''  
END  
