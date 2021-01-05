CREATE VIEW [dbo].[VW_DIRECTOR]
AS 
SELECT T.talent_name, T.talent_code from Talent T 
INNER JOIN Talent_Role TR ON TR.talent_code = T.talent_code 
INNER JOIN Role R ON R.role_type = 'T' and R.role_code = TR.role_code and UPPER(R.role_name)='DIRECTOR'
