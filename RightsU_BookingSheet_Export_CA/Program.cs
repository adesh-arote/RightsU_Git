using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Configuration;
using System.Data.SqlClient;
using System.Data;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using Microsoft.Office.Interop.Excel;
using Microsoft.Win32;
using System.Net.Http;
using System.Net;
using System.Net.Http.Headers;
using System.IO;
using System.Drawing;
using System.Data.OleDb;
using System.Reflection;
using System.Dynamic;

namespace RightsU_BookingSheet_Export_CA
{
    class Program
    {
        static void Main(string[] args)
        {
            GenerateDataforPendingBookingSheet();
            GenerateExcelSheetforPendingBookingSheet();
            UploadBookingSheet();
            ValidateAndUpdateBookingSheet();
        }

        public static void GenerateDataforPendingBookingSheet()
        {
            int BookingSheetCode = 0;
            int RecommandationCode = 0;

            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);

            try
            {
                sqlConnection.Open();
                string query = "SELECT * FROM AL_Booking_Sheet WHERE Record_Status = 'P' ";
                SqlCommand cmd = new SqlCommand(query, sqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();
                var dt = new System.Data.DataTable();

                if (!dr.IsClosed)
                {
                    dt.Load(dr);
                    dr.Close();
                }
                else
                {
                    dr.Close();
                }

                for (int i = 0; i <= dt.Rows.Count - 1; i++)
                {
                    BookingSheetCode = Convert.ToInt32(dt.Rows[i][0]);
                    RecommandationCode = Convert.ToInt32(dt.Rows[i][1]);

                    SqlCommand cmdSP = new SqlCommand(query, sqlConnection);
                    cmdSP.CommandText = "USPAL_Gen_BookingSheet_Data";
                    cmdSP.Connection = sqlConnection;
                    cmdSP.CommandType = CommandType.StoredProcedure;
                    SqlParameter param = new SqlParameter
                    {
                        ParameterName = "@BookingSheetCode",
                        SqlDbType = System.Data.SqlDbType.Int,
                        Value = BookingSheetCode,
                        Direction = ParameterDirection.Input
                    };

                    cmdSP.Parameters.Add(param);
                    cmdSP.ExecuteReader();

                }

            }
            catch (Exception e)
            {
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection.Close();
            }
        }
        public static void GenerateExcelSheetforPendingBookingSheet()
        {

            string ConnString1 = "";
            ConnString1 = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection1 = new SqlConnection(ConnString1);

            char Display_For_Val = 'B';
            DataSet dsManFields = new DataSet();

            try
            {
                sqlConnection1.Open();

                string query = "SELECT * FROM AL_Booking_Sheet WHERE Record_Status = 'I' ";
                //string query = "SELECT * FROM AL_Booking_Sheet WHERE AL_Booking_Sheet_Code = 3198";
                SqlCommand cmd = new SqlCommand(query, sqlConnection1);
                SqlDataReader dr = cmd.ExecuteReader();
                System.Data.DataTable dt = new System.Data.DataTable();

                if (!dr.IsClosed)
                {
                    dt.Load(dr);
                    dr.Close();
                }
                else
                {
                    dr.Close();
                }

                for (int p = 0; p <= dt.Rows.Count - 1; p++)
                {
                    int BookingSheetCode = 0;
                    int RecommandationCode = 0;

                    BookingSheetCode = Convert.ToInt32(dt.Rows[p][0]);
                    RecommandationCode = Convert.ToInt32(dt.Rows[p][1]);

                    DataSet ds1 = new DataSet();
                    
                    System.Data.DataTable dt1 = new System.Data.DataTable();
                    dt1.Clear();
                    dt1.Columns.Add("DisplayFor", typeof(char));
                    dt1.Columns.Add("DisplayName", typeof(string));
                    
                    DataRow row = dt1.NewRow();
                    row["DisplayFor"] = 'M';
                    row["DisplayName"] = "Movies";
                    dt1.Rows.Add(row);

                    DataRow row1 = dt1.NewRow();
                    row1["DisplayFor"] = 'S';
                    row1["DisplayName"] = "TV Shows";
                    dt1.Rows.Add(row1);

                    for (int i = 0; i <= dt1.Rows.Count - 1; i++)
                    {
                        char DisplayFor = 'B';
                        int BookingCode = 0;
                        string DataTableName = "";

                        BookingCode = Convert.ToInt32(BookingSheetCode);
                        DisplayFor = Convert.ToChar(dt1.Rows[i][0]);
                        DataTableName = Convert.ToString(dt1.Rows[i][1]);

                        Display_For_Val = DisplayFor;

                        SqlCommand cmdSP1 = new SqlCommand(query, sqlConnection1);
                        cmdSP1.CommandText = "USPAL_GetBookingSheetData";
                        cmdSP1.Connection = sqlConnection1;
                        cmdSP1.CommandType = CommandType.StoredProcedure;
                        SqlParameter param1 = new SqlParameter
                        {
                            ParameterName = "@BookingSheetCode",
                            SqlDbType = System.Data.SqlDbType.Int,
                            Value = BookingCode,
                            Direction = ParameterDirection.Input
                        };
                        SqlParameter param2 = new SqlParameter
                        {
                            ParameterName = "@Display_For",
                            SqlDbType = System.Data.SqlDbType.Char,
                            Value = DisplayFor,
                            Direction = ParameterDirection.Input
                        };

                        cmdSP1.Parameters.Add(param1);
                        cmdSP1.Parameters.Add(param2);
                        SqlDataReader rdBookSheet = cmdSP1.ExecuteReader();
                        System.Data.DataTable BookSheet = new System.Data.DataTable(DataTableName);

                        if (!rdBookSheet.IsClosed)
                        {
                            BookSheet.Load(rdBookSheet);
                            ds1.Tables.Add(BookSheet);
                            rdBookSheet.Close();
                        }
                        else
                        {
                            rdBookSheet.Close();
                        }

                        System.Data.DataTable dtMand = new System.Data.DataTable(DataTableName);
                        dtMand = GetMandatoryFieldNames(BookingSheetCode, Display_For_Val);
                        dsManFields.Tables.Add(dtMand);
                    }
                    #region Add Revision History 
                    var dtRevHist = GetRevisionHistoryDetails(BookingSheetCode);
                    if(dtRevHist!=null)
                    {
                        ds1.Tables.Add(dtRevHist);
                    }
                    #endregion
                    #region Export to excel logic
                    ExportToExcel(ds1, dsManFields, BookingSheetCode, out string BookingSheetName);
                    UpdateBookingSheetRecord(BookingSheetCode, BookingSheetName);
                    #endregion
                }

            }
            catch (Exception e)
            {
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection1.Close();
            }

        }
        public static void UploadBookingSheet()
        {
            int DMMasterImportCode = 0;
            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);

