CREATE VIEW [dbo].[vwBookingSheetData_LS]
AS
SELECT Distinct bsd.Title_Content_Code, bsd.AL_Booking_Sheet_Code,bsd.Columns_Value , ec.Columns_name, ec.Columns_Code
FROM AL_Booking_Sheet_Details bsd
INNER JOIN Extended_Columns ec ON ec.Columns_Code = bsd.Columns_Code 
WHERE bsd.Columns_Code IN (select CAST(number AS INT) FROM DBO.fn_Split_withdelemiter((Select Parameter_Value from System_Parameter_New where Parameter_Name = 'AL_BookingSheetsColumnsForLoadSheet'), ','))
--bsd.Columns_Code (Select Parameter_Value from System_Parameter_New Where Parameter_Name  = 'AL_BookingSheetsColumnsForLoadSheet')
--,',')))
--WHERE bsd.Columns_Code IN (
--59
--,224
--,60
--,61
--,63
--,64
--,31
--,66
--,67
--,86
--,68
--,78
--,79
--,80
--,81
--,87
--,92
--,226
--,71
--,47
--,82
--,204
--,70
--,205
--,214
--,227,
--70
--)