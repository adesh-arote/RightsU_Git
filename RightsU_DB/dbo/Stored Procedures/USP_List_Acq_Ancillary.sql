CREATE PROCEDURE [dbo].[USP_List_Acq_Ancillary]
	@Acq_Deal_Code INT
AS
-- =============================================
-- Author:		Sagar Mahajan / Abhaysingh N. Rajpurohit
-- Create DATE: 08-October-2014
-- Description:	AcqDeal ANCIL List
-- Last Updated By : Akshay Rane
-- Updated On:  02-Mar-2018
-- =============================================
BEGIN

	IF(OBJECT_ID('TEMPDB..#Temp_Medium') IS NOT NULL)    
		DROP TABLE #Temp_Medium  
	IF(OBJECT_ID('TEMPDB..#Temp_Medium_Adv') IS NOT NULL)    
		DROP TABLE #Temp_Medium_Adv 

	--DECLARE @Acq_Deal_Code INT = 25032
	DECLARE @System_Parameter_New CHAR(1) = 'N'
	SELECT @System_Parameter_New = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_Ancillary_Advanced' 

	DECLARE @Deal_Type VARCHAR(30) = '' 
	SELECT @Deal_Type =dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code) 
	FROM Acq_Deal AD WHERE AD.Acq_Deal_Code = @Acq_Deal_Code

	IF(@System_Parameter_New <> 'N')
	BEGIN

		Select ADAP.Acq_Deal_Ancillary_Platform_Code--, AM.Ancillary_Medium_Name
		INTO #Temp_Medium_Adv
		from Acq_Deal_Ancillary ADA
		Inner Join Acq_Deal_Ancillary_Platform ADAP On ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
		--Inner Join Acq_Deal_Ancillary_Platform_Medium ADAPM ON ADAPM.Acq_Deal_Ancillary_Platform_Code = ADAP.Acq_Deal_Ancillary_Platform_Code
		--Inner join Ancillary_Platform_Medium APM ON ADAPM.Ancillary_Platform_Medium_Code = APM.Ancillary_Platform_Medium_Code
		--INNER JOIN Ancillary_Medium AM ON APM.Ancillary_Medium_Code = AM.Ancillary_Medium_Code 
		WHERE ADA.Acq_Deal_Code = @Acq_Deal_Code

		
		SELECT DISTINCT ADA.Acq_Deal_Ancillary_Code
		, dbo.UFN_GetTitleName(ADA.Acq_Deal_Ancillary_Code,'',@Deal_Type) as TitleName
		, AT.Ancillary_Type_Code,AT.Ancillary_Type_Name
		, ADA.Duration,ADA.Day,ADA.Remarks
		, '' AS Platform_Name
		, '' as Ancillary_Medium_Name
		FROM Acq_Deal_Ancillary ADA 	
		INNER JOIN Ancillary_Type AT ON ADA.Ancillary_Type_code = AT.Ancillary_Type_code	
		INNER JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Acq_Deal_Ancillary_Code=ADA.Acq_Deal_Ancillary_Code
		--Inner Join Ancillary_Platform AP ON ADAP.Ancillary_Platform_code= AP.Ancillary_Platform_code AND AT.Ancillary_Type_Code = ADA.Ancillary_Type_code
		WHERE ADA.Acq_Deal_Code = @Acq_Deal_Code and ADAP.Ancillary_Platform_Code IS NULL

	END
	ELSE
	BEGIN

		Select ADAP.Acq_Deal_Ancillary_Platform_Code, AM.Ancillary_Medium_Name
		INTO #Temp_Medium
		from Acq_Deal_Ancillary ADA
		Inner Join Acq_Deal_Ancillary_Platform ADAP On ADAP.Acq_Deal_Ancillary_Code = ADA.Acq_Deal_Ancillary_Code
		Inner Join Acq_Deal_Ancillary_Platform_Medium ADAPM ON ADAPM.Acq_Deal_Ancillary_Platform_Code = ADAP.Acq_Deal_Ancillary_Platform_Code
		Inner join Ancillary_Platform_Medium APM ON ADAPM.Ancillary_Platform_Medium_Code = APM.Ancillary_Platform_Medium_Code
		INNER JOIN Ancillary_Medium AM ON APM.Ancillary_Medium_Code = AM.Ancillary_Medium_Code 
		WHERE ADA.Acq_Deal_Code = @Acq_Deal_Code

		SELECT DISTINCT ADA.Acq_Deal_Ancillary_Code
		, dbo.UFN_GetTitleName(ADA.Acq_Deal_Ancillary_Code,'',@Deal_Type) as TitleName
		, AT.Ancillary_Type_Code,AT.Ancillary_Type_Name
		, ADA.Duration,ADA.Day,ADA.Remarks,AP.Platform_Name
		, (Stuff ((
			Select Distinct ', '+ ISNULL(TM.Ancillary_Medium_Name,'') from  #Temp_Medium TM 
			WHERE TM.Acq_Deal_Ancillary_Platform_Code = ADAP.Acq_Deal_Ancillary_Platform_Code               
			FOR XML PATH('')) , 1, 1, '')
		) as Ancillary_Medium_Name
		FROM Acq_Deal_Ancillary ADA 	
		INNER JOIN Ancillary_Type AT ON ADA.Ancillary_Type_code = AT.Ancillary_Type_code	
		INNER JOIN Acq_Deal_Ancillary_Platform ADAP ON ADAP.Acq_Deal_Ancillary_Code=ADA.Acq_Deal_Ancillary_Code
		Inner Join Ancillary_Platform AP ON ADAP.Ancillary_Platform_code= AP.Ancillary_Platform_code AND AT.Ancillary_Type_Code = ADA.Ancillary_Type_code
		WHERE ADA.Acq_Deal_Code = @Acq_Deal_Code

	END
END
