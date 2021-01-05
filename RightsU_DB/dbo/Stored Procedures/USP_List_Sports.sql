CREATE PROCEDURE [dbo].[USP_List_Sports]
@Acq_Deal_Code INT, 
@View_Type CHAR(1) = 'G',
@Title_Codes VARCHAR(5000) = '', 
@Deal_Movie_Codes VARCHAR(5000) = ''
AS
--|=============================================
--| Author:		  ADESH AROTE, RUSHABH GOHIL
--| Date Created: 02-Feb-2015
--| Description:  Acq Deal Sports List
--|=============================================
BEGIN
	SET FMTONLY OFF
	
	SET @Title_Codes = ISNULL(@Title_Codes,'')
	SET @Deal_Movie_Codes = ISNULL(@Deal_Movie_Codes,'')
	
	Declare @Sport_Code INT=0, @Title_Names NVARCHAR(MAX)

	Create Table #Temp_Sport_Rights (
		Acq_Deal_Sports_Code Int,
		Deal_Code Int,
		Title_Code Int,
		Episode_From Int,
		Episode_To Int,
		Content_Delivery Varchar(100),
		ST_Platform_Code Int,
		SM_Platform_Code Int,
		OB_Broadcast_Code Int,
		MB_Broadcast_Code Int,
		OB_Broadcast_Name NVARCHAR(2000),
		MB_Broadcast_Name NVARCHAR(2000),
		Title_Name NVARCHAR(2000),
		ST_Platform_Name NVARCHAR(2000),
		SM_Platform_Name NVARCHAR(2000)
		--Remarks Varchar(max)
	)
	
	Create Table #Temp_MB(
		Acq_Deal_Sport_Code Int, 
		Broadcast_Mode_Code int,
		Broadcast_Name NVARCHAR(200),
	)

	Create Table #Temp_OB(
		Acq_Deal_Sport_Code Int, 
		Broadcast_Mode_Code int,
		Broadcast_Name NVARCHAR(200),
	)

	Create Table #TempTIT(
		Acq_Deal_Sport_Code Int, 
		Title_Code Varchar(1000),
		Title_Name NVARCHAR(2000),
		Episode_From INT,
		Episode_To INT
	)

	Create Table #Temp_ST(
		Acq_Deal_Sport_Code Int, 
		Platform_Code int,
		Platform_Name NVARCHAR(4000),
	)

	Create Table #Temp_SM(
		Acq_Deal_Sport_Code Int, 
		Platform_Code int,
		Platform_Name NVARCHAR(4000),
	)

	If(@Title_Codes = '')
	Begin
		Select @Title_Codes = @Title_Codes + ',' + Cast(Title_Code As Varchar) From Acq_Deal_Movie Where Acq_Deal_Code = @Acq_Deal_Code
	End

	If(@Deal_Movie_Codes = '')
	Begin
		Select @Deal_Movie_Codes = @Deal_Movie_Codes + ',' + Cast(Acq_Deal_Movie_Code As Varchar) From Acq_Deal_Movie Where Acq_Deal_Code = @Acq_Deal_Code
	End

	Declare CUR_Sport Cursor For Select Acq_Deal_Sport_Code From Acq_Deal_Sport Where Acq_Deal_Code = @Acq_Deal_Code
	Open CUR_Sport
	Fetch Next From CUR_Sport InTo @Sport_Code
	While (@@FETCH_STATUS = 0)
	Begin
		If(@View_Type <> 'G')
		Begin
			--#TempTIT
			Insert InTo #TempTIT
			Select adrt.Acq_Deal_Sport_Code, adrt.Title_Code, 
			t.Title_Name + ' (' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ')' As Title_Name, 
			adrt.Episode_From, adrt.Episode_To
			From Acq_Deal_Sport_Title adrt 
			Inner Join Title t On adrt.Title_Code = t.Title_Code And Acq_Deal_Sport_Code = @Sport_Code 
			INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = @Acq_Deal_Code AND ADM.Title_Code = adrt.Title_Code 
			AND ISNULL(ADM.Episode_Starts_From, 0) = ISNULL(adrt.Episode_From, 0) AND ISNULL(ADM.Episode_End_To, 0) = ISNULL(adrt.Episode_To, 0)
			Where adrt.Title_Code In (
				Select number From DBO.fn_Split_withdelemiter(@Title_Codes, ',')
			) AND 
			ADM.Acq_Deal_Movie_Code In (
				Select number From DBO.fn_Split_withdelemiter(@Deal_Movie_Codes, ',')
			)
		End
		Else
		Begin
			Set @Title_Names = ''
			Select @Title_Names = @Title_Names + Title_Name + ', ' From (
				Select Distinct t.Title_Name + ' (' + Cast(adrt.Episode_From as Varchar(10)) + ' - ' + Cast(adrt.Episode_To as Varchar(10)) + ')' As Title_Name
				From Title t Inner Join Acq_Deal_Sport_Title adrt On t.Title_Code = adrt.Title_Code 
				INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = @Acq_Deal_Code AND ADM.Title_Code = adrt.Title_Code 
				AND ISNULL(ADM.Episode_Starts_From, 0) = ISNULL(adrt.Episode_From, 0) AND ISNULL(ADM.Episode_End_To, 0) = ISNULL(adrt.Episode_To, 0)
				Where Acq_Deal_Sport_Code = @Sport_Code And adrt.Title_Code In (
					Select number From DBO.fn_Split_withdelemiter(@Title_Codes, ',')
				)AND 
				ADM.Acq_Deal_Movie_Code In (
					Select number From DBO.fn_Split_withdelemiter(@Deal_Movie_Codes, ',')
				)
			) as a

			If(@Title_Names <> '')
			Begin
				Insert InTo #TempTIT (Acq_Deal_Sport_Code, Title_Code,Title_Name,Episode_From,Episode_To)
				Select @Sport_Code, 0, Substring(@Title_Names, 0, Len(@Title_Names)), 1, 1
			End
			
		End
		
		Declare @Name Varchar(2000) = ''
		
		--#Temp_MB
		If((Select Count(*) From Acq_Deal_Sport_Broadcast Where [Type] = 'MO' And Acq_Deal_Sport_Code = @Sport_Code) > 0)
		Begin
			Select @Name = @Name + bm.Broadcast_Mode_Name + ', ' From Acq_Deal_Sport_Broadcast adsb 
			Inner Join Broadcast_Mode bm On adsb.Broadcast_Mode_Code = bm.Broadcast_Mode_Code
			Where [Type] = 'MO' And Acq_Deal_Sport_Code = @Sport_Code
			
			Insert InTo #Temp_MB(Acq_Deal_Sport_Code, Broadcast_Mode_Code, Broadcast_Name)
			Select @Sport_Code, '0', Substring(@Name, 0, Len(@Name))
		End
		Else
			Insert InTo #Temp_MB(Acq_Deal_Sport_Code, Broadcast_Mode_Code, Broadcast_Name)
			Values(@Sport_Code, 0, '')
		Set @Name = ''
		
		--#Temp_OB
		If((Select Count(*) From Acq_Deal_Sport_Broadcast Where [Type] = 'OB' And Acq_Deal_Sport_Code = @Sport_Code) > 0)
		Begin
			Select @Name = @Name + bm.Broadcast_Mode_Name + ', ' From Acq_Deal_Sport_Broadcast adsb 
			Inner Join Broadcast_Mode bm On adsb.Broadcast_Mode_Code = bm.Broadcast_Mode_Code
			Where [Type] = 'OB' And Acq_Deal_Sport_Code = @Sport_Code
			
			Insert InTo #Temp_OB(Acq_Deal_Sport_Code, Broadcast_Mode_Code, Broadcast_Name)
			Select @Sport_Code, '0', Substring(@Name, 0, Len(@Name))
		End
		Else
			Insert InTo #Temp_OB(Acq_Deal_Sport_Code, Broadcast_Mode_Code, Broadcast_Name)
			Values(@Sport_Code, 0, '')
		Set @Name = ''
		
		--#Temp_ST
		If((Select Count(*) From Acq_Deal_Sport_Platform Where [Type] = 'ST' And Acq_Deal_Sport_Code = @Sport_Code) > 0)
		Begin
			Select @Name = @Name + p.Platform_Hiearachy + ', ' From Acq_Deal_Sport_Platform adsp
			Inner Join [Platform] p On adsp.Platform_Code = p.Platform_Code
			Where [Type] = 'ST' And Acq_Deal_Sport_Code = @Sport_Code
			
			Insert InTo #Temp_ST(Acq_Deal_Sport_Code, Platform_Code, Platform_Name)
			Select @Sport_Code, '0', Substring(@Name, 0, Len(@Name))
		End
		Else
			Insert InTo #Temp_ST(Acq_Deal_Sport_Code, Platform_Code, Platform_Name)
			Values(@Sport_Code, 0, '')
		Set @Name = ''
		
		--#Temp_SM
		If((Select Count(*) From Acq_Deal_Sport_Platform Where [Type] = 'SM' And Acq_Deal_Sport_Code = @Sport_Code) > 0)
		Begin
			Select @Name = @Name + p.Platform_Hiearachy + ', ' From Acq_Deal_Sport_Platform adsp
			Inner Join [Platform] p On adsp.Platform_Code = p.Platform_Code
			Where [Type] = 'SM' And Acq_Deal_Sport_Code = @Sport_Code
			
			Insert InTo #Temp_SM(Acq_Deal_Sport_Code, Platform_Code, Platform_Name)
			Select @Sport_Code, '0', Substring(@Name, 0, Len(@Name))
		End
		Else
			Insert InTo #Temp_SM(Acq_Deal_Sport_Code, Platform_Code, Platform_Name)
			Values(@Sport_Code, 0, '')
			
		Insert InTo #Temp_Sport_Rights
		Select sp.Acq_Deal_Sport_Code, sp.Acq_Deal_Code, tit.Title_Code, tit.Episode_From, tit.Episode_To, 
		CASE sp.Content_Delivery WHEN 'LV' THEN 'Live' WHEN 'RC' THEN 'Recorded' END,
		st.Platform_Code,sm.Platform_Code, mb.Broadcast_Mode_Code, ob.Broadcast_Mode_Code,
		CASE ob.Broadcast_Name WHEN '' THEN 'No' ELSE ob.Broadcast_Name END,
		CASE mb.Broadcast_Name WHEN '' THEN 'No' ELSE mb.Broadcast_Name END,
		tit.Title_Name,
		CASE st.Platform_Name WHEN '' THEN 'No' ELSE st.Platform_Name END,
		CASE sm.Platform_Name WHEN '' THEN 'No' ELSE sm.Platform_Name END
		From Acq_Deal_Sport sp
		Inner Join #TempTIT tit On sp.Acq_Deal_Sport_Code = tit.Acq_Deal_Sport_Code
		Inner Join #Temp_MB mb On sp.Acq_Deal_Sport_Code = mb.Acq_Deal_Sport_Code
		Inner Join #Temp_OB ob On sp.Acq_Deal_Sport_Code = ob.Acq_Deal_Sport_Code
		Inner Join #Temp_ST st On sp.Acq_Deal_Sport_Code = st.Acq_Deal_Sport_Code
		Inner Join #Temp_SM sm On sp.Acq_Deal_Sport_Code = sm.Acq_Deal_Sport_Code
		Where sp.Acq_Deal_Sport_Code = @Sport_Code

		Fetch Next From CUR_Sport InTo @Sport_Code
	End
	Close CUR_Sport
	Deallocate CUR_Sport

	Select * From  #Temp_Sport_Rights
	--Select * From  #TempTIT
	--Select * From  #Temp_MB
	--Select * From  #Temp_OB
	--Select * From  #Temp_ST
	--Select * From  #Temp_SM

	--Drop Table #Temp_Sport_Rights
	--Drop Table #TempTIT
	--Drop Table #Temp_MB
	--Drop Table #Temp_OB
	--Drop Table #Temp_ST
	--Drop Table #Temp_SM

	IF OBJECT_ID('tempdb..#Temp_MB') IS NOT NULL DROP TABLE #Temp_MB
	IF OBJECT_ID('tempdb..#Temp_OB') IS NOT NULL DROP TABLE #Temp_OB
	IF OBJECT_ID('tempdb..#Temp_SM') IS NOT NULL DROP TABLE #Temp_SM
	IF OBJECT_ID('tempdb..#Temp_Sport_Rights') IS NOT NULL DROP TABLE #Temp_Sport_Rights
	IF OBJECT_ID('tempdb..#Temp_ST') IS NOT NULL DROP TABLE #Temp_ST
	IF OBJECT_ID('tempdb..#TempTIT') IS NOT NULL DROP TABLE #TempTIT
END

/*
EXEC [USP_List_Sports] 275
*/