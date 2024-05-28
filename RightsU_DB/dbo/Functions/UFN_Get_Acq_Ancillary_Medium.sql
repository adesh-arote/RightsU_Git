CREATE Function [UFN_Get_Acq_Ancillary_Medium]
(
	@Acq_DealAncillary_PlatformCode INT
)
RETURNS varchar(max)       
AS      
BEGIN       
Declare @MediumName Varchar(1000)
SET @MediumName = ''
Select @MediumName = Stuff ((Select Distinct ', '+ISNULL(AM.Ancillary_Medium_Name,'') from Acq_Deal_Ancillary_Platform_Medium ADAPM
Inner Join Acq_Deal_Ancillary_Platform ADAP On ADAPM.Acq_Deal_Ancillary_Platform_Code=ADAP.Acq_Deal_Ancillary_Platform_Code
Inner join Ancillary_Platform_Medium APM ON ADAPM.Ancillary_Platform_Medium_Code = APM.Ancillary_Platform_Medium_Code
INNER JOIN Ancillary_Medium AM ON APM.Ancillary_Medium_Code = AM.Ancillary_Medium_Code 
Where ADAPM.Acq_Deal_Ancillary_Platform_Code= @Acq_DealAncillary_PlatformCode                   
FOR XML PATH(''))                   
, 1, 1, '')                    
RETURN @MediumName                       

END      

/*
Select  dbo.UFN_GetAncillary_Medium_Name (16)
*/