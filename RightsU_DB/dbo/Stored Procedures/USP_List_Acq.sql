

--EXEC USP_List_Acq 'AND Business_Unit_Code =1',1,'Acq_Deal_Code desc','Y',50,0,143,''

CREATE PROCEDURE [dbo].[USP_List_Acq]
(
--DECLARE
	@StrSearch NVARCHAR(Max)='AND Is_Master_Deal =''Y'' and deal_workflow_status = ''A'' AND deal_Type_Code = ''1'' And Business_Unit_Code In (1) AND is_active=''Y''',
	@PageNo Int=1,
	@OrderByCndition Varchar(100)='Acq_Deal_Code desc',
	@IsPaging Varchar(2)='Y',
	@PageSize Int=50,
	@RecordCount Int Out,
	@User_Code INT=143,
	@ExactMatch varchar(max) = ''
)
As
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 08-October-2014
-- Description:	AcqDeal List
-- Updated by : Vipul Surve
-- Date : 03 Mar 2017
-- Reason: Added one column which will Business Unit Name
-- =============================================
Begin


	--Set FMTONLY Off
	SET @OrderByCndition = N'Last_Updated_Time DESC'
	--DECLARE
	--@StrSearch Varchar(Max),
	--@PageNo Int,
	--@OrderByCndition Varchar(100),
	--@IsPaging Varchar(2),
	--@PageSize Int

	--SELECT
	--@StrSearch = '',
	--@PageNo = 1,
	--@OrderByCndition = 'Agreement_No',
	--@IsPaging = 'N',
	--@PageSize = 10

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

	Declare @SqlPageNo NVARCHAR(MAX)
	
	set @SqlPageNo = N'
			WITH Y AS (
						Select distinct x.Acq_Deal_Code,x.agreement_no, currentApproverCode, X.Vendor_Name,X.Entity_Name,X.Title_Name,Last_Updated_Time  From 
						(
							select * from (
								Select distinct AD.Acq_Deal_Code
									,ISNULL(dbo.UFN_Get_Current_Approver_Code(30,AD.Acq_Deal_Code),0) currentApproverCode
									,AD.Agreement_No,AD.[version],AD.Agreement_Date,AD.Is_Master_Deal
									,AD.[year_type],AD.[entity_code],AD.Deal_Type_Code
									,AD.Vendor_Code
									,AD.[attach_workflow]
									,AD.[deal_workflow_status],AD.[parent_deal_code],AD.[work_flow_code] as [work_flow_code]
									,AD.[last_updated_time]										
									,AD.[is_completed],AD.[is_active]
									,AD.[status]										
									,AD.Master_Deal_Movie_Code_ToLink
									,AD.[Deal_Tag_Code],AD.[Business_Unit_Code]
									,V.Vendor_Name
									,E.Entity_Name
									,T.Title_Name
									FROM [Acq_Deal] AD WITH(NOLOCK)
									Inner Join Vendor V WITH(NOLOCK) On AD.Vendor_Code = V.Vendor_Code 
									Inner Join Entity E WITH(NOLOCK) On AD.Entity_Code = E.Entity_Code
									Inner Join Acq_Deal_Movie ADM WITH(NOLOCK) On AD.Acq_Deal_Code = ADM.Acq_Deal_Code
									Inner Join Title T WITH(NOLOCK) On ADM.Title_Code = T.Title_Code
								)as XYZ Where 1=1 
								'+ @StrSearch + '
							)as X
						)
	Insert InTo #Temp Select Acq_Deal_Code,currentApproverCode,agreement_no,Vendor_Name,Title_name,Entity_Name,''1'','' '',Last_Updated_Time From Y'
	PRINT(@SqlPageNo)
	EXEC (@SqlPageNo)
	--select * from #Temp
	
	PRINT '1'
	Set @ExactMatch = '%'+@ExactMatch+'%'
	Update #Temp Set Sort = '0' Where Title_name like @ExactMatch OR Vendor_Name like @ExactMatch OR [Entity_Name] like @ExactMatch OR agreement_no like @ExactMatch 

	PRINT '2'
	delete from T From #Temp T Inner Join
	(
		Select ROW_NUMBER()Over(Partition By AgreeMent_No Order By Sort asc) RowNum, Id, Agreement_No, Sort From #Temp
	)a On T.Id = a.Id and a.RowNum <> 1
	
	PRINT '3'
	Select @RecordCount = Count(distinct (agreement_no )) From #Temp

	Update a 
		Set a.Row_Num = b.Row_Num
		From #Temp a
		Inner Join (
			--Select Rank() over(order by Sort Asc, Last_Updated_Time desc, ID ASC) Row_Num, ID From #Temp
			Select dense_Rank() over(order by Sort Asc, Last_Updated_Time desc, agreement_no ASC) Row_Num, ID From #Temp
		) As b On a.Id = b.Id
		
	PRINT '4'
	If(@IsPaging = 'Y')
	Begin	
		--select * from #Temp Order By Row_Num
		--Delete From #Temp Where Row_Num < (((1 - 1) * 10) + 1) Or Row_Num > 1 * 10 --and agreement_no = (select distinct agreement_no from #Temp)
		Delete From #Temp Where Row_Num < (((@PageNo - 1) * @PageSize) + 1) Or Row_Num > @PageNo * @PageSize 
	End	

	PRINT '5'
	Declare @Sql NVARCHAR(MAX)
	--select * from #Temp Order By Row_Num
