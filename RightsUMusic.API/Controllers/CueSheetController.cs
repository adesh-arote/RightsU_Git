using RightsUMusic.Entity;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.OleDb;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web;
using System.Web.Http;
using RightsUMusic.BLL.Services;
using System.IO;
using System.Text;
using System.Threading;
using System.Configuration;
using System.Net.Http.Headers;
using OfficeOpenXml;
using OfficeOpenXml.Style;
using System.Drawing;
using System.Text.RegularExpressions;

namespace RightsUMusic.API.Controllers
{
    public class CueSheetController : ApiController
    {
        private readonly CueSheetManagementServices obj = new CueSheetManagementServices();
        private readonly MHUsersServices objMHUsersServices = new MHUsersServices();

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage UploadCueSheet()
        {
            Return _objRet = new Return();
            try
            {
                Error.WriteLog("Upload Started", includeTime: true, addSeperater: true);

                MHUsersServices objMHUsersServices = new MHUsersServices();
                _objRet.IsSuccess = true;
                var httpRequest = HttpContext.Current.Request;

                var CueSheetCode = httpRequest.Form["CueSheetCode"];
                var fileWithTimeStamp = "";
                Error.WriteLog_Conditional("STEP 1 A: User Veryfying");
                string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
                UsersCode = UsersCode.Replace("Bearer ", "");
                Error.WriteLog_Conditional("STEP 1 B: User verified user code = " + UsersCode);

                var objU = new
                {
                    Users_Code = UsersCode
                };
                MHUsers objMHUser = objMHUsersServices.SearchFor(objU).FirstOrDefault();

                VendorServices objVendorServices = new VendorServices();
                Vendor objVendor = objVendorServices.GetVendorByID(objMHUser.Vendor_Code);
                DataTable dt = new DataTable();
                string strErrMsg = string.Empty;

                //try
                //{
                //var filePath = HttpContext.Current.Server.MapPath("~/Uploads/" + "CuesheetImport");
                //dt = exceldata(filePath);
                if (httpRequest.Files.Count > 0)
                {
                    Error.WriteLog_Conditional("STEP 2 A: File Upload Start");
                    foreach (string file in httpRequest.Files)
                    {
                        var postedFile = httpRequest.Files[file];
                        //var filePath = HttpContext.Current.Server.MapPath("~/Uploads/" + postedFile.FileName);
                        fileWithTimeStamp = Path.GetFileNameWithoutExtension(postedFile.FileName) + "_" + DateTime.Now.ToFileTime() + Path.GetExtension(postedFile.FileName);
                        var fileName = Path.GetFileNameWithoutExtension(postedFile.FileName) + Path.GetExtension(postedFile.FileName);
                        var filePath = HttpContext.Current.Server.MapPath("~/Uploads/" + fileWithTimeStamp);
                        postedFile.SaveAs(filePath);
                        int timeDelay = Convert.ToInt32(ConfigurationManager.AppSettings["TimeDelay"]);
                        Thread.Sleep(timeDelay);
                        dt = exceldata(filePath);
                    }
                    Error.WriteLog_Conditional("STEP 2 A: File Upload Ended");

                    Error.WriteLog_Conditional("STEP 3 A: File Validation Started");
                    string[] headers = { "Sr. No", "Show Name" };
                    if (dt.Columns.Count != 12)
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Count Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    if (dt.Columns[0].ToString() != "SrNo")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[1].ToString() != "Show Name")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[2].ToString() != "Episode")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    //else if (dt.Columns[3].ToString() != "Version")
                    //{
                    //    _objRet.IsSuccess = false;
                    //    _objRet.Message = "Column Name Mismatch";
                    //    return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    //}
                    else if (dt.Columns[3].ToString() != "Music Track")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[4].ToString() != "Movie/Album")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[5].ToString() != "Usage Type")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[6].ToString() != "TC IN")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[7].ToString() != "TC IN Frame")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[8].ToString() != "TC OUT")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[9].ToString() != "TC OUT Frame")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[10].ToString() != "Duration")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else if (dt.Columns[11].ToString() != "Duration Frame")
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "Column Name Mismatch";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                    }
                    else
                        _objRet.IsSuccess = true;

                    if (dt.Rows.Count == 0)
                    {
                        _objRet.IsSuccess = false;
                        _objRet.Message = "There Should be atleast 1 row in file";
                        return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

                    }

                    if (dt.Rows.Count <= 1)
                    {
                        int cnt = 0;
                        for (int i = 0; i < dt.Columns.Count; i++)
                        {
                            if (dt.Rows[0][i].ToString() == "")
                            {
                                cnt++;
                            }
                        }

                        if (cnt == dt.Columns.Count)
                        {
                            _objRet.IsSuccess = false;
                            _objRet.Message = "There Should be atleast 1 row in file";
                            return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                        }

                    }

                    Error.WriteLog_Conditional("STEP 3 B: File Validation Ended");

                    foreach (DataRow row in dt.Rows)
                    {
                        DateTime TCIN = new DateTime(); DateTime TCOUT = new DateTime(); DateTime Duration = new DateTime();

                        if (Convert.ToString(row["TC IN"]) != "")
                        {
                            try
                            {
                                TCIN = Convert.ToDateTime(row["TC IN"]);
                            }
                            catch (Exception)
                            {
                                _objRet.IsSuccess = false;
                                _objRet.Message = "Incorrect format for TC IN";
                                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                            }

                        }

                        if (Convert.ToString(row["TC OUT"]) != "")
                        {
                            try
                            {
                                TCOUT = Convert.ToDateTime(row["TC OUT"]);
                            }
                            catch (Exception)
                            {
                                _objRet.IsSuccess = false;
                                _objRet.Message = "Incorrect format for TC OUT";
                                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                            }

                        }
                        if (Convert.ToString(row["Duration"]) != "")
                        {
                            try
                            {
                                Duration = Convert.ToDateTime(row["Duration"]);
                            }
                            catch (Exception)
                            {
                                _objRet.IsSuccess = false;
                                _objRet.Message = "Incorrect format for Duration";
                                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                            }

                        }
                        if (Convert.ToString(row["TC IN Frame"]) != "")
                        {
                            if (!Regex.IsMatch(Convert.ToString(row["TC IN Frame"]), @"\d"))
                            {
                                _objRet.IsSuccess = false;
                                _objRet.Message = "Invalid From Frame";
                                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                            }
                        }
                        if (Convert.ToString(row["TC OUT Frame"]) != "")
                        {
                            if (!Regex.IsMatch(Convert.ToString(row["TC OUT Frame"]), @"\d"))
                            {
                                _objRet.IsSuccess = false;
                                _objRet.Message = "Invalid To Frame";
                                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                            }
                        }
                        if (Convert.ToString(row["Duration Frame"]) != "")
                        {
                            if (!Regex.IsMatch(Convert.ToString(row["Duration Frame"]), @"\d"))
                            {
                                _objRet.IsSuccess = false;
                                _objRet.Message = "Invalid Duration Frame";
                                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                            }
                        }
                    }
                    //foreach (DataColumn column in dt.Columns)
                    //{
                    //        string col = column.ColumnName;

                    //}
                }

                if (string.IsNullOrEmpty(strErrMsg))
                    _objRet.IsSuccess = true;
                else
                    _objRet.IsSuccess = false;
                _objRet.Message = strErrMsg;


                // obj.SaveMHCueSheet(objMHCueSheet);
                //int CueSheetCode = Convert.ToInt32(objMHCueSheet.MHCueSheetCode);
                Error.WriteLog_Conditional("STEP 4 A: Saving to Database Start");

                int CueSheetCodeOut = 0;
                obj.SaveCueSheet(dt, Convert.ToInt32(CueSheetCode), fileWithTimeStamp, Convert.ToInt32(UsersCode), out CueSheetCodeOut);

                Error.WriteLog_Conditional("STEP 4 B: Saving to Database End");
                _objRet.Message = "File Uploaded Successfully";

                Error.WriteLog("STEP 5: Upload Ended", includeTime: true, addSeperater: true);

                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);

                //return Request.CreateResponse(HttpStatusCode.Created, new
                //{
                //    _objRet = _objRet,
                //    strErrMsg = strErrMsg
                //}); ;

            }

            catch (Exception ex)
            {
                StringBuilder sb = new StringBuilder("Found Exception : " + ex.Message);
                while (ex.InnerException != null)
                {
                    ex = ex.InnerException;
                    sb.Append(" | Inner Exception : " + ex.Message);
                }
                _objRet.Message = ex.Message;
                Error.WriteLog_Conditional(sb.ToString(), addSeperater: true);
            }
            finally
            {
                Error.WriteLog("Upload Ended", includeTime: true, addSeperater: true);
            }


            return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
        }



        public static DataTable exceldata(string filePath)
        {
            Error.WriteLog_Conditional("Excel Function", addSeperater: true);
            DataTable dtexcel = new DataTable();
            DataTable dt = new DataTable();
            bool hasHeaders = false;
            string HDR = hasHeaders ? "Yes" : "No";
            string strConn;
            Error.WriteLog_Conditional("STEP 2 AA: OLEDB Con String", addSeperater: true);
            if (filePath.Substring(filePath.LastIndexOf('.')).ToLower() == ".xlsx")
                strConn = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" + filePath + ";Extended Properties=\"Excel 12.0;HDR=" + HDR + ";IMEX=0\"";
            else
                strConn = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + filePath + ";Extended Properties=\"Excel 8.0;HDR=" + HDR + ";IMEX=0\"";
            Error.WriteLog_Conditional("STEP 2 AB: OLEDB Con string = {" + strConn + "}", addSeperater: true);

            Error.WriteLog_Conditional("STEP 2 AC: OLEDB open Connection ");

            OleDbConnection conn = new OleDbConnection(strConn);
            conn.Open();
            DataTable schemaTable = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, new object[] { null, null, null, "TABLE" });
            //Looping Total Sheet of Xl File
            /*foreach (DataRow schemaRow in schemaTable.Rows)
            {
            }*/
            //Looping a first Sheet of Xl File
            DataRow schemaRow = schemaTable.Rows[0];
            string sheet = schemaRow["TABLE_NAME"].ToString();
            if (!sheet.EndsWith("_"))
            {
                string query = "SELECT  * FROM [CueSheet$]";
                OleDbDataAdapter daexcel = new OleDbDataAdapter(query, conn);
                dtexcel.Locale = CultureInfo.CurrentCulture;
                daexcel.Fill(dtexcel);
            }
            conn.Close();
            Error.WriteLog_Conditional("STEP 2 AC: OLEDB Close Conn");
            return dtexcel;

        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetCueSheetList(CueSheetListInput objCueSheetListInput)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");
            int RecordCount = 0;
            objCueSheetListInput.MHCueSheetCode = 0;

            try
            {
                var lstCueSheet = obj.GetCueSheetList(Convert.ToInt32(UsersCode), objCueSheetListInput, out RecordCount);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, CueSheet = lstCueSheet, RecordCount = RecordCount }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetCueSheetSongDetails(CueSheetDetailInput objCueSheetDetailInput)
        {
            Return _objRet = new Return();

            try
            {
                var lstCueSheetSongDetails = obj.GetCueSheetSongDetails(objCueSheetDetailInput);
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, CueSheetSongs = lstCueSheetSongDetails }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage CuesheetSubmit(MHCueSheet objMHCueSheet)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");

            objMHCueSheet = obj.GetByIdCueSheet(objMHCueSheet.MHCueSheetCode ?? 0);

            objMHCueSheet.UploadStatus = "S";
            objMHCueSheet.SubmitBy = Convert.ToInt32(UsersCode);
            objMHCueSheet.SubmitOn = System.DateTime.Now;

            try
            {
                obj.SubmitCueSheet(objMHCueSheet);
                obj.SendCueSheetForApproval(objMHCueSheet, Convert.ToInt32(UsersCode));
                _objRet.Message = "CueSheet Submitted Successfully";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage ExportCueSheetList(CueSheetListInput objCueSheetListInput)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");
            objCueSheetListInput.PagingRequired = "N";
            int RecordCount = 0;
            objCueSheetListInput.MHCueSheetCode = 0;

            try
            {
                var lstCueSheet = (List<USPMHGetCueSheetList>)obj.GetCueSheetList(Convert.ToInt32(UsersCode), objCueSheetListInput, out RecordCount);

                HttpResponseMessage response;
                response = Request.CreateResponse(HttpStatusCode.OK);
                MediaTypeHeaderValue mediaType = new MediaTypeHeaderValue("application/octet-stream");

                string Destination = HttpContext.Current.Server.MapPath("~/") + "Temp\\CueSheetList.xlsx";
                FileInfo OldFile = new FileInfo(HttpContext.Current.Server.MapPath("~/") + "Temp\\Sample1.xlsx");
                FileInfo newFile = new FileInfo(Destination);
                string Name = newFile.Name.ToString();
                if (newFile.Exists)
                {
                    newFile.Delete(); // ensures we create a new workbook
                    newFile = new FileInfo(Destination);
                }
                _objRet.Message = newFile.Name;
                var excelPackage = new ExcelPackage(newFile, OldFile);
                var sheet = excelPackage.Workbook.Worksheets["Sheet1"];
                sheet.Name = "Studio";

                sheet.Cells[1, 1].Value = "Request ID";
                sheet.Cells[1, 2].Value = "Date";
                sheet.Cells[1, 3].Value = "File Name";
                sheet.Cells[1, 4].Value = "Requested By";
                sheet.Cells[1, 5].Value = "Status";
                sheet.Cells[1, 6].Value = "Error Count";
                sheet.Cells[1, 7].Value = "Warning Records";
                sheet.Cells[1, 8].Value = "Success Records";

                for (int i = 1; i <= 8; i++)
                {
                    Color colFromHex = System.Drawing.ColorTranslator.FromHtml("#C0C0C0");
                    sheet.Cells[1, i].Style.Font.Bold = true;
                    sheet.Cells[1, i].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    sheet.Cells[1, i].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);
                    sheet.Cells[1, i].Style.Font.Size = 11;
                    sheet.Cells[1, i].Style.Font.Name = "Calibri";
                    sheet.Cells[1, i].Style.Fill.PatternType = ExcelFillStyle.Solid;
                    sheet.Cells[1, i].Style.Fill.BackgroundColor.SetColor(colFromHex);
                    sheet.Cells[1, i].AutoFitColumns();
                }

                ExcelColumn col1 = sheet.Column(1);
                ExcelColumn col2 = sheet.Column(2);
                ExcelColumn col3 = sheet.Column(3);
                ExcelColumn col4 = sheet.Column(4);
                ExcelColumn col5 = sheet.Column(5);
                ExcelColumn col6 = sheet.Column(6);
                ExcelColumn col7 = sheet.Column(7);
                ExcelColumn col8 = sheet.Column(8);
                col1.Width = 22;
                col2.Width = 18;
                col3.Width = 40;
                col4.Width = 20;
                col5.Width = 18;
                col6.Width = 15;
                col7.Width = 15;
                col8.Width = 15;

                for (int i = 0; i < lstCueSheet.Count; i++)
                {
                    DateTime dt = Convert.ToDateTime(lstCueSheet[i].RequestedDate.ToString());
                    string RequestedDate = dt.ToString("dd-MMM-yyyy");

                    sheet.Cells["A" + (i + 2)].Value = lstCueSheet[i].RequestID;
                    sheet.Cells["B" + (i + 2)].Value = RequestedDate;
                    sheet.Cells["C" + (i + 2)].Value = lstCueSheet[i].FileName;
                    sheet.Cells["D" + (i + 2)].Value = lstCueSheet[i].RequestedBy;
                    sheet.Cells["E" + (i + 2)].Value = lstCueSheet[i].Status;
                    sheet.Cells["F" + (i + 2)].Value = lstCueSheet[i].ErrorRecords;
                    sheet.Cells["G" + (i + 2)].Value = lstCueSheet[i].WarningRecords;
                    sheet.Cells["H" + (i + 2)].Value = lstCueSheet[i].SuccessRecords;
                    sheet.Cells["A" + (i + 2)].Style.HorizontalAlignment = ExcelHorizontalAlignment.Center;
                    //sheet.Cells["A" + (i + 2)].Style.Border.BorderAround(ExcelBorderStyle.Thin, System.Drawing.Color.Black);

                    sheet.Cells["A" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["B" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["C" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["D" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["E" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["F" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["G" + (i + 2)].Style.Font.Name = "Calibri";
                    sheet.Cells["H" + (i + 2)].Style.Font.Name = "Calibri";

                    sheet.Cells["F" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    sheet.Cells["G" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                    sheet.Cells["H" + (i + 2)].Style.HorizontalAlignment = OfficeOpenXml.Style.ExcelHorizontalAlignment.Center;
                }

                excelPackage.Workbook.Properties.Title = "PlanIT";
                excelPackage.Workbook.Properties.Author = "";
                excelPackage.Workbook.Properties.Comments = "";

                // set some extended property values
                excelPackage.Workbook.Properties.Company = "";

                // set some custom property values
                excelPackage.Workbook.Properties.SetCustomPropertyValue("Checked by", "");
                excelPackage.Workbook.Properties.SetCustomPropertyValue("AssemblyName", "EPPlus");
                // save our new workbook and we are done!
                excelPackage.Save();

                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage GetCueSheetStatus(MHCueSheet objMHCueSheet)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");
            int RecordCount = 0;
            int CueSheetCode = objMHCueSheet.MHCueSheetCode ?? 0;
            CueSheetListInput objCueSheetListInput = new CueSheetListInput
            {
                MHCueSheetCode = CueSheetCode,
                PagingRequired = "N",
                PageSize = 10,
                PageNo = 1,
                StatusCode = "",
                FromDate = "",
                ToDate = "",
                SortBy = "RequestedDate",
                Order = "DESC"
            };

            try
            {
                var lstCueSheet = obj.GetCueSheetList(Convert.ToInt32(UsersCode), objCueSheetListInput, out RecordCount).FirstOrDefault();
                if (lstCueSheet.Status == "Pending")
                    _objRet.Message = "No Status Changes.";
                else
                    _objRet.Message = lstCueSheet.Status;

                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, CueSheet = lstCueSheet, RecordCount = RecordCount }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage CueSheetSaveManually(MHCueSheet objMHCueSheet)
        {
            string UserCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UserCode = UserCode.Replace("Bearer ", "").Trim();

            var objU = new
            {
                Users_Code = Convert.ToInt32(UserCode),
            };
            MHUsers objUser = objMHUsersServices.SearchFor(objU).FirstOrDefault();

            string RequestID = obj.GetRequestID(objUser.Vendor_Code, "CS");

            objMHCueSheet.RequestID = RequestID;
            objMHCueSheet.UploadStatus = "P";
            objMHCueSheet.VendorCode = objUser.Vendor_Code;
            objMHCueSheet.TotalRecords = objMHCueSheet.MHCueSheetSong.ToList().Count();
            objMHCueSheet.ErrorRecords = 0;
            objMHCueSheet.CreatedBy = Convert.ToInt32(UserCode);
            objMHCueSheet.CreatedOn = System.DateTime.Now;

            Return _objRet = new Return();
            try
            {
                obj.CueSheetSaveManually(objMHCueSheet);

                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, RequestID = RequestID }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.Message.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }

            //  return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
        }

        [AcceptVerbs("GET", "POST")]
        [HttpPost]
        public HttpResponseMessage DownloadCuesheet(MHCueSheet objMHCueSheet)
        {
            Return _objRet = new Return();
            string UsersCode = Convert.ToString(this.ActionContext.Request.Headers.GetValues("userCode").FirstOrDefault());
            UsersCode = UsersCode.Replace("Bearer ", "");

            try
            {
                objMHCueSheet = obj.GetByIdCueSheet(objMHCueSheet.MHCueSheetCode ?? 0);
                string fullPath = HttpContext.Current.Server.MapPath("~/Uploads/" + objMHCueSheet.FileName);

                FileInfo file = new FileInfo(fullPath);

                if (!file.Exists)
                {
                    fullPath = "";
                }
                else
                {
                    fullPath = objMHCueSheet.FileName;
                }
                _objRet.Message = "";
                _objRet.IsSuccess = true;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet, FilePath = fullPath }, Configuration.Formatters.JsonFormatter);
            }
            catch (Exception ex)
            {
                _objRet.Message = ex.ToString();
                _objRet.IsSuccess = false;
                return Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
            }
        }

    }
}