CREATE VIEW VW_BookingSheetTemplateData
AS
SELECT DISTINCT TempData.Title_Code, TempExtData.Columns_Code, TempExtData.Columns_Name, TempData.Value, TempData.ColumnName, TempExtData.Extended_Group_Code FROM 
(SELECT Title_Code, ColumnName, Value
FROM (
SELECT T.Title_Code, cast(ISNULL(TT.Start_Date,'') as nvarchar(max))  AS Start_Date, 
       cast(ISNULL(TT.End_Date,'') as nvarchar(max))  AS End_Date, 
	   cast(ISNULL(T.Duration_In_Min,0) as nvarchar(max)) AS Duration_In_Min,
	   cast(ISNULL(T.Synopsis,'') as nvarchar(max)) AS Synopsis 
FROM
	(SELECT Title_Code, Synopsis, Duration_In_Min FROM Title) T
		INNER JOIN
		(SELECT DISTINCT ar.AL_Recommendation_Code, ar.Start_Date, ar.End_Date, arc.Title_Code FROM AL_Recommendation ar 
		inner join AL_Recommendation_Content arc ON ar.AL_Recommendation_Code = arc.AL_Recommendation_Code) TT
		ON T.Title_Code = TT.Title_Code
	) d
UNPIVOT(Value FOR ColumnName IN ([Start_Date], [End_Date], [Duration_In_Min], [Synopsis])) unpiv) AS TempData 
INNER JOIN 
(SELECT ec.Columns_Code, ec.Columns_Name, ec.Ref_Value_Field, egc.Extended_Group_Code 
	FROM Extended_Columns ec 
	INNER JOIN Extended_Group_Config egc ON ec.Columns_Code = egc.Columns_Code
	WHERE ec.Columns_Code in (SELECT Columns_Code FROM Extended_Group_Config 
	WHERE Extended_Group_Code in (SELECT Extended_Group_Code FROM extended_group  WHERE Module_Code in (1)))) AS TempExtData
ON TempData.ColumnName = TempExtData.Ref_Value_Field
--ORDER by TempData.Title_Code ASC