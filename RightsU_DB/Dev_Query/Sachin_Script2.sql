USE RIGHTSU_NEO_DM_COLORS

Declare @Title_Code Int = 0
declare @TelevisionShow int,@FormatShow int
select @TelevisionShow =11,@FormatShow =13
	

Declare CUR_Title Cursor For 
	Select * From UTOAMS_15Jun2016.dbo.Title 
	where Title_code in (6,268,378,406,422,423,435,448,461,471,511,513,523,627,630,705,706,707,708,709,710)
	--Where english_title Not in 	(Select Title_name From Title) --And reference_flag is null --And Title_Code = 6520
Open CUR_Title
Fetch Next From CUR_Title InTo @Title_Code
While (@@FETCH_STATUS = 0)
Begin

	INSERT INTO TITLE([Title_Name],[original_title],[title_code_id],[synopsis],[original_language_code]
					  ,[year_of_production],[Deal_Type_Code],[inserted_by],[inserted_on],[lock_time]
					  ,[last_updated_time],[last_action_by],[is_active],[Grade_Code],[reference_Key]
					  ,[reference_flag],[Title_Language_Code],[Duration_In_Min])
	SELECT [english_title],[original_title],[title_code_id],[synopsis],null
		   ,[year_of_production],
		   --DealType_Code
		   case when DealType_Code =2 then @TelevisionShow 
			when DealType_Code =3 then @FormatShow
			else DealType_Code  end 
		   ,t.inserted_by,t.inserted_on,t.lock_time
		   ,t.last_updated_time,t.last_action_by,t.is_active,gnew.Grade_Code,null
		   ,null,CASE WHEN lnew.language_code = 0 THEN NULL ELSE lnew.language_code END ,pre_CBFC_duration_in_min
	FROM UTOAMS_15Jun2016.dbo.Title t
	--inner join Rightsu_vmpl_live_27March_2015.dbo.Deal_Type dt on t.dealtype_code=dt.deal_type_code
	--inner join Deal_Type dtNew on dtNew.Deal_Type_Name=dt.Deal_Type_Name
	left join UTOAMS_15Jun2016.dbo.Language l on l.language_code=t.original_language_code
	left join Language lNew on lnew.Language_Name=l.Language_Name
	left join UTOAMS_15Jun2016.dbo.Grade_Master g on g.grade_code=t.Grade_Code
	left join Grade_Master gNew on gNew.Grade_Name=g.Grade_Name
	--left join Rightsu_Colors_22APR2015.dbo.Language lt on lt.language_code=t.Title_Language_Code
	--left join Language ltNew on ltnew.Language_Name=lt.Language_Name
	WHERE title_code = @Title_Code

	INSERT INTO Title_Country(title_code,Country_code)
	SELECT IDENT_CURRENT('Title'),c.Country_Code FROM UTOAMS_15Jun2016.dbo.Title_Country tc
	inner join UTOAMS_15Jun2016.dbo.International_Territory it on it.international_territory_code=tc.territory_code
	inner join Country c on c.Country_Name=it.international_territory_name
	WHERE title_code = @Title_Code


	INSERT INTO Title_Talent(Title_Code,Talent_Code,Role_Code)
	SELECT IDENT_CURRENT('Title'),tel1.Talent_Code,tr.role_code 
	FROM Rightsu_Colors_22APR2015.dbo.Title_Talent tt
	Inner Join Rightsu_Colors_22APR2015.dbo.Talent tel On tt.talent_code = tel.talent_code
	Inner Join Talent tel1 On tel.talent_name = tel1.Talent_Name
	inner join Rightsu_Colors_22APR2015.dbo.Talent_Role tr on tr.talent_code=tt.talent_code
	--inner join Rightsu_Colors_22APR2015.dbo.Role r on r.role_code=tt.Role_code
	--inner join Role rnew on rnew.Role_Name=r.Role_Name
	WHERE title_code = @Title_Code

	INSERT INTO Title_Geners(Title_Code,Genres_Code)
	SELECT IDENT_CURRENT('Title'),gnew.Genres_Code FROM Rightsu_Colors_22APR2015.dbo.Title_Geners tg
	Inner Join Rightsu_Colors_22APR2015.dbo.Genres g On tg.genres_code = g.genres_code
	Inner Join Genres gnew On g.genres_name = gnew.Genres_Name
	WHERE title_code = @Title_Code

	--INSERT INTO Map_Extended_Columns(Record_Code, Table_Name, Columns_Code, Columns_Value_Code, Column_Value, Is_Multiple_Select)
	--SELECT IDENT_CURRENT('Title'), Table_Name, Columns_Code, 
	--	Case 
	--		When Columns_Value_Code = 23 Then 12
	--		When Columns_Value_Code = 24 Then 13
	--		Else Columns_Value_Code
	--	End,  
	--	Column_Value, Is_Multiple_Select 
	--FROM Rightsu_Colors_22APR2015.dbo.Map_Extended_Columns
	--WHERE Record_Code = @Title_Code

	--INSERT INTO Map_Extended_Columns_Details(Map_Extended_Columns_Code, Columns_Value_Code)
	--SELECT mecNew.Map_Extended_Columns_Code, telNew.Talent_Code
	--FROM Rightsu_Colors_22APR2015.dbo.Map_Extended_Columns_Details mecd 
	--Inner Join Rightsu_Colors_22APR2015.dbo.Map_Extended_Columns mec On mec.Map_Extended_Columns_Code = mecd.Map_Extended_Columns_Code And mec.Record_Code = @Title_Code
	--Inner Join Map_Extended_Columns mecNew On mec.Columns_Code = mecNew.Columns_Code And mecNew.Record_Code = IDENT_CURRENT('Title')
	--Left Join Rightsu_Colors_22APR2015.dbo.Talent telOld On mecd.Columns_Value_Code = telOld.talent_code
	--Left Join Talent telNew On telOld.Talent_Name = telNew.Talent_Name

	Fetch Next From CUR_Title InTo @Title_Code
