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

                                    if (dt.Rows.Count == 0)
                                        Update_Acq_Adv_Ancillary_Report(objAcq_Adv_Ancillary_Report.Acq_Adv_Ancillary_Report_Code, "N", "PE");
                                    else
                                    {
                                        Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Calling Export Function");
                                        ExportAcq_Adv_Ancillary_Report(dt, objAcq_Adv_Ancillary_Report);
                                    }
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

            foreach (DataRow row in dt.Rows)
            {
                int i = 0;
                foreach (DataColumn col in dt.Columns)
                {
                    string CellValue = row[col.ColumnName].ToString();
                    if (col.ColumnName != "Agreement_No" && col.ColumnName != "Title" && col.ColumnName != "Title_Type" && col.ColumnName != "Ancillary_Type" && col.ColumnName != "Duration(Sec)" && col.ColumnName != "Period(Day)" && col.ColumnName != "Remarks")
                    {
                        if (CellValue == col.ColumnName)
                        {
                            row[col.ColumnName] = "YES";
                        }
                        else if (CellValue != col.ColumnName)
                        {
                            row[col.ColumnName] = "NO";
                        }
                        //Console.WriteLine(row[col]);
                    }
                    i++;
                }
            }
            dt.AcceptChanges();

            List<DataRow> list = dt.AsEnumerable().ToList();

            int Acq_Adv_Ancillary_Report_Code = 1;// objAcq_Adv_Ancillary_Report.Acq_Adv_Ancillary_Report_Code;
            try
            {

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
                    foreach (DataRow row in dt.Rows)
                    {
                        int i = 1, j = 0;
                        foreach (DataColumn col in dt.Columns)
                        {
                            string CellValue = row[col.ColumnName].ToString();
                            if (i == 1)
                            {
                                sheet.Cells[1, 1].Value = col.ColumnName;
                            }
                            else
                            {
                                sheet.Cells[1, i].Value = col.ColumnName;
                            }
                            i++;
                            j++;
                        }
                    }
                    int Erow = 2;
                    int Alltcnt = 0, Agreemntcnt = 0, Titlecnt = 0, TitleTypecnt = 0, rowNo = 2;
                    foreach (DataRow row in dt.Rows)
                    {
                        int Ecolumn = 1;

                        foreach (DataColumn col in dt.Columns)
                        {
                            if (Erow == 2 && Ecolumn == 1)
                            {
                                sheet.Cells[2, 1].Value = row.ItemArray[Ecolumn - 1];
                            }
                            else
                            {
                                sheet.Cells[Erow, Ecolumn].Value = row.ItemArray[Ecolumn - 1];
                            }
                            if (Erow > 2)
                            {
                                if (col.ColumnName == "Agreement_No" || col.ColumnName == "Title" || col.ColumnName == "Title_Type")
                                {
                                    string firstCellValue = "";
                                    string secondCellValue = "";
                                    if (col.ColumnName == "Agreement_No")
                                    {
                                        firstCellValue = sheet.Cells[(Erow - 1), Ecolumn + 1].Value.ToString();
                                        secondCellValue = row.ItemArray[1].ToString(); //sheet.Cells[Erow, Ecolumn].Value.ToString();
                                    }
                                    else if (col.ColumnName == "Title")
                                    {
                                        firstCellValue = sheet.Cells[(Erow - 1), Ecolumn].Value.ToString();
                                        secondCellValue = sheet.Cells[Erow, Ecolumn].Value.ToString();
                                    }
                                    else if (col.ColumnName == "Title_Type")
                                    {
                                        firstCellValue = sheet.Cells[(Erow - 1), Ecolumn - 1].Value.ToString();
                                        secondCellValue = row.ItemArray[1].ToString(); //sheet.Cells[Erow, Ecolumn].Value.ToString();
                                    }

                                    if (firstCellValue == secondCellValue)
                                    {
                                        Alltcnt++;
                                        if (col.ColumnName == "Agreement_No")
                                            Agreemntcnt++;

                                        if (col.ColumnName == "Title")
                                            Titlecnt++;

                                        if (col.ColumnName == "Title_Type")
                                            TitleTypecnt++;

                                        //sheet.Cells["A1:A2"].Merge = true;
                                    }
                                    else
                                    {
                                        //Alltcnt = 1;
                                        //rowNo = Erow;
                                        if (col.ColumnName == "Agreement_No")
                                        {
                                            Agreemntcnt = 0;
                                            rowNo = Erow;
                                        }
                                        if (col.ColumnName == "Title")
                                        {
                                            Titlecnt = 0;
                                            rowNo = Erow;
                                        }
                                        if (col.ColumnName == "Title_Type")
                                        {
                                            TitleTypecnt = 0;
                                            rowNo = Erow;
                                        }
                                    }

                                    //if(Alltcnt > 1)
                                    //{
                                    //    sheet.Cells[rowNo, Ecolumn, (Alltcnt + (rowNo)), Ecolumn].Merge = true;
                                    //}
                                    if (Agreemntcnt > 0 && col.ColumnName == "Agreement_No")
                                    {
                                        sheet.Cells[rowNo, Ecolumn, (Agreemntcnt + (rowNo)), Ecolumn].Merge = true;
                                    }
                                    if (Titlecnt > 0 && col.ColumnName == "Title")
                                    {
                                        sheet.Cells[rowNo, Ecolumn, (Titlecnt + (rowNo)), Ecolumn].Merge = true;
                                    }
                                    if (TitleTypecnt > 0 && col.ColumnName == "Title_Type")
                                    {
                                        sheet.Cells[rowNo, Ecolumn, (TitleTypecnt + (rowNo)), Ecolumn].Merge = true;
                                    }
                                }
                            }
                            Ecolumn++;
                        }
                        Erow++;
                    }

                    for (int i = 1; i <= dt.Columns.Count; i++)
                    {
                        sheet.Cells[1, i].Style.Font.Bold = true;
                        sheet.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                        sheet.Cells[1, i].Style.VerticalAlignment = OfficeOpenXml.Style.ExcelVerticalAlignment.Top;
                        sheet.Cells[1, i].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                        sheet.Cells[1, i].Style.Font.Size = 11;
                        sheet.Cells[1, i].Style.Font.Name = "Calibri";
                        sheet.Cells[1, i].Style.Fill.PatternType = ExcelFillStyle.Solid;

                        if (dt.Columns[i - 1].ColumnName != "Agreement_No" && dt.Columns[i - 1].ColumnName != "Title" && dt.Columns[i - 1].ColumnName != "Title_Type" && dt.Columns[i - 1].ColumnName != "Ancillary_Type" && dt.Columns[i - 1].ColumnName != "Duration(Sec)" && dt.Columns[i - 1].ColumnName != "Period(Day)" && dt.Columns[i - 1].ColumnName != "Remarks")
                        {
                            sheet.Cells[1, i].Style.Fill.BackgroundColor.SetColor(ColorTranslator.FromHtml("#565656"));
                            sheet.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Left;
                            sheet.Cells[1, i].Style.VerticalAlignment = OfficeOpenXml.Style.ExcelVerticalAlignment.Top;
                            sheet.Cells[1, i].Style.Font.Color.SetColor(Color.White);
                            //sheet.Cells[1, i].Style.WrapText = true;
                        }
                        else
                        {
                            sheet.Cells[1, i].Style.Fill.BackgroundColor.SetColor(ColorTranslator.FromHtml("#C0C0C0"));
                        }
                    }

                    //sheet.Cells["A1"].LoadFromDataTable(dt, true);
                    sheet.Cells.AutoFitColumns();
                    for (int i = 1; i <= dt.Columns.Count; i++)
                    {
                        sheet.Column(i).Width = 20;
                        sheet.Column(i).Style.WrapText = true;
                        sheet.Column(i).Style.VerticalAlignment = OfficeOpenXml.Style.ExcelVerticalAlignment.Top;
                    }

                    Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Data Inserted into sheet");

                    excelPackage.Save();

                    Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Sheet Saved");

                    //CHANGE THE RECORD STATUS TO 'C'
                    Update_Acq_Adv_Ancillary_Report(Acq_Adv_Ancillary_Report_Code, "C", "PE");

                    Error.WriteLog_Conditional("STEP 1 A : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Record Status Changed to 'C'");

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
