CREATE VIEW [dbo].[vwMovieTitleContent]      
AS 
select DISTINCT 
T.Title_Code,
TC1.Title_Content_Code,
TC1.Episode_No,
TC1.Ref_BMS_Content_Code ,
TC1.Episode_Title,
T.Title_Name,T.Duration_In_Min,L.Language_Name,
C.Country_Name,
REVERSE(stuff(reverse(  stuff(      
	(         
		select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + ', ' from Title_Talent TT      
		inner join Role R on R.Role_Code = TT.Role_Code      
		inner join Talent Tal on tal.talent_Code = TT.Talent_code      
		where TT.Title_Code = T.Title_Code AND R.Role_Code in (2)      
      
		FOR XML PATH(''), root('TalentName'), type      
	).value('/TalentName[1]','NVARCHAR(max)' ),1,0, '')      
	),1,2,'')) as [KeyStarCast],     
REVERSE(stuff(reverse(  stuff(      
	(         
		select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + ', ' from Title_Talent TT      
		inner join Role R on R.Role_Code = TT.Role_Code      
		inner join Talent Tal on tal.talent_Code = TT.Talent_code      
		where TT.Title_Code = T.Title_Code AND R.Role_Code in (4)      
      
		FOR XML PATH(''), root('Producer'), type      
	).value('/Producer[1]','NVARCHAR(max)'      
),1,0, '')),1,2,'')) as Producer ,

REVERSE(stuff(reverse(  stuff(      
	(         
		select cast(Tal.Talent_Name  as NVARCHAR(MAX)) + ', ' from Title_Talent TT      
		inner join Role R on R.Role_Code = TT.Role_Code      
		inner join Talent Tal on tal.talent_Code = TT.Talent_code      
		where TT.Title_Code = T.Title_Code AND R.Role_Code in (1)      
      
		FOR XML PATH(''), root('Director'), type      
	).value('/Director[1]','NVARCHAR(max)'      
	),1,0, '')      
),1,2,'')) as Director,
[dbo].[UFN_Get_Title_Genre](T.Title_Code) as Genre, ISNULL(T.Title_Image,' ') As Title_Image, T.Last_UpDated_Time, T.Inserted_On    
,(select TOP 1 P.Program_Name from Program P Where P.Program_Code = T.Program_Code) Program
,T.Year_Of_Production [YearOfRelease]
,Case When T.Is_Active='Y' then 'Active' Else 'Deactive' END AS Is_Active
from Title T 
INNER JOIN Language L ON L.Language_Code = T.Title_Language_Code
INNER JOIN Title_Country TC ON  TC.Title_Code = T.Title_Code
INNER  JOIN Country C ON TC.Country_Code = C.Country_Code
INNER JOIN Title_Content TC1 ON T.Title_Code = TC1.Title_Code
Where T.Deal_Type_Code = 1
