CREATE View [dbo].[VWTitleContent]
As
Select tc.Title_Content_Code, t.Title_Code, t.Title_Name, tc.Episode_Title, tc.Episode_No
From Title_Content tc
Inner Join vwtitle t On tc.Title_Code = t.Title_Code 