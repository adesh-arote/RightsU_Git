CREATE PROCEDURE USPAuditTrailReportList
--DECLARE
	@BusinessUnitcode VARCHAR(MAX)='',
	@DealType VARCHAR(MAX)='',
	@StartDate VARCHAR(MAX)='', 
	@EndDate VARCHAR(MAX)='', 
	@TitleName VARCHAR(MAX)='',
	@VendorCode VARCHAR(MAX)='',  
	@UserName VARCHAR(MAX)='' ,
	@ModuleCode INT
AS
/*=============================================  
Author:	Akshay Kamath
Create DATE: 07 Feb 2019
Description: 
=============================================*/
 BEGIN
     IF(@dealType='A')
      BEGIN  
         select *
            ,(select TOP 1 U1.First_Name from Users U1 Where U1.Users_Code = [CreatedBy]) AS CreatedBy
            ,(select TOP 1 U1.First_Name from Users U1 Where U1.Users_Code = [AmendedBy]) AS AmendedBy
            ,(select TOP 1 U1.First_Name from Users U1 Where U1.Users_Code = [SendforApprovalBy]) AS AmendedBy
	        ,(select TOP 1 U1.First_Name from Users U1 Where U1.Users_Code = [ApprovedBy]) AS ApprovedBy
	     from
	         (select DISTINCT AD.Agreement_No 'AgreementNo', BU.Business_Unit_Name 'BusinessUnitName', T.Title_Name 'TitleName', V.Vendor_Name 'VendorName', AD.Agreement_Date 'AgreementDate', 
	         (select TOp 1 MSH1.Status_Changed_On from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@ModuleCode And MSH1.Status = 'C' Order by Module_Status_Code) DealCreationDate , 
	         (select TOp 1 MSH1.Status_Changed_On from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'AM' Order by Module_Status_Code desc) DealAmendedDate,
	         (select TOp 1 MSH1.Status_Changed_On from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'W' Order by Module_Status_Code desc) SendforApprovalDate,
	         (select TOp 1 MSH1.Status_Changed_On from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'A' Order by Module_Status_Code desc) ApprovedDate, 
	         (AD.Inserted_By) CreatedBy,
	         (select TOp 1 MSH1.Status_Changed_By from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'W' Order by Module_Status_Code desc) SendforApprovalBy,
	         (select TOp 1 MSH1.Status_Changed_By from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'AM' Order by Module_Status_Code desc) AmendedBy,
	         (select TOp 1 MSH1.Status_Changed_By from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Acq_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'A' Order by Module_Status_Code desc) ApprovedBy
	     from Acq_Deal AD 
	     INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
	     INNER JOIN Business_Unit BU ON AD.Business_Unit_Code = BU.Business_Unit_Code
	     INNER JOIN Acq_Deal_Movie ADM ON AD.Acq_Deal_Code = ADM.Acq_Deal_Code
	     INNER JOIN Title T ON T.Title_Code = ADM.Title_Code
	     INNER JOIN Users U ON U.Users_Code = AD.Inserted_By
	     INNER JOIN Module_Status_History MSH ON MSH.Record_Code = AD.Acq_Deal_Code AND MSH.Module_Code= @moduleCode--30
	     where (T.Title_Name like '%' + @titleName+ '%' )  	
	        AND (@businessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@businessUnitcode, ',')))) 
	        AND (@userName='' OR (AD.Inserted_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@userName, ',')))) 
	        AND (@vendorCode='' OR (AD.Vendor_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@vendorCode,','))))
	        AND ((MSH.Status = 'AM' AND MSH.Status_Changed_On >= Convert(DateTime,@startDate,101) AND MSH.Status_Changed_On <= Convert(DateTime,@endDate,101))
	        OR (AD.Inserted_On >= Convert(DateTime,@startDate,101) AND AD.Inserted_On <= Convert(DateTime,@endDate,101)))	
	     ) AS A 
	     ORDER BY DealCreationDate
      END
--GO

--Syndication Data Dump
    IF(@dealType='S')
	BEGIN  
		select *,
			(select TOP 1 U1.First_Name from Users U1 Where U1.Users_Code = [CreatedBy]) AS CreatedBy,
			(select TOP 1 U1.First_Name from Users U1 Where U1.Users_Code = [AmendedBy]) AS AmendedBy,
			(select TOP 1 U1.First_Name from Users U1 Where U1.Users_Code = [SendforApprovalBy]) AS AmendedBy,
			(select TOP 1 U1.First_Name from Users U1 Where U1.Users_Code = [ApprovedBy]) AS ApprovedBy
	    from
		(
			SELECT DISTINCT AD.Agreement_No 'AgreementNo', BU.Business_Unit_Name 'BusinessUnitName', T.Title_Name 'TitleName', V.Vendor_Name 'VendorName', AD.Agreement_Date 'AgreementDate' , 
				(SELECT TOP 1 MSH1.Status_Changed_On from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'C' Order by Module_Status_Code) DealCreationDate  , 
				(SELECT TOP 1 MSH1.Status_Changed_On from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'AM' Order by Module_Status_Code desc) DealAmendedDate,
				(SELECT TOP 1 MSH1.Status_Changed_On from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'W' Order by Module_Status_Code desc) SendforApprovalDate,
				(SELECT TOP 1 MSH1.Status_Changed_On from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'A' Order by Module_Status_Code desc) ApprovedDate,  
				(AD.Inserted_By) CreatedBy,
				(SELECT TOP 1 MSH1.Status_Changed_By from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'W' Order by Module_Status_Code desc) SendforApprovalBy,
				(SELECT TOP 1 MSH1.Status_Changed_By from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'AM' Order by Module_Status_Code desc) AmendedBy,
				(SELECT TOP 1 MSH1.Status_Changed_By from Module_Status_History MSH1 Where MSH1.Record_Code = AD.Syn_Deal_Code And MSH1.Module_Code=@moduleCode And MSH1.Status = 'A' Order by Module_Status_Code desc) ApprovedBy
			from Syn_Deal AD 
			INNER JOIN Vendor V ON V.Vendor_Code = AD.Vendor_Code
			INNER JOIN Business_Unit BU ON AD.Business_Unit_Code = BU.Business_Unit_Code
			INNER JOIN Syn_Deal_Movie ADM ON AD.Syn_Deal_Code = ADM.Syn_Deal_Code
			INNER JOIN Title T ON T.Title_Code = ADM.Title_Code
			INNER JOIN Users U ON U.Users_Code = AD.Inserted_By
			INNER JOIN Module_Status_History MSH ON MSH.Record_Code = AD.Syn_Deal_Code AND MSH.Module_Code= @moduleCode--35
			where (T.Title_Name like '%' + @titleName+ '%' )  	
				AND (@businessUnitcode='' OR (AD.Business_Unit_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@businessUnitcode, ',')))) 
				AND (@userName='' OR (AD.Inserted_By IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@userName, ',')))) 
				AND (@vendorCode='' OR (AD.Vendor_Code IN(SELECT number FROM  dbo.fn_Split_withdelemiter(@vendorCode,','))))
				AND ((MSH.Status = 'AM' AND MSH.Status_Changed_On >= Convert(DateTime,@startDate,101) AND MSH.Status_Changed_On <= Convert(DateTime,@endDate,101))
				OR (AD.Inserted_On >= Convert(DateTime,@startDate,101) AND AD.Inserted_On <= Convert(DateTime,@endDate,101)))
	     ) AS A
	     ORDER BY DealCreationDate
       END 
 END

