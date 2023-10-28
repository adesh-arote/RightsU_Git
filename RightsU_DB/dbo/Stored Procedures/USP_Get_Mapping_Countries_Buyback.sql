﻿CREATE Proc [dbo].[USP_Get_Mapping_Countries_Buyback](@Syn_Deal_Right_Code Int)
As
Begin
	Declare @Loglevel int;
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Mapping_Countries_Buyback]', 'Step 1', 0, 'Started Procedure', 0, '' 
		Create Table #Temp_Acq_Country(
			Country_Code Int,
			Is_Added Char(1)
		)
	
		Create Table #Temp_Syn_Country(
			Country_Code Int
		)

		Insert InTo #Temp_Acq_Country
		SELECT DISTINCT CASE WHEN ADRT.Territory_Type = 'G' THEN TD.Country_Code ELSE ADRT.Country_Code END AS Country_Code,'N' 
		FROM Syn_Deal_Rights_Territory ADRT (NOLOCK) 
		LEFT JOIN Territory_Details TD (NOLOCK) ON ISNULL(ADRT.Territory_Code,0) = TD.Territory_Code
		WHERE Syn_Deal_Rights_Code = @Syn_Deal_Right_Code

	

		Insert InTo #Temp_Acq_Country
		Select DISTINCT Country_Code, 'Y' From Country (NOLOCK) Where Parent_Country_Code In (Select Country_Code From #Temp_Acq_Country)

		Insert InTo #Temp_Syn_Country
		SELECT tbl.Country_Code FROM 
		(
			SELECT DISTINCT CASE WHEN SDRT.Territory_Type = 'G' THEN TD.Country_Code ELSE SDRT.Country_Code END AS Country_Code
			FROM Acq_Deal_Rights_Territory SDRT (NOLOCK)
			LEFT JOIN Territory_Details TD (NOLOCK) ON SDRT.Territory_Code = TD.Territory_Code 		
			WHERE Acq_Deal_Rights_Code In(
				Select Acq_Deal_Rights_Code From Acq_Deal_Rights (NOLOCK) Where Buyback_Syn_Rights_Code = @Syn_Deal_Right_Code
			)
		) AS tbl
		WHERE tbl.Country_Code IN(Select TAC.Country_Code FROM #Temp_Acq_Country TAC)
	

		Declare @Mapped_Countries Varchar(Max) = ''
		If((Select Is_Theatrical_Right From Syn_Deal_Rights (NOLOCK) Where Syn_Deal_Rights_Code = @Syn_Deal_Right_Code) = 'N')
		Begin
			Select @Mapped_Countries = @Mapped_Countries + Cast(Country_Code As Varchar(10)) + ',' From (
				Select Distinct Case When Is_Theatrical_Territory = 'Y' Then Parent_Country_Code Else Country_Code End As Country_Code
				From Country (NOLOCK) Where Country_Code In (Select Country_Code From #Temp_Syn_Country)
			) As a
		End
		Else
		Begin
			Select @Mapped_Countries = @Mapped_Countries + Cast(Country_Code As Varchar(10)) + ',' From #Temp_Syn_Country
		End

		Set @Mapped_Countries = SUBSTRING(@Mapped_Countries, 0, Len(@Mapped_Countries))
		Select @Mapped_Countries As Mapped_Countries

		--Drop Table #Temp_Acq_Country
		--Drop Table #Temp_Syn_Country

		IF OBJECT_ID('tempdb..#Temp_Acq_Country') IS NOT NULL DROP TABLE #Temp_Acq_Country
		IF OBJECT_ID('tempdb..#Temp_Syn_Country') IS NOT NULL DROP TABLE #Temp_Syn_Country
	 
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Get_Mapping_Countries_Buyback]', 'Step 2', 0, 'Procedure Excution Completed', 0, '' 
End