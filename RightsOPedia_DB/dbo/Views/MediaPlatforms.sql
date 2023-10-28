﻿



CREATE VIEW [dbo].[MediaPlatforms]
	AS 
Select distinct p.Platform_Hiearachy,p.Platform_Code,AG.Attrib_Group_Code from Platform P
INNER JOIN Platform_Attrib_Group PAG ON P.Platform_Code = PAG.Platform_Code
INNER JOIN Attrib_Group AG ON PAG.Attrib_Group_Code = AG.Attrib_Group_Code 
where AG.Attrib_Group_Code IN (3,4) AND Parent_Platform_Code = 0 AND Is_Last_Level = 'N'




