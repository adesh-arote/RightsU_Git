using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Acq_DealController : BaseController
    {
        public ActionResult Index()
        {
            string currentTab = Convert.ToString(Request.QueryString["currentTab"]);
            if (currentTab == null )
                currentTab = "GNR";
            
            ViewBag.currentTab = currentTab;
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            if (TempData["isAmort"] != null)
                ViewBag.IsAmort = TempData["isAmort"];
            else
                ViewBag.IsAmort = "N";

           return View("~/Views/Acq_Deal/Index.cshtml");
      
            
        }      
        public JsonResult GetCostTabConfigFromServer()
        {
            string isDirectCostGrid = "N";
            System_Parameter_New_Service objSystem_Parameter_New_Service = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName);
            System_Parameter_New objSystem_Parameter_New = new System_Parameter_New();
            objSystem_Parameter_New = objSystem_Parameter_New_Service.SearchFor(x => x.Parameter_Name == "Direct_Cost_Grid").FirstOrDefault();
            if (objSystem_Parameter_New != null)
            {
                if (objSystem_Parameter_New.Parameter_Value == "Y")
                {
                    isDirectCostGrid = "Y";
                }
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("IsDirectCostGrid", isDirectCostGrid);

            return Json(obj);
        }
    }
}
