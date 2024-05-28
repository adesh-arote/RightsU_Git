using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Web.UI;
using System.Web.UI.WebControls;
using UTOFrameWork.FrameworkClasses;
using System.Collections.Generic;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class Syn_Status_HistoryController : BaseController
    { 
        #region============Properties==================
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.Syn_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.Syn_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.Syn_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.Syn_DEAL_SCHEMA] = value; }
        }

        private string Module_Type
        {
            get
            {
                if (Session["Module_Type"] == null)
                    Session["Module_Type"] = "A";
                return Session["Module_Type"].ToString();
            }
            set { Session["Module_Type"] = value; }
        }
        #endregion

        #region Actions
        public PartialViewResult Index()
        {
            Module_Type = "S";
            int Deal_Code = objDeal_Schema.Deal_Code;
            objDeal_Schema.Page_From = GlobalParams.Page_From_StatusHistory;
            ObjectResult<USP_List_Status_History_Result> Obj_USP_List_Status_History = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Status_History(Deal_Code, GlobalParams.ModuleCodeForSynDeal);

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;

            Session["FileName"] = "";
            Session["FileName"] = "syn_StatusHistory";
            return PartialView("~/Views/Syn_Deal/_Syn_Status_History.cshtml", Obj_USP_List_Status_History.ToList());
        }

        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            ClearSession();
            objDeal_Schema = null;
            Session[UtoSession.SESS_DEAL] = null;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
                obj_Dic.Add("Page_No", pageNo.ToString());
                obj_Dic.Add("ReleaseRecord", "Y");
                TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
                return RedirectToAction("Index", "Syn_List");
            }
        }

        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);
        }
        #endregion

        private void ClearSession()
        {
            //objAD_Session = null;
            //objDeal = null;
        }
    }
}