End
Close CUR_Title
Deallocate CUR_Title

delete from Map_Extended_Columns 
delete from Map_Extended_Columns_Details
-- =============================================
-- Declare and using a READ_ONLY cursor
-- =============================================
declare @Map_Extended_Columns_Code int
DECLARE CR_TitleTalent CURSOR
READ_ONLY
FOR 
	select distinct tt.Title_Code,ec.Columns_Code,ec.Is_Multiple_Select ,R.Role_Code
	from Title_Talent tt
	inner join Role r on r.Role_Code=tt.Role_Code
	inner join Extended_Columns ec  on r.Role_Name=ec.Columns_Name
	where tt.Role_Code in (13,15,16,17,18,19,21,22,23,24)

DECLARE @Title_CodeNew int,@Columns_Code int ,@Is_Multiple_Select  varchar(1),@role_Code int
OPEN CR_TitleTalent

FETCH NEXT FROM CR_TitleTalent INTO @Title_CodeNew,@Columns_Code,@Is_Multiple_Select ,@role_Code
WHILE (@@fetch_status <> -1)
BEGIN
	IF (@@fetch_status <> -2)
	BEGIN

		Insert into Map_Extended_Columns (Record_Code,Table_Name,Columns_Code,Columns_Value_Code,Column_Value,Is_Multiple_Select)
		select @Title_CodeNew,'TITLE',@Columns_Code,null,null,@Is_Multiple_Select 
		
		SELECT @Map_Extended_Columns_Code=SCOPE_IDENTITY() 

		Insert into Map_Extended_Columns_Details (Map_Extended_Columns_Code,Columns_Value_Code)
		select @Map_Extended_Columns_Code,tt.Talent_Code from Title_Talent tt
		where tt.Role_Code=@role_Code and tt.Title_Code=@Title_CodeNew

	END
	FETCH NEXT FROM CR_TitleTalent INTO @Title_CodeNew,@Columns_Code,@Is_Multiple_Select ,@role_Code
END

CLOSE CR_TitleTalent
DEALLOCATE CR_TitleTalent


delete from Title_Talent where Role_Code in (13,15,16,17,18,19,21,22,23,24)

