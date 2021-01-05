-- =============================================
-- Author:		<Reshma Kunjal>
-- Create date: <22/1/2015>
-- Description:	<Mass Territory Update Schedule Runs >
-- =============================================
CREATE PROCEDURE [dbo].[USP_Mass_Territory_Update_Schedule]
	
	--@UserCode int,
	--@result int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select admtu.Acq_Deal_Mass_Update_Code,admtu.Acq_Deal_Code,adr.Acq_Deal_Rights_Code ,count(adr.Acq_Deal_Rights_Code) cntDealRun
	into #tmpAcqDealMassUpdate
	from Acq_Deal_Mass_Territory_Update admtu 
	inner join Acq_Deal_Rights adr on adr.Acq_Deal_Code=admtu.Acq_Deal_Code
	inner join Acq_Deal ad on ad.Acq_Deal_Code=admtu.Acq_Deal_Code
	where  AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND admtu.Can_Process='Y' and ad.Deal_Workflow_Status='A'
	--and admtu.Acq_Deal_Mass_Update_Code=275 
	group by admtu.Acq_Deal_Mass_Update_Code,admtu.Acq_Deal_Code,adr.Acq_Deal_Rights_Code 
	order by admtu.Acq_Deal_Code,adr.Acq_Deal_Rights_Code 

	--select distinct adr.Acq_Deal_Rights_Code  from Acq_Deal_Rights_Territory adrt 
	--inner join Acq_Deal_Rights adr on adr.Acq_Deal_Rights_Code=adrt.Acq_Deal_Rights_Code
	--inner join Acq_Deal_Mass_Territory_Update_Details admtud on admtud.Territory_Code=adrt.Territory_Code
	--where adr.Acq_Deal_Rights_Code=2770 and admtud.Acq_Deal_Mass_Update_Code=275

	
	declare @dealRunCount int =1
	-- =============================================
	-- Declare and using a KEYSET cursor
	-- =============================================
	DECLARE CUR_MASS_UPDATE CURSOR
	
	FOR Select Acq_Deal_Mass_Update_Code,Acq_Deal_Code,Acq_Deal_Rights_Code,cntDealRun  from #tmpAcqDealMassUpdate

	DECLARE @Acq_Deal_Mass_Update_Code int,
			@Acq_Deal_Code int,
			@Acq_Deal_Rights_Code int,
			@cntDealRun int

	OPEN CUR_MASS_UPDATE

	FETCH NEXT FROM CUR_MASS_UPDATE INTO @Acq_Deal_Mass_Update_Code,@Acq_Deal_Code,@Acq_Deal_Rights_Code,@cntDealRun
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

			declare @validRight int=0,@cntCountry int =0
			
			select 
				@validRight=count(adr.Acq_Deal_Rights_Code)  
			from 
				Acq_Deal_Rights_Territory adrt 
				inner join Acq_Deal_Rights adr on adr.Acq_Deal_Rights_Code=adrt.Acq_Deal_Rights_Code
				inner join Acq_Deal_Mass_Territory_Update_Details admtud on admtud.Territory_Code=adrt.Territory_Code
			where 
				adr.Acq_Deal_Rights_Code=@Acq_Deal_Rights_Code and admtud.Acq_Deal_Mass_Update_Code=@Acq_Deal_Mass_Update_Code
			
			select @cntCountry=COUNT(*) from Acq_Deal_Mass_Territory_Update_Details admtud 
			inner join Territory_Details td on td.Territory_Code=admtud.Territory_Code
			inner join 
			(
				select  distinct adrtt.Acq_Deal_Rights_Code,adrtt.Territory_Code 
				from Acq_Deal_Rights_Territory adrtt) a 
			on a.Acq_Deal_Rights_Code=@Acq_Deal_Rights_Code and a.Territory_Code=admtud.Territory_Code 
			where admtud.Acq_Deal_Mass_Update_Code=@Acq_Deal_Mass_Update_Code
			and td.Country_Code not in 
			(
				select adrt.Country_Code from Acq_Deal_Rights_Territory adrt
				inner join Acq_Deal_Mass_Territory_Update_Details admtud on admtud.Territory_Code=adrt.Territory_Code
				inner join Acq_Deal_Mass_Territory_Update admtu on admtu.Acq_Deal_Mass_Update_Code=admtud.Acq_Deal_Mass_Update_Code
				where adrt.Acq_Deal_Rights_Code=@Acq_Deal_Rights_Code and admtu.Acq_Deal_Mass_Update_Code=@Acq_Deal_Mass_Update_Code
			)

			if(@validRight>0 and @cntCountry>0)
			begin
				 --print @validRight
				 print @dealRunCount
				 print @cntDealRun
					/*----RIGHTS TERRITORY-----*/
					
					insert into Acq_Deal_Rights_Territory (Acq_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code)
					select @Acq_Deal_Rights_Code,'G',td.Country_Code,admtud.Territory_Code from Acq_Deal_Mass_Territory_Update_Details admtud 
					inner join Territory_Details td on td.Territory_Code=admtud.Territory_Code
					inner join 
					(
						select  distinct adrtt.Acq_Deal_Rights_Code,adrtt.Territory_Code 
						from Acq_Deal_Rights_Territory adrtt) a 
					on a.Acq_Deal_Rights_Code=@Acq_Deal_Rights_Code and a.Territory_Code=admtud.Territory_Code 
					where admtud.Acq_Deal_Mass_Update_Code=@Acq_Deal_Mass_Update_Code
					and td.Country_Code not in 
					(
						select adrt.Country_Code from Acq_Deal_Rights_Territory adrt
						inner join Acq_Deal_Mass_Territory_Update_Details admtud on admtud.Territory_Code=adrt.Territory_Code
						inner join Acq_Deal_Mass_Territory_Update admtu on admtu.Acq_Deal_Mass_Update_Code=admtud.Acq_Deal_Mass_Update_Code
						where adrt.Acq_Deal_Rights_Code=@Acq_Deal_Rights_Code and admtu.Acq_Deal_Mass_Update_Code=@Acq_Deal_Mass_Update_Code
					)
					
					if(@dealRunCount=@cntDealRun)
					begin
					   				   
					   declare @isDone int =0
					   select @isDone=count(*) from Acq_Deal_Mass_Territory_Update where Acq_Deal_Mass_Update_Code=@Acq_Deal_Mass_Update_Code 
					   and Can_Process='D'

					   if(@isDone=0)
					   begin

						   /*------ACQ DEAL -VERSION----*/
						   update Acq_Deal set version=right(('000'+Convert(varchar(50),(version+1))),4)
						   where Acq_Deal_code=@Acq_Deal_Code

						   /*------MASS TERRITORY UPDATE----*/
						   update Acq_Deal_Mass_Territory_Update set Can_Process='D' , Processed_Date=getdate()
						   where Acq_Deal_Mass_Update_Code=@Acq_Deal_Mass_Update_Code 
						   and Can_Process='Y'

						   /*----DEAL ENTRY IN AT_ACQ_DEAL---*/
						   declare @Is_Error char(1) ='1'
						   Exec DBO.USP_AT_Acq_Deal @Acq_Deal_Code, @Is_Error Out
					   
						   select * from Module_Status_History
						   /*----Module Status History---*/
						   insert into Module_Status_History (Module_Code,Record_Code,Status,Status_Changed_By,Status_Changed_On,Remarks )
						   select 30,@Acq_Deal_Code,'A',143,GETDATE(),'System Approved after Mass Territory Update' 
					  end   
						   set @dealRunCount=1
                   
				   end
				   else
				   begin
						set @dealRunCount=@dealRunCount+1
				   end

			end
			
		END
		FETCH NEXT FROM CUR_MASS_UPDATE INTO @Acq_Deal_Mass_Update_Code,@Acq_Deal_Code,@Acq_Deal_Rights_Code,@cntDealRun
	END

	CLOSE CUR_MASS_UPDATE
	DEALLOCATE CUR_MASS_UPDATE
	
	drop table #tmpAcqDealMassUpdate
	
	---------- End Acq Deal Mass Territory Update----------
	
	---------- Start Syn Deal Mass Territory Update----------
	
	select admtu.Syn_Deal_Mass_Update_Code,admtu.Syn_Deal_Code,adr.Syn_Deal_Rights_Code ,count(adr.Syn_Deal_Rights_Code) cntDealRun
	into #tmpSynDealMassUpdate
	from Syn_Deal_Mass_Territory_Update admtu 
	inner join Syn_Deal_Rights adr on adr.Syn_Deal_Code=admtu.Syn_Deal_Code
	inner join Syn_Deal ad on ad.Syn_Deal_Code=admtu.Syn_Deal_Code
	where admtu.Can_Process='Y' and ad.Deal_Workflow_Status='A'
	group by admtu.Syn_Deal_Mass_Update_Code,admtu.Syn_Deal_Code,adr.Syn_Deal_Rights_Code 
	order by admtu.Syn_Deal_Code,adr.Syn_Deal_Rights_Code 
	
	SET @dealRunCount = 1
	-- =============================================
	-- Declare and using a KEYSET cursor
	-- =============================================
	DECLARE CUR_SYN_MASS_UPDATE CURSOR
	
	FOR Select Syn_Deal_Mass_Update_Code,Syn_Deal_Code,Syn_Deal_Rights_Code,cntDealRun  from #tmpSynDealMassUpdate

	DECLARE @Syn_Deal_Mass_Update_Code int,
			@Syn_Deal_Code int,
			@Syn_Deal_Rights_Code int,
			@cntSynDealRun int

	OPEN CUR_SYN_MASS_UPDATE

	FETCH NEXT FROM CUR_SYN_MASS_UPDATE INTO @Syn_Deal_Mass_Update_Code,@Syn_Deal_Code,@Syn_Deal_Rights_Code,@cntSynDealRun
	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN

			declare @validSynRight int=0,@cntSynCountry int =0
			
			select 
				@validSynRight=count(adr.Syn_Deal_Rights_Code)  
			from 
				Syn_Deal_Rights_Territory adrt 
				inner join Syn_Deal_Rights adr on adr.Syn_Deal_Rights_Code=adrt.Syn_Deal_Rights_Code
				inner join Syn_Deal_Mass_Territory_Update_Details admtud on admtud.Territory_Code=adrt.Territory_Code
			where 
				adr.Syn_Deal_Rights_Code=@Syn_Deal_Rights_Code and admtud.Syn_Deal_Mass_Update_Code=@Syn_Deal_Mass_Update_Code
			
			select @cntSynCountry=COUNT(*) from Syn_Deal_Mass_Territory_Update_Details admtud 
			inner join Territory_Details td on td.Territory_Code=admtud.Territory_Code
			inner join 
			(
				select  distinct adrtt.Syn_Deal_Rights_Code,adrtt.Territory_Code 
				from Syn_Deal_Rights_Territory adrtt) a 
			on a.Syn_Deal_Rights_Code=@Syn_Deal_Rights_Code and a.Territory_Code=admtud.Territory_Code 
			where admtud.Syn_Deal_Mass_Update_Code=@Syn_Deal_Mass_Update_Code
			and td.Country_Code not in 
			(
				select adrt.Country_Code from Syn_Deal_Rights_Territory adrt
				inner join Syn_Deal_Mass_Territory_Update_Details admtud on admtud.Territory_Code=adrt.Territory_Code
				inner join Syn_Deal_Mass_Territory_Update admtu on admtu.Syn_Deal_Mass_Update_Code=admtud.Syn_Deal_Mass_Update_Code
				where adrt.Syn_Deal_Rights_Code=@Syn_Deal_Rights_Code and admtu.Syn_Deal_Mass_Update_Code=@Syn_Deal_Mass_Update_Code
			)

			if(@validSynRight>0 and @cntSynCountry>0)
			begin
				 --print @validRight
				 print @dealRunCount
				 print @cntSynDealRun
					/*----RIGHTS TERRITORY-----*/
					
					insert into Syn_Deal_Rights_Territory (Syn_Deal_Rights_Code,Territory_Type,Country_Code,Territory_Code)
					select @Syn_Deal_Rights_Code,'G',td.Country_Code,admtud.Territory_Code from Syn_Deal_Mass_Territory_Update_Details admtud 
					inner join Territory_Details td on td.Territory_Code=admtud.Territory_Code
					inner join 
					(
						select  distinct adrtt.Syn_Deal_Rights_Code,adrtt.Territory_Code 
						from Syn_Deal_Rights_Territory adrtt) a 
					on a.Syn_Deal_Rights_Code=@Syn_Deal_Rights_Code and a.Territory_Code=admtud.Territory_Code 
					where admtud.Syn_Deal_Mass_Update_Code=@Syn_Deal_Mass_Update_Code
					and td.Country_Code not in 
					(
						select adrt.Country_Code from Syn_Deal_Rights_Territory adrt
						inner join Syn_Deal_Mass_Territory_Update_Details admtud on admtud.Territory_Code=adrt.Territory_Code
						inner join Syn_Deal_Mass_Territory_Update admtu on admtu.Syn_Deal_Mass_Update_Code=admtud.Syn_Deal_Mass_Update_Code
						where adrt.Syn_Deal_Rights_Code=@Syn_Deal_Rights_Code and admtu.Syn_Deal_Mass_Update_Code=@Syn_Deal_Mass_Update_Code
					)
					
					if(@dealRunCount=@cntSynDealRun)
					begin
					   				   
					   declare @isSynMassDone int =0
					   select @isSynMassDone=count(*) from Syn_Deal_Mass_Territory_Update where Syn_Deal_Mass_Update_Code=@Syn_Deal_Mass_Update_Code 
					   and Can_Process='D'

					   if(@isSynMassDone=0)
					   begin

						   /*------Syn_Deal -VERSION----*/
						   update Syn_Deal set version=right(('000'+Convert(varchar(50),(version+1))),4)
						   where Syn_Deal_Code=@Syn_Deal_Code

						   /*------Syn_Deal_Mass_Territory_Update----*/
						   update Syn_Deal_Mass_Territory_Update set Can_Process='D' , Processed_Date=getdate()
						   where Syn_Deal_Mass_Update_Code=@Syn_Deal_Mass_Update_Code 
						   and Can_Process='Y'

						   /*----DEAL ENTRY IN AT_SYN_DEAL---*/
						   declare @Is_Syn_Error char(1) ='1'
						   Exec DBO.USP_AT_Syn_Deal @Syn_Deal_Code, @Is_Syn_Error Out
					   
						   select * from Module_Status_History
						   /*----Module Status History---*/
						   insert into Module_Status_History (Module_Code,Record_Code,Status,Status_Changed_By,Status_Changed_On,Remarks )
						   select 35,@Syn_Deal_Code,'A',143,GETDATE(),'System Approved after Mass Territory Update' 
					  end   
						   set @dealRunCount=1
                   
				   end
				   else
				   begin
						set @dealRunCount=@dealRunCount+1
				   end

			end
			
		END
		FETCH NEXT FROM CUR_SYN_MASS_UPDATE INTO @Syn_Deal_Mass_Update_Code,@Syn_Deal_Code,@Syn_Deal_Rights_Code,@cntSynDealRun
	END

	CLOSE CUR_SYN_MASS_UPDATE
	DEALLOCATE CUR_SYN_MASS_UPDATE
	
	drop table #tmpSynDealMassUpdate
	IF OBJECT_ID('tempdb..#tmpAcqDealMassUpdate') IS NOT NULL DROP TABLE #tmpAcqDealMassUpdate
	IF OBJECT_ID('tempdb..#tmpSynDealMassUpdate') IS NOT NULL DROP TABLE #tmpSynDealMassUpdate
	
END