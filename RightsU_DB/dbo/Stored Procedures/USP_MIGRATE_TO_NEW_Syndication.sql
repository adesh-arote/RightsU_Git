CREATE PROC [dbo].[USP_MIGRATE_TO_NEW_Syndication]
(
	@SYN_DEALCODE INT=0,
	@dBug CHAR(1)='N'
)
AS
-- =============================================
-- Author:		RESHMA KUNJAL
-- Create DATE: 25-FEB-2015
-- Description: SP to migrate SYN Deals from OLD to NEW DB STructure
-- =============================================
BEGIN
Declare @Loglevel int
select @Loglevel = Parameter_Value from System_Parameter_New  where Parameter_Name='loglevel'
if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_MIGRATE_TO_NEW_Syndication]', 'Step 1', 0, 'Started Procedure', 0, ''
BEGIN TRAN
DECLARE @SYN_Deal_Code INT,@Syn_Deal_Rights_Code INT,@Syn_Deal_Pushback_Code INT,@Syn_Deal_Run_Code INT,@Syn_Deal_Ancillary_Code INT, @Business_unit_code Int = 0
,@Syn_Deal_Revenue_Code INT,@Syn_Deal_Revenue_HB_Code INT

select top 1 @Business_unit_code = Business_unit_code from Business_unit
	
	--ROLLBACK TRAN
	--RETURN
