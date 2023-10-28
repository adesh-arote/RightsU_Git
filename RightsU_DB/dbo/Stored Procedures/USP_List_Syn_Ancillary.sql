CREATE PROCEDURE [dbo].[USP_List_Syn_Ancillary]
	@Syn_Deal_Code INT
AS
---- =============================================
---- Author:		Rahul Kembhavi
---- Create DATE: 12-April-2022
---- Description:	SynDeal ANCIL List
---- Last Updated By : Rahul Kembhavi
---- Updated On:  12-April-2022
---- =============================================
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Syn_Ancillary]', 'Step 1', 0, 'Started Procedure', 0, ''
		IF(OBJECT_ID('TEMPDB..#Temp_Medium') IS NOT NULL)    
			DROP TABLE #Temp_Medium  
		IF(OBJECT_ID('TEMPDB..#Temp_Medium_Adv') IS NOT NULL)    
			DROP TABLE #Temp_Medium_Adv 

		--DECLARE @Syn_Deal_Code INT = 25032

		DECLARE @System_Parameter_New CHAR(1) = 'N'
		SELECT @System_Parameter_New = Parameter_Value FROM System_Parameter_New where Parameter_Name = 'Is_Ancillary_Advanced' 

		DECLARE @Deal_Type VARCHAR(30) = '' 
		SELECT @Deal_Type =dbo.UFN_GetDealTypeCondition(AD.Deal_Type_Code) 
		FROM Syn_Deal AD (NOLOCK) WHERE AD.Syn_Deal_Code = @Syn_Deal_Code

		IF(@System_Parameter_New <> 'N')
		BEGIN

			Select ADAP.Syn_Deal_Ancillary_Code , ADAP.Ancillary_Platform_code --, AM.Ancillary_Medium_Name
			INTO #Temp_Medium_Adv
			from Syn_Deal_Ancillary ADA (NOLOCK)
			LEFT Join Syn_Deal_Ancillary_Platform ADAP (NOLOCK) On ADAP.Syn_Deal_Ancillary_Code = ADA.Syn_Deal_Ancillary_Code
			WHERE ADA.Syn_Deal_Code = @Syn_Deal_Code  and ADAP.Ancillary_Platform_Code IS NULL

			SELECT DISTINCT ADA.Syn_Deal_Ancillary_Code
			, dbo.UFN_GetTitleName_Syn(ADA.Syn_Deal_Ancillary_Code,'',@Deal_Type) as TitleName
			, AT.Ancillary_Type_Code,AT.Ancillary_Type_Name
			, ISNULL(CAST(ADA.Duration AS INT),0) AS Duration,ISNULL(CAST(ADA.Day AS INT), 0) AS ADay,ADA.Remarks
			, ISNULL((Stuff ((
				Select Distinct ', '+ ISNULL(P.Platform_Name,'') from  #Temp_Medium_Adv TV 
				INNER JOIN [PLATFORM] P (NOLOCK) ON P.Platform_Code = TV.Ancillary_Platform_code
				WHERE TV.Syn_Deal_Ancillary_Code = ADA.Syn_Deal_Ancillary_Code 
				FOR XML PATH('')) , 1, 1, '')
			),'NA') as Platform_Name
			, '' as Ancillary_Medium_Name
			FROM Syn_Deal_Ancillary ADA  (NOLOCK)	
			INNER JOIN Ancillary_Type AT (NOLOCK) ON ADA.Ancillary_Type_code = AT.Ancillary_Type_code	
			LEFT JOIN Syn_Deal_Ancillary_Platform ADAP (NOLOCK) ON ADAP.Syn_Deal_Ancillary_Code=ADA.Syn_Deal_Ancillary_Code
			--Inner Join Ancillary_Platform AP ON ADAP.Ancillary_Platform_code= AP.Ancillary_Platform_code AND AT.Ancillary_Type_Code = ADA.Ancillary_Type_code
			WHERE ADA.Syn_Deal_Code = @Syn_Deal_Code and ADAP.Ancillary_Platform_Code IS NULL

		END
		ELSE
		BEGIN

			Select ADAP.Syn_Deal_Ancillary_Platform_Code, AM.Ancillary_Medium_Name
			INTO #Temp_Medium
			from Syn_Deal_Ancillary ADA (NOLOCK)
			Inner Join Syn_Deal_Ancillary_Platform ADAP (NOLOCK) On ADAP.Syn_Deal_Ancillary_Code = ADA.Syn_Deal_Ancillary_Code
			Inner Join Syn_Deal_Ancillary_Platform_Medium ADAPM (NOLOCK) ON ADAPM.Syn_Deal_Ancillary_Platform_Code = ADAP.Syn_Deal_Ancillary_Platform_Code
			Inner join Ancillary_Platform_Medium APM (NOLOCK) ON ADAPM.Ancillary_Platform_Medium_Code = APM.Ancillary_Platform_Medium_Code
			INNER JOIN Ancillary_Medium AM  (NOLOCK) ON APM.Ancillary_Medium_Code = AM.Ancillary_Medium_Code 
			WHERE ADA.Syn_Deal_Code = @Syn_Deal_Code

			SELECT DISTINCT ADA.Syn_Deal_Ancillary_Code
			, dbo.UFN_GetTitleName_Syn(ADA.Syn_Deal_Ancillary_Code,'',@Deal_Type) as TitleName
			, AT.Ancillary_Type_Code,AT.Ancillary_Type_Name
			, ADA.Duration,ADA.Day AS ADay,ADA.Remarks,AP.Platform_Name
			, (Stuff ((
				Select Distinct ', '+ ISNULL(TM.Ancillary_Medium_Name,'') from  #Temp_Medium TM 
				WHERE TM.Syn_Deal_Ancillary_Platform_Code = ADAP.Syn_Deal_Ancillary_Platform_Code               
				FOR XML PATH('')) , 1, 1, '')
			) as Ancillary_Medium_Name
			FROM Syn_Deal_Ancillary ADA  (NOLOCK)	
			INNER JOIN Ancillary_Type AT (NOLOCK) ON ADA.Ancillary_Type_code = AT.Ancillary_Type_code	
			INNER JOIN Syn_Deal_Ancillary_Platform ADAP  (NOLOCK) ON ADAP.Syn_Deal_Ancillary_Code=ADA.Syn_Deal_Ancillary_Code
			Inner Join Ancillary_Platform AP (NOLOCK) ON ADAP.Ancillary_Platform_code= AP.Ancillary_Platform_code AND AT.Ancillary_Type_Code = ADA.Ancillary_Type_code
			WHERE ADA.Syn_Deal_Code = @Syn_Deal_Code

		END

		IF OBJECT_ID('tempdb..#Temp_Medium') IS NOT NULL DROP TABLE #Temp_Medium
		IF OBJECT_ID('tempdb..#Temp_Medium_Adv') IS NOT NULL DROP TABLE #Temp_Medium_Adv
 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_List_Syn_Ancillary]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END