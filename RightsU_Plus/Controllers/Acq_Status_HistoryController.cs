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
    public class Acq_Status_HistoryController : BaseController
    {
        #region============Properties==================
        public Deal_Schema objDeal_Schema
        {
            get
            {
                if (Session[RightsU_Session.ACQ_DEAL_SCHEMA] == null)
                    Session[RightsU_Session.ACQ_DEAL_SCHEMA] = new Deal_Schema();
                return (Deal_Schema)Session[RightsU_Session.ACQ_DEAL_SCHEMA];
            }
            set { Session[RightsU_Session.ACQ_DEAL_SCHEMA] = value; }
        }
        #endregion
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

        public PartialViewResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDeal);
            Module_Type = "A";
            int Deal_Code = objDeal_Schema.Deal_Code;
            objDeal_Schema.Page_From = GlobalParams.Page_From_StatusHistory;
            ObjectResult<USP_List_Status_History_Result> Obj_USP_List_Status_History = new USP_Service(objLoginEntity.ConnectionStringName).USP_List_Status_History(Deal_Code, GlobalParams.ModuleCodeForAcqDeal);

            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
            {
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            }
            else
                ViewBag.Record_Locking_Code = 0;

            Session["FileName"] = "";
           // TempData.Remove("FileName");
            Session["FileName"] = "acq_StatusHistory";
            return PartialView("~/Views/Acq_Deal/_Acq_Status_History.cshtml", Obj_USP_List_Status_History.ToList());
        }

        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            ClearSession();
            objDeal_Schema = null;
            Session[UtoSession.SESS_DEAL] = null;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            obj_Dic.Add("Page_No", pageNo.ToString());
            obj_Dic.Add("ReleaseRecord", "Y");
            TempData[GlobalParams.Cancel_From_Deal] = obj_Dic;
            if (TempData["TitleData"] != null)
            {
                return RedirectToAction("View", "Title");
            }
            else
            {
                return RedirectToAction("Index", "Acq_List");
            }
            //return RedirectToAction("Index", "Acq_List", new { Page_No = pageNo, ReleaseRecord = "Y" });
        }

        private void ClearSession()
        {
            //objAD_Session = null;
            //objDeal = null;
        }

        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code);
        }
    }
}