            try
            {
                sqlConnection.Open();

                string query = "SELECT * FROM DM_Master_Import WHERE Status IN ('N','P') AND File_Type= 'B' AND Record_Code IS NOT NULL";
                //string query = "SELECT * FROM DM_Master_Import WHERE DM_Master_Import_Code = 2530";
                SqlCommand cmd = new SqlCommand(query, sqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();
                System.Data.DataTable dt = new System.Data.DataTable();
                //DataSet ds = new DataSet();
                System.Data.DataTable dtMovie = new System.Data.DataTable();                

                if (!dr.IsClosed)
                {
                    dt.Load(dr);
                    dr.Close();
                }
                else
                {
                    dr.Close();
                }

                for (int i = 0; i <= dt.Rows.Count - 1; i++)
                {
                    string InputFile = "";
                    string sheetName = "Movies$";
                    string sheetNameShow = "TV Shows$";
                    string fullpathname = "";
                    int DM_Master_Import_Code = 0;
                    string Sheet_Name = "";

                    DMMasterImportCode = Convert.ToInt32(dt.Rows[i][0]);
                    DM_Master_Import_Code = Convert.ToInt32(dt.Rows[i][0]);
                    InputFile = Convert.ToString(dt.Rows[i][2]);
                    fullpathname = ConfigurationManager.AppSettings["ImportFilePath"] + InputFile;
                    //fullpathname = @"C:\Users\sandipc\Desktop\Test\638204396307652160~Result_BS_No_1123 (1).xlsx";
                    try
                    {
                        OleDbConnection cn = new OleDbConnection();
                        cn = new OleDbConnection("Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + fullpathname + ";Extended Properties='Excel 12.0;HDR=No;IMEX=1'");
                        OleDbCommand cmdExcel = new OleDbCommand();
                        OleDbDataAdapter oda = new OleDbDataAdapter();
                        cmdExcel.Connection = cn;

                        System.Data.DataTable dt1 = new System.Data.DataTable();
                        dt1.Clear();
                        dt1.Columns.Add("DisplayFor", typeof(char));
                        dt1.Columns.Add("DisplayName", typeof(string));

                        DataRow row1 = dt1.NewRow();
                        row1["DisplayFor"] = 'M';
                        row1["DisplayName"] = "Movies";
                        dt1.Rows.Add(row1);

                        DataRow row2 = dt1.NewRow();
                        row2["DisplayFor"] = 'S';
                        row2["DisplayName"] = "TV Shows";
                        dt1.Rows.Add(row2);                        

                        for (int m = 0; m <= dt1.Rows.Count - 1; m++)
                        {
                            DataSet ds = new DataSet();
                            string DisplayFor = "";
                            DisplayFor = Convert.ToString(dt1.Rows[m][1]);
                            sheetName = DisplayFor + "$";
                            Sheet_Name = DisplayFor;
                            ds.Clear();
                            OleDbDataAdapter da = new OleDbDataAdapter("Select * From [" + sheetName + "] WHERE [F1] <> '' OR [F1] IS NOT NULL", cn);
                            da.Fill(ds);

                            if (ds.Tables.Count > 0)
                            {
                                if (ds.Tables[0].Rows.Count > 1)
                                {
                                    DataColumnCollection columns = ds.Tables[0].Columns;
                                    if (!columns.Contains("DataType"))
                                    {
                                        ds.Tables[0].Columns.Add("DataType", typeof(string)).SetOrdinal(0);
                                    }

                                    int Cnt = 0;
                                    foreach (DataRow drInn in ds.Tables[0].Rows) 
                                    {
                                        if(Cnt==0)
                                            drInn[0] = "H";
                                        else
                                            drInn[0] = "D";
                                        Cnt++;
                                    }
                                    
                                    List<Booking_Sheet_Import_Utility_UDT> lst_Booking_Sheet_Import_Utility_UDT = new List<Booking_Sheet_Import_Utility_UDT>();
                                    Booking_Sheet_Import_Utility_UDT obj_Booking_Sheet_Import_Utility_UDT = new Booking_Sheet_Import_Utility_UDT();

                                    //#region Header Validation
                                    
                                    int HRCount = 0;
                                    Type type = typeof(Booking_Sheet_Import_Utility_UDT);
                                    PropertyInfo[] properties = type.GetProperties();                                    

                                    lst_Booking_Sheet_Import_Utility_UDT = new List<Booking_Sheet_Import_Utility_UDT>();
                                    foreach (DataRow row in ds.Tables[0].Rows)
                                    {
                                        HRCount = 0;
                                        obj_Booking_Sheet_Import_Utility_UDT = new Booking_Sheet_Import_Utility_UDT();
                                        foreach (PropertyInfo property in properties)
                                        {
                                            if (HRCount == row.ItemArray.Count())
                                                break;
                                            if (row.ItemArray.ElementAt(HRCount) is DBNull)
                                                property.SetValue(obj_Booking_Sheet_Import_Utility_UDT, "");
                                            else
                                                property.SetValue(obj_Booking_Sheet_Import_Utility_UDT, row.ItemArray.ElementAt(HRCount));
                                            HRCount++;
                                        }
                                        lst_Booking_Sheet_Import_Utility_UDT.Add(obj_Booking_Sheet_Import_Utility_UDT);
                                    }

                                    string SheetName = "";
                                    if (Sheet_Name == "Movies")
                                    {
                                        SheetName = "Movie";
                                    }
                                    else if (Sheet_Name == "TV Shows")
                                    {
                                        SheetName = "Show";
                                    }

                                    InsertBookingSheetUDTData(lst_Booking_Sheet_Import_Utility_UDT, DM_Master_Import_Code, SheetName);

                                    //#endregion
                                }
                                else
                                {
                                    
                                }
                            }
                        }

                    }
                    catch (Exception e)
                    {
                        UpdateDMBookingSheetRecord(DMMasterImportCode);
                        LogWrite(e.Message.ToString());
                    }
                }

            }
            catch (Exception e)
            {
                UpdateDMBookingSheetRecord(DMMasterImportCode);
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection.Close();
            }
        }
        public static void ValidateAndUpdateBookingSheet()
        {
            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);

            try
            {
                sqlConnection.Open();

                string query = "SELECT * FROM DM_Master_Import WHERE Status IN ('N','P') AND File_Type= 'B' AND Record_Code IS NOT NULL";
                SqlCommand cmd = new SqlCommand(query, sqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();
                System.Data.DataTable dt = new System.Data.DataTable();
                DataSet ds = new DataSet();
                System.Data.DataTable dtMovie = new System.Data.DataTable();

                if (!dr.IsClosed)
                {
                    dt.Load(dr);
                    dr.Close();
                }
                else
                {
                    dr.Close();
                }

                for (int i = 0; i <= dt.Rows.Count - 1; i++)
                {                   
                    int DM_Master_Import_Code = 0;

                    DM_Master_Import_Code = Convert.ToInt32(dt.Rows[i][0]);

                    try
                    {
                        ValidateAndUpdateBookingSheetMovie(DM_Master_Import_Code);
                        ValidateAndUpdateBookingSheetShow(DM_Master_Import_Code);
                    }
                    catch (Exception e)
                    {
                        UpdateDMBookingSheetRecord(DM_Master_Import_Code);
                        LogWrite(e.Message.ToString());
                    }
                }

            }
            catch (Exception e)
            {
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection.Close();
            }
        }
        public static void ExportToExcel(System.Data.DataSet ds, System.Data.DataSet dsManFields, int BookingSheetCode, out string BookingSheetName)
        {
            string Bookingsheet_Name = "";
            Bookingsheet_Name = GetBookingsheetName(BookingSheetCode);

            var file = new FileInfo(ConfigurationManager.AppSettings["UploadFilePath"]+"Sample.xlsx");
            string Destination = ConfigurationManager.AppSettings["UploadFilePath"]+ Bookingsheet_Name;
            FileInfo newFile = new FileInfo(Destination);
            string Name = newFile.Name.ToString();
            if (newFile.Exists)
            {
                newFile.Delete(); 
            }

            using (ExcelPackage excel = new ExcelPackage(file))
            {
                if (ds != null && ds.Tables.Count > 0)
                {
                    for (int i = 0; i <= ds.Tables.Count - 1; i++)
                    {
                        if (i == 0)
                        {
                            ExcelWorksheet sheet = excel.Workbook.Worksheets["Sheet1"];
                            sheet.Name = ds.Tables[i].TableName;                            
                            if (ds.Tables[i].Rows.Count > 0)
                            {
                                sheet.Cells.LoadFromDataTable(ds.Tables[i], true);
                                for (int j = 1; j <= ds.Tables[i].Columns.Count; j++)
                                {
                                    sheet.DefaultColWidth = 40;
                                    Color colRed = System.Drawing.ColorTranslator.FromHtml("#F73131");
                                    Color colOrange = System.Drawing.ColorTranslator.FromHtml("#E35335");
                                    Color colGreen = System.Drawing.ColorTranslator.FromHtml("#8FD64B");
                                    Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                                    sheet.Cells[1, j].Style.Font.Bold = true;
                                    sheet.Cells[1, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                                    sheet.Cells[1, j].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                                    sheet.Cells[1, j].Style.Font.Size = 11;
                                    sheet.Cells[1, j].Style.Font.Name = "Calibri";
                                    sheet.Cells[1, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                    //sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colFromHex);                                    
                                    sheet.Cells[1, j].Style.WrapText = true;
                                    sheet.Cells[1, j].AutoFitColumns();

                                    if (dsManFields != null && dsManFields.Tables.Count > 0)
                                    {
                                        for (int m = 0; m < dsManFields.Tables[i].Rows.Count; m++)
                                        {
                                            string ValidationValue = Convert.ToString(dsManFields.Tables[i].Rows[m][0]);
                                            string HeaderValue = Convert.ToString(dsManFields.Tables[i].Rows[m][1]);
                                            //dsTable Header
                                            string dsTableheaderVal = Convert.ToString(sheet.Cells[1, j].Value);
                                            if (ValidationValue.ToUpper().Contains("MAN") && HeaderValue == dsTableheaderVal)
                                            {
                                                sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colRed);
                                                break;
                                            }
                                            else if (ValidationValue.ToUpper().Contains("PO") && HeaderValue == dsTableheaderVal)
                                            {
                                                sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colOrange);
                                                break;
                                            }
                                            else
                                            {
                                                sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colGreen);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colGreen);
                                    }
                                }

                                // Colur Code logic
                                for (int k = 0; k < ds.Tables[i].Rows.Count; k++)
                                {
                                    for (int l = 0; l < ds.Tables[i].Columns.Count; l++)
                                    {
                                        sheet.DefaultColWidth = 40;
                                        sheet.Cells[k + 2, l + 1].Style.WrapText = true;
                                        string CellValue = Convert.ToString(ds.Tables[i].Rows[k][l]);
                                        if (CellValue.ToUpper() == "REMOVE")
                                        {
                                            sheet.Cells[k + 2, l + 1].Style.Font.Bold = true;
                                            sheet.Cells[k + 2, l + 1].Style.Font.Color.SetColor(Color.Red);
                                        }
                                    }
                                }
                                //
                            }
                            else
                            {
                                sheet.Cells.LoadFromDataTable(ds.Tables[i], true);
                                for (int j = 1; j <= ds.Tables[i].Columns.Count; j++)
                                {
                                    sheet.DefaultColWidth = 40;
                                    Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                                    sheet.Cells[1, j].Style.Font.Bold = true;
                                    sheet.Cells[1, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                                    sheet.Cells[1, j].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                                    sheet.Cells[1, j].Style.Font.Size = 11;
                                    sheet.Cells[1, j].Style.Font.Name = "Calibri";
                                    sheet.Cells[1, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                    sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colFromHex);
                                    sheet.Cells[1, j].Style.WrapText = true;
                                    sheet.Cells[1, j].AutoFitColumns();
                                }
                            }

                        }
                        else
                        {
                            ExcelWorksheet sheet = excel.Workbook.Worksheets.Add(ds.Tables[i].TableName);                            
                            if (ds.Tables[i].Rows.Count > 0)
                            {
                                sheet.Cells.LoadFromDataTable(ds.Tables[i], true);
                                for (int j = 1; j <= ds.Tables[i].Columns.Count; j++)
                                {
                                    sheet.DefaultColWidth = 40;
                                    Color colRed = System.Drawing.ColorTranslator.FromHtml("#F73131");
                                    Color colOrange = System.Drawing.ColorTranslator.FromHtml("#E35335");
                                    Color colGreen = System.Drawing.ColorTranslator.FromHtml("#8FD64B");
                                    Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                                    sheet.Cells[1, j].Style.Font.Bold = true;
                                    sheet.Cells[1, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                                    sheet.Cells[1, j].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                                    sheet.Cells[1, j].Style.Font.Size = 11;
                                    sheet.Cells[1, j].Style.Font.Name = "Calibri";
                                    sheet.Cells[1, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                    //sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colFromHex);
                                    sheet.Cells[1, j].Style.WrapText = true;
                                    sheet.Cells[1, j].AutoFitColumns();

                                    if (dsManFields != null && dsManFields.Tables.Count > 0 && ds.Tables[i].TableName != "Revision History")
                                    {
                                        for (int m = 0; m < dsManFields.Tables[i].Rows.Count; m++)
                                        {
                                            string ValidationValue = Convert.ToString(dsManFields.Tables[i].Rows[m][0]);
                                            string HeaderValue = Convert.ToString(dsManFields.Tables[i].Rows[m][1]);
                                            //dsTable Header
                                            string dsTableheaderVal = Convert.ToString(sheet.Cells[1, j].Value);
                                            if (ValidationValue.ToUpper().Contains("MAN") && HeaderValue == dsTableheaderVal)
                                            {
                                                sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colRed);
                                                break;
                                            }
                                            else if (ValidationValue.ToUpper().Contains("PO") && HeaderValue == dsTableheaderVal)
                                            {
                                                sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colOrange);
                                                break;
                                            }
                                            else
                                            {
                                                sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colGreen);
                                            }
                                        }
                                    }
                                    else
                                    {
                                        sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colFromHex);
                                    }

                                }
                                // Colur Code logic
                                for (int k = 0; k < ds.Tables[i].Rows.Count; k++)
                                {
                                    for (int l = 0; l < ds.Tables[i].Columns.Count; l++)
                                    {
                                        sheet.DefaultColWidth = 40;
                                        sheet.Cells[k + 2, l + 1].Style.WrapText = true;
                                        string CellValue = Convert.ToString(ds.Tables[i].Rows[k][l]);
                                        if (CellValue.ToUpper() == "REMOVE")
                                        {
                                            sheet.Cells[k + 2, l + 1].Style.Font.Bold = true;
                                            sheet.Cells[k + 2, l + 1].Style.Font.Color.SetColor(Color.Red);
                                        }
                                    }
                                }
                                //
                            }
                            else
                            {
                                sheet.Cells.LoadFromDataTable(ds.Tables[i], true);
                                for (int j = 1; j <= ds.Tables[i].Columns.Count; j++)
                                {
                                    sheet.DefaultColWidth = 40;
                                    Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                                    sheet.Cells[1, j].Style.Font.Bold = true;
                                    sheet.Cells[1, j].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                                    sheet.Cells[1, j].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                                    sheet.Cells[1, j].Style.Font.Size = 11;
                                    sheet.Cells[1, j].Style.Font.Name = "Calibri";
                                    sheet.Cells[1, j].Style.Fill.PatternType = ExcelFillStyle.Solid;
                                    sheet.Cells[1, j].Style.Fill.BackgroundColor.SetColor(colFromHex);
                                    sheet.Cells[1, j].Style.WrapText = true;
                                    sheet.Cells[1, j].AutoFitColumns();
                                }
                            }
                        }

                    }
                    FileInfo excelFile = new FileInfo(ConfigurationManager.AppSettings["UploadFilePath"] + Bookingsheet_Name);
                    excel.SaveAs(excelFile);

                }
            }

            BookingSheetName = Bookingsheet_Name;
        }
        public static void UpdateBookingSheetRecord(int BookingSheetCode, string BookingSheetName)
        {
            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);
            sqlConnection.Open();
            string query = "UPDATE AL_Booking_Sheet SET Record_Status = 'C', Excel_File = '"+ BookingSheetName + "' WHERE AL_Booking_Sheet_Code = '" + BookingSheetCode + "'";
            SqlCommand cmd = new SqlCommand(query, sqlConnection);          
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection.Close();
            }
        }                
        public static void InsertBookingSheetUDTData(List<Booking_Sheet_Import_Utility_UDT> Obj_Booking_Sheet_Import_Utility_UDT, int DM_Master_Import_Code, string Sheet_Name)
        {            
            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);

            ListtoDataTable lsttodt = new ListtoDataTable();
            System.Data.DataTable dt = lsttodt.ToDataTable(Obj_Booking_Sheet_Import_Utility_UDT);

            try
            {
                sqlConnection.Open();

                SqlCommand cmdSP = new SqlCommand();
                cmdSP.CommandText = "USPAL_Booking_Sheet_Import_Utility_PI";
                cmdSP.Connection = sqlConnection;
                cmdSP.CommandType = CommandType.StoredProcedure;

                SqlParameter param1 = new SqlParameter
                {
                    ParameterName = "@Booking_Sheet_Utility",
                    SqlDbType = SqlDbType.Structured,
                    TypeName = "dbo.Booking_Sheet_Import_Utility",
                    Value = dt,
                    Direction = ParameterDirection.Input
                };
                SqlParameter param2 = new SqlParameter
                {
                    ParameterName = "@CallFor",
                    SqlDbType = System.Data.SqlDbType.NVarChar,
                    Value = "INS",
                    Direction = ParameterDirection.Input
                };
                SqlParameter param3 = new SqlParameter
                {
                    ParameterName = "@User_Code",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Value = "143",
                    Direction = ParameterDirection.Input
                };
                SqlParameter param4 = new SqlParameter
                {
                    ParameterName = "@DM_Master_Import_Code",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Value = DM_Master_Import_Code,
                    Direction = ParameterDirection.Input
                };
                SqlParameter param5 = new SqlParameter
                {
                    ParameterName = "@Sheet_Name",
                    SqlDbType = System.Data.SqlDbType.NVarChar,
                    Value = Sheet_Name,
                    Direction = ParameterDirection.Input
                };

                cmdSP.Parameters.Add(param1);
                cmdSP.Parameters.Add(param2);                
                cmdSP.Parameters.Add(param3);
                cmdSP.Parameters.Add(param4);
                cmdSP.Parameters.Add(param5);

                cmdSP.ExecuteReader();

            }
            catch (Exception e)
            {
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection.Close();
            }
        }
        public static void ValidateAndUpdateBookingSheetMovie(int DM_Master_Import_Code)
        {
            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);

            try
            {
                sqlConnection.Open();
                SqlCommand cmdSP = new SqlCommand();
                cmdSP.CommandText = "USPAL_Booking_Sheet_Movie_Import_Utility_PIII";
                cmdSP.Connection = sqlConnection;
                cmdSP.CommandType = CommandType.StoredProcedure;

                SqlParameter param1 = new SqlParameter
                {
                    ParameterName = "@DM_Master_Import_Code",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Value = DM_Master_Import_Code,
                    Direction = ParameterDirection.Input
                };

                cmdSP.Parameters.Add(param1);
                cmdSP.ExecuteReader();
            }
            catch (Exception e)
            {
                UpdateDMBookingSheetRecord(DM_Master_Import_Code);
                LogWrite(e.Message.ToString());
            }
        }
        public static void ValidateAndUpdateBookingSheetShow(int DM_Master_Import_Code)
        {
            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);

            try
            {
                sqlConnection.Open();
                SqlCommand cmdSP = new SqlCommand();
                cmdSP.CommandText = "USPAL_Booking_Sheet_Show_Import_Utility_PIII";
                cmdSP.Connection = sqlConnection;
                cmdSP.CommandType = CommandType.StoredProcedure;

                SqlParameter param1 = new SqlParameter
                {
                    ParameterName = "@DM_Master_Import_Code",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Value = DM_Master_Import_Code,
                    Direction = ParameterDirection.Input
                };

                cmdSP.Parameters.Add(param1);
                cmdSP.ExecuteReader();
            }
            catch (Exception e)
            {
                UpdateDMBookingSheetRecord(DM_Master_Import_Code);
                LogWrite(e.Message.ToString());
            }
        }
        public static void UpdateDMBookingSheetRecord(int DM_Master_Import_Code)
        {
            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);
            sqlConnection.Open();
            string query = "UPDATE DM_Master_Import SET Status = 'E' WHERE DM_Master_Import_Code = '" + DM_Master_Import_Code + "'";
            SqlCommand cmd = new SqlCommand(query, sqlConnection);
            try
            {
                cmd.ExecuteNonQuery();
            }
            catch (Exception e)
            {
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection.Close();
            }
        }
        public static System.Data.DataTable GetRevisionHistoryDetails(int BookingSheetCode = 0)
        {
            System.Data.DataTable dtRevHist = new System.Data.DataTable("Revision History");

            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);

            try
            {
                sqlConnection.Open();
                string query = "SELECT CAST(dmi.Action_On AS NVARCHAR) AS Date, dmi.Remarks AS Notes, u.First_Name AS Author FROM DM_Master_Import dmi LEFT JOIN Users u ON dmi.Action_By = u.Users_Code WHERE File_Type = 'B' AND Record_Code ="+ BookingSheetCode;
                SqlCommand cmd = new SqlCommand(query, sqlConnection);
                SqlDataReader dr = cmd.ExecuteReader();

                if (!dr.IsClosed)
                {
                    dtRevHist.Load(dr);
                    dr.Close();
                }
                else
                {
                    dr.Close();
                }                

            }
            catch (Exception e)
            {
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection.Close();
            }

            return dtRevHist;
        }
        public static System.Data.DataTable GetMandatoryFieldNames(int BookingSheetCode, char DisplayFor)
        {
            System.Data.DataTable dsMandatary = new System.Data.DataTable();
            string ConnString1 = "";
            ConnString1 = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection1 = new SqlConnection(ConnString1);

            try
            {
                sqlConnection1.Open();

                using (SqlDataAdapter da = new SqlDataAdapter())
                {
                    string DataTableName = "";
                    char Display_For = DisplayFor;
                    BookingSheetCode = Convert.ToInt32(BookingSheetCode);

                    if (DisplayFor == 'M')
                    {
                        DataTableName = "Movies";
                    }
                    else
                    {
                        DataTableName = "TV Shows";
                    }
                    dsMandatary = new System.Data.DataTable(DataTableName);

                    SqlParameter param1 = new SqlParameter
                    {
                        ParameterName = "@BookingSheetCode",
                        SqlDbType = System.Data.SqlDbType.Int,
                        Value = BookingSheetCode,
                        Direction = ParameterDirection.Input
                    };
                    SqlParameter param2 = new SqlParameter
                    {
                        ParameterName = "@Display_For",
                        SqlDbType = System.Data.SqlDbType.Char,
                        Value = DisplayFor,
                        Direction = ParameterDirection.Input
                    };

                    SqlCommand sqlcomm = new SqlCommand();
                    sqlcomm.Connection = sqlConnection1;
                    sqlcomm.Parameters.Add(param1);
                    sqlcomm.Parameters.Add(param2);

                    sqlcomm.CommandText = "USPAL_GetBookingSheetMandatoryFieldNames";
                    da.SelectCommand = sqlcomm;
                    da.SelectCommand.CommandType = CommandType.StoredProcedure;

                    da.Fill(dsMandatary);
                }
            }
            catch (Exception e)
            {
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection1.Close();
            }
            return dsMandatary;
        }
        public static string GetBookingsheetName(int BookingSheetCode)
        {
            string BookingSheetName = "";
            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);
            sqlConnection.Open();
            string query = "SELECT (v.Short_Code +'-'+ CAST((format(ap.Start_Date, 'MMy')) AS NVARCHAR(10))+'-V'+ CAST((SELECT COUNT(*) + 1 FROM DM_Master_Import WHERE STATUS = 'S' AND Record_Code = bs.AL_Booking_Sheet_Code ) AS NVARCHAR(10)) +'-'+ CAST((bs.Booking_Sheet_No) AS NVARCHAR(10)) + '.xlsx') AS BookingSheetName FROM AL_Booking_Sheet bs INNER JOIN AL_Recommendation ar ON ar.AL_Recommendation_Code = bs.AL_Recommendation_Code INNER JOIN AL_Proposal ap ON ap.AL_Proposal_Code = ar.AL_Proposal_Code INNER JOIN Vendor v ON v.Vendor_Code = ap.Vendor_Code WHERE bs.AL_Booking_Sheet_Code = '" + BookingSheetCode + "'";
            SqlCommand cmd = new SqlCommand(query, sqlConnection);
            try
            {
                SqlDataReader dr = cmd.ExecuteReader();
                System.Data.DataTable dt = new System.Data.DataTable();
                DataSet ds = new DataSet();

                if (!dr.IsClosed)
                {
                    dt.Load(dr);
                    dr.Close();
                }
                else
                {
                    dr.Close();
                }

                if(dt.Rows.Count > 0)
                {
                    BookingSheetName = Convert.ToString(dt.Rows[0]["BookingSheetName"]);
                }
            }
            catch (Exception e)
            {
                LogWrite(e.Message.ToString());
            }
            finally
            {
                sqlConnection.Close();
            }
            return BookingSheetName;
        }
        public static void LogWrite(string logMessage)
        {
            string m_exePath = ConfigurationManager.AppSettings["LogFilePath"]; 
            try
            {
                using (StreamWriter w = File.AppendText(m_exePath + "\\" + "log.txt"))
                {
                    Log(logMessage, w);
                }
            }
            catch (Exception ex)
            {
            }
        }
        public static void Log(string logMessage, TextWriter txtWriter)
        {
            try
            {
                txtWriter.Write("\r\nLog Entry : ");
                txtWriter.WriteLine("{0} {1}", DateTime.Now.ToLongTimeString(),
                    DateTime.Now.ToLongDateString());
                txtWriter.WriteLine("  :");
                txtWriter.WriteLine("  :{0}", logMessage);
                txtWriter.WriteLine("-------------------------------");
            }
            catch (Exception ex)
            {
            }
        }
    }

    public class ListtoDataTable
    {
        public System.Data.DataTable ToDataTable<T>(List<T> items)
        {
            System.Data.DataTable dataTable = new System.Data.DataTable(typeof(T).Name);
            //Get all the properties by using reflection   
            PropertyInfo[] Props = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);
            foreach (PropertyInfo prop in Props)
            {
                //Setting column names as Property names  
                dataTable.Columns.Add(prop.Name);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {

                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }

            return dataTable;
        }
    }
    public class Booking_Sheet_Import_Utility_UDT
    {        
        public string Col1 { get; set; }
        public string Col2 { get; set; }
        public string Col3 { get; set; }
        public string Col4 { get; set; }
        public string Col5 { get; set; }
        public string Col6 { get; set; }
        public string Col7 { get; set; }
        public string Col8 { get; set; }
        public string Col9 { get; set; }
        public string Col10 { get; set; }
        public string Col11 { get; set; }
        public string Col12 { get; set; }
        public string Col13 { get; set; }
        public string Col14 { get; set; }
        public string Col15 { get; set; }
        public string Col16 { get; set; }
        public string Col17 { get; set; }
        public string Col18 { get; set; }
        public string Col19 { get; set; }
        public string Col20 { get; set; }
        public string Col21 { get; set; }
        public string Col22 { get; set; }
        public string Col23 { get; set; }
        public string Col24 { get; set; }
        public string Col25 { get; set; }
        public string Col26 { get; set; }
        public string Col27 { get; set; }
        public string Col28 { get; set; }
        public string Col29 { get; set; }
        public string Col30 { get; set; }
        public string Col31 { get; set; }
        public string Col32 { get; set; }
        public string Col33 { get; set; }
        public string Col34 { get; set; }
        public string Col35 { get; set; }
        public string Col36 { get; set; }
        public string Col37 { get; set; }
        public string Col38 { get; set; }
        public string Col39 { get; set; }
        public string Col40 { get; set; }
        public string Col41 { get; set; }
        public string Col42 { get; set; }
        public string Col43 { get; set; }
        public string Col44 { get; set; }
        public string Col45 { get; set; }
        public string Col46 { get; set; }
        public string Col47 { get; set; }
        public string Col48 { get; set; }
        public string Col49 { get; set; }
        public string Col50 { get; set; }
        public string Col51 { get; set; }
        public string Col52 { get; set; }
        public string Col53 { get; set; }
        public string Col54 { get; set; }
        public string Col55 { get; set; }
        public string Col56 { get; set; }
        public string Col57 { get; set; }
        public string Col58 { get; set; }
        public string Col59 { get; set; }
        public string Col60 { get; set; }
        public string Col61 { get; set; }
        public string Col62 { get; set; }
        public string Col63 { get; set; }
        public string Col64 { get; set; }
        public string Col65 { get; set; }
        public string Col66 { get; set; }
        public string Col67 { get; set; }
        public string Col68 { get; set; }
        public string Col69 { get; set; }
        public string Col70 { get; set; }
        public string Col71 { get; set; }
        public string Col72 { get; set; }
        public string Col73 { get; set; }
        public string Col74 { get; set; }
        public string Col75 { get; set; }
        public string Col76 { get; set; }
        public string Col77 { get; set; }
        public string Col78 { get; set; }
        public string Col79 { get; set; }
        public string Col80 { get; set; }
        public string Col81 { get; set; }
        public string Col82 { get; set; }
        public string Col83 { get; set; }
        public string Col84 { get; set; }
        public string Col85 { get; set; }
        public string Col86 { get; set; }
        public string Col87 { get; set; }
        public string Col88 { get; set; }
        public string Col89 { get; set; }
        public string Col90 { get; set; }
        public string Col91 { get; set; }
        public string Col92 { get; set; }
        public string Col93 { get; set; }
        public string Col94 { get; set; }
        public string Col95 { get; set; }
        public string Col96 { get; set; }
        public string Col97 { get; set; }
        public string Col98 { get; set; }
        public string Col99 { get; set; }
        public string Col100 { get; set; }
        public string Col101 { get; set; }
        public string Col102 { get; set; }
        public string Col103 { get; set; }
        public string Col104 { get; set; }
        public string Col105 { get; set; }
        public string Col106 { get; set; }
        public string Col107 { get; set; }
        public string Col108 { get; set; }
        public string Col109 { get; set; }
        public string Col110 { get; set; }
        public string Col111 { get; set; }
        public string Col112 { get; set; }
        public string Col113 { get; set; }
        public string Col114 { get; set; }
        public string Col115 { get; set; }
        public string Col116 { get; set; }
        public string Col117 { get; set; }
        public string Col118 { get; set; }
        public string Col119 { get; set; }
        public string Col120 { get; set; }
        public string Col121 { get; set; }
        public string Col122 { get; set; }
        public string Col123 { get; set; }
        public string Col124 { get; set; }
        public string Col125 { get; set; }
        public string Col126 { get; set; }
        public string Col127 { get; set; }
        public string Col128 { get; set; }
        public string Col129 { get; set; }
        public string Col130 { get; set; }
        public string Col131 { get; set; }
        public string Col132 { get; set; }
        public string Col133 { get; set; }
        public string Col134 { get; set; }
        public string Col135 { get; set; }
        public string Col136 { get; set; }
        public string Col137 { get; set; }
        public string Col138 { get; set; }
        public string Col139 { get; set; }
        public string Col140 { get; set; }
        public string Col141 { get; set; }
        public string Col142 { get; set; }
        public string Col143 { get; set; }
        public string Col144 { get; set; }
        public string Col145 { get; set; }
        public string Col146 { get; set; }
        public string Col147 { get; set; }
        public string Col148 { get; set; }
        public string Col149 { get; set; }
        public string Col150 { get; set; }
        public string Col151 { get; set; }
        public string Col152 { get; set; }
        public string Col153 { get; set; }
        public string Col154 { get; set; }
        public string Col155 { get; set; }
        public string Col156 { get; set; }
        public string Col157 { get; set; }
        public string Col158 { get; set; }
        public string Col159 { get; set; }
        public string Col160 { get; set; }
        public string Col161 { get; set; }
        public string Col162 { get; set; }
        public string Col163 { get; set; }
        public string Col164 { get; set; }
        public string Col165 { get; set; }
        public string Col166 { get; set; }
        public string Col167 { get; set; }
        public string Col168 { get; set; }
        public string Col169 { get; set; }
        public string Col170 { get; set; }
        public string Col171 { get; set; }
        public string Col172 { get; set; }
        public string Col173 { get; set; }
        public string Col174 { get; set; }
        public string Col175 { get; set; }
        public string Col176 { get; set; }
        public string Col177 { get; set; }
        public string Col178 { get; set; }
        public string Col179 { get; set; }
        public string Col180 { get; set; }
        public string Col181 { get; set; }
        public string Col182 { get; set; }
        public string Col183 { get; set; }
        public string Col184 { get; set; }
        public string Col185 { get; set; }
        public string Col186 { get; set; }
        public string Col187 { get; set; }
        public string Col188 { get; set; }
        public string Col189 { get; set; }
        public string Col190 { get; set; }
        public string Col191 { get; set; }
        public string Col192 { get; set; }
        public string Col193 { get; set; }
        public string Col194 { get; set; }
        public string Col195 { get; set; }
        public string Col196 { get; set; }
        public string Col197 { get; set; }
        public string Col198 { get; set; }
        public string Col199 { get; set; }
        public string Col200 { get; set; }
    }
}
