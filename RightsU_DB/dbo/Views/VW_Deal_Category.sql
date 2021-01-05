
CREATE VIEW VW_Deal_Category 
AS

--SELECT 'O' Category_Type, 'Own Production' Category_Name UNION
--SELECT 'A', 'Assignment' UNION
--SELECT 'L', 'License'

Select Role_Code AS Category_Type, Role_Name As Category_Name from Role where  Role_Type = 'A'