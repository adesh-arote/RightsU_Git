using Newtonsoft.Json;
using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities;
using RightsU.BMS.Entities.Master_Entities;
using Swashbuckle.Swagger.Annotations;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Web;
using System.Web.Http;

namespace RightsU.BMS.WebAPI.Controllers
{
    [SwaggerConsumes("application/json")]
    [SwaggerProduces("application/json")]
    public class scheduleuploadController : ApiController
    {
        private readonly Channel_Service objChannelServices = new Channel_Service();
        private readonly BMS_Schedule_Import_Config_Service objBMSScheduleImportConfigServices = new BMS_Schedule_Import_Config_Service();
        private readonly BMSServices objBMSServices = new BMSServices();
        private readonly BMS_Log_Service objBMSLogServices = new BMS_Log_Service();

        /// <summary>
        /// Text File Process Detail
        /// </summary>
        /// <remarks>This Api read uploaded text file and insert data into table</remarks>
        /// <param name="UploadFile">File Object</param> //HttpPostedFileBase UploadFile,
        /// <param name="ChannelName">Channel Name</param>
        /// <returns></returns>               
        [SwaggerResponse(HttpStatusCode.OK, "Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPost]
        [ActionName("scheduleuploadtxt")]
        public HttpResponseMessage scheduleuploadtxt(string ChannelName = null )
        {
            Return _objRet = new Return();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;

            ScheduleInput ScheduleInput = new ScheduleInput();
            ScheduleInput.FileType = "Text";
            ScheduleInput.ChannelName = ChannelName;

            BMS_Log objLog = new BMS_Log();
            objLog.Request_Time = DateTime.Now;
            objLog.Module_Name = "BMS_Schedule";
            objLog.Method_Type = Request.Method.Method;
            objLog.Record_Status = "D";            

            string IsUseForAsRun = "";
            int? ChannelCode = 0;
            string UploadFileName = "";

            try
            {
                ChannelName = Convert.ToString(this.ActionContext.Request.Headers.GetValues("ChannelName").FirstOrDefault());
                ChannelCode = objChannelServices.SearchFor(new { Channel_Name = ChannelName.Trim() }).Select(x => (x.Channel_Code)).SingleOrDefault();

                if (!string.IsNullOrEmpty(Convert.ToString(ChannelCode)) && ChannelCode != 0)
                {
                    IsUseForAsRun = objChannelServices.SearchFor(new { Channel_Code = ChannelCode }).Select(x => (x.IsUseForAsRun)).SingleOrDefault();
                    if (string.IsNullOrEmpty(IsUseForAsRun))
                    {
                        _objRet.Message = "Channel Is Not Activated, Please Contact Administrator.";
                        _objRet.IsSuccess = false;
                        objLog.Record_Status = "E";
                        objLog.Error_Description = _objRet.Message;
                    }
                }
                else
                {
                    _objRet.Message = "Channel Not Mapped.";
                    _objRet.IsSuccess = false;
                    objLog.Record_Status = "E";
                    objLog.Error_Description = _objRet.Message;
                }

                var httpRequest = HttpContext.Current.Request;
                var fileWithTimeStamp = "";
                DataTable datatable = new DataTable();

                if (httpRequest.Files.Count > 0 && _objRet.IsSuccess)
                {
                    foreach (string file in httpRequest.Files)
                    {
                        var postedFile = httpRequest.Files[file];
                        string extension = System.IO.Path.GetExtension(postedFile.FileName);
                        if (extension == ".txt")
                        {
                            fileWithTimeStamp = Path.GetFileNameWithoutExtension(postedFile.FileName) + "_" + DateTime.Now.ToFileTime() + Path.GetExtension(postedFile.FileName);
                            var fileName = Path.GetFileNameWithoutExtension(postedFile.FileName) + Path.GetExtension(postedFile.FileName);
                            var filePath = HttpContext.Current.Server.MapPath("~/Uploads/TextFile/" + fileWithTimeStamp);
                            postedFile.SaveAs(filePath);

                            UploadFileName = Convert.ToString(fileWithTimeStamp);

                            StreamReader streamreader = new StreamReader(filePath);
                            char[] delimiter = new char[] { '\t' };
                            string[] columnheaders = streamreader.ReadLine().Split(delimiter);
                            foreach (string columnheader in columnheaders)
                            {
                                datatable.Columns.Add(columnheader);
                            }

                            while (streamreader.Peek() > 0)
                            {
                                int i = 0;
                                DataRow datarow = datatable.NewRow();
                                datarow.ItemArray = streamreader.ReadLine().Split(delimiter);
                                datatable.Rows.Add(datarow);
                            }

                            if (datatable.Rows.Count > 0)
                            {
                                List<BMS_Schedule_Import_Config> objBMSScheduleImportConfig = new List<BMS_Schedule_Import_Config>();
                                objBMSScheduleImportConfig = objBMSScheduleImportConfigServices.SearchFor(new { File_Format = "txt" }).ToList();

                                if (objBMSScheduleImportConfig.Count > 0)
                                {
                                    List<Schedule_Data_UDT> ScheduleDataUDT = new List<Schedule_Data_UDT>();
                                    foreach (DataRow row in datatable.Rows)
                                    {
                                        Schedule_Data_UDT ScheduleData = new Schedule_Data_UDT();
                                        foreach (DataColumn column in datatable.Columns)
                                        {
                                            string Input_Column_Name = objBMSScheduleImportConfig.Where(w => w.Input_Column_Name == column.ColumnName.Replace("\"", "")).Select(l => l.Input_Column_Name).FirstOrDefault();
                                            if (!string.IsNullOrEmpty(Input_Column_Name))
                                            {

                                                if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                    ScheduleData.Program_Episode_ID = row["\"Program Episode ID\""].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Program Title")
                                                    ScheduleData.Program_Episode_Title = row["\"Program Title\""].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Program Episode Number")
                                                    ScheduleData.Program_Episode_Number = row["\"Program Episode Number\""].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Program Category")
                                                    ScheduleData.Program_Category = row["\"Program Category\""].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Program Version ID")
                                                    ScheduleData.Program_Version_ID = row["\"Program Version ID\""].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Schedule Item Log Date")
                                                    ScheduleData.Schedule_Item_Log_Date = row["\"Schedule Item Log Date\""].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Schedule Item Log Time")
                                                    ScheduleData.Schedule_Item_Log_Time = row["\"Schedule Item Log Time\""].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Schedule Item Duration")
                                                    ScheduleData.Schedule_Item_Duration = row["\"Schedule Item Duration\""].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Scheduled Version House Number List")
                                                    ScheduleData.Scheduled_Version_House_Number_List = row["\"Scheduled Version House Number List\""].ToString().Replace("\"", "");
                                                //if (column.ColumnName.Replace("\"", "") == "Program Title")
                                                //    ScheduleData.Program_Title = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.File_Code = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Channel_Code = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Inserted_By = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Inserted_On = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.IsDealApproved = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.TitleCode = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.DMCode = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Deal_Code = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Deal_Type = "";  
                                            }
                                        }
                                        ScheduleDataUDT.Add(ScheduleData);
                                    }

                                    if (ScheduleDataUDT.Count > 0)
                                    {
                                        ListtoDataTable lstToDataTable = new ListtoDataTable();
                                        DataTable dt = lstToDataTable.ToDataTable(ScheduleDataUDT);
                                        if (dt.Rows.Count > 0)
                                        {
                                            int id = objBMSServices.BMSUploadData(dt, "txt", Convert.ToInt32(ChannelCode));
                                            if (id > 0)
                                            {
                                                //if ((System.IO.File.Exists(filePath)))
                                                //{
                                                //    System.IO.File.Delete(filePath);
                                                //}

                                                _objRet.Message = "File Uploaded Successfully";
                                                _objRet.IsSuccess = true;
                                            }
                                            else
                                            {
                                                _objRet.Message = "Error";
                                                _objRet.IsSuccess = false;
                                                objLog.Record_Status = "E";
                                                objLog.Error_Description = _objRet.Message;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            _objRet.Message = "Please Upload Text File";
                            _objRet.IsSuccess = false;
                            objLog.Record_Status = "E";
                            objLog.Error_Description = _objRet.Message;
                        }
                    }
                }

                ScheduleInput.FileName = UploadFileName;
                objLog.Request_Xml = JsonConvert.SerializeObject(ScheduleInput);
                objLog.Response_Time = DateTime.Now;
                _objRet.LogId = objBMSLogServices.InsertLog(objLog);
            }
            catch(Exception ex)
            {
                objLog.Request_Xml = JsonConvert.SerializeObject(ScheduleInput);
                objLog.Record_Status = "E";
                objLog.Error_Description = _objRet.Message;
                objLog.Response_Time = DateTime.Now;
                ScheduleInput.FileName = UploadFileName;
                objLog.Request_Xml = JsonConvert.SerializeObject(ScheduleInput);
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
                _objRet.LogId = objBMSLogServices.InsertLog(objLog);

                var response = Request.CreateResponse(HttpStatusCode.InternalServerError, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("LogId", _objRet.LogId.ToString());
                response.Headers.Add("Message", _objRet.Message);
                response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                return response;
            }            

            if (_objRet.IsSuccess)
            {
                var response = Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("LogId", _objRet.LogId.ToString());
                response.Headers.Add("Message", _objRet.Message);
                response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                return response;
            }
            else
            {
                var response = Request.CreateResponse(HttpStatusCode.BadRequest, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("LogId", _objRet.LogId.ToString());
                response.Headers.Add("Message", _objRet.Message);
                response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                return response;
            }
        }

        /// <summary>
        /// Text File Process Detail
        /// </summary>
        /// <remarks>This Api read uploaded CSV file and insert data into table</remarks>
        /// <param name="UploadFile">File Object</param> //HttpPostedFileBase UploadFile,
        /// <param name="ChannelName">Channel Name</param>
        /// <returns></returns>               
        [SwaggerResponse(HttpStatusCode.OK, "Success")]
        [SwaggerResponse(HttpStatusCode.BadRequest, "Validation Error")]
        [SwaggerResponse(HttpStatusCode.InternalServerError, "Internal Server Error")]
        [HttpPost]
        [ActionName("scheduleuploadcsv")]
        public HttpResponseMessage scheduleuploadcsv(string ChannelName = null)
        {
            Return _objRet = new Return();
            _objRet.Message = "Success";
            _objRet.IsSuccess = true;

            ScheduleInput ScheduleInput = new ScheduleInput();
            ScheduleInput.FileType = "Text";
            ScheduleInput.ChannelName = ChannelName;

            BMS_Log objLog = new BMS_Log();
            objLog.Request_Time = DateTime.Now;
            objLog.Module_Name = "BMS_Schedule";
            objLog.Method_Type = Request.Method.Method;
            objLog.Record_Status = "D";                     

            string IsUseForAsRun = "";
            int? ChannelCode = 0;
            string UploadFileName = "";

            try
            {
                ChannelName = Convert.ToString(this.ActionContext.Request.Headers.GetValues("ChannelName").FirstOrDefault());
                ChannelCode = objChannelServices.SearchFor(new { Channel_Name = ChannelName.Trim() }).Select(x => (x.Channel_Code)).SingleOrDefault();

                if (!string.IsNullOrEmpty(Convert.ToString(ChannelCode)) && ChannelCode != 0)
                {
                    IsUseForAsRun = objChannelServices.SearchFor(new { Channel_Code = ChannelCode }).Select(x => (x.IsUseForAsRun)).SingleOrDefault();
                    if (string.IsNullOrEmpty(IsUseForAsRun))
                    {
                        _objRet.Message = "Channel Is Not Activated, Please Contact Administrator.";
                        _objRet.IsSuccess = false;
                        objLog.Record_Status = "E";
                        objLog.Error_Description = _objRet.Message;
                    }
                }
                else
                {
                    _objRet.Message = "Channel Not Mapped.";
                    _objRet.IsSuccess = false;
                    objLog.Record_Status = "E";
                    objLog.Error_Description = _objRet.Message;
                }

                var httpRequest = HttpContext.Current.Request;
                var fileWithTimeStamp = "";
                DataTable datatable = new DataTable();

                if (httpRequest.Files.Count > 0 && _objRet.IsSuccess)
                {
                    foreach (string file in httpRequest.Files)
                    {
                        var postedFile = httpRequest.Files[file];
                        string extension = System.IO.Path.GetExtension(postedFile.FileName);
                        if (extension == ".csv")
                        {
                            fileWithTimeStamp = Path.GetFileNameWithoutExtension(postedFile.FileName) + "_" + DateTime.Now.ToFileTime() + Path.GetExtension(postedFile.FileName);
                            var fileName = Path.GetFileNameWithoutExtension(postedFile.FileName) + Path.GetExtension(postedFile.FileName);
                            var filePath = HttpContext.Current.Server.MapPath("~/Uploads/CSVFile/" + fileWithTimeStamp);
                            postedFile.SaveAs(filePath);

                            UploadFileName = Convert.ToString(fileWithTimeStamp);

                            StreamReader streamreader = new StreamReader(filePath);
                            char[] delimiter = new char[] { ',' };
                            string[] columnheaders = streamreader.ReadLine().Split(delimiter);
                            foreach (string columnheader in columnheaders)
                            {
                                datatable.Columns.Add(columnheader);
                            }

                            while (streamreader.Peek() > 0)
                            {
                                DataRow datarow = datatable.NewRow();
                                datarow.ItemArray = streamreader.ReadLine().Split(delimiter);
                                datatable.Rows.Add(datarow);
                            }

                            if (datatable.Rows.Count > 0)
                            {
                                List<BMS_Schedule_Import_Config> objBMSScheduleImportConfig = new List<BMS_Schedule_Import_Config>();
                                objBMSScheduleImportConfig = objBMSScheduleImportConfigServices.SearchFor(new { File_Format = "csv" }).ToList();

                                if (objBMSScheduleImportConfig.Count > 0)
                                {
                                    List<Schedule_Data_UDT> ScheduleDataUDT = new List<Schedule_Data_UDT>();
                                    foreach (DataRow row in datatable.Rows)
                                    {
                                        Schedule_Data_UDT ScheduleData = new Schedule_Data_UDT();
                                        foreach (DataColumn column in datatable.Columns)
                                        {
                                            string Input_Column_Name = objBMSScheduleImportConfig.Where(w => w.Input_Column_Name == column.ColumnName.Replace("\"", "")).Select(l => l.Input_Column_Name).FirstOrDefault();
                                            if (!string.IsNullOrEmpty(Input_Column_Name))
                                            {

                                                if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                    ScheduleData.Program_Episode_ID = row["Program Episode ID"].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Program Title")
                                                    ScheduleData.Program_Episode_Title = row["Program Title"].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Program Episode Number")
                                                    ScheduleData.Program_Episode_Number = row["Program Episode Number"].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Program Category")
                                                    ScheduleData.Program_Category = row["Program Category"].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Program Version ID")
                                                    ScheduleData.Program_Version_ID = row["Program Version ID"].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Schedule Item Log Date")
                                                    ScheduleData.Schedule_Item_Log_Date = row["Schedule Item Log Date"].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Schedule Item Log Time")
                                                    ScheduleData.Schedule_Item_Log_Time = row["Schedule Item Log Time"].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Schedule Item Duration")
                                                    ScheduleData.Schedule_Item_Duration = row["Schedule Item Duration"].ToString().Replace("\"", "");
                                                if (column.ColumnName.Replace("\"", "") == "Scheduled Version House Number List")
                                                    ScheduleData.Scheduled_Version_House_Number_List = row["Scheduled Version House Number List"].ToString().Replace("\"", "");
                                                //if (column.ColumnName.Replace("\"", "") == "Program Title")
                                                //    ScheduleData.Program_Title = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.File_Code = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Channel_Code = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Inserted_By = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Inserted_On = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.IsDealApproved = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.TitleCode = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.DMCode = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Deal_Code = "";
                                                //if (column.ColumnName.Replace("\"", "") == "Program Episode ID")
                                                //    ScheduleData.Deal_Type = "";  
                                            }
                                        }
                                        ScheduleDataUDT.Add(ScheduleData);
                                    }

                                    if (ScheduleDataUDT.Count > 0)
                                    {
                                        ListtoDataTable lstToDataTable = new ListtoDataTable();
                                        DataTable dt = lstToDataTable.ToDataTable(ScheduleDataUDT);
                                        if (dt.Rows.Count > 0)
                                        {
                                            int id = objBMSServices.BMSUploadData(dt, "csv", Convert.ToInt32(ChannelCode));
                                            if (id > 0)
                                            {
                                                _objRet.Message = "File Uploaded Successfully";
                                                _objRet.IsSuccess = true;
                                            }
                                            else
                                            {
                                                _objRet.Message = "Error";
                                                _objRet.IsSuccess = false;
                                                objLog.Record_Status = "E";
                                                objLog.Error_Description = _objRet.Message;
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        else
                        {
                            _objRet.Message = "Please Upload Text File";
                            _objRet.IsSuccess = false;
                            objLog.Record_Status = "E";
                            objLog.Error_Description = _objRet.Message;
                        }
                    }
                }

                ScheduleInput.FileName = UploadFileName;
                objLog.Request_Xml = JsonConvert.SerializeObject(ScheduleInput);
                objLog.Response_Time = DateTime.Now;
                _objRet.LogId = objBMSLogServices.InsertLog(objLog);

            }
            catch(Exception ex)
            {                
                objLog.Request_Xml = JsonConvert.SerializeObject(ScheduleInput);
                objLog.Record_Status = "E";
                objLog.Error_Description = _objRet.Message;
                objLog.Response_Time = DateTime.Now;
                ScheduleInput.FileName = UploadFileName;
                objLog.Request_Xml = JsonConvert.SerializeObject(ScheduleInput);
                _objRet.Message = ex.Message;
                _objRet.IsSuccess = false;
                _objRet.LogId = objBMSLogServices.InsertLog(objLog);

                var response = Request.CreateResponse(HttpStatusCode.InternalServerError, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("LogId", _objRet.LogId.ToString());
                response.Headers.Add("Message", _objRet.Message);
                response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                return response;
            }            

            if (_objRet.IsSuccess)
            {
                var response = Request.CreateResponse(HttpStatusCode.OK, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("LogId", _objRet.LogId.ToString());
                response.Headers.Add("Message", _objRet.Message);
                response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                return response;
            }
            else
            {
                var response = Request.CreateResponse(HttpStatusCode.BadRequest, new { Return = _objRet }, Configuration.Formatters.JsonFormatter);
                response.Headers.Add("LogId", _objRet.LogId.ToString());
                response.Headers.Add("Message", _objRet.Message);
                response.Headers.Add("IsSuccess", _objRet.IsSuccess.ToString());
                return response;
            }
        }
    }

    public class Schedule_Data_UDT
    {
        public string Program_Episode_ID { get; set; }
        public string Program_Episode_Title { get; set; }
        public string Program_Episode_Number { get; set; }
        public string Program_Category { get; set; }
        public string Program_Version_ID { get; set; }
        public string Schedule_Item_Log_Date { get; set; }
        public string Schedule_Item_Log_Time { get; set; }
        public string Schedule_Item_Duration { get; set; }
        public string Scheduled_Version_House_Number_List { get; set; }
        public string Program_Title { get; set; }
        public string File_Code { get; set; }
        public string Channel_Code { get; set; }
        public string Inserted_By { get; set; }
        public string Inserted_On { get; set; }
        public string IsDealApproved { get; set; }
        public string TitleCode { get; set; }
        public string DMCode { get; set; }
        public string Deal_Code { get; set; }
        public string Deal_Type { get; set; }
    }

    public class ListtoDataTable
    {
        public DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);
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
    public class ScheduleInput
    {
        /// <summary>
        /// File Name
        /// </summary>
        public string FileName { get; set; }
        /// <summary>
        /// File Type
        /// </summary>
        public string FileType { get; set; }
        /// <summary>
        /// Channel Name
        /// </summary>
        public string ChannelName { get; set; }
    }
}
