CREATE Function [dbo].[UFN_Get_Report_Territory](@Country_Codes Varchar(2000), @RowId Int)
Returns @Tbl_Ret TABLE (
	Region_Code Int,
	Cluster_Name NVarchar(MAX),
	Region_Name NVarchar(MAX)
) AS
Begin
	--Declare @Country_Codes Varchar(2000) = '10,11,12,13,14,143,144,145,146,147,148,149,15,150,151,152,153,154,155,156,157,158,159,16,160,161,162,163,164,165,166,167,168,169,17,170,171,172,173,174,175,176,177,178,179,18,180,181,182,183,184,185,186,187,188,189,19,190,191,192,193,194,195,196,197,198,199,2,20,200,201,202,203,204,205,206,207,208,209,21,210,211,212,213,214,215,216,217,218,219,22,220,221,222,223,224,225,226,227,228,229,23,230,231,232,233,234,235,236,237,238,239,24,240,241,242,243,244,245,246,247,248,249,25,250,251,252,253,254,255,256,257,258,26,27,28,29,3,30,31,32,33,34,35,36,37,38,39,4,40,41,42,43,44,45,46,47,48,49,5,50,51,52,53,54,55,56,57,58,59,6,60,61,62,63,64,65,66,67,68,69,7,70,71,72,73,74,75,76,77,78,8,9'
	--Declare @Country_Codes Varchar(2000) = '10,11,12,13,14,143,144,146,147,148,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,17,170,171,172,173,174,175,176,177,178,179,18,180,181,182,183,184,185,186,187,188,189,19,190,191,192,193,194,195,196,197,198,199,2,20,200,201,202,203,204,205,207,208,209,21,210,211,212,213,214,215,216,217,218,219,22,220,221,222,223,224,225,226,227,228,229,23,230,231,232,233,235,236,237,238,239,24,240,241,242,243,247,248,249,25,250,251,252,253,254,255,256,257,258,259,26,260,261,262,263,264,265,266,267,268,269,27,270,271,272,273,274,275,276,277,278,279,28,280,281,282,283,284,285,286,287,288,289,29,290,291,292,293,294,295,296,297,298,299,3,30,300,301,302,303,304,305,306,307,308,309,31,310,311,312,313,314,315,316,317,318,319,32,320,321,322,323,33,34,35,36,37,39,4,40,41,43,45,46,47,48,49,5,50,51,52,53,54,55,56,57,59,6,60,61,62,64,65,68,69,7,70,72,73,74,76,77,8,9'
	--Declare @Country_Codes Varchar(2000) = '42'
	--Declare @RowId Int = 1
	--Select @Country_Codes
	
	--Declare @Tbl_Ret TABLE (
	--	Region_Code Int,
	--	Cluster_Name NVarchar(MAX),
	--	Region_Name NVarchar(MAX)
	--)

	Declare @InclPercent Int = 50

	Declare @Temp_Country_In As Table(
		Country_Code Int,
		Report_Territory_Code Int
	)
	
	Declare @Temp_Country_NIn As Table(
		Country_Code Int,
		Report_Territory_Code Int
	)
	
	Declare @Temp_Territory As Table(
		Report_Territory_Code Int,
		DB_Cnt Int,
		In_Cnt Int,
		NIn_Cnt Int,
		In_Percent Int,
		Eligible Char(1),
		Exclusion_Countries NVarchar(Max)
	)

	INSERT INTO @Temp_Territory(Report_Territory_Code, DB_Cnt, Eligible, Exclusion_Countries)
	Select Report_Territory_Code, (
		Select Count(*) From Report_Territory_Country trc2 Where trc2.Report_Territory_Code = trc1.Report_Territory_Code And trc2.Country_Code In (
			Select Country_Code From Country Where Is_Active = 'Y'
		)
	), 'N', ''
	From Report_Territory trc1

	Update @Temp_Territory Set In_Percent = Round((DB_Cnt * @InclPercent) / 100.0, 0)

	INSERT INTO @Temp_Country_In(Country_Code, Report_Territory_Code)
	Select Country_Code, Report_Territory_Code From Report_Territory_Country rtc
	Inner Join dbo.fn_Split_withdelemiter(IsNull(@Country_Codes, ''), ',') On IsNull(number, '') <> '' AND Cast(number AS Int) = rtc.Country_Code
	
	INSERT INTO @Temp_Country_NIn(Country_Code, Report_Territory_Code)
	Select Country_Code, Report_Territory_Code From Report_Territory_Country rtc Where rtc.Country_Code Not In (
		Select Cast(number AS Int) From dbo.fn_Split_withdelemiter(IsNull(@Country_Codes, ''), ',') Where IsNull(number, '') <> ''
	)
	
	Update t1 Set In_Cnt = (
		Select Count(*) From @Temp_Country_In t2 Where t1.Report_Territory_Code = t2.Report_Territory_Code
	)
	From @Temp_Territory t1
	
	Delete From @Temp_Territory Where In_Cnt = 0

	Update @Temp_Territory Set NIn_Cnt = DB_Cnt - In_Cnt

	Update @Temp_Territory Set Eligible = 'Y' Where In_Cnt > In_Percent

	Declare @WorldCode Int = 0, @All_Territory_Count Int = 0, @Full_Avail_Territory Int = 0

	Select @WorldCode = Report_Territory_Code From Report_Territory Where Report_Territory_Name = 'World'

	If Exists (Select Top 1 * From @Temp_Territory Where NIn_Cnt = 0 And Report_Territory_Code = @WorldCode)
	Begin
		Insert InTo @Tbl_Ret(Region_Code, Region_Name, Cluster_Name)
		Select @RowId, '', 'World'
	End
	Else
	Begin
	
		--Delete From @Temp_Territory Where Report_Territory_Code = @WorldCode

		Declare @Territories NVarchar(MAX) = ''
		
		Select @All_Territory_Count = Count(*) From Report_Territory Where Report_Territory_Code <> @WorldCode
		Select @Full_Avail_Territory = Count(*) From @Temp_Territory Where NIn_Cnt = 0 And Report_Territory_Code <> @WorldCode
		--Select @All_Territory_Count, @Full_Avail_Territory, Round((@All_Territory_Count * @InclPercent) / 100.0, 0)

		If(@Full_Avail_Territory > Round((@All_Territory_Count * @InclPercent) / 100.0, 0))
		Begin
			
			Set @Territories = Ltrim(STUFF(
			(
				Select Distinct ', ' + rt.Report_Territory_Name + ' (Partial)' From @Temp_Territory tt
				Inner Join Report_Territory rt On tt.Report_Territory_Code = rt.Report_Territory_Code And NIn_Cnt <> 0 And rt.Report_Territory_Code <> @WorldCode
				FOR XML PATH('')
			), 1, 1, ''))

			IF(ISNULL(@Territories, '') <> '')
			BEGIN
				Set @Territories = 'World Excluding ' + @Territories
			END

		End
		Else
		Begin

			Set @Territories = Ltrim(STUFF(
			(
				Select Distinct ', ' + rt.Report_Territory_Name From @Temp_Territory tt
				Inner Join Report_Territory rt On tt.Report_Territory_Code = rt.Report_Territory_Code And NIn_Cnt = 0
				FOR XML PATH('')
			), 1, 1, ''))

		End
		
		Update t1 Set Exclusion_Countries =  Ltrim(STUFF(
		(
			Select Distinct ', ' + Country_Name from @Temp_Country_NIn tcn
			Inner Join Country c On c.Country_Code = tcn.Country_Code
			Where t1.Report_Territory_Code = tcn.Report_Territory_Code-- And tcn.Report_Territory_Code <> @WorldCode
			FOR XML PATH('')
		), 1, 1, ''))
		From @Temp_Territory t1 Where Eligible = 'Y' AND NIn_Cnt <> 0

		Declare @Countries NVarchar(MAX) = IsNull(Ltrim(STUFF(
		(
			Select '; ' + rt.Report_Territory_Name + ' Excluding (' + Exclusion_Countries + ')' From @Temp_Territory tt
			Inner Join Report_Territory rt On tt.Report_Territory_Code = rt.Report_Territory_Code And Exclusion_Countries <> '' And Eligible = 'Y'
			FOR XML PATH('')
		), 1, 1, '')), '')

		--Select @Countries
		--Select * From @Temp_Territory

		Declare @Exclusion_Countries NVarchar(MAX) = IsNull(Ltrim(STUFF(
		(
			Select Distinct ', ' + Country_Name from @Temp_Territory tt  
			Inner Join @Temp_Country_In tcn On tt.Report_Territory_Code = tcn.Report_Territory_Code AND Eligible = 'N'-- And tt.Report_Territory_Code <> @WorldCode
			Inner Join Country c On c.Country_Code = tcn.Country_Code
			FOR XML PATH('')
		), 1, 1, '')), '')
		
		Set @Countries = @Countries + Case When @Countries = '' OR @Exclusion_Countries = '' Then '' Else '; ' End + @Exclusion_Countries

		--Select @Countries
		Insert InTo @Tbl_Ret(Region_Code, Region_Name, Cluster_Name)
		Select @RowId, @Countries, @Territories
	End
	
	RETURN 
