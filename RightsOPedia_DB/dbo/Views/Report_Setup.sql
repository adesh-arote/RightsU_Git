



CREATE VIEW [dbo].[Report_Setup]
AS
SELECT arc.DP_Attrib_Group_Code [Department_Code], dp.Attrib_Group_Name [Department_Name], arc.BV_Attrib_Group_Code [Business_Vertical_Code], bv.Attrib_Group_Name [Business_Vertical_Name],
View_Name, Name_In_DB, Display_Name, IsPartofSelectOnly, Output_Group, arc.Display_Order, arc.Control_Type, List_Source, Lookup_Column, Display_Column, WhCondition, arc.Icon, arc.Is_Mandatory, arc.Css_Class, ValidOpList
FROM RightsU_Plus_Testing.dbo.Report_Column_Setup_IT rcs
INNER JOIN RightsU_Plus_Testing.dbo.Attrib_Report_Column arc ON rcs.Column_Code = arc.Column_Code
INNER JOIN RightsU_Plus_Testing.dbo.Attrib_Group dp ON dp.Attrib_Group_Code = arc.DP_Attrib_Group_Code AND dp.Is_Active = 'Y'
INNER JOIN RightsU_Plus_Testing.dbo.Attrib_Group bv ON bv.Attrib_Group_Code = arc.BV_Attrib_Group_Code AND dp.Is_Active = 'Y'



