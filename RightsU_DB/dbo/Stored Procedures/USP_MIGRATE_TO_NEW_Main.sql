
CREATE PROC [dbo].[USP_MIGRATE_TO_NEW_Main]
(
	@dBug CHAR(1)='N'
)
AS
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 07-November-2014
-- Description: SP to migrate LOOP ON ALL DEALS AND CAll Migrate SP
-- =============================================
BEGIN
	DECLARE @Deal_Code_Cur INT
	DECLARE CUR_DEAL CURSOR
	READ_ONLY
	FOR 
	--SELECT Deal_Code FROM Rightsu_vmpl_live_27March_2015.dbo.Deal WHERE deal_no NOT IN (SELECT Agreement_No FROM Acq_Deal)
	
	SELECT Deal_Code FROM Rightsu_vmpl_live_27March_2015.dbo.Deal  
	WHERE deal_code not in (SELECT Deal_Code FROM Rightsu_vmpl_live_27March_2015.dbo.Deal where deal_no='A-2015-00002')
	OPEN CUR_DEAL	

	FETCH NEXT FROM CUR_DEAL INTO @Deal_Code_Cur

	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			EXEC USP_MIGRATE_TO_NEW @Deal_Code_Cur,@dBug
		END
		FETCH NEXT FROM CUR_DEAL INTO @Deal_Code_Cur		
	END
	CLOSE CUR_DEAL
	DEALLOCATE CUR_DEAL


	------------------------UPDATE Master_Deal_Movie_Code_ToLink
	Update adOld
	set adOld.Master_Deal_Movie_Code_ToLink=adm.Acq_Deal_Movie_Code
	from Acq_Deal adOld
	inner join Rightsu_vmpl_live_27March_2015.dbo.Deal_Movie dm on adOld.Master_Deal_Movie_Code_ToLink=dm.Deal_Movie_Code
	inner join Rightsu_vmpl_live_27March_2015.dbo.Title t on t.Title_Code=dm.Title_Code 
	inner join Title tNew on tNew.Title_Name=t.english_title  and tnew.Reference_Flag is null
	inner join Acq_Deal_Movie adm on adm.Title_Code=tnew.Title_Code
	inner join Acq_Deal ad on adm.Acq_Deal_Code=ad.Acq_Deal_Code and ad.Agreement_No=substring(adOld.Agreement_No,0,13)
	where isnull(adOld.Master_Deal_Movie_Code_ToLink,0)>0 
	--and adOld.acq_Deal_code <> 53
	and adOld.Is_Master_Deal='N'

END

--exec [USP_MIGRATE_TO_NEW_Main] 'D'