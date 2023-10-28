CREATE PROCEDURE [dbo].[USP_BMS_Get_List_Masters]
AS
-- =============================================
-- Author: Sagar Mahajan
-- Create date: 05 Nov 2015
-- Description:	Get List of All Master call from package BMS_Masters_Import
-- =============================================
BEGIN	
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Get_List_Masters]', 'Step 1', 0, 'Started Procedure', 0, ''
		SET NOCOUNT ON;
	-- ========================================================Delete Temp Table if Exist============================
		IF OBJECT_ID('TEMPDB..#Temp_Xml_Data') IS NOT NULL
		BEGIN
			DROP TABLE #Temp_Xml_Data
		END
		CREATE TABLE #Temp_Xml_Data
		(		
			Module_Name VARCHAR(100),				
			BaseAddress NVARCHAR(100),
			RequestUri NVARCHAR(100),
			Order_Id INT,
			BMS_Log_Code INT
		)
	
		INSERT INTO #Temp_Xml_Data (Module_Name,BaseAddress,RequestUri,Order_Id)
		SELECT 
			DISTINCT Module_Name,BaseAddress,RequestUri,Order_Id 
		FROM [BMS_All_Masters] (NOLOCK)  WHERE IS_Active = 'Y' AND Method_Type = 'G'  ORDER BY Order_Id
	
		-- =============================================Start BV Log Code========================
		--SELECT @moduleName AS Module_Name, Method_Type, GETDATE(), Xml_Data, 'W' AS Record_Status FROM #Temp_Xml_Data
		DECLARE @maxBvLogCode INT = 0
		SELECT @maxBvLogCode = ISNULL(MAX(BMS_Log_Code), 0) FROM BMS_Log (NOLOCK)
		INSERT INTO BMS_Log(Module_Name, Method_Type, Request_Time, Request_Xml,Record_Status)    
		SELECT 
			 Module_Name,'GET',GETDATE(),NULL,'W' AS Record_Status
		FROM #Temp_Xml_Data

		UPDATE tmp SET tmp.BMS_Log_Code = bvL.BMS_Log_Code 
		FROM  #Temp_Xml_Data tmp
		INNER JOIN BMS_Log bvL ON tmp.Module_Name = bvL.Module_Name 
		AND bvL.Record_Status = 'W' AND bvL.BMS_Log_Code > @maxBvLogCode
		--- ---
	-- =============================================Result Statment========================
		SELECT 
			 Module_Name,BaseAddress,RequestUri,Order_Id,BMS_Log_Code 
		FROM #Temp_Xml_Data    
    
		DROP TABLE #Temp_Xml_Data 
		IF OBJECT_ID('tempdb..#Temp_Xml_Data') IS NOT NULL DROP TABLE #Temp_Xml_Data

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_BMS_Get_List_Masters]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END