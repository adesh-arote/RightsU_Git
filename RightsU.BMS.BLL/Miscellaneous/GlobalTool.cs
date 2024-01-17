﻿using RightsU.BMS.BLL.Services;
using System;
using System.Collections.Generic;
using System.Linq;
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
    }
}
