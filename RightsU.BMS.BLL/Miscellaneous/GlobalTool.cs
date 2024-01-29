using RightsU.BMS.BLL.Services;
using RightsU.BMS.Entities.FrameworkClasses;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;

namespace RightsU.BMS.BLL.Miscellaneous
{
    public static class GlobalTool
    {
        public static double DateToLinux(DateTime dateTimeToConvert)
        {
            DateTime dt = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Local);

            DateTime dtNow = dateTimeToConvert;
            TimeSpan result = dtNow.Subtract(dt);
            int seconds = Convert.ToInt32(result.TotalSeconds);
            return seconds;
        }

        public static DateTime LinuxToDate(double LinuxTimestamp)
        {
            DateTime dt = new DateTime(1970, 1, 1, 0, 0, 0, 0, DateTimeKind.Local);

            dt = dt.AddSeconds(LinuxTimestamp).ToLocalTime();
            return dt;
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
    }
}
