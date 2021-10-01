SELECT * FROM title_Objection_Status
SELECT * FROM title_Objection_Type
SELECT * FROM title_Objection_Territory
SELECT * FROM title_Objection_Platform
SELECT * FROM title_Objection_Rights_Period
SELECT * FROM Title_Objection

DELETE FROM Title_Objection
DELETE FROM title_Objection_Type

DBCC CHECKIDENT ('Title_Objection', RESEED, 0)



 --SELECT * FROM title_Objection_Status
 --select * from system_parameter_new where Parameter_Name like '%rpt%'


 SELECT DISTINCT ADRP.Platform_Code 
 FROM Acq_Deal_Rights ADR
 INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = ADR.Acq_Deal_Code
 INNER JOIN acq_Deal_rights_platform ADRP ON ADRP.Acq_Deal_Rights_Code = ADR.Acq_Deal_Rights_Code
 WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND 
 ADR.Acq_Deal_Code = 21738 AND ADM.Title_Code = 36672

 SELECT DISTINCT ADRT.Territory_Type, ADRT.Country_Code, ADRT.Territory_Code FROM Acq_Deal_Rights_Territory ADRT
 INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
 INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = ADR.Acq_Deal_Code
 WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND 
 ADR.Acq_Deal_Code = 21738 AND ADM.Title_Code = 36672


 SELECT DISTINCT ADR.Actual_Right_Start_Date, adr.Actual_Right_End_Date
 FROM Acq_Deal_Rights ADR
 INNER JOIN Acq_Deal_Movie ADM ON ADM.Acq_Deal_Code = ADR.Acq_Deal_Code
 WHERE  ADR.Actual_Right_End_Date >= GETDATE() AND 
 ADR.Acq_Deal_Code = 21738 AND ADM.Title_Code = 36672
 order by 1,2

select * from Acq_Deal where Agreement_No =  'A-2021-00072'
select * from Title where Title_Name =  'Title Objection Part 1'




