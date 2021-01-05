CREATE PROC [dbo].[USP_MIGRATE_TO_NEW]
(	
	@DEALCODE INT=0,
	@dBug CHAR(1)='N'
)
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 06-November-2014
-- Description: SP to migrate ACQL Deals from OLD to NEW DB STructure
-- Modified By- Reshma Kunjal
-- Create DATE: Feb-2015
-- =============================================
BEGIN


BEGIN TRAN

	DECLARE @Acq_Deal_Code INT,@Acq_Deal_Rights_Code INT,@Acq_Deal_Pushback_Code INT,@Acq_Deal_Run_Code INT,@Acq_Deal_Ancillary_Code INT, @Excel_Deal_Code Int = 0, @Business_unit_code Int = 0
	,@Acq_Deal_Rights_HoldBack_Code INT,@Acq_Deal_Rights_Blackout_Code INT
	,@Acq_Deal_Cost_Code int

	select top 1 @Business_unit_code =Business_Unit_Code from Business_Unit
	--ROLLBACK TRAN
	--RETURN

BEGIN TRY

	--PRINT 'REGION INSERT INTO AD / ADM / ADL'
	BEGIN -- REGION INSERT INTO AD / ADM / ADL
	/* -- ACQ_Deal
	*/
	INSERT INTO Acq_Deal 
	(Agreement_No,Version,Agreement_Date
	,Deal_Desc,Deal_Type_Code,Year_Type
	,Entity_Code
	,Is_Master_Deal
	,Category_Code
	,Vendor_Code,Vendor_Contacts_Code,Currency_Code
	,Exchange_Rate,Ref_No,Attach_Workflow
	,Deal_Workflow_Status,Parent_Deal_Code
	,Work_Flow_Code
	,Amendment_Date,Is_Released,Release_On
	,Release_By,Is_Completed,Is_Active
	,Content_Type,Payment_Terms_Conditions,Status
	,Is_Auto_Generated,Is_Migrated,Cost_Center_Id
	,Master_Deal_Movie_Code_ToLink,BudgetWise_Costing_Applicable
	,Validate_CostWith_Budget,Deal_Tag_Code,Remarks
	,Inserted_By,Inserted_On,Last_Updated_Time
	,Last_Action_By,Lock_Time,Business_Unit_Code
	,Ref_BMS_Code,Rights_Remarks,Payment_Remarks
	,Deal_Complete_Flag,All_Channel)
	SELECT 
	d.deal_no
	--dbo.UFN_Auto_Genrate_Agreement_No('A', deal_signed_date, 0)
	,d.version,d.deal_signed_date
	,d.deal_desc,dtnew.deal_type_code,d.year_type
	,d.entity_code
	,CASE WHEN d.deal_type='M' THEN 'Y' ELSE 'N' END Is_Master_Deal
	,cnew.category_code
	, vNew.Vendor_Code ,d.customer_contact_code, currnew.currency_code -- Temp Indian Currency -- Party -- HC
	,d.exchange_rate,d.ref_no,d.attach_workflow
	,case when d.deal_workflow_status='S' then 'W'
	 when d.deal_workflow_status='RS' then 'W'
	 when d.deal_workflow_status='AM' then 'AM'
	 else left(d.deal_workflow_status,1) end ,d.parent_deal_code
	-- TEMP Top 1 
	,(SELECT TOP 1 Workflow_Code FROM Workflow_Module W WHERE W.Business_Unit_Code=Business_Unit_Code AND System_End_Date IS NULL) work_flow_code  -- HC
	,d.amendment_date,d.is_released,d.release_on
	,d.release_by,d.is_completed,d.is_active
	,d.content_type,d.payment_terms_conditions,d.status
	,d.Is_Auto_generated,d.is_migrated,d.cost_center_id
	,d.MasterDealMovieCode_ToLink,d.BudgetWiseCostingApplicable
	,d.ValidateCostWithBudget,d.Deal_Tag_Code,d.remarks
	,d.inserted_by,d.Inserted_On,d.last_updated_time
	,d.last_action_by,d.lock_time,@Business_unit_code
	,0 Ref_BMS_Code,''Rights_Remarks,''Payment_Remarks
	,'R,C' Deal_Complete_Flag,'' All_Channel
	FROM Rightsu_vmpl_live_27March_2015.dbo.deal  D
	Inner Join Rightsu_vmpl_live_27March_2015.dbo.Vendor v On d.customer_code = v.vendor_code
		Inner Join Vendor vNew On vNew.Vendor_Name = v.vendor_name
	---Category , Currency,Payment Terms, Entity---
	Inner join Rightsu_vmpl_live_27March_2015.dbo.Category c on d.category_code=c.category_code
	inner join Category cNew on cNew.Category_Name=c.category_name
	inner join Rightsu_vmpl_live_27March_2015.dbo.Currency curr on d.currency_code=curr.currency_code
	inner join Currency currNew on currNew.Currency_Name=curr.currency_name
	inner join Rightsu_vmpl_live_27March_2015.dbo.Deal_Type dt on d.deal_for_code=dt.deal_type_code
	inner join Deal_Type dtNew on dtNew.Deal_Type_Name=dt.Deal_Type_Name
	---Category , Currency,Payment Terms---
	WHERE d.deal_code=@DEALCODE

	/*Update Content Type*/	
	Update Acq_Deal
	SET Role_Code = (Select Role_Code FROM Role WHERE Role_Name = 'Assignment')
	WHERE Content_Type = 'A'

	Update Acq_Deal
	SET Role_Code = (Select Role_Code FROM Role WHERE Role_Name = 'License')
	WHERE Content_Type = 'L'

	Update Acq_Deal
	SET Role_Code = (Select Role_Code FROM Role WHERE Role_Name = 'Own Production')
	WHERE Content_Type = 'O'


	SELECT @Acq_Deal_Code=SCOPE_IDENTITY() 
	--IF(@dBug='D')SELECT @Acq_Deal_Code Acq_Deal_Code

	/* -- Acq_Deal_Movie
	*/
	INSERT INTO  Acq_Deal_Movie
	 (Acq_Deal_Code
	,Title_Code,No_Of_Episodes,Notes
	,No_Of_Files,Is_Closed,Title_Type
	,Amort_Type,Episode_Starts_From,Closing_Remarks
	,Movie_Closed_Date,Remark,Inserted_By
	,Inserted_On,Last_UpDated_Time,Last_Action_By
	,Ref_BMS_Movie_Code,Episode_End_To)
	SELECT 
	 @Acq_Deal_Code deal_code
	,titNew.Title_Code,0,notes
	,no_of_files,is_closed,DealMovieType
	,AmortType,episode_starts_from,Closing_remarks
	,Movie_Closed_Date,Remark,dm.inserted_by
	,dm.Inserted_On,dm.last_updated_time,dm.last_action_by
	,0 Ref_BMS_Movie_Code,episode_starts_from
	FROM Rightsu_vmpl_live_27March_2015.dbo.deal_movie dm
	inner join Rightsu_vmpl_live_27March_2015.dbo.deal d on d.deal_code=dm.deal_code
	Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit on dm.title_code = tit.title_code  
	Inner Join Title titNew On tit.english_title = titNew.Title_Name and 
	((d.deal_type='M' and titnew.Reference_Flag is null) or (d.deal_type='S' and titnew.Reference_Flag ='T'))--titNew.deal_type_code=tit.dealtype_code
	WHERE d.Deal_Code=@DEALCODE

	/*UPDATE RIGHTS REMARKS IN ACQ DEAL*/
	Update ad set ad.Rights_Remarks=adm.Remark
	from Acq_deal_movie adm 
	inner join Acq_Deal ad on ad.Acq_Deal_Code=adm.Acq_Deal_Code
	where adm.acq_Deal_code=@Acq_Deal_Code
	
	/*--Acq_Deal_Licensor
	*/
	INSERT INTO Acq_Deal_Licensor
	(Acq_Deal_Code,Vendor_Code)
	SELECT 
		@Acq_Deal_Code, vNew.vendor_code
	FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Licensor D
	Inner Join Rightsu_vmpl_live_27March_2015.dbo.Vendor v On d.licensor_customer_code = v.vendor_code
	Inner Join Vendor vNew On vNew.Vendor_Name = v.vendor_name
	WHERE Deal_Code=@DEALCODE
	
	END
	

	------------------------UPDATE Master_Deal_Movie_Code_ToLink
	--Update adOld
	--set adOld.Master_Deal_Movie_Code_ToLink=adm.Acq_Deal_Movie_Code
	----select adOld.Master_Deal_Movie_Code_ToLink,adOld.Agreement_No,ad.Agreement_No Parent_new,d.deal_no Parent_Old,t.english_title,tnew.Title_Name,*
	--from Acq_Deal adOld
	--inner join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie dm on adOld.Master_Deal_Movie_Code_ToLink=dm.Deal_Movie_Code
	--inner join Rightsu_vmpl_live_27March_2015.dbo.Title t on t.Title_Code=dm.Title_Code 
	--inner join Title tNew on tNew.Title_Name=t.english_title  and tnew.Reference_Flag is null
	--inner join Acq_Deal_Movie adm on adm.Title_Code=tnew.Title_Code
	--inner join Acq_Deal ad on adm.Acq_Deal_Code=ad.Acq_Deal_Code and ad.Agreement_No=substring(adOld.Agreement_No,0,13)
	--where isnull(adOld.Master_Deal_Movie_Code_ToLink,0)>0 
	--and adOld.acq_Deal_code=@Acq_Deal_Code 
	--and adOld.Is_Master_Deal='Y'


	--Update adOld
	--set adOld.Master_Deal_Movie_Code_ToLink=adm.Acq_Deal_Movie_Code
	--select Distinct adOld.Master_Deal_Movie_Code_ToLink,adm.Acq_Deal_Movie_Code

	--Select * From Acq_Deal Where Is_Master_Deal='N' 


	--PRINT 'Acq_Deal_payment_terms '
	/*--- Acq_Deal_payment_terms ---*/
	INSERT INTO  Acq_Deal_Payment_Terms
	 (
		Acq_Deal_Code,
		Payment_Term_Code,
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
		@Acq_Deal_Code acq_deal_code,
		pnew.Payment_Terms_Code,
		days_after,
		per_cent,
		Due_Date,
		cnew.Cost_Type_Code,
		dpt.Inserted_On,
		dpt.Inserted_By,
		dpt.Last_Updated_Time,
		dpt.Last_Action_By
	FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Payment_Terms dpt
	Inner join Rightsu_vmpl_live_27March_2015.dbo.Payment_Terms p on dpt.payment_terms_code=p.payment_terms_code
	inner join Payment_Terms pNew on pNew.Payment_Terms=p.Payment_Terms
	inner join Rightsu_vmpl_live_27March_2015.dbo.Cost_Type c on c.cost_type_code=dpt.Cost_Type_Code
	inner join Cost_Type cNew on cNew.Cost_Type_Name=c.Cost_Type_Name
	WHERE deal_code=@DEALCODE
	order by dpt.deal_payment_terms_code
	/*---Acq_Deal_payment_terms ---*/

	--print 'REGION Rights Groupwise Exclusivity / Title / Platform / Territory / Subtitling / Dubbing'
	BEGIN -- REGION Rights Groupwise Exclusivity / Title / Platform / Territory / Subtitling / Dubbing
	
	/*--Exclusivity Group Wise
	*/
	CREATE TABLE #Exclusive_Group(
		is_group INT,
		Is_Exclusive CHAR(1)
	)
	INSERT INTO #Exclusive_Group(is_group,Is_Exclusive)
	SELECT dmr.is_group,is_exclusive
	FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Territory DMRT ON DMR.deal_movie_rights_code=DMRT.deal_movie_rights_code 
	WHERE DM.deal_code=@DEALCODE
	GROUP BY dmr.is_Group,is_exclusive
	ORDER BY dmr.is_Group
		    
	DECLARE @Acq_Deal_Rights_Title Deal_Rights_Title
	INSERT INTO @Acq_Deal_Rights_Title (Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
	SELECT is_group,titNew.Title_Code,episode_starts_from, episode_starts_from
	FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie dm
	inner join Rightsu_vmpl_live_27March_2015.dbo.Deal d on d.deal_code=dm.deal_code
	Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit on dm.title_code = tit.title_code 
	Inner Join Title titNew On tit.english_title = titNew.Title_Name 
	and ((d.deal_type='M' and titnew.Reference_Flag is null) or (d.deal_type='S' and titnew.Reference_Flag ='T'))--titNew.deal_type_code=tit.dealtype_code
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
	WHERE DM.deal_code=@DEALCODE
	GROUP BY is_group,titNew.Title_Code,episode_starts_from
 
	DECLARE @Acq_Deal_Rights_Platform Deal_Rights_Platform
	INSERT INTO @Acq_Deal_Rights_Platform (Deal_Rights_Code,Platform_Code)
	SELECT is_group,p.platform_code
	FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Platform p on p.platform_code=dmr.platform_code
	--inner join Platform pNew on p.platform_name=pNew.platform_name and p.Platform_Hiearachy=pNew.Platform_Hiearachy
	WHERE DM.deal_code=@DEALCODE	
	GROUP BY is_group,p.platform_code

	DECLARE @Acq_Deal_Rights_Territory Deal_Rights_Territory
	INSERT INTO @Acq_Deal_Rights_Territory (Deal_Rights_Code
	       ,Territory_Type,Country_Code,Territory_Code)
	SELECT dmr.is_group
		   ,territory_type,c.Country_Code,t.Territory_Code
	FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Territory DMRT ON DMR.deal_movie_rights_code=DMRT.deal_movie_rights_code 
	left join Rightsu_vmpl_live_27March_2015.dbo.International_Territory it on it.international_territory_code=dmrt.territory_code
	left join Country c on c.Country_Name=it.international_territory_name
	left join Rightsu_vmpl_live_27March_2015.dbo.territory_group tg on tg.territory_group_code=dmrt.territory_group_code
	left join Territory t on t.Territory_Name=tg.territory_group_name
	WHERE DM.deal_code=@DEALCODE	
	GROUP BY dmr.is_group,territory_type,c.Country_Code,t.Territory_Code
	ORDER BY dmr.is_group

	DECLARE @Acq_Deal_Rights_Subtitling Deal_Rights_Subtitling
	INSERT INTO @Acq_Deal_Rights_Subtitling(Deal_Rights_Code
			,Language_Type
			,Subtitling_Code,Language_Group_Code)
	SELECT dmr.is_group
		   ,CASE WHEN ISNULL(DMRS.language_code,0)>0 THEN 'L' ELSE 'G' END Language_Type
		   ,CASE WHEN ISNULL(DMRS.language_code,0)>0 THEN lnew.language_code else LGD.Language_Code end Language_Code
		   ,lgNew.Language_Group_Code
	FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Subtitling DMRS ON DMR.deal_movie_rights_code=DMRS.deal_movie_rights_code 
	left join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=dmrs.language_code
	left join Language lnew on lNew.Language_Name=l.Language_Name
	Left join Rightsu_vmpl_live_27March_2015.dbo.Language_Group lg on lg.Language_Group_Code=dmrs.Language_Group_Code
	Left join Language_Group lgNew on lgNew.Language_Group_Name=lg.Language_Group_Name
	LEFT JOIN Language_Group_Details LGD ON lgNew.Language_Group_Code=LGD.Language_Group_Code
	WHERE DM.deal_code=@DEALCODE	
	GROUP BY dmr.is_group,lNew.language_code,lgNew.Language_Group_Code,DMRS.language_code,LGD.Language_Code

	DECLARE @Acq_Deal_Rights_Dubbing Deal_Rights_Dubbing
	INSERT INTO @Acq_Deal_Rights_Dubbing(Deal_Rights_Code
			,Language_Type
			,Dubbing_Code,Language_Group_Code)
	SELECT dmr.is_group
		   ,CASE WHEN ISNULL(DMRD.language_code,0)>0 THEN 'L' ELSE 'G' END Language_Type
		   ,CASE WHEN ISNULL(DMRD.language_code,0)>0 THEN lnew.language_code else LGD.Language_Code end Language_Code
		   ,LGNew.Language_Group_Code
	FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Dubbing DMRD ON DMR.deal_movie_rights_code=DMRD.deal_movie_rights_code 
	left join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=dmrd.language_code
	left join Language lnew on lNew.Language_Name=l.Language_Name
	Left join Rightsu_vmpl_live_27March_2015.dbo.Language_Group lg on lg.Language_Group_Code=dmrd.Language_Group_Code
	Left join Language_Group lgNew on lgNew.Language_Group_Name=lg.Language_Group_Name
	LEFT JOIN Language_Group_Details LGD ON lgNew.Language_Group_Code=LGD.Language_Group_Code
	WHERE DM.deal_code=@DEALCODE	
	GROUP BY dmr.is_group,LNew.language_code,LGNew.Language_Group_Code,DMRD.language_code,LGD.Language_Code
	
	END
	
	--print 'REGION RUN Groupwise Run / Title / Channel / Repeat On Day / Yearwise Run'
	BEGIN -- REGION RUN Groupwise Run / Title / Channel / Repeat On Day / Yearwise Run
		DECLARE @Acq_Deal_Run_Title Deal_Run_Title
		INSERT INTO @Acq_Deal_Run_Title(
			Deal_Run_Code,Title_Code,Episode_From,Episode_To
		)
		SELECT 
			run_definition_group_code,titNew.Title_Code,episode_starts_from, episode_starts_from
		FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie dm
		inner join Rightsu_vmpl_live_27March_2015.dbo.Deal d on d.deal_code=dm.deal_code
		Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit1 on dm.title_code = tit1.title_code  
		Inner Join Title titNew On tit1.english_title = titNew.Title_Name and titNew.deal_type_code=tit1.dealtype_code
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR ON DMR.deal_movie_rights_code=DMRR.deal_movie_rights_code
		WHERE DM.deal_code=@DEALCODE And titNew.Title_Code Not In (
			Select tit.Title_Code From DM_Runs_Allocation dmr
			Inner Join Title tit On dmr.Title = tit.Title_Name 
			Where dmr.[Acquisition Deal No] = @Excel_Deal_Code
		)
		GROUP BY run_definition_group_code,titNew.Title_Code,episode_starts_from
		
		DECLARE @Acq_Deal_Run_Channel Deal_Run_Channel
		INSERT INTO @Acq_Deal_Run_Channel(
			 Deal_Run_Code
			,Channel_Code
			,Min_Runs,Max_Runs
			,No_Of_Runs_Sched,No_Of_AsRuns
			,Do_Not_Consume_Rights,Is_Primary
			,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
		)
		SELECT 
			 DMRR.run_definition_group_code
			,cnew.Channel_Code
			,Min_Runs,Max_Runs
			,DMRRC.No_Of_Runs_Sched,DMRRC.No_Of_AsRuns
			,Do_Not_Consume_Rights,DMRRC.IsPrimary
			,143 Inserted_By,getdate() Inserted_On,null Last_action_By,null Last_updated_Time
		FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM		
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR ON DMR.deal_movie_rights_code=DMRR.deal_movie_rights_code
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run_Channel DMRRC ON DMRRC.deal_movie_rights_run_code=DMRR.deal_movie_rights_run_code
		left join Rightsu_vmpl_live_27March_2015.dbo.Channel c on c.channel_code=DMRRC.channel_code
		left join Channel cNew on c.channel_name=cnew.channel_name
		WHERE DM.deal_code=@DEALCODE
		GROUP BY DMRR.run_definition_group_code,
			 cnew.Channel_Code
			,Min_Runs
			,Max_Runs
			,DMRRC.No_Of_Runs_Sched
			,DMRRC.No_Of_AsRuns
			,Do_Not_Consume_Rights
			,DMRRC.IsPrimary
	 ORDER BY run_definition_group_code,channel_code

		DECLARE @Acq_Deal_Run_Repeat_On_Day Deal_Run_Repeat_On_Day
		INSERT INTO @Acq_Deal_Run_Repeat_On_Day(
			Deal_Run_Code,Day_Code
		)
		SELECT 
			 DMRR.run_definition_group_code,Day_Code
		FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM		
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR ON DMR.deal_movie_rights_code=DMRR.deal_movie_rights_code
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run_Repeat_On_Day DMRRC ON DMRRC.deal_movie_rights_run_code=DMRR.deal_movie_rights_run_code
		WHERE DM.deal_code=@DEALCODE
	 GROUP BY DMRR.run_definition_group_code,Day_Code

		DECLARE @Acq_Deal_Run_Yearwise_Run Deal_Run_Yearwise_Run
		INSERT INTO @Acq_Deal_Run_Yearwise_Run(
			Deal_Run_Code
			,Start_Date,End_Date,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns
			,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
		)
		SELECT 
			 DMRR.run_definition_group_code
			 ,Start_Date,End_Date,DMRRC.No_Of_Runs,DMRRC.No_Of_Runs_Sched,DMRRC.No_Of_AsRuns
			 ,143 Inserted_By,getdate() Inserted_On,null Last_action_By, null Last_updated_Time
		FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM		
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR ON DMR.deal_movie_rights_code=DMRR.deal_movie_rights_code
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run_Yearwise_Run DMRRC ON DMRRC.deal_movie_rights_run_code=DMRR.deal_movie_rights_run_code
	WHERE DM.deal_code=@DEALCODE
	GROUP BY DMRR.run_definition_group_code,Start_Date,End_Date,DMRRC.No_Of_Runs,DMRRC.No_Of_Runs_Sched,DMRRC.No_Of_AsRuns
	END
	
	--print 'REGION Ancillary Groupwise Title / Platform / Platform_Medium'
	BEGIN -- REGION Ancillary Groupwise Title / Platform / Platform_Medium
		/*SELECT * FROM Acq_Deal_Ancillary
		SELECT AP.Ancillary_Type_code,DMA.Ancillary_Platform_code,Duration,[Day],Remarks,Group_No 
		FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Ancillary DMA
		INNER JOIN  Rightsu_vmpl_live_27March_2015.dbo.Ancillary_Platform AP ON AP.Ancillary_Platform_code=DMA.Ancillary_Platform_code
		INNER JOIN  Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM ON DM.deal_movie_code=DMA.deal_movie_code 
		WHERE deal_code=@DealCode
		GROUP BY DMA.Ancillary_Platform_code,Duration,[Day],Remarks,Group_No,AP.Ancillary_Type_code
		*/
		DECLARE @Acq_Deal_Ancillary_Title Ancillary_Title
		INSERT INTO @Acq_Deal_Ancillary_Title(
				Deal_Ancillary_Code,Title_Code,Episode_From,Episode_To
		)
		SELECT Group_No,titNew.Title_Code,episode_starts_from, episode_starts_from
		FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Ancillary DMA
		INNER JOIN  Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM ON DM.deal_movie_code=DMA.deal_movie_code
		INNER JOIN  Rightsu_vmpl_live_27March_2015.dbo.Deal D ON D.deal_code=DM.deal_code
		Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit1 on dm.title_code = tit1.title_code 
		Inner Join Title titNew On tit1.english_title = titNew.Title_Name 
		and ((d.deal_type='M' and titnew.Reference_Flag is null) or (d.deal_type='S' and titnew.Reference_Flag ='T'))--titNew.deal_type_code=tit.dealtype_code
		WHERE dm.deal_code=@DealCode
		GROUP BY Group_No,titNew.Title_Code,episode_starts_from
		
		DECLARE @Acq_Deal_Ancillary_Platform Ancillary_Platform
		INSERT INTO @Acq_Deal_Ancillary_Platform(
				Deal_Ancillary_Code,Ancillary_Platform_code
		)
		SELECT Group_No,Ancillary_Platform_code
		FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Ancillary DMA
		INNER JOIN  Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM ON DM.deal_movie_code=DMA.deal_movie_code 
		WHERE deal_code=@DealCode
		GROUP BY Group_No,Ancillary_Platform_code
		
		DECLARE @Acq_Deal_Ancillary_Platform_Medium Ancillary_Platform_Medium
		INSERT INTO @Acq_Deal_Ancillary_Platform_Medium(
				Deal_Ancillary_Code,Ancillary_Platform_Medium_Code,Ancillary_Platform_Code
		)
		SELECT DMA.Group_No,DMAM.Ancillary_Platform_Medium_Code,DMA.Ancillary_Platform_code 
		FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Ancillary_Medium DMAM
		INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Ancillary DMA ON DMA.Deal_Movie_Ancillary_Code=DMAM.Deal_Movie_Ancillary_Code
		INNER JOIN  Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM ON DM.deal_movie_code=DMA.deal_movie_code 
		WHERE deal_code=@DealCode
		GROUP BY DMAM.Ancillary_Platform_Medium_Code,DMA.Group_No,DMA.Ancillary_Platform_code
		ORDER BY Group_No 
	END

	--print 'REGION CURSOR INSERT INTO ADA_Ancillary'
	BEGIN -- REGION CURSOR INSERT INTO ADA--chk
	DECLARE 
	 @Ancillary_Type_code int
	,@Duration numeric
	,@Day numeric
	,@Remarks NVARCHAR(max) = ''
	,@Group_No_ADA int

	DECLARE CUR_DMA_ADA CURSOR
	READ_ONLY
	FOR 
	SELECT DISTINCT AP.Ancillary_Type_code,Duration,ISNULL([Day],0),ISNULL(Remarks,''),Group_No 
		FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Ancillary DMA
		INNER JOIN  Rightsu_vmpl_live_27March_2015.dbo.Ancillary_Platform AP ON AP.Ancillary_Platform_code=DMA.Ancillary_Platform_code
		INNER JOIN  Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM ON DM.deal_movie_code=DMA.deal_movie_code 
		WHERE deal_code=@DEALCODE
	OPEN CUR_DMA_ADA	

	FETCH NEXT FROM CUR_DMA_ADA INTO 
					@Ancillary_Type_code,@Duration,@Day,@Remarks,@Group_No_ADA

	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			/* -- Acq_Deal_Ancillary
		     */
			INSERT INTO Acq_Deal_Ancillary(Acq_Deal_Code,Ancillary_Type_code,Duration,[Day],Remarks,Group_No)
			SELECT @Acq_Deal_Code Acq_Deal_Code,@Ancillary_Type_code,@Duration,@Day,@Remarks,@Group_No_ADA
			
			SELECT @Acq_Deal_Ancillary_Code=SCOPE_IDENTITY()
			--IF(@dBug='D')SELECT @Acq_Deal_Ancillary_Code Acq_Deal_Ancillary_Code
			
			-- Useful Comment: UDT Deal_Ancillary_Code=@Group_No_ADA
			/* -- Acq_Deal_Ancillary_Title
		     */
			 INSERT INTO Acq_Deal_Ancillary_Title(
				Acq_Deal_Ancillary_Code,Title_Code,Episode_From,Episode_To
			 )
			 SELECT @Acq_Deal_Ancillary_Code Acq_Deal_Ancillary_Code,Title_Code,Episode_From,Episode_To
			 FROM @Acq_Deal_Ancillary_Title
			 WHERE Deal_Ancillary_Code=@Group_No_ADA 

			 /* -- Acq_Deal_Ancillary_Platform
		     */
			 INSERT INTO Acq_Deal_Ancillary_Platform(
				Acq_Deal_Ancillary_Code,Ancillary_Platform_code
			 )
			 SELECT @Acq_Deal_Ancillary_Code Acq_Deal_Ancillary_Code,Ancillary_Platform_code
			 FROM @Acq_Deal_Ancillary_Platform
			 WHERE Deal_Ancillary_Code=@Group_No_ADA 

			 /* -- Acq_Deal_Ancillary_Platform_Medium
		     */
			 INSERT INTO Acq_Deal_Ancillary_Platform_Medium(
				Acq_Deal_Ancillary_Platform_Code,Ancillary_Platform_Medium_Code
			 )
			 SELECT DB.Acq_Deal_Ancillary_Platform_Code,TEMP.Ancillary_Platform_Medium_Code
			 FROM @Acq_Deal_Ancillary_Platform_Medium TEMP
			 INNER JOIN Acq_Deal_Ancillary_Platform DB ON DB.Ancillary_Platform_code=TEMP.Ancillary_Platform_code 
			 AND TEMP.Deal_Ancillary_Code=@Group_No_ADA And DB.Acq_Deal_Ancillary_Code = @Acq_Deal_Ancillary_Code

		END
		FETCH NEXT FROM CUR_DMA_ADA INTO 
					 @Ancillary_Type_code,@Duration,@Day,@Remarks,@Group_No_ADA					
	END
	CLOSE CUR_DMA_ADA
	DEALLOCATE CUR_DMA_ADA
	END
	
	--print 'REGION INSERT INTO CURSOR ADRR'
	BEGIN -- REGION INSERT INTO CURSOR ADRR
	
	--if(
	--	(
	--		Select Count(*) From DM_Runs_Allocation Where [Acquisition Deal No] In (
	--			Select Payment_Terms_Conditions From Acq_Deal Where Acq_Deal_Code = @Acq_Deal_Code
	--		)
	--	) < 1
	--)
	--Begin
	--if(
		--CLOSE CUR_DMRR_ADR
		--DEALLOCATE CUR_DMRR_ADR

		DECLARE 
		 @Run_Definition_Group_Code Varchar(1000) = ''
		,@Run_Title_Code Int
		,@Run_Type CHAR(1)
		,@No_Of_Runs int
		,@No_Of_Runs_Sched int
		,@No_Of_AsRuns int
		,@Is_Yearwise_Definition CHAR(1)
		,@Is_Rule_Right CHAR(1)
		,@Right_Rule_Code int
		,@Repeat_Within_Days_Hrs CHAR(1)
		,@No_Of_Days_Hrs int
		,@Is_Channel_Definition_Rights CHAR(1)
		,@Primary_Channel_Code int
		,@Run_Definition_Type CHAR(1)
		--,@Prime_Start_Time Time
		--,@Prime_End_Time Time
		--,@Off_Prime_Start_Time Time
		--,@Off_Prime_End_Time Time
		--,@Simulcast Time
		--,@Prime_Run Int
		--,@Off_Prime_Run Int
		,@counter Int = 0
		,@Episode_From Int = 0
		--,@Episode_To Int = 0

		If(@Business_unit_code = 2)
		Begin
			DECLARE CUR_DMRR_ADR CURSOR
			READ_ONLY
			FOR 
				SELECT distinct
					--STUFF(
					--		(
					--			Select Distinct ',' + CAST(DMRR1.run_definition_group_code as Varchar) From Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR1
					--			Inner Join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR1 ON DMR1.deal_movie_rights_code=DMRR1.deal_movie_rights_code
					--			Inner Join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM1 ON DMR1.deal_movie_code=DM1.deal_movie_code 
					--						And DM1.deal_code = @DEALCODE And IsNull(DMR1.right_start_date, GetDate()) = IsNull(DMR.right_start_date, getdate()) 
					--						And IsNull(DMR.right_end_date, getdate()) = isnull(DMR1.right_end_date, getdate())
					--						And DM1.title_code = DM.title_code
					--			FOR XML PATH('')
					--		), 1, 1, ''
					--	) as run_definition_group_code,DM.title_code,
					run_definition_group_code,titNew.Title_Code,
					DMRR.run_type,DMRR.no_of_runs
					,DMRR.no_of_runs_sched,no_of_AsRuns,DMRR.is_yearwise_definition
					,DMRR.is_rule_right,CASE WHEN DMRR.right_rule_code=0 THEN NULL ELSE DMRR.right_rule_code END,repeat_within_days_hrs
					,no_of_days_hrs,is_channel_definition_rights,primary_channel_code,DMRR.run_definition_type
					--,DMRR.Prime_Start_Time, DMRR.Prime_End_Time, DMRR.Off_Prime_Start_Time, DMRR.Off_Prime_End_Time, DMRR.Time_Lag_Simulcast
					--,Prime_Run, Off_Prime_Run
				FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie dm
				inner join Rightsu_vmpl_live_27March_2015.dbo.Deal d on d.deal_code=dm.deal_code
				Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit1 on dm.title_code = tit1.title_code 
				Inner Join Title titNew On tit1.english_title = titNew.Title_Name and titNew.deal_type_code=tit1.dealtype_code
				INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
				INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR ON DMR.deal_movie_rights_code=DMRR.deal_movie_rights_code
				WHERE DM.deal_code=@DEALCODE and titNew.Title_Code Not In (
					Select Title_Code From DM_Runs_Allocation dmr 
					Inner Join Title tit On dmr.Title = tit.Title_Name 
					Where dmr.[Acquisition Deal No] = @Excel_Deal_Code
				)
				GROUP BY
					run_definition_group_code, DMRR.run_type,DMRR.no_of_runs
					,DMRR.no_of_runs_sched,no_of_AsRuns,DMRR.is_yearwise_definition
					,DMRR.is_rule_right,DMRR.right_rule_code,repeat_within_days_hrs
					,no_of_days_hrs,is_channel_definition_rights,primary_channel_code,DMRR.run_definition_type, titNew.Title_Code
					,DMR.right_start_date, DMR.right_end_date
					--,DMRR.Prime_Start_Time, DMRR.Prime_End_Time, DMRR.Off_Prime_Start_Time, DMRR.Off_Prime_End_Time, DMRR.Time_Lag_Simulcast
					--,Prime_Run, Off_Prime_Run
		End
		Else
		Begin
			--print 'Else @Business_unit_code =0'
			
			DECLARE CUR_DMRR_ADR CURSOR
			READ_ONLY
			FOR
				SELECT distinct
					STUFF(
						(
							Select Distinct ',' + CAST(DMRR1.run_definition_group_code as Varchar) From Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR1
							Inner Join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR1 ON DMR1.deal_movie_rights_code=DMRR1.deal_movie_rights_code
							Inner Join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM1 ON DMR1.deal_movie_code=DM1.deal_movie_code 
									   And DM1.deal_code = @DEALCODE And IsNull(DMR1.right_start_date, GetDate()) = IsNull(DMR.right_start_date, getdate()) 
									   And IsNull(DMR.right_end_date, getdate()) = isnull(DMR1.right_end_date, getdate())
							FOR XML PATH('')
						), 1, 1, ''
					) as run_definition_group_code, 
					titNew.Title_Code,
					DMRR.run_type,DMRR.no_of_runs
					,DMRR.no_of_runs_sched,
					no_of_AsRuns,
					DMRR.is_yearwise_definition
					,DMRR.is_rule_right,
					CASE WHEN DMRR.right_rule_code=0 THEN NULL ELSE DMRR.right_rule_code END,
					repeat_within_days_hrs
					,no_of_days_hrs,
					is_channel_definition_rights,
					cnew.Channel_Code,
					DMRR.run_definition_type
					--,DMRR.Prime_Start_Time, DMRR.Prime_End_Time, DMRR.Off_Prime_Start_Time, DMRR.Off_Prime_End_Time, DMRR.Time_Lag_Simulcast
					--,Prime_Run, Off_Prime_Run
					,episode_starts_from
					--,no_of_episodes
				FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie dm
				Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit1 on dm.title_code = tit1.title_code
				Inner Join Title titNew On tit1.english_title = titNew.Title_Name
				INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
				INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR ON DMR.deal_movie_rights_code=DMRR.deal_movie_rights_code
				left join Rightsu_vmpl_live_27March_2015.dbo.Channel c on c.channel_code=dmrr.primary_channel_code
				left join Channel cNew on c.channel_name=cNew.Channel_Name
				WHERE DM.deal_code=@DEALCODE and titNew.title_code Not In (
					Select Title_Code From DM_Runs_Allocation dmr 
					Inner Join Title tit On dmr.Title = tit.Title_Name 
					Where dmr.[Acquisition Deal No] = @Excel_Deal_Code
				)
				GROUP BY
					DMRR.run_type,DMRR.no_of_runs
					,DMRR.no_of_runs_sched,no_of_AsRuns,DMRR.is_yearwise_definition
					,DMRR.is_rule_right,DMRR.right_rule_code,repeat_within_days_hrs
					,no_of_days_hrs,is_channel_definition_rights,cnew.Channel_Code,DMRR.run_definition_type, titNew.title_code
					,DMR.right_start_date, DMR.right_end_date
					--,DMRR.Prime_Start_Time, DMRR.Prime_End_Time, DMRR.Off_Prime_Start_Time, DMRR.Off_Prime_End_Time, DMRR.Time_Lag_Simulcast
					--,Prime_Run, Off_Prime_Run
					,episode_starts_from,no_of_episodes
			
		End
			--SELECT distinct 
			--	STUFF(
			--			(
			--				Select Distinct ',' + CAST(DMRR1.run_definition_group_code as Varchar) From Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR1
			--				Inner Join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR1 ON DMR1.deal_movie_rights_code=DMRR1.deal_movie_rights_code
			--				Inner Join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM1 ON DMR1.deal_movie_code=DM1.deal_movie_code 
			--						   And DM1.deal_code = @DEALCODE And IsNull(DMR1.right_start_date, GetDate()) = IsNull(DMR.right_start_date, getdate()) 
			--						   And IsNull(DMR.right_end_date, getdate()) = isnull(DMR1.right_end_date, getdate())
			--				FOR XML PATH('')
			--			), 1, 1, ''
			--		) as run_definition_group_code,
			--	DMRR.run_type,DMRR.no_of_runs
			--	,DMRR.no_of_runs_sched,no_of_AsRuns,DMRR.is_yearwise_definition
			--	,DMRR.is_rule_right,CASE WHEN DMRR.right_rule_code=0 THEN NULL ELSE DMRR.right_rule_code END,repeat_within_days_hrs
			--	,no_of_days_hrs,is_channel_definition_rights,primary_channel_code,DMRR.run_definition_type
			--	,DMRR.Prime_Start_Time, DMRR.Prime_End_Time, DMRR.Off_Prime_Start_Time, DMRR.Off_Prime_End_Time, DMRR.Time_Lag_Simulcast
			--FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM
			--INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
			--INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR ON DMR.deal_movie_rights_code=DMRR.deal_movie_rights_code
			--WHERE DM.deal_code=@DEALCODE and DM.title_code Not In (
			--	Select Title_Code From DM_Runs_Allocation dmr 
			--	Inner Join Title tit On dmr.Title = tit.Title_Name 
			--	Where dmr.[Acquisition Deal No] = @Excel_Deal_Code
			--)
			--GROUP BY
			--	DMRR.run_type,DMRR.no_of_runs
			--	,DMRR.no_of_runs_sched,no_of_AsRuns,DMRR.is_yearwise_definition
			--	,DMRR.is_rule_right,DMRR.right_rule_code,repeat_within_days_hrs
			--	,no_of_days_hrs,is_channel_definition_rights,primary_channel_code,DMRR.run_definition_type--, DM.title_code
			--	,DMR.right_start_date, DMR.right_end_date
			--	,DMRR.Prime_Start_Time, DMRR.Prime_End_Time, DMRR.Off_Prime_Start_Time, DMRR.Off_Prime_End_Time, DMRR.Time_Lag_Simulcast
		/*
		SELECT 
				 Max(run_definition_group_code) run_definition_group_code,DMRR.run_type,DMRR.no_of_runs
				,DMRR.no_of_runs_sched,no_of_AsRuns,DMRR.is_yearwise_definition
				,DMRR.is_rule_right,CASE WHEN DMRR.right_rule_code=0 THEN NULL ELSE DMRR.right_rule_code END,repeat_within_days_hrs
				,no_of_days_hrs,is_channel_definition_rights,primary_channel_code,DMRR.run_definition_type
			FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie DM
			INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
			INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Run DMRR ON DMR.deal_movie_rights_code=DMRR.deal_movie_rights_code
			WHERE DM.deal_code=@DEALCODE
			GROUP BY
				 DMRR.run_type,DMRR.no_of_runs
				,DMRR.no_of_runs_sched,no_of_AsRuns,DMRR.is_yearwise_definition
				,DMRR.is_rule_right,DMRR.right_rule_code,repeat_within_days_hrs
				,no_of_days_hrs,is_channel_definition_rights,primary_channel_code,DMRR.run_definition_type, DM.title_code
		*/
		
		
		OPEN CUR_DMRR_ADR	

		FETCH NEXT FROM CUR_DMRR_ADR INTO 
						 @Run_Definition_Group_Code
						,@Run_Title_Code
						,@Run_Type
						,@No_Of_Runs
						,@No_Of_Runs_Sched
						,@No_Of_AsRuns
						,@Is_Yearwise_Definition
						,@Is_Rule_Right
						,@Right_Rule_Code
						,@Repeat_Within_Days_Hrs
						,@No_Of_Days_Hrs
						,@Is_Channel_Definition_Rights
						,@Primary_Channel_Code
						,@Run_Definition_Type
						--,@Prime_Start_Time
						--,@Prime_End_Time
						--,@Off_Prime_Start_Time
						--,@Off_Prime_End_Time
						--,@Simulcast
						--,@Prime_Run
						--,@Off_Prime_Run
						,@Episode_From
						--,@Episode_To

		WHILE (@@fetch_status <> -1)
		BEGIN
			IF (@@fetch_status <> -2)
			BEGIN

				--print 'Acq_Deal_Run'
				/* -- Acq_Deal_Run
				 */
				Set @counter = @counter + 1
				If(@Business_unit_code = 2)
				Begin
					INSERT INTO Acq_Deal_Run(
						Acq_Deal_Code,run_definition_group_code,run_type,no_of_runs
						,no_of_runs_sched,no_of_AsRuns,is_yearwise_definition
						,is_rule_right,right_rule_code,repeat_within_days_hrs
						,no_of_days_hrs,is_channel_definition_rights,primary_channel_code,run_definition_type,
						Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run
					)
					SELECT
					 @Acq_Deal_Code,(Select Top 1 number From DBO.fn_Split_withdelemiter(@Run_Definition_Group_Code, ',')),@Run_Type,@No_Of_Runs
					,@No_Of_Runs_Sched,@No_Of_AsRuns,@Is_Yearwise_Definition
					,@Is_Rule_Right,@Right_Rule_Code,@Repeat_Within_Days_Hrs
					,@No_Of_Days_Hrs,@Is_Channel_Definition_Rights,@Primary_Channel_Code,@Run_Definition_Type
					,null, null, null, null, null,null,null
				End
				Else
				Begin
					INSERT INTO Acq_Deal_Run(
						Acq_Deal_Code,run_definition_group_code,run_type,no_of_runs
						,no_of_runs_sched,no_of_AsRuns,is_yearwise_definition
						,is_rule_right,right_rule_code,repeat_within_days_hrs
						,no_of_days_hrs,is_channel_definition_rights,primary_channel_code,run_definition_type,
						Prime_Start_Time, Prime_End_Time, Off_Prime_Start_Time, Off_Prime_End_Time, Time_Lag_Simulcast, Prime_Run, Off_Prime_Run
					)
					SELECT
					 @Acq_Deal_Code,@counter,@Run_Type,@No_Of_Runs
					,@No_Of_Runs_Sched,@No_Of_AsRuns,@Is_Yearwise_Definition
					,@Is_Rule_Right,@Right_Rule_Code,@Repeat_Within_Days_Hrs
					,@No_Of_Days_Hrs,@Is_Channel_Definition_Rights,@Primary_Channel_Code,@Run_Definition_Type
					,null, null, null, null, null,null,null
					--,@Prime_Start_Time, @Prime_End_Time, @Off_Prime_Start_Time, @Off_Prime_End_Time, @Simulcast,@Prime_Run,@Off_Prime_Run
				End
				SELECT @Acq_Deal_Run_Code=SCOPE_IDENTITY()
				--IF(@dBug='D')SELECT @Acq_Deal_Run_Code Acq_Deal_Run_Code
				
				-- Useful Comment: UDT Deal_Run_Code=Run_Definition_Group_Code
				/* -- Acq_Deal_Run_Title
				 */
				INSERT INTO Acq_Deal_Run_Title(
					Acq_Deal_Run_Code,Title_Code,Episode_From,Episode_To
				)
				Select @Acq_Deal_Run_Code, @Run_Title_Code,@Episode_From,1

				--INSERT INTO Acq_Deal_Run_Title(
				--	Acq_Deal_Run_Code,Title_Code
				--)
				--SELECT  Distinct @Acq_Deal_Run_Code Acq_Deal_Run_Code,Title_Code
				--FROM @Acq_Deal_Run_Title
				--WHERE Deal_Run_Code In (
				--	Select number From DBO.fn_Split_withdelemiter(@Run_Definition_Group_Code, ',')
				--) And Title_Code Not In (
				--	Select tit.Title_Code From DM_Runs_Allocation dmr
				--	Inner Join Title tit On dmr.Title = tit.Title_Name 
				--	Where dmr.[Acquisition Deal No] = @Excel_Deal_Code
				--)

				/* -- Acq_Deal_Run_Channel
				 */
				INSERT INTO Acq_Deal_Run_Channel(
					 Acq_Deal_Run_Code
					,Channel_Code
					,Min_Runs,Max_Runs
					,No_Of_Runs_Sched,No_Of_AsRuns
					,Do_Not_Consume_Rights,Is_Primary
					,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
				)
				SELECT Distinct @Acq_Deal_Run_Code Acq_Deal_Run_Code
						,Channel_Code
						,Min_Runs,Max_Runs
						,No_Of_Runs_Sched,No_Of_AsRuns
						,Do_Not_Consume_Rights,Is_Primary
						,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
				FROM @Acq_Deal_Run_Channel
				WHERE Deal_Run_Code In (
					Select number From DBO.fn_Split_withdelemiter(@Run_Definition_Group_Code, ',')
				)
				
				/* -- Acq_Deal_Run_Repeat_On_Day
				 */
				INSERT INTO Acq_Deal_Run_Repeat_On_Day(
					Acq_Deal_Run_Code,Day_Code
				)
				SELECT Distinct @Acq_Deal_Run_Code Acq_Deal_Run_Code,Day_Code
				FROM @Acq_Deal_Run_Repeat_On_Day
				WHERE Deal_Run_Code In (
					Select number From DBO.fn_Split_withdelemiter(@Run_Definition_Group_Code, ',')
				)

				/* -- Acq_Deal_Run_Yearwise_Run
				 */
				INSERT INTO Acq_Deal_Run_Yearwise_Run(
					 Acq_Deal_Run_Code
					,Start_Date,End_Date,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns
					,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
				)
				SELECT Distinct @Acq_Deal_Run_Code Acq_Deal_Run_Code
					,Start_Date,End_Date,No_Of_Runs,No_Of_Runs_Sched,No_Of_AsRuns
					,Inserted_By,Inserted_On,Last_action_By,Last_updated_Time
				FROM @Acq_Deal_Run_Yearwise_Run
				WHERE Deal_Run_Code In (
					Select number From DBO.fn_Split_withdelemiter(@Run_Definition_Group_Code, ',')
				)
			END
			FETCH NEXT FROM CUR_DMRR_ADR INTO 
						 @Run_Definition_Group_Code
						,@Run_Title_Code
						,@Run_Type
						,@No_Of_Runs
						,@No_Of_Runs_Sched
						,@No_Of_AsRuns
						,@Is_Yearwise_Definition
						,@Is_Rule_Right
						,@Right_Rule_Code
						,@Repeat_Within_Days_Hrs
						,@No_Of_Days_Hrs
						,@Is_Channel_Definition_Rights
						,@Primary_Channel_Code
						,@Run_Definition_Type	
						--,@Prime_Start_Time
						--,@Prime_End_Time
						--,@Off_Prime_Start_Time
						--,@Off_Prime_End_Time
						--,@Simulcast
						--,@Prime_Run
						--,@Off_Prime_Run
						,@Episode_From
						--,@Episode_To
		END
		CLOSE CUR_DMRR_ADR
		DEALLOCATE CUR_DMRR_ADR
		
	--End
	END
	
	--print 'REGION INSERT INTO CURSOR ADR / ADRT / ADRP / ADRTERR / ADRS / ADRD'
	BEGIN -- REGION INSERT INTO CURSOR ADR / ADRT / ADRP / ADRTERR / ADRS / ADRD
	DECLARE @is_group_r INT
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
	,@Actual_Right_start_Date datetime
	,@Actual_Right_End_Date datetime
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
	,@Milestone Varchar(100)


	DECLARE CUR_DMR_ADR_GROUP CURSOR
	READ_ONLY
	FOR 
	SELECT 
	a.is_group,a.is_original_language_rights,is_sub_license, right_period_for
	,IsTentative,term,case when right_period_for='U' then d.deal_signed_date else right_start_date end
	,right_end_date,IsRightsofFirstRefusal,FirstRefusalDate
	,right_start_date Effective_Start_Date,Actual_Right_start_Date,Actual_Right_End_Date
	--,143 inserted_by,getdate() inserted_on,null last_updated_time,null last_action_by
	,d.inserted_by,d.inserted_on,d.last_updated_time,d.last_action_by
	,'N' Is_Exclusive, 
	Case 
		When is_sub_license = 'N' Then Null
		When ISPriorApproval = 'Y' Then 2
		When ISPriorNotice = 'Y' Then 3
		Else 1
	End	 Sub_License_Code -- HC
	,'N' Is_Theatrical_Right --TDB None of the deals are Domestic
	, 
	--(SELECT Milestone_Type_Code FROM Milestone_Type WHERE Milestone_Type_Name=ltrim(rtrim(Milestone)))
	null Milestone_Type_Code
	,run_based_no_of_run Milestone_No_Of_Unit
	,run_based_unit Milestone_Unit_Type
	,b.Deal_Movie_Rights_Restriction_Remark Restriction_Remarks, '' Milestone
	FROM (
		Select * From Rightsu_vmpl_live_27March_2015.dbo.DEAL_MOvie_Rights r WHERE DEAL_MOvie_Code in
		(
			SELECT DEAL_MOvie_Code FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie WHERE deal_code=@DEALCODE
		) 
	) as a
	inner join Rightsu_vmpl_live_27March_2015.dbo.DEAL_Movie dm on dm.deal_movie_code=a.deal_movie_code
	inner join Rightsu_vmpl_live_27March_2015.dbo.DEAL d on dm.deal_code=d.deal_code
	Left Join (
		Select Distinct Max(Deal_Movie_Rights_Restriction_Remark) Deal_Movie_Rights_Restriction_Remark, dmr1.Group_No From Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Restriction_Remark dmrrr
		Inner Join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Restriction_Remark_Details dmrrrd On dmrrr.Deal_Movie_Rights_Restriction_Remark_Code = dmrrrd.Deal_Movie_Rights_Restriction_Remark_Code
		Inner Join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights dmr1 On dmr1.deal_movie_rights_code = dmrrrd.Deal_Movie_Rights_Code And dmr1.DEAL_MOvie_Code in
		(
			SELECT DEAL_MOvie_Code FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie WHERE deal_code=@DEALCODE
		) 
		Group By dmr1.Group_No
	) as b On a.Group_No = b.Group_No
	WHERE d.deal_code=@DEALCODE
	GROUP BY 
	--a.Group_No,
	--b.Group_No,
	a.is_original_language_rights,is_sub_license,right_period_for
	,IsTentative,term,right_start_date
	,right_end_date,IsRightsofFirstRefusal,FirstRefusalDate
	,Actual_Right_start_Date,Actual_Right_End_Date	
	--,ltrim(rtrim(Milestone))
	,run_based_no_of_run,run_based_unit, b.Deal_Movie_Rights_Restriction_Remark, ISPriorApproval, ISPriorNotice
	--, a.Milestone
	,d.deal_signed_date
	,d.inserted_by,d.inserted_on,d.last_updated_time,d.last_action_by,a.is_group
	OPEN CUR_DMR_ADR_GROUP	

	FETCH NEXT FROM CUR_DMR_ADR_GROUP INTO 
					 @is_group_r
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
					,@Actual_Right_start_Date
					,@Actual_Right_End_Date
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
					,@Milestone
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

			/* -- Acq_Deal_Rights		
		    */
			INSERT INTO Acq_Deal_Rights(
			 Acq_Deal_Code
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
			,Restriction_Remarks)
			SELECT  @Acq_Deal_Code Acq_Deal_Code
			,@is_original_language_rights,@is_sub_license, Case When @right_period_for = 'R' Then 'M' Else @right_period_for End
			,@IsTentative,@term,@right_start_date
			,@right_end_date,@IsRightsofFirstRefusal,@FirstRefusalDate
			,@right_start_date,@right_start_date,@right_end_date
			,@inserted_by,@inserted_on,@last_updated_time
			,@last_action_by,
			(SELECT Is_Exclusive FROM #Exclusive_Group WHERE is_group=@is_group_r)Is_Exclusive
			,@Sub_License_Code
			,@Is_Theatrical_Right
			,Case 
				When @Milestone = 'Run Based' Then 1
				When (@Milestone = 'TC/ QC Ok' Or @Milestone = 'TC / QC Ok') Then 2
				When @Milestone = 'Delivery of Material' Then 3
				Else Null
			End
			,@Milestone_No_Of_Unit,@Milestone_Unit_Type
			,@Restriction_Remarks
		
			SELECT @Acq_Deal_Rights_Code=SCOPE_IDENTITY()
			--IF(@dbug='D') SELECT @Acq_Deal_Rights_Code Acq_Deal_Rights_Code
						
			 -- Useful Comment: UDT Deal_Rights_Code=Group_No

			 /* -- Acq_Deal_Rights_Title
			 */
			 INSERT INTO Acq_Deal_Rights_Title(
			 Acq_Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
			 SELECT 
				 @Acq_Deal_Rights_Code Acq_Deal_Rights_Code,Title_Code,Episode_From,Episode_To
			 FROM @Acq_Deal_Rights_Title
			 WHERE Deal_Rights_Code =@is_group_r 

			 /* -- Acq_Deal_Rights_Platform		
		     */
		     INSERT INTO Acq_Deal_Rights_Platform(
		     Acq_Deal_Rights_Code,platform_Code)
			 SELECT 
				@Acq_Deal_Rights_Code Acq_Deal_Rights_Code,platform_Code
			 FROM @Acq_Deal_Rights_Platform
		     WHERE Deal_Rights_Code =@is_group_r 
		
		
			 /* -- Acq_Deal_Rights_Territory
			 */
			 if((select count(*) from @Acq_Deal_Rights_Territory where Territory_Type<>'G' and Deal_Rights_Code=@is_group_r)>0)
			 begin
				 INSERT INTO Acq_Deal_Rights_Territory(
					Acq_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code 
				 )	
				 SELECT distinct
						@Acq_Deal_Rights_Code,Territory_Type, Case When Country_Code > 0 Then Country_Code Else Null End, Case When Territory_Code > 0 Then Territory_Code Else Null End
				 FROM @Acq_Deal_Rights_Territory 
				 WHERE Deal_Rights_Code=@is_group_r 
			end
			else
			begin
				INSERT INTO Acq_Deal_Rights_Territory(
					Acq_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code 
				 )	
				 SELECT distinct
						@Acq_Deal_Rights_Code,Territory_Type, td.country_code, adrt.Territory_Code 
				 FROM @Acq_Deal_Rights_Territory adrt
				 inner join Territory_Details td on td.territory_code=adrt.territory_code
				 inner join Country c on c.country_code=td.country_code
				 WHERE Deal_Rights_Code=@is_group_r and  c.is_active='Y'
			end
			 /* -- Acq_Deal_Rights_Subtitling
			 */
			 INSERT INTO Acq_Deal_Rights_Subtitling(Acq_Deal_Rights_Code
				,Language_Type
				,Language_Code,
				Language_Group_Code
			 )
			 SELECT
					@Acq_Deal_Rights_Code,Language_Type,Subtitling_Code,
					Case When Language_Group_Code > 0 Then Language_Group_Code Else Null End
			 FROM @Acq_Deal_Rights_Subtitling
			 WHERE Deal_Rights_Code=@is_group_r 

			 /* -- Acq_Deal_Rights_Dubbing
			 */
			 INSERT INTO Acq_Deal_Rights_Dubbing(Acq_Deal_Rights_Code
				,Language_Type
				,Language_Code,Language_Group_Code
			 )
			 SELECT
					@Acq_Deal_Rights_Code,Language_Type,Dubbing_Code,Case When Language_Group_Code > 0 Then Language_Group_Code Else Null End
			 FROM @Acq_Deal_Rights_Dubbing
			 WHERE Deal_Rights_Code=@is_group_r 
			 			 
			
			/* -- Acq_Deal_Rights_Holdback
			 */
			 --DEALLOCATE CR_ACQ_RIGHTS_HB
			DECLARE CR_ACQ_RIGHTS_HB CURSOR
			READ_ONLY
			FOR  select dmrh.Holdback_Type,
						dmrh.HB_Run_After_Release_No,
						dmrh.HB_Run_After_Release_Units,
						p.Platform_Code,
						dmrh.Holdback_Release_Date,
						dmrh.Holdback_Comment,Is_Original_Language
						,dmrh.Deal_Movie_Rights_Holdback_Code
						,pH.platform_code
				 FROM Rightsu_vmpl_live_27March_2015.dbo.deal_movie DM
				 INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.deal_movie_rights DMR ON DM.deal_movie_code=DMR.deal_movie_code 
				 INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_Holdback DMRH ON DMR.deal_movie_rights_code=DMRH.Deal_movie_rights_code 
				 left join Rightsu_vmpl_live_27March_2015.dbo.Platform p on p.platform_code=DMRH.Holdback_On_Platform_Code 
				 --left join Platform pNew on pNew.Platform_Code=p.Platform_Code and p.Platform_Hiearachy=pNew.Platform_Hiearachy
				 left join Rightsu_vmpl_live_27March_2015.dbo.Platform pH on pH.platform_code=DMR.platform_code 
				 --left join Platform pHNew on pHNew.Platform_Code=ph.Platform_Code and pH.Platform_Hiearachy=pHNew.Platform_Hiearachy
				 WHERE DM.deal_code=@DEALCODE	
				 and dmr.is_group=@is_group_r

			DECLARE @Holdback_Type  char,@HB_Run_After_Release_No  int,@HB_Run_After_Release_Units  int,@Holdback_On_Platform_Code  int,@Holdback_Release_Date  datetime,
			@Holdback_Comment  NVARCHAR(2000),@Is_Original_Language  char,@Deal_Movie_Rights_Holdback_Code int,@h_Platform_code int

			OPEN CR_ACQ_RIGHTS_HB

			FETCH NEXT FROM CR_ACQ_RIGHTS_HB INTO @Holdback_Type,@HB_Run_After_Release_No,@HB_Run_After_Release_Units,@Holdback_On_Platform_Code,@Holdback_Release_Date,
			@Holdback_Comment,@Is_Original_Language,@Deal_Movie_Rights_Holdback_Code,@h_Platform_code
			WHILE (@@fetch_status <> -1)
			BEGIN
				IF (@@fetch_status <> -2)
				BEGIN
					
					/*--Deal_Rights_Holdback--*/
					IF EXISTS (SELECT TOP 1 Acq_Deal_Rights_Holdback_code from Acq_Deal_Rights_Holdback where 
						Acq_Deal_Rights_Code=@Acq_Deal_Rights_Code and Holdback_Type=@Holdback_Type and HB_Run_After_Release_No=@HB_Run_After_Release_No  and 
						HB_Run_After_Release_Units=@HB_Run_After_Release_Units and isnull(Holdback_On_Platform_Code,0)=isnull(@Holdback_On_Platform_Code,0) and 
						isnull(Holdback_Release_Date,getdate())=isnull(@Holdback_Release_Date,getdate()) and Holdback_Comment=@Holdback_Comment and Is_Title_Language_Right=@Is_Original_Language	
					)
					BEGIN
						
						SELECT top 1 @Acq_Deal_Rights_Holdback_code=@Acq_Deal_Rights_HoldBack_Code from Acq_Deal_Rights_Holdback where 
						Acq_Deal_Rights_Code=@Acq_Deal_Rights_Code and Holdback_Type=@Holdback_Type and HB_Run_After_Release_No=@HB_Run_After_Release_No  and 
						HB_Run_After_Release_Units=@HB_Run_After_Release_Units and isnull(Holdback_On_Platform_Code,0)=isnull(@Holdback_On_Platform_Code,0) and 
						Holdback_Release_Date=@Holdback_Release_Date and Holdback_Comment=@Holdback_Comment and Is_Title_Language_Right=@Is_Original_Language	

					END
					ELSE
					BEGIN
						Insert into Acq_Deal_Rights_Holdback(Acq_Deal_Rights_Code,Holdback_Type,HB_Run_After_Release_No,HB_Run_After_Release_Units,Holdback_On_Platform_Code,
						Holdback_Release_Date,Holdback_Comment,Is_Title_Language_Right)
						select @Acq_Deal_Rights_Code,@Holdback_Type,@HB_Run_After_Release_No,@HB_Run_After_Release_Units,@Holdback_On_Platform_Code,@Holdback_Release_Date,
						@Holdback_Comment,@Is_Original_Language

						SELECT @Acq_Deal_Rights_Holdback_code=SCOPE_IDENTITY()
					END
					
					--IF(@dbug='D') SELECT @Acq_Deal_Rights_Holdback_code Deal_Revenue_HB_Code

					/*---Deal_Rights_Holdback_Dubbing---*/
					Insert into Acq_Deal_Rights_Holdback_Dubbing(Acq_Deal_Rights_Holdback_Code,Language_Code)
					Select @Acq_Deal_Rights_Holdback_code,lnew.Language_Code from 
					Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_HoldBack_Languages dmrhl 
					inner join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=dmrhl.language_code
					inner join Language lnew on l.language_name=lnew.language_name
					where dmrhl.Deal_Movie_Rights_HoldBack_Code=@Deal_Movie_Rights_Holdback_Code
					and Language_Type='D'

					/*---Deal_Rights_Holdback_Subtitling---*/
					Insert into Acq_Deal_Rights_Holdback_Subtitling(Acq_Deal_Rights_Holdback_Code,Language_Code)
					Select @Acq_Deal_Rights_Holdback_code,lnew.Language_Code from 
					Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_HoldBack_Languages dmrhl 
					inner join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=dmrhl.language_code
					inner join Language lnew on l.language_name=lnew.language_name
					where dmrhl.Deal_Movie_Rights_HoldBack_Code=@Deal_Movie_Rights_Holdback_Code
					and Language_Type='S'

					/*---Deal_Rights_Holdback_Territory---*/
					
					Insert into Acq_Deal_Rights_Holdback_Territory(Acq_Deal_Rights_Holdback_Code,Territory_Type,Country_Code,Territory_Code)
					Select distinct @Acq_Deal_Rights_Holdback_code,
					--case when isnull(Country_Code,isnull(Territory_Code,0))>0 then 'I' else 'G' end,
					'I',td.country_code,null 
					from 
					Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie_Rights_HoldBack_Territory dmrht
					--left join Rightsu_vmpl_live_27March_2015.dbo.International_Territory it on it.international_territory_code=dmrht.country_code
					--left join Country c on c.Country_Name=it.international_territory_name
					left join Rightsu_vmpl_live_27March_2015.dbo.territory_group tg on tg.territory_group_code=dmrht.territory_code
					left join Territory t on t.Territory_Name=tg.territory_group_name
					left join Territory_Details td on t.Territory_code=td.Territory_code
					left join Country c on c.country_code=td.country_code
					where dmrht.Deal_Movie_Rights_HoldBack_Code=@Deal_Movie_Rights_Holdback_Code
					and c.is_active='Y'
					
					/*---Deal_Rights_Holdback_Platform---*/
					Insert into Acq_Deal_Rights_Holdback_Platform(Acq_Deal_Rights_Holdback_Code,Platform_Code)
					select @Acq_Deal_Rights_Holdback_code,@h_Platform_code


					
				END
				FETCH NEXT FROM CR_ACQ_RIGHTS_HB INTO @Holdback_Type,@HB_Run_After_Release_No,@HB_Run_After_Release_Units,@Holdback_On_Platform_Code,@Holdback_Release_Date,
			@Holdback_Comment,@Is_Original_Language,@Deal_Movie_Rights_Holdback_Code,@h_Platform_code
			END
			CLOSE CR_ACQ_RIGHTS_HB
			DEALLOCATE CR_ACQ_RIGHTS_HB
			
			  /* -- END OF Syn_Deal_Movie_Rights_Holdback
			 */
			 
		END
		FETCH NEXT FROM CUR_DMR_ADR_GROUP INTO  @is_group_r,@is_original_language_rights
											,@is_sub_license
											,@right_period_for
											,@IsTentative
											,@term
											,@right_start_date
											,@right_end_date
											,@IsRightsofFirstRefusal
											,@FirstRefusalDate
											,@Effective_Start_Date
											,@Actual_Right_start_Date
											,@Actual_Right_End_Date
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
											,@Milestone
	END
	CLOSE CUR_DMR_ADR_GROUP
	DEALLOCATE CUR_DMR_ADR_GROUP
	END

	--print 'REGION INSERT INTO CURSOR AD PUSHBACK'
	BEGIN -- REGION INSERT INTO CURSOR ADP
	DECLARE 
	 @Deal_Rights_RHB_Code_cur int
	,@Deal_Code_Cur int
	,@Right_Period_For_Cur CHAR(1)
	,@IsTentative_Cur CHAR(1)
	,@Term_Cur varchar(100)
	,@Right_Start_Date_Cur datetime
	,@Right_End_Date_Cur datetime
	,@Milestone_Type_Cur int
	,@Milestone_No_Of_Unit_Cur int
	,@Milestone_Unit_Type_Cur int
	,@Is_Original_Language_Rights_Cur CHAR(1)
	,@Remarks_Cur Remarks_UD
	,@Inserted_By_Cur int
	,@Inserted_On_Cur datetime
	,@Last_Updated_Time_Cur datetime
	,@Last_Action_By_Cur int	
	
	DECLARE CUR_DRRHB_ADP CURSOR
	READ_ONLY
	FOR 
	SELECT 
		 Deal_Rights_RHB_Code
		,Deal_Code
		,Right_Period_For
		,IsTentative
		,Term
		,Right_Start_Date
		,Right_End_Date
		,case when Milestone_Type=0 then null else Milestone_Type end
		,Milestone_No_Of_Unit
		,Milestone_Unit_Type
		,Is_Original_Language_Rights
		,Remarks
		,Inserted_By
		,Inserted_On
		,Last_Updated_Time
		,Last_Action_By		
	FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Rights_RHB
	WHERE Deal_Code=@DEALCODE
	OPEN CUR_DRRHB_ADP	

	FETCH NEXT FROM CUR_DRRHB_ADP INTO 
					 @Deal_Rights_RHB_Code_Cur
					,@Deal_Code_Cur
					,@Right_Period_For_Cur
					,@IsTentative_Cur
					,@Term_Cur
					,@Right_Start_Date_Cur
					,@Right_End_Date_Cur
					,@Milestone_Type_Cur
					,@Milestone_No_Of_Unit_Cur
					,@Milestone_Unit_Type_Cur
					,@Is_Original_Language_Rights_Cur
					,@Remarks_Cur
					,@Inserted_By_Cur
					,@Inserted_On_Cur
					,@Last_Updated_Time_Cur
					,@Last_Action_By_Cur					

	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			/* -- Acq_Deal_Pushback		
		     */
			INSERT INTO Acq_Deal_Pushback(
				 Acq_Deal_Code
				,Right_Type
				,Is_Tentative
				,Term
				,Right_Start_Date
				,Right_End_Date
				,Milestone_Type_Code
				,Milestone_No_Of_Unit
				,Milestone_Unit_Type
				,Is_Title_Language_Right
				,Remarks
				,Inserted_By
				,Inserted_On
				,Last_Updated_Time
				,Last_Action_By)
		    SELECT
			 @Acq_Deal_Code
			,@Right_Period_For_Cur
			,@IsTentative_Cur
			,@Term_Cur
			,@Right_Start_Date_Cur
			,@Right_End_Date_Cur
			,@Milestone_Type_Cur
			,@Milestone_No_Of_Unit_Cur
			,@Milestone_Unit_Type_Cur
			,@Is_Original_Language_Rights_Cur
			,@Remarks_Cur
			,@Inserted_By_Cur
			,@Inserted_On_Cur
			,@Last_Updated_Time_Cur
			,@Last_Action_By_Cur			

			SELECT @Acq_Deal_Pushback_Code=SCOPE_IDENTITY()
			--IF(@dBug='D')SELECT @Acq_Deal_Pushback_Code Acq_Deal_Pushback_Code
			
			/* -- Acq_Deal_Pushback_Title		
		     */
			INSERT INTO Acq_Deal_Pushback_Title
			(Acq_Deal_Pushback_Code,Title_Code,Episode_From,Episode_To)
			SELECT 				
				@Acq_Deal_Pushback_Code,titNew.Title_Code,1,1
			FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Rights_RHB_Title drrt
			inner join Rightsu_vmpl_live_27March_2015.dbo.Deal_Rights_RHB drr on drr.Deal_Rights_RHB_Code=drrt.Deal_Rights_RHB_Code
			inner join Rightsu_vmpl_live_27March_2015.dbo.Deal d on d.deal_code=drr.deal_code
			Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit on drrt.title_code = tit.title_code  
			Inner Join Title titNew On tit.english_title = titNew.Title_Name 
			and ((d.deal_type='M' and titnew.Reference_Flag is null) or (d.deal_type='S' and titnew.Reference_Flag ='T'))--titNew.deal_type_code=tit.dealtype_code
			WHERE drrt.Deal_Rights_RHB_Code=@Deal_Rights_RHB_Code_cur

			/* -- Acq_Deal_Pushback_Platform		
		     */
			INSERT INTO Acq_Deal_Pushback_Platform
			(Acq_Deal_Pushback_Code,Platform_code)
			SELECT 				
				@Acq_Deal_Pushback_Code,p.Platform_code
			FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Rights_RHB_Platform drrp
			inner join Rightsu_vmpl_live_27March_2015.dbo.Platform p on p.platform_code=drrp.Platform_Code
			--inner join Platform pNew on pNew.Platform_Name=p.Platform_Name and p.Platform_Hiearachy=pNew.Platform_Hiearachy
			WHERE Deal_Rights_RHB_Code=@Deal_Rights_RHB_Code_cur

			/* -- Acq_Deal_Pushback_Territory
		     */
			INSERT INTO Acq_Deal_Pushback_Territory
			(Acq_Deal_Pushback_Code,Territory_Type,Country_Code,Territory_Code)
			SELECT 				
				@Acq_Deal_Pushback_Code,Territory_Type,
				Case When c.Country_Code > 0 Then c.Country_Code Else Null End, Case When t.Territory_Code > 0 Then t.Territory_Code Else Null End
				--International_Territory_Code,Territory_Group_Code
			FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Rights_RHB_Territory drht
			left join Rightsu_vmpl_live_27March_2015.dbo.International_Territory it on it.international_territory_code=drht.International_Territory_Code
			left join Country c on c.Country_Name=it.international_territory_name
			left join Rightsu_vmpl_live_27March_2015.dbo.territory_group tg on tg.territory_group_code=drht.territory_group_code
			left join Territory t on t.Territory_Name=tg.territory_group_name
			WHERE Deal_Rights_RHB_Code=@Deal_Rights_RHB_Code_cur
			
			/* -- Acq_Deal_Pushback_Subtitling
		     */
			INSERT INTO Acq_Deal_Pushback_Subtitling
			(Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code)
			SELECT 				
				@Acq_Deal_Pushback_Code,Language_Type,
				CASE WHEN ISNULL(drrs.Language_Code,0)>0 THEN lnew.language_code else LGD.Language_Code end Language_Code
				,Case When lgnew.Language_Group_Code > 0 Then lgnew.Language_Group_Code Else Null End
			FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Rights_RHB_Subtitling drrs
			Left  join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=drrs.language_code
			Left join Language lnew on lNew.Language_Name=l.Language_Name
			Left join Rightsu_vmpl_live_27March_2015.dbo.Language_Group lg on lg.Language_Group_Code=drrs.Language_Group_Code
			Left join Language_Group lgNew on lgNew.Language_Group_Name=lg.Language_Group_Name
			LEFT JOIN Language_Group_Details LGD ON lgNew.Language_Group_Code=LGD.Language_Group_Code
			WHERE Deal_Rights_RHB_Code=@Deal_Rights_RHB_Code_cur

			/* -- Acq_Deal_Pushback_Dubbing
		     */
			INSERT INTO Acq_Deal_Pushback_Dubbing
			(Acq_Deal_Pushback_Code,Language_Type,Language_Code,Language_Group_Code)
			SELECT 				
				@Acq_Deal_Pushback_Code,Language_Type,
				CASE WHEN ISNULL(drrd.Language_Code,0)>0 THEN lnew.language_code else LGD.Language_Code end Language_Code
				,Case When lgnew.Language_Group_Code > 0 Then lgnew.Language_Group_Code Else Null End
			FROM Rightsu_vmpl_live_27March_2015.dbo.Deal_Rights_RHB_Dubbing drrd
			Left  join Rightsu_vmpl_live_27March_2015.dbo.Language l on l.language_code=drrd.language_code
			Left join Language lnew on lNew.Language_Name=l.Language_Name
			Left join Rightsu_vmpl_live_27March_2015.dbo.Language_Group lg on lg.Language_Group_Code=drrd.Language_Group_Code
			Left join Language_Group lgNew on lgNew.Language_Group_Name=lg.Language_Group_Name
			LEFT JOIN Language_Group_Details LGD ON lgNew.Language_Group_Code=LGD.Language_Group_Code
			WHERE Deal_Rights_RHB_Code=@Deal_Rights_RHB_Code_cur

		END
		FETCH NEXT FROM CUR_DRRHB_ADP INTO 
					 @Deal_Rights_RHB_Code_Cur
					,@Deal_Code_Cur
					,@Right_Period_For_Cur
					,@IsTentative_Cur
					,@Term_Cur
					,@Right_Start_Date_Cur
					,@Right_End_Date_Cur
					,@Milestone_Type_Cur
					,@Milestone_No_Of_Unit_Cur
					,@Milestone_Unit_Type_Cur
					,@Is_Original_Language_Rights_Cur
					,@Remarks_Cur
					,@Inserted_By_Cur
					,@Inserted_On_Cur
					,@Last_Updated_Time_Cur
					,@Last_Action_By_Cur					
	END
	CLOSE CUR_DRRHB_ADP
	DEALLOCATE CUR_DRRHB_ADP
	END
	
	--print 'REGION INSERT INTO COST'
	BEGIN---REGION INSERT INTO COST / 
	
	DECLARE @Acq_Deal_Cost_Title Deal_Rights_Title
	INSERT INTO @Acq_Deal_Cost_Title (Deal_Rights_Code,Title_Code,Episode_From,Episode_To)
	SELECT is_group,titNew.Title_Code,1,1
	FROM Rightsu_vmpl_live_27March_2015.dbo.deal_movie dm
	inner join Rightsu_vmpl_live_27March_2015.dbo.deal d on d.deal_code=dm.deal_code
	Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit on dm.title_code = tit.title_code  
	Inner Join Title titNew On tit.english_title = titNew.Title_Name 
	and ((d.deal_type='M' and titnew.Reference_Flag is null) or (d.deal_type='S' and titnew.Reference_Flag ='T'))--titNew.deal_type_code=tit.dealtype_code
	INNER JOIN Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost DMC ON DM.deal_movie_code=DMC.deal_movie_code
	WHERE DM.deal_code=@DEALCODE
	GROUP BY is_group,titNew.Title_Code, no_of_episodes
	--print 'Inserted into @Acq_Deal_Cost_Title'	

	--CLOSE CR_ACQ_COST
	--DEALLOCATE CR_ACQ_COST
	DECLARE CR_ACQ_COST CURSOR
	READ_ONLY
	FOR 
		Select 
		currNew.currency_code,
		dmc.exchange_rate,
		deal_movie_cost,
		deal_movie_cost_per_episode,
		ccnew.Cost_Center_Id,
		d.Inserted_On,
		d.Inserted_By,
		d.Last_Updated_Time,
		d.Last_Action_By,
		additional_cost,
		catchup_cost,
		variable_cost_type,
		variable_cost_sharing_type
		,is_group 
		,rrnew.royalty_recoupment_code
	FROM Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost dmc
	inner join Rightsu_vmpl_live_27March_2015.dbo.deal_movie dm on dm.deal_movie_code=dmc.deal_movie_code
	inner join Rightsu_vmpl_live_27March_2015.dbo.deal d on d.deal_code=dm.deal_code
	inner join Rightsu_vmpl_live_27March_2015.dbo.Currency curr on dmc.currency_code=curr.currency_code
	inner join Currency currNew on currNew.Currency_Name=curr.currency_name
	left join Rightsu_vmpl_live_27March_2015.dbo.Royalty_Recoupment rr on rr.royalty_recoupment_code=dmc.royalty_recoupment_code
	left join Royalty_Recoupment rrNew on rrNew.Royalty_Recoupment_Name=rr.Royalty_Recoupment_Name
	left join Rightsu_vmpl_live_27March_2015.dbo.Cost_Center cc on cc.cost_center_id=dmc.cost_center_id
	left join Cost_Center ccNew on ccNew.Cost_Center_Name=cc.Cost_Center_Name
	WHERE d.deal_code=@DEALCODE
	group by 
		currNew.currency_code,
		dmc.exchange_rate,
		deal_movie_cost,
		deal_movie_cost_per_episode,
		ccnew.Cost_Center_Id,
		additional_cost,
		catchup_cost,
		variable_cost_type,
		variable_cost_sharing_type
		,is_group 
		,rrnew.royalty_recoupment_code,d.Inserted_On,
		d.Inserted_By,
		d.Last_Updated_Time,
		d.Last_Action_By

	DECLARE @currency_code int,@exchange_rate decimal,@deal_movie_cost decimal,@deal_movie_cost_per_episode decimal,@cost_center_id int,
	@C_Inserted_On datetime,@C_Inserted_By int,@C_Last_Updated_Time datetime,@C_Last_Action_By int,@additional_cost decimal,@catchup_cost decimal,@variable_cost_type char,
	@variable_cost_sharing_type char,@is_group int,@royalty_recoupment_code int

	OPEN CR_ACQ_COST
	
	FETCH NEXT FROM CR_ACQ_COST INTO @currency_code,@exchange_rate,@deal_movie_cost,@deal_movie_cost_per_episode,@cost_center_id,@C_Inserted_On,
	@C_Inserted_By,@C_Last_Updated_Time,@C_Last_Action_By,@additional_cost,@catchup_cost,@variable_cost_type,@variable_cost_sharing_type,@is_group
	,@royalty_recoupment_code
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

			--print 'ADD Deal_Movie_Cost'
			/*----Deal_Movie_Cost----*/
			Insert into Acq_Deal_Cost(Acq_Deal_Code,Currency_Code,Currency_Exchange_Rate,Deal_Cost,Deal_Cost_Per_Episode,
			Cost_Center_Id,Additional_Cost,Catchup_Cost,Variable_Cost_Type,Variable_Cost_Sharing_Type,Royalty_Recoupment_Code,
			Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
			select @Acq_Deal_Code,@currency_code,@exchange_rate,@deal_movie_cost,@deal_movie_cost_per_episode,@cost_center_id,
			@additional_cost,@catchup_cost,@variable_cost_type,@variable_cost_sharing_type,
			@royalty_recoupment_code,@C_Inserted_On,@C_Inserted_By,@C_Last_Updated_Time,@C_Last_Action_By


			SELECT @Acq_Deal_Cost_Code=SCOPE_IDENTITY()
			--IF(@dbug='D') SELECT @Acq_Deal_Cost_Code Acq_Deal_Cost_Code
			
			--print 'ADD Deal_Movie_Cost Title'			
			 /* -- Acq_Deal_Cost_Title*/
			 INSERT INTO Acq_Deal_Cost_Title(
			 Acq_Deal_Cost_Code,Title_Code,Episode_From,Episode_To)
			 SELECT 
				 @Acq_Deal_Cost_Code Acq_Deal_Cost_Code,Title_Code,Episode_From,Episode_To
			 FROM @Acq_Deal_Cost_Title
			 WHERE Deal_Rights_Code =@is_group 

			 --print 'ADD Deal_Movie_Cost Additional Exp'
			 /*----Acq_Deal_Cost_Additional_Exp---*/
			 Insert into  Acq_Deal_Cost_Additional_Exp
			 (Acq_Deal_Cost_Code,Additional_Expense_Code,Amount,Min_Max,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By)
			 select @Acq_Deal_Cost_Code,aNew.additional_expense_code,amount,min_max,@C_Inserted_On,@c_Inserted_By,@c_Last_Updated_Time,@c_Last_Action_By
			 from   Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost_additional_exp  dmca
			 inner join Rightsu_vmpl_live_27March_2015.dbo.Additional_Expense a on a.additional_expense_code= dmca.additional_expense_code
			 inner join Additional_Expense aNew on anew.Additional_Expense_Name=a.additional_expense_name
			 inner join Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost dmc on dmc.deal_movie_cost_code=dmca.deal_movie_cost_code
			 inner join Rightsu_vmpl_live_27March_2015.dbo.deal_movie dm on dm.deal_movie_code=dmc.deal_movie_code
			 where dm.deal_code=@DEALCODE and dmc.is_group=@is_group
			 group by aNew.additional_expense_code,amount,min_max

			 --print 'ADD Deal_Movie_Cost Commission'
			 /*---Acq_Deal_Cost_Commission---*/
			 Insert into Acq_Deal_Cost_Commission
			 (Acq_Deal_Cost_Code,Cost_Type_Code,Royalty_Commission_Code,Vendor_Code,Type,Commission_Type,Percentage,Amount,Entity_Code)
			 Select @Acq_Deal_Cost_Code,ctNew.cost_type_code,royalty_commission_code,vNew.vendor_code,type,commission_type,percentage,amount,eNew.Entity_Code
			 from  Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost_commission dmcc
			 inner join Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost dmc on dmc.deal_movie_cost_code=dmcc.deal_movie_cost_code
			 inner join Rightsu_vmpl_live_27March_2015.dbo.deal_movie dm on dm.deal_movie_code=dmc.deal_movie_code
			 left join Rightsu_vmpl_live_27March_2015.dbo.Cost_Type ct on ct.cost_type_code=dmcc.cost_type_code
			 left join Cost_Type ctNew on ct.cost_type_name=ctNew.cost_type_name
			 left join Rightsu_vmpl_live_27March_2015.dbo.Entity e on e.entity_code=dmcc.vendor_code
			 left join Entity eNew on e.entity_name=eNew.Entity_Name
			 left join Rightsu_vmpl_live_27March_2015.dbo.Vendor v on v.vendor_code=dmcc.vendor_code
			 left join Vendor vNew on v.vendor_name=vNew.vendor_name
			 where dm.deal_code=@DEALCODE and dmc.is_group=@is_group
			 group by ctNew.cost_type_code,royalty_commission_code,vNew.vendor_code,type,commission_type,percentage,amount,eNew.Entity_Code

			-- /*---Syn_Deal_Revenue_Platform---*/
			-- Insert into Syn_Deal_Revenue_Platform (Syn_Deal_Revenue_Code,Platform_Code)
			--select @Syn_Deal_Revenue_Code,pNew.platform_code from Rightsu_vmpl_live_27March_2015.dbo.syn_deal_movie_cost_platform_distribution sdmcpd
			--Inner join Rightsu_vmpl_live_27March_2015.dbo.Platform p on p.platform_code=sdmcpd.platform_code
			--inner join Platform pNew on pNew.Platform_Name=p.Platform_Name
			--where syn_deal_movie_cost_code=@syn_deal_movie_cost_code
			--and syndication_deal_movie_code=@syndication_deal_movie_code

			/*---Acq_Deal_Cost_Variable_Cost---*/
			Insert into Acq_Deal_Cost_Variable_Cost(Acq_Deal_Cost_Code,Vendor_Code,Percentage,Amount,Inserted_On,Inserted_By,Last_Updated_Time
			,Last_Action_By,Entity_Code)
			select @Acq_Deal_Cost_Code,vNew.Vendor_Code,percentage,amount,@c_inserted_on,@c_inserted_by,@c_last_updated_time,@c_last_action_by,
			eNew.Entity_Code
			 from Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost_variable_cost dmcvc
			 inner join Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost dmc on dmc.deal_movie_cost_code=dmcvc.deal_movie_cost_code
			inner join Rightsu_vmpl_live_27March_2015.dbo.deal_movie dm on dm.deal_movie_code=dmc.deal_movie_code
			left join Rightsu_vmpl_live_27March_2015.dbo.Entity e on e.entity_code=dmcvc.licensr_code
			left join Entity eNew on e.entity_name=eNew.Entity_Name
			left join Rightsu_vmpl_live_27March_2015.dbo.Vendor v on v.vendor_code=dmcvc.licensr_code
			left join Vendor vNew on v.vendor_name=vNew.vendor_name
			where dm.deal_code=@DEALCODE and dmc.is_group=@is_group
			group by vNew.Vendor_Code,percentage,amount,eNew.Entity_Code

			/*---- Acq_Deal_Cost_Costtype---*/
			Insert into  Acq_Deal_Cost_Costtype(Acq_Deal_Cost_Code,Cost_Type_Code,Amount,Inserted_On,Inserted_By,Last_Updated_Time,Last_Action_By,Consumed_Amount)
			select @Acq_Deal_Cost_Code,cNew.cost_type_code,amount,@c_Inserted_On,@c_Inserted_By,@c_Last_Updated_Time,@c_Last_Action_By,0
			from Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost_costtype dmcc
			inner join Rightsu_vmpl_live_27March_2015.dbo.deal_movie_cost dmc on dmc.deal_movie_cost_code=dmcc.deal_movie_cost_code
			inner join Rightsu_vmpl_live_27March_2015.dbo.deal_movie dm on dm.deal_movie_code=dmc.deal_movie_code
			inner join Rightsu_vmpl_live_27March_2015.dbo.Cost_Type c on c.cost_type_code=dmcc.cost_type_code
			inner join Cost_Type cNew on cNew.Cost_Type_Name=c.Cost_Type_Name
			where dm.deal_code=@DEALCODE and dmc.is_group=@is_group
			group by cNew.cost_type_code,amount
			

		END
		FETCH NEXT FROM CR_ACQ_COST INTO @currency_code,@exchange_rate,@deal_movie_cost,@deal_movie_cost_per_episode,@cost_center_id,@C_Inserted_On,
	@C_Inserted_By,@C_Last_Updated_Time,@C_Last_Action_By,@additional_cost,@catchup_cost,@variable_cost_type,@variable_cost_sharing_type,@is_group
	,@royalty_recoupment_code
	END

	CLOSE CR_ACQ_COST
	DEALLOCATE CR_ACQ_COST

	END
	/*
	print 'REGION INSERT INTO ACQU SPORT'
	BEGIN -- REGION INSERT INTO ACQU SPORT

		Create Table #TempTableStandalone(
			PlatformCode Int
		)

		Create Table #TempTableSimulcast(
			PlatformCode Int
		)

		Create Table #TempTableStandalone_New(
			[IntCode] int,
			[Deal_Code] int,
			GroupNo Int,
			Title varchar(1000),
			Content_Delivery varchar(1000),
			Modes_Broadcast varchar(1000),
			Obligation_Broadcast varchar(1000),
			Deferred_Live_Duration varchar(1000),
			Tape_Delayed_Duration varchar(1000),
			Standalone_Digital_Live varchar(1000),
			Substantial_Live_Stanalone varchar(1000),
			Standalone_Platforms varchar(1000),
			Simulcast_Digital_Tranmission varchar(1000),
			Substantial_Live_Digital_Simulcast varchar(1000),
			Simuslcast_Platforms varchar(1000),
			Commentary_Languages varchar(1000),
			MBO_Critical_Notes varchar(1000),
			MTO_Critical_Notes varchar(1000),
		)

		Insert into #TempTableStandalone
		Select Distinct replace([PlatformCode],'ST_','') [PlatformCode] From 
		(
			Select * From 
			(
				select IntCode,[ST_57],[ST_63],[ST_60],[ST_58],[ST_61],[ST_259],[ST_59],[ST_62],[ST_56],[ST_274],[ST_273],[ST_69],[ST_270],[ST_271],[ST_272] 
				from Dm_Sport where Deal_No = @Excel_Deal_Code
			) as a
			UNPIVOT
			(
				[YesNo] FOR [PlatformCode] IN([ST_57],[ST_63],[ST_60],[ST_58],[ST_61],[ST_259],[ST_59],[ST_62],[ST_56],[ST_274],[ST_273],[ST_69],[ST_270],[ST_271],[ST_272]
			)
			) as UPVT
		) as ab Where [YesNo] = 'YES'

		Insert into #TempTableSimulcast
		Select Distinct Replace([PlatformCode],'SM_','') [PlatformCode] From 
		(
			Select * From 
			(
				select IntCode,[SM_63],[SM_57],[SM_60],[SM_58],[SM_61],[SM_259],[SM_59],[SM_62],[SM_56],[SM_69] 
				from Dm_Sport where Deal_No=@Excel_Deal_Code
			) as a
			UNPIVOT
			(
				[YesNo] FOR [PlatformCode] IN([SM_63],[SM_57],[SM_60],[SM_58],[SM_61],[SM_259],[SM_59],[SM_62],[SM_56],[SM_69] 
			)
			) as UPVT
		) as ab Where [YesNo] = 'YES'

		Declare @strStandalone Varchar(1000),@strSimulcast Varchar(1000)= ''
		Set @strStandalone = ''
		Select @strStandalone = @strStandalone + Cast(PlatformCode as varchar) + ',' From #TempTableStandalone
		Set @strStandalone = SUBSTRING(@strStandalone, 0, Len(@strStandalone))

		Set @strSimulcast = ''
		Select @strSimulcast = @strSimulcast + Cast(PlatformCode as varchar) + ',' From #TempTableSimulcast
		Set @strSimulcast = SUBSTRING(@strSimulcast, 0, Len(@strSimulcast))


		Insert InTo #TempTableStandalone_New([IntCode],[Deal_Code],Title,Content_Delivery ,Modes_Broadcast,Obligation_Broadcast,Deferred_Live_Duration,Tape_Delayed_Duration,
			   Standalone_Digital_Live,Substantial_Live_Stanalone,Standalone_Platforms,Simulcast_Digital_Tranmission,Substantial_Live_Digital_Simulcast ,
				Simuslcast_Platforms,Commentary_Languages,MBO_Critical_Notes,MTO_Critical_Notes)
		Select IntCode,Deal_No,Title,Content_Delivery,Modes_Broadcast,Obligation_Broadcast,Deferred_Live_Duration,Tape_Delayed_Duration,Standalone_Digital_Live,Substantial_Live_Stanalone
			   ,@strStandalone,Simulcast_Digital_Tranmission,Substantial_Live_Digital_Simulcast,@strSimulcast,Commentary_Languages,MBO_Critical_Notes,MTO_Critical_Notes
		From DM_Sport Where [Deal_No]  = @Excel_Deal_Code

		Update tmp Set tmp.GroupNo = a.GrpNo 
		From #TempTableStandalone_New tmp
			Inner Join (
				select ROW_NUMBER() Over(Order By [Deal_Code] asc) GrpNo,Content_Delivery ,Modes_Broadcast,Obligation_Broadcast,Deferred_Live_Duration,Tape_Delayed_Duration,
				Standalone_Digital_Live,Substantial_Live_Stanalone,Standalone_Platforms,Simulcast_Digital_Tranmission,Substantial_Live_Digital_Simulcast ,
				Simuslcast_Platforms,Commentary_Languages,MBO_Critical_Notes,MTO_Critical_Notes,Deal_Code
			from #TempTableStandalone_New
			group by 									
				Content_Delivery ,Modes_Broadcast,Obligation_Broadcast,Deferred_Live_Duration,Tape_Delayed_Duration,
				Standalone_Digital_Live,Substantial_Live_Stanalone,Standalone_Platforms,Simulcast_Digital_Tranmission,Substantial_Live_Digital_Simulcast ,
				Simuslcast_Platforms,Commentary_Languages,MBO_Critical_Notes,MTO_Critical_Notes,[Deal_Code]
		) as a On tmp.Deal_Code = a.Deal_Code  And tmp.Standalone_Platforms = a.Standalone_Platforms  and tmp.Simuslcast_Platforms=a.Simuslcast_Platforms
			And IsNull(tmp.Commentary_Languages, '') = IsNull(a.Commentary_Languages, '') And 
			IsNull(tmp.Content_Delivery, '') = IsNull(a.Content_Delivery, '') And 
			IsNull(tmp.Deal_Code, '') = IsNull(a.Deal_Code, '') And 
			IsNull(tmp.Deferred_Live_Duration, '') = IsNull(a.Deferred_Live_Duration, '') And 
			IsNull(tmp.Modes_Broadcast, '') = IsNull(a.Modes_Broadcast, '') And 
			IsNull(tmp.Obligation_Broadcast, '') = IsNull(a.Obligation_Broadcast, '') And 
			IsNull(tmp.MBO_Critical_Notes, '') = IsNull(a.MBO_Critical_Notes, '') And 
			IsNull(tmp.MTO_Critical_Notes, '') = IsNull(a.MTO_Critical_Notes, '') And 
			IsNull(tmp.Simulcast_Digital_Tranmission, '') = IsNull(a.Simulcast_Digital_Tranmission, '') And 
			IsNull(tmp.Standalone_Digital_Live, '') = IsNull(a.Standalone_Digital_Live, '') And 
			IsNull(tmp.Substantial_Live_Digital_Simulcast, '') = IsNull(a.Substantial_Live_Digital_Simulcast, '') And 
			IsNull(tmp.Substantial_Live_Stanalone, '') = IsNull(a.Substantial_Live_Stanalone, '') And 
			IsNull(tmp.Tape_Delayed_Duration, '') = IsNull(a.Tape_Delayed_Duration, '') 	
	
		Declare @Content_Dlv Varchar(100) = '', @BC_Modes Varchar(1000) = '', @BC_Oblig Varchar(1000) = '', @Def_Dur Varchar(100) = '', @Tape_Dur Varchar(100) = '',
				@St_Dig_Live Varchar(100) = '',@sub_Live_Standalone Varchar(1000) = '',@simul_Dig_Trans Varchar(1000) = '',@Sub_Live_Simul varchar(1000),
				@commentryLang varchar(1000), @GroupNo Int = 0, @Standalone_Platforms Varchar(1000) = '', @Simuslcast_Platforms Varchar(1000) = '', 
				@IntCode Int = 0,@MBO_Critical_Notes varchar(1000),@MTO_Critical_Notes varchar(1000)


		set   @MBO_Critical_Notes=''
		set	   @MTO_Critical_Notes=''--chk place remark declaration
		DECLARE CUR_Sport CURSOR READ_ONLY FOR 
				Select Distinct GroupNo From #TempTableStandalone_New

		OPEN CUR_Sport
		FETCH NEXT FROM CUR_Sport INTO @GroupNo
		WHILE (@@fetch_status = 0)
		BEGIN

			Select Top 1 @IntCode = IntCode From #TempTableStandalone_New Where GroupNo = @GroupNo

			 Select @Content_Dlv = '',
				   @BC_Modes = '',
				   @BC_Oblig = '',
				   @Def_Dur = '',
				   @Tape_Dur = '',
				   @St_Dig_Live = '',
				   @sub_Live_Standalone = '',		   
				   @Standalone_Platforms = '',
				   @simul_Dig_Trans = '',
				   @Sub_Live_Simul = '',
				   @Simuslcast_Platforms = '',		   
				   @commentryLang = '',
				  
				   @MBO_Critical_Notes='',
				   @MTO_Critical_Notes=''

			Select @Content_Dlv = Content_Delivery, @BC_Modes = Modes_Broadcast, @BC_Oblig = Obligation_Broadcast, @Def_Dur = Deferred_Live_Duration, 
				   @Tape_Dur = Tape_Delayed_Duration, @St_Dig_Live = Standalone_Digital_Live,@sub_Live_Standalone=Substantial_Live_Stanalone,
				   @simul_Dig_Trans=Simulcast_Digital_Tranmission,@Sub_Live_Simul=Substantial_Live_Digital_Simulcast,
				   @commentryLang=Commentary_Languages,@MBO_Critical_Notes=MBO_Critical_Notes,@MTO_Critical_Notes=MTO_Critical_Notes
			From DM_Sport Where IntCode = @IntCode
	
			Select 
				   @Content_Dlv = Content_Delivery,
				   @BC_Modes = Modes_Broadcast,
				   @BC_Oblig = Obligation_Broadcast,
				   @Def_Dur = Deferred_Live_Duration,
				   @Tape_Dur = Tape_Delayed_Duration,

				   @St_Dig_Live = Standalone_Digital_Live,
				   @sub_Live_Standalone = Substantial_Live_Stanalone,		   
				   @Standalone_Platforms = Standalone_Platforms,

				   @simul_Dig_Trans = Simulcast_Digital_Tranmission,
				   @Sub_Live_Simul = Substantial_Live_Digital_Simulcast,
				   @Simuslcast_Platforms = Simuslcast_Platforms,
		   
				   @commentryLang = Commentary_Languages,
				   @MBO_Critical_Notes=MBO_Critical_Notes,
				   @MTO_Critical_Notes=MTO_Critical_Notes
			From #TempTableStandalone_New
			Where IntCode = @IntCode
	
			Insert InTo Acq_Deal_Sport(Acq_Deal_Code, Content_Delivery, Obligation_Broadcast, 
									   Deferred_Live, 
									   Deferred_Live_Duration, 
									   Tape_Delayed, 
									   Tape_Delayed_Duration, 
									   Standalone_Transmission, Standalone_Substantial, 
									   Simulcast_Transmission, Simulcast_Substantial, 
									   Remarks,MBO_Note)
			Select @Acq_Deal_Code, Case When @Content_Dlv = 'Live' Then 'LV' Else 'RC' End, Case When IsNull(@BC_Oblig, '') <> '' Then 'Y' Else 'N' End,
				   Case When IsNull(@Def_Dur, '') = 'Unlimited' Then 'UL' 
						When IsNull(@Def_Dur, '') = '' Then 'NA'
						Else 'DF' 
				   End, 
				   Case When IsNull(@Def_Dur, '') = '' Or IsNull(@Def_Dur, '') = 'Unlimited' Then Null Else @Def_Dur End,
				   Case When IsNull(@Tape_Dur, '') = 'Unlimited' Then 'UL'
						When IsNull(@Tape_Dur, '') = '' Then 'NA'
						Else 'DF' 
				   End, 
				   Case When IsNull(@Tape_Dur, '') = '' Or IsNull(@Tape_Dur, '') = 'Unlimited' Then NULL Else @Tape_Dur End,
				   Case When IsNull(@St_Dig_Live, '') = 'YES' Then 'Y' Else 'N' End, Case When IsNull(@sub_Live_Standalone, '') = 'YES' Then 'Y' Else 'N' End,
				   Case When IsNull(@simul_Dig_Trans, '') = 'YES' Then 'Y' Else 'N' End, Case When IsNull(@Sub_Live_Simul, '') = 'YES' Then 'Y' Else 'N' End,
				   @MTO_Critical_Notes,@MBO_Critical_Notes

			Declare @Acq_Deal_Sport Int = 0
			Select @Acq_Deal_Sport = IDENT_CURRENT('Acq_Deal_Sport')

			Insert InTo Acq_Deal_Sport_Title(Acq_Deal_Sport_Code, Title_Code, Episode_From, Episode_To)
			SELECT @Acq_Deal_Sport, titNew.Title_Code, adm.Episode_Starts_From, adm.Episode_End_To
			FROM #TempTableStandalone_New t1
			Inner Join Rightsu_vmpl_live_27March_2015.dbo.Title tit on t1.Title = tit.english_title
			Inner Join Title titNew On tit.english_title = titNew.Title_Name
			Inner Join Acq_Deal_Movie adm On adm.Title_Code = titNew.Title_Code And adm.Acq_Deal_Code = @Acq_Deal_Code And GroupNo = @GroupNo
	
			Insert InTo Acq_Deal_Sport_Broadcast(Acq_Deal_Sport_Code, Broadcast_Mode_Code, [Type])
			Select @Acq_Deal_Sport, b.Broadcast_Mode_Code, 'MO' From DBO.fn_Split_withdelemiter(IsNull(@BC_Modes, ''), ',') a 
			Inner Join Broadcast_Mode b On a.number = b.Broadcast_Mode_Name
	
			Insert InTo Acq_Deal_Sport_Broadcast(Acq_Deal_Sport_Code, Broadcast_Mode_Code, [Type])
			Select @Acq_Deal_Sport, b.Broadcast_Mode_Code, 'OB' From DBO.fn_Split_withdelemiter(IsNull(@BC_Oblig, ''), ',') a 
			Inner Join Broadcast_Mode b On a.number = b.Broadcast_Mode_Name

			If(IsNull(@Standalone_Platforms, '') <> '')
			Begin
				Insert InTo Acq_Deal_Sport_Platform(Acq_Deal_Sport_Code, Platform_Code, [Type])
				Select @Acq_Deal_Sport, a.number, 'ST' From DBO.fn_Split_withdelemiter(IsNull(@Standalone_Platforms, ''), ',') a 
			End
	
			If(IsNull(@Simuslcast_Platforms, '') <> '')
			Begin
				Insert InTo Acq_Deal_Sport_Platform(Acq_Deal_Sport_Code, Platform_Code, [Type])
				Select @Acq_Deal_Sport, a.number, 'SM' From DBO.fn_Split_withdelemiter(IsNull(@Simuslcast_Platforms, ''), ',') a 
			End

			If((Select Count(*) From Language_Group Where Language_Group_Name In (
					Select ltrim(rtrim(number)) from DBO.fn_Split_withdelemiter(isnull(@commentryLang, ''), ',')
				)) > 0)
			Begin
				Insert InTo Acq_Deal_Sport_Language(Acq_Deal_Sport_Code, Language_Code, Language_Group_Code, Language_Type, Flag)
				Select @Acq_Deal_Sport, lgd.Language_Code, a.Language_Group_Code, 'G', 'C' From (
					Select Language_Group_Code From Language_Group Where Language_Group_Name In (
						Select ltrim(rtrim(number)) from DBO.fn_Split_withdelemiter(isnull(@commentryLang, ''), ',')
					)
				) as a 
				Inner Join Language_Group_Details lgd On 1=1 And lgd.Language_Group_Code = a.Language_Group_Code
			End
			Else If(IsNull(@commentryLang, '') <> '')
			Begin
				Insert InTo Acq_Deal_Sport_Language(Acq_Deal_Sport_Code, Language_Code, Language_Group_Code, Language_Type, Flag)
				Select @Acq_Deal_Sport, Language_Code, Null, 'L', 'C' From (
					Select language_code From [Language] Where language_name In (
						Select ltrim(rtrim(number)) from DBO.fn_Split_withdelemiter(isnull(@commentryLang, ''), ',')
					)
				) as a
			End

			FETCH NEXT FROM CUR_Sport INTO @GroupNo
		End
		Close CUR_Sport
		Deallocate CUR_Sport

		drop table #TempTableStandalone
		drop table #TempTableStandalone_New
		drop table #TempTableSimulcast

	END
	*/
	Declare @Is_Error Varchar(10) = ''
	

	--print 'USP_AT_Acq_Deal'
	--if(
	--	(
	--		Select Count(*) From DM_Runs_Allocation Where [Acquisition Deal No] In (
	--			Select Payment_Terms_Conditions From Acq_Deal Where Acq_Deal_Code = @Acq_Deal_Code
	--		)
	--	) < 1
	--)
	--Begin
		Exec USP_AT_Acq_Deal @Acq_Deal_Code, @Is_Error Out
		
		--Insert InTo Module_Status_History
		--Select 30, @Acq_Deal_Code, 'A', 143, GetDate(), 'System Migrated Deal'
	--End
	--Else
	--	Update Acq_Deal Set Deal_Workflow_Status = 'N' Where Acq_Deal_Code = @Acq_Deal_Code
	
	
	/*  Acq_Deal_Rights_Title_EPS
	*/
	Declare @Acq_Deal_Rights_Title_Code Int = 0
	Declare cur_tit Cursor For 
		Select Acq_Deal_Rights_Title_Code From Acq_Deal_Rights_Title
	Open cur_tit
	Fetch Next From cur_tit InTo @Acq_Deal_Rights_Title_Code
	While (@@FETCH_STATUS = 0)
	Begin
		--Print @Acq_Deal_Rights_Title_Code
		Update Acq_Deal_Rights_Title Set Episode_From = Episode_From Where Acq_Deal_Rights_Title_Code = @Acq_Deal_Rights_Title_Code
		Fetch Next From cur_tit InTo @Acq_Deal_Rights_Title_Code
	End
	Close cur_tit
	Deallocate cur_tit


	/* Module_Status_History
	*/
	Insert InTo Module_Status_History (Module_Code,Record_Code,Status,Status_Changed_By,Status_Changed_On,Remarks)
	select module_code,@Acq_Deal_Code,
	CASE WHEN (case when CHARINDEX('~',status,0) =0 then status else substring(status,0,CHARINDEX('~',status,0)) end)='S' then 'W' 
	WHEN (case when CHARINDEX('~',status,0) =0 then status else substring(status,0,CHARINDEX('~',status,0)) end)='RS' then 'E'
	else (case when CHARINDEX('~',status,0) =0 then status else substring(status,0,CHARINDEX('~',status,0)) end) end
	,status_changed_by,status_changed_on,remarks from 
	Rightsu_vmpl_live_27March_2015.dbo.Module_Status_History where 
	Record_Code=@DEALCODE and module_code=30

	Insert InTo Module_Status_History (Module_Code,Record_Code,Status,Status_Changed_By,Status_Changed_On,Remarks)
	select module_code,@Acq_Deal_Code,'W',status_changed_by,status_changed_on,remarks from 
	Rightsu_vmpl_live_27March_2015.dbo.Module_Status_History where 
	Record_Code=@DEALCODE and module_code=30
	and (case when CHARINDEX('~',status,0) =0 then status else substring(status,0,CHARINDEX('~',status,0)) end)='RS' 

	insert into Module_Workflow_Detail (Module_Code,Record_Code,Group_Code,Primary_User_Code,Role_Level,Is_Done,Next_Level_Group,Entry_Date)
	select Module_Code,@Acq_Deal_Code,Group_Code,Primary_User_Code,Role_Level,Is_Done,Next_Level_Group,Entry_Date 
	from Rightsu_vmpl_live_27March_2015.dbo.Module_Workflow_Detail 
	where module_code=30 and record_code=@DEALCODE

	Exec USP_Generate_Title_Content @Acq_Deal_Code, '', NULL
	DROP TABLE #Exclusive_Group	
END TRY

BEGIN CATCH

	CLOSE CUR_DMA_ADA
	DEALLOCATE CUR_DMA_ADA

	CLOSE CUR_DMRR_ADR
	DEALLOCATE CUR_DMRR_ADR

	CLOSE CUR_DMR_ADR_GROUP
	DEALLOCATE CUR_DMR_ADR_GROUP
	
	CLOSE CUR_DRRHB_ADP
	DEALLOCATE CUR_DRRHB_ADP
	
	Close CUR_Sport
	Deallocate CUR_Sport
	
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
		   @DEALCODE
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
END

SET ANSI_NULLS ON