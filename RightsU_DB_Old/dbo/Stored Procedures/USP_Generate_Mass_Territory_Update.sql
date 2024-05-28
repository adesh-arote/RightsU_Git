ALTER Proc [dbo].[USP_Generate_Mass_Territory_Update](@TerritoryCodes Varchar(4000),@UserId int)
As
Begin

		-- =============================================
		-- Author:Reshma Kunjal
		-- Create DATE: 14-1-2015
		-- Description:	Inserts Deal data to be processed when new country is added to territory
		-- =============================================
	
		/*
		select * from Territory
		select * from [Acq_Deal_Mass_Territory_Update]
		select * from [Acq_Deal_Mass_Territory_Update_Details]
		select * from [Acq_Deal_Mass_Update_ErrorLog]
		
		select * from Acq_Deal
		select * from Acq_Deal_Rights
		select * from Acq_Deal_Rights_Territory
		*/
		
		/*Insert into Acq_Deal_Mass_Territory_Update*/
	   INSERT INTO 
			Acq_Deal_Mass_Territory_Update (Acq_Deal_Code,Date,Status,Processed_Date,Can_Process,Created_By)
	   select 
			distinct ad.Acq_Deal_Code,GETDATE(),'',NULL,'N',@UserId
		from 
			Acq_Deal ad inner join 
			Acq_Deal_Rights adr on adr.Acq_Deal_Code=ad.Acq_Deal_Code inner join 
			Acq_Deal_Rights_Territory adrt on adrt.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
		where 
			AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND 
			adrt.Territory_Type='G' and ad.Is_Active='Y' and ad.Deal_Workflow_Status='A'
			and isnull(adrt.Territory_Code,0) in (Select number from dbo.[fn_Split_withdelemiter](@TerritoryCodes,','))
			and ad.Acq_Deal_Code not in (select Acq_Deal_Code from Acq_Deal_Mass_Territory_Update where Can_Process in ('N'))
			

		/*Insert into [Acq_Deal_Mass_Territory_Update_Details]*/
		insert into 
			Acq_Deal_Mass_Territory_Update_Details (Acq_Deal_Mass_Update_Code,Territory_Code)
		select 
			admtu.Acq_Deal_Mass_Update_Code,a.Territory_Code from 
		( 
			select 
				distinct adrt.Territory_Code ,ad.Acq_Deal_Code 
			from
				Acq_Deal ad inner join
				Acq_Deal_Rights adr on ad.Acq_Deal_Code=adr.Acq_Deal_Code
				inner join Acq_Deal_Rights_Territory adrt on adrt.Acq_Deal_Rights_Code=adr.Acq_Deal_Rights_Code
			where 
				AD.Deal_Workflow_Status NOT IN ('AR', 'WA') AND 
				adrt.Territory_Type='G' 
				and isnull(adrt.Territory_Code,0) in (Select number from dbo.[fn_Split_withdelemiter](@TerritoryCodes,','))
		) as a 
			inner join Acq_Deal_Mass_Territory_Update admtu on admtu.Acq_Deal_Code=a.Acq_Deal_Code 
			left join Acq_Deal_Mass_Territory_Update_Details  admtud on admtud.Acq_Deal_Mass_Update_Code=admtu.Acq_Deal_Mass_Update_Code
		where 
			admtu.Can_Process in ('N') and isnull(admtud.Territory_Code,0)<>a.Territory_Code

		/*Insert into Syn_Deal_Mass_Territory_Update*/
	   INSERT INTO 
			Syn_Deal_Mass_Territory_Update (Syn_Deal_Code,Date,Status,Processed_Date,Can_Process,Created_By)
	   select 
			distinct ad.Syn_Deal_Code,GETDATE(),'',NULL,'N',@UserId
		from 
			Syn_Deal ad inner join 
			Syn_Deal_Rights adr on adr.Syn_Deal_Code=ad.Syn_Deal_Code inner join 
			Syn_Deal_Rights_Territory adrt on adrt.Syn_Deal_Rights_Code=adr.Syn_Deal_Rights_Code
		where 
			adrt.Territory_Type='G' and ad.Is_Active='Y' and ad.Deal_Workflow_Status='A'
			and isnull(adrt.Territory_Code,0) in (Select number from dbo.[fn_Split_withdelemiter](@TerritoryCodes,','))
			and ad.Syn_Deal_Code not in (select Syn_Deal_Code from Syn_Deal_Mass_Territory_Update where Can_Process in ('N'))
			

		/*Insert into [Syn_Deal_Mass_Territory_Update_Details]*/
		insert into 
			Syn_Deal_Mass_Territory_Update_Details (Syn_Deal_Mass_Update_Code,Territory_Code)
		select 
			admtu.Syn_Deal_Mass_Update_Code,a.Territory_Code from 
		( 
			select 
				distinct adrt.Territory_Code ,ad.Syn_Deal_Code 
			from
				Syn_Deal ad inner join
				Syn_Deal_Rights adr on ad.Syn_Deal_Code=adr.Syn_Deal_Code
				inner join Syn_Deal_Rights_Territory adrt on adrt.Syn_Deal_Rights_Code=adr.Syn_Deal_Rights_Code
			where 
				adrt.Territory_Type='G' 
				and isnull(adrt.Territory_Code,0) in (Select number from dbo.[fn_Split_withdelemiter](@TerritoryCodes,','))
		) as a 
			inner join Syn_Deal_Mass_Territory_Update admtu on admtu.Syn_Deal_Code=a.Syn_Deal_Code 
			left join Syn_Deal_Mass_Territory_Update_Details  admtud on admtud.Syn_Deal_Mass_Update_Code=admtu.Syn_Deal_Mass_Update_Code
		where 
			admtu.Can_Process in ('N') and isnull(admtud.Territory_Code,0)<>a.Territory_Code

			

		--select * from Acq_Deal_Mass_Territory_Update
		--select * from Acq_Deal_Mass_Territory_Update_Details

End

/*

	exec [USP_Generate_Mass_Territory_Update] ',2'

	delete from Acq_Deal_Mass_Territory_Update 
	delete from Acq_Deal_Mass_Territory_Update_Details 
	
	update Acq_Deal_Mass_Territory_Update set can_process='Y' where Acq_Deal_Mass_Update_code=114 
	select * from [Acq_Deal_Mass_Territory_Update]
	select * from [Acq_Deal_Mass_Territory_Update_Details]

*/