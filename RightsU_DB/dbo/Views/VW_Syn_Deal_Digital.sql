CREATE VIEW dbo.VW_Syn_Deal_Digital
AS
SELECT Syn_Deal_Code, sdd.Syn_Deal_Digital_Code, Title_code, Episode_From, Episode_To, Music_Title_Code, AvailableForExcel, sddd3.Remarks
--, sddd1.Row_Num, sddd2.Row_Num, sddd3.Row_Num
FROM Syn_Deal_Digital sdd 
INNER JOIN (
   SELECT sddd1in.Syn_Deal_Digital_Code, sddd1in.Digital_Data_Code AS Music_Title_Code, sddd1in.Row_Num FROM Syn_Deal_Digital_Detail sddd1in 
   WHERE sddd1in.Digital_Config_Code = 17 AND sddd1in.Digital_Data_Code IS NOT NULL
)sddd1 ON sddd1.Syn_Deal_Digital_Code = sdd.Syn_Deal_Digital_Code
INNER JOIN (
   SELECT sddd2in.Syn_Deal_Digital_Code, sddd2in.User_Value AS AvailableForExcel, sddd2in.Row_Num FROM Syn_Deal_Digital_Detail sddd2in 
   WHERE sddd2in.Digital_Config_Code = 19
)sddd2 ON sddd2.Syn_Deal_Digital_Code = sdd.Syn_Deal_Digital_Code AND sddd2.Row_Num = sddd1.Row_Num
INNER JOIN (
   SELECT sddd3in.Syn_Deal_Digital_Code, sddd3in.User_Value AS Remarks, sddd3in.Row_Num FROM Syn_Deal_Digital_Detail sddd3in 
   WHERE sddd3in.Digital_Config_Code = 20
)sddd3 ON sddd3.Syn_Deal_Digital_Code = sdd.Syn_Deal_Digital_Code AND sddd3.Row_Num = sddd1.Row_Num