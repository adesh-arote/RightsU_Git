CREATE PROC [dbo].[USP_Title_Objection_Adv_PreReq]    
(      
 @Type VARCHAR(100)   
)  
AS 
BEGIN
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
	SELECT DISTINCT Title_Objection_Status_Code, Objection_Status_Name, 'TOS' AS Data_For FROM Title_Objection_Status 
	ORDER BY Objection_Status_Name      

	INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)    
	SELECT DISTINCT Objection_Type_Code, Objection_Type_Name, 'TOT' AS Data_For FROM Title_Objection_Type   
	ORDER BY Objection_Type_Name      
 
	INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)    
	SELECT DISTINCT T.Title_Code, T.Title_Name, 'TTT' AS Data_For FROM Title T     
	INNER JOIN Title_Objection TOB ON T.Title_Code = TOB.Title_Code
	WHERE TOB.Record_Type = @Type OR @Type = '' 
	ORDER BY T.Title_Name    

	INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)    
	SELECT DISTINCT V.Vendor_Code, V.Vendor_Name, 'TOV' AS Data_For FROM Vendor V
	LEFT JOIN Acq_Deal AD ON V.Vendor_Code = AD.Vendor_Code
	INNER JOIN Title_Objection TOB ON AD.Acq_Deal_Code = TOB.Record_Code
	WHERE TOB.Record_Type = @Type OR @Type = ''
	ORDER BY V.Vendor_Name 

	INSERT INTO #PreReqData(Display_Value, Display_Text, Data_For)    
	SELECT DISTINCT V.Vendor_Code, V.Vendor_Name, 'TOV' AS Data_For FROM Vendor V
	LEFT JOIN Syn_Deal SD ON V.Vendor_Code = SD.Vendor_Code
	INNER JOIN Title_Objection TOB ON SD.Syn_Deal_Code = TOB.Record_Code
	WHERE TOB.Record_Type = @Type OR @Type = ''
	ORDER BY V.Vendor_Name  

	SELECT Display_Value, Display_Text, Data_For FROM #PreReqData    
END