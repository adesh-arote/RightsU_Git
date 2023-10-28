CREATE PROCEDURE [dbo].[USPAuditTrailReportList]
--DECLARE
	@BusinessUnitcode VARCHAR(MAX)='6',	
	@StartDate VARCHAR(MAX)='01/01/2017', 
	@EndDate VARCHAR(MAX)='12/01/2017', 
	@CreatedOrAmended CHAR(1)='A',
	@TitleCode VARCHAR(MAX)='',
	@VendorCode VARCHAR(MAX)='',  
	@UserCode VARCHAR(MAX)='' ,
	@ModuleCode INT=30
AS
/*=============================================  
Author:	Akshay Kamath
Create DATE: 07 Feb 2019
Description: 
=============================================*/
BEGIN
	Declare @Loglevel int
	select @Loglevel = Parameter_Value from System_Parameter_New where Parameter_Name='loglevel'
	if(@Loglevel< 2)Exec [USPLogSQLSteps] '[USPAuditTrailReportList]', 'Step 1', 0, 'Started Procedure', 0, ''
     
		 IF(@ModuleCode='30')
		  BEGIN  
			 select AgreementNo,BusinessUnitName,TitleName,VendorName,AgreementDate,DealCreationDate,DealAmendedDate,SendforApprovalDate,ApprovedDate
				,(select TOP 1 U1.First_Name from Users U1 (NOLOCK)  Where U1.Users_Code = [CreatedBy]) AS CreatedBy
				,(select TOP 1 U1.First_Name from Users U1 (NOLOCK)  Where U1.Users_Code = [AmendedBy]) AS AmendedBy
				,(select TOP 1 U1.First_Name from Users U1 (NOLOCK)  Where U1.Users_Code = [SendforApprovalBy]) AS SendforApprovalBy
				,(select TOP 1 U1.First_Name from Users U1 (NOLOCK)  Where U1.Users_Code = [ApprovedBy]) AS ApprovedBy
			 from
				 (select DISTINCT AD.Agreement_No 'AgreementNo', BU.Business_Unit_Name 'BusinessUnitName', T.Title_Name 'TitleName', V.Vendor_Name 'VendorName', AD.Agreement_Date 'AgreementDate', 
				 (select TOp 1 MSH1.Status_Changed_On from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'C' Order by Module_Status_Code) DealCreationDate , 
				 (select TOp 1 MSH1.Status_Changed_On from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'AM' Order by Module_Status_Code desc) DealAmendedDate,
				 (select TOp 1 MSH1.Status_Changed_On from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'W' Order by Module_Status_Code desc) SendforApprovalDate,
				 (select TOp 1 MSH1.Status_Changed_On from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'A' Order by Module_Status_Code desc) ApprovedDate, 
				 (AD.Inserted_By) CreatedBy,																										 
				 (select TOp 1 MSH1.Status_Changed_By from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'W' Order by Module_Status_Code desc) SendforApprovalBy,
				 (select TOp 1 MSH1.Status_Changed_By from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'AM' Order by Module_Status_Code desc) AmendedBy,
				 (select TOp 1 MSH1.Status_Changed_By from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'A' Order by Module_Status_Code desc) ApprovedBy
			 from Acq_Deal AD (NOLOCK)  
			 INNER JOIN Vendor V (NOLOCK)  ON V.Vendor_Code = AD.Vendor_Code
			 INNER JOIN Business_Unit BU (NOLOCK)  ON AD.Business_Unit_Code = BU.Business_Unit_Code
			 INNER JOIN Acq_Deal_Movie ADM  (NOLOCK) ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
			 INNER JOIN Title T  (NOLOCK) ON T.Title_Code = ADM.Title_Code
			 INNER JOIN Users U (NOLOCK)  ON U.Users_Code = AD.Inserted_By
			 INNER JOIN Module_Status_History MSH (NOLOCK)  ON MSH.Record_Code = AD.Acq_Deal_Code AND MSH.Module_Code= @ModuleCode--30
			 where (@TitleCode='' OR (ADM.Title_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@TitleCode, ',')))) 
			 --(T.Title_Name like '%' + @titleName+ '%' ) 		  	
				AND (@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
				AND (@UserCode='' OR (AD.Inserted_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
				AND (@VendorCode='' OR (AD.Vendor_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@VendorCode,','))))
				AND ((MSH.Status = 'AM' AND MSH.Status_Changed_On >= Convert(DateTime,@StartDate,101) AND MSH.Status_Changed_On <= Convert(DateTime,@EndDate,101) AND @CreatedOrAmended='A')
			   OR (AD.Inserted_On >= Convert(DateTime,@StartDate,101) AND AD.Inserted_On <= Convert(DateTime,@EndDate,101) AND @CreatedOrAmended='C')
				)) 	AS A 
			 ORDER BY DealCreationDate
		  END
	--GO

	--Syndication Data Dump
		IF(@ModuleCode='35')
		BEGIN  
			select AgreementNo,BusinessUnitName,TitleName,VendorName,AgreementDate,DealCreationDate,DealAmendedDate,SendforApprovalDate,ApprovedDate,
				(select TOP 1 U1.First_Name from Users U1 (NOLOCK)  Where U1.Users_Code = [CreatedBy]) AS CreatedBy,
				(select TOP 1 U1.First_Name from Users U1 (NOLOCK)  Where U1.Users_Code = [AmendedBy]) AS AmendedBy,
				(select TOP 1 U1.First_Name from Users U1 (NOLOCK)  Where U1.Users_Code = [SendforApprovalBy]) AS SendforApprovalBy,
				(select TOP 1 U1.First_Name from Users U1 (NOLOCK)  Where U1.Users_Code = [ApprovedBy]) AS ApprovedBy
			from
			(
				SELECT DISTINCT AD.Agreement_No 'AgreementNo', BU.Business_Unit_Name 'BusinessUnitName', T.Title_Name 'TitleName', V.Vendor_Name 'VendorName', AD.Agreement_Date 'AgreementDate' , 
					(SELECT TOP 1 MSH1.Status_Changed_On from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'C' Order by Module_Status_Code) DealCreationDate  , 
					(SELECT TOP 1 MSH1.Status_Changed_On from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'AM' Order by Module_Status_Code desc) DealAmendedDate,
					(SELECT TOP 1 MSH1.Status_Changed_On from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'W' Order by Module_Status_Code desc) SendforApprovalDate,
					(SELECT TOP 1 MSH1.Status_Changed_On from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'A' Order by Module_Status_Code desc) ApprovedDate,  
					(AD.Inserted_By) CreatedBy,																	
					(SELECT TOP 1 MSH1.Status_Changed_By from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'W' Order by Module_Status_Code desc) SendforApprovalBy,
					(SELECT TOP 1 MSH1.Status_Changed_By from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'AM' Order by Module_Status_Code desc) AmendedBy,
					(SELECT TOP 1 MSH1.Status_Changed_By from Module_Status_History MSH1 (NOLOCK)  Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'A' Order by Module_Status_Code desc) ApprovedBy
				from Syn_Deal AD  (NOLOCK) 
				INNER JOIN Vendor V  (NOLOCK) ON V.Vendor_Code = AD.Vendor_Code
				INNER JOIN Business_Unit BU (NOLOCK)  ON AD.Business_Unit_Code = BU.Business_Unit_Code
				INNER JOIN Syn_Deal_Movie ADM (NOLOCK)  ON AD.Syn_Deal_Code = ADM.Syn_Deal_Code
				INNER JOIN Title T  (NOLOCK) ON T.Title_Code = ADM.Title_Code
				INNER JOIN Users U  (NOLOCK) ON U.Users_Code = AD.Inserted_By
				INNER JOIN Module_Status_History MSH (NOLOCK)  ON MSH.Record_Code = AD.Syn_Deal_Code AND MSH.Module_Code= @ModuleCode--35
				where  (@TitleCode='' OR (ADM.Title_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@TitleCode, ',')))) 
					--(T.Title_Name like '%' + @titleName+ '%' ) 		  		
					AND (@BusinessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@BusinessUnitcode, ',')))) 
					AND (@UserCode='' OR (AD.Inserted_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@UserCode, ',')))) 
					AND (@VendorCode='' OR (AD.Vendor_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@VendorCode,','))))
					AND ((MSH.Status = 'AM' AND MSH.Status_Changed_On >= Convert(DateTime,@StartDate,101) AND MSH.Status_Changed_On <= Convert(DateTime,@EndDate,101) AND @CreatedOrAmended='A')
					OR (AD.Inserted_On >= Convert(DateTime,@StartDate,101) AND AD.Inserted_On <= Convert(DateTime,@EndDate,101) AND @CreatedOrAmended='C'))
			 ) AS A
			 ORDER BY DealCreationDate
		   END 
	  
	if(@Loglevel< 2) Exec [USPLogSQLSteps] '[USPAuditTrailReportList]', 'Step 2', 0, 'Procedure Excution Completed', 0, ''
END
