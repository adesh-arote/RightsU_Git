﻿CREATE PROC [dbo].[USP_MIGRATE_TO_NEW_Main_Syndication]
(
	@dBug CHAR(1)='N'
)
AS
-- =============================================
-- Author:		Reshma Kunjal
-- Create DATE: 25-Feb-2015
-- Description: SP to migrate LOOP ON ALL Syn DEALS AND CAll Migrate SP
-- =============================================
BEGIN
Declare @Loglevel int
select @Loglevel = Parameter_Value from System_Parameter_New   where Parameter_Name='loglevel'
 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_MIGRATE_TO_NEW_Main_Syndication]', 'Step 1', 0, 'Started Procedure', 0, '' 
	DECLARE @Syn_Deal_Code_Cur INT
	DECLARE CUR_DEAL CURSOR
	READ_ONLY
	FOR 
	
	SELECT Syndication_Deal_Code FROM Rightsu_vmpl_live_27March_2015.dbo.Syndication_Deal 
	where Is_Active='Y'
	order by Syndication_Deal_Code
	OPEN CUR_DEAL	

	FETCH NEXT FROM CUR_DEAL INTO @Syn_Deal_Code_Cur

	WHILE (@@fetch_status <> -1)
	BEGIN
		IF (@@fetch_status <> -2)
		BEGIN
			EXEC USP_MIGRATE_TO_NEW_Syndication @Syn_Deal_Code_Cur,@dBug
		END
		FETCH NEXT FROM CUR_DEAL INTO @Syn_Deal_Code_Cur		
	END
	CLOSE CUR_DEAL
	DEALLOCATE CUR_DEAL
	 
 if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_MIGRATE_TO_NEW_Main_Syndication]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
