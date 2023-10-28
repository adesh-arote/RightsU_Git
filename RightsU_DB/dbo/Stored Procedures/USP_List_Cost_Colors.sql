CREATE PROCEDURE [dbo].[USP_List_Cost_Colors]
@Acq_Deal_Code INT
AS
--|=============================================
--| Author:		  RUSHABH GOHIL
--| Date Created: 13-Apr-2015
--| Description:  Acq Deal Cost List for Colors
--|=============================================
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Cost_Colors]', 'Step 1', 0, 'Started Procedure', 0, ''

		SET FMTONLY OFF
		SET NOCOUNT ON	
		SELECT DISTINCT ADC.Acq_Deal_Cost_Code, ADC.Deal_Cost, ADC.Remarks, ADCT.Acq_Deal_Cost_Title_Code, 
			CT.Cost_Type_Name AS Cost_Type, 
			dbo.UFN_GetTitleNameInFormat(dbo.UFN_GetDealTypeCondition(T.Deal_Type_Code), T.Title_Name, ADCT.Episode_From, ADCT.Episode_To) AS Title,
			CASE ADC.Incentive WHEN 'Y' THEN 'Yes' ELSE 'No' END AS Incentive
		INTO #Temp
		FROM Acq_Deal_Cost ADC (NOLOCK)
		INNER JOIN Acq_Deal_Cost_Title ADCT (NOLOCK) ON ADCT.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
		INNER JOIN Acq_Deal_Cost_Costtype ADCC (NOLOCK) ON ADCC.Acq_Deal_Cost_Code = ADC.Acq_Deal_Cost_Code
		INNER JOIN Title T (NOLOCK) ON T.Title_Code = ADCT.Title_Code
		INNER JOIN Cost_Type CT (NOLOCK) ON CT.Cost_Type_Code = ADCC.Cost_Type_Code
		WHERE ADC.Acq_Deal_Code = @Acq_Deal_Code
	
	
		SELECT DISTINCT p.Acq_Deal_Cost_Code,p.Deal_Cost,p.Remarks,p.Cost_Type,p.Incentive,
			STUFF((SELECT DISTINCT ',<uto> ' + p1.Title
				 FROM #Temp p1
				 WHERE p.Acq_Deal_Cost_Code = p1.Acq_Deal_Cost_Code
					FOR XML PATH(''), TYPE
					).value('.', 'NVARCHAR(MAX)')
				,1,7,'') Titles
		FROM #Temp p;
	
		--DROP TABLE #Temp
		IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Cost_Colors]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END