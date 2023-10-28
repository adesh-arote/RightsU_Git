CREATE Procedure [dbo].[USP_Generate_Search_Music_Title]      
As      
Begin      
	Declare @Loglevel int;
	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Generate_Search_Music_Title]', 'Step 1', 0, 'Started Procedure', 0, ''
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
		 Create Table #Temp(      
		  Music_Title_Code Int,       
		  Masters_Value NVarchar(Max)      
		 )      
		 -- =============================================      
		-- Author:  Adesh Arote      
		-- Create date: 19-May-2017      
		-- Description: Concatenate Master value to Search for Music Title       
		-- =============================================      
  
  
		 Insert InTo #Temp(Music_Title_Code, Masters_Value)      
		 Select Music_Title_Code,  LTRIM(RTRIM(Search_Value)) From (      
		  Select  Music_Title_Code,   
		 MT.Music_title_Name +' '+  
		   IsNull(REVERSE(STUFF(REVERSE(STUFF(      
		   (      
			SELECT Distinct cast(MA.Music_Album_Name  as NVARCHAR(MAX)) + ','      
			FROM Music_Album MA  (NOLOCK)    
			WHERE MA.Music_Album_Code = MT.Music_Album_Code    
			FOR XML PATH(''), root('ALBUM'), type      
			 ).value('/ALBUM[1]','Nvarchar(max)'      
		   ),2,0, '')), 1, 1, '')), '') + ' ' +     
  
		   IsNull(REVERSE(STUFF(REVERSE(STUFF(      
		   (      
			SELECT Distinct cast(MTH.Music_Theme_Name  as NVARCHAR(MAX)) + ','      
			FROM Music_Theme MTH    (NOLOCK)  
		  INNER JOIN Music_Title_Theme MTT (NOLOCK) on MT.Music_Title_Code= MTT.Music_Title_Code    
			WHERE MTT.Music_Theme_Code = MTH.Music_Theme_Code    
			FOR XML PATH(''), root('THEME'), type      
			 ).value('/THEME[1]','Nvarchar(max)'      
		   ),2,0, '')), 1, 1, '')), '') + ' ' +     
		   IsNull(REVERSE(STUFF(REVERSE(STUFF(      
		   (      
			SELECT Distinct cast(Tal.Talent_Name  as NVARCHAR(MAX)) + ','      
			FROM Music_Title_Talent TT    (NOLOCK)   
			INNER JOIN Talent Tal (NOLOCK) on tal.talent_Code = TT.Talent_code      
			WHERE TT.Music_Title_Code = MT.Music_Title_Code      
			FOR XML PATH(''), root('TALENT'), type      
			 ).value('/TALENT[1]','Nvarchar(max)'      
		   ),2,0, '')), 1, 1, '')), '') + ' ' +      
		   IsNull(REVERSE(STUFF(REVERSE(STUFF(      
		   (      
			SELECT Distinct cast(ml.Music_Label_Name  as NVARCHAR(MAX)) + ','      
			FROM Music_Title_Label tl   (NOLOCK)    
			INNER JOIN Music_Label ml (NOLOCK) on ml.Music_Label_Code = tl.Music_Label_Code      
			WHERE tl.Music_Title_Code = mt.Music_Title_Code and tl.Effective_To IS Null     
			FOR XML PATH(''), root('LABEL'), type      
			 ).value('/LABEL[1]','Nvarchar(max)'      
		   ),2,0, '')), 1, 1, '')), '') + ' ' +     
		   IsNull(REVERSE(STUFF(REVERSE(STUFF(      
		   (      
			SELECT Distinct cast(ml.Language_Name  as NVARCHAR(MAX)) + ','      
			FROM Music_Title_Language tl   (NOLOCK)    
			INNER JOIN Music_Language ml (NOLOCK) on ml.Music_Language_Code = tl.Music_Language_Code      
			WHERE tl.Music_Title_Code = mt.Music_Title_Code      
			FOR XML PATH(''), root('LANG'), type      
			 ).value('/LANG[1]','Nvarchar(max)'      
		   ),2,0, '')), 1, 1, '')), '') As Search_Value      
		  From Music_Title MT    
		  --INNER JOIN Music_Album MA ON MA.Music_Album_Code = MT.Music_Album_Code  
		   Where Music_Title_Code   In (      
		   Select Record_Code From Process_Search (NOLOCK) Where Module_Name = 'MT' and DATEADD(SECOND, 3, Created_On) <= GETDATE()      
		  )      
		 ) AS a      
      
		 Delete From Process_Search Where Module_Name = 'MT'AND Record_Code In (      
		  Select Music_Title_Code From #Temp      
		 )      
       
		 Delete mts      
		 From #Temp t      
		 Inner Join Music_Title_Search mts On t.Music_Title_Code = mts.Music_Title_Code AND IsNull(t.Masters_Value, '') = ''      
      
		 Delete From #Temp Where IsNull(Masters_Value, '') = ''      
      
		 Update mts Set mts.Masters_Value = t.Masters_Value      
		 From #Temp t      
		 Inner Join Music_Title_Search mts On t.Music_Title_Code = mts.Music_Title_Code      
      
		 Delete t      
		 From #Temp t      
		 Inner Join Music_Title_Search mts On t.Music_Title_Code = mts.Music_Title_Code      
      
		 Insert InTo Music_Title_Search(Music_Title_Code, Masters_Value)      
		 Select Music_Title_Code, Masters_Value From #Temp      
      
			--Drop Table #Temp      
		   IF OBJECT_ID('tempdb..#Temp') IS NOT NULL DROP TABLE #Temp   

	if(@Loglevel < 2)Exec [USPLogSQLSteps] '[USP_Generate_Search_Music_Title]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
End