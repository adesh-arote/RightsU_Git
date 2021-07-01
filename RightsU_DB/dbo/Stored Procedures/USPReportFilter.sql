CREATE Procedure USPReportFilter
@BusinessUnitcode NVARCHAR(MAX) = '',
@UserCode NVARCHAR(MAX) = ''
AS
BEGIN
DECLARE @BussinessUnitNames NVARCHAR(MAX),
@UserNames NVARCHAR(MAX)


	
	SET @BussinessUnitNames =ISNULL(STUFF((SELECT DISTINCT ',' + b.Business_Unit_Name      
	FROM Business_Unit b       
	WHERE b.Business_Unit_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@BusinessUnitcode,',') WHERE number NOT IN('0', ''))      
	AND b.Is_Active = 'Y'      
	FOR XML PATH(''), TYPE      
	   ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')  
	IF(@BusinessUnitcode = '')
	BEGIN
		SET @BussinessUnitNames = 'All Business Unit'
	END
	ELSE
	BEGIN
		SET @BussinessUnitNames= Case when @BusinessUnitcode = '' Then 'NA' ELSE @BussinessUnitNames END
		
	END

		SET @UserNames =ISNULL(STUFF((SELECT DISTINCT ', ' + (b.First_Name+' '+b.Last_Name)      
		 FROM Users b       
		 WHERE b.Users_Code IN (SELECT CAST(number AS INT) number FROM dbo.fn_Split_withdelemiter(@UserCode,',') WHERE number NOT IN('0', ''))      
		 AND b.Is_Active = 'Y'      
		 FOR XML PATH(''), TYPE      
		    ).value('.', 'NVARCHAR(MAX)'), 1, 1, ''), '')  
			IF(@UserCode = '')
			BEGIN
				SET @UserNames = 'All Users'
			END
			ELSE
			BEGIN
				SET @UserNames= Case when @UserCode = '' Then 'NA' ELSE @UserNames END
				
			END


			Select @BussinessUnitNames AS BusinessUnit, @UserNames AS Users



END
