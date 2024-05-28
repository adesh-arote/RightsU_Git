CREATE View [dbo].[VWTitle]
As
Select t.Title_Code, t.Title_Name, dt.Deal_Type_Name
From Title t
INNER Join Deal_Type dt On t.Deal_Type_Code = dt.Deal_Type_Code
where dt.Deal_Type_Code = 11
