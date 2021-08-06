using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using System.Data.Entity.Core.Objects;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.Collections;
using System.Web.UI.WebControls;
using System.IO;
using System.Web.UI;
using Microsoft.Reporting.WebForms;

namespace RightsU_Plus.Controllers
{
    public class IPR_ListController : BaseController
    {
        #region --- Attributes and Properties ---
        ReportViewer ReportViewer1;
        ArrayList arrUserRight;
        public int moduleCode = GlobalParams.ModuleCodeFor_IPR_Application;

        public IPR_List_Search objPage_Properties
        {
            get
            {
                if (Session["IPR_List_Search_Page_Properties"] == null)
                    Session["IPR_List_Search_Page_Properties"] = new IPR_List_Search();
                return (IPR_List_Search)Session["IPR_List_Search_Page_Properties"];
            }
            set { Session["IPR_List_Search_Page_Properties"] = value; }
        }


        public int pageNo
        {
            get
            {
                if (Session["PageNo"] == null)
                    Session["PageNo"] = 0;
                return (int)Session["PageNo"];
            }
            set { Session["PageNo"] = value; }
        }

        public int DpageNo
        {
            get
            {
                if (Session["dPageNo"] == null)
                    Session["dPageNo"] = 1;
                return (int)Session["dPageNo"];
            }
            set { Session["dPageNo"] = value; }
        }
        public int IpageNo
        {
            get
            {
                if (Session["iPageNo"] == null)
                    Session["iPageNo"] = 1;
                return (int)Session["iPageNo"];
            }
            set { Session["iPageNo"] = value; }
        }
        public int BpageNo
        {
            get
            {
                if (Session["bPageNo"] == null)
                    Session["bPageNo"] = 1;
                return (int)Session["bPageNo"];
            }
            set { Session["bPageNo"] = value; }
        }
        public int ApageNo
        {
            get
            {
                if (Session["aPageNo"] == null)
                    Session["aPageNo"] = 1;
                return (int)Session["aPageNo"];
            }
            set { Session["aPageNo"] = value; }
        }
        public string tab
        {
            get
            {
                if (Session["TABNAME"] == null)
                    Session["TABNAME"] = "";
                return (String)Session["TABNAME"];
            }
            set { Session["TABNAME"] = value; }
        }


        private int _recordPerPage = 10;
        public int recordPerPage
        {
            get { return _recordPerPage; }
            set { _recordPerPage = value; }
        }

        public string IsAdvanced
        {
            get
            {
                if (Session["isAdvanced"] == null)
                    Session["isAdvanced"] = String.Empty;
                return (string)Session["isAdvanced"];
            }
            set { Session["isAdvanced"] = value; }
        }
        public string Common_Search
        {
            get
            {
                if (Session["Common_Search"] == null)
                    Session["Common_Search"] = string.Empty;
                return (string)Session["Common_Search"];
            }
            set { Session["Common_Search"] = value; }
        }
        public string ApplicationNo
        {
            get
            {
                if (Session["applicationNo"] == null)
                    Session["applicationNo"] = string.Empty;
                return (string)Session["applicationNo"];
            }
            set { Session["applicationNo"] = value; }
        }

        public string RegistrationNo
        {
            get
            {
                if (Session["registrationNo"] == null)
                    Session["registrationNo"] = string.Empty;
                return (string)Session["registrationNo"];
            }
            set { Session["registrationNo"] = value; }
        }
        public string Type
        {
            get
            {
                if (Session["type"] == null)
                    Session["type"] = "0";
                return (string)Session["type"];
            }
            set { Session["type"] = value; }
        }
        public string Business_Unit
        {
            get
            {
                if (Session["Business_Unit"] == null)
                    Session["Business_Unit"] = "0";
                return (string)Session["Business_Unit"];
            }
            set { Session["Business_Unit"] = value; }
        }
        public string Channel
        {
            get
            {
                if (Session["Channel"] == null)
                    Session["Channel"] = "0";
                return (string)Session["Channel"];
            }
            set { Session["Channel"] = value; }
        }
        public string Trademark
        {
            get
            {
                if (Session["trademark"] == null)
                    Session["trademark"] = string.Empty;
                return (string)Session["trademark"];
            }
            set { Session["trademark"] = value; }
        }
        public string TradeMarkAtto
        {
            get
            {
                if (Session["tradeMarkAtto"] == null)
                    Session["tradeMarkAtto"] = string.Empty;
                return (string)Session["tradeMarkAtto"];
            }
            set { Session["tradeMarkAtto"] = value; }
        }
        public string AppFromDate
        {
            get
            {
                if (Session["appFromDate"] == null)
                    Session["appFromDate"] = string.Empty;
                return (string)Session["appFromDate"];
            }
            set { Session["appFromDate"] = value; }
        }
        public string AppToDate
        {
            get
            {
                if (Session["appToDate"] == null)
                    Session["appToDate"] = "";
                return (String)Session["appToDate"];
            }
            set { Session["appToDate"] = value; }
        }
        public string Applicant
        {
            get
            {
                if (Session["applicant"] == null)
                    Session["applicant"] = "0";
                return (String)Session["applicant"];
            }
            set { Session["applicant"] = value; }
        }
        public string ApplicationStatus
        {
            get
            {
                if (Session["applicationStatus"] == null)
                    Session["applicationStatus"] = "0";
                return (String)Session["applicationStatus"];
            }
            set { Session["applicationStatus"] = value; }
        }
        public string RenToDate
        {
            get
            {
                if (Session["renToDate"] == null)
                    Session["renToDate"] = "";
                return (String)Session["renToDate"];
            }
            set { Session["renToDate"] = value; }
        }
        public string RenFromDate
        {
            get
            {
                if (Session["renFromDate"] == null)
                    Session["renFromDate"] = "";
                return (String)Session["renFromDate"];
            }
            set { Session["renFromDate"] = value; }
        }
        public string Classt
        {
            get
            {
                if (Session["classt"] == null)
                    Session["classt"] = "";
                return (String)Session["classt"];
            }
            set { Session["classt"] = value; }
        }
        public string UseFromDate
        {
            get
            {
                if (Session["useFromDate"] == null)
                    Session["useFromDate"] = "";
                return (String)Session["useFromDate"];
            }
            set { Session["useFromDate"] = value; }
        }
        public string UseToDate
        {
            get
            {
                if (Session["useToDate"] == null)
                    Session["useToDate"] = "";
                return (String)Session["useToDate"];
            }
            set { Session["useToDate"] = value; }
        }
        public string OppositionNo
        {
            get
            {
                if (Session["oppositionNo"] == null)
                    Session["oppositionNo"] = "";
                return (String)Session["oppositionNo"];
            }
            set { Session["oppositionNo"] = value; }
        }
        public string OppStatus
        {
            get
            {
                if (Session["oppStatus"] == null)
                    Session["oppStatus"] = "0";
                return (String)Session["oppStatus"];
            }
            set { Session["oppStatus"] = value; }
        }
        public string Country
        {
            get
            {
                if (Session["country"] == null)
                    Session["country"] = "0";
                return (String)Session["country"];
            }
            set { Session["country"] = value; }
        }