Set @Sql = N'SELECT * FROM (
SELECT distinct dbo.[UFN_Get_MIlestone_Count](Acq_Deal_Code) as TotalMilestoneCount,
V.Vendor_Name VendorName, AD.Acq_Deal_Code, AD.Agreement_No
,AD.Deal_Type_Code Deal_Type_Code
,ISNULL(dbo.UFN_Get_Current_Approver_Code(30,AD.Acq_Deal_Code),0) currentApproverCode		
,dbo.UFN_Get_Count_Of_Workflow_Details(30,AD.Acq_Deal_Code)WorkFlowDetailsCount		
,dbo.UFN_Get_Acq_Territory(AD.Acq_Deal_Code) CountryDetails
,dbo.UFN_Get_Acq_Rights_Period(AD.Acq_Deal_Code) RightPeriod
,dbo.UFN_Get_Title(AD.Acq_Deal_Code,''A'') DealTitles
,(SELECT DISTINCT count(ISNULL(Title_Name,Original_Title)) FROM Acq_Deal_Movie ADM WITH(NOLOCK)
INNER JOIN Title Tit WITH(NOLOCK) On Tit.title_code = ADM.Title_Code WHERE ADM.Acq_Deal_Code = AD.Acq_Deal_Code ) Cnt_DealTitles
,dbo.fn_IsShow_Deal_Reopen_Btn(AD.Acq_Deal_Code) IsShowReopenBtn
,(SELECT COUNT(*) from Acq_Deal_Movie WITH(NOLOCK) where Acq_Deal_Code in (AD.Acq_Deal_Code)  and ISNULL(is_closed,''N'')=''Y'') IsCountMovieClosed
,(select COUNT(*) from Acq_Deal_Movie WITH(NOLOCK) where Acq_Deal_Code  in (AD.Acq_Deal_Code)  AND ISNULL(is_closed,''N'') = ''N'') IsShowDealMovieCloseBtn	    
,(SELECT COUNT(Deal_Code) from Syn_Acq_Mapping WITH(NOLOCK) where Deal_Code in (AD.Acq_Deal_Code)) isShowAmmendmentBtn
,(select Deal_Tag_Description from Deal_Tag WITH(NOLOCK) where Deal_Tag_Code = AD.Deal_Tag_Code) DealTagDescription
,(SELECT TOP 1 DT.Deal_Type_Name FROM Deal_Type DT WITH(NOLOCK) WHERE  DT.Deal_Type_Code=AD.Deal_Type_Code ) DealTypeName
,AD.Acq_Deal_Code IntCode
,AD.Last_Updated_Time LastUpdatedTime
,AD.Last_Action_By LastActionBy
,[dbo].[UFN_Get_Deal_IsComplete](AD.Acq_Deal_Code) IsCompleted
,[dbo].[UFN_Check_Workflow](30,AD.Acq_Deal_Code) IsZeroWorkFlow
,AD.Attach_Workflow attachWorkflow
,AD.Deal_Workflow_Status dealWorkFlowStatus
,AD.Agreement_No DealNo
,''N'' IsAutoGenerated
,AD.Agreement_Date DealSignedDate
,(select count(AT_Acq_Deal_Code) from AT_Acq_Deal WITH(NOLOCK) where Acq_Deal_Code = AD.Acq_Deal_Code) parentDealCode		
,AD.Deal_Desc DealDesc
,AD.Is_Released isReleased
,'''' IsTerminate
,dbo.UFN_Is_Deal_Tentative(AD.Acq_Deal_Code,30) IsTentative
,'''' IsDealContinue
,CASE WHEN CAST(AD.version AS float) < 10 THEN ''0'' + CAST(CAST(AD.version AS float) AS VARCHAR) Else CAST(CAST(AD.version AS float) AS VARCHAR)END AS version
,(SELECT Max(Version) FROM AT_Acq_Deal WITH(NOLOCK) WHERE Acq_Deal_Code = AD.Acq_Deal_Code) [Previous Version]
,AD.Work_Flow_Code as work_flow_code
,AD.Work_Flow_Code as workflowcode
,AD.Deal_Tag_Code DealTagCode
,AD.Is_Active isActive
,r.Role_Name contentType
,AD.Currency_Code currencyCode
,AD.Inserted_On insertedOn
,AD.Inserted_By insertedBy
,AD.Vendor_Contacts_Code customerContactCode
,AD.Category_Code categoryCode
,AD.Vendor_Code customerCode
,AD.Entity_Code EntityCode
,AD.Year_Type YearType
,AD.Ref_No refNo
,AD.Exchange_Rate exchangeRate
,AD.Payment_Terms_Conditions PaymentTermsNConditions
,AD.Validate_CostWith_Budget
,AD.BudgetWise_Costing_Applicable
,AD.Amendment_Date DealAMDDate
,AD.Status
,(Select Top 1 Action From Deal_Process dp WITH(NOLOCK) Where dp.Deal_Code = AD.Acq_Deal_Code AND DP.Record_Status <> ''D'') AT_Status
,AD.Deal_Type_Code DealFor
,AD.Remarks
,AD.Deal_Complete_Flag		
,AD.Master_Deal_Movie_Code_ToLink MasterDealMovieCodeToLink
,AD.Business_Unit_Code
,(select Business_Unit_Name from Business_Unit WITH(NOLOCK) where Business_Unit_Code = AD.Business_Unit_Code) Business_Unit_Name
,AD.Last_Updated_Time
,dbo.[UFN_Get_Deal_DealWorkFlowStaus](AD.Acq_Deal_Code, Deal_Workflow_Status, '+ CAST(@User_Code AS VARCHAR(50)) +') Final_Deal_Workflow_Status
,dbo.[UFN_DEAL_SET_BUTTON_VISIBILITY](AD.Acq_Deal_Code,  CAST(AD.version AS float) , '+ CAST(@User_Code AS VARCHAR(50)) +', AD.Deal_Workflow_Status) Show_Hide_Buttons
,T.Row_Num  
FROM Acq_Deal AD WITH(NOLOCK)
INNER JOIN Vendor v WITH(NOLOCK) on AD.Vendor_Code = v.vendor_code
Inner Join Role r WITH(NOLOCK) On AD.Role_Code = r.Role_Code
INNER JOIN #Temp T on AD.Acq_Deal_Code = T.RowId
) tbl
ORDER BY tbl.Row_Num'

	 --WHERE tbl.Acq_Deal_Code in (Select RowId From #Temp) ORDER BY  + @OrderByCndition
			--,AD.Deal_Complete_Flag
	PRINT @Sql
	Exec(@Sql)
	--Drop Table #Temp

	IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp
End
/*
EXEC  USP_List_Acq '',1,'1','Y',10,10,1
EXEC USP_List_Acq 'AND Business_Unit_Code =1' ',1, 'Acq_Deal_Code desc','Y',10,10,143
select * from Users
Use RightsU_Plus
*/
