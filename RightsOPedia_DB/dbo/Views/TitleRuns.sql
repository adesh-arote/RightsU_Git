



CREATE VIEW [dbo].[TitleRuns]
AS
SELECT DISTINCT ad.Acq_Deal_Code, adr.Acq_Deal_Run_Code, adrt.Title_Code, adrt.Episode_From, adrt.Episode_To, adr.Run_Type, adr.No_Of_Runs, c.Channel_Name, adrc.Min_Runs
FROM RightsU_Plus_Testing.dbo.Acq_Deal ad
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Run adr ON ad.Acq_Deal_Code = adr.Acq_Deal_Code
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Run_Title adrt ON adr.Acq_Deal_Run_Code = adrt.Acq_Deal_Run_Code
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Movie adrm ON adr.Acq_Deal_Code = adrm.Acq_Deal_Code AND adrm.Title_Code = adrt.Title_Code AND adrm.Episode_Starts_From = adrt.Episode_From AND adrm.Episode_End_To = adrt.Episode_To
INNER JOIN RightsU_Plus_Testing.dbo.Acq_Deal_Run_Channel adrc ON adr.Acq_Deal_Run_Code = adrc.Acq_Deal_Run_Code
INNER JOIN RightsU_Plus_Testing.dbo.Channel c ON adrc.Channel_Code = c.Channel_Code




