using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.SessionState;
using RightsU_BLL;
using RightsU_Entities;
using UTOFrameWork.FrameworkClasses;
using System.Data.Entity.Core.Objects;
using System.Reflection;
//using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class BaseController : Controller
    {
        public USP_Service objUSP_Service
        {
            get
            {
                if (Session["USP_Service"] == null)
                    Session["USP_Service"] = new USP_Service(objLoginEntity.ConnectionStringName);
                return (USP_Service)Session["USP_Service"];
            }
            set { Session["USP_Service"] = value; }
        }

        public MessageKey objMessageKey
        {
            get
            {
                if (Session["objMessageKey"] == null)
                    Session["objMessageKey"] = new MessageKey();
                return (MessageKey)Session["objMessageKey"];
            }
            set { Session["objMessageKey"] = value; }
        }

        public LoginEntity objLoginEntity
        {
            get
            {
                if (Session[RightsU_Session.CurrentLoginEntity] == null)
                    Session[RightsU_Session.CurrentLoginEntity] = new LoginEntity();
                return (LoginEntity)Session[RightsU_Session.CurrentLoginEntity];
            }
            set { Session[RightsU_Session.CurrentLoginEntity] = value; }
        }
        private List<Email_Notification_Log> lstEmail_Notification_Log
        {
            get
            {
                if (Session["lstEmail_Notification_Log"] == null)
                    Session["lstEmail_Notification_Log"] = new List<Email_Notification_Log>();
                return (List<Email_Notification_Log>)Session["lstEmail_Notification_Log"];
            }

            set
            {
                Session["lstEmail_Notification_Log"] = value;
            }
        }

        public User objLoginUser { get; set; }
        List<int> arrUserRight;
        List<string> arrSysyem_Module_Language;
        #region --- Page No's ---
        int PageSize = 5;
        private int DealStartAndExp_Days
        {
            get
            {
                if (Session["DealStartAndExp_Days"] == null)
                    Session["DealStartAndExp_Days"] = 0;
                return Convert.ToInt32(Session["DealStartAndExp_Days"]);
            }
            set
            {
                Session["DealStartAndExp_Days"] = value;
            }
        }

        private int StartAcqDealListCount
        {
            get
            {
                if (Session["StartAcqDealListCount"] == null)
                    Session["StartAcqDealListCount"] = 0;
                return Convert.ToInt32(Session["StartAcqDealListCount"]);
            }
            set
            {
                Session["StartAcqDealListCount"] = value;
            }
        }
        private int StartSynDealListCount
        {
            get
            {
                if (Session["StartSynDealListCount"] == null)
                    Session["StartSynDealListCount"] = 0;
                return Convert.ToInt32(Session["StartSynDealListCount"]);
            }
            set
            {
                Session["StartSynDealListCount"] = value;
            }
        }
        private int ExpireAcqDealListCount
        {
            get
            {
                if (Session["ExpireAcqDealListCount"] == null)
                    Session["ExpireAcqDealListCount"] = 0;
                return Convert.ToInt32(Session["ExpireAcqDealListCount"]);
            }
            set
            {
                Session["ExpireAcqDealListCount"] = value;
            }
        }
        private int ExpireSynDealDataListCount
        {
            get
            {
                if (Session["ExpireSynDealDataListCount"] == null)
                    Session["ExpireSynDealDataListCount"] = 0;
                return Convert.ToInt32(Session["ExpireSynDealDataListCount"]);
            }
            set
            {
                Session["ExpireSynDealDataListCount"] = value;
            }
        }
        private int ROFR_AcquisitionListCount
        {
            get
            {
                if (Session["ROFR_AcquisitionListCount"] == null)
                    Session["ROFR_AcquisitionListCount"] = 0;
                return Convert.ToInt32(Session["ROFR_AcquisitionListCount"]);
            }
            set
            {
                Session["ROFR_AcquisitionListCount"] = value;
            }
        }
        private int TentativeStartAcquDealsListCount
        {
            get
            {
                if (Session["TentativeStartAcquDealsListCount"] == null)
                    Session["TentativeStartAcquDealsListCount"] = 0;
                return Convert.ToInt32(Session["TentativeStartAcquDealsListCount"]);
            }
            set
            {
                Session["TentativeStartAcquDealsListCount"] = value;
            }
        }
        private int AprovedAcqDealListCount
        {
            get
            {
                if (Session["AprovedAcqDealListCount"] == null)
                    Session["AprovedAcqDealListCount"] = 0;
                return Convert.ToInt32(Session["AprovedAcqDealListCount"]);
            }
            set
            {
                Session["AprovedAcqDealListCount"] = value;
            }
        }
        private int AproveSynDealListCount
        {
            get
            {
                if (Session["AproveSynDealListCount"] == null)
                    Session["AproveSynDealListCount"] = 0;
                return Convert.ToInt32(Session["AproveSynDealListCount"]);
            }
            set
            {
                Session["AproveSynDealListCount"] = value;
            }
        }

        private int StartAcqDealList_PageNo
        {
            get
            {
                if (Session["StartAcqDealList_PageNo"] == null)
                    Session["StartAcqDealList_PageNo"] = 0;
                return Convert.ToInt32(Session["StartAcqDealList_PageNo"]);
            }
            set
            {
                Session["StartAcqDealList_PageNo"] = value;
            }
        }
        private int StartSynDealList_PageNo
        {
            get
            {
                if (Session["StartSynDealList_PageNo"] == null)
                    Session["StartSynDealList_PageNo"] = 0;
                return Convert.ToInt32(Session["StartSynDealList_PageNo"]);
            }
            set
            {
                Session["StartSynDealList_PageNo"] = value;
            }
        }
        private int ExpireAcqDealList_PageNo
        {
            get
            {
                if (Session["ExpireAcqDealList_PageNo"] == null)
                    Session["ExpireAcqDealList_PageNo"] = 0;
                return Convert.ToInt32(Session["ExpireAcqDealList_PageNo"]);
            }
            set
            {
                Session["ExpireAcqDealList_PageNo"] = value;
            }
        }
        private int ExpireSynDealDataList_PageNo
        {
            get
            {
                if (Session["ExpireSynDealDataList_PageNo"] == null)
                    Session["ExpireSynDealDataList_PageNo"] = 0;
                return Convert.ToInt32(Session["ExpireSynDealDataList_PageNo"]);
            }
            set
            {
                Session["ExpireSynDealDataList_PageNo"] = value;
            }
        }
        private int ROFR_AcquisitionList_PageNo
        {
            get
            {
                if (Session["ROFR_AcquisitionList_PageNo"] == null)
                    Session["ROFR_AcquisitionList_PageNo"] = 0;
                return Convert.ToInt32(Session["ROFR_AcquisitionList_PageNo"]);
            }
            set
            {
                Session["ROFR_AcquisitionList_PageNo"] = value;
            }
        }
        private int TentativeStartAcquDealsList_PageNo
        {
            get
            {
                if (Session["TentativeStartAcquDealsList_PageNo"] == null)
                    Session["TentativeStartAcquDealsList_PageNo"] = 0;
                return Convert.ToInt32(Session["TentativeStartAcquDealsList_PageNo"]);
            }
            set
            {
                Session["TentativeStartAcquDealsList_PageNo"] = value;
            }
        }
        private int AprovedAcqDealList_PageNo
        {
            get
            {
                if (Session["AprovedAcqDealList_PageNo"] == null)
                    Session["AprovedAcqDealList_PageNo"] = 0;
                return Convert.ToInt32(Session["AprovedAcqDealList_PageNo"]);
            }
            set
            {
                Session["AprovedAcqDealList_PageNo"] = value;
            }
        }
        private int AproveSynDealList_PageNo
        {
            get
            {
                if (Session["AproveSynDealList_PageNo"] == null)
                    Session["AproveSynDealList_PageNo"] = 0;
                return Convert.ToInt32(Session["AproveSynDealList_PageNo"]);
            }
            set
            {
                Session["AproveSynDealList_PageNo"] = value;
            }
        }

        private int StartAcqDealList_LastPageNo
        {
            get
            {
                if (Session["StartAcqDealList_LastPageNo"] == null)
                    Session["StartAcqDealList_LastPageNo"] = 0;
                return Convert.ToInt32(Session["StartAcqDealList_LastPageNo"]);
            }
            set
            {
                Session["StartAcqDealList_LastPageNo"] = value;
            }
        }
        private int StartSynDealList_LastPageNo
        {
            get
            {
                if (Session["StartSynDealList_LastPageNo"] == null)
                    Session["StartSynDealList_LastPageNo"] = 0;
                return Convert.ToInt32(Session["StartSynDealList_LastPageNo"]);
            }
            set
            {
                Session["StartSynDealList_LastPageNo"] = value;
            }
        }
        private int ExpireAcqDealList_LastPageNo
        {
            get
            {
                if (Session["ExpireAcqDealList_LastPageNo"] == null)
                    Session["ExpireAcqDealList_LastPageNo"] = 0;
                return Convert.ToInt32(Session["ExpireAcqDealList_LastPageNo"]);
            }
            set
            {
                Session["ExpireAcqDealList_LastPageNo"] = value;
            }
        }
        private int ExpireSynDealDataList_LastPageNo
        {
            get
            {
                if (Session["ExpireSynDealDataList_LastPageNo"] == null)
                    Session["ExpireSynDealDataList_LastPageNo"] = 0;
                return Convert.ToInt32(Session["ExpireSynDealDataList_LastPageNo"]);
            }
            set
            {
                Session["ExpireSynDealDataList_LastPageNo"] = value;
            }
        }
        private int ROFR_AcquisitionList_LastPageNo
        {
            get
            {
                if (Session["ROFR_AcquisitionList_LastPageNo"] == null)
                    Session["ROFR_AcquisitionList_LastPageNo"] = 0;
                return Convert.ToInt32(Session["ROFR_AcquisitionList_LastPageNo"]);
            }
            set
            {
                Session["ROFR_AcquisitionList_LastPageNo"] = value;
            }
        }
        private int TentativeStartAcquDealsList_LastPageNo
        {
            get
            {
                if (Session["TentativeStartAcquDealsList_LastPageNo"] == null)
                    Session["TentativeStartAcquDealsList_LastPageNo"] = 0;
                return Convert.ToInt32(Session["TentativeStartAcquDealsList_LastPageNo"]);
            }
            set
            {
                Session["TentativeStartAcquDealsList_LastPageNo"] = value;
            }
        }
        private int AproveAcqDealList_LastPageNo
        {
            get
            {
                if (Session["AproveAcqDealList_LastPageNo"] == null)
                    Session["AproveAcqDealList_LastPageNo"] = 0;
                return Convert.ToInt32(Session["AproveAcqDealList_LastPageNo"]);
            }
            set
            {
                Session["AproveAcqDealList_LastPageNo"] = value;
            }
        }
        private int AproveSynDealList_LastPageNo
        {
            get
            {
                if (Session["AproveSynDealList_LastPageNo"] == null)
                    Session["AproveSynDealList_LastPageNo"] = 0;
                return Convert.ToInt32(Session["AproveSynDealList_LastPageNo"]);
            }
            set
            {
                Session["AproveSynDealList_LastPageNo"] = value;
            }
        }

        private int ExpireSynDealDataListCount_SynRevHB
        {
            get
            {
                if (Session["ExpireSynDealDataListCount_SynRevHB"] == null)
                    Session["ExpireSynDealDataListCount_SynRevHB"] = 0;
                return Convert.ToInt32(Session["ExpireSynDealDataListCount_SynRevHB"]);
            }
            set
            {
                Session["ExpireSynDealDataListCount_SynRevHB"] = value;
            }
        }

        private int ExpireSynDealDataListCount_AcqRevHB
        {
            get
            {
                if (Session["ExpireSynDealDataListCount_AcqRevHB"] == null)
                    Session["ExpireSynDealDataListCount_AcqRevHB"] = 0;
                return Convert.ToInt32(Session["ExpireSynDealDataListCount_AcqRevHB"]);
            }
            set
            {
                Session["ExpireSynDealDataListCount_AcqRevHB"] = value;
            }
        }

        private int ExpireAcqDealDataListCount_AcqHB
        {
            get
            {
                if (Session["ExpireAcqDealDataListCount_AcqHB"] == null)
                    Session["ExpireAcqDealDataListCount_AcqHB"] = 0;
                return Convert.ToInt32(Session["ExpireAcqDealDataListCount_AcqHB"]);
            }
            set
            {
                Session["ExpireAcqDealDataListCount_AcqHB"] = value;
            }
        }

        private int ExpireSynDealDataListCount_SynHB
        {
            get
            {
                if (Session["ExpireSynDealDataListCount_SynHB"] == null)
                    Session["ExpireSynDealDataListCount_SynHB"] = 0;
                return Convert.ToInt32(Session["ExpireSynDealDataListCount_SynHB"]);
            }
            set
            {
                Session["ExpireSynDealDataListCount_SynHB"] = value;
            }
        }

        #endregion
        protected override void OnActionExecuting(ActionExecutingContext filterContext)
        {
            if (Session[RightsU_Session.SESS_KEY] == null)
            {
                CheckandRedirect(filterContext);
                return;
            }
            else
            {
                HttpSessionState CurrentSession = System.Web.HttpContext.Current.Session;
                if (((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser != null)
                {
                    objLoginUser = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;
                    HttpApplicationState Application = HttpContext.ApplicationInstance.Application;
                    Hashtable htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];
                    string entityKey = Convert.ToString(System.Web.HttpContext.Current.Session["Entity_Type"]);

                    if (!htLoggedUser.ContainsKey(objLoginUser.Login_Name + "#" + entityKey))
                    {
                        CheckandRedirect(filterContext);
                        return;
                    }
                    else
                    {
                        string[] timeSessionId = new string[2];
                        timeSessionId = GetTimeAndSessionId(Convert.ToString(htLoggedUser[objLoginUser.Login_Name + "#" + entityKey]));
                        string storedSessionId = timeSessionId[1];

                        if (storedSessionId != CurrentSession.SessionID)
                        {
                            CheckandRedirect(filterContext);
                            return;
                        }

                        if (Request.QueryString["moduleCode"] != null)
                        {
                            objLoginUser.moduleCode = Convert.ToInt32(Request.QueryString["moduleCode"]);
                        }
                    }
                    SessAppTimeOut();
                }
                else
                {
                    CheckandRedirect(filterContext);
                    return;
                }
            }
        }

        private void CheckandRedirect(ActionExecutingContext filterContext)
        {
            Session.Abandon();
            HttpRuntime.Cache.Remove(HttpContext.Session.SessionID);
            if (filterContext.HttpContext.Request.IsAjaxRequest())
            {
                JsonResult result = Json(true, "text/html");
                filterContext.Result = result;
            }
            else
            {
                filterContext.Result = new RedirectResult("~\\Login\\Index");
            }
        }

        public ActionResult Main()
        {
            // CommonUtil.WriteErrorLog("Called Main Action of Base Controlle", logFileName);
            if (Session[RightsU_Session.SESS_KEY] != null)
            {
                if (((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser != null)
                {
                    objLoginUser = ((RightsU_Session)Session[RightsU_Session.SESS_KEY]).Objuser;
                }
                else
                {
                    return RedirectToAction("Index", "Login");
                }
            }
            else
                return RedirectToAction("Index", "Login");

            //  CommonUtil.WriteErrorLog("Calling Dashboard Action of Base Controller", logFileName);

            List<System_Language> lstSystemLanguage = new System_Language_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Is_Active == "Y").ToList();
            int systemLanguageCode = (lstSystemLanguage.Where(w => w.Is_Default == "Y").First() ?? new System_Language()).System_Language_Code;
            systemLanguageCode = (objLoginUser.System_Language_Code ?? systemLanguageCode);
            ViewBag.Language = new SelectList(lstSystemLanguage, "System_Language_Code", "Language_Name", systemLanguageCode);

            //LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTitle);
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), 0);
            return RedirectToAction("DashBoard", "Base");
        }
        public ActionResult Redirect_Page(string ActionName, string ControllerName, string IsMenu = "", int modulecode = 0)
        {

            Dictionary<string, string> obj_D = new Dictionary<string, string>();
            obj_D.Add("IsMenu", IsMenu);
            TempData["QS_LayOut"] = obj_D;
            return RedirectToAction(ActionName, ControllerName);
        }

        public ActionResult DashBoard(string Search = "")
        {
            //   CommonUtil.WriteErrorLog("Called Dashboard Action of Base Controller", logFileName);
            int PageNo = 1;
            DealStartAndExp_Days = StartAndExpiryDays();

            Search = Search.Trim();
            TempData["Search"] = Search;

            arrUserRight = GetUserRights(false);
            if (arrUserRight.Count > 0)
                ViewBag.DashBoardVissible = "T";
            else
                ViewBag.DashBoardVissible = "F";

            StartAcqDealListCount = 0;
            StartSynDealListCount = 0;
            ExpireAcqDealListCount = 0;
            ExpireSynDealDataListCount = 0;
            ROFR_AcquisitionListCount = 0;
            TentativeStartAcquDealsListCount = 0;
            AprovedAcqDealListCount = 0;
            AproveSynDealListCount = 0;

            StartAcqDealList_PageNo = 1;
            StartSynDealList_PageNo = 1;
            ExpireAcqDealList_PageNo = 1;
            ExpireSynDealDataList_PageNo = 1;
            ROFR_AcquisitionList_PageNo = 1;
            TentativeStartAcquDealsList_PageNo = 1;
            AprovedAcqDealList_PageNo = 1;
            AproveSynDealList_PageNo = 1;

            ExpireSynDealDataListCount_SynRevHB = 0;
            ExpireSynDealDataListCount_AcqRevHB = 0;
            ExpireAcqDealDataListCount_AcqHB = 0;
            ExpireSynDealDataListCount_SynHB = 0;

            if (arrUserRight.Count > 0)
            {
                #region------- BindTables--------

                if (arrUserRight.Contains(GlobalParams.RightsCodeForAcquisitionRightsStart))
                {
                    List<USP_Get_Dashboard_Detail_Result> StartAcqDealList = BindStarAcqDeal(Search);

                    StartAcqDealListCount = StartAcqDealList.Count();

                    StartAcqDealList_LastPageNo = ((StartAcqDealListCount / PageSize) - (StartAcqDealListCount % PageSize == 0 ? 1 : 0)) + 1;

                    StartAcqDealList = StartAcqDealList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.StartAcqDealList = StartAcqDealList;
                }
                else
                    ViewBag.StartAcqDealList = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForAcquisitionRightsStart))
                {
                    List<USP_Get_Dashboard_Detail_Result> AproveAcqDealList = BindAproveAcqDeal(Search);

                    AprovedAcqDealListCount = AproveAcqDealList.Count();

                    AprovedAcqDealList_PageNo = ((AprovedAcqDealListCount / PageSize) - (AprovedAcqDealListCount % PageSize == 0 ? 1 : 0)) + 1;

                    AproveAcqDealList = AproveAcqDealList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.AproveAcqDealList = AproveAcqDealList;
                }
                else
                    ViewBag.AproveAcqDealList = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForSyndicationRightsStart))
                {
                    List<USP_Get_Dashboard_Detail_Result> StartSynDealList = BindStartSynDeal(Search);
                    StartSynDealListCount = StartSynDealList.Count();

                    StartSynDealList_LastPageNo = ((StartSynDealListCount / PageSize) - (StartSynDealListCount % PageSize == 0 ? 1 : 0)) + 1;

                    StartSynDealList = StartSynDealList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.StartSynDealList = StartSynDealList;
                }
                else
                    ViewBag.StartSynDealList = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForSyndicationRightsStart))
                {
                    List<USP_Get_Dashboard_Detail_Result> AproveSynDealList = BindAproveSynDeal(Search);
                    StartSynDealListCount = AproveSynDealList.Count();

                    AproveSynDealList_LastPageNo = ((AproveSynDealListCount / PageSize) - (AproveSynDealListCount % PageSize == 0 ? 1 : 0)) + 1;

                    AproveSynDealList = AproveSynDealList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.AproveSynDealList = AproveSynDealList;
                }
                else
                    ViewBag.AproveSynDealList = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForAcquisitionRightsEnd))
                {

                    List<USP_Get_Dashboard_Detail_Result> ExpireAcqDealList = BindExpiringAcqDeal(Search);
                    ExpireAcqDealListCount = ExpireAcqDealList.Count();

                    ExpireAcqDealList_LastPageNo = ((ExpireAcqDealListCount / PageSize) - (ExpireAcqDealListCount % PageSize == 0 ? 1 : 0)) + 1;

                    ExpireAcqDealList = ExpireAcqDealList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.ExpireAcqDealList = ExpireAcqDealList;
                }
                else
                    ViewBag.ExpireAcqDealList = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForSyndicationRightsEnd))
                {
                    List<USP_Get_Dashboard_Detail_Result> ExpireSynDealDataList = BindExpiringSynDeal(Search);
                    ExpireSynDealDataListCount = ExpireSynDealDataList.Count();

                    ExpireSynDealDataList_LastPageNo = ((ExpireSynDealDataListCount / PageSize) - (ExpireSynDealDataListCount % PageSize == 0 ? 1 : 0)) + 1;

                    ExpireSynDealDataList = ExpireSynDealDataList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.ExpireSynDealDataList = ExpireSynDealDataList;
                }
                else
                    ViewBag.ExpireSynDealDataList = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForAcquisitionRightsROFR))
                {
                    List<USP_Get_Dashboard_Detail_Result> ROFR_AcquisitionList = BindROFRAcqDeal(Search);
                    ROFR_AcquisitionListCount = ROFR_AcquisitionList.Count();

                    ROFR_AcquisitionList_LastPageNo = ((ROFR_AcquisitionListCount / PageSize) - (ROFR_AcquisitionListCount % PageSize == 0 ? 1 : 0)) + 1;

                    ROFR_AcquisitionList = ROFR_AcquisitionList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.ROFR_AcquisitionList = ROFR_AcquisitionList;
                }
                else
                    ViewBag.ROFR_AcquisitionList = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForAcquisitionRightsTentative))
                {
                    List<USP_Get_Dashboard_Detail_Result> TentativeStartAcquDealsList = BindTentativeStartAcqDeal(Search);
                    TentativeStartAcquDealsListCount = TentativeStartAcquDealsList.Count();
                    TentativeStartAcquDealsList = TentativeStartAcquDealsList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    TentativeStartAcquDealsList_LastPageNo = ((TentativeStartAcquDealsListCount / PageSize) - (TentativeStartAcquDealsListCount % PageSize == 0 ? 1 : 0)) + 1;

                    ViewBag.TentativeStartAcquDealsList = TentativeStartAcquDealsList;
                }
                else
                    ViewBag.TentativeStartAcquDealsList = null;


                if (arrUserRight.Contains(GlobalParams.RightsCodeForSyndicationRevHB))
                {
                    List<USP_Get_Dashboard_Detail_Result> ExpireSynDealDataList_SynRevHB = BindExpiringSynDeal_ReverseHoldback(Search);
                    ExpireSynDealDataListCount_SynRevHB = ExpireSynDealDataList_SynRevHB.Count();

                    ExpireSynDealDataList_LastPageNo = ((ExpireSynDealDataListCount / PageSize) - (ExpireSynDealDataListCount % PageSize == 0 ? 1 : 0)) + 1;

                    ExpireSynDealDataList_SynRevHB = ExpireSynDealDataList_SynRevHB.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.ExpireSynDealDataList_SynRevHB = ExpireSynDealDataList_SynRevHB;
                }
                else
                    ViewBag.ExpireSynDealDataList_SynRevHB = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForAcquisitionRevHB))
                {
                    List<USP_Get_Dashboard_Detail_Result> ExpireAcqDealDataList_AcqRevHB = BindExpiringAcqDeal_ReverseHoldback(Search);
                    ExpireSynDealDataListCount_AcqRevHB = ExpireAcqDealDataList_AcqRevHB.Count();

                    ExpireSynDealDataList_LastPageNo = ((ExpireSynDealDataListCount / PageSize) - (ExpireSynDealDataListCount % PageSize == 0 ? 1 : 0)) + 1;

                    ExpireAcqDealDataList_AcqRevHB = ExpireAcqDealDataList_AcqRevHB.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.ExpireAcqDealDataList_AcqRevHB = ExpireAcqDealDataList_AcqRevHB;
                }
                else
                    ViewBag.ExpireAcqDealDataList_AcqRevHB = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForAcquisitionHB))
                {
                    List<USP_Get_Dashboard_Detail_Result> ExpireAcqDealDataList_AcqHB = BindExpiringAcqDeal_Holdback(Search);
                    ExpireAcqDealDataListCount_AcqHB = ExpireAcqDealDataList_AcqHB.Count();

                    ExpireSynDealDataList_LastPageNo = ((ExpireSynDealDataListCount / PageSize) - (ExpireSynDealDataListCount % PageSize == 0 ? 1 : 0)) + 1;

                    ExpireAcqDealDataList_AcqHB = ExpireAcqDealDataList_AcqHB.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.ExpireAcqDealDataList_AcqHB = ExpireAcqDealDataList_AcqHB;
                }
                else
                    ViewBag.ExpireAcqDealDataList_AcqHB = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForSyndicationHB))
                {
                    List<USP_Get_Dashboard_Detail_Result> ExpireSynDealDataList_SynHB = BindExpiringSynDeal_Holdback(Search);
                    ExpireSynDealDataListCount_SynHB = ExpireSynDealDataList_SynHB.Count();

                    ExpireSynDealDataList_LastPageNo = ((ExpireSynDealDataListCount / PageSize) - (ExpireSynDealDataListCount % PageSize == 0 ? 1 : 0)) + 1;

                    ExpireSynDealDataList_SynHB = ExpireSynDealDataList_SynHB.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.ExpireSynDealDataList_SynHB = ExpireSynDealDataList_SynHB;
                }
                else
                    ViewBag.ExpireSynDealDataList_SynHB = null;

                #endregion

                #region ------ Title------
                string startAcqDealListDays = "";
                string startSynDealListDays = "";
                string ExpireAcqDealListDays = "";
                string ExpireSynDealListDays = "";
                string ROFR_AcquisitionListDays = "";
                string TentativeStartAcquDealsListDays = "";
                string AproveAcqDealListDays = "";
                string AproveSynDealListDays = "";
                string Expire_SynRevHBDays = "";
                string Expire_AcqRevHBDays = "";
                string Expire_AcqHBDays = "";
                string Expire_SynHBDays = "";

                startAcqDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ADTS").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                startSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SDTS").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                ExpireAcqDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ADTE").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                ExpireSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SDTE").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                ROFR_AcquisitionListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ADTR").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                TentativeStartAcquDealsListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-TADTS").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                AproveAcqDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ADTA").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                AproveSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SDTA").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                Expire_SynRevHBDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SRHB").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                Expire_AcqRevHBDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ARHB").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                Expire_AcqHBDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-AHB").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                Expire_SynHBDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SHB").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();


                if (startAcqDealListDays == null)
                    startAcqDealListDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTS").Select(s => s.Parameter_Value).FirstOrDefault();
                if (startSynDealListDays == null)
                    startSynDealListDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SDTS").Select(s => s.Parameter_Value).FirstOrDefault();
                if (ExpireAcqDealListDays == null)
                    ExpireAcqDealListDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTE").Select(s => s.Parameter_Value).FirstOrDefault();
                if (ExpireSynDealListDays == null)
                    ExpireSynDealListDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SDTE").Select(s => s.Parameter_Value).FirstOrDefault();
                if (ROFR_AcquisitionListDays == null)
                    ROFR_AcquisitionListDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTR").Select(s => s.Parameter_Value).FirstOrDefault();
                if (TentativeStartAcquDealsListDays == null)
                    TentativeStartAcquDealsListDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-TADTS").Select(s => s.Parameter_Value).FirstOrDefault();
                if (AproveAcqDealListDays == null)
                    AproveAcqDealListDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTA").Select(s => s.Parameter_Value).FirstOrDefault();
                if (AproveSynDealListDays == null)
                    AproveSynDealListDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SDTA").Select(s => s.Parameter_Value).FirstOrDefault();
                if (String.IsNullOrEmpty(Expire_SynRevHBDays))
                    Expire_SynRevHBDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SRHB").Select(s => s.Parameter_Value).FirstOrDefault();
                if (String.IsNullOrEmpty(Expire_AcqRevHBDays))
                    Expire_AcqRevHBDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ARHB").Select(s => s.Parameter_Value).FirstOrDefault();
                if (String.IsNullOrEmpty(Expire_AcqHBDays))
                    Expire_AcqHBDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-AHB").Select(s => s.Parameter_Value).FirstOrDefault();
                if (String.IsNullOrEmpty(Expire_SynHBDays))
                    Expire_SynHBDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SHB").Select(s => s.Parameter_Value).FirstOrDefault();

                string startAcqDealListTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTS").Select(s => s.Description).FirstOrDefault();
                string startSynDealListTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SDTS").Select(s => s.Description).FirstOrDefault();
                string ExpireAcqDealListTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTE").Select(s => s.Description).FirstOrDefault();
                string ExpireSynDealListTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SDTE").Select(s => s.Description).FirstOrDefault();
                string ROFR_AcquisitionListTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTR").Select(s => s.Description).FirstOrDefault();
                string TentativeStartAcquDealsListTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-TADTS").Select(s => s.Description).FirstOrDefault();
                string AproveAcqDealListTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTA").Select(s => s.Description).FirstOrDefault();
                string AproveSynDealListTitle = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SDTA").Select(s => s.Description).FirstOrDefault();
                //string DealStartAndExp_Days = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTA").Select(s => s.Description).FirstOrDefault();
                string ExpireSynDealListTitle_SynRevHB = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SRHB").Select(s => s.Description).FirstOrDefault();
                string ExpireAcqDealListTitle_AcqRevHB = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ARHB").Select(s => s.Description).FirstOrDefault();
                string ExpireAcqDealListTitle_AcqHB = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-AHB").Select(s => s.Description).FirstOrDefault();
                string ExpireAcqDealListTitle_SynHB = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SHB").Select(s => s.Description).FirstOrDefault();

                ViewBag.StartAcqDealListTitle = startAcqDealListTitle + " " + startAcqDealListDays + " days";
                ViewBag.StartSynDealListTitle = startSynDealListTitle + " " + startSynDealListDays + " days";
                ViewBag.ExpireAcqDealListTitle = ExpireAcqDealListTitle + " " + ExpireAcqDealListDays + " days";
                ViewBag.ExpireSynDealDataListTitle = ExpireSynDealListTitle_SynRevHB + " " + ExpireSynDealListDays + " days";
                ViewBag.ROFR_AcquisitionListTitle = ROFR_AcquisitionListTitle + " " + ROFR_AcquisitionListDays + " days";
                ViewBag.TentativeStartAcquDealsListTitle = TentativeStartAcquDealsListTitle + " " + TentativeStartAcquDealsListDays + " days";
                ViewBag.AproveAcqDealListTitle = AproveAcqDealListTitle + " " + AproveAcqDealListDays + " days";
                ViewBag.AproveSynDealListTitle = AproveSynDealListTitle + " " + AproveSynDealListDays + " days";
                ViewBag.DealStartAndExp_Days = DealStartAndExp_Days;
                ViewBag.SynRevHB_Title = ExpireSynDealListTitle_SynRevHB + " " + Expire_SynRevHBDays + " days";
                ViewBag.AcqRevHB_Title = ExpireAcqDealListTitle_AcqRevHB + " " + Expire_AcqRevHBDays + " days";
                ViewBag.AcqHB_Title = ExpireAcqDealListTitle_AcqHB + " " + Expire_AcqHBDays + " days";
                ViewBag.SynHB_Title = ExpireAcqDealListTitle_SynHB + " " + Expire_SynHBDays + " days";

                #endregion

                #region ------ Title------
                ViewBag.StartAcqDealList_PageNo = StartAcqDealList_PageNo; 
                ViewBag.StartSynDealList_PageNo = StartSynDealList_PageNo;
                ViewBag.ExpireAcqDealList_PageNo = ExpireAcqDealList_PageNo;
                ViewBag.ExpireSynDealDataList_PageNo = ExpireSynDealDataList_PageNo;
                ViewBag.ROFR_AcquisitionList_PageNo = ROFR_AcquisitionList_PageNo;
                ViewBag.TentativeStartAcquDealsList_PageNo = TentativeStartAcquDealsList_PageNo;
                ViewBag.AproveAcqDealList_PageNo = AprovedAcqDealList_PageNo;
                ViewBag.AproveSynDealList_PageNo = AproveSynDealList_PageNo;

                ViewBag.StartAcqDealList_LastPageNo = StartAcqDealList_LastPageNo;
                ViewBag.StartSynDealList_LastPageNo = StartSynDealList_LastPageNo;
                ViewBag.ExpireAcqDealList_LastPageNo = ExpireAcqDealList_LastPageNo;
                ViewBag.ExpireSynDealDataList_LastPageNo = ExpireSynDealDataList_LastPageNo;
                ViewBag.ROFR_AcquisitionList_LastPageNo = ROFR_AcquisitionList_LastPageNo;
                ViewBag.TentativeStartAcquDealsList_LastPageNo = TentativeStartAcquDealsList_LastPageNo;
                ViewBag.AproveAcqDealList_LastPageNo = AproveAcqDealList_LastPageNo;
                ViewBag.AproveSynDealList_LastPageNo = AproveSynDealList_LastPageNo ;
                #endregion
                ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeFor_DashBoard, objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
                bool srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForCost) + "~");
                ViewBag.CostVisibility = srchaddRights;
                //  CommonUtil.WriteErrorLog("Calling Dashboard View of Base Controlle", logFileName);
                return View("Dashboard");
            }
            else
            {
                return View("_Layout");
            }
        }
        public JsonResult BindDashBoard_Graph(string businessUnitCodes)
        {
            USP_Service objUSP_Service = new USP_Service(objLoginEntity.ConnectionStringName);
            object[] arrHeaderRows, arrHeaderCols;
            Dictionary<string, object> obj = new Dictionary<string, object>();

            List<USP_Get_Dashboard_Data_Result> lstRegionWiseDealExpiry = objUSP_Service.USP_Get_Dashboard_Data("REGION_WISE_DEAL_EXPIRY", businessUnitCodes).ToList();
            object[] arrRegionWiseDealExpiry = GetChartData(lstRegionWiseDealExpiry, out arrHeaderRows, out arrHeaderCols);
            obj.Add("RegionWiseDealExpiry", arrRegionWiseDealExpiry);
            obj.Add("RegionWiseDealExpiry_RowArray", arrHeaderRows);
            obj.Add("RegionWiseDealExpiry_ColArray", arrHeaderCols);

            List<USP_Get_Dashboard_Data_Result> lstPlatformWiseSalesDistribution = objUSP_Service.USP_Get_Dashboard_Data("PLATFORM_WISE_SALES_DISTRIBUTION", businessUnitCodes).ToList();
            object[] arrPlatformWiseSalesDistribution = GetChartData(lstPlatformWiseSalesDistribution, out arrHeaderRows, out arrHeaderCols);
            obj.Add("PlatformWiseSalesDistribution", arrPlatformWiseSalesDistribution);
            obj.Add("PlatformWiseSalesDistribution_RowArray", arrHeaderRows);
            obj.Add("PlatformWiseSalesDistribution_ColArray", arrHeaderCols);

            List<USP_Get_Dashboard_Data_Result> lstRegionWiseSalesDistribution = objUSP_Service.USP_Get_Dashboard_Data("REGION_WISE_SALES_DISTRIBUTION", businessUnitCodes).ToList();
            object[] arrRegionWiseSalesDistribution = GetChartData(lstRegionWiseSalesDistribution, out arrHeaderRows, out arrHeaderCols);
            obj.Add("RegionWiseSalesDistribution", arrRegionWiseSalesDistribution);
            obj.Add("RegionWiseSalesDistribution_RowArray", arrHeaderRows);
            obj.Add("RegionWiseSalesDistribution_ColArray", arrHeaderCols);

            List<USP_Get_Dashboard_Data_Result> lstAcquisitionVsSyndication = objUSP_Service.USP_Get_Dashboard_Data("ACQUISITION_VS_SYNDICATION", businessUnitCodes).ToList();
            object[] arrAcquisitionVsSyndication = GetChartData(lstAcquisitionVsSyndication, out arrHeaderRows, out arrHeaderCols);
            #region --- Set Properties For Gauge ---
            object[] objData = null, objRed = null, objYellow = null, objGreen = null;

            for (int i = 0; i < arrAcquisitionVsSyndication.Length; i++)
            {
                object[] objD = (object[])arrAcquisitionVsSyndication[i];
                if (objD[0].ToString().ToUpper() == "DATA")
                    objData = objD;
                else if (objD[0].ToString().ToUpper() == "RED")
                    objRed = objD;
                if (objD[0].ToString().ToUpper() == "YELLOW")
                    objYellow = objD;
                if (objD[0].ToString().ToUpper() == "GREEN")
                    objGreen = objD;
            }

            dynamic objAcquisitionVsSyndication = null;

            if (objData != null)
            {
                objAcquisitionVsSyndication = new
                {
                    Total = objData[1],
                    Consumed = objData[2],
                    RedFrom = objRed[1],
                    RedTo = objRed[2],
                    YellowFrom = objYellow[1],
                    YellowTo = objYellow[2],
                    GreenFrom = objGreen[1],
                    GreenTo = objGreen[2]
                };
            }
            #endregion
            obj.Add("AcquisitionVsSyndication", objAcquisitionVsSyndication);
            obj.Add("AcquisitionVsSyndication_RowArray", arrHeaderRows);
            obj.Add("AcquisitionVsSyndication_ColArray", arrHeaderCols);

            List<USP_Get_Dashboard_Data_Result> lstLanguageWiseSyndicationSubtitle = objUSP_Service.USP_Get_Dashboard_Data("LANGUAGE_WISE_SYNDICATION_SUBTITLE", businessUnitCodes).ToList();
            object[] arrLanguageWiseSyndicationSubtitle = GetChartData(lstLanguageWiseSyndicationSubtitle, out arrHeaderRows, out arrHeaderCols);
            obj.Add("LanguageWiseSyndicationSubtitle", arrLanguageWiseSyndicationSubtitle);
            obj.Add("LanguageWiseSyndicationSubtitle_RowArray", arrHeaderRows);
            obj.Add("LanguageWiseSyndicationSubtitle_ColArray", arrHeaderCols);

            List<USP_Get_Dashboard_Data_Result> lstLanguageWiseSyndicationDubbing = objUSP_Service.USP_Get_Dashboard_Data("LANGUAGE_WISE_SYNDICATION_DUBBING", businessUnitCodes).ToList();
            object[] arrLanguageWiseSyndicationDubbing = GetChartData(lstLanguageWiseSyndicationDubbing, out arrHeaderRows, out arrHeaderCols);
            obj.Add("LanguageWiseSyndicationDubbing", arrLanguageWiseSyndicationDubbing);
            obj.Add("LanguageWiseSyndicationDubbing_RowArray", arrHeaderRows);
            obj.Add("LanguageWiseSyndicationDubbing_ColArray", arrHeaderCols);

            List<USP_Get_Dashboard_Data_Result> lstTitleRegion = objUSP_Service.USP_Get_Dashboard_Data("TITLE_REGION", businessUnitCodes).ToList();
            object[] arrTitleRegion = GetChartData(lstTitleRegion, out arrHeaderRows, out arrHeaderCols);
            obj.Add("TitleRegion", arrTitleRegion);
            obj.Add("TitleRegion_RowArray", arrHeaderRows);
            obj.Add("TitleRegion_ColArray", arrHeaderCols);
            return Json(obj);
        }

        public ActionResult DashBoard_Graph()
        {
            arrUserRight = GetUserRights(true);
            if (arrUserRight.Count > 0)
                ViewBag.DashBoardVissible = "T";
            else
                ViewBag.DashBoardVissible = "F";
            List<SelectListItem> lstBusiness = new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)), "Business_Unit_Code", "Business_Unit_Name").OrderBy(o => o.Text).Distinct().ToList();
            ViewBag.Business_Unit_Code_All = string.Join(",", lstBusiness.Select(s => s.Value).ToArray());
            if (lstBusiness.Count > 1)
                lstBusiness.Insert(0, new SelectListItem() { Value = "0", Text = "All" });
            ViewBag.Business_Unit_List = lstBusiness;
            return View();
        }

        private object[] GetChartData(List<USP_Get_Dashboard_Data_Result> lst, out object[] arrHeaderRows, out object[] arrHeaderCols)
        {
            int length = lst.Count; ;
            object[] arrMain = new object[(length > 0) ? length - 1 : 0];
            if (length > 0)
            {
                for (int i = 0; i < arrMain.Length; i++)
                {
                    USP_Get_Dashboard_Data_Result item = lst[i];
                    string[] arr = item.Col_Values.Split('~');
                    object[] arrHeader = new object[arr.Length];
                    if (i == 0)
                    {
                        for (int j = 0; j < arr.Length; j++)
                        {
                            string str = arr[j];
                            if (str.ToUpper().Equals("{ANN}"))
                            {
                                arrHeader[j] = new { role = "annotation" };
                            }
                            else if (str.ToUpper().Equals("{ANN_NUM}"))
                            {
                                arrHeader[j] = new { type = "number", role = "annotation" };
                            }
                            else
                            {
                                arrHeader[j] = str;
                            }
                        }

                        arrMain[i] = arrHeader;
                    }
                    else
                    {
                        object[] arrVal = new object[arr.Length];
                        for (int k = 0; k < arrVal.Length; k++)
                        {
                            string val = arr[k];
                            if (k == 0)
                                arrVal[k] = val;
                            else
                            {
                                try
                                {
                                    arrVal[k] = Convert.ToInt32(val);
                                }
                                catch (Exception)
                                {
                                    arrVal[k] = val;
                                }
                            }
                        }

                        arrMain[i] = arrVal;
                    }
                }

                string[] rowCols = lst[length - 1].Col_Values.Split('^');

                arrHeaderRows = rowCols[0].Split(',');
                arrHeaderCols = rowCols[1].Split(',');
            }
            else
            {
                arrHeaderRows = new object[0];
                arrHeaderCols = new object[0];
            }
            return arrMain;
        }

        public JsonResult GetApprovalList(string commonSearch)
        {
            int pageNo = 0, pageSize = 10, RecordCount = 0;
            string isPaging = "Y";
            string Common_Search = string.Empty;

            RightsU_Entities.User objLoginUser = ((RightsU_Entities.RightsU_Session)Session[RightsU_Entities.RightsU_Session.SESS_KEY]).Objuser;
            System.Data.Entity.Core.Objects.ObjectParameter objRecordCount = new System.Data.Entity.Core.Objects.ObjectParameter("RecordCount", RecordCount);
            List<RightsU_Entities.USP_List_Approval_Acq_Syn_Result> lstAcq = new RightsU_BLL.USP_Service(objLoginEntity.ConnectionStringName).USP_List_Approval_Acq_Syn(commonSearch, pageNo, "",
                isPaging, pageSize, objRecordCount, objLoginUser.Users_Code).ToList();
            return Json(lstAcq);
        }
        #region -------Menu--------
        public ActionResult GetMenu(string TabName = "")
        {
            var List = (dynamic)null;
            string strHTML = "";
            string OpeningULTag = "<ul>";
            string ClosingULTag = "</ul>";
            string OpeningLITag = "<li>";
            string ClosingLITag = "</li>";
            List<USP_GetMenu_Result> LoadMenuList = new USP_Service(objLoginEntity.ConnectionStringName).USP_GetMenu(objLoginUser.Security_Group_Code.ToString(), "Y", objLoginUser.Users_Code).ToList();
            LoadMenuList = LoadMenuList.Where(x => x.Module_Position.ToUpper().StartsWith(TabName.ToUpper())).ToList();
            if (TabName == "A")
                strHTML = strHTML + "<h4>Masters</h4><a class='close' href='#' onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlMasters');\"><span class='Reviewclose'>x</span></a>";
            if (TabName == "N")
                strHTML = strHTML + "<h4>Amort</h4><a class='close' href='#' onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlAmort');\"><span class='Reviewclose'>x</span></a>";
            else if (TabName == "E")
                strHTML = strHTML + "<h4>Reports</h4><a class='close' href='#' onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlReports');\"><span class='Reviewclose'>x</span></a>";
            else if (TabName == "C")
                strHTML = strHTML + "<h4>IPR</h4><a class='close' href=\"#\" onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlIPR');\"><span class=\"Reviewclose\">x</span></a>";
            else if (TabName == "D")
                strHTML = strHTML + "<h4>Settings</h4><a class='close' href=\"#\" onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlSettings');\"><span class=\"Reviewclose\">x</span></a>";
            else if (TabName == "F")
                strHTML = strHTML + "<h4>Upload</h4><a class=\"close\" href=\"#\" onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlUploads');\"><span class=\"Reviewclose\">x</span></a>";
            else if (TabName == "G")
                strHTML = strHTML + "<h4>Availability</h4><a class='close' href='#' onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlAvail');\"><span class='Reviewclose'>x</span></a>";
            else if (TabName == "H")
                strHTML = strHTML + "<h4>Glossary</h4><a class='close' href='#' onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlGlossary');\"><span class='Reviewclose'>x</span></a>";
            else if (TabName == "M")
                strHTML = strHTML + "<h4>Music Track</h4><a class='close' href='#' onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlMusic');\"><span class='Reviewclose'>x</span></a>";
            else if (TabName == "O")
                strHTML = strHTML + "<h4>Music Hub</h4><a class='close' href='#' onclick=\"javascript: panelVisible=true;togglePanelVisibility('pnlMusicHub');\"><span class='Reviewclose'>x</span></a>";
            strHTML = strHTML + OpeningULTag;
            List<USP_GetMenu_Result> SubMenuList = LoadMenuList.Where(x => x.Module_Position.Length == 2).ToList();

            if (TabName == "D" && System.Configuration.ConfigurationManager.AppSettings["isLDAPAuthReqd"].ToString().Trim().ToUpper() == "N")
                strHTML = strHTML + OpeningLITag + "<a href='" + System.Web.VirtualPathUtility.ToAbsolute("~/Login/ChangePasswordIndex") + "'>Change Password</a>" + ClosingLITag;

            foreach (USP_GetMenu_Result USP_GetMenu_Result_Obj in SubMenuList)
            {
                if (USP_GetMenu_Result_Obj.Is_Sub_Module == "Y")
                {
                    int Count = LoadMenuList.Where(x => x.Module_Position.Length == 3 && x.Module_Position.StartsWith(USP_GetMenu_Result_Obj.Module_Position)).ToList().Count();
                    if (Count > 0)
                    {
                        strHTML = strHTML + "<li class='active has-sub'>";
                        strHTML = strHTML + "<a href='#'>" + USP_GetMenu_Result_Obj.Module_Name + "</a>";
                        strHTML = strHTML + OpeningULTag;
                        List<USP_GetMenu_Result> SubSubMenuList = LoadMenuList.Where(x => x.Module_Position.Length == 3 && x.Module_Position.StartsWith(USP_GetMenu_Result_Obj.Module_Position)).ToList();
                        foreach (USP_GetMenu_Result USP_GetMenu_Result_Sub_Obj in SubSubMenuList)
                            strHTML = strHTML + OpeningLITag + "<a href='" + System.Web.VirtualPathUtility.ToAbsolute("~/" + USP_GetMenu_Result_Sub_Obj.Url + "?modulecode=" + USP_GetMenu_Result_Sub_Obj.Module_Code) + "'>" + USP_GetMenu_Result_Sub_Obj.Module_Name + "</a>" + ClosingLITag;
                        strHTML = strHTML + ClosingULTag;
                    }
                    else
                        strHTML = strHTML + OpeningLITag + "<a href='" + System.Web.VirtualPathUtility.ToAbsolute("~/" + USP_GetMenu_Result_Obj.Url + "?modulecode=" + USP_GetMenu_Result_Obj.Module_Code) + "'>" + USP_GetMenu_Result_Obj.Module_Name + "</a>" + ClosingLITag;
                }
                else
                    strHTML = strHTML + OpeningLITag + "<a href='" + System.Web.VirtualPathUtility.ToAbsolute("~/" + USP_GetMenu_Result_Obj.Url + "?modulecode=" + USP_GetMenu_Result_Obj.Module_Code) + "'>" + USP_GetMenu_Result_Obj.Module_Name + "</a>" + ClosingLITag;
            }
            strHTML = strHTML + ClosingULTag;
            List = strHTML;
            return Json(List);
        }
        #endregion

        #region===============DashBoard List Methods==================
        private List<USP_Get_Dashboard_Detail_Result> BindStarAcqDeal(string Search)
        {
            int? startAcqDealListDays = 0;
            startAcqDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ADTS").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (startAcqDealListDays == null)
                startAcqDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTS").Select(w => w.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> StartAcqDealList = objUSP_Service.USP_Get_Dashboard_Detail("AS", Search, objLoginUser.Users_Code, startAcqDealListDays).ToList();
            return StartAcqDealList;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindAproveAcqDeal(string Search)
        {
            int? AproveAcqDealListDays = 0;
            AproveAcqDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ADTA").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (AproveAcqDealListDays == null)
                AproveAcqDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTA").Select(w => w.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> AproveAcqDealList = objUSP_Service.USP_Get_Dashboard_Detail("AA", Search, objLoginUser.Users_Code, AproveAcqDealListDays).ToList();
            return AproveAcqDealList;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindStartSynDeal(string Search)
        {
            int? startSynDealListDays = 0;
            startSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SDTS").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (startSynDealListDays == null)
                startSynDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SDTS").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> StartSynDealList = objUSP_Service.USP_Get_Dashboard_Detail("SS", Search, objLoginUser.Users_Code, startSynDealListDays).ToList();
            return StartSynDealList;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindAproveSynDeal(string Search)
        {
            int? AproveSynDealListDays = 0;
            AproveSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SDTA").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (AproveSynDealListDays == null)
                AproveSynDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SDTA").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> AproveSynDealList = objUSP_Service.USP_Get_Dashboard_Detail("SA", Search, objLoginUser.Users_Code, AproveSynDealListDays).ToList();
            return AproveSynDealList;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindExpiringAcqDeal(string Search)
        {
            int? ExpireAcqDealListDays = 0;
            ExpireAcqDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ADTE").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (ExpireAcqDealListDays == null)
                ExpireAcqDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTE").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> ExpireAcqDealList = objUSP_Service.USP_Get_Dashboard_Detail("AE", Search, objLoginUser.Users_Code, ExpireAcqDealListDays).ToList();
            return ExpireAcqDealList;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindExpiringSynDeal(string Search)
        {
            int? ExpireSynDealListDays = 0;
            ExpireSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SDTE").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (ExpireSynDealListDays == null)
                ExpireSynDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SDTE").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> ExpireSynDealDataList = objUSP_Service.USP_Get_Dashboard_Detail("SE", Search, objLoginUser.Users_Code, ExpireSynDealListDays).ToList();
            return ExpireSynDealDataList;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindROFRAcqDeal(string Search)
        {
            int? ROFR_AcquisitionListDays = 0;
            ROFR_AcquisitionListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ADTR").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (ROFR_AcquisitionListDays == null)
                ROFR_AcquisitionListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTR").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> ROFR_AcquisitionList = objUSP_Service.USP_Get_Dashboard_Detail("AR", Search, objLoginUser.Users_Code, ROFR_AcquisitionListDays).ToList();
            return ROFR_AcquisitionList;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindTentativeStartAcqDeal(string Search)
        {
            int? TentativeStartAcquDealsListDays = 0;
            TentativeStartAcquDealsListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-TADTS").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (TentativeStartAcquDealsListDays == null)
                TentativeStartAcquDealsListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-TADTS").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> TentativeStartAcquDealsList = objUSP_Service.USP_Get_Dashboard_Detail("AT", Search, objLoginUser.Users_Code, TentativeStartAcquDealsListDays).ToList();
            return TentativeStartAcquDealsList;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindExpiringSynDeal_ReverseHoldback(string Search)
        {
            int? ExpireSynDealListDays = 0;
            ExpireSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SRHB").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (ExpireSynDealListDays == null)
                ExpireSynDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SRHB").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> ExpireSynDealDataList_SRHB = objUSP_Service.USP_Get_Dashboard_Detail("SRHB", Search, objLoginUser.Users_Code, ExpireSynDealListDays).ToList();
            return ExpireSynDealDataList_SRHB;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindExpiringAcqDeal_ReverseHoldback(string Search)
        {
            int? ExpireSynDealListDays = 0;
            ExpireSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ARHB").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (ExpireSynDealListDays == null)
                ExpireSynDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ARHB").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> ExpireSynDealDataList_ARHB = objUSP_Service.USP_Get_Dashboard_Detail("ARHB", Search, objLoginUser.Users_Code, ExpireSynDealListDays).ToList();
            return ExpireSynDealDataList_ARHB;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindExpiringAcqDeal_Holdback(string Search)
        {
            int? ExpireSynDealListDays = 0;
            ExpireSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-AHB").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (ExpireSynDealListDays == null)
                ExpireSynDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-AHB").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> ExpireSynDealDataList_AHB = objUSP_Service.USP_Get_Dashboard_Detail("AHB", Search, objLoginUser.Users_Code, ExpireSynDealListDays).ToList();
            return ExpireSynDealDataList_AHB;
        }

        private List<USP_Get_Dashboard_Detail_Result> BindExpiringSynDeal_Holdback(string Search)
        {
            int? ExpireSynDealListDays = 0;
            ExpireSynDealListDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-SHB").Select(s => s.Dashboard_Value).FirstOrDefault();
            if (ExpireSynDealListDays == null)
                ExpireSynDealListDays = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-SHB").Select(s => s.Parameter_Value).FirstOrDefault());
            List<USP_Get_Dashboard_Detail_Result> ExpireSynDealDataList_SHB = objUSP_Service.USP_Get_Dashboard_Detail("SHB", Search, objLoginUser.Users_Code, ExpireSynDealListDays).ToList();
            return ExpireSynDealDataList_SHB;
        }

        private int StartAndExpiryDays()
        {
            int DealStartAndExp_Days = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "DASHBOARD_DAYS").Select(s => s.Parameter_Value).FirstOrDefault());

            return DealStartAndExp_Days;
        }

        public ActionResult Paging(int currentPageIndex, string type, string Search, string Button)
        {
            int PageNo;
            int LastPageNo = 1;
            if (Button == "N")
                PageNo = currentPageIndex + 1;
            else
                PageNo = currentPageIndex - 1;
            TempData["PageIndex"] = PageNo;
            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeFor_DashBoard, objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            bool srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForCost) + "~");

            List<USP_Get_Dashboard_Detail_Result> List = new List<USP_Get_Dashboard_Detail_Result>();

            if (type.ToUpper() == "AS")
            {
                List = BindStarAcqDeal(Search);
                StartAcqDealListCount = List.Count();
                StartAcqDealList_LastPageNo = ((StartAcqDealListCount / PageSize) - (StartAcqDealListCount % PageSize == 0 ? 1 : 0)) + 1;
                List = List.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();
                ViewBag.StartAcqDealList = List;
                ViewBag.StartAcqDealList_PageNo = PageNo;
                ViewBag.StartAcqDealList_LastPageNo = StartAcqDealList_LastPageNo;
                LastPageNo = StartAcqDealList_LastPageNo;
            }
            else if (type.ToUpper() == "SS")
            {
                List = BindStartSynDeal(Search);
                StartSynDealListCount = List.Count();
                StartSynDealList_LastPageNo = ((StartSynDealListCount / PageSize) - (StartSynDealListCount % PageSize == 0 ? 1 : 0)) + 1;
                List = List.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();
                ViewBag.StartSynDealList_PageNo = PageNo;
                ViewBag.StartSynDealList_LastPageNo = StartSynDealList_LastPageNo;
                LastPageNo = StartSynDealList_LastPageNo;
            }
            else if (type.ToUpper() == "AE")
            {
                List = BindExpiringAcqDeal(Search);
                ExpireAcqDealListCount = List.Count();

                ExpireAcqDealList_LastPageNo = ((ExpireAcqDealListCount / PageSize) - (ExpireAcqDealListCount % PageSize == 0 ? 1 : 0)) + 1;

                List = List.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                ViewBag.ExpireAcqDealList = List;

                ViewBag.ExpireAcqDealList_PageNo = PageNo;
                ViewBag.ExpireAcqDealList_LastPageNo = ExpireAcqDealList_LastPageNo;
                LastPageNo = ExpireAcqDealList_LastPageNo;
            }
            else if (type.ToUpper() == "SE")
            {
                List = BindExpiringSynDeal(Search);
                ExpireSynDealDataListCount = List.Count();

                ExpireSynDealDataList_LastPageNo = ((ExpireSynDealDataListCount / PageSize) - (ExpireSynDealDataListCount % PageSize == 0 ? 1 : 0)) + 1;

                List = List.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                ViewBag.ExpireSynDealDataList = List;

                ViewBag.ExpireSynDealDataList_PageNo = PageNo;
                ViewBag.ExpireSynDealDataList_LastPageNo = ExpireSynDealDataList_LastPageNo;
                LastPageNo = ExpireSynDealDataList_LastPageNo;
            }
            else if (type.ToUpper() == "AR")
            {
                List = BindROFRAcqDeal(Search);
                ROFR_AcquisitionListCount = List.Count();

                ROFR_AcquisitionList_LastPageNo = ((ROFR_AcquisitionListCount / PageSize) - (ROFR_AcquisitionListCount % PageSize == 0 ? 1 : 0)) + 1;

                List = List.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                ViewBag.ROFR_AcquisitionList = List;

                ViewBag.ROFR_AcquisitionList_PageNo = PageNo;
                ViewBag.ROFR_AcquisitionList_LastPageNo = ROFR_AcquisitionList_LastPageNo;
                LastPageNo = ROFR_AcquisitionList_LastPageNo;
            }
            else if (type.ToUpper() == "AT")
            {
                List = BindTentativeStartAcqDeal(Search);
                TentativeStartAcquDealsListCount = List.Count();
                List = List.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                TentativeStartAcquDealsList_LastPageNo = ((TentativeStartAcquDealsListCount / PageSize) - (TentativeStartAcquDealsListCount % PageSize == 0 ? 1 : 0)) + 1;

                ViewBag.TentativeStartAcquDealsList = List;

                ViewBag.TentativeStartAcquDealsList_PageNo = PageNo;
                ViewBag.TentativeStartAcquDealsList_LastPageNo = TentativeStartAcquDealsList_LastPageNo;
                LastPageNo = TentativeStartAcquDealsList_LastPageNo;
            }

            string Html = "";
            string html_Deal_No = "";
            if (srchaddRights == true)
                Html = Html + " <tr><th>Deal No.</th><th>Title</th><th>Party Name</th><th>Amount</th><th>Period</th></tr>";
            else
                Html = Html + " <tr><th>Deal No.</th><th>Title</th><th>Party Name</th><th>Period</th></tr>";

            foreach (USP_Get_Dashboard_Detail_Result Obj in List)
            {
                string Title = Obj.TitleName.Length >= 33 ? Obj.TitleName.Substring(0, 30) + "..." : Obj.TitleName;
                string Customer = Obj.Customer.Length >= 33 ? Obj.Customer.Substring(0, 30) + "..." : Obj.Customer;
                string Is_Deal_Right = Obj.Is_Deal_Rights != null ? Obj.Is_Deal_Rights : "Y";
                string DealUrl = "";
                if (type.ToUpper() == "SS" || type.ToUpper() == "SE")
                {
                    DealUrl = Url.Action("ButtonEvents", "Syn_List", new { CommandName = "View", Syn_Deal_Code = Obj.Deal_Code });
                }
                else
                {
                    DealUrl = Url.Action("ButtonEvents", "Acq_List", new { CommandName = "View", Acq_Deal_Code = Obj.Deal_Code });
                }
                if (Is_Deal_Right == "Y")
                    html_Deal_No = "<a href='" + DealUrl + "'>" + Obj.Agreement_No + "</a>";
                else
                    html_Deal_No = Obj.Agreement_No;

                Html = Html + "<tr>" + "<td><h5>" + html_Deal_No + "</h5></td>"
                             + "<td>" + "<h5 title='" + Obj.TitleName + "'>" + Title + "</h5></td>"
                             + "<td><div  title='" + Obj.Customer + "'>" + Customer + "</div></td>";
                if (srchaddRights == true)
                {
                    Html = Html + " <td class=\"amount\">" + String.Format("{0:n}", Obj.Deal_Movie_Cost) + "</td>";
                }
                Html = Html + " <td>" + Obj.RightPeriod + "</td>" + "</tr>";
            }

            return Json(new { Html = Html, PageNo = PageNo, LastPageNo = LastPageNo });
        }
        #endregion

        private List<int> GetUserRights(bool isGraphical = false)
        {
            int moduleCode = GlobalParams.ModuleCodeFor_DashBoard;
            if (isGraphical)
                moduleCode = GlobalParams.ModuleCodeFor_DashBoard_Graphical;
            arrUserRight = new Security_Group_Rel_Service(objLoginEntity.ConnectionStringName).SearchFor(i => i.Security_Group_Code == objLoginUser.Security_Group_Code
                            && i.System_Module_Rights_Code == i.System_Module_Right.Module_Right_Code
                            && i.System_Module_Right.Module_Code == moduleCode)
                .Select(i => i.System_Module_Right.Right_Code).Distinct().ToList();

            List<int> arrUserwiseRight;
            arrUserwiseRight = new Users_Exclusion_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Users_Code == objLoginUser.Users_Code).Select(s => s.System_Module_Right.Right_Code).Distinct().ToList();

            List<int> arrExclusiveRights = arrUserRight.Except(arrUserwiseRight).ToList();
            return arrExclusiveRights;
        }

        private void SessAppTimeOut()
        {
            HttpSessionState ss = System.Web.HttpContext.Current.Session;
            string sessionId = ss.SessionID;
            string entityKey = Convert.ToString(System.Web.HttpContext.Current.Session["Entity_Type"]);
            HttpApplicationState Application = HttpContext.ApplicationInstance.Application;
            Hashtable htLoggedUser = new Hashtable();

            if (Application["LOGGEDUSERS"] != null)
            {
                htLoggedUser = (Hashtable)Application["LOGGEDUSERS"];
                if (htLoggedUser.ContainsKey(objLoginUser.Login_Name + "#" + entityKey))
                {
                    string[] timeSessionId = new string[2];
                    timeSessionId = GetTimeAndSessionId(Convert.ToString(htLoggedUser[objLoginUser.Login_Name + "#" + entityKey]));
                    string storedSessionId = timeSessionId[1];

                    if (storedSessionId != sessionId)
                    {
                        Response.Redirect("~\\Login\\Index");
                        return;
                    }
                    else
                    {
                        int maxTime = Session.Timeout;
                        long maxTimeInSec = maxTime * 60;
                        long loggedTime = Convert.ToInt64(timeSessionId[0]);
                        long currentTime = Convert.ToInt64(GetDateComparisionNumber(DateTime.Now.ToString("s")));
                        long totalTimeDiffInSec = currentTime - loggedTime;

                        if (totalTimeDiffInSec > maxTimeInSec)
                        {
                            htLoggedUser.Remove(objLoginUser.Login_Name + "#" + entityKey);
                            Response.Redirect("~\\Login\\Index");
                            return;
                        }
                        else
                        {
                            htLoggedUser.Remove(objLoginUser.Login_Name + "#" + entityKey);
                            htLoggedUser.Add(objLoginUser.Login_Name + "#" + entityKey, GetDateComparisionNumber(DateTime.Now.ToString("s")) + "#" + sessionId);
                            Application.Lock();
                            Application["LOGGEDUSERS"] = htLoggedUser;
                            Application.UnLock();
                        }
                    }
                }
                else
                {
                    Response.Redirect("~\\Login\\Index");
                    return;
                }
            }
        }
        public string[] GetTimeAndSessionId(string timeSessionId)
        {
            string[] timeSession = new string[2];
            timeSession = timeSessionId.Split('#');
            return timeSession;
        }
        public static string GetDateComparisionNumber(string strDate)
        {
            string actualStr = strDate.Trim().Replace("T", "~").Replace(":", "~").Replace("-", "~");
            string[] arrDt = actualStr.Split('~');
            string tmpTimeInSec = arrDt[0].Trim() + arrDt[1].Trim() + arrDt[2].Trim() + Convert.ToString(Convert.ToInt64(Convert.ToInt64(arrDt[3].Trim()) * 60 * 60) + Convert.ToInt64(Convert.ToInt64(arrDt[4].Trim()) * 60) + Convert.ToInt64(arrDt[5].Trim()));
            return tmpTimeInSec;
        }
        public void LoadSystemMessage(int systemLanguageCode, int moduleCode)
        {
            if (systemLanguageCode > 0)
            {
                List<System_Language_Message> lstSystemMessage = new System_Language_Message_Service(objLoginEntity.ConnectionStringName).SearchFor(x =>
                x.System_Language_Code == systemLanguageCode && (x.System_Module_Message.Module_Code == moduleCode ||
                (x.System_Module_Message.Module_Code ?? 0) == 0
                )).ToList();
                objMessageKey.LayoutDirection = lstSystemMessage.FirstOrDefault().System_Language.Layout_Direction;
                Type type = objMessageKey.GetType();
                PropertyInfo[] prop = type.GetProperties();
                foreach (var p in prop)
                {
                    string a = p.Name;
                    string v = lstSystemMessage.Where(w => w.System_Module_Message.System_Message.Message_Key.Trim() == p.Name.Trim()).Select(s => s.Message_Desc).FirstOrDefault();
                    if (!string.IsNullOrEmpty(v))
                    {
                        p.SetValue(objMessageKey, v.Replace("\r\n", " "));
                    }
                }
            }
        }


        public ActionResult Show_Email_Popup1(string Email_Type)
        {
            List<Email_Notification_Log> lstLog = new List<Email_Notification_Log>();
            //string alertDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Email_Alert_Days").Select(x => x.Parameter_Value).FirstOrDefault();
            //DateTime dt = DateTime.Today.AddDays(Convert.ToDouble(alertDays));
            ////if (lstEmail_Notification_Log.Count == 0)
            ////{
            //lstEmail_Notification_Log = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.User_Code == objLoginUser.Users_Code
            //&& string.IsNullOrEmpty(x.Email_Body) == false && x.Created_Time >= dt
            //&& x.Email_Config.Email_Config_Detail.Select(e => e.OnScreen_Notification).FirstOrDefault() == "Y").ToList();
            ////}
            //lstLog = lstEmail_Notification_Log.Where(x => x.Email_Config_Code == Email_Type_Code).OrderBy(x => x.Is_Read).ToList();
            //ViewBag.EmailCount = lstLog.Where(w => w.Is_Read == "N").Count();
            //ViewBag.FirstTotalCount = lstLog.Count();
            return PartialView("_Email_Notification_Popup", lstLog);
        }
        public void updateSeenNotification(string Email_Log_Codes)
        {
            dynamic resultSet;
           
            //string[] Email_Log_Code = Email_Log_Codes.Split(',').Distinct().ToArray();
            //foreach (var item in Email_Log_Code)
            //{
            //    if (item != "")
            //    {
            //        Email_Notification_Log_Service objS = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName);
            //        int code = Convert.ToInt32(item);
            //        Email_Notification_Log objEmail_Notification_Log = objS.SearchFor(s => s.Email_Notification_Log_Code == code).FirstOrDefault();
            //        if (objEmail_Notification_Log.Is_Read == "N")
            //        {
            //            objEmail_Notification_Log.EntityState = State.Modified;
            //            objEmail_Notification_Log.Is_Read = "Y";
            //            objS.Save(objEmail_Notification_Log, out resultSet);
            //            lstEmail_Notification_Log.Where(w => w.Email_Notification_Log_Code == code).Select(x => x).FirstOrDefault().Is_Read = "Y";
            //        }
            //    }
            //}
        }
        public void MarkAllRead()
        {
            NotificationController obj = new NotificationController();
            List<GetMessageStatus> lstGetMessageStatus = obj.GetMessageStatusDetails("", objLoginUser.Email_Id);
            foreach (GetMessageStatus item in lstGetMessageStatus)
            {
                obj.UpdateMessageStatusDetails(item.NotificationsCode, item.NotificationDetailCode);
            }

            //string alertDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Email_Alert_Days").Select(x => x.Parameter_Value).FirstOrDefault();
            //DateTime dt = DateTime.Today.AddDays(Convert.ToDouble(alertDays));
            //List<Email_Notification_Log> lst = new List<Email_Notification_Log>();
            //lst = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.User_Code == objLoginUser.Users_Code
            //      && string.IsNullOrEmpty(x.Email_Body) == false && x.Created_Time >= dt
            //      && x.Email_Config.Email_Config_Detail.Select(e => e.OnScreen_Notification).FirstOrDefault() == "Y").ToList();
            //string[] emailnotifycode = lst.Select(x => x.Email_Notification_Log_Code.ToString()).ToArray();
            //dynamic resultSet;
            //foreach (var item in emailnotifycode)
            //{
            //    Email_Notification_Log_Service objS = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName);
            //    int code = Convert.ToInt32(item);
            //    Email_Notification_Log objEmail_Notification_Log = objS.SearchFor(s => s.Email_Notification_Log_Code == code).FirstOrDefault();
            //    if (objEmail_Notification_Log.Is_Read == "N")
            //    {
            //        objEmail_Notification_Log.EntityState = State.Modified;
            //        objEmail_Notification_Log.Is_Read = "Y";
            //        objS.Save(objEmail_Notification_Log, out resultSet);
            //    }
            //}
        }
        public JsonResult UpdateSystemLanguage(int systemLanguageCode)
        {
            string status = "S", message = "Language Updated successfully";

            User_Service objService = new User_Service(objLoginEntity.ConnectionStringName);

            if (systemLanguageCode > 0)
            {
                objLoginUser.System_Language_Code = systemLanguageCode;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }

    }
}
