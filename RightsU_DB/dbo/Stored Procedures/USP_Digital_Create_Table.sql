CREATE PROCEDURE [dbo].[USP_Digital_Create_Table](@tabCode INT=1, @Acq_Deal_Code int, @Title_Code varchar(max), @View varchar(10))
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Digital_Create_Table]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		SET NOCOUNT ON
		SET FMTONLY OFF

		DECLARE @Acq_Deal_Digital_Detail_Code int, @Acq_Deal_Digital_Code int, @Digital_Tab_Code int, @Digital_Config_Code int, @Digital_Data_Code varchar(1000), 
		@User_Value varchar(max), @Row_Num int, @Digital_Data varchar(max), @Final_String varchar(max)='', @i int = 0, @prevrow int = 0, @Short_Name varchar(10)=''

		SELECT @Short_Name = Short_Name from Digital_Tab (NOLOCK)  where Digital_Tab_Code = @tabCode
	
		DECLARE cur_Table CURSOR FOR 
		SELECT Acq_Deal_Digital_Detail_Code, ads.Acq_Deal_Digital_Code, Digital_Tab_Code, Digital_Config_Code, Digital_Data_Code, User_Value, Row_Num FROM 
		Acq_Deal_Digital ads (NOLOCK) 
		inner join Acq_Deal_Digital_detail adsd (NOLOCK)  on adsd.Acq_Deal_Digital_Code = ads.Acq_Deal_Digital_Code
		WHERE Digital_Tab_Code = @tabCode and ads.Acq_Deal_Code = @Acq_Deal_Code and ads.Acq_Deal_Digital_Code = @Title_Code

		OPEN cur_Table

		FETCH NEXT FROM cur_Table INTO @Acq_Deal_Digital_Detail_Code, @Acq_Deal_Digital_Code, @Digital_Tab_Code, @Digital_Config_Code, @Digital_Data_Code, 
		@User_Value, @Row_Num

		WHILE @@FETCH_STATUS = 0  
		BEGIN
			IF(@Row_Num != @prevrow)
			BEGIN
				SELECT @i = @i +1
				SELECT @prevrow = @Row_Num
				SELECT @Final_String = @Final_String + '<Tr id="'+ @Short_Name + Convert(varchar,@Row_Num) +'" name="' + @Short_Name + Convert(varchar,@Row_Num) + '">' 
			END
		
			print @Digital_Data_Code 

			if (@Digital_Data_Code !='' And isnull(@User_Value , '')='')
			BEGIN
				select @Digital_Data = Stuff(
				(SELECT ', ' + s.Data_Description FROM Digital_Data s (NOLOCK)  where Digital_Data_Code in (SELECT number FROM [fn_Split_withdelemiter](@Digital_Data_Code,',')) FOR XML PATH('')), 1, 2, '') 

				select @Final_String = @Final_String + '<TD>' + @Digital_Data + '</TD>'
			END

			if (isnull(@Digital_Data_Code, '')='' And @User_Value != '' And @User_Value is not null)
			BEGIN
				select @Final_String = @Final_String + '<TD><div class="DigitalRemarks">' + @User_Value + '</div></TD>'
			END

			if isnull(@Digital_Data_Code,'')= '' And isnull(@User_Value ,'')=''
			BEGIN
				select @Final_String = @Final_String + '<TD>&nbsp;</TD>'
			END

			FETCH NEXT FROM cur_Table INTO @Acq_Deal_Digital_Detail_Code, @Acq_Deal_Digital_Code, @Digital_Tab_Code, @Digital_Config_Code, @Digital_Data_Code, 
			@User_Value, @Row_Num
		
			IF(@Row_Num != @prevrow and @View <> 'VIEW')
			SELECT @Final_String = @Final_String + '<TD style="text-align: center;"><a id="E'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Edit" class="glyphicon glyphicon-pencil" onclick="DigitalEdit(this,'+ Convert(varchar,@Acq_Deal_Digital_Code)+','+ Convert(varchar,@prevrow)+','+ Convert(varchar,@i)+');"></a><a id="D'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Delete" class="glyphicon glyphicon-trash" onclick="DigitalDelete(this,'+ Convert(varchar,@Acq_Deal_Digital_Code)+','+ Convert(varchar,@prevrow)+','+ Convert(varchar,@i)+','+ CONVERT(varchar,@tabCode)+','''+ CONVERT(varchar,@Short_Name) +''');"></a></TD></Tr>' 
			print @Final_String
		END

		IF(Len(@Final_String) > 0 and @View <> 'VIEW' )
			SELECT @Final_String = @Final_String + '<TD style="text-align: center;"><a id="E'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Edit" class="glyphicon glyphicon-pencil" onclick="DigitalEdit(this,'+ Convert(varchar,@Acq_Deal_Digital_Code)+','+ Convert(varchar,@Row_Num)+','+ Convert(varchar,@i)+');"></a><a id="D'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Delete" class="glyphicon glyphicon-trash" onclick="DigitalDelete(this,'+ Convert(varchar,@Acq_Deal_Digital_Code)+','+ Convert(varchar,@Row_Num)+','+ Convert(varchar,@i)+','+ CONVERT(varchar,@tabCode)+','''+ CONVERT(varchar,@Short_Name)+''');"></a></TD></Tr>' 


		CLOSE cur_Table
		Deallocate cur_Table

		SELECT @Final_String AS Tab
	
	--if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Digital_Create_Table]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END