--declare @RecordCount Int 
--exec USP_List_BMS_log '  And Module_Name like ''%post%'' OR Method_Type like ''%post%'' OR Error_Description like ''%post%'' OR Record_Status like ''%post%'' 
--OR Request_Xml like ''%post%'' OR Response_Xml like ''%post%''',2,'Y',10,@RecordCount out
--select @RecordCount


--declare @RecordCount Int 
--exec USP_List_BMS_log ' AND 1=1',2,'Y',10,@RecordCount out
--select @RecordCount
CREATE  Procedure [dbo].[USP_List_BMS_log]
(
	@StrSearch NVARCHAR(Max),
	@PageNo Int,
--	@OrderByCndition Varchar(100),
	@IsPaging Varchar(2),
	@PageSize Int,
	@RecordCount Int Out
)
As
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 08-October-2014
-- Description:	AcqDeal List
-- Updated by : Priti D Phand
-- Date : 17 Nov 2014
-- Reason: Added one column which will return count of milestones added from function UFN_Get_MIlestone_Count
-- =============================================
Begin

	Set FMTONLY Off
	--SET @OrderByCndition = 'Last_Updated_Time DESC'
	--DECLARE
	--@StrSearch Varchar(Max),
	--@PageNo Int,
	--@OrderByCndition Varchar(100),
	--@IsPaging Varchar(2),
	--@PageSize Int
	
		if(@PageNo = 0)
			Set @PageNo = 1

		Create Table #Temp(
			Id Int,
			RowId Varchar(200),
			--currentApproverCode INT
		);

		Declare @SqlPageNo Varchar(5000)
			
		
		set @SqlPageNo = 
				'WITH Y AS (
		  
							Select k, BMS_Log_Code From 
							(
								select k = ROW_NUMBER() OVER (ORDER BY Request_Time desc),* from (
									Select BMS_Log_Code,Module_Name ,Method_Type,Request_Time ,Response_Time,Request_Xml,Response_Xml,Record_Status, Error_Description 
		from BMS_log 
									)as XYZ Where 1 = 1  
										'+ @StrSearch + '
							 )as X
		   
						)
		Insert InTo #Temp Select k,BMS_Log_Code From Y '
		

		
		--PRINT(@SqlPageNo)
		EXEC(@SqlPageNo)
		
		Select @RecordCount = Count(*) From #Temp
		
		If(@IsPaging = 'Y')
		Begin	
		
			Delete From #Temp Where Id < (((@PageNo - 1) * @PageSize) + 1) Or Id > @PageNo * @PageSize 
			
		End	

		Declare @Sql NVARCHAR(MAX)
		Set @Sql = 'select BMS_Log_Code,Module_Name,Method_Type,Request_Time ,Response_Time,Request_Xml,Response_Xml,
		 CASE ISNULL(Record_Status, '''') 
		  WHEN ''W'' THEN ''Waiting''
		  WHEN ''D'' THEN ''Complete''
		 ELSE ''Error''
	END AS Record_Status, Error_Description 
		 from BMS_log where BMS_Log_Code in (
		select RowId from #Temp ) ORDER BY Request_Time desc'

		--	--,AD.Deal_Complete_Flag
		--PRINT @Sql
		Exec(@Sql)
		Drop Table #Temp
	
End