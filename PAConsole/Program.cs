using OfficeOpenXml;
using OfficeOpenXml.Style;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace PAConsole
{
    class Program
    {
        static void Main(string[] args)
        {
            PA_Report();
        }
        RightsU_Plus_TestingEntities db = new RightsU_Plus_TestingEntities();
        public static void PA_Report()
        {
            Error.WriteLog("EXE Started", includeTime: true, addSeperater: true);
            try
            {
                Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connecting to database");
                using (var context = new RightsU_Plus_TestingEntities())
                {
                    if (context.Acq_Adv_Ancillary_Report.Where(x => x.Report_Status == "W").Count() == 0)
                    {
                        List<Acq_Adv_Ancillary_Report> lstAcq_Adv_Ancillary_Report = context.Acq_Adv_Ancillary_Report.Where(x => x.Report_Status == "P").ToList();
                        foreach (Acq_Adv_Ancillary_Report objAcq_Adv_Ancillary_Report in lstAcq_Adv_Ancillary_Report)
                        {
                            Update_Acq_Adv_Ancillary_Report(objAcq_Adv_Ancillary_Report.Acq_Adv_Ancillary_Report_Code, "W", "PS");
                            Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Updateing W to database = " + objAcq_Adv_Ancillary_Report.Acq_Adv_Ancillary_Report_Code.ToString());
                            try
                            {

                                using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["CS1"].ConnectionString))
                                using (SqlCommand command = new SqlCommand("USP_Acq_Deal_Ancillary_Adv_Report", connection))
                                {
                                    command.CommandType = CommandType.StoredProcedure;

                                    DataTable dt = new DataTable();
                                    SqlDataAdapter adapt = new SqlDataAdapter(command);
                                    command.Parameters.Add(new SqlParameter("@Agreement_No",""));
                                    command.Parameters.Add(new SqlParameter("@Title_Codes", "4580"));
                                    command.Parameters.Add(new SqlParameter("@Platform_Codes","0"));
                                    command.Parameters.Add(new SqlParameter("@Ancillary_Type_Code", "0"));
                                    command.Parameters.Add(new SqlParameter("@Business_Unit_Code", 1));
                                    command.Parameters.Add(new SqlParameter("@IncludeExpired", "N"));

                                    connection.Open();
                                    command.ExecuteNonQuery();

                                    Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : FINISHED running procedure");

                                    adapt.SelectCommand = command;
                                    adapt.Fill(dt);

                                    Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Inserted into DataTable = ");

                                    if (dt == null)
                                        Update_Acq_Adv_Ancillary_Report(objAcq_Adv_Ancillary_Report.Acq_Adv_Ancillary_Report_Code, "N", "PE");
                                    else
                                        Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Calling Export Function");

                                    ExportAcq_Adv_Ancillary_Report(dt, objAcq_Adv_Ancillary_Report);
                                }
                            }
                            catch (Exception ex)
                            {
                                Update_Acq_Adv_Ancillary_Report(objAcq_Adv_Ancillary_Report.Acq_Adv_Ancillary_Report_Code, "E", "PE", ex.ToString());
                                StringBuilder sb = new StringBuilder("Found Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                                while (ex.InnerException != null)
                                {
                                    ex = ex.InnerException;
                                    sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                                }
                                Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                StringBuilder sb = new StringBuilder("Found Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                while (ex.InnerException != null)
                {
                    ex = ex.InnerException;
                    sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                }

                Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
            }
            finally
            {
                Error.WriteLog("EXE Ended", includeTime: true, addSeperater: true);
                //timer.Start();
            }
        }
        public static void Update_Acq_Adv_Ancillary_Report(int Acq_Adv_Ancillary_Report_Code, string Report_Status, string Process_Start_End, string Error_Message = "")
        {
            Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Called Update_Acq_Adv_Ancillary_Report");

            using (var context = new RightsU_Plus_TestingEntities())
            {
                Acq_Adv_Ancillary_Report objAcq_Adv_Ancillary_Report = context.Acq_Adv_Ancillary_Report.Where(x => x.Acq_Adv_Ancillary_Report_Code == Acq_Adv_Ancillary_Report_Code).FirstOrDefault();
                objAcq_Adv_Ancillary_Report.Report_Status = Report_Status;
                objAcq_Adv_Ancillary_Report.Error_Message = Error_Message;
                if (Process_Start_End == "PS")
                    objAcq_Adv_Ancillary_Report.Process_Start = DateTime.Now;
                else
                    objAcq_Adv_Ancillary_Report.Process_End = DateTime.Now;

                if (Report_Status == "C")
                    objAcq_Adv_Ancillary_Report.File_Name = "Acq_Adv_Ancillary_Report_Sheet" + Acq_Adv_Ancillary_Report_Code.ToString() + ".xlsx";

                context.Entry(objAcq_Adv_Ancillary_Report).State = EntityState.Modified;
                context.SaveChanges();

                Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Save Changes for Update_Acq_Adv_Ancillary_Report");

            }
        }
        public static void ExportAcq_Adv_Ancillary_Report(DataTable dt, Acq_Adv_Ancillary_Report objAcq_Adv_Ancillary_Report)
        {
            foreach (DataRow row in dt.Rows)
            {
                int i = 0;    
                foreach (DataColumn col in dt.Columns)
                {
                    string CellValue = row[col.ColumnName].ToString();
                    if(col.ColumnName != "Agreement_No" && col.ColumnName != "Title_Name" && col.ColumnName != "Title_Type" && col.ColumnName != "Ancillary_Type_Name" && col.ColumnName != "Duration" && col.ColumnName != "Day" && col.ColumnName != "Remarks")
                    {
                        if (CellValue == "1")
                        {
                            row.ItemArray[i] = "Yes";
                        }
                        else if(CellValue == "0")
                        {
                            row.ItemArray[i] = "No";
                        }
                        //Console.WriteLine(row[col]);
                    }
                    i++;
                }
            }
            Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Called Export Function");

            int Acq_Adv_Ancillary_Report_Code = 1;// objAcq_Adv_Ancillary_Report.Acq_Adv_Ancillary_Report_Code;
            try
            {
                //string Destination = "D:\\Temp\\Music_Usage_Report_Sheet_" + Music_Usage_Report_Code + ".xlsx";
                //FileInfo OldFile = new FileInfo("D:\\Temp\\Sample1.xlsx");

                string Destination = ConfigurationSettings.AppSettings["Destination"].ToString() + "Adv_Ancillary_Report_Sheet_" + Acq_Adv_Ancillary_Report_Code + ".xlsx";
                FileInfo OldFile = new FileInfo(ConfigurationSettings.AppSettings["OldFile"]);

                Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " :" + Destination);

                FileInfo newFile = new FileInfo(Destination);
                string Name = newFile.Name.ToString();
                if (newFile.Exists)
                {
                    newFile.Delete(); // ensures we create a new workbook
                    newFile = new FileInfo(Destination);
                }
                using (ExcelPackage excelPackage = new ExcelPackage(newFile, OldFile))
                {

                    ExcelPackage.LicenseContext = OfficeOpenXml.LicenseContext.NonCommercial;

                    var sheet = excelPackage.Workbook.Worksheets["Sheet1"];

                    for (int i = 1; i <= dt.Columns.Count; i++)
                    {
                        sheet.Cells[1, i].Style.Font.Bold = true;
                        sheet.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet.Cells[1, i].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                        sheet.Cells[1, i].Style.Font.Size = 11;
                        sheet.Cells[1, i].Style.Font.Name = "Calibri";
                        sheet.Cells[1, i].Style.Fill.PatternType = ExcelFillStyle.Solid;
                        sheet.Cells[1, i].Style.Fill.BackgroundColor.SetColor(ColorTranslator.FromHtml("#C0C0C0"));
                        sheet.Cells[1, i].AutoFitColumns();
                    }
                    
                    sheet.Cells["A1"].LoadFromDataTable(dt, true);
                    sheet.Cells.AutoFitColumns();

                    Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Data Inserted into sheet");

                    excelPackage.Save();

                    Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Sheet Saved");
                }

            }
            catch (Exception ex)
            {
                Update_Acq_Adv_Ancillary_Report(Acq_Adv_Ancillary_Report_Code, "E", "PE", ex.ToString());

                StringBuilder sb = new StringBuilder("Found Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                while (ex.InnerException != null)
                {
                    ex = ex.InnerException;
                    sb.Append(" | Inner Exception : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : " + ex.Message);
                }

                Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
            }
        }
    }
}
