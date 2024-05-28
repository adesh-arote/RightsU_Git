select * from title order by 1 desc

select T.Title_Code, MIN(TR.Release_Date) AS Release_Date into #TitleRelease from Title_Release TR
INNER JOIN Title T ON T.Title_Code = TR.Title_Code
GROUP BY  T.Title_Code

SELECT * FROM TITLE WHERE TITLE_cODE = 38559

SELECT ADR.Actual_Right_Start_Date, ADR.Actual_Right_End_Date, ADR.Right_Type, ADRT.*,
TR.Release_Date,  DATEADD(DAY,-1, (DATEADD(year, 60, CONVERT(date,DATEADD(YEAR,DATEDIFF(YEAR,0,DATEADD(year, 1, TR.Release_Date)),0))))) FROM Acq_Deal_Rights_Title ADRT
--UPDATE ADR SET 
--ADR.Actual_Right_End_Date = DATEADD(DAY,-1, (DATEADD(year, 60, CONVERT(date,DATEADD(YEAR,DATEDIFF(YEAR,0,DATEADD(year, 1, TR.Release_Date)),0)))))
-- FROM Acq_Deal_Rights_Title ADRT
INNER JOIN #TitleRelease TR ON ADRT.Title_Code = TR.Title_Code
INNER JOIN Acq_Deal_Rights ADR ON ADR.Acq_Deal_Rights_Code = ADRT.Acq_Deal_Rights_Code
WHERE ADR.Right_Type ='U'
 

 select * from System_Parameter_New order by 1 desc

select convert (date,DATEADD(YEAR,DATEDIFF(YEAR,0,DATEADD(year, 1, getdate())),0))