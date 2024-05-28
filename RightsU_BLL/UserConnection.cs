using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace RightsU_BLL
{
    public class DBConnection
    {

        public static string Connection_Str
        {
            get
            {
                try
                {
                    if (HttpContext.Current.Session["Entity_Type"] == null)
                    {
                        return "RightsU_MotionPicture";
                    }
                    else
                    {
                        if (Convert.ToString(HttpContext.Current.Session["Entity_Type"]).ToUpper() ==
                            Convert.ToString(ConfigurationManager.AppSettings["RightsU_VMPL"]).ToUpper())
                        {
                            return "RightsU_MotionPicture";
                        }
                        return "RightsU_Broadcaster";
                    }
                }
                catch (Exception)
                {
                    return "RightsU_MotionPicture";
                }
            }
        }
    }
}
