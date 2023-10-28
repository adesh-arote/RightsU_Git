CREATE PROCEDURE [dbo].[USP_Syn_Deal_Supplementary_Details_Data](@TabCode INT = 1, @Syn_Deal_Supplementary_Code INT, @View VARCHAR(10))
AS
BEGIN
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2) Exec [USPLogSQLSteps] '[USP_Syn_Deal_Supplementary_Details_Data]', 'Step 1', 0, 'Started Procedure', 0, ''
	
		SET NOCOUNT ON
		SET FMTONLY OFF

		DECLARE @Syn_Deal_Supplementary_Detail_Code INT, @Supplementary_Tab_Code INT, @Supplementary_Config_Code INT, @Supplementary_Data_Code VARCHAR(1000)
		DECLARE @User_Value VARCHAR(MAX), @Row_Num INT, @Supplementary_Data VARCHAR(MAX), @Final_String VARCHAR(MAX) = '', @i INT = 0, @prevrow INT = 0, @Short_Name VARCHAR(10) = ''

		SELECT @Short_Name = Short_Name from Supplementary_Tab (NOLOCK) where Supplementary_Tab_Code = @tabCode
	
		DECLARE cur_Table CURSOR FOR SELECT Syn_Deal_Supplementary_Detail_Code, ads.Syn_Deal_Supplementary_Code, Supplementary_Tab_Code, Supplementary_Config_Code, Supplementary_Data_Code, User_Value, Row_Num 
									 FROM Syn_Deal_Supplementary ads (NOLOCK)
									 INNER JOIN Syn_Deal_Supplementary_detail adsd (NOLOCK) on adsd.Syn_Deal_Supplementary_Code = ads.Syn_Deal_Supplementary_Code
									 WHERE Supplementary_Tab_Code = @tabCode and ads.Syn_Deal_Supplementary_Code = @Syn_Deal_Supplementary_Code
		OPEN cur_Table
		FETCH NEXT FROM cur_Table INTO @Syn_Deal_Supplementary_Detail_Code, @Syn_Deal_Supplementary_Code, @Supplementary_Tab_Code, @Supplementary_Config_Code, @Supplementary_Data_Code, @User_Value, @Row_Num
		WHILE @@FETCH_STATUS = 0  
		BEGIN

			IF(@Row_Num != @prevrow)
			BEGIN
				SELECT @i = @i +1
				SELECT @prevrow = @Row_Num
				SELECT @Final_String = @Final_String + '<Tr id="'+ @Short_Name + CONVERT(VARCHAR,@Row_Num) +'" name="' + @Short_Name + Convert(VARCHAR,@Row_Num) + '">' 
			END
		
			PRINT @Supplementary_Data_Code 

			IF (@Supplementary_Data_Code !='' And ISNULL(@User_Value , '')='')
			BEGIN
				SELECT @Supplementary_Data = STUFF((SELECT ', ' + s.Data_Description FROM Supplementary_Data s (NOLOCK) where Supplementary_Data_Code in (SELECT number FROM [fn_Split_withdelemiter](@Supplementary_Data_Code,',')) FOR XML PATH('')), 1, 2, '') 

				SELECT @Final_String = @Final_String + '<TD>' + @Supplementary_Data + '</TD>'
			END

			IF (ISNULL(@Supplementary_Data_Code, '')='' And @User_Value != '' And @User_Value is not null)
			BEGIN
				SELECT @Final_String = @Final_String + '<TD><div class="SuppRemarks">' + @User_Value + '</div></TD>'
			END

			IF ISNULL(@Supplementary_Data_Code,'')= '' And ISNULL(@User_Value ,'')=''
			BEGIN
				SELECT @Final_String = @Final_String + '<TD>&nbsp;</TD>'
			END

			FETCH NEXT FROM cur_Table INTO @Syn_Deal_Supplementary_Detail_Code, @Syn_Deal_Supplementary_Code, @Supplementary_Tab_Code, @Supplementary_Config_Code, @Supplementary_Data_Code, @User_Value, @Row_Num
		
			IF(@Row_Num != @prevrow and @View <> 'VIEW')
				SELECT @Final_String = @Final_String + '<TD style="text-align: center;"><a id="E'+ @Short_Name + CONVERT(VARCHAR,@Row_Num) +'" title="Edit" class="glyphicon glyphicon-pencil" onclick="SuppEdit(this,'+ Convert(VARCHAR,@Syn_Deal_Supplementary_Code)+','+ Convert(VARCHAR,@prevrow)+','+ Convert(VARCHAR,@i)+');"></a><a id="D'+ @Short_Name + CONVERT(VARCHAR,@Row_Num) +'" title="Delete" class="glyphicon glyphicon-trash" onclick="SuppDelete(this,'+ Convert(VARCHAR,@Syn_Deal_Supplementary_Code)+','+ Convert(VARCHAR,@prevrow)+','+ Convert(VARCHAR,@i)+','+ CONVERT(VARCHAR,@tabCode)+','''+ CONVERT(VARCHAR,@Short_Name) +''');"></a></TD></Tr>' 
			PRINT @Final_String

		END

		IF(LEN(@Final_String) > 0 and @View <> 'VIEW' )
			SELECT @Final_String = @Final_String + '<TD style="text-align: center;"><a id="E'+ @Short_Name + CONVERT(VARCHAR,@Row_Num) +'" title="Edit" class="glyphicon glyphicon-pencil" onclick="SuppEdit(this,'+ Convert(VARCHAR,@Syn_Deal_Supplementary_Code)+','+ Convert(VARCHAR,@Row_Num)+','+ Convert(VARCHAR,@i)+');"></a><a id="D'+ @Short_Name + CONVERT(VARCHAR,@Row_Num) +'" title="Delete" class="glyphicon glyphicon-trash" onclick="SuppDelete(this,'+ Convert(VARCHAR,@Syn_Deal_Supplementary_Code)+','+ Convert(VARCHAR,@Row_Num)+','+ Convert(VARCHAR,@i)+','+ CONVERT(VARCHAR,@tabCode)+','''+ CONVERT(VARCHAR,@Short_Name)+''');"></a></TD></Tr>' 

		CLOSE cur_Table
		Deallocate cur_Table

		SELECT @Final_String AS Tab
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Syn_Deal_Supplementary_Details_Data]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END