        #endregion

        private const string CurrentTab_OppositionBy = "B";
        private const string CurrentTab_OppositionAgainst = "A";
        private const string CurrentTab_Domestic = "D";
        private const string CurrentTab_International = "I";
        #region --Methods--

        public JsonResult CheckRecordCurrentStatus(int IPR_Int_Opp_Code)
        {
            string message = "";
            int RLCode = 0;
            bool isLocked = false;
           
            if (IPR_Int_Opp_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(IPR_Int_Opp_Code, GlobalParams.ModuleCodeFor_IPR_Application, objLoginUser.Users_Code, out RLCode, out message, objLoginEntity.ConnectionStringName);
            }
            var obj = new
            {      
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = message,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }

        public JsonResult CheckRecordLock(int IPR_Rep_Code = 0 , int IPR_Opp_Code = 0)
        {
            string strMessage = "";
            int RLCode = 0;
            bool isLocked = true;
            int IPR_Rep_Opp_Code = 0;

            if (IPR_Rep_Code == 0)
                IPR_Rep_Opp_Code = IPR_Opp_Code;
            else
                IPR_Rep_Opp_Code = IPR_Rep_Code;

            if (IPR_Rep_Opp_Code > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                isLocked = objCommonUtil.Lock_Record(IPR_Rep_Opp_Code, GlobalParams.ModuleCodeFor_IPR_Application, objLoginUser.Users_Code, out RLCode, out strMessage, objLoginEntity.ConnectionStringName);
            }
            if (isLocked)
            {
                objPage_Properties.RecordLockingCode = RLCode;
                TempData["RecodLockingCode"] = objPage_Properties.RecordLockingCode;
            }
            

            var obj = new
            {
                Is_Locked = (isLocked) ? "Y" : "N",
                Message = strMessage,
                Record_Locking_Code = RLCode
            };
            return Json(obj);
        }


        public ActionResult Index()
        {
            string IsMenu = "";
            if (Request.QueryString["IsMenu"] != null)
                IsMenu = Request.QueryString["IsMenu"];
            if (IsMenu == "Y")
            {
                Reset_Srch_Criteria();
                ResetPaging();
            }
            int RecordLockingCode = objPage_Properties.RecordLockingCode;
            tab = "";
            SelectList type_List = new SelectList((new IPR_TYPE_Service(objLoginEntity.ConnectionStringName).SearchFor(x => 1 == 1).ToList()).OrderBy(o => o.Type), "Type", "Type", Type);
            SelectList applicationStatus_List = new SelectList(((new IPR_APP_STATUS_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y").ToList()), "App_Status",
            "App_Status", ApplicationStatus);
            SelectList applicant_List = new SelectList((new IPR_ENTITY_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => 1 == 1).ToList(), "Entity", "Entity", Applicant);
            SelectList oppStatus_List = new SelectList((new IPR_Opp_Status_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y").ToList().OrderBy(o => o.Opp_Status),
            "Opp_Status", "Opp_Status", OppStatus);
            SelectList country_List = new SelectList(((new IPR_Country_Service(objLoginEntity.ConnectionStringName)).SearchFor(x => x.Is_Active == "Y").ToList()), "IPR_Country_Name", "IPR_Country_Name", Country);
            ViewBag.Type_List = type_List;
            ViewBag.ApplicationStatus_List = applicationStatus_List;
            ViewBag.Applicant_List = applicant_List;
            ViewBag.OppStatus_List = oppStatus_List;
            ViewBag.Country_List = country_List;

            List<Business_Unit> lstBusinessUnit = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(w => true).OrderBy(o => o.Business_Unit_Name).ToList();
            ViewBag.BusinessUnitList = new MultiSelectList(lstBusinessUnit, "Business_Unit_Code", "Business_Unit_Name");
            List<RightsU_Entities.Channel> lstChannel = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Is_Active == "Y").OrderBy(o => o.Channel_Name).ToList();
            ViewBag.ChannelList = new MultiSelectList(lstChannel, "Channel_Code", "Channel_Name");

            ObjectResult<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(moduleCode), objLoginUser.Security_Group_Code, objLoginUser.Users_Code);
            string c = addRights.FirstOrDefault();
            ViewBag.AddVisibility = c;
            ViewBag.NoRight = true;
            ViewBag.NoRight = true;
            if ((Request.QueryString["TABNAME"]) != null)
            {
                tab = (Request.QueryString["TABNAME"]);
                ViewBag.applicationNo = ApplicationNo;
                ViewBag.common_Search = Common_Search;
                ViewBag.trademark = Trademark;
                ViewBag.tradeMarkAtto = TradeMarkAtto;
                ViewBag.appFromDate = AppFromDate;
                ViewBag.appToDate = AppToDate;
                ViewBag.renFromDate = RenFromDate;
                ViewBag.renToDate = RenToDate;
                ViewBag.classt = Classt;
                ViewBag.useFromDate = UseFromDate;
                ViewBag.useToDate = UseToDate;
                ViewBag.oppositionNo = OppositionNo;
                ViewBag.businessUnit = Business_Unit;
                ViewBag.channel = Channel;
            }
            else
            {
                if (c.Contains("~" + GlobalParams.RightCodeForDomesticTab + "~"))
                    tab = "D";
                else if (c.Contains("~" + GlobalParams.RightCodeForInternationalTab + "~"))
                    tab = "I";
                else if (c.Contains("~" + GlobalParams.RightCodeForOppositionByTab + "~"))
                    tab = "B";
                else if (c.Contains("~" + GlobalParams.RightCodeForOppositionAgainstTab + "~"))
                    tab = "A";
                else
                    ViewBag.NoRight = false;
            }


            if (RecordLockingCode > 0)
            {
                CommonUtil objCommonUtil = new CommonUtil();
                objCommonUtil.Release_Record(RecordLockingCode, objLoginEntity.ConnectionStringName);
            }

            ViewBag.isAdvanced = IsAdvanced;
            ViewBag.IsMenu = IsMenu;
            ViewBag.Tab = tab;
            return View();
        }
        public ActionResult ModalPopup(string ApplicationNo ,int IPRRepCode)
        {
            ModalPopupList lstModal = new ModalPopupList();
            IPR_Opp_Service objIPR_REP_Service = new IPR_Opp_Service(objLoginEntity.ConnectionStringName);
            IPR_REP_Class_Service objIPR_REP_Class_Service = new IPR_REP_Class_Service(objLoginEntity.ConnectionStringName);

            ViewBag.IPRDomesticClass = objIPR_REP_Class_Service.SearchFor(s => s.IPR_Rep_Code == IPRRepCode && s.IPR_REP.IPR_For == "D" && s.IPR_Class_Code == s.IPR_CLASS.IPR_Class_Code).Select(x => x.IPR_CLASS.Description).ToList();
            ViewBag.IPRInternationalClass = objIPR_REP_Class_Service.SearchFor(s => s.IPR_Rep_Code == IPRRepCode && s.IPR_REP.IPR_For == "I" && s.IPR_Class_Code == s.IPR_CLASS.IPR_Class_Code).Select(x => x.IPR_CLASS.Description).ToList();
            lstModal.OppoBy = objIPR_REP_Service.SearchFor(s => s.IPR_REP.Application_No == ApplicationNo && s.IPR_For == "B").Select(s => s).ToList();
            lstModal.OppoAgainst = objIPR_REP_Service.SearchFor(s => s.IPR_REP.Application_No == ApplicationNo && s.IPR_For == "A").Select(s => s).ToList();

            return PartialView("_OppositionDetailPopup", lstModal);
        }

        public ActionResult ButtonEvent(string MODE, int? IPR_Rep_Code, int? IPR_Opp_Code)
        {
            Dictionary<string, string> obj_Dictionary_IPRList = new Dictionary<string, string>();
            obj_Dictionary_IPRList.Add("MODE", MODE);
            obj_Dictionary_IPRList.Add("Tab", tab);
            if (tab == "B" || tab == "A" || IPR_Opp_Code > 0)
            {
                obj_Dictionary_IPRList.Add("IPR_Opp_Code", IPR_Opp_Code == null ? "0" : IPR_Opp_Code.ToString());
                TempData["QueryString_IPR"] = obj_Dictionary_IPRList;
                return RedirectToAction("Index", "IPR_OppBy_Against");
            }
            else
            {
                obj_Dictionary_IPRList.Add("IPR_Rep_Code", IPR_Rep_Code == null ? "0" : IPR_Rep_Code.ToString());
                TempData["QueryString_IPR"] = obj_Dictionary_IPRList;
                return RedirectToAction("Index", "IPR_Int_Dom");
            }
        }

        public PartialViewResult Bind_Grid_Domestic_List(string Tab = "", string SearchCriteria = "", string PageNo = "0", string Istabchange = "", string IsSetPage = "", int recordPerPage = 10)
        {
            if (PageNo == "0")
                ResetPaging();
            string search = "";
            if (Istabchange != "Y")
                search = FillSearch(Tab);
            else
                Reset_Srch_Criteria();
            string isPaging = "Y";
            int RecordCount = 0;
            if (PageNo == "")
                PageNo = "0";
            pageNo = Convert.ToInt32(PageNo) + 1;
            if (IsSetPage == "Y")
                SetPageNo(Tab, Convert.ToInt32(PageNo) + 1);
            ViewBag.isAdvanced = IsAdvanced;
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            if (Tab != "")
                tab = Tab;
            if (tab == CurrentTab_International)
            {
                string orderByCndition = "T.IPR_Rep_Code desc";
                List<USP_List_IPR_Result> lst = new List<USP_List_IPR_Result>();
                search += " AND IR.IPR_For = 'I'";
                lst = (new USP_Service(objLoginEntity.ConnectionStringName).USP_List_IPR("I", search, IpageNo, orderByCndition, isPaging,
                    recordPerPage, objRecordCount, objLoginUser.Users_Code, Convert.ToInt32(moduleCode)).ToList());
                RecordCount = Convert.ToInt32(objRecordCount.Value);
                ViewBag.RecordCount = RecordCount;
                ViewBag.Tab = CurrentTab_International;
                ViewBag.PageNo = IpageNo;
                return PartialView("List_International", lst);
            }
            else if (tab == CurrentTab_OppositionBy)
            {
                string orderByCndition = "IOp.IPR_Opp_Code desc";
                List<USP_List_IPR_Opp_Result> lst = new List<USP_List_IPR_Opp_Result>();
                search += " AND IOp.IPR_For = 'B'";
                lst = (new USP_Service(objLoginEntity.ConnectionStringName).USP_List_IPR_Opp(CurrentTab_OppositionBy, search, BpageNo,
                    orderByCndition, isPaging, recordPerPage, objRecordCount, objLoginUser.Users_Code, Convert.ToInt32(moduleCode)).ToList());
                RecordCount = Convert.ToInt32(objRecordCount.Value);
                ViewBag.RecordCount = RecordCount;
                ViewBag.Tab = CurrentTab_OppositionBy;
                ViewBag.PageNo = BpageNo;
                return PartialView("List_OppBy", lst);
            }
            else if (tab == CurrentTab_OppositionAgainst)
            {
                string orderByCndition = "IOp.IPR_Opp_Code desc";
                List<USP_List_IPR_Opp_Result> lst = new List<USP_List_IPR_Opp_Result>();
                search += " AND IOp.IPR_For = 'A'";
                lst = (new USP_Service(objLoginEntity.ConnectionStringName).USP_List_IPR_Opp(CurrentTab_OppositionAgainst, search, ApageNo,
                    orderByCndition, isPaging, recordPerPage, objRecordCount, objLoginUser.Users_Code, Convert.ToInt32(moduleCode)).ToList());
                RecordCount = Convert.ToInt32(objRecordCount.Value);
                ViewBag.RecordCount = RecordCount;
                ViewBag.Tab = CurrentTab_OppositionAgainst;
                ViewBag.PageNo = ApageNo;
                return PartialView("List_OppAgainst", lst);
            }
            else
            {
                string orderByCndition = "T.IPR_Rep_Code desc";
                List<USP_List_IPR_Result> lst = new List<USP_List_IPR_Result>();
                search += " AND IR.IPR_For = 'D'";
                lst = (new USP_Service(objLoginEntity.ConnectionStringName).USP_List_IPR("D", search, DpageNo, orderByCndition, isPaging,
                    recordPerPage, objRecordCount, objLoginUser.Users_Code, Convert.ToInt32(moduleCode)).ToList());
                RecordCount = Convert.ToInt32(objRecordCount.Value);
                ViewBag.RecordCount = RecordCount;
                ViewBag.Tab = CurrentTab_Domestic;
                ViewBag.PageNo = DpageNo;
                return PartialView("List_Domestic", lst);
            }
        }

        private void SetPageNo(string Tab = "", int p = 1)
        {
            if (Tab == CurrentTab_Domestic)
                DpageNo = p;
            else if (Tab == CurrentTab_International)
                IpageNo = p;
            else if (Tab == CurrentTab_OppositionAgainst)
                ApageNo = p;
            else if (Tab == CurrentTab_OppositionBy)
                BpageNo = p;
        }

        public PartialViewResult SearchList(string Tab, string applicationNo, string type, string trademark, string tradeMarkAtto, string appFromDate,
              string appToDate, string applicationStatus, string applicant, string renFromDate, string renToDate, string classt, string useFromDate, string useToDate,
              string oppositionNo, string oppStatus, string country, string businessUnit = "0", string channel = "0", string SearchCommon = "", string PageNo = "0", string isAdvanced = "", string registrationNo = "")
        {
            ResetPaging();
            Common_Search = SearchCommon;
            ApplicationNo = applicationNo;
            Trademark = trademark;
            Type = type;
            Business_Unit = businessUnit;
            Channel = channel;
            TradeMarkAtto = tradeMarkAtto;
            AppFromDate = appFromDate;
            AppToDate = appToDate;
            ApplicationStatus = applicationStatus;
            Applicant = applicant;
            RenFromDate = renFromDate;
            RenToDate = renToDate;
            Classt = classt;
            UseFromDate = useFromDate;
            UseToDate = useToDate;
            OppositionNo = oppositionNo;
            OppStatus = oppStatus;
            Country = country;
            IsAdvanced = isAdvanced;
            RegistrationNo = registrationNo;
            return Bind_Grid_Domestic_List(Tab, PageNo);
        }

        private void Reset_Srch_Criteria()
        {
            Common_Search = string.Empty;
            ApplicationNo = string.Empty;
            Trademark = string.Empty;
            Type = string.Empty;
            Business_Unit = string.Empty;
            Channel = string.Empty;
            TradeMarkAtto = string.Empty;
            AppFromDate = string.Empty;
            AppToDate = string.Empty;
            ApplicationStatus = string.Empty;
            Applicant = string.Empty;
            RenFromDate = string.Empty;
            RenToDate = string.Empty;
            Classt = string.Empty;
            UseFromDate = string.Empty;
            UseToDate = string.Empty;
            OppositionNo = string.Empty;
            OppStatus = string.Empty;
            Country = string.Empty;
            IsAdvanced = string.Empty;
            RegistrationNo = string.Empty;

            Session["common_Search"] = null;
            Session["applicationNo"] = null;
            Session["trademark"] = null;
            Session["type"] = null;
            Session["Business_Unit"] = null;
            Session["Channel"] = null;
            Session["tradeMarkAtto"] = null;
            Session["appFromDate"] = null;
            Session["appToDate"] = null;
            Session["applicationStatus"] = null;
            Session["Applicant"] = null;
            Session["renFromDate"] = null;
            Session["renToDate"] = null;
            Session["classt"] = null;
            Session["useFromDate"] = null;
            Session["useToDate"] = null;
            Session["oppositionNo"] = null;
            Session["oppStatus"] = null;
            Session["country"] = null;
            Session["isAdvanced"] = null;
            Session["registrationNo"] = null;
        }

        private void ResetPaging()
        {
            IpageNo = 1;
            DpageNo = 1;
            ApageNo = 1;
            BpageNo = 1;
        }

        public string FillSearch(string Tab)
        {
            if (Tab == "")
                Tab = CurrentTab_Domestic;
            else
                tab = Tab;
            string searchCriteria = "";
            if (tab == CurrentTab_International || tab == CurrentTab_Domestic)
            {
                if (ApplicationNo != "" && ApplicationNo != "0")
                {
                    searchCriteria += " AND IR.Application_No LIKE N'%" + ApplicationNo.Trim() + "%' ";
                }
                if (Type != "" && Type != "0")
                {
                    searchCriteria += " AND IR.IPR_Type_Code IN(Select IPR_Type_Code From IPR_TYPE where TYPE = N'" + Type.Trim() + "') ";
                }
                if (Business_Unit != "" && Business_Unit != "0")
                {
                    searchCriteria += " AND IPR_BU.Business_Unit_Code IN(" + Business_Unit.Trim() + ") ";
                }
                if (Channel != "" && Channel != "0")
                {
                    searchCriteria += " AND IPR_C.Channel_Code IN(" + Channel.Trim() + ") ";
                }
                if (Trademark != "")
                {
                    searchCriteria += " AND IR.Trademark LIKE N'%" + Trademark.Trim() + "%'";
                }
                if (TradeMarkAtto != "")
                {
                    searchCriteria += " AND (IR.Trademark_Attorney LIKE N'%" + TradeMarkAtto.Trim() + "%' "
                            + "OR IR.International_Trademark_Attorney LIKE N'%" + TradeMarkAtto.Trim() + "%') ";
                }
                if (AppFromDate != "")
                {
                    searchCriteria += " AND CONVERT(DATETIME, IR.Application_Date) >= CONVERT(datetime,'" + AppFromDate.Trim() + "',103)";
                }
                if (AppToDate != "")
                {
                    searchCriteria += " AND CONVERT(DATETIME, IR.Application_Date) <= CONVERT(datetime,'" + AppToDate.Trim() + "',103)";
                }
                if (ApplicationStatus != "" && ApplicationStatus != "0")
                {
                    searchCriteria += " AND IR.Application_Status_Code IN(Select IPR_App_Status_Code from IPR_APP_STATUS where App_Status = N'" + ApplicationStatus.Trim() + "') ";
                }
                if (Applicant != "" && Applicant != "0")
                {
                    searchCriteria += " AND IR.Applicant_Code IN(Select IPR_Entity_Code from IPR_ENTITY where Entity = N'" + Applicant.Trim() + "') ";
                }
                if (RenFromDate != "")
                {
                    searchCriteria += " AND CONVERT(DATETIME, IR.Renewed_Until) >=  CONVERT(datetime,'" + RenFromDate.Trim() + "',103)";
                }
                if (RenToDate != "")
                {
                    searchCriteria += " AND CONVERT(DATETIME, IR.Renewed_Until) <= CONVERT(datetime,'" + RenToDate.Trim() + "',103)";
                }
                if (Classt != "")
                {
                    searchCriteria += " AND (IC.Parent_Class_Code In (Select IC1.IPR_Class_Code From IPR_CLASS IC1 Where IC1.Description LIKE N'%" + Classt.Trim()
                        + "%') OR IC.Description LIKE '%" + Classt.Trim() + "%')";
                }
                if (UseFromDate != "")
                {
                    searchCriteria += " AND CONVERT(DATETIME, IR.Date_Of_Use) >=  CONVERT(datetime,'" + UseFromDate.Trim() + "',103)";
                }
                if (UseToDate != "")
                {
                    searchCriteria += " AND CONVERT(DATETIME, IR.Date_Of_Use) <= CONVERT(datetime,'" + UseToDate.Trim() + "',103)";
                }

                if (Country != "" && Country != "0")
                {
                    searchCriteria += " AND IR.Country_Code IN(Select IPR_Country_Code From IPR_Country where IPR_Country_Name = N'" + Country.Trim() + "') ";
                }
                if (!string.IsNullOrEmpty(RegistrationNo) && tab != CurrentTab_Domestic)
                {
                    searchCriteria += " AND IR.Registration_No LIKE N'%" + RegistrationNo + "%' ";
                }
                if (Common_Search != "")
                {
                    searchCriteria += " AND (IR.Application_No LIKE N'%" + Common_Search.Trim() + "%'"
                                   + " OR IR.IPR_Type_Code IN(Select IPR_Type_Code From IPR_TYPE where TYPE LIKE N'%" + Common_Search.Trim() + "%')"
                                   + " OR IPR_BU.Business_Unit_Code IN(Select Business_Unit_Code From Business_Unit where Business_Unit_Name LIKE N'%" + Common_Search.Trim() + "%') "
                                   + " OR IPR_C.Channel_Code IN(Select Channel_Code From Channel where Channel_Name LIKE N'%" + Common_Search.Trim() + "%') "
                                   + " OR IR.Trademark LIKE N'%" + Common_Search.Trim() + "%' OR (IR.Trademark_Attorney LIKE N'%" + Common_Search.Trim() + "%'"
                                   + " OR IR.International_Trademark_Attorney LIKE N'%" + Common_Search.Trim() + "%') "
                                   + " OR IR.Application_Status_Code IN(Select IPR_App_Status_Code from IPR_APP_STATUS where App_Status LIKE N'%" + Common_Search.Trim() + "%')"
                                   + " OR IR.Applicant_Code IN(Select IPR_Entity_Code from IPR_ENTITY where Entity LIKE N'%" + Common_Search.Trim() + "%')"
                                   + " OR (IC.Parent_Class_Code In (Select IC1.IPR_Class_Code From IPR_CLASS IC1 Where IC1.Description LIKE N'%" + Common_Search.Trim() + "%')"
                                   + " OR IC.Description LIKE N'%" + Common_Search.Trim() + "%')"
                                   + " OR IR.Country_Code IN(Select IPR_Country_Code From IPR_Country where IPR_Country_Name LIKE N'%" + Common_Search.Trim() + "%')) ";
                }
            }
            else if (tab == CurrentTab_OppositionAgainst || tab == CurrentTab_OppositionBy)
            {
                if (!string.IsNullOrEmpty(ApplicationNo.Trim()) && ApplicationNo != "0")
                {
                    searchCriteria += " AND (IR.Application_No LIKE N'%" + ApplicationNo.Trim() + "%' OR IOp.Application_No LIKE N'%"
                        + ApplicationNo.Trim() + "%') ";
                }
                if (!string.IsNullOrEmpty(TradeMarkAtto.Trim()))
                {
                    searchCriteria += " AND IR.Trademark_Attorney LIKE N'%" + TradeMarkAtto.Trim() + "%' ";
                }
                if (!string.IsNullOrEmpty(Trademark.Trim()))
                {
                    searchCriteria += " AND (IR.Trademark LIKE N'%" + Trademark.Trim() + "%' OR IOp.Trademark LIKE N'%"
                        + Trademark.Trim() + "%') ";
                }
                if (Type != "" && Type != "0")
                {
                    searchCriteria += " AND IR.IPR_Type_Code IN(Select IPR_Type_Code From IPR_TYPE where TYPE LIKE N'%" + Type.Trim() + "%') ";
                }
                if (Business_Unit != "" && Business_Unit != "0")
                {
                    searchCriteria += " AND IPR_BU.Business_Unit_Code IN(" + Business_Unit.Trim() + ") ";
                }
                if (Channel != "" && Channel != "0")
                {
                    searchCriteria += " AND IPR_C.Channel_Code IN(" + Channel.Trim() + ") ";
                }
                if (!string.IsNullOrEmpty(Classt.Trim()))
                {
                    searchCriteria += " AND (IC.IPR_Class_Code In (Select IC1.Parent_Class_Code From IPR_CLASS IC1 Where IC1.Description LIKE N'%" + Classt.Trim()
                        + "%') " + "OR IC.Description LIKE N'%" + Classt.Trim() + "%' "
                    + "OR IC.Parent_Class_Code In (Select IC1.IPR_Class_Code From IPR_CLASS IC1 Where IC1.Description LIKE N'%" + Classt.Trim() + "%') "
                    + ")";
                }
                if (!string.IsNullOrEmpty(OppositionNo.Trim()))
                {
                    searchCriteria += " AND IOp.Opp_No LIKE N'%" + OppositionNo.Trim() + "%'";
                }
                if (OppStatus != "" && OppStatus != "0")
                {
                    searchCriteria += " AND IOp.IPR_Opp_Status_Code In(Select IPR_Opp_Status_Code from IPR_Opp_Status where Opp_Status = N'" + OppStatus.Trim() + "') ";
                }
                if (Common_Search != "")
                {
                    searchCriteria += " AND (IR.Application_No LIKE N'%" + Common_Search.Trim() + "%' OR IOp.Application_No LIKE N'%"
                        + Common_Search.Trim() + "%' OR IR.IPR_Type_Code IN(Select IPR_Type_Code From IPR_TYPE where TYPE LIKE N'%" + Common_Search.Trim() + "%')"
                        + " OR IPR_BU.Business_Unit_Code IN(Select Business_Unit_Code From Business_Unit where Business_Unit_Name LIKE N'%" + Common_Search.Trim() + "%') "
                        + " OR IPR_C.Channel_Code IN(Select Channel_Code From Channel where Channel_Name LIKE N'%" + Common_Search.Trim() + "%') "
                        + " OR IR.Trademark LIKE N'%" + Common_Search.Trim() + "%' OR IR.Trademark_Attorney LIKE N'%" + Common_Search.Trim() + "%' "
                        + " OR (IC.IPR_Class_Code In (Select IC1.Parent_Class_Code From IPR_CLASS IC1 Where IC1.Description LIKE N'%" + Common_Search.Trim() + "%')"
                        + " OR IC.Description LIKE N'%" + Common_Search.Trim() + "%' "
                        + " OR IC.Parent_Class_Code In (Select IC1.IPR_Class_Code From IPR_CLASS IC1 Where IC1.Description LIKE N'%" + Common_Search.Trim() + "%'))"
                        + " OR IR.Country_Code IN(Select IPR_Country_Code From IPR_Country where IPR_Country_Name LIKE N'%" + Common_Search.Trim() + "%') "
                        + " OR IOp.Opp_No LIKE N'%" + Common_Search.Trim() + "%'"
                        + " OR IOp.IPR_Opp_Status_Code In(Select IPR_Opp_Status_Code from IPR_Opp_Status where Opp_Status LIKE N'%" + Common_Search.Trim() + "%')) ";
                }
            }
            return searchCriteria;
        }

        public void ExportToExcel(string Tab = "D", string applicationNo = "", string type = "", string trademark = "", string tradeMarkAtto = "",
            string appFromDate = "", string appToDate = "", string applicationStatus = "", string applicant = "", string renFromDate = "", string renToDate = "",
            string classt = "", string useFromDate = "", string useToDate = "", string oppositionNo = "", string oppStatus = "", string country = "",
            string businessUnit = "", string channel = "")
        {
            ReportViewer1 = new ReportViewer();
            int RecordCount = 0;
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;

            string RC = "";
            string searchCriteria = FillSearch(Tab);
            GridView gvExport = new GridView();
            string excelFileName = "", strHeaderScript = "<div><h3>IPR {TAB_NAME}</h3><div>", dwn_strHeaderScript = "<b>Total Records: {RC}</b>";
            if (Tab == "")
                Tab = CurrentTab_Domestic;
            if (Tab == CurrentTab_Domestic || Tab == CurrentTab_International)
            {
                #region--- CurrentTab_Domestic ---
                if (Tab == CurrentTab_International)
                {
                    excelFileName = "IPR_International";
                    strHeaderScript = strHeaderScript.Replace("{TAB_NAME}", "International");
                    Tab = "I";
                }
                else
                {
                    excelFileName = "IPR_Domestic";
                    strHeaderScript = strHeaderScript.Replace("{TAB_NAME}", "Domestic");
                    Tab = "D";
                }
                string orderByCndition = "T.IPR_Rep_Code desc";
                string strSearchCriteria = searchCriteria.Trim();
                strSearchCriteria = strSearchCriteria + " AND IR.IPR_For = '" + Tab + "'";
                ReportParameter[] parm = new ReportParameter[9];
                parm[0] = new ReportParameter("tabName", Tab);
                parm[1] = new ReportParameter("StrSearch", strSearchCriteria);
                parm[2] = new ReportParameter("PageNo", Convert.ToString(pageNo));
                parm[3] = new ReportParameter("OrderByCndition", orderByCndition);
                parm[4] = new ReportParameter("IsPaging", "N");
                parm[5] = new ReportParameter("PageSize", "10");
                parm[6] = new ReportParameter("RecordCount", Convert.ToString(RecordCount));
                parm[7] = new ReportParameter("User_Code", Convert.ToString(objLoginUser.Users_Code));
                parm[8] = new ReportParameter("Module_Code", Convert.ToString(moduleCode));
                ReportCredential();
                ReportViewer1.ServerReport.ReportPath = string.Empty;
                if (ReportViewer1.ServerReport.ReportPath == "")
                {
                    ReportSetting objRS = new ReportSetting();
                    ReportViewer1.ServerReport.ReportPath = objRS.GetReport("rptListIPR");
                }
                ReportViewer1.ServerReport.SetParameters(parm);
                #endregion
            }
            else if (Tab == CurrentTab_OppositionBy || Tab == CurrentTab_OppositionAgainst)
            {
                #region--- CurrentTab_OppositionBy ---
                if (Tab == CurrentTab_OppositionBy)
                {
                    strHeaderScript = strHeaderScript.Replace("{TAB_NAME}", "Opposition By");
                    excelFileName = "IPR_OppositionBy";
                    Tab = "B";
                }
                else
                {
                    strHeaderScript = strHeaderScript.Replace("{TAB_NAME}", "Opposition Against");
                    excelFileName = "IPR_OppositionAgainst";
                    Tab = "A";
                }
                string orderByCndition = "IOp.IPR_Opp_Code desc";
                string strSearchCriteria = searchCriteria.Trim();
                ReportParameter[] parm = new ReportParameter[9];
                parm[0] = new ReportParameter("Ipr_For", Tab);
                parm[1] = new ReportParameter("StrSearch", strSearchCriteria);
                parm[2] = new ReportParameter("PageNo", Convert.ToString(pageNo));
                parm[3] = new ReportParameter("OrderByCndition", orderByCndition);
                parm[4] = new ReportParameter("IsPaging", "N");
                parm[5] = new ReportParameter("PageSize", "10");
                parm[6] = new ReportParameter("RecordCount", Convert.ToString(RecordCount));
                parm[7] = new ReportParameter("User_Code", Convert.ToString(objLoginUser.Users_Code));
                parm[8] = new ReportParameter("Module_Code", Convert.ToString(moduleCode));
                ReportCredential();
                ReportViewer1.ServerReport.ReportPath = string.Empty;
                if (ReportViewer1.ServerReport.ReportPath == "")
                {
                    ReportSetting objRS = new ReportSetting();
                    ReportViewer1.ServerReport.ReportPath = objRS.GetReport("rptListIPROpp");
                }
                ReportViewer1.ServerReport.SetParameters(parm);
                #endregion
            }
            Byte[] buffer = ReportViewer1.ServerReport.Render("Excel", null, out extension, out encoding, out mimeType, out streams, out warnings);
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-disposition", "filename=" + excelFileName + ".xls");
            Response.OutputStream.Write(buffer, 0, buffer.Length);
            Response.End();
        }
        public void ReportCredential()
        {
            var rptCredetialList = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

            string ReportingServer = rptCredetialList.Where(x => x.Parameter_Name == "RPT_ReportingServer").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["ReportingServer"];
            string IsCredentialRequired = rptCredetialList.Where(x => x.Parameter_Name == "RPT_IsCredentialRequired").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["IsCredentialRequired"];

            if (IsCredentialRequired.ToUpper() == "TRUE")
            {
                string CredentialPassWord = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserPassWord").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["CredentialsUserPassWord"];
                string CredentialUser = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialsUserName"];
                string CredentialdomainName = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialdomainName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialdomainName"];

                ReportViewer1.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser, CredentialPassWord, CredentialdomainName);
            }

            ReportViewer1.Visible = true;
            ReportViewer1.ServerReport.Refresh();
            ReportViewer1.ProcessingMode = ProcessingMode.Remote;
            if (ReportViewer1.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
            {
                ReportViewer1.ServerReport.ReportServerUrl = new Uri(ReportingServer);
            }
        }

        public JsonResult DeleteIPR(int IPR_Code)
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();
            bool isValid = false;
            if (tab == CurrentTab_OppositionAgainst || tab == CurrentTab_OppositionBy)
            {
                int IPR_Opp_Code = Convert.ToInt32(IPR_Code);
                IPR_Opp_Service objIPR_Opp_Service = new IPR_Opp_Service(objLoginEntity.ConnectionStringName);
                IPR_Opp objOpp = objIPR_Opp_Service.GetById(IPR_Opp_Code);
                objOpp.EntityState = State.Deleted;
                dynamic resultSet;
                isValid = objIPR_Opp_Service.Delete(objOpp, out resultSet);
            }
            else
            {
                int IPR_Rep_Code = Convert.ToInt32(IPR_Code);
                IPR_REP_Service objIPR_REP_Service = new IPR_REP_Service(objLoginEntity.ConnectionStringName);
                IPR_REP objIR = objIPR_REP_Service.GetById(IPR_Rep_Code);
                IPR_Opp_Service objIPR_Opp_Service = new IPR_Opp_Service(objLoginEntity.ConnectionStringName);
                int c = objIPR_Opp_Service.SearchFor(x => x.IPR_Rep_Code == IPR_Rep_Code).ToList().Count;
                if (c == 0)
                {
                    objIR.EntityState = State.Deleted;
                    dynamic resultSet;
                    isValid = objIPR_REP_Service.Delete(objIR, out resultSet);
                }
                else
                    objJson.Add("Error", "IPR Rep is already Used in IPR Opposition");
            }
            TempData["TABNAME"] = tab;

            if (isValid)
            {
                objJson.Add("Message", "Deleted Successfully");
                objJson.Add("Error", "");
            }
            return Json(objJson);
        }

        public partial class IPR_List_Search
        {
            public IPR_List_Search() { }
            public int RecordLockingCode { get; set; }

        }
       
        #endregion
    }
    public class ModalPopupList
    {
        public IList<IPR_Opp> OppoBy { get; set; }
        public IList<IPR_Opp> OppoAgainst { get; set; }
    }
}