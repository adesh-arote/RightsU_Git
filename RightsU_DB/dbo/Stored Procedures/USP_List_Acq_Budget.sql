CREATE PROCEDURE [dbo].[USP_List_Acq_Budget]  
@Acq_Deal_Code INT,  
@Title_Code VARCHAR(MAX)  
AS  
-- =============================================  
-- Author:  Rajesh Godse  						
-- Create DATE: 21-May-2015  					
-- Description: Acquisition deal budget list  	
-- =============================================  
BEGIN  
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_List_Acq_Budget]', 'Step 1', 0, 'Started Procedure', 0, ''
	DECLARE @Selected_Deal_Type_Code INT ,@Deal_Type_Condition VARCHAR(MAX) = ''  
	 SELECT TOP 1 @Selected_Deal_Type_Code = Deal_Type_Code FROM Acq_Deal (NOLOCK) WHERE Acq_Deal_Code = @ACQ_DEAL_CODE  
	 SELECT @Deal_Type_Condition = dbo.UFN_GetDealTypeCondition(@Selected_Deal_Type_Code)  
  
	 Select ADB.Acq_Deal_Budget_Code,  
	 DBO.UFN_GetTitleNameInFormat(@Deal_Type_Condition, T.Title_Name, ADB.Episode_From, ADB.Episode_To) AS Title_Name  
	 ,SW.WBS_Code,SW.WBS_Description,sw.Studio_Vendor,sw.Original_Dubbed,ADB.Title_Code,ADB.Episode_From,ADB.Episode_To  

	 from Acq_Deal_Budget ADB  (NOLOCK) 
	 INNER JOIN Title T (NOLOCK) ON ADB.Title_Code = T.Title_Code  
	 INNER JOIN SAP_WBS SW (NOLOCK) ON ADB.SAP_WBS_Code = sw.SAP_WBS_Code  
	 INNER JOIN Acq_Deal_Movie ADM (NOLOCK) ON ADB.Acq_Deal_Code = ADM.Acq_Deal_Code AND ADM.Title_Code = ADB.Title_Code AND ADM.Episode_Starts_From = ADB.Episode_From AND ADB.Episode_To = ADM.Episode_End_To  
	 WHERE ADB.Acq_Deal_Code = @Acq_Deal_Code  
	 --AND((ADB.Title_Code in (select number from fn_Split_withdelemiter(@Title_Code,',')) AND @Title_Code <> '0') OR @Title_Code = '0')  
	 AND ((((ADB.TITLE_CODE IN (SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@Title_Code,',')) AND @Title_Code <> '0')OR @Title_Code = '0')  AND @Deal_Type_Condition != 'DEAL_PROGRAM') OR  
	   (((ADM.Acq_Deal_Movie_Code IN  (SELECT NUMBER FROM DBO.FN_SPLIT_WITHDELEMITER(@Title_Code,',')) AND @Title_Code <> '0')OR @Title_Code = '0') AND @Deal_Type_Condition = 'DEAL_PROGRAM'))  
   
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_List_Acq_Budget]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
