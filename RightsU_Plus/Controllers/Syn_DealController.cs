using RightsU_BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_DealController : BaseController
    {
        //
        // GET: /Syn_Deal/
        public ActionResult Index()
        {
            string currentTab = Convert.ToString(Request.QueryString["currentTab"]);
            if (currentTab == null)
                currentTab = "GNR";
            ViewBag.currentTab = currentTab;
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForSynDeal);
            Session["FileName"] = "";
            Session["FileName"] = "SyndicationDeals";
            return View("~/Views/Syn_Deal/Index.cshtml");
        }

        public JsonResult GetSynRightStatus(int rightCode, int dealCode)
        {
            string recordStatus = "P";
            if (rightCode > 0 )
            {
                recordStatus = new Syn_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal_Rights_Code == rightCode).Select(x => x.Right_Status).FirstOrDefault();
            }
            else
            {
                recordStatus = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetSynRightStatus(rightCode, dealCode).FirstOrDefault();
            }

            var obj = new { RecordStatus = recordStatus };
            return Json(obj);
        }

    }
}
