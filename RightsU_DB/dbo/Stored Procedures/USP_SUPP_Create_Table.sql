CREATE PROCEDURE [dbo].[USP_SUPP_Create_Table](@tabCode INT=1, @Acq_Deal_Code int, @Title_Code varchar(max), @View varchar(10))
AS
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SUPP_Create_Table]', 'Step 1', 0, 'Started Procedure', 0, ''  
		SET NOCOUNT ON
		SET FMTONLY OFF

		DECLARE @Acq_Deal_Supplementary_Detail_Code int, @Acq_Deal_Supplementary_Code int, @Supplementary_Tab_Code int, @Supplementary_Config_Code int, @Supplementary_Data_Code varchar(1000), 
		@User_Value varchar(max), @Row_Num int, @Supplementary_Data varchar(max), @Final_String varchar(max)='', @i int = 0, @prevrow int = 0, @Short_Name varchar(10)=''

		SELECT @Short_Name = Short_Name from Supplementary_Tab (NOLOCK) where Supplementary_Tab_Code = @tabCode
	
		DECLARE cur_Table CURSOR FOR 
		SELECT Acq_Deal_Supplementary_Detail_Code, ads.Acq_Deal_Supplementary_Code, Supplementary_Tab_Code, Supplementary_Config_Code, Supplementary_Data_Code, User_Value, Row_Num FROM 
		Acq_Deal_Supplementary ads (NOLOCK)
		inner join Acq_Deal_Supplementary_detail adsd (NOLOCK) on adsd.Acq_Deal_Supplementary_Code = ads.Acq_Deal_Supplementary_Code
		WHERE Supplementary_Tab_Code = @tabCode and ads.Acq_Deal_Code = @Acq_Deal_Code and ads.Acq_Deal_Supplementary_Code = @Title_Code

		OPEN cur_Table

		FETCH NEXT FROM cur_Table INTO @Acq_Deal_Supplementary_Detail_Code, @Acq_Deal_Supplementary_Code, @Supplementary_Tab_Code, @Supplementary_Config_Code, @Supplementary_Data_Code, 
		@User_Value, @Row_Num

		WHILE @@FETCH_STATUS = 0  
		BEGIN
			IF(@Row_Num != @prevrow)
			BEGIN
				SELECT @i = @i +1
				SELECT @prevrow = @Row_Num
				SELECT @Final_String = @Final_String + '<Tr id="'+ @Short_Name + Convert(varchar,@Row_Num) +'" name="' + @Short_Name + Convert(varchar,@Row_Num) + '">' 
			END
		
			print @Supplementary_Data_Code 

			if (@Supplementary_Data_Code !='' And isnull(@User_Value , '')='')
			BEGIN
				select @Supplementary_Data = Stuff(
				(SELECT ', ' + s.Data_Description FROM Supplementary_Data s where Supplementary_Data_Code in (SELECT number FROM [fn_Split_withdelemiter](@Supplementary_Data_Code,',')) FOR XML PATH('')), 1, 2, '') 

				select @Final_String = @Final_String + '<TD>' + @Supplementary_Data + '</TD>'
			END

			if (isnull(@Supplementary_Data_Code, '')='' And @User_Value != '' And @User_Value is not null)
			BEGIN
				select @Final_String = @Final_String + '<TD><div class="SuppRemarks">' + @User_Value + '</div></TD>'
			END

			if isnull(@Supplementary_Data_Code,'')= '' And isnull(@User_Value ,'')=''
			BEGIN
				select @Final_String = @Final_String + '<TD>&nbsp;</TD>'
			END

			FETCH NEXT FROM cur_Table INTO @Acq_Deal_Supplementary_Detail_Code, @Acq_Deal_Supplementary_Code, @Supplementary_Tab_Code, @Supplementary_Config_Code, @Supplementary_Data_Code, 
			@User_Value, @Row_Num
		
			IF(@Row_Num != @prevrow and @View <> 'VIEW')
			SELECT @Final_String = @Final_String + '<TD style="text-align: center;"><a id="E'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Edit" class="glyphicon glyphicon-pencil" onclick="SuppEdit(this,'+ Convert(varchar,@Acq_Deal_Supplementary_Code)+','+ Convert(varchar,@prevrow)+','+ Convert(varchar,@i)+');"></a><a id="D'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Delete" class="glyphicon glyphicon-trash" onclick="SuppDelete(this,'+ Convert(varchar,@Acq_Deal_Supplementary_Code)+','+ Convert(varchar,@prevrow)+','+ Convert(varchar,@i)+','+ CONVERT(varchar,@tabCode)+','''+ CONVERT(varchar,@Short_Name) +''');"></a></TD></Tr>' 
			print @Final_String
		END

		IF(Len(@Final_String) > 0 and @View <> 'VIEW' )
			SELECT @Final_String = @Final_String + '<TD style="text-align: center;"><a id="E'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Edit" class="glyphicon glyphicon-pencil" onclick="SuppEdit(this,'+ Convert(varchar,@Acq_Deal_Supplementary_Code)+','+ Convert(varchar,@Row_Num)+','+ Convert(varchar,@i)+');"></a><a id="D'+ @Short_Name + CONVERT(varchar,@Row_Num) +'" title="Delete" class="glyphicon glyphicon-trash" onclick="SuppDelete(this,'+ Convert(varchar,@Acq_Deal_Supplementary_Code)+','+ Convert(varchar,@Row_Num)+','+ Convert(varchar,@i)+','+ CONVERT(varchar,@tabCode)+','''+ CONVERT(varchar,@Short_Name)+''');"></a></TD></Tr>' 


		CLOSE cur_Table
		Deallocate cur_Table

		SELECT @Final_String AS Tab
	IF(@Loglevel< 2)Exec [USPLogSQLSteps] '[USP_SUPP_Create_Table]', 'Step 2', 0, 'Procedure Excuting Completed', 0, '' 
END