End

/*

Declare @Country_Codes Varchar(2000) = '2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,143,144,145,146,147,148,149,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,170,171,172,173,174,175,176,177,178,179,180,181,182,183,184,185,186,187,188,189,190,191,192,193,194,195,196,197,198,199,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,245,246,247,248,249,250,251,252,253,254,255,256,257,258'
Declare @Country_Codes Varchar(2000) = '10,11,12,13,14,143,144,146,147,148,150,151,152,153,154,155,156,157,158,159,160,161,162,163,164,165,166,167,168,169,17,170,171,172,173,174,175,176,177,178,179,18,180,181,182,183,184,185,186,187,188,189,19,190,191,192,193,194,195,196,197,198,199,2,20,200,201,202,203,204,205,207,208,209,21,210,211,212,213,214,215,216,217,218,219,22,220,221,222,223,224,225,226,227,228,229,23,230,231,232,233,235,236,237,238,239,24,240,241,242,243,247,248,249,25,250,251,252,253,254,255,256,257,258,259,26,260,261,262,263,264,265,266,267,268,269,27,270,271,272,273,274,275,276,277,278,279,28,280,281,282,283,284,285,286,287,288,289,29,290,291,292,293,294,295,296,297,298,299,3,30,300,301,302,303,304,305,306,307,308,309,31,310,311,312,313,314,315,316,317,318,319,32,320,321,322,323,33,34,35,36,37,39,4,40,41,42,43,45,46,47,48,49,5,50,51,52,53,54,55,56,57,59,6,60,61,62,64,65,68,69,7,70,72,73,74,76,77,8,9'
Declare @Country_Codes Varchar(2000) = '10,11,12,13,14,143,144,146,147,148,150,151,152,153,154,155,156,157,159,160,161,162,163,164,165,166,167,168,169,17,170,171,172,173,174,175,176,177,178,179,18,180,181,182,183,184,185,186,187,188,189,19,190,191,192,193,194,195,196,197,198,199,2,20,200,201,202,203,204,205,207,208,209,21,210,211,212,213,214,215,216,217,218,219,22,220,221,222,223,224,225,226,227,228,229,23,230,231,232,233,235,236,237,238,239,24,240,241,242,243,247,248,249,25,250,251,252,253,254,255,256,257,258,259,26,260,261,262,263,264,265,266,267,268,269,27,270,271,272,273,274,275,276,277,278,279,28,280,281,282,283,284,285,286,287,288,289,29,290,291,292,293,294,295,296,297,298,299,3,30,300,301,302,303,304,305,306,307,308,309,31,310,311,312,313,314,315,316,317,318,319,32,320,321,322,323,33,34,35,36,37,39,4,40,41,43,45,46,47,48,49,5,50,51,52,53,54,55,56,57,59,6,60,61,62,64,65,68,69,7,70,72,73,74,76,77,8,9'
--Declare @Country_Codes Varchar(2000) = '42'
Select * From DBO.UFN_Get_Report_Territory(@Country_Codes, 1)

*/

