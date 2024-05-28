using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class Syn_Run_ListController : BaseController
    {
        #region "--------------- Object ---------------"
        public int PageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = 0;
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
        }
        public Syn_Deal objSyn_Deal
        {
            get
            {
                if (Session[RightsU_Session.SESS_SYNDEAL] == null)
                    Session[RightsU_Session.SESS_SYNDEAL] = new Syn_Deal();
                return (Syn_Deal)Session[RightsU_Session.SESS_SYNDEAL];
            }
            set { Session[RightsU_Session.SESS_SYNDEAL] = value; }
        }
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

        #endregion

        public PartialViewResult Index(string hdnTitleCode = "")
        {
            if (TempData["QueryString_Run"] != null)
                TempData["QueryString_Run"] = null;
            objDeal_Schema.Page_From = GlobalParams.Page_From_Run;
            USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);
            var result = objUsp.USP_Validate_RIGHT_FOR_SYN_RUN(objDeal_Schema.Deal_Code);
            objSyn_Deal = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).GetById(objDeal_Schema.Deal_Code);
            ViewBag.IsRightsAdded = result.ElementAt(0).ToString();
            string Deal_Type_Condition = GlobalUtil.GetDealTypeCondition(objDeal_Schema.Deal_Type_Code);
            Syn_Deal_Movie_Service objADMS = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName);
            var titleList = objUsp.USP_GET_TITLE_FOR_SYN_RUN(objDeal_Schema.Deal_Code);
            ViewBag.TitleList = new MultiSelectList(titleList, "Title_Code", "Title_Name", hdnTitleCode.Split(','));
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                ViewBag.Record_Locking_Code = objDeal_Schema.Record_Locking_Code;
            else
                ViewBag.Record_Locking_Code = 0;
            return PartialView("~/Views/Syn_Deal/_Syn_Run_List.cshtml");
        }

        public PartialViewResult BindRun(string hdnTitleCode = "", int PageNumber = 0, int PageSize = 50)
        {
            USP_Service objUsp = new USP_Service(objLoginEntity.ConnectionStringName);
            if (hdnTitleCode == null || hdnTitleCode == "")
                hdnTitleCode = "0";
            List<USP_Syn_List_Runs_Result> pagedList = objUsp.USP_Syn_List_Runs(objDeal_Schema.Deal_Code, hdnTitleCode).ToList();
            List<USP_Syn_List_Runs_Result> list;
            PageNo = PageNumber + 1;
            if (PageNo == 1)
            {

                list = pagedList.Take(PageSize).ToList();
            }
            else
                list = pagedList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();
            ViewBag.RecordCount = pagedList.Count;
            ViewBag.PageNo = PageNo;
            objDeal_Schema.Run_PageNo = PageNumber;
            objDeal_Schema.Run_PageSize = PageSize;
            objDeal_Schema.Run_Titles = hdnTitleCode;
            return PartialView("~/Views/Syn_Deal/_List_Run.cshtml", list);
            //return PartialView("~/Views/Syn_Run_List/_Syn_List_Run.cshtml", list);
        }
        public void ResetMessageSession()
        {
            Session["Message"] = string.Empty;
        }
        public ActionResult ChangeTab(string hdnTabName)
        {
            return DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().RedirectToControl(hdnTabName, objDeal_Schema.PageNo, objDeal_Schema.Deal_Type_Code, GlobalParams.ModuleCodeForSynDeal);
        }
        public JsonResult Delete(int id)
        {
            Syn_Deal_Run_Service objADRS = new Syn_Deal_Run_Service(objLoginEntity.ConnectionStringName);
            Syn_Deal_Run objSyn_DR = objADRS.GetById(id);
            if (objSyn_DR != null)
            {

                if (objSyn_DR.Syn_Deal_Run_Yearwise_Run.Count() > 0)
                {
                    foreach (Syn_Deal_Run_Yearwise_Run objADRYR in objSyn_DR.Syn_Deal_Run_Yearwise_Run)
                    {
                        objADRYR.EntityState = State.Deleted;
                    }
                }
                if (objSyn_DR.Syn_Deal_Run_Repeat_On_Day.Count() > 0)
                {
                    foreach (Syn_Deal_Run_Repeat_On_Day objADRR in objSyn_DR.Syn_Deal_Run_Repeat_On_Day)
                    {
                        objADRR.EntityState = State.Deleted;
                    }
                }

                if (objSyn_DR.Syn_Deal_Run_Platform.Count() > 0)
                {
                    foreach (Syn_Deal_Run_Platform objSDRP in objSyn_DR.Syn_Deal_Run_Platform)
                        objSDRP.EntityState = State.Deleted;
                }
                objSyn_DR.EntityState = State.Deleted;
            }
            dynamic resultSet;
            objADRS.Save(objSyn_DR, out resultSet);
            return Json("Success");
        }

        public ActionResult Cancel()
        {
            int pageNo = objDeal_Schema.PageNo;
            if (objDeal_Schema.Mode != GlobalParams.DEAL_MODE_ADD && objDeal_Schema.Mode != GlobalParams.DEAL_MODE_VIEW)
                DBUtil.Release_Record(objDeal_Schema.Record_Locking_Code);
            objDeal_Schema = null;
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
        public ActionResult ButtonEvents(int? id)
        {
            Dictionary<string, string> obj_Dictionary = new Dictionary<string, string>();
            obj_Dictionary.Add("Syn_Deal_Run_Code", id.ToString());
            TempData["QueryString_Run"] = obj_Dictionary;
            string tabName = GlobalParams.Page_From_Run_Detail_AddEdit;
            if (objDeal_Schema.Mode == GlobalParams.DEAL_MODE_VIEW || objDeal_Schema.Mode == GlobalParams.DEAL_MODE_APPROVE)
                tabName = GlobalParams.Page_From_Run_Detail_View;//return RedirectToAction("View", "Syn_Run");
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("TabName", tabName);
            return Json(obj);
            //return RedirectToAction("Index", "Syn_Run");
        }

        public ActionResult CheckTitlesForRun()
        {
            bool EnableAddButton = true;
           List<string> lstPlatformCodes_IsRun = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Applicable_Syn_Run== "Y").Select(x => x.Platform_Code.ToString()).ToList();
            List<Syn_Deal_Rights> lstSyn_Deal_Rights = objSyn_Deal.Syn_Deal_Rights.Where(x => x.Right_Status == "C" && x.Is_Pushback == "N").ToList();
            foreach (Syn_Deal_Rights item in lstSyn_Deal_Rights)
            {
                List<string> lstPlatformCodes = item.Syn_Deal_Rights_Platform.Select(x => x.Platform_Code.ToString()).ToList();
                int count_LinerPlatformCodes = lstPlatformCodes_IsRun.Where(x => lstPlatformCodes.Contains(x)).Count();
                EnableAddButton = count_LinerPlatformCodes > 0 ? true : false;
            }

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("EnableAddButton", EnableAddButton);
            return Json(obj);
        }
    }
}
