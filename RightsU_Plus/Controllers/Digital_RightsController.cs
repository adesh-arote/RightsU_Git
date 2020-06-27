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
    public class Digital_RightsController : BaseController
    {
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            //get { return new Deal_Schema(); }
            set
            {
                Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value;
            }
        }

        //public ActionResult Index()
        //{
        //    return View();
        //}
        public PartialViewResult DigitalRights()
        {
            ViewBag.IsActive = "Y";
            objDeal_Schema.Page_From = GlobalParams.Page_From_Digital_Rights;
            return PartialView("~/Views/Acq_Deal/_Digital_Rights_List.cshtml");
        }

        public PartialViewResult AddEditDigitalRights()
        {

            return PartialView("~/Views/Acq_Deal/_Digital_Rights_AddEdit.cshtml");
        }

        public ActionResult Digital()
        {
            return View("~/Views/Shared/Demo_Digital/DigitalAsset.cshtml");
        }

        public ActionResult DigitalAsset()
        {
            return View("~/Views/Digital_Rights/Digital_Assets.cshtml");
        }

        public ActionResult SchedulingInstruction()
        {
            return View("~/Views/Digital_Rights/Scheduling_Instruction.cshtml");
        }

        public ActionResult ConsumptionReport()
        {
            return View("~/Views/Digital_Rights/Consumption_Report.cshtml");
        }
        public PartialViewResult BindPlatformTreeView(string strPlatform, string Mode)
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            objPTV.PlatformCodes_Selected = strPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            // objPTV.PlatformCodes_Display = strPlatform;
            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            if (Mode == "A")
                ViewBag.TreeId = "Rights_Platform";
            else if (Mode == "V")
                ViewBag.TreeId = "Rights_PlatformV";
            else
                ViewBag.TreeId = "Rights_Platforms";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }

    }
}
