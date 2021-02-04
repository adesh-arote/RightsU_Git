
CREATE FUNCTION [dbo].[UFN_GET_SYNRHB]
(
	@Title_Code Int
)
RETURNS NVarchar(Max)
As
Begin
	--Declare @Title_Code Int = '1124'--, @Platform_Str Varchar(1000) = '1,10,117,118,120,124,125,127,130,131,132,133,137,138,146,16,160,17,18,182,184,191,2,200,205,210,218,229,23,230,231,248,249,256,258,264,3,31,36,38,4,5,53,6,62,65,8', @Region_Str Varchar(1000) = '170,180,209,210,394'

	Declare @TblSynRights Table(
		Syn_Deal_Rights_Code Int,
		Country_Name NVarchar(Max),
		Platform_Codes Varchar(Max),
		Platform_Name NVarchar(Max),
		Milestone_Type_Code Int,
		Milestone_Unit_Type Int,
		Milestone_No_Of_Unit Int
	)

	Declare @TblSynRightsRgn Table(
		Syn_Deal_Rights_Code Int,
		Country_Name NVarchar(Max)
	)

	Declare @TblSynRightsPlt Table(
		Syn_Deal_Rights_Code Int,
		Platform_Code Int
	)

	Insert InTo @TblSynRights(Syn_Deal_Rights_Code, Milestone_Type_Code, Milestone_Unit_Type, Milestone_No_Of_Unit)
	Select Distinct sdr.Syn_Deal_Rights_Code, Milestone_Type_Code, Milestone_Unit_Type, Milestone_No_Of_Unit From Syn_Deal_Rights sdr
	Inner Join Syn_Deal_Rights_Title sdrt On sdr.Syn_Deal_Rights_Code = sdrt.Syn_Deal_Rights_Code AND sdrt.Title_Code = @Title_Code And 
	Is_Pushback = 'Y' AND Right_Type = 'M' AND Actual_Right_Start_Date IS NULL
	
	Insert InTo @TblSynRightsRgn(Syn_Deal_Rights_Code, Country_Name)
	Select Distinct sdr.Syn_Deal_Rights_Code, td.Territory_Name From @TblSynRights sdr
	Inner Join Syn_Deal_Rights_Territory sdrtt On sdr.Syn_Deal_Rights_Code = sdrtt.Syn_Deal_Rights_Code AND sdrtt.Territory_Type <> 'I'
	Inner Join Territory td On sdrtt.Territory_Code = td.Territory_Code
	UNION
	Select Distinct sdr.Syn_Deal_Rights_Code, c.Country_Name From @TblSynRights sdr
	Inner Join Syn_Deal_Rights_Territory sdrtt On sdr.Syn_Deal_Rights_Code = sdrtt.Syn_Deal_Rights_Code AND sdrtt.Territory_Type = 'I'
	Inner Join Country c On sdrtt.Country_Code = c.Country_Code

	Insert InTo @TblSynRightsPlt(Syn_Deal_Rights_Code, Platform_Code)
	Select Distinct sdr.Syn_Deal_Rights_Code, Platform_Code From @TblSynRights sdr
	Inner Join Syn_Deal_Rights_Platform sdrp On sdr.Syn_Deal_Rights_Code = sdrp.Syn_Deal_Rights_Code


	Update b Set b.Country_Name = 
	STUFF
	(
		(
			SELECT DISTINCT ', ' + CAST(Country_Name As Varchar(Max)) FROM @TblSynRightsRgn a Where b.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
			FOR XML PATH('')
		), 1, 1, ''
	)
	From @TblSynRights b

	Update b Set b.Platform_Codes = 
	STUFF
	(
		(
			SELECT DISTINCT ', ' + CAST(a.Platform_Code As Varchar(Max)) FROM @TblSynRightsPlt a Where b.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
			FOR XML PATH('')
		), 1, 1, ''
	)
	From @TblSynRights b
	
	Update b Set b.Platform_Name = 
	STUFF
	(
		(
			SELECT DISTINCT ', ' + CAST(Platform_Hiearachy As NVarchar(Max)) FROM DBO.[UFN_Get_Platform_With_Parent](b.Platform_Codes)
			FOR XML PATH('')
		), 1, 1, ''
	)
	From @TblSynRights b
	Declare @term NVarchar(Max) = ''
	Select @term = 
	STUFF
	(
		(
			Select '' + StrRHB From (
				Select sdr.Country_Name COLLATE SQL_Latin1_General_CP1_CI_AS + ' - ' + sdr.Platform_Name COLLATE SQL_Latin1_General_CP1_CI_AS + ' - from ' + mt.Milestone_Type_Name COLLATE SQL_Latin1_General_CP1_CI_AS 
						+ ' to: ' + Cast(sdr.Milestone_No_Of_Unit as Varchar(4)) COLLATE SQL_Latin1_General_CP1_CI_AS +
						Case sdr.Milestone_Unit_Type When 1 Then ' Days' When 2 Then ' Weeks' When 3 Then ' Months' When 4 Then ' Years' End + ';' COLLATE SQL_Latin1_General_CP1_CI_AS As StrRHB
				From @TblSynRights sdr
				Inner Join Milestone_Type mt On sdr.Milestone_Type_Code = mt.Milestone_Type_Code
			) AS a 
			FOR XML PATH('')
		), 1, 1, ''
	)

	--Delete From @TblSynRightsRgn Where Syn_Deal_Rights_Code Not In (
	--	Select Syn_Deal_Rights_Code From @TblSynRightsPlt
	--)

	--Delete From @TblSynRightsPlt Where Syn_Deal_Rights_Code Not In (
	--	Select Syn_Deal_Rights_Code From @TblSynRightsRgn
	--)

	--Update rg Set rg.Country_Name = c.Country_Name From @TblSynRightsRgn rg
	--Inner Join Country c On rg.Country_Code = c.Country_Code 

	--Update rp Set rp.Platform_Name = p.Platform_Hiearachy From @TblSynRightsPlt rp
	--Inner Join Platform p On rp.Platform_Code = p.Platform_Code

	--Declare @term NVarchar(Max) = ''
	--Select @term = 
	--	STUFF
	--	(
	--		(
	--			Select '' + StrRHB From (
	--				Select 
	--					STUFF
	--					(
	--						(
	--							SELECT DISTINCT ', ' + CAST(Country_Name As NVarchar(Max)) FROM @TblSynRightsRgn a Where sdr.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
	--							FOR XML PATH('')
	--						), 1, 1, ''
	--					) + ' - ' +
	--					STUFF
	--					(
	--						(
	--							SELECT DISTINCT ', ' + CAST(Platform_Name As Varchar(Max)) FROM @TblSynRightsPlt a Where sdr.Syn_Deal_Rights_Code = a.Syn_Deal_Rights_Code
	--							FOR XML PATH('')
	--						), 1, 1, ''
	--					) + ' - from ' + mt.Milestone_Type_Name + ' to: ' + Cast(sdr.Milestone_No_Of_Unit as Varchar(4)) +
	--					Case sdr.Milestone_Unit_Type When 1 Then ' Days' When 2 Then ' Weeks' When 3 Then ' Months' When 4 Then ' Years' End + ';' As StrRHB
	--				From (Select Distinct Syn_Deal_Rights_Code From @TblSynRightsRgn) rg
	--				Inner Join Syn_Deal_Rights sdr On sdr.Syn_Deal_Rights_Code = rg.Syn_Deal_Rights_Code
	--				Inner Join Milestone_Type mt On sdr.Milestone_Type_Code = mt.Milestone_Type_Code
	--			) AS a 
	--			FOR XML PATH('')
	--		), 1, 1, ''
	--	)


	RETURN ISNULL(@term, '')
END

/*

Select DBO.[UFN_GET_SYNRHB](1124)

*/

