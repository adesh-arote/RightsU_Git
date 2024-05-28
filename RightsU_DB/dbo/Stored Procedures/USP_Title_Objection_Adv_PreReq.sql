CREATE PROC [dbo].[USP_Title_Objection_Adv_PreReq]    
(      
 @Type VARCHAR(100)   
)  
AS 
BEGIN
	Declare @Loglevel  int;

	select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'

	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Title_Objection_Adv_PreReq]', 'Step 1', 0, 'Started Procedure', 0, ''   
		IF(OBJECT_ID('TEMPDB..#PreReqData') IS NOT NULL)    
		DROP TABLE #PreReqData    
      
		--DECLARE @Type VARCHAR(100) ='S' 

		CREATE TABLE #PreReqData    
		(      
			Display_Value INT,    
			Display_Text NVARCHAR(MAX),    
			Data_For VARCHAR(3)    
		)     
 
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)    
		SELECT DISTINCT Title_Objection_Status_Code, Objection_Status_Name, 'TOS' AS Data_For FROM Title_Objection_Status (NOLOCK)
		ORDER BY Objection_Status_Name      

		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)    
		SELECT DISTINCT Objection_Type_Code, Objection_Type_Name, 'TOT' AS Data_For FROM Title_Objection_Type (NOLOCK)
		ORDER BY Objection_Type_Name      
 
		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)    
		SELECT DISTINCT T.Title_Code, T.Title_Name, 'TTT' AS Data_For FROM Title T (NOLOCK)  
		INNER JOIN Title_Objection TOB (NOLOCK) ON T.Title_Code = TOB.Title_Code
		WHERE TOB.Record_Type = @Type OR @Type = '' 
		ORDER BY T.Title_Name    

		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)    
		SELECT DISTINCT V.Vendor_Code, V.Vendor_Name, 'TOV' AS Data_For FROM Vendor V (NOLOCK) 
		LEFT JOIN Acq_Deal AD (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
		INNER JOIN Title_Objection TOB (NOLOCK) ON AD.Acq_Deal_Code = TOB.Record_Code
		WHERE TOB.Record_Type = @Type OR @Type = ''
		ORDER BY V.Vendor_Name 

		INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)    
		SELECT DISTINCT V.Vendor_Code, V.Vendor_Name, 'TOV' AS Data_For FROM Vendor V (NOLOCK) 
		LEFT JOIN Syn_Deal SD (NOLOCK) ON V.Vendor_Code = SD.Vendor_Code
		INNER JOIN Title_Objection TOB (NOLOCK) ON SD.Syn_Deal_Code = TOB.Record_Code
		WHERE TOB.Record_Type = @Type OR @Type = ''
		ORDER BY V.Vendor_Name  

		SELECT Display_Value, Display_Text, Data_For FROM #PreReqData    
	 
	if(@Loglevel  < 2)Exec [USPLogSQLSteps] '[USP_Title_Objection_Adv_PreReq]', 'Step 2', 0, 'Procedure Excuting Completed', 0, ''   
END