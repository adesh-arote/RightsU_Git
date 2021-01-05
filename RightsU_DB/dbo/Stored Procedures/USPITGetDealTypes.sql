CREATE PROCEDURE USPITGetDealTypes
@BusinessVerticalCodes VARCHAR(30)
AS
BEGIN
SELECT DISTINCT DT.Deal_Type_Code, DT.Deal_Type_Name FROM deal_type DT
INNER JOIN attrib_deal_type ADT
ON ADT.deal_type_code = DT.deal_type_code
WHERE ADT.attrib_group_code IN (SELECT number FROM dbo.fn_Split_withdelemiter(ISNULL(@BusinessVerticalCodes, ''), ',') WHERE number <> '')
END
