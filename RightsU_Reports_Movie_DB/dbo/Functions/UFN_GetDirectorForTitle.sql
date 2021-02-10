﻿CREATE function [dbo].[UFN_GetDirectorForTitle](@title_code as int) returns NVarchar(500)
as
begin
declare @retStr NVarchar(500)

select  @retStr = coalesce(@retStr + ', ', '') + 
(select talent_name from talent tstar where tstar.talent_code = tst.talent_code)  
 from title inner join Title_Talent tst on tst.title_code = title.title_code  and Role_Code=1
where  title.title_code = @title_code
--select ISNULL(@retStr,'')
return ISNULL(@retStr,'')
 -- select dbo.f_GetStarCastForTitle(22)
end

