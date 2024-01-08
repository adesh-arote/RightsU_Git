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
    }
}
