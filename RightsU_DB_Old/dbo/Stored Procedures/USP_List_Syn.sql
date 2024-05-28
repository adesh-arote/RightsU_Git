
CREATE PROCEDURE [dbo].[USP_List_Syn]
(
	@StrSearch NVARCHAR(Max),
	@PageNo Int,
	@OrderByCndition Varchar(100),
	@IsPaging Varchar(2),
	@PageSize Int,
	@RecordCount Int Out,
	@User_Code INT,
	@ExactMatch varchar(max) = ''
)
AS
--|==============================================================================
--| Author:		  RUSHABH V. GOHIL
--| Date Created: 21-Aug-2015
--| Description:  Return related dependencies added or not for Syndication Deals
--|==============================================================================
BEGIN
	SET FMTONLY OFF
	
	SET @OrderByCndition = N'Last_Updated_Time DESC'
	
	if(@PageNo = 0)
		Set @PageNo = 1

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
	Create Table #Temp(
		Id Int Identity(1,1),
		RowId Varchar(200),
		currentApproverCode INT,
		agreement_no  Varchar(200),
		Vendor_Name  Varchar(200),
		Title_name  Varchar(200),
		Entity_Name  Varchar(200),
		Sort varchar(10),
		Row_Num Int,
		Last_Updated_Time datetime
	);
	Declare @SqlPageNo NVARCHAR(4000)
	
	set @SqlPageNo = N'
		WITH Y AS (
			Select distinct x.Syn_Deal_Code,x.agreement_no, currentApproverCode, X.Vendor_Name,X.Entity_Name,X.Title_Name,Last_Updated_Time  From 
			(
				select * from (
					Select distinct SD.Syn_Deal_Code
					    ,ISNULL(dbo.UFN_Get_Current_Approver_Code(35,SD.Syn_Deal_Code),0) currentApproverCode
					    ,SD.Agreement_No,SD.[version],SD.Agreement_Date
						,SD.[entity_code],SD.Deal_Type_Code
						,SD.Vendor_Code
						,SD.[attach_workflow],SD.[remarks]
						,SD.[deal_workflow_status],SD.[work_flow_code] as [work_flow_code]
						,SD.[last_updated_time]
						,SD.[is_completed],SD.[is_active]
						,SD.[status]										
						,SD.[Deal_Tag_Code],SD.[Business_Unit_Code]
					    ,V.Vendor_Name
						,E.Entity_Name
						,T.Title_Name
						FROM [Syn_Deal] SD WITH(NOLOCK)
						Inner Join Vendor V WITH(NOLOCK) On SD.Vendor_Code = V.Vendor_Code 
						LEFT Join Entity E WITH(NOLOCK) On SD.Entity_Code = E.Entity_Code
						Inner Join Syn_Deal_Movie SDM WITH(NOLOCK) On SD.Syn_Deal_Code = SDM.Syn_Deal_Code
						Inner Join Title T WITH(NOLOCK) On SDM.Title_Code = T.Title_Code
					)as XYZ Where 1 = 1  
						'+ @StrSearch + '
			 ) as X
		)
		Insert InTo #Temp Select Syn_Deal_Code,currentApproverCode,agreement_no,Vendor_Name,Title_name,Entity_Name,''1'','' '',Last_Updated_Time From Y'

	PRINT(@SqlPageNo)
	EXEC(@SqlPageNo)

	Set @ExactMatch = '%'+@ExactMatch+'%'
	Update #Temp Set Sort = '0' Where Title_name like @ExactMatch OR Vendor_Name like @ExactMatch OR [Entity_Name] like @ExactMatch OR agreement_no like @ExactMatch 
	delete from T From #Temp T Inner Join
	(
		Select ROW_NUMBER()Over(Partition By AgreeMent_No Order By Sort asc) RowNum, Id, Agreement_No, Sort From #Temp
	)a On T.Id = a.Id and a.RowNum <> 1
	Select @RecordCount = Count(distinct (agreement_no )) From #Temp
	Update a 
		Set a.Row_Num = b.Row_Num
		From #Temp a
		Inner Join (
			--Select Rank() over(order by Sort Asc, Last_Updated_Time desc, ID ASC) Row_Num, ID From #Temp
			Select dense_Rank() over(order by Sort Asc, Last_Updated_Time desc, agreement_no ASC) Row_Num, ID From #Temp
		) As b On a.Id = b.Id

	If(@IsPaging = 'Y')
	Begin	
		Delete From #Temp Where Row_Num < (((@PageNo - 1) * @PageSize) + 1) Or Row_Num > @PageNo * @PageSize 
	End	

	Declare @Sql NVARCHAR(4000)	
	Set @Sql = N'SELECT * FROM (
		SELECT distinct
		 V.Vendor_Name Vendor_Name		
		,SD.Syn_Deal_Code
		,SD.Agreement_No
		,SD.Deal_Type_Code Deal_Type_Code
		,ISNULL(dbo.UFN_Get_Current_Approver_Code(35,SD.Syn_Deal_Code),0) currentApproverCode		
		,ISNULL(dbo.UFN_Get_Count_Of_Workflow_Details(35,SD.Syn_Deal_Code),0)  WorkFlowDetailsCount		
		,dbo.UFN_Get_Syn_Territory(SD.Syn_Deal_Code) CountryDetails
		,dbo.UFN_Get_Syn_Rights_Period(SD.Syn_Deal_Code) RightPeriod
		,dbo.UFN_Get_Title(SD.Syn_Deal_Code,''S'') DealTitles
		,(SELECT DISTINCT count(ISNULL(Title_Name,Original_Title)) FROM Syn_Deal_Movie SDM  
			INNER JOIN Title Tit On Tit.title_code = SDM.Title_Code WHERE SDM.Syn_Deal_Code = SD.Syn_Deal_Code ) Cnt_DealTitles			
		, dbo.fn_IsShow_Deal_Reopen_Btn(SD.Syn_Deal_Code)  IsShowReopenBtn
		,ISNULL((SELECT COUNT(*) from Syn_Deal_Movie WITH(NOLOCK) where Syn_Deal_Code in (SD.Syn_Deal_Code)  and ISNULL(is_closed,''N'')=''Y''),0) IsCountMovieClosed
	    ,(select COUNT(*) from Syn_Deal_Movie WITH(NOLOCK) where Syn_Deal_Code  in (SD.Syn_Deal_Code)  AND ISNULL(is_closed,''N'') = ''N'') IsShowDealMovieCloseBtn	    
	    ,(SELECT COUNT(*) from Syn_Acq_Mapping WITH(NOLOCK) where Syn_Deal_Code in (SD.Syn_Deal_Code)) isShowAmmendmentBtn
	    ,(select Deal_Tag_Description from Deal_Tag WITH(NOLOCK) where Deal_Tag_Code = SD.Deal_Tag_Code) DealTagDescription
	    ,(SELECT TOP 1 DT.Deal_Type_Name FROM Deal_Type DT WITH(NOLOCK) WHERE  DT.Deal_Type_Code=SD.Deal_Type_Code ) DealTypeName
		,SD.Syn_Deal_Code IntCode
		,SD.Last_Updated_Time LastUpdatedTime
        ,ISNULL(SD.Last_Action_By,0) LastActionBy
        ,[dbo].[UFN_Get_Syn_Deal_IsComplete](SD.Syn_Deal_Code) IsCompleted	    
		,[dbo].[UFN_Check_Workflow](35,SD.Syn_Deal_Code) IsZeroWorkFlow
	    ,SD.Attach_Workflow attachWorkflow
	    ,SD.Deal_Workflow_Status dealWorkFlowStatus
	    ,SD.Agreement_No DealNo
	    ,SD.Agreement_Date DealSignedDate	    
		,(Select COUNT(AT_Syn_Deal_Code) from AT_Syn_Deal AT WITH(NOLOCK) WHERE AT.Syn_Deal_Code =  SD.Syn_Deal_Code) parentDealCode
		,SD.Deal_Description DealDesc		
		,'''' IsTerminate
		,dbo.UFN_Is_Deal_Tentative(SD.Syn_Deal_Code,35) IsTentative
		,'''' IsDealContinue
		,CASE WHEN CAST(SD.version AS float) < 10 THEN ''0'' + CAST(CAST(SD.version AS float) AS VARCHAR) Else CAST(CAST(SD.version AS float) AS VARCHAR)END AS version
		,(SELECT Max(Version) FROM AT_Syn_Deal WITH(NOLOCK) WHERE Syn_Deal_Code = SD.Syn_Deal_Code) [Previous Version]
		,ISNULL(SD.Work_Flow_Code,0) as work_flow_code
		,ISNULL(SD.Work_Flow_Code,0) as workflowcode
		,SD.Deal_Tag_Code DealTagCode
		,SD.Is_Active isActive		
		,CASE WHEN SD.Currency_Code IS NULL THEN 0 ELSE SD.Currency_Code END AS currencyCode
		,SD.Inserted_On insertedOn
		,SD.Inserted_By insertedBy		
		,SD.Category_Code categoryCode
		,SD.Vendor_Code customerCode
		,ISNULL(SD.Entity_Code,0) EntityCode
		,SD.Year_Type YearType
		,SD.Ref_No refNo
		,cast(SD.Exchange_Rate as varchar) exchangeRate
		,SD.Payment_Terms_Conditions PaymentTermsNConditions
		,SD.Status
		,(Select Top 1 Action From Deal_Process dp WITH(NOLOCK) Where dp.Deal_Code = SD.Syn_Deal_Code AND DP.Record_Status <> ''D'') AT_Status
		,SD.Deal_Type_Code DealFor
		,SD.Remarks
		,SD.Business_Unit_Code
		,(select Business_Unit_Name from Business_Unit WITH(NOLOCK) where Business_Unit_Code = SD.Business_Unit_Code) Business_Unit_Name
		,SD.Deal_Complete_Flag
		,SD.Last_Updated_Time
		,dbo.[UFN_Get_Syn_Deal_Workflow_Status](SD.Syn_Deal_Code, Deal_Workflow_Status, '+ CAST(@User_Code AS VARCHAR(50)) +') Final_Deal_Workflow_Status
		,dbo.[UFN_Syn_DEAL_SET_BUTTON_VISIBILITY](SD.Syn_Deal_Code, SD.version, '+ CAST(@User_Code AS VARCHAR(50)) +', SD.Deal_Workflow_Status) Show_Hide_Buttons
		,T.Row_Num  
		FROM Syn_Deal SD WITH(NOLOCK)
		INNER JOIN Vendor v WITH(NOLOCK) on SD.Vendor_Code = v.vendor_code	
		INNER JOIN #Temp T on SD.Syn_Deal_Code = T.RowId
    ) tbl 
	 ORDER BY tbl.Row_Num'

    --WHERE tbl.Syn_Deal_Code in (Select RowId From #Temp) ORDER BY  + @OrderByCndition

	PRINT @Sql
	Exec(@Sql)
	Drop Table #Temp
	
	--select '' Vendor_Name,1 Syn_Deal_Code, '' Agreement_No, 1 Deal_Type_Code, 1 currentApproverCode, ISNULL(1,0) WorkFlowDetailsCount, 
	--	'' CountryDetails, '' RightPeriod, '' DealTitles, '' IsShowReopenBtn, 1 IsCountMovieClosed, 1 IsShowDealMovieCloseBtn,
	--	1 isShowAmmendmentBtn, '' DealTagDescription, '' DealTypeName, 1 IntCode, GETDATE() LastUpdatedTime, 1 LastActionBy, 
	--	'' IsCompleted, '' IsZeroWorkFlow, '' attachWorkflow, '' dealWorkFlowStatus, '' DealNo, GETDATE() DealSignedDate, 1 parentDealCode, 
	--	'' DealDesc, '' IsTerminate, '' IsTentative, '' IsDealContinue, '' version, 1 workflowcode, 1 DealTagCode, '' isActive, 
	--	1 currencyCode, GETDATE() insertedOn, 1 insertedBy, 1 categoryCode, 1 customerCode, 1 EntityCode, '' YearType, '' refNo, 
	--	'' exchangeRate, '' PaymentTermsNConditions, '' Status, 1 DealFor, '' Remarks, 1 Business_Unit_Code, '' Deal_Complete_Flag, 
	--	'' Final_Deal_Workflow_Status, '' Show_Hide_Buttons
End


/*
EXEC  USP_List_Syn '',1,'1','Y',10,10
EXEC  USP_List_Syn '',1,'1','Y',10,10,143

select dbo.UFN_Get_Count_Of_Workflow_Details(35,3)
*/