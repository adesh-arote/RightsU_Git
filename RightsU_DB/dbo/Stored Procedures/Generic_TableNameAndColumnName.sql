CREATE PROCEDURE [dbo].[Generic_TableNameAndColumnName]
	@pServerName varchar(max),
	@pServerUserName varchar(max),
	@pServerPassword varchar(max),
	@pDBName varchar(max),
	@pFolderPath varchar(max),
	@pFileExtn varchar(10)
AS
BEGIN
	Declare @Loglevel int;

	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Generic_TableNameAndColumnName]', 'Step 1', 0, 'Started Procedure', 0, ''
		Declare @counts int = 0;

		Declare @ta Table
		(
		  TableName varchar(max),
		  RecordCount bigint
		)

		Declare @finaQuery table
		(
		  finalQuery varchar(max)
		)

		Insert into @ta
		SELECT A.Name AS TableName  , SUM(B.rows) AS RecordCount  
		FROM sys.objects A  
		INNER JOIN sys.partitions B ON A.object_id = B.object_id  
		WHERE A.type = 'U'  and SCHEMA_NAME(A.schema_id) = 'dbo' 
		and (A.name not like 'AT%'
	or A.name in ('AT_ACQ_DEAL', 'AT_ACQ_DEAL_RIGHTS', 'AT_ACQ_DEAL_RIGHTS_TITLE')
	)
		and A.name not like 'tmp_%'
		and A.name not like '%rightsu_%'
		and A.name not like 'IPR%'
		and A.name not like '%music%'
		and A.name not like 'Temp%'
		and A.name not like '%temp'
		and A.name not like 'BV_%'
		and A.name not like 'DM_%'
		and A.name not like 'UTO_%'
		and A.name not like 'BMS_%'
		and A.name not like 'VW%'
		and A.name not like 'MH%'
		and A.name not like 'System_%'
		and A.name not like 'metadata_%'
		and A.name not like 'acq_metadata_%'
		and A.name not like 'syn_metadata_%'
		and A.name not like 'acq_holdback_metadata_%'
		and A.name not like 'syn_holdback_metadata_%'
		and A.name not like 'acq_rholdback_metadata_%'
		and A.name not like 'syn_rholdback_metadata_%'
		and A.name not in ('b','new','k','aa','__RefactorLog', 'talent1', 'AcqPreReqMappingData')
		GROUP BY A.schema_id, A.Name
		having SUM(B.rows) > 0
		order by 1 asc;

		DECLARE  @pTableName VARCHAR(MAX); 
   
		DECLARE cursor_product CURSOR

		FOR SELECT TableName FROM @ta OPEN cursor_product;

		FETCH NEXT FROM cursor_product INTO @pTableName;

		WHILE @@FETCH_STATUS = 0
			BEGIN

				declare @names nvarchar(4000);
				declare @table varchar(max) = @pTableName;
				declare @fullqueryC varchar(max);
				declare @col nvarchar(max) ;
				declare @fullquery varchar(max);
				declare @mainQuery varchar(max) = '';
			
				set @col = null;
				set @names = null;
				set @fullquery = '';
				set @mainQuery = '';
				set @fullqueryC = '';

				select  @names = coalesce(@names + ',', '') + '''' +  c.name  + ''''
				from sys.tables t 
					inner join sys.columns c on c.object_id = t.object_id
					inner join sys.types st on st.system_type_id = c.system_type_id
				where t.name = @table 
				and st.name != 'sysname' 
				and st.schema_id = 4
				order by c.column_id asc

				set @fullqueryC = 'select ' +  @names ;

				select @col =  
					case when st.name in ('nvarchar','varchar') then 
						coalesce(@col + ', ', '') + 'isnull(replace(replace(replace(replace(replace(cast(' + c.name + ' as  nvarchar(4000)),''\'', ''\\''),''|'', ''##PIPE##''),''""'', ''##QUOTE##''),''''+CHAR(13)+'''',''##NEWLINE_R##''),''''+CHAR(10)+'''',''##NEWLINE_N##'') ,'''')' + ' as ' + c.name
					when st.name in ('bigint','int','char') then 
						coalesce(@col + ' ,', '') + 'isnull('+c.name+', '''')'  + ' as ' + c.name
					when st.name = 'datetime' then
						coalesce(@col + ' ,', '') + 'isnull(convert(varchar, '+c.name+ ', 20), '''')'  + ' as ' + c.name
					when st.name = 'bit' then
						coalesce(@col + ' ,', '') + 'case when ' + c.name   + '=  1 then ''True'' else ''False'' end'  + ' as ' + c.name
					else  
						coalesce(@col + ' ,', '') + c.name
					end 
				from sys.tables t
					inner join sys.columns c on c.object_id = t.object_id
					inner join sys.types st on st.system_type_id = c.system_type_id
				where t.name = @table 
				and st.name != 'sysname' 
				and st.schema_id = 4
				order by c.column_id asc

				set @fullquery = 'select ' +  @col + ' from ' + @table;
			
				set @mainQuery = 'sqlcmd -S ' + @pServerName + ' -U ' + @pServerUserName + ' -P "' + @pServerPassword + '" -d ' + @pDBName + ' -s "|" -h-1 -W -Q "set nocount on;' + @fullqueryC + ';' + @fullquery + '"' + ' -o ' + '"' + @pFolderPath + @pTableName + @pFileExtn + '"';

				insert into @finaQuery values (@mainQuery);

				print @mainQuery;

				set @counts = @counts + 1;

				--print @counts;
				-------------- uncomment this line to see the result count

				FETCH NEXT FROM cursor_product INTO 
				@pTableName;
			END;

		CLOSE cursor_product;
		DEALLOCATE cursor_product;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[Generic_TableNameAndColumnName]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
	--select * from @finaQuery; --uncomment this line if you want to see the query results with select cmd
END