BEGIN TRY

	BEGIN -- REGION INSERT INTO SD / SDM / SDL

	--print 'SYN_Deal'
	/* -- SYN_Deal
	*/
	INSERT INTO Syn_Deal 
	(
		Agreement_Date,	Agreement_No,	Attach_Workflow,
		Category_Code,	Currency_Code,	Customer_Type,
		Deal_Description,	Deal_Tag_Code,	Deal_Type_Code,
		Deal_Workflow_Status,	Entity_Code,	Exchange_Rate,
		Inserted_By,	Inserted_On,	Is_Active,
		Is_Completed,	Is_Migrated,	Last_Action_By,
		Last_Updated_Time,	Lock_Time,	Other_Deal,
		Parent_Syn_Deal_Code,	Payment_Terms_Conditions,	Ref_No,
		Remarks,	Sales_Agent_Code,	Sales_Agent_Contact_Code,
		Status,	Total_Sale,	Vendor_Code,
		Vendor_Contact_Code,	Version,	Work_Flow_Code,
		Year_Type,	Business_Unit_Code,	Ref_BMS_Code,
		Rights_Remarks,	Payment_Remarks,	Deal_Complete_Flag	
	)
	SELECT 
		syndication_deal_date,
		--dbo.UFN_Auto_Genrate_Agreement_No('A', syndication_deal_date, 0)
		syndication_no
		,attach_workflow
		,cnew.category_code,currnew.currency_code,customer_type,
		deal_description,Deal_Tag_Code,deal_type_code
		,case when sd.deal_workflow_status='S' then 'W'
			 when sd.deal_workflow_status='RS' then 'W'
			 when sd.deal_workflow_status='AM' then 'AM'
		else left(sd.deal_workflow_status,1) end ,entity_code,exchange_rate,
		SD.Inserted_By,sd.Inserted_On Inserted_On,SD.Is_Active
		,is_Completed,is_migrated,SD.Last_Action_By
		,SD.Last_Updated_Time,SD.Lock_Time,other_deal
		,parent_syndeal_code,payment_terms_conditions,ref_no,
		remerks,salesagent_code,salesagent_contact_code
		,status,total_sale,vnew.Vendor_Code
		,vcnew.Vendor_Contacts_Code,'0001',
		(SELECT TOP 1 Workflow_Code FROM Workflow_Module W (NOLOCK) WHERE W.Business_Unit_Code=Business_Unit_Code AND System_End_Date IS NULL) work_flow_code,  -- HC
		year_type,@Business_unit_code,0 Ref_BMS_Code,
		''Rights_Remarks,''Payment_Remarks,'R,C' Deal_Complete_Flag
	FROM 
		Rightsu_vmpl_live_27March_2015.dbo.syndication_deal  SD
		Inner Join Rightsu_vmpl_live_27March_2015.dbo.Vendor v On SD.vendor_code = v.vendor_code
		Inner Join Vendor vNew (NOLOCK) On vNew.Vendor_Name = v.vendor_name
		left join Rightsu_vmpl_live_27March_2015.dbo.Vendor_Contacts vc on vc.vendor_contacts_code=sd.vendor_contact_code
		left join Vendor_Contacts vcnew (NOLOCK) on vcnew.Contact_Name =vc.Contact_Name
		---Category , Currency,Payment Terms---
		Inner join Rightsu_vmpl_live_27March_2015.dbo.Category c on sd.category_code=c.category_code
		inner join Category cNew (NOLOCK) on cNew.Category_Name=c.category_name
		inner join Rightsu_vmpl_live_27March_2015.dbo.Currency curr on sd.currency_code=curr.currency_code
		inner join Currency currNew (NOLOCK) on currNew.Currency_Name=curr.currency_name
		---Category , Currency,Payment Terms---
	WHERE syndication_deal_code=@SYN_DEALCODE --and sd.Is_Active='Y'
	--select * from Rightsu_vmpl_live_27March_2015.dbo.syndication_deal  

	SELECT @Syn_Deal_Code=SCOPE_IDENTITY() 
	--IF(@dBug='D')SELECT @SYN_Deal_Code Syn_Deal_Code

	--print 'Syn_Deal_Movie'
	/*--- Syn_Deal_Movie ---*/
	declare @eps_start int,@eps_end int
	select  @eps_start =1,@eps_end =1
	
	INSERT INTO  Syn_Deal_Movie
	(
		Syn_Deal_Code,
		Title_Code,
		No_Of_Episode,
		Is_Closed,
		Syn_Title_Type,
		Remark,
		Episode_End_To,
		Episode_From
	)
	SELECT 
		@SYN_Deal_Code syn_deal_code
		,titNew.Title_Code,
		no_of_episode,
		is_Closed,
		SynDealMovieType,
		Remark,
		@eps_start,
		@eps_end
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie sdm
	Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit on sdm.title_code = tit.title_code 
	Inner Join Title titNew (NOLOCK) On tit.english_title = titNew.Title_Name
	WHERE syndication_deal_code=@SYN_DEALCODE
	/*--- Syn_Deal_Movie ---*/

	/*UPDATE RIGHTS REMARKS IN ACQ DEAL*/
	Update sd set sd.Rights_Remarks=sdm.Remark
	from Syn_Deal_Movie sdm 
	inner join Syn_Deal sd on sd.Syn_Deal_Code=sdm.Syn_Deal_Code
	where sdm.Syn_Deal_Code=@SYN_Deal_Code
	

	--print 'Syn_Deal_Payment_Terms'
	/*--- Syn_Deal_payment_terms ---*/
	INSERT INTO  Syn_Deal_Payment_Terms
	 (
		Syn_Deal_Code,
		Payment_Terms_Code,
		Days_After,
		Percentage,
		Due_Date,
		Cost_Type_Code,
		Inserted_On,
		Inserted_By,
		Last_Updated_Time,
		Last_Action_By
	)
	SELECT 
		@SYN_Deal_Code syn_deal_code,
		pnew.Payment_Terms_Code,
		days_after,
		per_cent,
		Due_Date,
		cnew.Cost_Type_Code,
		getdate() Inserted_On,
		sdpt.Inserted_By,
		sdpt.Last_Updated_Time,
		sdpt.Last_Action_By
	FROM Rightsu_vmpl_live_27March_2015.dbo.Syn_deal_payment_terms sdpt
	Inner join Rightsu_vmpl_live_27March_2015.dbo.Payment_Terms p on sdpt.payment_term_code=p.payment_terms_code
	inner join Payment_Terms pNew (NOLOCK) on pNew.Payment_Terms=p.Payment_Terms
	inner join Rightsu_vmpl_live_27March_2015.dbo.Cost_Type c on c.cost_type_code=sdpt.Cost_Type_Code
	inner join Cost_Type cNew (NOLOCK) on cNew.Cost_Type_Name=c.Cost_Type_Name
	WHERE syndication_deal_code=@SYN_DEALCODE
	/*---Syn_Deal_payment_terms ---*/

	--print 'REGION Rights Groupwise Exclusivity / Title / Platform / Territory / Subtitling / Dubbing'
	BEGIN -- REGION Rights Groupwise Exclusivity / Title / Platform / Territory / Subtitling / Dubbing
	
	/*----------RIGHTS-----------*/
	BEGIN
	/*--Exclusivity Group Wise
	*/
	CREATE TABLE #Exclusive_Group(
		is_group INT,
		Is_Exclusive CHAR(1)
	)
	INSERT INTO #Exclusive_Group(is_group,Is_Exclusive)
	SELECT  sdmr.is_group,is_exclusive
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Territory SDMRT ON SDMR.syn_deal_movie_rights_code=SDMRT.Syn_Deal_movie_rights_code 
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE and isnull(sdmr.isPushBack,'N')='N'
	GROUP BY  sdmr.is_group,is_exclusive
	ORDER BY is_group
		    
	DECLARE @Syn_Deal_Rights_Title Deal_Rights_Title
	INSERT INTO @Syn_Deal_Rights_Title (Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
	SELECT is_group,titNew.Title_Code,@eps_start,@eps_end
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie sdm
	Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit on sdm.title_code = tit.title_code
	Inner Join Title titNew (NOLOCK) On tit.english_title = titNew.Title_Name
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE and isnull(sdmr.isPushBack,'N')='N'
	GROUP BY is_group,titNew.Title_Code, no_of_episode
 
	DECLARE @Syn_Deal_Rights_Platform Deal_Rights_Platform
	INSERT INTO @Syn_Deal_Rights_Platform (Deal_Rights_Code,pnew.Platform_Code)
	SELECT is_group,p.platform_code
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Platform p on p.platform_code=sdmr.platform_code
	--inner join Platform pNew on p.platform_name=pNew.platform_name and p.Platform_Hiearachy=pNew.Platform_Hiearachy
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE and isnull(sdmr.isPushBack,'N')='N'	
	GROUP BY is_group,p.platform_code

	select country_code 
	into #tmpCountry
	from Country (NOLOCK) where Country_code>142

	DECLARE @Syn_Deal_Rights_Territory Deal_Rights_Territory
	INSERT INTO @Syn_Deal_Rights_Territory (Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code)
	SELECT sdmr.is_group,territory_type,
	case when sdmrt.is_domestic_territory ='Y' then cterr.country_code 
	when sdmrt.is_international_territory ='Y' then c.country_code 
	else c.country_code end 
	,tnew.territory_code
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Territory SDMRT ON SDMR.syn_deal_movie_rights_code=SDMRT.Syn_Deal_movie_rights_code 
	left join Rightsu_vmpl_live_27March_2015.dbo.International_Territory it on it.international_territory_code=SDMRT.territory_code
	left join Country c (NOLOCK) on c.country_name=it.international_territory_name
	left join Rightsu_vmpl_live_27March_2015.dbo.Territory t on t.territory_code=SDMRT.territory_code
	left join Country cTerr (NOLOCK) on cTerr.country_name=t.territory_name
	left join Rightsu_vmpl_live_27March_2015.dbo.territory_group tg on tg.territory_group_code=SDMRT.territory_group_code
	left join Territory tnew (NOLOCK) on tnew.Territory_Name=tg.territory_group_name
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE and isnull(sdmr.isPushBack,'N')='N'	
	GROUP BY sdmr.is_group,territory_type,c.country_code,cterr.country_code,tnew.territory_code,sdmrt.is_domestic_territory,sdmrt.is_international_territory
	ORDER BY sdmr.is_group

	DECLARE @Syn_Deal_Rights_Subtitling Deal_Rights_Subtitling
	INSERT INTO @Syn_Deal_Rights_Subtitling(Deal_Rights_Code,Language_Type,Subtitling_Code,Language_Group_Code)
	SELECT sdmr.is_group
		   ,CASE WHEN ISNULL(SDMRS.language_code,0)>0 THEN 'L' ELSE 'G' END Language_Type
		   --,ISNULL(SDMRS.language_code,lnew.language_code) Language_Code,
		   ,CASE WHEN ISNULL(SDMRS.language_code,0)>0 THEN lnew.language_code else LGD.Language_Code end Language_Code
		   ,lgnew.Language_Group_Code
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Subtitling SDMRS ON SDMR.syn_deal_movie_rights_code=SDMRS.Syn_Deal_movie_rights_code 
	left join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=SDMRS.language_code
	left join Language lnew (NOLOCK) on lNew.Language_Name=l.Language_Name
	Left join Rightsu_vmpl_live_27March_2015.dbo.Language_Group lg on lg.Language_Group_Code=sdmrs.Language_Group_Code
	Left join Language_Group lgNew (NOLOCK) on lgNew.Language_Group_Name=lg.Language_Group_Name
	LEFT JOIN Language_Group_Details LGD (NOLOCK) ON lgNew.Language_Group_Code=LGD.Language_Group_Code
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE	 and isnull(sdmr.isPushBack,'N')='N'
	GROUP BY sdmr.is_group,lnew.language_code,lgnew.Language_Group_Code,SDMRS.language_code,LGD.Language_Code

	DECLARE @Syn_Deal_Rights_Dubbing Deal_Rights_Dubbing
	INSERT INTO @Syn_Deal_Rights_Dubbing(Deal_Rights_Code,Language_Type,Dubbing_Code,Language_Group_Code)
	SELECT sdmr.is_group
		   ,CASE WHEN ISNULL(SDMRD.language_code,0)>0 THEN 'L' ELSE 'G' END Language_Type
		   --,ISNULL(SDMRD.language_code,lNew.language_code) Language_Code
		   ,CASE WHEN ISNULL(SDMRD.language_code,0)>0 THEN lnew.language_code else LGD.Language_Code end Language_Code
		   ,lgNew.Language_Group_Code
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Dubbing SDMRD ON SDMR.syn_deal_movie_rights_code=SDMRD.Syn_Deal_movie_rights_code 
	left join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=SDMRD.language_code
	left join Language lnew (NOLOCK) on lNew.Language_Name=l.Language_Name
	Left join Rightsu_vmpl_live_27March_2015.dbo.Language_Group lg on lg.Language_Group_Code=SDMRD.Language_Group_Code
	Left join Language_Group lgNew (NOLOCK) on lgNew.Language_Group_Name=lg.Language_Group_Name
	LEFT JOIN Language_Group_Details LGD (NOLOCK) ON lgNew.Language_Group_Code=LGD.Language_Group_Code
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE	 and isnull(sdmr.isPushBack,'N')='N'
	GROUP BY sdmr.is_group,lnew.language_code,lgNew.Language_Group_Code,SDMRD.language_code,LGD.Language_Code
	
	END
	/*----------RIGHTS-----------*/

	/*----------PUSH_BACK-----------*/
	BEGIN
			    
	DECLARE @Syn_Deal_Rights_Title_PB Deal_Rights_Title
	INSERT INTO @Syn_Deal_Rights_Title_PB (Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
	SELECT is_group,titNew.Title_Code,@eps_start,@eps_end
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie sdm
	Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit on sdm.title_code = tit.title_code
	Inner Join Title titNew (NOLOCK) On tit.english_title = titNew.Title_Name
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE and isnull(sdmr.isPushBack,'N')='Y'
	GROUP BY is_group,titNew.Title_Code, no_of_episode
 
	DECLARE @Syn_Deal_Rights_Platform_PB Deal_Rights_Platform
	INSERT INTO @Syn_Deal_Rights_Platform_PB (Deal_Rights_Code,pnew.Platform_Code)
	SELECT is_group,p.platform_code
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Platform p on p.platform_code=sdmr.platform_code
	--inner join Platform pNew on p.platform_name=pNew.platform_name and p.Platform_Hiearachy=pNew.Platform_Hiearachy
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE and isnull(sdmr.isPushBack,'N')='Y'
	GROUP BY is_group,p.platform_code

	DECLARE @Syn_Deal_Rights_Territory_PB Deal_Rights_Territory
	INSERT INTO @Syn_Deal_Rights_Territory_PB (Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code)
	SELECT sdmr.is_group,territory_type,
	case when sdmrt.is_domestic_territory ='Y' then cterr.country_code 
	when sdmrt.is_international_territory ='Y' then c.country_code 
	else c.country_code end 
	,tnew.territory_code
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Territory SDMRT ON SDMR.syn_deal_movie_rights_code=SDMRT.Syn_Deal_movie_rights_code 
	left join Rightsu_vmpl_live_27March_2015.dbo.International_Territory it on it.international_territory_code=SDMRT.territory_code
	left join Country c (NOLOCK) on c.country_name=it.international_territory_name
	left join Rightsu_vmpl_live_27March_2015.dbo.Territory t on t.territory_code=SDMRT.territory_code
	left join Country cTerr (NOLOCK) on cTerr.country_name=t.territory_name
	left join Rightsu_vmpl_live_27March_2015.dbo.territory_group tg on tg.territory_group_code=SDMRT.territory_group_code
	left join Territory tnew (NOLOCK) on tnew.Territory_Name=tg.territory_group_name
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE and isnull(sdmr.isPushBack,'N')='Y'
	GROUP BY sdmr.is_group,territory_type,c.country_code,cterr.country_code,tnew.territory_code,sdmrt.is_domestic_territory,sdmrt.is_international_territory
	ORDER BY sdmr.is_group

	DECLARE @Syn_Deal_Rights_Subtitling_PB Deal_Rights_Subtitling
	INSERT INTO @Syn_Deal_Rights_Subtitling_PB(Deal_Rights_Code,Language_Type,Subtitling_Code,Language_Group_Code)
	SELECT sdmr.is_group
		   ,CASE WHEN ISNULL(SDMRS.language_code,0)>0 THEN 'L' ELSE 'G' END Language_Type
		   --,ISNULL(SDMRS.language_code,lnew.language_code) Language_Code
		   ,CASE WHEN ISNULL(SDMRS.language_code,0)>0 THEN lnew.language_code else LGD.Language_Code end Language_Code
		   ,lgnew.Language_Group_Code
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Subtitling SDMRS ON SDMR.syn_deal_movie_rights_code=SDMRS.Syn_Deal_movie_rights_code 
	left join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=SDMRS.language_code
	left join Language lnew (NOLOCK) on lNew.Language_Name=l.Language_Name
	Left join Rightsu_vmpl_live_27March_2015.dbo.Language_Group lg on lg.Language_Group_Code=sdmrs.Language_Group_Code
	Left join Language_Group lgNew (NOLOCK) on lgNew.Language_Group_Name=lg.Language_Group_Name
	LEFT JOIN Language_Group_Details LGD (NOLOCK) ON lgnew.Language_Group_Code=LGD.Language_Group_Code
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE and isnull(sdmr.isPushBack,'N')='Y'
	GROUP BY sdmr.is_group,lnew.language_code,lgnew.Language_Group_Code,SDMRS.language_code,lgd.Language_Code

	DECLARE @Syn_Deal_Rights_Dubbing_PB Deal_Rights_Dubbing
	INSERT INTO @Syn_Deal_Rights_Dubbing_PB(Deal_Rights_Code,Language_Type,Dubbing_Code,Language_Group_Code)
	SELECT sdmr.is_group
		   ,CASE WHEN ISNULL(SDMRD.language_code,0)>0 THEN 'L' ELSE 'G' END Language_Type
		   --,ISNULL(SDMRD.language_code,lNew.language_code) Language_Code
		   ,CASE WHEN ISNULL(SDMRD.language_code,0)>0 THEN lnew.language_code else LGD.Language_Code end Language_Code
		   ,lgNew.Language_Group_Code
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Dubbing SDMRD ON SDMR.syn_deal_movie_rights_code=SDMRD.Syn_Deal_movie_rights_code 
	--LEFT JOIN Language_Group_Details LGD ON SDMRD.Language_Group_Code=LGD.Language_Group_Code
	left join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=SDMRD.language_code
	left join Language lnew (NOLOCK) on lNew.Language_Name=l.Language_Name
	Left join Rightsu_vmpl_live_27March_2015.dbo.Language_Group lg on lg.Language_Group_Code=SDMRD.Language_Group_Code
	Left join Language_Group lgNew (NOLOCK) on lgNew.Language_Group_Name=lg.Language_Group_Name
	LEFT JOIN Language_Group_Details LGD (NOLOCK) ON lgNew.Language_Group_Code=LGD.Language_Group_Code
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE  and isnull(sdmr.isPushBack,'N')='Y'
	GROUP BY sdmr.is_group,lnew.language_code,lgNew.Language_Group_Code,SDMRD.language_code,LGD.Language_Code
	
	END
	/*----------PUSH_BACK-----------*/

	END
	
	--print 'REGION INSERT INTO CURSOR ADR / ADRT / ADRP / ADRTERR / ADRS / ADRD'
	BEGIN -- REGION INSERT INTO CURSOR ADR / ADRT / ADRP / ADRTERR / ADRS / ADRD
	DECLARE @is_group INT
	,@is_original_language_rights CHAR(1)
	,@is_sub_license CHAR(1)
	,@right_period_for CHAR(1)
	,@IsTentative CHAR(1)
	,@term VARCHAR(100)
	,@right_start_date datetime
	,@right_end_date datetime
	,@IsRightsofFirstRefusal CHAR(1)
	,@FirstRefusalDate datetime
	,@Effective_Start_Date datetime
	--,@Actual_Right_start_Date datetime
	--,@Actual_Right_End_Date datetime
	,@inserted_by int
	,@inserted_on datetime
	,@last_updated_time datetime
	,@last_action_by int
	,@Is_Exclusive CHAR(1)
	,@Sub_License_Code INT
	,@Is_Theatrical_Right CHAR(1)
	,@Milestone_Type_Code INT
	,@Milestone_No_Of_Unit  INT
	,@Milestone_Unit_Type INT
	,@Restriction_Remarks Remarks_UD
	--,@Milestone Varchar(100)
	,@Is_Pushback CHAR(1)
	--,@PlatformCode int
	,@run_type  char(1)
	,@no_of_runs  int
	,@is_yearwise_definition char(1)
	,@is_rule_right char(1)
	,@right_rule_code int

	--DEALLOCATE CUR_DMR_ADR_GROUP
	DECLARE CUR_DMR_ADR_GROUP CURSOR
	READ_ONLY
	FOR 
	SELECT 
	a.is_group,c.is_original_language_rights,is_sub_license, right_period_for
	,IsTentative,term,case when right_period_for='U' then sd.syndication_deal_date else right_start_date end
	,right_end_date,IsRightsofFirstRefusal,FirstRefusalDate
	,Effective_Start_Date--,Actual_Right_start_Date,Actual_Right_End_Date
	--,143 inserted_by,GETDATE() inserted_on,null last_updated_time,null last_action_by
	,sd.inserted_by,sd.inserted_on,sd.last_updated_time,sd.last_action_by
	,'N' Is_Exclusive, 
	Case 
		When is_sub_license = 'N' Then Null
		When isPrior = 'PA' Then 2
		When isPrior = 'PN' Then 3
		Else 1
	End	 Sub_License_Code -- HC
	,dbo.fn_GET_MIG_IS_THEATRICAL(@SYN_DEALCODE,a.is_group,'S') Is_Theatrical_Right --TDB None of the deals are Domestic
	,-- (SELECT Milestone_Type_Code FROM Milestone_Type WHERE Milestone_Type_Name=ltrim(rtrim(Milestone)))
	null Milestone_Type_Code
	,run_based_no_of_run Milestone_No_Of_Unit
	,run_based_unit Milestone_Unit_Type
	,case when a.IsPushBack='Y' then a.Remarks else  b.Syn_Deal_Movie_Rights_Restriction_Remark end Restriction_Remarks
	--, a.Milestone
	,isnull(a.IsPushBack,'N') IsPushBack
	--,a.platform_code
	,run_type,no_of_runs,is_yearwise_definition,is_rule_right,rrNew.right_rule_code
	FROM (
		Select * From Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights r WHERE syndication_deal_movie_code in
		(
			SELECT syndication_deal_movie_code FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie WHERE syndication_deal_code=@SYN_DEALCODE
		) 
	) as a
	inner join Rightsu_vmpl_live_27March_2015.dbo.syndication_DEAL_Movie sdm on sdm.syndication_deal_movie_code=a.syndication_deal_movie_code
	inner join Rightsu_vmpl_live_27March_2015.dbo.syndication_DEAL sd on sdm.syndication_deal_code=sd.syndication_deal_code
	Left Join (
		Select Distinct Max(Syn_Deal_Movie_Rights_Restriction_Remark) Syn_Deal_Movie_Rights_Restriction_Remark, 
		sdmr1.is_group From Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Restriction_Remark sdmrrr
		Inner Join Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Restriction_Remark_Details sdmrrrd On sdmrrr.Syn_Deal_Movie_Rights_Restriction_Remark_Code = sdmrrrd.Syn_Deal_Movie_Rights_Restriction_Remark_Code
		Inner Join Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights sdmr1 On sdmr1.syn_deal_movie_rights_code = sdmrrrd.syn_Deal_Movie_Rights_Code And sdmr1.syndication_deal_movie_code in
		(
			SELECT syndication_deal_movie_code FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie WHERE syndication_deal_code=@SYN_DEALCODE
		) 
		Group By sdmr1.is_group
	) as b On a.is_group = b.is_group
	left join  Rightsu_vmpl_live_27March_2015.dbo.Right_Rule rr on rr.Right_Rule_Code=a.right_rule_code
	left join Right_Rule rrNew on rrNew.right_Rule_Name=rr.right_Rule_Name
	left join (
		Select max(is_original_language_rights) is_original_language_rights,is_group From Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights r 
		WHERE syndication_deal_movie_code in
		(
			SELECT syndication_deal_movie_code FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie WHERE syndication_deal_code=@SYN_DEALCODE
		)
		group by is_group 
	) as c on a.is_group=c.is_group
	GROUP BY 
	a.is_group,b.is_group,c.is_original_language_rights,a.is_sub_license,right_period_for
	,IsTentative,term,right_start_date
	,right_end_date,IsRightsofFirstRefusal,FirstRefusalDate
	,Effective_Start_Date
	--,ltrim(rtrim(Milestone))
	,run_based_no_of_run,run_based_unit, b.Syn_Deal_Movie_Rights_Restriction_Remark,isPrior--, a.Milestone
	,a.IsPushBack
	--,a.platform_code
	,sd.inserted_by,sd.inserted_on,sd.last_updated_time,sd.last_action_by
	,sd.syndication_deal_date,a.Remarks 
	,run_type,no_of_runs,is_yearwise_definition,is_rule_right,rrNew.right_rule_code

	OPEN CUR_DMR_ADR_GROUP	
	FETCH NEXT FROM CUR_DMR_ADR_GROUP INTO 
					 @is_group
					,@is_original_language_rights
					,@is_sub_license
					,@right_period_for
					,@IsTentative
					,@term
					,@right_start_date
					,@right_end_date
					,@IsRightsofFirstRefusal
					,@FirstRefusalDate
					,@Effective_Start_Date
					--,@Actual_Right_start_Date
					--,@Actual_Right_End_Date
					,@inserted_by
					,@inserted_on
					,@last_updated_time
					,@last_action_by
					,@Is_Exclusive
					,@Sub_License_Code
					,@Is_Theatrical_Right
					,@Milestone_Type_Code
					,@Milestone_No_Of_Unit
					,@Milestone_Unit_Type
					,@Restriction_Remarks
					,@Is_Pushback
					--,@PlatformCode
					,@run_type
					,@no_of_runs
					,@is_yearwise_definition
					,@is_rule_right
					,@right_rule_code
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

			/* -- Syn_Deal_Rights		
		    */
			--declare @Is_Exclusive_R char(1)
			--SELECT @Is_Exclusive_R=Is_Exclusive FROM #Exclusive_Group WHERE is_group=@is_group


			INSERT INTO Syn_Deal_Rights(
			 Syn_Deal_Code
			,Is_Title_Language_Right,Is_Sub_License,Right_Type
			,Is_Tentative,Term,Right_Start_Date
			,Right_End_Date,Is_ROFR,ROFR_Date
			,Effective_Start_Date,Actual_Right_Start_Date,Actual_Right_End_Date
			,Inserted_By,Inserted_On,Last_Updated_Time
			,Last_Action_By
			,Is_Exclusive
			,Sub_License_Code
			,Is_Theatrical_Right
			,Milestone_Type_Code,Milestone_No_Of_Unit,Milestone_Unit_Type
			,Restriction_Remarks,Is_Pushback,Right_Status)
			SELECT  @SYN_Deal_Code Syn_Deal_Code
			,@is_original_language_rights,@is_sub_license, Case When @right_period_for = 'R' Then 'M' Else @right_period_for End
			,@IsTentative,@term,@right_start_date
			,@right_end_date,@IsRightsofFirstRefusal,@FirstRefusalDate
			,@right_start_date,@right_start_date,@right_end_date
			,@inserted_by,@inserted_on,@last_updated_time
			,@last_action_by,
			 case when @Is_Pushback='Y' then 'Y' else (SELECT Is_Exclusive FROM #Exclusive_Group WHERE is_group=@is_group)end Is_Exclusive 
			,@Sub_License_Code
			,@Is_Theatrical_Right
			,@Milestone_Type_Code
			,@Milestone_No_Of_Unit,@Milestone_Unit_Type
			,@Restriction_Remarks,@Is_Pushback,'C'
		
			SELECT @Syn_Deal_Rights_Code=SCOPE_IDENTITY()
			--IF(@dbug='D') SELECT @Syn_Deal_Rights_Code Syn_Deal_Rights_Code
						
			 if(@Is_Pushback='N')
			 BEGIN

				 /* -- Syn_Deal_Rights_Title
				 */
				 INSERT INTO Syn_Deal_Rights_Title(
				 Syn_Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
				 SELECT 
					 @Syn_Deal_Rights_Code Syn_Deal_Rights_Code,Title_Code,Episode_From,Episode_To
				 FROM @Syn_Deal_Rights_Title
				 WHERE Deal_Rights_Code =@is_group 
			 
				 /* -- Syn_Deal_Rights_Platform		
				 */                            
				 INSERT INTO Syn_Deal_Rights_Platform(
				 Syn_Deal_Rights_Code,platform_Code)
				 SELECT 
					@Syn_Deal_Rights_Code Syn_Deal_Rights_Code,platform_Code
				 FROM @Syn_Deal_Rights_Platform
				 WHERE Deal_Rights_Code =@is_group 
		
				 /* -- Syn_Deal_Rights_Territory
				 */
				 
				 
				 if((SELECT count(*) from @Syn_Deal_Rights_Territory WHERE Deal_Rights_Code=@is_group and Territory_Type<>'G')>0)
				 begin
					 INSERT INTO Syn_Deal_Rights_Territory(
						Syn_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code 
					 )	
					 SELECT 
							@Syn_Deal_Rights_Code,Territory_Type, 
							Case When Country_Code > 0 Then Country_Code Else Null End, Case When Territory_Code > 0 Then Territory_Code Else Null End
					 FROM @Syn_Deal_Rights_Territory			 
					 WHERE Deal_Rights_Code=@is_group 
			 	 end		 
				 else
				 begin
					
					INSERT INTO Syn_Deal_Rights_Territory(
						Syn_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code 
					 )	
					 SELECT 
							@Syn_Deal_Rights_Code,Territory_Type, Country_Code,Territory_Code
					 FROM @Syn_Deal_Rights_Territory			 
					 WHERE Deal_Rights_Code=@is_group 
					 
					 INSERT INTO Syn_Deal_Rights_Territory(
						Syn_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code 
					 )	
					 SELECT @Syn_Deal_Rights_Code,'G',Country_Code, 1 FROM #tmpCountry		 
					 
				 end
				 /* -- Syn_Deal_Rights_Subtitling
				 */
				 INSERT INTO Syn_Deal_Rights_Subtitling(Syn_Deal_Rights_Code
					,Language_Type
					,Language_Code,
					Language_Group_Code
				 )
				 SELECT
						@Syn_Deal_Rights_Code,Language_Type,Subtitling_Code,
						Case When Language_Group_Code > 0 Then Language_Group_Code Else Null End
				 FROM @Syn_Deal_Rights_Subtitling
				 WHERE Deal_Rights_Code=@is_group 

				 /* -- Syn_Deal_Rights_Dubbing
				 */
				 INSERT INTO Syn_Deal_Rights_Dubbing(Syn_Deal_Rights_Code
					,Language_Type
					,Language_Code,Language_Group_Code
				 )
				 SELECT
						@Syn_Deal_Rights_Code,Language_Type,Dubbing_Code,Case When Language_Group_Code > 0 Then Language_Group_Code Else Null End
				 FROM @Syn_Deal_Rights_Dubbing
				 WHERE Deal_Rights_Code=@is_group 

				 /* -- Syn_Deal_Rights_RUN
			 */
				 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 	 if(@run_type='C' or @run_type='U')
			 BEGIN
				
				DECLARE CR_SYN_RUN CURSOR
				FOR SELECT Title_Code,Episode_From,Episode_To FROM @Syn_Deal_Rights_Title WHERE Deal_Rights_Code =@is_group 
				DECLARE @RUN_Title_Code int ,@RUn_Episode_From int ,@RUN_Episode_To int
				OPEN CR_SYN_RUN
				FETCH NEXT FROM CR_SYN_RUN INTO @RUN_Title_Code ,@RUN_Episode_From ,@RUN_Episode_To 
				WHILE(@@fetch_status<>-1)
				BEGIN
					IF (@@fetch_status <> -2)
					BEGIN
						
						/*Syn_Deal_Run
						*/
						Insert into Syn_Deal_Run (Syn_Deal_Code,Title_Code,Episode_From,Episode_To,Run_Type,No_Of_Runs,Is_Yearwise_Definition,Is_Rule_Right,
							  Right_Rule_Code,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time)
						SELECT @Syn_Deal_Code,@RUN_Title_Code ,@RUN_Episode_From ,@RUN_Episode_To,@run_type,@No_Of_Runs,@Is_Yearwise_Definition,@Is_Rule_Right,
							   @Right_Rule_Code,@Inserted_By,@Inserted_On,@Last_action_By,@Last_updated_Time
						 
						 set @Syn_Deal_Run_Code =SCOPE_IDENTITY()

						 /*Syn_Deal_Run_Platform
						 */
						 Insert into Syn_Deal_Run_Platform(Syn_Deal_Run_Code,Platform_Code)
						 SELECT @Syn_Deal_Run_Code,sdrp.Platform_Code
						 FROM @Syn_Deal_Rights_Platform sdrp
						 inner join Platform p on p.Platform_Code=sdrp.Platform_Code
						 WHERE sdrp.Deal_Rights_Code =@is_group and isnull(p.Is_Applicable_Syn_Run,'N')='Y'

						 /*Syn_Deal_Run_Yearwise_Run
						 */
						 Insert into Syn_Deal_Run_Yearwise_Run(Syn_Deal_Run_Code,Start_Date,End_Date,No_Of_Runs)
						 select @Syn_Deal_Run_Code,sdmryr.start_date,sdmryr.end_date,sdmryr.no_of_runs 
						 from Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights_yearwise_run sdmryr
						 inner join Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights sdmr on sdmr.syn_deal_movie_rights_code=sdmryr.syn_deal_movie_rights_code
						 where sdmr.is_group=@is_group
						 
					END
					FETCH NEXT FROM CR_SYN_RUN INTO @RUN_Title_Code ,@RUN_Episode_From ,@RUN_Episode_To 
				END
				CLOSE CR_SYN_RUN
				DEALLOCATE CR_SYN_RUN
			 END
			 
				 /* -- Syn_Deal_Movie_Rights_Holdback
				 */
				 --DEALLOCATE CR_SYN_RIGHTS_HB
					DECLARE CR_SYN_RIGHTS_HB CURSOR
			READ_ONLY
			FOR  select sdmrh.Holdback_Type,
						sdmrh.HB_Run_After_Release_No,
						sdmrh.HB_Run_After_Release_Units,
						p.Platform_Code,
						sdmrh.Holdback_Release_Date,
						sdmrh.Holdback_Comment,Is_Original_Language
						,sdmrh.Syn_Deal_Movie_Rights_Holdback_Code
						,pH.platform_code
				 FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie SDM
				 INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_rights SDMR ON SDM.syndication_deal_movie_code=SDMR.syndication_deal_movie_code 
				 INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_Holdback SDMRH ON SDMR.syn_deal_movie_rights_code=SDMRH.Syn_Deal_movie_rights_code 
				 left join Rightsu_vmpl_live_27March_2015.dbo.Platform p on p.platform_code=SDMRH.Holdback_On_Platform_Code 
				 --left join Platform pNew on pNew.Platform_Code=p.Platform_Code and p.Platform_Hiearachy=pNew.Platform_Hiearachy
				 left join Rightsu_vmpl_live_27March_2015.dbo.Platform pH on pH.platform_code=SDMR.platform_code 
				 --left join Platform pHNew on pHNew.Platform_Code=ph.Platform_Code and pH.Platform_Hiearachy=pHNew.Platform_Hiearachy
				 WHERE SDM.syndication_deal_code=@SYN_DEALCODE	
				 --and SDMRH.Group_No=@is_group 
				 and sdmr.is_group=@is_group

					DECLARE @Holdback_Type  char,@HB_Run_After_Release_No  int,@HB_Run_After_Release_Units  int,@Holdback_On_Platform_Code  int,@Holdback_Release_Date  datetime,
			@Holdback_Comment  varchar(2000),@Is_Original_Language  char,@Syn_Deal_Movie_Rights_Holdback_Code int,@h_Platform_code int

					OPEN CR_SYN_RIGHTS_HB

					FETCH NEXT FROM CR_SYN_RIGHTS_HB INTO @Holdback_Type,@HB_Run_After_Release_No,@HB_Run_After_Release_Units,@Holdback_On_Platform_Code,@Holdback_Release_Date,
			@Holdback_Comment,@Is_Original_Language,@Syn_Deal_Movie_Rights_Holdback_Code,@h_Platform_code
																																																														WHILE (@@fetch_status <> -1)
			BEGIN
				IF (@@fetch_status <> -2)
				BEGIN
					
					/*--Syn_Deal_Rights_Holdback--*/
					IF EXISTS (SELECT TOP 1 Syn_Deal_Rights_Holdback_code from Syn_Deal_Rights_Holdback where 
						Syn_Deal_Rights_Code=@Syn_Deal_Rights_Code and Holdback_Type=@Holdback_Type and HB_Run_After_Release_No=@HB_Run_After_Release_No  and 
						HB_Run_After_Release_Units=@HB_Run_After_Release_Units and isnull(Holdback_On_Platform_Code,0)=isnull(@Holdback_On_Platform_Code,0) and 
						Holdback_Release_Date=@Holdback_Release_Date and Holdback_Comment=@Holdback_Comment and Is_Original_Language=@Is_Original_Language	
					)
					BEGIN
						
						SELECT top 1 @Syn_Deal_Revenue_HB_Code=Syn_Deal_Rights_Holdback_code from Syn_Deal_Rights_Holdback where 
						Syn_Deal_Rights_Code=@Syn_Deal_Rights_Code and Holdback_Type=@Holdback_Type and HB_Run_After_Release_No=@HB_Run_After_Release_No  and 
						HB_Run_After_Release_Units=@HB_Run_After_Release_Units and isnull(Holdback_On_Platform_Code,0)=isnull(@Holdback_On_Platform_Code,0) and 
						Holdback_Release_Date=@Holdback_Release_Date and Holdback_Comment=@Holdback_Comment and Is_Original_Language=@Is_Original_Language	

					END
					ELSE
					BEGIN
						Insert into Syn_Deal_Rights_Holdback(Syn_Deal_Rights_Code,Holdback_Type,HB_Run_After_Release_No,HB_Run_After_Release_Units,Holdback_On_Platform_Code,
						Holdback_Release_Date,Holdback_Comment,Is_Original_Language)
						select @Syn_Deal_Rights_Code,@Holdback_Type,@HB_Run_After_Release_No,@HB_Run_After_Release_Units,@Holdback_On_Platform_Code,@Holdback_Release_Date,
						@Holdback_Comment,@Is_Original_Language

						SELECT @Syn_Deal_Revenue_HB_Code=SCOPE_IDENTITY()
					END
					
					--IF(@dbug='D') SELECT @Syn_Deal_Revenue_HB_Code Syn_Deal_Revenue_HB_Code

					/*---Syn_Deal_Rights_Holdback_Dubbing---*/
					Insert into Syn_Deal_Rights_Holdback_Dubbing(Syn_Deal_Rights_Holdback_Code,Language_Code)
					Select @Syn_Deal_Revenue_HB_Code,lnew.Language_Code from 
					Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_HoldBack_Languages sdmrhl 
					inner join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=sdmrhl.language_code
					inner join Language lnew on l.language_name=lnew.language_name
					where sdmrhl.Syn_Deal_Movie_Rights_HoldBack_Code=@Syn_Deal_Movie_Rights_Holdback_Code
					and Language_Type='D'

					/*---Syn_Deal_Rights_Holdback_Subtitling---*/
					Insert into Syn_Deal_Rights_Holdback_Subtitling(Syn_Deal_Rights_Holdback_Code,Language_Code)
					Select @Syn_Deal_Revenue_HB_Code,lnew.Language_Code from 
					Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_HoldBack_Languages sdmrhl 
					inner join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=sdmrhl.language_code
					inner join Language lnew on l.language_name=lnew.language_name
					where sdmrhl.Syn_Deal_Movie_Rights_HoldBack_Code=@Syn_Deal_Movie_Rights_Holdback_Code
					and Language_Type='S'


					/*---Syn_Deal_Rights_Holdback_Territory---*/
					Insert into Syn_Deal_Rights_Holdback_Territory(Syn_Deal_Rights_Holdback_Code,Territory_Type,Country_Code,Territory_Code)
					Select @Syn_Deal_Revenue_HB_Code,case when isnull(Country_Code,isnull(Territory_Code,0))>0 then 'I' else 'G' end,
					isnull(Country_Code,Territory_Code),Territory_Group_Code from 
					Rightsu_vmpl_live_27March_2015.dbo.Syn_Deal_Movie_Rights_HoldBack_Territory sdmrht
					where sdmrht.Syn_Deal_Movie_Rights_HoldBack_Code=@Syn_Deal_Movie_Rights_Holdback_Code
					 
					/*---Syn_Deal_Rights_Holdback_Platform---*/
					Insert into Syn_Deal_Rights_Holdback_Platform(Syn_Deal_Rights_Holdback_Code,Platform_Code)
					select @Syn_Deal_Revenue_HB_Code,@h_Platform_code

										
				END
				FETCH NEXT FROM CR_SYN_RIGHTS_HB INTO @Holdback_Type,@HB_Run_After_Release_No,@HB_Run_After_Release_Units,@Holdback_On_Platform_Code,@Holdback_Release_Date,
			@Holdback_Comment,@Is_Original_Language,@Syn_Deal_Movie_Rights_Holdback_Code,@h_Platform_code
			END
					CLOSE CR_SYN_RIGHTS_HB
					DEALLOCATE CR_SYN_RIGHTS_HB
			
				  /* -- END OF Syn_Deal_Movie_Rights_Holdback
				 */
			 END
			 ELSE if(@Is_Pushback='Y')
			 BEGIN

				/* -- Syn_Deal_Rights_Title_PB
				 */
				 INSERT INTO Syn_Deal_Rights_Title(
				 Syn_Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
				 SELECT 
					 @Syn_Deal_Rights_Code Syn_Deal_Rights_Code,Title_Code,Episode_From,Episode_To
				 FROM @Syn_Deal_Rights_Title_PB
				 WHERE Deal_Rights_Code =@is_group 
			 
				 /* -- Syn_Deal_Rights_Platform		
				 */                            
				 INSERT INTO Syn_Deal_Rights_Platform(
				 Syn_Deal_Rights_Code,platform_Code)
				 SELECT 
					@Syn_Deal_Rights_Code Syn_Deal_Rights_Code,platform_Code
				 FROM @Syn_Deal_Rights_Platform_PB
				 WHERE Deal_Rights_Code =@is_group 
		
				 /* -- Syn_Deal_Rights_Territory
				 */

				 if((SELECT count(*) from @Syn_Deal_Rights_Territory_PB WHERE Deal_Rights_Code=@is_group and Territory_Type<>'G')>0)
				 begin
					 INSERT INTO Syn_Deal_Rights_Territory(
						Syn_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code 
					 )	
					 SELECT 
							@Syn_Deal_Rights_Code,Territory_Type, Case When Country_Code > 0 Then Country_Code Else Null End, Case When Territory_Code > 0 Then Territory_Code Else Null End
					 FROM @Syn_Deal_Rights_Territory_PB			 
					 WHERE Deal_Rights_Code=@is_group 
			 	END
				elSE
				BEGIn
					INSERT INTO Syn_Deal_Rights_Territory(
						Syn_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code 
					 )	
					 SELECT 
							@Syn_Deal_Rights_Code,Territory_Type,Country_Code, Territory_Code 
					 FROM @Syn_Deal_Rights_Territory_PB			 
					 WHERE Deal_Rights_Code=@is_group 

					INSERT INTO Syn_Deal_Rights_Territory(
						Syn_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code 
					 )	
					 SELECT @Syn_Deal_Rights_Code,'G',Country_Code, 1 FROM #tmpCountry		 
				END

						 
				 /* -- Syn_Deal_Rights_Subtitling
				 */
				 INSERT INTO Syn_Deal_Rights_Subtitling(Syn_Deal_Rights_Code
					,Language_Type
					,Language_Code,
					Language_Group_Code
				 )
				 SELECT
						@Syn_Deal_Rights_Code,Language_Type,Subtitling_Code,
						Case When Language_Group_Code > 0 Then Language_Group_Code Else Null End
				 FROM @Syn_Deal_Rights_Subtitling_PB
				 WHERE Deal_Rights_Code=@is_group 

				 /* -- Syn_Deal_Rights_Dubbing
				 */
				 INSERT INTO Syn_Deal_Rights_Dubbing(Syn_Deal_Rights_Code
					,Language_Type
					,Language_Code,Language_Group_Code
				 )
				 SELECT
						@Syn_Deal_Rights_Code,Language_Type,Dubbing_Code,Case When Language_Group_Code > 0 Then Language_Group_Code Else Null End
				 FROM @Syn_Deal_Rights_Dubbing_PB
				 WHERE Deal_Rights_Code=@is_group 

			 END
		END
		FETCH NEXT FROM CUR_DMR_ADR_GROUP INTO  @is_group,@is_original_language_rights
											,@is_sub_license
											,@right_period_for
											,@IsTentative
											,@term
											,@right_start_date
											,@right_end_date
											,@IsRightsofFirstRefusal
											,@FirstRefusalDate
											,@Effective_Start_Date
											--,@Actual_Right_start_Date
											--,@Actual_Right_End_Date
											,@inserted_by
											,@inserted_on
											,@last_updated_time
											,@last_action_by
											,@Is_Exclusive
											,@Sub_License_Code
											,@Is_Theatrical_Right
											,@Milestone_Type_Code
											,@Milestone_No_Of_Unit
											,@Milestone_Unit_Type
											,@Restriction_Remarks
											,@is_Pushback
											,@run_type
											,@no_of_runs
											,@is_yearwise_definition
											,@is_rule_right
											,@right_rule_code
											--,@PlatformCode
	END
	CLOSE CUR_DMR_ADR_GROUP
	DEALLOCATE CUR_DMR_ADR_GROUP
	END
	
	--print 'REGION INSERT INTO REVENUE'
	BEGIN---REGION INSERT INTO REVENUE / 
	
	DECLARE @Syn_Deal_Revenue_Title Deal_Rights_Title
	INSERT INTO @Syn_Deal_Revenue_Title (Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
	
	SELECT is_group,titNew.Title_Code,@eps_start,@eps_end
	FROM Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie sdm
	Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit on sdm.title_code = tit.title_code
	Inner Join Title titNew On tit.english_title = titNew.Title_Name
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost SDMC ON SDM.syndication_deal_movie_code=SDMC.syndication_deal_movie_code
	--left join Rightsu_vmpl_live_27March_2015.dbo.Cost_Center c on c.cost_center_id=sdmc.cost_center_id
	--left join Cost_Center cNew on cNew.Cost_Center_Name=c.Cost_Center_Name
	--inner join Rightsu_vmpl_live_27March_2015.dbo.Currency curr on sdmc.currency_code=curr.currency_code
	--inner join Currency currNew on currNew.Currency_Name=curr.currency_name
	WHERE SDM.syndication_deal_code=@SYN_DEALCODE
	GROUP BY is_group,titNew.Title_Code, no_of_episode
	
	--DEALLOCATE CR_SYN_COST
	DECLARE CR_SYN_COST CURSOR
	READ_ONLY
	FOR Select 
		--sdmc.syndication_deal_movie_code,
		currnew.currency_code,
		sdmc.exchange_rate,
		deal_movie_cost,
		deal_movie_cost_per_episode,
		cnew.cost_center_id,
		sd.Inserted_On,
		sd.Inserted_By,
		sd.Last_Updated_Time,
		sd.Last_Action_By,
		additional_cost,
		catchup_cost,
		variable_cost_type,
		variable_cost_sharing_type
		,is_group 
		--,sdmc.syn_deal_movie_cost_code
	FROM Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost sdmc
	inner join Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie sdm on sdm.syndication_deal_movie_code=sdmc.syndication_deal_movie_code
	inner join Rightsu_vmpl_live_27March_2015.dbo.syndication_deal sd on sdm.syndication_deal_code=sd.syndication_deal_code
	inner join Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost_platform_distribution sdmcpd on sdmcpd.syn_deal_movie_cost_code=sdmc.syn_deal_movie_cost_code
	left join Rightsu_vmpl_live_27March_2015.dbo.Cost_Center c on c.cost_center_id=sdmc.cost_center_id
	left join Cost_Center cNew on cNew.Cost_Center_Name=c.Cost_Center_Name
	inner join Rightsu_vmpl_live_27March_2015.dbo.Currency curr on sdmc.currency_code=curr.currency_code
	inner join Currency currNew on currNew.Currency_Name=curr.currency_name
	WHERE sd.syndication_deal_code=@SYN_DEALCODE
	group by 
		currNew.currency_code,
		sdmc.exchange_rate,
		deal_movie_cost,
		deal_movie_cost_per_episode,
		cnew.Cost_Center_Id,
		additional_cost,
		catchup_cost,
		variable_cost_type,
		variable_cost_sharing_type
		,is_group ,
		sd.Inserted_On,
		sd.Inserted_By,
		sd.Last_Updated_Time,
		sd.Last_Action_By

	DECLARE @currency_code int,@exchange_rate decimal,@deal_movie_cost decimal,@deal_movie_cost_per_episode decimal,@cost_center_id int,
	@C_Inserted_On datetime,@C_Inserted_By int,@C_Last_Updated_Time datetime,@C_Last_Action_By int,@additional_cost decimal,@catchup_cost decimal,@variable_cost_type char,
	@variable_cost_sharing_type char

	OPEN CR_SYN_COST

	FETCH NEXT FROM CR_SYN_COST INTO @currency_code,@exchange_rate,@deal_movie_cost,@deal_movie_cost_per_episode,@cost_center_id,@C_Inserted_On,
	@C_Inserted_By,@C_Last_Updated_Time,@C_Last_Action_By,@additional_cost,@catchup_cost,@variable_cost_type,@variable_cost_sharing_type,@is_group
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

			/*----Syn_Deal_Revenue*/
			Insert into Syn_Deal_Revenue(
			Syn_Deal_Code,Currency_Code,Currency_Exchange_Rate,
			Deal_Cost,Deal_Cost_Per_Episode,Cost_Center_Id,
			Additional_Cost,Catchup_Cost,Variable_Cost_Type,Variable_Cost_Sharing_Type,
			Royalty_Recoupment_Code,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
			select @SYN_Deal_Code,@currency_code,@exchange_rate,@deal_movie_cost,@deal_movie_cost_per_episode,@cost_center_id,
			@additional_cost,@catchup_cost,@variable_cost_type,@variable_cost_sharing_type,
			null Royalty_Recoupment_Code,@C_Inserted_On,@C_Inserted_By,@C_Last_Updated_Time,@C_Last_Action_By

			SELECT @Syn_Deal_Revenue_Code=SCOPE_IDENTITY()
			--IF(@dbug='D') SELECT @Syn_Deal_Revenue_Code Syn_Deal_Revenue_Code
						
			 /* -- Syn_Deal_Revenue_Title*/
			 INSERT INTO Syn_Deal_Revenue_Title(
			 Syn_Deal_Revenue_Code,Title_Code,Episode_From,Episode_To)
			 SELECT 
				 @Syn_Deal_Revenue_Code Syn_Deal_Revenue_Code,Title_Code,Episode_From,Episode_To
			 FROM @Syn_Deal_Revenue_Title
			 WHERE Deal_Rights_Code =@is_group 

			 /*----Syn_Deal_Revenue_Additional_Exp---*/
			 Insert into  Syn_Deal_Revenue_Additional_Exp
			 (Syn_Deal_Revenue_Code,Additional_Expense_Code,Amount,Min_Max,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
			 select @Syn_Deal_Revenue_Code,aNew.additional_expense_code,amount,min_max,@c_Inserted_On,@c_Inserted_By,@c_Last_Updated_Time,@c_Last_Action_By
			 from   Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost_additional_exp  sdmca
			 inner join Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost dmc on dmc.syn_deal_movie_cost_code=sdmca.syn_deal_movie_cost_code
			 inner join Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie dm on dm.syndication_deal_movie_code=dmc.syndication_deal_movie_code
			 inner join Rightsu_vmpl_live_27March_2015.dbo.Additional_Expense a on a.additional_expense_code= sdmca.additional_expense_code
			 inner join Additional_Expense aNew (NOLOCK) on anew.Additional_Expense_Name=a.additional_expense_name
			 where dm.syndication_deal_code=@Syn_DEALCODE and dmc.is_group=@is_group
			 group by aNew.additional_expense_code,amount,min_max

			 /*---Syn_Deal_Revenue_Commission---*/
			 Insert into Syn_Deal_Revenue_Commission
			 (Syn_Deal_Revenue_Code,Cost_Type_Code,Royalty_Commission_Code,Vendor_Code,Type,Commission_Type,Percentage,Amount,Entity_Code)
			 Select @Syn_Deal_Revenue_Code,ctNew.cost_type_code,royalty_commission_code,vNew.vendor_code,type,commission_type,percentage,amount,eNew.Entity_Code
			 from  Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost_commission sdmcc
			 inner join Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost dmc on dmc.syn_deal_movie_cost_code=sdmcc.syn_deal_movie_cost_code
			 inner join Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie dm on dm.syndication_deal_movie_code=dmc.syndication_deal_movie_code
			 left join Rightsu_vmpl_live_27March_2015.dbo.Cost_Type ct on ct.cost_type_code=sdmcc.cost_type_code
			 left join Cost_Type ctNew (NOLOCK) on ct.cost_type_name=ctNew.cost_type_name
			 left join Rightsu_vmpl_live_27March_2015.dbo.Entity e on e.entity_code=sdmcc.vendor_code
			 left join Entity eNew (NOLOCK) on e.entity_name=eNew.Entity_Name
			 left join Rightsu_vmpl_live_27March_2015.dbo.Vendor v on v.vendor_code=sdmcc.vendor_code
			 left join Vendor vNew (NOLOCK) on v.vendor_name=vNew.vendor_name
			 where dm.syndication_deal_code=@Syn_DEALCODE and dmc.is_group=@is_group
			 group by ctNew.cost_type_code,royalty_commission_code,vNew.vendor_code,type,commission_type,percentage,amount,eNew.Entity_Code

			-- /*---Syn_Deal_Revenue_Platform---*/
			-- Insert into Syn_Deal_Revenue_Platform (Syn_Deal_Revenue_Code,Platform_Code)
			--select @Syn_Deal_Revenue_Code,pNew.platform_code from Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost_platform_distribution sdmcpd
			--Inner join Rightsu_vmpl_live_27March_2015.dbo.Platform p on p.platform_code=sdmcpd.platform_code
			--inner join Platform pNew on pNew.Platform_Name=p.Platform_Name and pNew.Platform_Hiearachy=p.Platform_Hiearachy
			--where syn_deal_movie_cost_code=@syn_deal_movie_cost_code
			--and syndication_deal_movie_code=@syndication_deal_movie_code

			/*---Syn_Deal_Revenue_Variable_Cost---*/
			Insert into Syn_Deal_Revenue_Variable_Cost(Syn_Deal_Revenue_Code,Vendor_Code,Percentage,Amount,Inserted_On,Inserted_By,Last_Updated_Time
			,Last_Action_By,Entity_Code)
			select @Syn_Deal_Revenue_Code,vNew.Vendor_Code,percentage,amount,@c_Inserted_On,@c_Inserted_By,@c_Last_Updated_Time,@c_Last_Action_By
			,eNew.Entity_Code
			 from Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost_variable_cost sdmcvc
			 inner join Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost dmc on dmc.syn_deal_movie_cost_code=sdmcvc.syn_deal_movie_cost_code
			 inner join Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie dm on dm.syndication_deal_movie_code=dmc.syndication_deal_movie_code
			left join Rightsu_vmpl_live_27March_2015.dbo.Entity e on e.entity_code=sdmcvc.licensr_code
			left join Entity eNew (NOLOCK) on e.entity_name=eNew.Entity_Name
			left join Rightsu_vmpl_live_27March_2015.dbo.Vendor v on v.vendor_code=sdmcvc.licensr_code
			left join Vendor vNew (NOLOCK)on v.vendor_name=vNew.vendor_name
			where dm.syndication_deal_code=@Syn_DEALCODE and dmc.is_group=@is_group
			group by vNew.Vendor_Code,percentage,amount,eNew.Entity_Code

			/*----Syn_Deal_Revenue_Costtype---*/
			Insert into Syn_Deal_Revenue_Costtype(Syn_Deal_Revenue_Code,Cost_Type_Code,Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By,Consumed_Amount)
			select @Syn_Deal_Revenue_Code,cNew.cost_type_code,amount,@c_Inserted_On,@c_Inserted_By,@c_Last_Updated_Time,@c_Last_Action_By,0
			from Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost_costtype sdmcc
			inner join Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost dmc on dmc.syn_deal_movie_cost_code=sdmcc.syn_deal_movie_cost_code
			 inner join Rightsu_vmpl_live_27March_2015.dbo.syndication_deal_movie dm on dm.syndication_deal_movie_code=dmc.syndication_deal_movie_code
			inner join Rightsu_vmpl_live_27March_2015.dbo.Cost_Type c on c.cost_type_code=sdmcc.cost_type_code
			inner join Cost_Type cNew (NOLOCK) on cNew.Cost_Type_Name=c.Cost_Type_Name
			where dm.syndication_deal_code=@Syn_DEALCODE and dmc.is_group=@is_group
			group by cNew.cost_type_code,amount


		END
		FETCH NEXT FROM CR_SYN_COST INTO @currency_code,@exchange_rate,@deal_movie_cost,@deal_movie_cost_per_episode,@cost_center_id,@C_Inserted_On,
	@C_Inserted_By,@C_Last_Updated_Time,@C_Last_Action_By,@additional_cost,@catchup_cost,@variable_cost_type,@variable_cost_sharing_type,@is_group
	END

	CLOSE CR_SYN_COST
	DEALLOCATE CR_SYN_COST
	
	END
	Declare @Is_Error Varchar(10) = ''
	
	Exec USP_AT_Syn_Deal @SYN_Deal_Code, @Is_Error Out

	/* Syn_Deal_Rights_Title_EPS
	*/
	Declare @Syn_Deal_Rights_Title_Code Int = 0
	Declare cur_tit Cursor For 
		Select Syn_Deal_Rights_Title_Code From Syn_Deal_Rights_Title
	Open cur_tit
	Fetch Next From cur_tit InTo @Syn_Deal_Rights_Title_Code
	While (@@FETCH_STATUS = 0)
	Begin
		--Print @Syn_Deal_Rights_Title_Code
		Update Syn_Deal_Rights_Title Set Episode_From = Episode_From Where Syn_Deal_Rights_Title_Code = @Syn_Deal_Rights_Title_Code
		Fetch Next From cur_tit InTo @Syn_Deal_Rights_Title_Code
	End
	Close cur_tit
	Deallocate cur_tit

	/* Module_Status_History
	*/
	Insert InTo Module_Status_History (Module_Code,Record_Code,Status,Status_Changed_By,Status_Changed_On,Remarks)
	select module_code,@SYN_Deal_Code,
	CASE WHEN (case when CHARINDEX('~',status,0) =0 then status else substring(status,0,CHARINDEX('~',status,0)) end)='S' then 'W' 
	WHEN (case when CHARINDEX('~',status,0) =0 then status else substring(status,0,CHARINDEX('~',status,0)) end)='RS' then 'E'
	else (case when CHARINDEX('~',status,0) =0 then status else substring(status,0,CHARINDEX('~',status,0)) end) end
	,status_changed_by,status_changed_on,remarks from 
	Rightsu_vmpl_live_27March_2015.dbo.Module_Status_History where 
	Record_Code=@SYN_DEALCODE and module_code=35

	Insert InTo Module_Status_History (Module_Code,Record_Code,Status,Status_Changed_By,Status_Changed_On,Remarks)
	select module_code,@SYN_Deal_Code,'W',status_changed_by,status_changed_on,remarks from 
	Rightsu_vmpl_live_27March_2015.dbo.Module_Status_History where 
	Record_Code=@SYN_DEALCODE and module_code=35
	and (case when CHARINDEX('~',status,0) =0 then status else substring(status,0,CHARINDEX('~',status,0)) end)='RS' 
	
	insert into Module_Workflow_Detail (Module_Code,Record_Code,Group_Code,Primary_User_Code,Role_Level,Is_Done,Next_Level_Group,Entry_Date)
	select Module_Code,@SYN_Deal_Code,Group_Code,Primary_User_Code,Role_Level,Is_Done,Next_Level_Group,Entry_Date 
	from Rightsu_vmpl_live_27March_2015.dbo.Module_Workflow_Detail 
	where module_code=35 and record_code=@SYN_DEALCODE


	DROP TABLE #Exclusive_Group
	DROP TABLE #tmpCountry		 
	-- TEMP
	--UPDATE Syn_Deal SET Year_Type='DY'
	--UPDATE Syn_Deal_Run SET Primary_Channel_Code=null --Commented by Reshma
	--UPDATE Syn_Deal_Rights SET Is_Title_Language_Right='Y' 
	END
END TRY
BEGIN CATCH
	--CLOSE CUR_DMA_ADA
	--DEALLOCATE CUR_DMA_ADA

	--CLOSE CUR_DMRR_ADR
	--DEALLOCATE CUR_DMRR_ADR

	--CLOSE CUR_DMR_ADR_GROUP
	--DEALLOCATE CUR_DMR_ADR_GROUP
	
	--CLOSE CUR_DRRHB_ADP
	--DEALLOCATE CUR_DRRHB_ADP
	
	--Close CUR_Sport
	--Deallocate CUR_Sport
	ROLLBACK TRAN

	DECLARE @ErrorMessage NVARCHAR(4000);
    DECLARE @ErrorSeverity INT;
    DECLARE @ErrorState INT;
 
    SELECT @ErrorMessage = ERROR_MESSAGE(),
           @ErrorSeverity = ERROR_SEVERITY(),
           @ErrorState = ERROR_STATE();

	INSERT INTO DM_ErrDeal(ErrorMessage,ErrorSeverity,ErrorState,DEAL_CODE)
	SELECT @ErrorMessage ErrorMessage,
           @ErrorSeverity ErrorSeverity,
           @ErrorState ErrorState,
		   @SYN_DEALCODE
	RETURN
END CATCH

COMMIT TRAN
/*

Select * FROM DM_ErrDeal
CREATE TABLE DM_ErrDeal
(
	ErrorMessage NVARCHAR(4000),
    ErrorSeverity INT,
    ErrorState INT,
	DEAL_CODE INT
)

USP_MIGRATE_TO_NEW


--Deal Code --> Acq_Deal
--Deal Movie Code --> ACq_Deal_MOvie
--Group COde --> all dealmovies within deal -->Acq_Deal_Movie_Rights (LOOP)
	--BEGIN  LOOP
		--SINGLE INSERT --> ACq_Deal_Rights
			-- --> ACq_Deal_Rights_Title with @ACq_Deal_Rights_Code
			-- --> ACq_Deal_Rights_PLatform with @ACq_Deal_Rights_Code
	--END LOOP


RETURN



*/

 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_MIGRATE_TO_NEW_Syndication]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
