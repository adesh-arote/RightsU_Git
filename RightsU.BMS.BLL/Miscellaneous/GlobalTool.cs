using Newtonsoft.Json;
using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities.FrameworkClasses;
using RightsU.BMS.Entities.LogClasses;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.BLL.Miscellaneous
{
    public static class GlobalTool
    {
        public static double DateToLinux(DateTime dateTimeToConvert)
        {
            DateTime dt = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);

            DateTime dtNow = dateTimeToConvert;
            TimeSpan result = dtNow.Subtract(dt);
            int seconds = Convert.ToInt32(result.TotalSeconds);
            return seconds;
        }

        public static DateTime LinuxToDate(double LinuxTimestamp)
        {
            DateTime dt = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Utc);

            dt = dt.AddSeconds(LinuxTimestamp).ToLocalTime();
            return dt;
        }

        public static TimeSpan LinuxToTime(double LinuxTimestamp)
        {
            TimeSpan result = TimeSpan.FromHours(LinuxTimestamp);
            return result;
        }

        public static double TimeToLinux(TimeSpan TimeToConvert)
        {
            TimeSpan ts = TimeSpan.Parse(Convert.ToString(TimeToConvert), System.Globalization.CultureInfo.InvariantCulture);
            double seconds = ts.TotalSeconds;
            return seconds;
        }

        public static List<string> GetErrorList(List<string> lstErrorCodes)
        {
            string strQuery = string.Empty;

            strQuery = "SELECT Upload_Error_Code,Error_Description FROM Error_Code_Master WHERE Upload_Error_Code IN ('" + string.Join<string>("','", lstErrorCodes) + "')";

            return new Error_Code_MasterServices().SearchBySql(strQuery).Select(x => x.Upload_Error_Code + " : " + x.Error_Description).ToList();
        }

        public static GenericReturn SetError(GenericReturn _objRet, string ErrorCode)
        {
            //GenericReturn _objRet = new GenericReturn();

            _objRet.Message = "Error";
            _objRet.Errors.Add(ErrorCode);
            _objRet.IsSuccess = false;
            _objRet.StatusCode = HttpStatusCode.BadRequest;

            return _objRet;
        }

        public static int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }

        public async static Task<string> AuditLog(MasterAuditLog obj, string AuthKey)
        {
            int timeout = 3600;
            string result = "";

            try
            {
                string url = ConfigurationSettings.AppSettings["AuditLogURL"];
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);

                try
                {
                    request.KeepAlive = false;
                    request.ProtocolVersion = HttpVersion.Version10;
                    request.ContentType = "application/Json";
                    request.Method = "POST";
                    request.Headers.Add("ContentType", "application/json");
                    request.Headers.Add("AuthKey", AuthKey);

                    if (obj.logData == null)
                    {
                        obj.logData = "";
                    }

                    using (var streamWriter = new StreamWriter(request.GetRequestStream()))
                    {
                        string logData = JsonConvert.SerializeObject(obj);
                        streamWriter.Write(logData);
                    }

                    var httpResponse = (HttpWebResponse)request.GetResponse();

                    using (var streamReader = new StreamReader(httpResponse.GetResponseStream()))
                    {
                        result = streamReader.ReadToEnd();
                    }
                }
                catch (Exception ex)
                {
                    throw;
                    //request.Abort();
                    //LogService(JsonConvert.SerializeObject(obj));
                }
                if (result != "")
                {
                    //request posted successfully;	
                }
            }
            catch (Exception ex)
            {
                //LogService(JsonConvert.SerializeObject(obj));
                throw;
            }
            return result;
        }
    }
}
