using OfficeOpenXml;
using OfficeOpenXml.Style;
using RightsU_PAReport_Service.Model;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.Entity;
using System.Data.SqlClient;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.ServiceProcess;
using System.Text;
using System.Threading.Tasks;

namespace RightsU_PAReport_Service
{
    public partial class RightsU_PA_Report : ServiceBase
    {
        public System.Timers.Timer timer = new System.Timers.Timer();
        public RightsU_PA_Report()
        {
            InitializeComponent();
            Error.WriteLog("Service Started", includeTime: true, addSeperater: true);
        }

        protected override void OnStart(string[] args)
        {
            timer.Interval = Convert.ToInt32(ConfigurationSettings.AppSettings["Timer"]);
            timer.Elapsed += new System.Timers.ElapsedEventHandler(this.OnTimer);
            timer.Start();
        }

        protected override void OnStop()
        {
            Error.WriteLog("Service Stoped", includeTime: true, addSeperater: true);
        }
        public void OnTimer(object sender, System.Timers.ElapsedEventArgs args)
        {
            timer.Stop();
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
                            Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Updating W to database = " + objAcq_Adv_Ancillary_Report.Acq_Adv_Ancillary_Report_Code.ToString());
                            try
                            {
                                using (SqlConnection connection = new SqlConnection(ConfigurationManager.ConnectionStrings["CS1"].ConnectionString))
                                using (SqlCommand command = new SqlCommand("USP_Acq_Deal_Ancillary_Adv_Report", connection))
                                {
                                    command.CommandType = CommandType.StoredProcedure;

                                    DataTable dt = new DataTable();
                                    SqlDataAdapter adapt = new SqlDataAdapter(command);
                                    command.Parameters.Add(new SqlParameter("@Agreement_No", objAcq_Adv_Ancillary_Report.Agreement_No));
                                    command.Parameters.Add(new SqlParameter("@Title_Codes", objAcq_Adv_Ancillary_Report.Title_Codes));
                                    command.Parameters.Add(new SqlParameter("@Platform_Codes", objAcq_Adv_Ancillary_Report.Platform_Codes));
                                    command.Parameters.Add(new SqlParameter("@Ancillary_Type_Code", objAcq_Adv_Ancillary_Report.Ancillary_Type_Codes));
                                    command.Parameters.Add(new SqlParameter("@Business_Unit_Code", objAcq_Adv_Ancillary_Report.Business_Unit_Code));
                                    command.Parameters.Add(new SqlParameter("@IncludeExpired", objAcq_Adv_Ancillary_Report.IncludeExpired));

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
                timer.Start();
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

                    //sheet.Workbook.Worksheets.Add(dt);
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
