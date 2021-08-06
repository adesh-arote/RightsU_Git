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
    public class IPR_DashboardController : Controller
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

            if (arrUserRight.Count > 0)
            {
                #region------- BindTables--------

                if (arrUserRight.Contains(GlobalParams.RightsCodeForAcquisitionRightsStart))
                {
                    List<USP_Get_IPR_Dashboard_Details_Result> StartAcqDealList = BindDomesticExpiry(Search);

                    StartAcqDealListCount = StartAcqDealList.Count();

                    StartAcqDealList_LastPageNo = ((StartAcqDealListCount / PageSize) - (StartAcqDealListCount % PageSize == 0 ? 1 : 0)) + 1;

                    StartAcqDealList = StartAcqDealList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.StartAcqDealList = StartAcqDealList;
                }
                else
                    ViewBag.StartAcqDealList = null;

                if (arrUserRight.Contains(GlobalParams.RightsCodeForAcquisitionRightsStart))
                {
                    List<USP_Get_IPR_Dashboard_Details_Result> AproveAcqDealList = BindInternationalExpiry(Search);

                    AprovedAcqDealListCount = AproveAcqDealList.Count();

                    AprovedAcqDealList_PageNo = ((AprovedAcqDealListCount / PageSize) - (AprovedAcqDealListCount % PageSize == 0 ? 1 : 0)) + 1;

                    AproveAcqDealList = AproveAcqDealList.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();

                    ViewBag.AproveAcqDealList = AproveAcqDealList;
                }
                else
                    ViewBag.AproveAcqDealList = null;

                #endregion

                #region ------ Title------
                string DomesticTrademarkExpiryDays = "";
                string InternationalTrademarkExpiryDays = "";

                DomesticTrademarkExpiryDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-TE").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
                InternationalTrademarkExpiryDays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ITE").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();

                if (DomesticTrademarkExpiryDays == null)
                    DomesticTrademarkExpiryDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-TE").Select(s => s.Parameter_Value).FirstOrDefault();
                if (InternationalTrademarkExpiryDays == null)
                    InternationalTrademarkExpiryDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ITE").Select(s => s.Parameter_Value).FirstOrDefault();


                string DomesticDesc = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-TE").Select(s => s.Description).FirstOrDefault();
                string InternationalDesc = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ITE").Select(s => s.Description).FirstOrDefault();

                ViewBag.DT = DomesticDesc + " " + DomesticTrademarkExpiryDays +" "+ "days";
                ViewBag.AT = InternationalDesc +" "+ InternationalTrademarkExpiryDays+" "+ "days";
                //string DealStartAndExp_Days = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "DB-ADTA").Select(s => s.Description).FirstOrDefault();

                ViewBag.DealStartAndExp_Days = DealStartAndExp_Days;
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
        //private List<USP_Get_Dashboard_Detail_Result> BindStarAcqDeal(string Search)
        private List<USP_Get_IPR_Dashboard_Details_Result> BindDomesticExpiry(string Search)
        {
            string DomesticExpirydays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-TE").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
            List<USP_Get_IPR_Dashboard_Details_Result> DomesticList = objUSP_Service.USP_Get_IPR_Dashboard_Detail("D", Search, objLoginUser.Users_Code, Convert.ToInt32(DomesticExpirydays)).ToList();
            return DomesticList;
        }

        //private List<USP_Get_Dashboard_Detail_Result> BindAproveAcqDeal(string Search)
        private List<USP_Get_IPR_Dashboard_Details_Result> BindInternationalExpiry(string Search)
        {
            string IntTEExpirydays = new Users_Configuration_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Users_Code == objLoginUser.Users_Code && w.Dashboard_Key == "DB-ITE").Select(s => s.Dashboard_Value.ToString()).FirstOrDefault();
            List<USP_Get_IPR_Dashboard_Details_Result> InternationalList = objUSP_Service.USP_Get_IPR_Dashboard_Detail("I", Search, objLoginUser.Users_Code, Convert.ToInt32(IntTEExpirydays)).ToList();
            return InternationalList;
        }
        private int StartAndExpiryDays()
        {
            int DealStartAndExp_Days = Convert.ToInt32(new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name.ToUpper() == "DASHBOARD_DAYS").Select(s => s.Parameter_Value).FirstOrDefault());

            return DealStartAndExp_Days;
        }

        //public ActionResult Paging(int currentPageIndex, string type, string Search, string Button)
        //{
        //    int PageNo;
        //    int LastPageNo = 1;
        //    if (Button == "N")
        //        PageNo = currentPageIndex + 1;
        //    else
        //        PageNo = currentPageIndex - 1;
        //    TempData["PageIndex"] = PageNo;
        //    ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(GlobalParams.ModuleCodeFor_DashBoard, objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
        //    bool srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForCost) + "~");

        //    List<USP_Get_IPR_Dashboard_Details_Result> List = new List<USP_Get_IPR_Dashboard_Details_Result>();

        //    if (type.ToUpper() == "D")
        //    {
        //        List = BindDomesticExpiry(Search);
        //        StartAcqDealListCount = List.Count();
        //        StartAcqDealList_LastPageNo = ((StartAcqDealListCount / PageSize) - (StartAcqDealListCount % PageSize == 0 ? 1 : 0)) + 1;
        //        List = List.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();
        //        ViewBag.StartAcqDealList = List;
        //        ViewBag.StartAcqDealList_PageNo = PageNo;
        //        ViewBag.StartAcqDealList_LastPageNo = StartAcqDealList_LastPageNo;
        //        LastPageNo = StartAcqDealList_LastPageNo;
        //    }
        //    else if (type.ToUpper() == "I")
        //    {
        //        List = BindInternationalExpiry(Search);
        //        StartSynDealListCount = List.Count();
        //        StartSynDealList_LastPageNo = ((StartSynDealListCount / PageSize) - (StartSynDealListCount % PageSize == 0 ? 1 : 0)) + 1;
        //        List = List.Skip((PageNo - 1) * PageSize).Take(PageSize).ToList();
        //        ViewBag.StartSynDealList_PageNo = PageNo;
        //        ViewBag.StartSynDealList_LastPageNo = StartSynDealList_LastPageNo;
        //        LastPageNo = StartSynDealList_LastPageNo;
        //    }

        //    string Html = "";
        //    string html_Deal_No = "";
        //    if (srchaddRights == true)
        //        Html = Html + " <tr><th>Deal No.</th><th>Title</th><th>Party Name</th><th>Amount</th><th>Period</th></tr>";
        //    else
        //        Html = Html + " <tr><th>Deal No.</th><th>Title</th><th>Party Name</th><th>Period</th></tr>";

        //    //foreach (USP_Get_IPR_Dashboard_Details_Result Obj in List)
        //    //{
        //    //    string Title = Obj.Trademark_No.Length >= 33 ? Obj.Trademark_No.Substring(0, 30) + "..." : Obj.Trademark_No;
        //    //    string Customer = Obj.Trademark_Name.Length >= 33 ? Obj.Trademark_Name.Substring(0, 30) + "..." : Obj.Trademark_Name;
        //    //    string Is_Deal_Right = Obj.Is_Deal_Rights != null ? Obj.Is_Deal_Rights : "Y";
        //    //    string DealUrl = "";
        //    //    if (type.ToUpper() == "SS" || type.ToUpper() == "SE")
        //    //    {
        //    //        DealUrl = Url.Action("ButtonEvents", "Syn_List", new { CommandName = "View", Syn_Deal_Code = Obj.Deal_Code });
        //    //    }
        //    //    else
        //    //    {
        //    //        DealUrl = Url.Action("ButtonEvents", "Acq_List", new { CommandName = "View", Acq_Deal_Code = Obj.Deal_Code });
        //    //    }
        //    //    if (Is_Deal_Right == "Y")
        //    //        html_Deal_No = "<a href='" + DealUrl + "'>" + Obj.Agreement_No + "</a>";
        //    //    else
        //    //        html_Deal_No = Obj.Agreement_No;

        //    //    Html = Html + "<tr>" + "<td><h5>" + html_Deal_No + "</h5></td>"
        //    //                 + "<td>" + "<h5 title='" + Obj.TitleName + "'>" + Title + "</h5></td>"
        //    //                 + "<td><div  title='" + Obj.Customer + "'>" + Customer + "</div></td>";
        //    //    if (srchaddRights == true)
        //    //    {
        //    //        Html = Html + " <td class=\"amount\">" + String.Format("{0:n}", Obj.Deal_Movie_Cost) + "</td>";
        //    //    }
        //    //    Html = Html + " <td>" + Obj.RightPeriod + "</td>" + "</tr>";
        //    //}

        //    return Json(new { Html = Html, PageNo = PageNo, LastPageNo = LastPageNo });
        //}
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


        public ActionResult Show_Email_Popup(int Email_Type_Code)
        {
            List<Email_Notification_Log> lstLog = new List<Email_Notification_Log>();
            string alertDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Email_Alert_Days").Select(x => x.Parameter_Value).FirstOrDefault();
            DateTime dt = DateTime.Today.AddDays(Convert.ToDouble(alertDays));
            //if (lstEmail_Notification_Log.Count == 0)
            //{
            lstEmail_Notification_Log = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.User_Code == objLoginUser.Users_Code
            && string.IsNullOrEmpty(x.Email_Body) == false && x.Created_Time >= dt
            && x.Email_Config.Email_Config_Detail.Select(e => e.OnScreen_Notification).FirstOrDefault() == "Y").ToList();
            //}
            lstLog = lstEmail_Notification_Log.Where(x => x.Email_Config_Code == Email_Type_Code).OrderBy(x => x.Is_Read).ToList();
            ViewBag.EmailCount = lstLog.Where(w => w.Is_Read == "N").Count();
            ViewBag.FirstTotalCount = lstLog.Count();
            return PartialView("_Email_Notification_Popup", lstLog);
        }
        public void updateSeenNotification(string Email_Log_Codes)
        {
            dynamic resultSet;

            string[] Email_Log_Code = Email_Log_Codes.Split(',').Distinct().ToArray();
            foreach (var item in Email_Log_Code)
            {
                if (item != "")
                {
                    Email_Notification_Log_Service objS = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName);
                    int code = Convert.ToInt32(item);
                    Email_Notification_Log objEmail_Notification_Log = objS.SearchFor(s => s.Email_Notification_Log_Code == code).FirstOrDefault();
                    if (objEmail_Notification_Log.Is_Read == "N")
                    {
                        objEmail_Notification_Log.EntityState = State.Modified;
                        objEmail_Notification_Log.Is_Read = "Y";
                        objS.Save(objEmail_Notification_Log, out resultSet);
                        lstEmail_Notification_Log.Where(w => w.Email_Notification_Log_Code == code).Select(x => x).FirstOrDefault().Is_Read = "Y";
                    }
                }
            }
        }
        public void MarkAllRead()
        {
            string alertDays = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Email_Alert_Days").Select(x => x.Parameter_Value).FirstOrDefault();
            DateTime dt = DateTime.Today.AddDays(Convert.ToDouble(alertDays));
            List<Email_Notification_Log> lst = new List<Email_Notification_Log>();
            lst = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.User_Code == objLoginUser.Users_Code
                  && string.IsNullOrEmpty(x.Email_Body) == false && x.Created_Time >= dt
                  && x.Email_Config.Email_Config_Detail.Select(e => e.OnScreen_Notification).FirstOrDefault() == "Y").ToList();
            string[] emailnotifycode = lst.Select(x => x.Email_Notification_Log_Code.ToString()).ToArray();
            dynamic resultSet;
            foreach (var item in emailnotifycode)
            {
                Email_Notification_Log_Service objS = new Email_Notification_Log_Service(objLoginEntity.ConnectionStringName);
                int code = Convert.ToInt32(item);
                Email_Notification_Log objEmail_Notification_Log = objS.SearchFor(s => s.Email_Notification_Log_Code == code).FirstOrDefault();
                if (objEmail_Notification_Log.Is_Read == "N")
                {
                    objEmail_Notification_Log.EntityState = State.Modified;
                    objEmail_Notification_Log.Is_Read = "Y";
                    objS.Save(objEmail_Notification_Log, out resultSet);
                }
            }
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
