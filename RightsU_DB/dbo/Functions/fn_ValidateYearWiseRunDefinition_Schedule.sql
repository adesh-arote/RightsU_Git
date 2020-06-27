

CREATE FUNCTION [dbo].[fn_ValidateYearWiseRunDefinition_Schedule]
(
	@VW_DMR_Run_Code_Cr INT,
	@ON_AIR_Cr VARCHAR(500),
	@IsWithRight char(1)
)
RETURNS char
AS
BEGIN


DECLARE @Result char(1)
DECLARE @YearwiseRunAvailable int 
DECLARE @no_of_runs_sched int 
DECLARE @no_of_runs_asrun int 



set @Result = 'Y'



if(@IsWithRight = 'Y')
BEGIN
	select  distinct @YearwiseRunAvailable =  (DMRRYR.no_of_runs) from ACQ_Deal_Run_Yearwise_Run AS  DMRRYR
	WHERE DMRRYR.Acq_Deal_Run_Code = @VW_DMR_Run_Code_Cr
	and ----------Right Period Validation                                        
	(
		@ON_AIR_Cr between CAST(isnull(DMRRYR.start_date, @ON_AIR_Cr) AS DATETIME)
		and CAST(isnull(DMRRYR.end_date, @ON_AIR_Cr) AS DATETIME)
	)
	
	
	select  distinct @no_of_runs_sched = (DMRRYR.no_of_runs_sched), @no_of_runs_asrun = (DMRRYR.no_of_AsRuns) from ACQ_Deal_Run_Yearwise_Run  AS  DMRRYR	
	WHERE DMRRYR.Acq_Deal_Run_Code = @VW_DMR_Run_Code_Cr
	and ----------Right Period Validation                                        
	(
		@ON_AIR_Cr between CAST(isnull(DMRRYR.start_date, @ON_AIR_Cr) AS DATETIME)
		and CAST(isnull(DMRRYR.end_date, @ON_AIR_Cr) AS DATETIME)
	)
	set @no_of_runs_sched = isnull(@no_of_runs_sched,0) + isnull(@no_of_runs_asrun,0)
	
	if(@YearwiseRunAvailable < @no_of_runs_sched)
	BEGIN
		set @Result = 'N'
	END
END


ELSE IF(@IsWithRight = 'N')
BEGIN
	--@VW_DMR_Run_Code_Cr
	select  distinct @YearwiseRunAvailable =  (DMRRYR.no_of_runs) from ACQ_Deal_Run_Yearwise_Run AS  DMRRYR
	WHERE DMRRYR.Acq_Deal_Run_Yearwise_Run_Code = @VW_DMR_Run_Code_Cr
	--and ----------Right Period Validation                                        
	--(
	--	@ON_AIR_Cr between CAST(isnull(DMRRYR.start_date, @ON_AIR_Cr) AS DATETIME)
	--	and CAST(isnull(DMRRYR.end_date, @ON_AIR_Cr) AS DATETIME)
	--)
	
	
	select  distinct @no_of_runs_sched = (DMRRYR.no_of_runs_sched) , @no_of_runs_asrun = (DMRRYR.no_of_AsRuns) from ACQ_Deal_Run_Yearwise_Run  AS  DMRRYR	
	WHERE DMRRYR.Acq_Deal_Run_Yearwise_Run_Code = @VW_DMR_Run_Code_Cr
	--and ----------Right Period Validation                                        
	--(
	--	@ON_AIR_Cr between CAST(isnull(DMRRYR.start_date, @ON_AIR_Cr) AS DATETIME)
	--	and CAST(isnull(DMRRYR.end_date, @ON_AIR_Cr) AS DATETIME)
	--)
	set @no_of_runs_sched = isnull(@no_of_runs_sched,0) + isnull(@no_of_runs_asrun,0)
	if(@YearwiseRunAvailable < @no_of_runs_sched)
	BEGIN
		set @Result = 'N'
	END 
END

RETURN @Result 
     
END









/*


select * FROM Deal_Movie_Rights_Run_Yearwise_Run DMRRYR
										WHERE DMRRYR.deal_movie_rights_run_code = @VW_DMR_Run_Code_Cr
										and ----------Right Period Validation                                        
										(                                        
											@ON_AIR_Cr between CAST(isnull(DMRRYR.start_date, @ON_AIR_Cr) AS DATETIME)
											and CAST(isnull(DMRRYR.end_date, @ON_AIR_Cr) AS DATETIME)
										)----------/Right Period Validation                                        


select * from title where english_title like 'rea%'
select * from deal where deal_no = '23'
select * from Deal_movie where deal_code = 24 and title_code = 238
select * from Deal_Movie_Rights where deal_movie_code = 230
select * from Deal_Movie_Rights_Run where deal_movie_rights_code in 
(
	select deal_movie_rights_code from Deal_Movie_Rights where deal_movie_code = 230
)

*/