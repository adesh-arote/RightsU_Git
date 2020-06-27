

CREATE function [dbo].[UFN_GetGenresForTitle](@title_code as int) returns NVarchar(500)
as
begin
declare @retStr NVarchar(500)

select  @retStr = coalesce(@retStr + ', ', '') + 
(select Genres_Name from Genres g where g.Genres_Code = tg.Genres_Code)  
 from Title t
LEFT OUTER JOIN Title_Geners AS tg ON t.Title_Code =tg.Title_Code
where  t.Title_Code = @title_code
--select ISNULL(@retStr,'')
return ISNULL(@retStr,'')
 -- select dbo.f_GetStarCastForTitle(22)
end



