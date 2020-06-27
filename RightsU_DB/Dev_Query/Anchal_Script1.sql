--exec USP_Content_Channel_Run_Data_Generation


--exec USP_BMS_Deal_Data_Generation

select distinct Title_Content_Code,Acq_Deal_Code,Acq_Deal_Run_Code,Rights_Start_Date,Rights_End_Date,Channel_Code,Right_Rule_Code,Defined_Runs
 from Content_Channel_Run where  Acq_Deal_Code=13886


select * from Content_Channel_Run where Acq_Deal_Code=13885

select * from Acq_Deal where Agreement_No='A-2017-00253'
select * from Acq_Deal_Run where
Acq_Deal_Code=13885

select * from Acq_Deal_Run_Channel  where
Acq_Deal_Run_Code=11341

select * from Acq_Deal_Run_Yearwise_Run  where
Acq_Deal_Run_Code=11341


delete from Content_Channel_Run where Acq_Deal_Code=13885 AND Content_Channel_Run_Code<=57406
 
select * from Acq_Deal where Agreement_No='A-2017-00237'
select * from Acq_Deal_Run where
Acq_Deal_Code=12869

select * from Acq_Deal_Run_Channel  where
Acq_Deal_Run_Code=11344

select * from Acq_Deal_Run_Yearwise_Run  where
Acq_Deal_Run_Code=11344

select * from Content_Channel_Run where Acq_Deal_Code=12869
select * from Acq_Deal_Rights where
Acq_Deal_Code=12869

select * from Acq_Deal_Rights_Title where Acq_Deal_Rights_Code=22623

select * from Title_Content where Title_Code= 26040

select * from BMS_Process_Deals  where Acq_Deal_Code=12869

select * from Acq_Deal where Agreement_No='A-2017-00255'
select * from Acq_Deal_Run where
Acq_Deal_Code=13887

select * from Acq_Deal_Run_Channel  where
Acq_Deal_Run_Code=11345

select * from Acq_Deal_Run_Yearwise_Run  where
Acq_Deal_Run_Code=11345

--Update Content_Channel_Run SET Is_Archive='N' where Acq_Deal_Code=13888

select * from BMS_Process_Deals  where Acq_Deal_Code=13887

--delete from Content_Channel_Run where  Acq_Deal_Code=13887 AND Content_Channel_Run_Code <= 59474
select * from Acq_Deal_Run where
Acq_Deal_Code=13888

select * from Acq_Deal_Run_Channel  where
Acq_Deal_Run_Code=11346

select * from Acq_Deal_Run_Yearwise_Run  where
Acq_Deal_Run_Code=11346


select * from Acq_Deal where Agreement_No='A-2017-00256'

select * from Acq_Deal where Agreement_No='A-2017-00261'
select * from Content_Channel_Run where
Acq_Deal_Code=13896

select * from Acq_Deal_Run_Channel  where
Acq_Deal_Run_Code=11354

select * from Acq_Deal_Run_Yearwise_Run  where
Acq_Deal_Run_Code=11354
select * from Content_Channel_Run where Acq_Deal_Code=13896 AND Is_Archive='N'
select * from Content_Channel_Run where Acq_Deal_Code=13896 AND Is_Archive='Y'
select DISTINCT Title_Content_Code from Content_Channel_Run where Acq_Deal_Code=13896 AND Is_Archive='N'

--delete from Content_Channel_Run where Acq_Deal_Code=13886
--Update Content_Channel_Run SET Is_Archive='N' where Acq_Deal_Code=13888

select ROUND(20/3,0)

select * from Acq_Deal where Agreement_No='A-2017-00265'
select * from Acq_Deal_Run where Acq_Deal_Code=13901
select * from Content_Channel_Run where Acq_Deal_Code=13901

select * from Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code=11357

select * from Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code=11357

select * from Content_Channel_Run where Acq_Deal_Code=13901 AND Is_Archive='N'
select DISTINCT Title_Content_Code from Content_Channel_Run where Acq_Deal_Code=13901 AND Is_Archive='N'

select * from Provisional_Deal


select * from Acq_Deal where Agreement_No='A-2017-00268'
select * from Acq_Deal_Run where Acq_Deal_Code=13904
select * from Content_Channel_Run where Acq_Deal_Code=13904

select * from Acq_Deal_Run_Channel WHERE Acq_Deal_Run_Code=11360
select * from Acq_Deal_Run_Yearwise_Run WHERE Acq_Deal_Run_Code=11360

select * from Provisional_Deal where Agreement_No='P-2017-00008'
select * from Provisional_Deal_Title where Provisional_Deal_Code=8
select * from Provisional_Deal_Run where Provisional_Deal_Title_Code=11
select * from Provisional_Deal_Run_Channel where Provisional_Deal_Run_Code IN(8,10)


select * from Content_Channel_Run where Provisional_Deal_Code=8
select * from Provisional_Deal where Agreement_No='P-2017-00010'
select * from Provisional_Deal_Title where Provisional_Deal_Code=10
select * from Provisional_Deal_Run where Provisional_Deal_Title_Code=12
select * from Provisional_Deal_Run_Channel where Provisional_Deal_Run_Code=9

select * from Content_Channel_Run where Provisional_Deal_Code=10

select * from Content_Channel_Run where Provisional_Deal_Code=11
select * from Provisional_Deal where Agreement_No='P-2017-00011'
select * from Provisional_Deal_Title where Provisional_Deal_Code=11
select * from Provisional_Deal_Run where Provisional_Deal_Title_Code=13
select * from Provisional_Deal_Run_Channel where Provisional_Deal_Run_Code=9


select * from Content_Channel_Run where Provisional_Deal_Code=12
select * from Provisional_Deal where Agreement_No='P-2017-00012'
select * from Provisional_Deal_Title where Provisional_Deal_Code=12
select * from Provisional_Deal_Run where Provisional_Deal_Title_Code=14
select * from Provisional_Deal_Run_Channel where Provisional_Deal_Run_Code in(11,12)

select * from Content_Channel_Run CCR 
LEFT JOIN Provisional_Deal PD ON PD.Provisional_Deal_Code = CCR.Provisional_Deal_Code
LEFT JOIN Provisional_Deal_Run PDR ON PDR.Provisional_Deal_Run_Code = CCR.Provisional_Deal_Run_Code
LEFT JOIN Provisional_Deal_Title PDT ON PDT.Provisional_Deal_Code=PD.Provisional_Deal_Code
LEFT JOIN Provisional_Deal_Run_Channel PDRC ON PDRC.Provisional_Deal_Run_Code = PDR.Provisional_Deal_Run_Code
where  CCR.Provisional_Deal_Code=12 AND (PDRC.Provisional_Deal_Run_Channel_Code IS NULL OR PDR.Provisional_Deal_Run_Code IS NULL
OR PDT.Provisional_Deal_Title_Code IS NULL
)

select * from Channel where Channel_Name='AXN INDIA'
select * from Channel where Channel_Name='SET INDIA'