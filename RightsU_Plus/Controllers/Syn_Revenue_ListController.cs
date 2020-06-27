using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class Syn_Revenue_ListController : Controller
    {        
        // GET: /Syn_Revenue_List/
        public PartialViewResult Index()
        {
            return PartialView("~/Views/Syn_Deal/_Syn_Revenue_List.cshtml");
        }
    }
}
