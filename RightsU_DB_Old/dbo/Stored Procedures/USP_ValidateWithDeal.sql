--Exec USP_ValidateWithDeal '8','1,10,100,101,103,104,105,12,13,15,18,31,33,34,35,36,38,40,41,42,44,45,46,47,49,50,54,57,61,63,64,65,68,7,73,76,79,8,81,85,86,87,88,89,92,96,99'
--Exec USP_ValidateWithDeal '1,10,11,12,13,15,16,18,19,2,3,4,6,7,8' , '1'
cREATE PROCEDURE USP_ValidateWithDeal 
@Territory_Code varchar(2000),
@Country_Code  varchar(2000)
AS
Begin
Declare @query as nvarchar(max)
set @query =
'select * from acq_deal_rights_territory where Acq_Deal_Rights_Code is not Null
AND Territory_Code in('+@Territory_Code+')
AND Country_Code in('+@Country_Code+')
UNION
select * from acq_deal_pushback_territory where acq_deal_pushback_Code is not Null
AND Territory_Code in('+@Territory_Code+')
AND Country_Code in('+@Country_Code+')'
EXECUTE sp_executesql @query
ENd