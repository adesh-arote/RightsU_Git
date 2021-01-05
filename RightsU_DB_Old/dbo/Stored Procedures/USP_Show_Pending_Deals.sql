CREATE Procedure [dbo].[USP_Show_Pending_Deals] (@Acq_Deal_Code int)            
As    
-- =============================================
-- Author:		Pavitar Dua
-- Create DATE: 14-October-2014
-- Description:	
-- =============================================      
Begin           
/*
	select t.english_title  as original_title,    
	CASE WHEN  c.deal_movie_code is  not  null then 'Yes' else 'No' end IsCostAdded,  
	CASE WHEN r.deal_movie_code IS NOT NULL  then 'Yes' else 'No'  end IsRightsAdded,  
	CASE WHEN r.deal_movie_code IS NULL then 'Rights not added' else '' end +' '+    
	CASE WHEN  c.deal_movie_code IS NULL then ' Cost not added' else '' end as Error    
	from deal_movie dm 
	left outer join deal_movie_rights r  on dm.deal_movie_code=r.deal_movie_code     
	left outer join title t on t.title_code=dm.title_code    
	left outer join deal_movie_cost c on dm.deal_movie_code=c.deal_movie_code    
	where  dm.deal_code=@deal_code AND (c.deal_movie_code IS NULL OR r.deal_movie_code IS NULL)
	group by t.english_title, c.deal_movie_code, r.deal_movie_code
*/

SELECT 
Acq_Deal_Code,
T.Title_Name  as Title_Name,
--CASE WHEN  c.deal_movie_code is  not  null then 'Yes' else 'No' end IsCostAdded,  
--CASE WHEN r.deal_movie_code IS NOT NULL  then 'Yes' else 'No'  end IsRightsAdded,  
CASE WHEN ADRT.Acq_Deal_Rights_Code IS NULL then 'Rights not added' else '' end +' '    
--CASE WHEN  c.deal_movie_code IS NULL then ' Cost not added' else '' end as Error    
FROM 
Acq_Deal_Movie ADM
INNER JOIN Acq_Deal_Rights_Title ADRT ON ADM.Title_Code=ADRT.Title_Code
INNER JOIN Title T ON T.Title_Code=ADRT.Title_Code
GROUP BY Title_Name,Acq_Deal_Rights_Code,Acq_Deal_Code

End 

/*
[sp_showPendingDeals] 222

*/