﻿using RightsU_PurchaseOrder_Export.WebReference;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Net;
using System.ServiceProcess;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;

namespace RightsU_PurchaseOrder_Export
{
    partial class RightsU_AL_Purchase_Order : ServiceBase
    {
        public System.Timers.Timer timer = new System.Timers.Timer();
        public RightsU_AL_Purchase_Order()
        {
            InitializeComponent();
            Error.WriteLog("Service Started", includeTime: true, addSeperater: true);
        }
        protected override void OnStart(string[] args)
        {
            timer.Interval = Convert.ToInt32(ConfigurationSettings.AppSettings["Timer"]);
            timer.Elapsed += new System.Timers.ElapsedEventHandler(this.OnTimer);
            timer.Start();
            // TODO: Add code here to start your service.
        }
        protected override void OnStop()
        {
            Error.WriteLog("Service Stoped", includeTime: true, addSeperater: true);
            // TODO: Add code here to perform any tear-down necessary to stop your service.
        }
        public void OnTimer(object sender, System.Timers.ElapsedEventArgs args)
        {
            timer.Stop();
            Error.WriteLog("EXE Started", includeTime: true, addSeperater: true);
            try
            {
                GenerateDataforPendingPurchaseOrder();
                GeneratePDFforPendingPurchaseOrder();
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
        public static void GenerateDataforPendingPurchaseOrder()
        {
            Error.WriteLog_Conditional("STEP 1.1  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Started  Generate Data For Pending Purchase Order.");
            int PurchaseOrderCode = 0;

            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);

            try
            {
                sqlConnection.Open();
                Error.WriteLog_Conditional("STEP 1.2  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Database connection established.");
                string query = "SELECT * FROM AL_Purchase_Order WHERE Status = 'P' AND Workflow_Status = 'W' ";
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
                Error.WriteLog_Conditional("STEP 1.3 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Getting reords from database.");
                for (int i = 0; i <= dt.Rows.Count - 1; i++)
                {
                    PurchaseOrderCode = Convert.ToInt32(dt.Rows[i][0]);

                    SqlCommand cmdSP = new SqlCommand(query, sqlConnection);
                    cmdSP.CommandText = "USPAL_Gen_Purchase_Order_Data";
                    cmdSP.Connection = sqlConnection;
                    cmdSP.CommandType = CommandType.StoredProcedure;
                    SqlParameter param = new SqlParameter
                    {
                        ParameterName = "@ALPurchaseOrderCode",
                        SqlDbType = System.Data.SqlDbType.Int,
                        Value = PurchaseOrderCode,
                        Direction = ParameterDirection.Input
                    };

                    cmdSP.Parameters.Add(param);
                    cmdSP.ExecuteReader();

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
                sqlConnection.Close();
                Error.WriteLog_Conditional("STEP 1.4 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Database connection closed.");
            }
        }
        public static void GeneratePDFforPendingPurchaseOrder()
        {
            Error.WriteLog_Conditional("STEP 2.1  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Started Generating PDF for Pending Purchase Order.");
            string ConnString1 = "";
            ConnString1 = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection1 = new SqlConnection(ConnString1);

            try
            {
                sqlConnection1.Open();
                Error.WriteLog_Conditional("STEP 2.2  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Database connection established.");
                //string query = "SELECT * FROM (SELECT apod.AL_Purchase_Order_Details_Code, apod.Title_Code, apod.Status, apor.AL_Purchase_Order_Code, apod.Vendor_Code, (SELECT TOP 1 Vendor_Name FROM vendor WHERE Vendor_Code = apod.Vendor_Code) AS Vendor_Name, apod.PO_Number, ROW_NUMBER() OVER ( PARTITION BY apod.AL_Purchase_Order_Details_Code ORDER BY apor.AL_Purchase_Order_Code ) AS RowNum FROM (SELECT * FROM AL_Purchase_Order_Details WHERE Status = 'P') apod INNER JOIN AL_Purchase_Order_Rel apor ON apor.AL_Purchase_Order_Details_Code = apod.AL_Purchase_Order_Details_Code INNER JOIN AL_Purchase_Order apo ON apo.AL_Purchase_Order_Code = apor.AL_Purchase_Order_Code LEFT JOIN AL_Booking_Sheet absh ON absh.AL_Booking_Sheet_Code = apo.AL_Booking_Sheet_Code LEFT JOIN Vendor v ON absh.Vendor_Code = v.Vendor_Code) AS T WHERE RowNum = 1 AND Status = 'P'"; //AND Status = 'P'
                string query = "SELECT * FROM (SELECT apod.AL_Purchase_Order_Details_Code, apod.Title_Code, apod.Status, apor.AL_Purchase_Order_Code, apod.Vendor_Code, (SELECT TOP 1 Vendor_Name FROM vendor WHERE Vendor_Code = apod.Vendor_Code) AS Vendor_Name, apod.PO_Number, apo.AL_Booking_Sheet_Code, apo.Workflow_Status, ROW_NUMBER() OVER ( PARTITION BY apod.AL_Purchase_Order_Details_Code ORDER BY apor.AL_Purchase_Order_Code ) AS RowNum FROM (SELECT * FROM AL_Purchase_Order_Details WHERE Status = 'P') apod INNER JOIN AL_Purchase_Order_Rel apor ON apor.AL_Purchase_Order_Details_Code = apod.AL_Purchase_Order_Details_Code INNER JOIN AL_Purchase_Order apo ON apo.AL_Purchase_Order_Code = apor.AL_Purchase_Order_Code LEFT JOIN AL_Booking_Sheet absh ON absh.AL_Booking_Sheet_Code = apo.AL_Booking_Sheet_Code LEFT JOIN Vendor v ON absh.Vendor_Code = v.Vendor_Code) AS T WHERE RowNum = 1 AND Status = 'P' AND Workflow_Status = 'A'"; //AND Status = 'P'
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

                Error.WriteLog_Conditional("STEP 2.3 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Getting reords from database.");
                for (int p = 0; p <= dt.Rows.Count - 1; p++)
                {
                    string ALPurchaseOrderDetailsCode = Convert.ToString(dt.Rows[p]["AL_Purchase_Order_Details_Code"]);
                    string ALTitleCode = Convert.ToString(dt.Rows[p]["Title_Code"]);
                    string PO_Number = "";
                    string AL_Purchase_Order_Code = Convert.ToString(dt.Rows[p]["AL_Purchase_Order_Code"]);

                    //string GetDealTypeQuery = "SELECT * FROM Title t WHERE t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies'),',')) AND t.Title_Code = '" + ALTitleCode + "'";
                    string GetDealTypeQuery = "SELECT * FROM Title t WHERE t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Movies'),',')) AND t.Title_Code = '" + ALTitleCode + "'";
                    SqlCommand cmd2 = new SqlCommand(GetDealTypeQuery, sqlConnection1);
                    SqlDataReader dr2 = cmd2.ExecuteReader();
                    System.Data.DataTable dt2 = new System.Data.DataTable();

                    if (!dr2.IsClosed)
                    {
                        dt2.Load(dr2);
                        dr2.Close();
                    }
                    else
                    {
                        dr2.Close();
                    }
                    #region PDF Conversion Logic
                    if (dt2.Rows.Count > 0)
                    {
                        string Title_Name = "";
                        Title_Name = Convert.ToString(dt2.Rows[0]["Title_Name"]);
                        PO_Number = Convert.ToString(dt.Rows[p]["PO_Number"]);
                        CreatePurchaseOrderForMovie(ALPurchaseOrderDetailsCode, AL_Purchase_Order_Code, PO_Number, Title_Name);
                    }
                    else
                    {
                        //string GetShowDataQuery = "SELECT * FROM AL_Purchase_Order_Details apod INNER JOIN Title t ON t.Title_Code = apod.Title_Code AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),',')) WHERE apod.Status = 'P' AND apod.AL_Purchase_Order_Details_Code = '" + ALPurchaseOrderDetailsCode + "'";
                        string GetShowDataQuery = "SELECT * FROM AL_Purchase_Order_Details apod INNER JOIN Title t ON t.Title_Code = apod.Title_Code AND t.Deal_Type_Code IN (SELECT number FROM [dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),',')) WHERE apod.Status = 'P' AND apod.AL_Purchase_Order_Details_Code = '" + ALPurchaseOrderDetailsCode + "'";
                        SqlCommand cmd3 = new SqlCommand(GetShowDataQuery, sqlConnection1);
                        SqlDataReader dr3 = cmd3.ExecuteReader();
                        System.Data.DataTable dt3 = new System.Data.DataTable();

                        if (!dr3.IsClosed)
                        {
                            dt3.Load(dr3);
                            dr3.Close();
                        }
                        else
                        {
                            dr3.Close();
                        }
                        if (dt3.Rows.Count > 0)
                        {
                            int Vendor_Code = 0;
                            string Vendor_Name = "";
                            string GetCurrentVendorDT = "SELECT TOP 1 ISNULL(v.Vendor_Code,0) AS Vendor_Code, ISNULL(v.Vendor_Name,'') AS Vendor_Name FROM AL_Booking_Sheet_Details absd LEFT JOIN Vendor V ON absd.Columns_Value = V.Vendor_Name INNER JOIN Title t ON t.Title_Code = absd.Title_Code AND t.Deal_Type_Code IN(SELECT number FROM[dbo].[fn_Split_withdelemiter]((SELECT sp.Parameter_Value FROM System_Parameter sp WHERE sp.Parameter_Name = 'AL_DealType_Show'),',')) WHERE absd.AL_Booking_Sheet_Code = '" + Convert.ToString(dt.Rows[p]["AL_Booking_Sheet_Code"]) + "' AND absd.Title_Code = '" + Convert.ToString(dt3.Rows[0]["Title_Code"]) + "' AND absd.Title_Content_Code = '" + Convert.ToString(dt3.Rows[0]["Title_Content_Code"]) + "' AND Columns_Code IN (SELECT Parameter_Value FROM system_parameter_New WHERE Parameter_Name = 'AL_Ext_Col_Distributor_Value')";
                            SqlCommand cmd4 = new SqlCommand(GetCurrentVendorDT, sqlConnection1);
                            SqlDataReader dr4 = cmd4.ExecuteReader();
                            System.Data.DataTable dt4 = new System.Data.DataTable();

                            if (!dr4.IsClosed)
                            {
                                dt4.Load(dr4);
                                dr4.Close();
                            }
                            else
                            {
                                dr4.Close();
                            }
                            if (dt4.Rows.Count > 0)
                            {
                                Vendor_Code = Convert.ToInt32(dt4.Rows[0]["Vendor_Code"]);
                                Vendor_Name = Convert.ToString(dt4.Rows[0]["Vendor_Name"]);
                            }

                            PO_Number = Convert.ToString(dt.Rows[p]["PO_Number"]);
                            CreatePurchaseOrderForShow(ALPurchaseOrderDetailsCode, AL_Purchase_Order_Code, PO_Number, Vendor_Name, Vendor_Code);
                        }
                    }
                    #endregion
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
                sqlConnection1.Close();
                Error.WriteLog_Conditional("STEP 2.4 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Database connection closed.");
            }

        }
        public static void CreatePurchaseOrderForMovie(string ALPurchaseOrderDetailsCode, string AL_Purchase_Order_Code, string PO_Number, string Title_Name)
        {
            Error.WriteLog_Conditional("STEP 3.1 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Create Purchase Order For Movie.");
            ReportExecutionService rs = new ReportExecutionService();
            ReportingCredentials objRC = ReportCredential();

            rs.Credentials = new NetworkCredential(objRC.CredentialdomainName + "\\" + objRC.CredentialUser, objRC.CredentialPassWord);
            string asmxPath = ConfigurationManager.AppSettings["asmxPath"];
            rs.Url = objRC.ReportingServer + "/" + asmxPath;

            Error.WriteLog_Conditional("STEP 3.1.1 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Connecting Reporting Service.");

            rs.ExecutionHeaderValue = new ExecutionHeader();
            var executionInfo = new ExecutionInfo();
            string rdlPurchaseOrder = ConfigurationManager.AppSettings["rdlPurchaseOrder"];
            //rs.UseDefaultCredentials = true;
            executionInfo = rs.LoadReport(rdlPurchaseOrder, null);

            Error.WriteLog_Conditional("STEP 3.1.2 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Load Report.");

            List<ParameterValue> parameters = new List<ParameterValue>();
            parameters.Add(new ParameterValue { Name = "AL_Purchase_Order_Details_Code", Value = ALPurchaseOrderDetailsCode });
            rs.SetExecutionParameters(parameters.ToArray(), "en-US");

            Error.WriteLog_Conditional("STEP 3.1.3 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Set Execution Parameters.");

            string deviceInfo = "<DeviceInfo><Toolbar>False</Toolbar></DeviceInfo>";
            string mimeType;
            string encoding;
            string[] streamId;
            Warning[] warning;

            rs.Timeout = Timeout.Infinite;
            var result = rs.Render("pdf", deviceInfo, out mimeType, out encoding, out encoding, out warning, out streamId);

            Error.WriteLog_Conditional("STEP 3.1.4 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Render PDF result.");

            string outputFilePath = ConfigurationManager.AppSettings["outputPath"];
            string outputFileName = "";

            //Regex reg = new Regex("[*'\",:&#^@/<>?|]");
            //Title_Name = reg.Replace(Title_Name, "_");
            Title_Name = Title_Name.Replace("*", "＊");
            Title_Name = Title_Name.Replace("|", "|");
            Title_Name = Title_Name.Replace("?", "？");
            Title_Name = Title_Name.Replace("/", "／");
            Title_Name = Title_Name.Replace(@"\", "＼");
            Title_Name = Title_Name.Replace("<", "＜");
            Title_Name = Title_Name.Replace(">", "＞");
            Title_Name = Title_Name.Replace(":", "：");
            Title_Name = Title_Name.Replace('"', '＂');

            outputFileName = PO_Number.Replace("/", "／") + "-" + Title_Name + ".pdf";

            Error.WriteLog_Conditional("STEP 3.1.5 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Replacing Special Charactors to Unicode Charactors.");

            File.WriteAllBytes(outputFilePath + outputFileName, result);
            Error.WriteLog_Conditional("STEP 3.2 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Created " + outputFileName + "file.");
            #region Update PurchaseOrderDetail
            string query1 = "UPDATE AL_Purchase_Order_Details SET Status = 'C', PDF_File_Name = N'" + outputFileName.Replace("'", "''") + "' WHERE AL_Purchase_Order_Details_Code = '" + ALPurchaseOrderDetailsCode + "'";
            string query2 = "UPDATE AL_Purchase_Order SET Status = 'C' WHERE AL_Purchase_Order_Code = '" + AL_Purchase_Order_Code + "'";
            UpdatePurchaseOrderDetailRecord(query1);
            UpdatePurchaseOrderDetailRecord(query2);
            Error.WriteLog_Conditional("STEP 3.3 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Updated Table AL_Purchase_Order_Details and AL_Purchase_Order");
            #endregion
        }
        public static void CreatePurchaseOrderForShow(string ALPurchaseOrderDetailsCode, string AL_Purchase_Order_Code, string PO_Number, string Vendor_Name, int Vendor_Code)
        {
            Error.WriteLog_Conditional("STEP 4.1 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Create Purchase Order For Show.");
            ReportExecutionService rs = new ReportExecutionService();
            ReportingCredentials objRC = ReportCredential();

            rs.Credentials = new NetworkCredential(objRC.CredentialdomainName + "\\" + objRC.CredentialUser, objRC.CredentialPassWord);
            string asmxPath = ConfigurationManager.AppSettings["asmxPath"];
            rs.Url = objRC.ReportingServer + "/" + asmxPath;

            rs.ExecutionHeaderValue = new ExecutionHeader();
            var executionInfo = new ExecutionInfo();
            string rdlPurchaseOrder = ConfigurationManager.AppSettings["rdlPurchaseOrderShow"];
            //rs.UseDefaultCredentials = true;
            executionInfo = rs.LoadReport(rdlPurchaseOrder, null);

            List<ParameterValue> parameters = new List<ParameterValue>();
            parameters.Add(new ParameterValue { Name = "AL_Purchase_Order_Details_Code", Value = ALPurchaseOrderDetailsCode });
            rs.SetExecutionParameters(parameters.ToArray(), "en-US");

            string deviceInfo = "<DeviceInfo><Toolbar>False</Toolbar></DeviceInfo>";
            string mimeType;
            string encoding;
            string[] streamId;
            Warning[] warning;

            rs.Timeout = Timeout.Infinite;
            var result = rs.Render("pdf", deviceInfo, out mimeType, out encoding, out encoding, out warning, out streamId);

            string outputFilePath = ConfigurationManager.AppSettings["outputPath"];
            string outputFileName = "";

            //Regex reg = new Regex("[*'\",:&#^@]");
            //Vendor_Name = reg.Replace(Vendor_Name, "_");

            Vendor_Name = Vendor_Name.Replace("*", "＊");
            Vendor_Name = Vendor_Name.Replace("|", "|");
            Vendor_Name = Vendor_Name.Replace("?", "？");
            Vendor_Name = Vendor_Name.Replace("/", "／");
            Vendor_Name = Vendor_Name.Replace(@"\", "＼");
            Vendor_Name = Vendor_Name.Replace("<", "＜");
            Vendor_Name = Vendor_Name.Replace(">", "＞");
            Vendor_Name = Vendor_Name.Replace(":", "：");
            Vendor_Name = Vendor_Name.Replace('"', '＂');

            outputFileName = PO_Number.Replace("/", "／") + "-" + Vendor_Name + ".pdf";

            File.WriteAllBytes(outputFilePath + outputFileName, result);
            Error.WriteLog_Conditional("STEP 4.2 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Created " + outputFileName + "file.");
            #region Update PurchaseOrderDetail            
            string query1 = "UPDATE apod SET Status = 'C' , PDF_File_Name = N'" + outputFileName.Replace("'", "''") + "' , Vendor_Code = '" + Vendor_Code + "' FROM AL_Purchase_Order_Details apod WHERE apod.AL_Purchase_Order_Details_Code = '" + ALPurchaseOrderDetailsCode + "'";
            string query2 = "UPDATE AL_Purchase_Order SET Status = 'C' WHERE AL_Purchase_Order_Code = '" + AL_Purchase_Order_Code + "'";
            string query3 = "UPDATE AL_Purchase_Order_Details SET Status = 'C', Vendor_Code = '" + Vendor_Code + "', PDF_File_Name = N'" + outputFileName.Replace("'", "''") + "' WHERE Status = 'P' AND PO_Number = '" + PO_Number + "'";
            UpdatePurchaseOrderDetailRecord(query1);
            UpdatePurchaseOrderDetailRecord(query2);
            UpdatePurchaseOrderDetailRecord(query3);
            Error.WriteLog_Conditional("STEP 4.3 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Updated Table AL_Purchase_Order_Details and AL_Purchase_Order");
            #endregion
        }
        public static void UpdatePurchaseOrderDetailRecord(string Result_query)
        {
            Error.WriteLog_Conditional("STEP 5.1 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Update Purchase Order Detail Record.");
            string ConnString = "";
            ConnString = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlConnection = new SqlConnection(ConnString);
            sqlConnection.Open();
            Error.WriteLog_Conditional("STEP 5.2  : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Database connection established.");
            string query = Result_query;
            SqlCommand cmd = new SqlCommand(query, sqlConnection);
            try
            {
                cmd.ExecuteNonQuery();
                Error.WriteLog_Conditional("STEP 5.3 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Record updated successfully.");
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
                sqlConnection.Close();
                Error.WriteLog_Conditional("STEP 5.4 : " + DateTime.Now.ToString("dd-MMM-yyyy  HH:mm:ss") + " : Database connection closed.");
            }
        }        
        public static ReportingCredentials ReportCredential()
        {
            ReportingCredentials objRC = new ReportingCredentials();
            var objbufferSize = new
            {
                Parameter_Name = "RPT"
                //IsActive = "Y"
            };
            string strSql = "SELECT Parameter_Name, Parameter_Value FROM System_Parameter_New WHERE Parameter_Name LIKE '%RPT%'";
            DataSet ds = ProcessSelect(strSql);
            DataTable dt = ds.Tables[0];

            foreach (DataRow dr in dt.Rows)
            {
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_ReportingServer")
                    objRC.ReportingServer = Convert.ToString(dr["Parameter_Value"]);
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_IsCredentialRequired")
                    objRC.IsCredentialRequired = Convert.ToString(dr["Parameter_Value"]);
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_CredentialsUserPassWord")
                    objRC.CredentialPassWord = Convert.ToString(dr["Parameter_Value"]);
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_CredentialsUserName")
                    objRC.CredentialUser = Convert.ToString(dr["Parameter_Value"]);
                if (Convert.ToString(dr["Parameter_Name"]) == "RPT_CredentialdomainName")
                    objRC.CredentialdomainName = Convert.ToString(dr["Parameter_Value"]);
            }

            return objRC;
        }
        private static DataSet ProcessSelect(string sql)
        {
            //string StrCon = ConfigurationManager.AppSettings["conStr"];
            string StrCon = ConfigurationManager.ConnectionStrings["DbConn"].ConnectionString;
            SqlConnection sqlCon = null;
            SqlDataAdapter da;
            DataSet ds = new DataSet();
            using (sqlCon = new SqlConnection(StrCon))
            {
                sqlCon.Open();
                SqlCommand sql_cmnd = new SqlCommand(sql, sqlCon);
                sql_cmnd.CommandType = CommandType.Text;
                sql_cmnd.CommandTimeout = 32767;
                da = new SqlDataAdapter(sql_cmnd);
                da.Fill(ds);
            }
            return ds;
        }
    }
    public class ReportingCredentials
    {
        public string ReportingServer { get; set; }
        public string IsCredentialRequired { get; set; }
        public string CredentialPassWord { get; set; }
        public string CredentialUser { get; set; }
        public string CredentialdomainName { get; set; }
    }
}
