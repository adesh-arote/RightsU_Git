using RightsU_Plus.Controllers;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            // filters.Add(new HandleErrorAttribute());
            filters.Add(new Custom_Error());
        }
    }
}