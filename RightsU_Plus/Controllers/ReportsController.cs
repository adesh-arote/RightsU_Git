using Microsoft.Reporting.WebForms;
using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;
using Newtonsoft.Json;

namespace RightsU_Plus.Controllers
{
    public class ReportsController : BaseController
    {
        #region Properties
        private List<Acq_Adv_Ancillary_Report> lstMHReport
        {
            get
            {
                if (Session["lstMHReport"] == null)
                    Session["lstMHReport"] = new List<Acq_Adv_Ancillary_Report>();
                return (List<Acq_Adv_Ancillary_Report>)Session["lstMHReport"];
            }
            set { Session["lstMHReport"] = value; }
        }

        #endregion
        #region --- Deal Version History Report ---
        public ActionResult DealVersionHistory()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForDealVersionHistoryReport);
            BindFormatDDL();
            List<SelectListItem> lstDeal = new List<SelectListItem>();
            lstDeal.Add(new SelectListItem { Text = "Acquisition Deals", Value = GlobalParams.ModuleCodeForAcqDeal.ToString() });
            lstDeal.Add(new SelectListItem { Text = "Syndication Deals", Value = GlobalParams.ModuleCodeForSynDeal.ToString() });
            ViewBag.DealList = lstDeal;
            ViewBag.BusinessUnitList = GetBusinessUnitList();
            return View();
        }
        public JsonResult PopulateAgreementNo(string searchPrefix = "", string module = "")
        {
            dynamic result = "";

            if (module == GlobalParams.ModuleCodeForSynDeal.ToString())
            {
                if (!string.IsNullOrEmpty(searchPrefix))
                {
                    result = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Agreement_No.Contains(searchPrefix)).Select(s => new { Text = s.Agreement_No, Code = s.Syn_Deal_Code });
                }
            }
            //if (module == "30")
            else
            {
                if (!string.IsNullOrEmpty(searchPrefix))
                {
                    result = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Agreement_No.Contains(searchPrefix)).Select(s => new { Text = s.Agreement_No, Code = s.Acq_Deal_Code });
                }
            }
            return Json(result);
        }
        public JsonResult PopulateAgreementNoOnBU_Code(string searchPrefix = "", string module = "", int BU_Code = 0)
        {
            dynamic result = "";

            if (module == GlobalParams.ModuleCodeForSynDeal.ToString())
            {
                if (!string.IsNullOrEmpty(searchPrefix))
                {
                    result = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Agreement_No.Contains(searchPrefix) && s.Syn_Deal_Movie.Any(SM => SM.Syn_Deal.Business_Unit_Code == BU_Code) && s.Version.Substring(0, 4) != "0001").Select(s => new { Text = s.Agreement_No, Code = s.Syn_Deal_Code });
                }
            }
            //if (module == "30")
            else
            {
                if (!string.IsNullOrEmpty(searchPrefix))
                {
                    result = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Agreement_No.Contains(searchPrefix) && s.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code) && s.Version.Substring(0, 4) != "0001").Select(s => new { Text = s.Agreement_No, Code = s.Acq_Deal_Code });
                }
            }
            return Json(result);
        }

        public JsonResult PopulateAgreementNoOnBU_CodeDealStatus(string searchPrefix = "", string module = "", string BU_Code = "")
        {
            dynamic result = "";
            string[] arr_BU = BU_Code.Split(',');

            if (module == GlobalParams.ModuleCodeForSynDeal.ToString())
            {
                if (!string.IsNullOrEmpty(searchPrefix))
                {
                    result = new Syn_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Agreement_No.Contains(searchPrefix) && arr_BU.Contains(s.Business_Unit_Code.ToString())).Select(s => new { Text = s.Agreement_No, Code = s.Syn_Deal_Code, s.Business_Unit_Code });
                }
            }
            //if (module == "30")
            else
            {
                if (!string.IsNullOrEmpty(searchPrefix))
                {
                    result = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Agreement_No.Contains(searchPrefix) && arr_BU.Contains(s.Business_Unit_Code.ToString())).Select(s => new { Text = s.Agreement_No, Code = s.Acq_Deal_Code });
                }
            }
            return Json(result);
        }
        public PartialViewResult BindDealVersionHistoryReport(string acqDealCode, string businessUnitcode, string dealCode, string dateformat)
        {
            ReportViewer rptViewer = new ReportViewer();
            try
            {
                if (dealCode == GlobalParams.ModuleCodeForAcqDeal.ToString())
                {
                    ReportParameter[] parm = new ReportParameter[7];
                    parm[0] = new ReportParameter("Acq_Deal_Code", acqDealCode);
                    parm[1] = new ReportParameter("Business_Unit_Code", businessUnitcode);
                    parm[2] = new ReportParameter("TabName", " ");
                    parm[3] = new ReportParameter("DateFormat", dateformat);
                    parm[4] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
                    parm[5] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
                    parm[6] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
                    rptViewer = BindReport(parm, "DEAL_VERSION");
                }
                else if (dealCode == GlobalParams.ModuleCodeForSynDeal.ToString())
                {
                    ReportParameter[] parm = new ReportParameter[7];
                    parm[0] = new ReportParameter("Syn_Deal_Code", acqDealCode);
                    parm[1] = new ReportParameter("Business_Unit_Code", businessUnitcode);
                    parm[2] = new ReportParameter("TabName", " ");
                    parm[3] = new ReportParameter("DateFormat", dateformat);
                    parm[4] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
                    parm[5] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
                    parm[6] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
                    rptViewer = BindReport(parm, "DEAL_VERSION_SYN");
                }
            }
            catch (Exception e)
            {
                throw e;
            }

            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region --- Deal Workflow Status Report ---
        public ActionResult DealWorkflowStatusPending()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForDealWorkflowStausPending);
            BindFormatDDL();
            List<SelectListItem> lstDeal = new List<SelectListItem>();
            lstDeal.Add(new SelectListItem { Text = "Acquisition Deals", Value = GlobalParams.ModuleCodeForAcqDeal.ToString() });
            lstDeal.Add(new SelectListItem { Text = "Syndication Deals", Value = GlobalParams.ModuleCodeForSynDeal.ToString() });
            ViewBag.DealList = lstDeal;
            ViewBag.BusinessUnitList = GetBusinessUnitList();
            return View();
        }

        public PartialViewResult BindDealWorkflowStatusReport(string businessUnitcode, string dealCode)
        {
            ReportViewer rptViewer = new ReportViewer();
            try
            {
                if (dealCode == GlobalParams.ModuleCodeForAcqDeal.ToString())
                {
                    ReportParameter[] parm = new ReportParameter[3];
                    parm[0] = new ReportParameter("Content_Category", businessUnitcode);
                    parm[1] = new ReportParameter("Module_Code", dealCode);
                    parm[2] = new ReportParameter("Created_By", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
                    rptViewer = BindReport(parm, "rpt_Deal_WFStatus_Pending");
                }
                else if (dealCode == GlobalParams.ModuleCodeForSynDeal.ToString())
                {
                    ReportParameter[] parm = new ReportParameter[3];
                    parm[0] = new ReportParameter("Content_Category", businessUnitcode);
                    parm[1] = new ReportParameter("Module_Code", dealCode);
                    parm[2] = new ReportParameter("Created_By", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
                    rptViewer = BindReport(parm, "rpt_Deal_WFStatus_Pending");
                }
            }
            catch (Exception e)
            {
                throw e;
            }

            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region --- Logged In Users Report ---
        public ActionResult LoggedInUsersReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModulecodeForLoggedInUsersReport);
            string EntityName = Convert.ToString(System.Web.HttpContext.Current.Session["Entity_Type"]);
            OnlineVisitorsContainer_Class obj_OnlineVisitorsContainer_Class = new OnlineVisitorsContainer_Class();
            List<OnlineVisitorsContainer_Class> lst_OnlineVisitorsContainer_Class = new List<OnlineVisitorsContainer_Class>();
            if (OnlineVisitorsContainer.Visitors.Count > 0)
            {
                foreach (var item in OnlineVisitorsContainer.Visitors)
                {
                    if (item.Value.EntityName == EntityName)
                    {
                        OnlineVisitorsContainer_Class obj = new OnlineVisitorsContainer_Class();
                        obj.UserName = item.Value.UserName;
                        obj.SessionStarted = item.Value.SessionStarted;
                        obj.IpAddress = item.Value.IpAddress;
                        obj.UserAgent = item.Value.UserAgent;
                        obj.EnterUrl = item.Value.EnterUrl;
                        obj.UrlReferrer = item.Value.UrlReferrer;
                        lst_OnlineVisitorsContainer_Class.Add(obj);
                    }
                }
            }
            obj_OnlineVisitorsContainer_Class.lst_OnlineVisitorsContainer_Class = lst_OnlineVisitorsContainer_Class.OrderByDescending(o => o.SessionStarted).ToList();
            return View("~/Views/Reports/LoggedInUsersReport.cshtml", obj_OnlineVisitorsContainer_Class);
        }
        public class OnlineVisitorsContainer_Class
        {
            public string UserName { get; set; }
            public DateTime SessionStarted { get; set; }
            public string IpAddress { get; set; }
            public string UserAgent { get; set; }
            public string EnterUrl { get; set; }
            public string UrlReferrer { get; set; }
            public List<OnlineVisitorsContainer_Class> lst_OnlineVisitorsContainer_Class { get; set; }
        }

        #endregion

        #region -- Music Assignment Audit report--
        public ActionResult Music_Assignment_Audit_Report()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicAssignmentActivityReport);
            BindFormatDDL();
            return View();
        }
        public PartialViewResult BindMusicAssignmentAuditReport(string userCode, string dateFrom, string dateTo, string dateformat)
        {
            string user_names = UserAutosuggest(userCode);
            ReportParameter[] param = new ReportParameter[7];
            param[0] = new ReportParameter("User_Id", user_names);
            param[1] = new ReportParameter("Date_From", GlobalUtil.MakedateFormat(dateFrom));
            param[2] = new ReportParameter("Date_To", GlobalUtil.MakedateFormat(dateTo));
            param[3] = new ReportParameter("DateFormat", dateformat);
            param[4] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            param[5] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            param[6] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(param, "Music_Assignment_Audit_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion
        #region--- Acq Deal List Report ---

        public User objLoginedUser { get; set; }
        public int Code { get; set; }
        public ActionResult AcqDealListReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDealListReport);
            BindFormatDDL();
            ViewBag.UserModuleRights = GetUserModuleRights();
            string rightsForAllBU = GetUserModuleRights();
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            int BU_Code = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
            ViewBag.status = new SelectList(new Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Tag_Code > 0), "Deal_Tag_Code", "Deal_Tag_Description").ToList();
            ViewBag.AcquisitionDeal = new SelectList(new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Business_Unit.Users_Business_Unit.All(u => u.Users_Code == objLoginUser.Users_Code))).ToList();
            if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~") && rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true, true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(false, true);
            }
            else
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList();
            }
            var AllowDealSegment = ViewBag.AllowDealSegment = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Deal_Segment").Select(x => x.Parameter_Value).FirstOrDefault();
            var IsAllowTypeOfFilm = ViewBag.IsAllowTypeOfFilm = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Type_Of_Film").Select(x => x.Parameter_Value).FirstOrDefault();

            if (AllowDealSegment == "Y")
            {
                ViewBag.Deal_Segment = new SelectList(new Deal_Segment_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList(), "Deal_Segment_Code", "Deal_Segment_Name");
            }

            if (IsAllowTypeOfFilm == "Y")
            {
                ViewBag.TypeOfFilm = new SelectList(new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == 2).Select(x => new { Columns_Value_Code = x.Columns_Value_Code, Columns_Value = x.Columns_Value }).ToList(), "Columns_Value_Code", "Columns_Value");
            }
            var Is_AllowMultiBUacqdealreport = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AllowMultiBUacqdealreport").Select(x => x.Parameter_Value).FirstOrDefault();
            ViewBag.Is_AllowMultiBUacqdealreport = Is_AllowMultiBUacqdealreport;

            ViewBag.ModeOfAcquisitionList = GetModeOfAcquisitionList();

            return View();
        }
        public ActionResult AuditTrailReport()

        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDealListReport);
            BindFormatDDL();
            ViewBag.UserModuleRights = GetUserModuleRights();
            string rightsForAllBU = GetUserModuleRights();
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            ViewBag.AcquisitionDeal = new SelectList(
                  new List<SelectListItem>
                  {   new SelectListItem { Text = "Acquisition Deal", Value = GlobalParams.ModuleCodeForAcqDeal.ToString()},
                      new SelectListItem {  Text = "Syndication Deal", Value = GlobalParams.ModuleCodeForSynDeal.ToString()},
                  }, "Value", "Text", "S");
            string[] arrBu_Codes = new Users_Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Users_Code == objLoginUser.Users_Code).Select(s => s.Business_Unit_Code.ToString()).ToArray();
            ViewBag.TitleList = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => /*x.Reference_Flag != "T" &&*/ x.Acq_Deal_Movie.Any(AM => arrBu_Codes.Contains(AM.Acq_Deal.Business_Unit_Code.ToString()))).OrderBy(t => t.Title_Name), "Title_Code", "Title_Name").ToList();
            ViewBag.UserName = new MultiSelectList(new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Users_Code", "First_Name").ToList();
            int BU_Code = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
            ViewBag.Licensor = new MultiSelectList(new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Vendor_Code", "Vendor_Name").ToList();
            if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true);
            }
            else
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList();
            }
            return View();
        }
        public JsonResult BindTitleList(int BU_Code)
        {
            Deal_Type_Service objDTS = new Deal_Type_Service(objLoginEntity.ConnectionStringName);
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);


            ViewBag.TitleList = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Reference_Flag != "T" && x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code)).OrderBy(t => t.Title_Name), "Title_Code", "Title_Name").ToList();

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("ddlTitle", ViewBag.TitleList);
            return Json(obj);

        }
        public PartialViewResult BindAcqDealListReport(string businessUnitcode, string DealNo, string DealType, string Dealtag, string startDate, string endDate, string Title,
            string IsPushBack, string subDeal, string DealSegment, string masterDeal, string dateformat, string IsCheckRight, string TypeOfFilm, string ModeOfAcquisitionCode)
        {
            if (businessUnitcode == "0")
            {
                businessUnitcode = "0";
                businessUnitcode = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(x => x.Business_Unit_Code).ToList());
                //businessUnitcode = string.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                //     .Select(s => s.Business_Unit_Code.ToString()).ToArray());
            }
            else if (businessUnitcode == "-1")
            {
                var BUforRegGEC = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                var arrayBUforRegGEC = BUforRegGEC.Split(',');
                businessUnitcode = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code) && arrayBUforRegGEC.Contains(x.Business_Unit_Code.ToString())).Select(x => x.Business_Unit_Code).ToList());
            }


            string title_names = TitleAutosuggest(Title);
            string Promoter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(t => true).Where(w => w.Parameter_Name == "Promoter_Tab").Select(s => s.Parameter_Value).FirstOrDefault();
            ReportParameter[] parm = new ReportParameter[19];

            parm[0] = new ReportParameter("Agreement_No", DealNo);
            parm[1] = new ReportParameter("Is_Master_Deal", DealType);
            parm[2] = new ReportParameter("Deal_Tag_Code", Dealtag);
            parm[3] = new ReportParameter("Start_Date", GlobalUtil.MakedateFormat(startDate));
            parm[4] = new ReportParameter("End_Date", GlobalUtil.MakedateFormat(endDate));
            parm[5] = new ReportParameter("Title_Name", title_names);
            parm[6] = new ReportParameter("Business_Unit_code", businessUnitcode);
            parm[7] = new ReportParameter("Is_Pushback", IsPushBack);
            parm[8] = new ReportParameter("DateFormat", dateformat);
            parm[9] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[10] = new ReportParameter("SubDeal", subDeal);
            parm[11] = new ReportParameter("IsMasterDealNew", masterDeal);
            parm[12] = new ReportParameter("IsPromoter", Promoter);
            parm[13] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[14] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            parm[15] = new ReportParameter("IsCheckRight", IsCheckRight);
            parm[16] = new ReportParameter("DealSegment", DealSegment);
            parm[17] = new ReportParameter("TypeOfFilm", TypeOfFilm);
            parm[18] = new ReportParameter("ModeOfAcquisition", ModeOfAcquisitionCode);
            ReportViewer rptViewer = BindReport(parm, "ACQUITION_DEAL_LIST_REPORT");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        public PartialViewResult BindAuditTrailReport(string businessUnitcode, string moduleCode, string startDate, string endDate, string amendStart, string amendEnd, string createdOramended, string titleCode,
           string vendorCode, string userCode, string dateformat)
        {
            if (businessUnitcode == "0")
            {
                businessUnitcode = "0";
                businessUnitcode = string.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                     .Select(s => s.Business_Unit_Code.ToString()).ToArray());
            }
            string title_names = TitleAutosuggest(titleCode);
            string start_date = string.IsNullOrWhiteSpace(startDate) ? amendStart : startDate;
            string end_date = string.IsNullOrWhiteSpace(endDate) ? amendEnd : endDate;
            string Promoter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(t => true).Where(w => w.Parameter_Name == "Promoter_Tab").Select(s => s.Parameter_Value).FirstOrDefault();
            ReportParameter[] parm = new ReportParameter[9];

            parm[0] = new ReportParameter("BusinessUnitcode", businessUnitcode);
            parm[1] = new ReportParameter("StartDate", GlobalUtil.MakedateFormat(start_date));
            parm[2] = new ReportParameter("EndDate", GlobalUtil.MakedateFormat(end_date));
            parm[3] = new ReportParameter("TitleCode", title_names);
            parm[4] = new ReportParameter("VendorCode", vendorCode);
            parm[5] = new ReportParameter("UserCode", userCode);
            parm[6] = new ReportParameter("DateFormat", dateformat);
            parm[7] = new ReportParameter("ModuleCode", moduleCode);
            parm[8] = new ReportParameter("CreatedOrAmended", createdOramended);
            //parm[7] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());

            ReportViewer rptViewer = BindReport(parm, "AUDIT_TRAIL_LIST_REPORT");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        public JsonResult PopulateTitleNameForAcqDeal(string BU_Code, string keyword = "")
        {
            List<string> arrBUCodes = new List<string>();

            if (BU_Code == "0")
            {
                arrBUCodes = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active != " " && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                    .Select(s => s.Business_Unit_Code.ToString()).ToList();
            }
            else if (BU_Code == "-1")
            {
                var listOfGEC = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                var templistOfGEC = listOfGEC.Split(',').ToList();
                arrBUCodes = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active != " " && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code) && templistOfGEC.Contains(x.Business_Unit_Code.ToString()))
                    .Select(s => s.Business_Unit_Code.ToString()).ToList();

            }
            else
            {
                arrBUCodes = BU_Code.Split(',').ToList();
            }
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();

                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();

                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Name.ToUpper()
            .Contains(searchString.ToUpper())
            && s.Is_Active == "Y"
            && s.Reference_Flag != "T"
            && s.Acq_Deal_Movie.Any(AM => arrBUCodes.Contains(AM.Acq_Deal.Business_Unit_Code.ToString())))
            .Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).Distinct().ToList();

            }

            return Json(result);
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForAcqDealListReport), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        #endregion
        #region--- IPR Report ---
        public ActionResult IPRReport()
        {
            ViewBag.Applicant = new SelectList(new IPR_ENTITY_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList(), "Entity", "Entity").ToList();
            ViewBag.IPRClass = new SelectList(new IPR_CLASS_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parent_Class_Code == 0).ToList(), "Description", "Description").ToList();

            return View("~/Views/Reports/IPR_Report.cshtml");
        }

        public PartialViewResult BindIPRReport(string Trademark, string Applicant, string RegDate, string ExpiryDate, string IntDom, string ClassCode)
        {
            ReportParameter[] parm = new ReportParameter[7];
            parm[0] = new ReportParameter("Trademark", Trademark ?? " ");
            parm[1] = new ReportParameter("Registration_Date", GlobalUtil.MakedateFormat(RegDate));
            parm[2] = new ReportParameter("Renewed_Until", GlobalUtil.MakedateFormat(ExpiryDate));
            parm[3] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[4] = new ReportParameter("Organization", Applicant ?? " ");
            parm[5] = new ReportParameter("Class", ClassCode == "" ? "00" : ClassCode);
            parm[6] = new ReportParameter("IntDom", IntDom ?? "D");

            ReportViewer rptViewer = BindReport(parm, "rptIPR_IntDom_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region --- Syn Deal List Report ---
        public ActionResult SynDealListReport()
        {
            int ModuleCode = objLoginUser.moduleCode;
            if (ModuleCode == GlobalParams.ModuleCodeForSynDealListReport)
                LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForSynDealListReport);
            else
                LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTheatricalSyndicationReport);

            BindFormatDDL();
            string moduleCode = Request.QueryString["modulecode"];
            ViewBag.Code = moduleCode;
            Session["code"] = moduleCode;
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            int BU_Code = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
            ViewBag.UserModuleRights = GetUserModuleSynRights();
            string rightsForAllBU = GetUserModuleSynRights();

            ViewBag.status = new SelectList(new Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Tag_Code > 0), "Deal_Tag_Code", "Deal_Tag_Description").ToList();
            ViewBag.TitleList = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Reference_Flag != "T" && x.Syn_Deal_Movie.Any(SM => SM.Syn_Deal.Business_Unit_Code == BU_Code)).OrderBy(t => t.Title_Name), "Title_Code", "Title_Name").ToList();
            if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~") && rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true, true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(false, true);
            }
            else
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList();
            }
            var AllowDealSegment = ViewBag.AllowDealSegment = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Deal_Segment").Select(x => x.Parameter_Value).FirstOrDefault();
            var IsAllowTypeOfFilm = ViewBag.IsAllowTypeOfFilm = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Type_Of_Film").Select(x => x.Parameter_Value).FirstOrDefault();

            if (AllowDealSegment == "Y")
            {
                ViewBag.Deal_Segment = new SelectList(new Deal_Segment_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList(), "Deal_Segment_Code", "Deal_Segment_Name");
            }

            if (IsAllowTypeOfFilm == "Y")
            {
                ViewBag.TypeOfFilm = new SelectList(new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == 2).Select(x => new { Columns_Value_Code = x.Columns_Value_Code, Columns_Value = x.Columns_Value }).ToList(), "Columns_Value_Code", "Columns_Value");
            }
            var Is_AllowMultiBUsyndealreport = ViewBag.Is_AllowMultiBUsyndealreport = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AllowMultiBUsyndealreport").Select(x => x.Parameter_Value).FirstOrDefault();

            return View();
        }
        public JsonResult BindSynTitleList(string BU_Code, string keyword = "")
        {
            List<string> arrBUCodes = new List<string>();
            if (BU_Code == "0")
            {
                arrBUCodes = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active != " " && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                    .Select(s => s.Business_Unit_Code.ToString()).ToList();
            }
            else if (BU_Code == "-1")
            {
                var listOfGEC = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                var templistOfGEC = listOfGEC.Split(',').ToList();
                arrBUCodes = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active != " " && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code) && templistOfGEC.Contains(x.Business_Unit_Code.ToString()))
                    .Select(s => s.Business_Unit_Code.ToString()).ToList();

            }
            else
            {
                arrBUCodes = BU_Code.Split(',').ToList();
            }

            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Name.ToUpper().Contains(searchString.ToUpper()) && s.Is_Active == "Y" && s.Reference_Flag != "T" && s.Syn_Deal_Movie.Any(SM => arrBUCodes.Contains(SM.Syn_Deal.Business_Unit_Code.ToString()))).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).Distinct().ToList();
            }
            return Json(result);
        }
        public PartialViewResult BindSynDealListReport(string businessUnitcode, string DealNo, string status, string startDate, string endDate, string TitleCode, string DealSegment,
            string IsPushBack, string isTheatrical, bool isExpiredDeal, string dateformat, string IsCheckRight, string TypeOfFilm)
        {
            if (businessUnitcode == "0")
            {
                businessUnitcode = "0";
                businessUnitcode = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(x => x.Business_Unit_Code).ToList());
                //businessUnitcode = string.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                //     .Select(s => s.Business_Unit_Code.ToString()).ToArray());
            }
            else if (businessUnitcode == "-1")
            {
                var BUforRegGEC = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                var arrayBUforRegGEC = BUforRegGEC.Split(',');
                businessUnitcode = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code) && arrayBUforRegGEC.Contains(x.Business_Unit_Code.ToString())).Select(x => x.Business_Unit_Code).ToList());
            }

            string Promoter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(t => true).Where(w => w.Parameter_Name == "Promoter_Tab_Syn").Select(s => s.Parameter_Value).FirstOrDefault();
            string title_names = TitleAutosuggest(TitleCode);
            string ExpiredDeal = "";
            if (isExpiredDeal == true)
            {
                ExpiredDeal = "Y";
            }
            else
            {
                ExpiredDeal = "N";
            }
            ReportParameter[] parm = new ReportParameter[17];

            parm[0] = new ReportParameter("Agreement_No", DealNo);
            parm[1] = new ReportParameter("Title_Codes", title_names);
            parm[2] = new ReportParameter("Deal_Tag_Code", status);
            parm[3] = new ReportParameter("Start_Date", GlobalUtil.MakedateFormat(startDate));
            parm[4] = new ReportParameter("End_Date", GlobalUtil.MakedateFormat(endDate));
            parm[5] = new ReportParameter("Business_Unit_code", businessUnitcode);
            parm[6] = new ReportParameter("Is_Pushback", IsPushBack);
            parm[7] = new ReportParameter("IS_Expired", ExpiredDeal);
            parm[8] = new ReportParameter("IS_Theatrical", isTheatrical);
            parm[9] = new ReportParameter("DateFormat", dateformat);
            parm[10] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[11] = new ReportParameter("IsPromoter", Promoter);
            parm[12] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[13] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            parm[14] = new ReportParameter("IsCheckRight", IsCheckRight);
            parm[15] = new ReportParameter("DealSegment", DealSegment);
            parm[16] = new ReportParameter("TypeOfFilm", TypeOfFilm);
            ReportViewer rptViewer = BindReport(parm, "SYNDICATION_DEAL_LIST_REPORT");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        private string GetUserModuleSynRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForSynDealListReport), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        #endregion

        #region--- Music Exception report ---
        public ActionResult MusicExceptionReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicExceptionReport);
            BindFormatDDL();
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);

            ViewBag.MusicLabel = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Label_Code", "Music_Label_Name").ToList();
            ViewBag.Channel = new SelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Channel_Code", "Channel_Name").ToList();
            ViewBag.Content = new SelectList(new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Episode_Title != null), "Title_Code", "Episode_Title").Distinct().ToList();


            return View();
        }
        public JsonResult BindContenForMusicEx(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && s.Episode_Title != null).Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).ToList().Distinct();
            }
            return Json(result);
        }
        public PartialViewResult BindMusicExceptionReport(string type, string fromDate, string toDate, string channel, string musicLabel, string content, string episodeFrom, string episodeTo, string dateformat, string timeformat)
        {
            content = content.Trim().Trim('﹐').Trim();
            string content_names = "";
            if (content != "")
            {
                string[] terms = content.Split('﹐');
                string[] Content_Codes = new Title_Content_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Title.Title_Name)).Select(s => s.Title.Title_Code.ToString()).ToArray();
                content_names = string.Join(", ", Content_Codes);
            }
            ReportParameter[] parm = new ReportParameter[13];
            parm[0] = new ReportParameter("IsAired", type);
            parm[1] = new ReportParameter("MusicLabelCode", musicLabel);
            parm[2] = new ReportParameter("ChannelCode", channel);
            parm[3] = new ReportParameter("EpisodeFrom", episodeFrom);
            parm[4] = new ReportParameter("EpisodeTo", episodeTo);
            parm[5] = new ReportParameter("DateFrom", GlobalUtil.MakedateFormat(fromDate));
            parm[6] = new ReportParameter("DateTo", GlobalUtil.MakedateFormat(toDate));
            parm[7] = new ReportParameter("ContentCode", content_names);
            parm[8] = new ReportParameter("DateFormat", dateformat);
            parm[9] = new ReportParameter("TimeFormat", timeformat);
            parm[10] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[11] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[12] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Music_Exception_Handling_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        public JsonResult PopulateUsers(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Login_Name.ToUpper().Contains(searchString.ToUpper()) && s.Is_Active == "Y").Select(x => new { Login_Name = x.Login_Name, Users_Code = x.Users_Code }).Distinct().ToList();
            }
            return Json(result);
        }

        public ActionResult PlatformAcquisition()
        {
            int ModuleCode = objLoginUser.moduleCode;
            if (ModuleCode == GlobalParams.ModuleCodeForPlatformwiseAcquisition)
                LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForPlatformwiseAcquisition);
            else
                LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForDigitalTitleReport);

            BindFormatDDL();
            string moduleCode = Request.QueryString["modulecode"];
            ViewBag.Code = moduleCode;
            string Report_RestRmk = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Report_Restriction_Remarks").Select(w => w.Parameter_Value).First();
            ViewBag.Report_RestrictionRMK = Report_RestRmk;
            string rightsForAllBU = GetUserModulePlatformwiseAcqRights();
            if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~") && rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true, true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(false, true);
            }
            else
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList();
            }
            return View();
        }
        public JsonResult BindTitleForPlAcq(int BU_Code, string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                if (BU_Code == 0)
                {
                    var listOfBU = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(x => x.Business_Unit_Code).ToList();

                    result = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && listOfBU.Any(x => x.ToString() == s.Acq_Deal.Business_Unit_Code.ToString()) && (s.Acq_Deal.Is_Master_Deal == "Y" ||
                    s.Acq_Deal.Deal_Type_Code == GlobalParams.Deal_Type_Music)).Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).Distinct().ToList();
                }
                else if (BU_Code == -1)
                {
                    var listOfGEC = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                    var strListOfGEC = listOfGEC.Split(',');

                    result = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && strListOfGEC.Contains(s.Acq_Deal.Business_Unit_Code.ToString()) && (s.Acq_Deal.Is_Master_Deal == "Y" ||
                    s.Acq_Deal.Deal_Type_Code == GlobalParams.Deal_Type_Music)).Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).Distinct().ToList();
                }
                else
                {
                    result = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && s.Acq_Deal.Business_Unit_Code == BU_Code && (s.Acq_Deal.Is_Master_Deal == "Y" ||
                    s.Acq_Deal.Deal_Type_Code == GlobalParams.Deal_Type_Music)).Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).Distinct().ToList();
                }

            }
            return Json(result);
        }
        public PartialViewResult BindPlatformAcquisition(string businessUnitcode, string titleCodes, string platformCodes, bool isExpiredDeal, bool isSubDeal, bool isRestRmk, int ModuleCode, string dateformat)
        {
            string title_names = TitleAutosuggest(titleCodes);
            string heading = "";
            string moduleCode = objLoginUser.moduleCode.ToString();
            if (ModuleCode == GlobalParams.ModuleCodeForPlatformwiseAcquisition)
            {
                heading = "Platformwise Acquisition";
            }
            else
            {
                heading = "Digital Acquisition Title Report";
                platformCodes = " ";
            }

            if (businessUnitcode == "0")
            {
                businessUnitcode = "0";
                businessUnitcode = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(x => x.Business_Unit_Code).ToList());
                //businessUnitcode = string.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                //     .Select(s => s.Business_Unit_Code.ToString()).ToArray());
            }
            else if (businessUnitcode == "-1")
            {
                var BUforRegGEC = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                var arrayBUforRegGEC = BUforRegGEC.Split(',');
                businessUnitcode = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code) && arrayBUforRegGEC.Contains(x.Business_Unit_Code.ToString())).Select(x => x.Business_Unit_Code).ToList());
            }

            if (ModuleCode == GlobalParams.ModuleCodeForPlatformwiseAcquisition)
            {
                if (platformCodes == " ")
                {
                    //platformCodes = GetSelectedPlatform(platformCodes, businessUnitcode);
                    platformCodes = "";
                }
                else
                {
                    platformCodes = GetSelectedPlatform(platformCodes, businessUnitcode);
                }

            }

            string strShowExpiredDeals = (isExpiredDeal == true) ? "Y" : "N";
            string strShowSubDeals = (isSubDeal == true) ? "Y" : "N";
            string strRestRmk = (isRestRmk == true) ? "Y" : "N";


            ReportParameter[] parm = new ReportParameter[11];
            parm[0] = new ReportParameter("Business_Unit_Code", businessUnitcode);
            parm[1] = new ReportParameter("Title_Codes", title_names);
            parm[2] = new ReportParameter("Platform_Codes", platformCodes);
            parm[3] = new ReportParameter("Show_Expired", strShowExpiredDeals);
            parm[4] = new ReportParameter("Include_Sub_Deal", strShowSubDeals);
            parm[5] = new ReportParameter("Module_Code", moduleCode);
            parm[6] = new ReportParameter("Report_Handing", heading);
            parm[7] = new ReportParameter("DateFormat", dateformat);
            parm[8] = new ReportParameter("Restriction_Remarks", strRestRmk);
            parm[9] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[10] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            ReportViewer rptViewer = BindReport(parm, "ACQ_TITLE_PLATFORM_REPORT");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        private string GetSelectedPlatform(string platformCodes, string businessUnitCode)
        {
            //int buCode = Convert.ToInt32(businessUnitCode);
            var arrOfBU = businessUnitCode.Split(',');
            string strPlatformCode = platformCodes;
            if (string.IsNullOrEmpty(strPlatformCode.Trim()))
            {
                int[] arrPlatform = new Acq_Deal_Rights_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrOfBU.Contains(x.Acq_Deal.Business_Unit_Code.ToString())).
                    SelectMany(sm => sm.Acq_Deal_Rights_Platform).Select(s => s.Platform.Platform_Code).Distinct().ToArray();

                strPlatformCode = string.Join(",", arrPlatform);

            }
            return strPlatformCode;

        }
        public PartialViewResult BindPlatformTreeView(string SelectedPlatform = "", string displayCodes = "", string callFor = "")
        {
            Platform_Tree_View objPTV = new Platform_Tree_View(objLoginEntity.ConnectionStringName);
            objPTV.PlatformCodes_Selected = SelectedPlatform.Split(new string[] { "," }, StringSplitOptions.RemoveEmptyEntries);
            if (callFor == "PG")
                objPTV.PlatformCodes_Display = displayCodes;

            ViewBag.TV_Platform = objPTV.PopulateTreeNode("N");
            ViewBag.TreeId = "Rights_Platform";
            ViewBag.TreeValueId = "hdnTVCodes";
            return PartialView("_TV_Platform");
        }
        //public PartialViewResult BindPlatformTreePopup(int platformGroupCode)
        //{
        //    RightsU_Entities.Platform_Group objPG = new Platform_Group_Service(objLoginEntity.ConnectionStringName).GetById(platformGroupCode);
        //    Platform_Tree_View objPTV = new Platform_Tree_View();
        //    string strPlatform = string.Join(",", objPG.Platform_Group_Details.Select(s => s.Platform_Code).ToArray());
        //    objPTV.PlatformCodes_Display = strPlatform;
        //    ViewBag.TV_Platform = objPTV.PopulateTreeNode("Y");
        //    ViewBag.TreeId = "Rights_Platform";
        //    ViewBag.TreeValueId = "hdnTVCodes";
        //    return PartialView("_TV_Platform");
        //}
        public PartialViewResult BindPlatformPopup()
        {
            List<SelectListItem> lstPlatformGroup = new SelectList(new Platform_Group_Service(objLoginEntity.ConnectionStringName).SearchFor(p => p.Platform_Group_Code != 0 && p.Is_Active == "Y"), "Platform_Group_Code", "Platform_Group_Name").Distinct().ToList();
            ViewBag.PlatformGroupList = lstPlatformGroup;
            return PartialView("~/Views/Reports/_Platform_Acquisition_tree.cshtml");
        }

        public PartialViewResult BindPlatformGroup(string PlatformGroupCode, string SelectedCodes)
        {
            int Platform_Group_Code = Convert.ToInt32(PlatformGroupCode);
            string strPlatform_Code = "";
            if (Platform_Group_Code > 0)
            {
                RightsU_Entities.Platform_Group objPlatform_Group = new Platform_Group_Service(objLoginEntity.ConnectionStringName).GetById(Platform_Group_Code);
                strPlatform_Code = string.Join(",", new Platform_Group_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Platform_Group_Code == Platform_Group_Code).ToList().Select(x => Convert.ToString(x.Platform_Code)));
                if (string.IsNullOrEmpty(SelectedCodes))
                    SelectedCodes = strPlatform_Code;
            }
            return BindPlatformTreeView(SelectedCodes, strPlatform_Code, "PG");
        }
        private string GetUserModulePlatformwiseAcqRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForPlatformwiseAcquisition), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public SelectList GetBusinessUnitList(bool isRightForAllBusinessUnit = false, bool isRightForAllGEC = false)
        {
            List<SelectListItem> list = new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
          .Select(i => new { Display_Value = i.Business_Unit_Code, Display_Text = i.Business_Unit_Name }).ToList().Distinct(),
          "Display_Value", "Display_Text").ToList();

            var Is_AllowMultiBUacqdealreport = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AllowMultiBUacqdealreport").Select(x => x.Parameter_Value).FirstOrDefault();

            if (Is_AllowMultiBUacqdealreport != "Y")
            {
                if (isRightForAllGEC)
                {
                    list.Insert(0, new SelectListItem() { Selected = true, Text = "All Regional GEC", Value = "-1" });
                }

                if (isRightForAllBusinessUnit)
                {
                    list.Insert(0, new SelectListItem() { Selected = true, Text = "All Business Unit", Value = "0" });
                }
            }
            return new SelectList(list, "Value", "Text");
        }

        public SelectList GetModeOfAcquisitionList()
        {
            List<SelectListItem> list = new SelectList(new Role_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Role_Type == "A")
            .Select(i => new { Display_Value = i.Role_Code, Display_Text = i.Role_Name }).ToList().Distinct(), "Display_Value", "Display_Text").ToList();

            //list.Insert(0, new SelectListItem() { Selected = true, Text = "All Mode Of Acquisition", Value = "0" });

            return new SelectList(list, "Value", "Text");
        }
        #region -------------- Platform Wise Syndication--------
        public ActionResult PlatformWiseSyndication()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForPlatformwiseSyndicationReport);
            BindFormatDDL();
            int bUCode = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
            string rightsForAllBU = GetUserModulePlatformwiseSynRights();
            if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~") && rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true, true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(false, true);
            }
            else
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList();
            }
            string Report_RestRmk = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Parameter_Name == "Report_Restriction_Remarks").Select(s => s.Parameter_Value).First();
            ViewBag.Restriction_Remark = Report_RestRmk;
            ViewBag.TitleList = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Reference_Flag != "T" && x.Syn_Deal_Movie.Any(SM => SM.Syn_Deal.Business_Unit_Code == bUCode)).OrderBy(t => t.Title_Name), "Title_Code", "Title_Name").ToList();
            return View();
        }
        public MultiSelectList GetSelecteLdLTitleist()
        {
            return new MultiSelectList(new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true)
                  .Select(i => new { Display_Value = i.Title.Title_Code, Display_Text = i.Title.Title_Name }).ToList().Distinct(),
                  "Display_Value", "Display_Text");
        }
        public JsonResult BindTitleForPlSyn(int BU_Code, string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                if (BU_Code == 0)
                {
                    var listOfBU = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(x => x.Business_Unit_Code).ToList();

                    result = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && listOfBU.Any(s => s.ToString() == x.Syn_Deal.Business_Unit_Code.ToString())).Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).Distinct().ToList();
                }
                else if (BU_Code == -1)
                {
                    var listOfGEC = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                    var strListOfGEC = listOfGEC.Split(',');

                    result = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && strListOfGEC.Contains(x.Syn_Deal.Business_Unit_Code.ToString())).Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).Distinct().ToList();
                }
                else
                {
                    result = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Syn_Deal.Business_Unit_Code == BU_Code).Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).Distinct().ToList();
                }

                //result = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Syn_Deal.Business_Unit_Code == BU_Code).Select(x => x.Title).Distinct().ToList();
            }
            return Json(result);
        }
        public PartialViewResult BindPlatformSyndication(string businessUnitcode, string titleCodes, string platformCodes, bool isExpiredDeal, bool isRestRmk, string dateformat)
        {
            string title_names = TitleAutosuggest(titleCodes);

            if (title_names == "") title_names = " ";

            if (businessUnitcode == "0")
            {
                businessUnitcode = "0";
                businessUnitcode = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(x => x.Business_Unit_Code).ToList());
                //businessUnitcode = string.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code))
                //     .Select(s => s.Business_Unit_Code.ToString()).ToArray());
            }
            else if (businessUnitcode == "-1")
            {
                var BUforRegGEC = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BUCodes_All_Regional_GEC").Select(x => x.Parameter_Value).First();
                var arrayBUforRegGEC = BUforRegGEC.Split(',');
                businessUnitcode = String.Join(",", new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code) && arrayBUforRegGEC.Contains(x.Business_Unit_Code.ToString())).Select(x => x.Business_Unit_Code).ToList());
            }

            if (platformCodes == " ")
            {
                platformCodes = "";
            }
            else
            {
                platformCodes = GetSelectedPlatform(platformCodes, businessUnitcode);
            }

            string strShowExpiredDeals = (isExpiredDeal == true) ? "Y" : "N";
            string strRestrictionRmk = (isRestRmk == true) ? "Y" : "N";

            ReportParameter[] parm = new ReportParameter[9];
            parm[0] = new ReportParameter("Business_Unit_Code", businessUnitcode);
            parm[1] = new ReportParameter("Title_Codes", title_names);
            parm[2] = new ReportParameter("Platform_Codes", platformCodes);
            parm[3] = new ReportParameter("Show_Expired", strShowExpiredDeals);
            parm[4] = new ReportParameter("DateFormat", dateformat);
            parm[5] = new ReportParameter("Restriction_Remarks", strRestrictionRmk);
            parm[6] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[7] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[8] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Syn_Deal_Title_Platform_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        private string GetUserModulePlatformwiseSynRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForPlatformwiseSyndicationReport), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        #endregion
        # region-----------Syndication sales Report------------------

        public ActionResult SyndicationSalesReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForSyndicationsalesReport);
            BindFormatDDL();
            ViewBag.BusinessUnitList = GetBusinessUnitList();
            Territory_Service territoryServiceInstance = new Territory_Service(objLoginEntity.ConnectionStringName);
            Country_Service countryServiceInstance = new Country_Service(objLoginEntity.ConnectionStringName);
            var countryList = new SelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Is_Theatrical_Territory == "N"), "Country_Code", "Country_Name").ToList();

            ViewBag.CountryList = countryList;
            int bUCode = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
            //ViewBag.TitleList = GetSelecteLdLTitleist();
            ViewBag.TitleList = new SelectList(new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal.Business_Unit_Code == bUCode).Select(s => s.Title).Distinct(), "Title_Code", "Title_Name").ToList();

            return View();
        }

        public JsonResult BindBUList(int businessUnitCode)
        {

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Title_List", new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Syn_Deal.Business_Unit_Code == businessUnitCode).Select(s => s.Title).ToList().Distinct());

            return Json(obj);
        }


        public JsonResult BindCountryTerritory(string Type, string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                if (Type == "T")
                {
                    result = new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Territory_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && x.Is_Thetrical == "N").Select(x => new { Name = x.Territory_Name, Code = x.Territory_Code }).ToList();
                }
                else if (Type == "C")
                {
                    result = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Country_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && x.Is_Theatrical_Territory == "N").Select(x => new { Name = x.Country_Name, Code = x.Country_Code }).ToList();
                }
                else
                {
                    result = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Country_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && x.Is_Theatrical_Territory == "Y").Select(x => new { Name = x.Country_Name, Code = x.Country_Code }).ToList();
                    result.AddRange(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Territory_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && x.Is_Thetrical == "Y").Select(x => new { Name = x.Territory_Name, Code = x.Territory_Code }).ToList());
                }
            }
            return Json(result);
        }

        public PartialViewResult BindSyndicationSalesReport(string businessUnitcode, string titleCodes, string txtfrom, string txtto, string platformCodes, string CountryList, bool isExpiredDeal, bool isdomesticTerritory, string dateformat, string numberformat, string Tag = "")
        {
            CountryList = CountryList.Trim().Trim('﹐').Trim();
            string numberResult = numberformat.Split('~')[0];
            string country_Codes_Param = "";
            string CCODE = "";
            if (CountryList != "" && Tag == "C")
            {
                string[] terms = CountryList.Split('﹐');
                string[] country_Codes = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Country_Name)).Select(s => "C" + s.Country_Code.ToString()).ToArray();
                string[] country_Names = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Country_Name)).Select(s => s.Country_Name.ToString()).ToArray();
                country_Codes_Param = string.Join(",", country_Codes);
                if (country_Codes_Param == "")
                    country_Codes_Param = "-1";
                CCODE = string.Join(",", country_Names);
            }

            else if (CountryList != "" && Tag == "T")
            {
                string[] terms = CountryList.Split('﹐');
                string[] country_Codes = new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Territory_Name)).Select(s => "T" + s.Territory_Code.ToString()).ToArray();
                string[] country_Names = new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Territory_Name)).Select(s => s.Territory_Name.ToString()).ToArray();
                country_Codes_Param = string.Join(",", country_Codes);
                if (country_Codes_Param == "")
                    country_Codes_Param = "-1";
                CCODE = string.Join(",", country_Names);
            }
            else if (CountryList != "" && Tag == "")
            {
                string[] terms = CountryList.Split('﹐');
                string[] country_Codes = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Country_Name) && x.Is_Active == "Y" && x.Is_Theatrical_Territory == "Y").Select(s => "C" + s.Country_Code.ToString()).ToArray();
                country_Codes_Param = string.Join(",", country_Codes);
                if (country_Codes_Param == "")
                    country_Codes_Param = "-1";
                CCODE = CountryList.Trim().Trim('﹐').Trim();
            }
            string from = "";
            string to = "";

            if (platformCodes == " ")
            {
                platformCodes = "";
            }
            else
            {
                platformCodes = GetSelectedPlatform(platformCodes, businessUnitcode);
            }

            string strShowExpiredDeals = "";
            if (isExpiredDeal == true)
                strShowExpiredDeals = "Y";
            else
                strShowExpiredDeals = "N";

            string chkIncludeDomestic = "";
            if (isdomesticTerritory == true)
                chkIncludeDomestic = "Y";
            else
                chkIncludeDomestic = "N";

            if (txtfrom != "")
                from = GlobalUtil.MakedateFormat(txtfrom);
            if (txtto != "")
                to = GlobalUtil.MakedateFormat(txtto);

            titleCodes = titleCodes.Trim().Trim('﹐').Trim();
            string title_names = "";
            if (titleCodes != "")
            {
                string[] terms = titleCodes.Split('﹐');
                string[] Title_Codes = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Title.Title_Name)).Select(s => s.Title.Title_Code.ToString()).ToArray();
                title_names = string.Join(", ", Title_Codes);
                if (title_names == "")
                    title_names = "-1";
            }

            ReportParameter[] parm = new ReportParameter[14];
            parm[0] = new ReportParameter("Business_Unit_Code", businessUnitcode);
            parm[1] = new ReportParameter("Title_Codes", title_names);
            parm[2] = new ReportParameter("Platform_Codes", (platformCodes == "") ? " " : platformCodes);
            parm[3] = new ReportParameter("Show_Expired", strShowExpiredDeals);
            parm[4] = new ReportParameter("Country_Codes", (country_Codes_Param == "") ? " " : country_Codes_Param);
            parm[5] = new ReportParameter("Start_Date", from);
            parm[6] = new ReportParameter("End_Date", to);
            parm[7] = new ReportParameter("IncludeDomestic", chkIncludeDomestic);
            parm[8] = new ReportParameter("DateFormat", dateformat);
            parm[9] = new ReportParameter("NumberFormat", numberResult);
            parm[10] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[11] = new ReportParameter("CountryCodeForFilter", CCODE);
            parm[12] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[13] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Syndication_Sales_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }


        # endregion

        #region -------Run Exception Report ----------
        public ActionResult RunsExceptionReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForRunExceptionReport);
            BindFormatDDL();
            RightsU_Entities.Deal_Type objDT = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type_Name == GlobalParams.Title_Type_Movie.ToString()).FirstOrDefault();

            ViewBag.TitleList = new MultiSelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type.Deal_Type_Code == GlobalParams.Deal_Type_Movie), "Title_Code", "Title_Name").Distinct();
            return View();
        }
        public JsonResult BindTitleForRunException(string dealType, string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                //RightsU_Entities.Deal_Type objDT = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type_Name == dealType).FirstOrDefault();
                //result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Deal_Type.Deal_Type_Code == objDT.Deal_Type_Code && x.Reference_Flag != "T").Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList().Distinct();

                List<string> lstTitleTypeCode = new List<string>();
                if (dealType == "M")
                {
                    System_Parameter_New Movies_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Movies").FirstOrDefault();
                    lstTitleTypeCode = Movies_system_Parameter.Parameter_Value.Split(',').ToList();
                }
                else
                {
                    System_Parameter_New Show_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Show").FirstOrDefault();
                    lstTitleTypeCode = Show_system_Parameter.Parameter_Value.Split(',').ToList();
                }

                result =
                    new SelectList((from x in new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lstTitleTypeCode.Any(a => x.Deal_Type_Code.ToString() == a) && x.Title_Name.ToUpper().Contains(searchString.ToUpper())).ToList()
                                    select new
                                    {
                                        x.Title_Name,
                                        x.Title_Code
                                    }).Distinct(), "Title_Code", "Title_Name").OrderBy(x => x.Text).ToList();
            }
            return Json(result);
        }

        public PartialViewResult BindRunExceptionReport(string TitleCodes, string FromDate, string ToDate, string TitleType, string datetimeformat, string dateformat, string EpisodeFrom, string EpisodeTo)
        {
            string ReportType = "S";
            string from = "";
            string to = "";
            List<string> lstTitleTypeCode = new List<string>();
            if (TitleType == "M")
                TitleType = "Movie";
            else
                TitleType = "Program";
            int DealTypeCode = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type_Name == TitleType).Select(s => s.Deal_Type_Code).FirstOrDefault();
            string title_names = TypeWiseTitleAutosuggest(TitleCodes, DealTypeCode);
            if (FromDate != "")
                from = GlobalUtil.MakedateFormat(FromDate);
            if (ToDate != "")
                to = GlobalUtil.MakedateFormat(ToDate);

            if (TitleType == "M")
                TitleType = "MOVIE";
            else
                TitleType = "SHOW";

            ReportParameter[] parm = new ReportParameter[13];
            parm[0] = new ReportParameter("ReportType", ReportType);
            parm[1] = new ReportParameter("IsShowAll", "'N'");
            parm[2] = new ReportParameter("TitleType", TitleType);
            parm[3] = new ReportParameter("TitleCode", title_names);
            parm[4] = new ReportParameter("StartDate", GlobalUtil.MakedateFormat(FromDate));
            parm[5] = new ReportParameter("EndDate", GlobalUtil.MakedateFormat(ToDate));
            parm[6] = new ReportParameter("DateTimeFormat", datetimeformat);
            parm[7] = new ReportParameter("DateFormat", dateformat);
            parm[8] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[9] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[10] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            parm[11] = new ReportParameter("EpisodeFrom", EpisodeFrom);
            parm[12] = new ReportParameter("EpisodeTo", EpisodeTo);
            ReportViewer rptViewer = BindReport(parm, "Runs_Exception_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region ----------------Deal Expiry Report-----------------
        public ActionResult DealExpiryReport(string callFor = "AE", int expDays = 30, string callFrom = "")
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForDealExpiryReport);
            BindFormatDDL();

            List<SelectListItem> lstExpiry = new List<SelectListItem>();
            lstExpiry.Add(new SelectListItem { Text = "Acquisition Expiring Deals", Value = "AE", Selected = callFor == "AE" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Acquisition Starting Deals", Value = "AS", Selected = callFor == "AS" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Acquisition ROFR Deals", Value = "AR", Selected = callFor == "AR" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Acquisition Approved Deals", Value = "AA", Selected = callFor == "AA" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Syndication Starting Deals", Value = "SS", Selected = callFor == "SS" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Syndication Expiring Deals", Value = "SE", Selected = callFor == "SE" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Syndication Approved Deals", Value = "SA", Selected = callFor == "SA" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Tentative Acquisition Deals", Value = "AT", Selected = callFor == "AT" ? true : false });

            lstExpiry.Add(new SelectListItem { Text = "Acquisition Expiring Holdback On Seller Deals", Value = "ARHB", Selected = callFor == "ARHB" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Syndication Expiring Holdback On Seller Deals", Value = "SRHB", Selected = callFor == "SRHB" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Acquisition Holdback Deals", Value = "AHB", Selected = callFor == "AHB" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Syndication Holdback Deals", Value = "SHB", Selected = callFor == "SHB" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Acquisition Material Type Starting Deals", Value = "AMT", Selected = callFor == "AMT" ? true : false });
            lstExpiry.Add(new SelectListItem { Text = "Acquisition Payment Term Starting Deals", Value = "APT", Selected = callFor == "APT" ? true : false });

            ViewBag.ExpiryFor = lstExpiry;
            ViewBag.callFrom = callFrom;
            ViewBag.expDays = expDays;

            if (callFrom == "D")
            {
                string dateInString = DateTime.Now.ToShortDateString();
                DateTime startDate = DateTime.Parse(dateInString);
                DateTime expiryDate = startDate.AddDays(expDays);
                ViewBag.startDate = startDate.ToShortDateString();
                ViewBag.endDate = expiryDate.ToShortDateString();
            }

            // int code = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
            ViewBag.BusinessUnitList = GetBusinessUnitList();

            return View();
        }
        public JsonResult BindTitleForDealExpiry(int BU_Code, string ExpiryFor, string keyword = "")
        {
            if (ExpiryFor == "A")
            {
                dynamic result = "";
                if (!string.IsNullOrEmpty(keyword))
                {
                    List<string> terms = keyword.Split('﹐').ToList();
                    terms = terms.Select(s => s.Trim()).ToList();
                    string searchString = terms.LastOrDefault().ToString().Trim();
                    result = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Acq_Deal.Business_Unit_Code == BU_Code
                 && (x.Acq_Deal.Is_Master_Deal == "Y" || x.Acq_Deal.Deal_Type_Code == GlobalParams.Deal_Type_Music)).Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).ToList().Distinct();
                }
                return Json(result);
            }
            else
            {
                dynamic result = "";
                if (!string.IsNullOrEmpty(keyword))
                {
                    List<string> terms = keyword.Split('﹐').ToList();
                    terms = terms.Select(s => s.Trim()).ToList();
                    string searchString = terms.LastOrDefault().ToString().Trim();
                    result = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Syn_Deal.Business_Unit_Code == BU_Code).Select(x => new { Title_Name = x.Title.Title_Name, Title_Code = x.Title.Title_Code }).ToList().Distinct();
                }
                return Json(result);
            }

        }
        public JsonResult BindRegionDealExpiry(string IsDomestic, string RegionType)
        {
            if (IsDomestic == "Y")
            {
                var countryTerritoryList = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Is_Theatrical_Territory == "Y"), "Country_Code", "Country_Name").Distinct().ToList();
                countryTerritoryList.AddRange(new MultiSelectList(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Is_Thetrical == "Y"), "Territory_Code", "Territory_Name").Distinct().ToList());
                ViewBag.Region = countryTerritoryList;
                Dictionary<string, object> obj = new Dictionary<string, object>();
                obj.Add("ddlRegion", ViewBag.Region);
                return Json(obj);
            }
            else
            {
                if (RegionType == "C")
                {
                    ViewBag.Region = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Is_Domestic_Territory == "N"), "Country_Code", "Country_Name").Distinct().ToList();
                    Dictionary<string, object> obj = new Dictionary<string, object>();
                    obj.Add("ddlRegion", ViewBag.Region);
                    return Json(obj);
                }
                else
                {
                    ViewBag.Region = new MultiSelectList(new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Is_Thetrical == "N"), "Territory_Code", "Territory_Name").Distinct().ToList();
                    Dictionary<string, object> obj = new Dictionary<string, object>();
                    obj.Add("ddlRegion", ViewBag.Region);
                    return Json(obj);
                }
            }
        }
        public PartialViewResult BindExpiryDealReport(string TitleCodes, string platformCodes, string RegionCodes, string days, string FromDate, string ToDate, string expiryFor, string Domestic, string SubDeal, string BUCode, string dateformat, string Range, string Tag = "")
        {
            RegionCodes = RegionCodes.Trim().Trim('﹐').Trim();
            string country_Codes_Param = "";
            TitleCodes = TitleCodes.Trim().Trim('﹐').Trim();
            string title_names = "";
            string CCODE = "";
            if (TitleCodes != "")
            {
                string[] terms = TitleCodes.Split('﹐');
                if (expiryFor.Substring(0, 1) == "A")
                {
                    string[] Title_Code = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Title.Title_Name)).Select(s => s.Title.Title_Code.ToString()).ToArray();
                    title_names = string.Join(", ", Title_Code);
                    if (title_names == "")
                        title_names = "-1";
                }
                else
                {
                    string[] Title_Code = new Syn_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Title.Title_Name)).Select(s => s.Title.Title_Code.ToString()).ToArray();
                    title_names = string.Join(", ", Title_Code);
                    if (title_names == "")
                        title_names = "-1";
                }
            }

            if (RegionCodes != "" || Tag == "C")
            {
                string[] terms = RegionCodes.Split('﹐');
                string[] country_Codes = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Country_Name)).Select(s => "C" + s.Country_Code.ToString()).ToArray();
                string[] country_Names = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Country_Name)).Select(s => s.Country_Name.ToString()).ToArray();
                country_Codes_Param = string.Join(",", country_Codes);
                if (country_Codes_Param == "" && RegionCodes != "")
                    country_Codes_Param = "-1";
                //else
                //    country_Codes_Param = "";
                CCODE = string.Join(",", country_Names);
            }

            else if (RegionCodes != "" || Tag == "T")
            {
                string[] terms = RegionCodes.Split('﹐');
                string[] country_Codes = new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Territory_Name)).Select(s => "T" + s.Territory_Code.ToString()).ToArray();
                string[] country_Names = new Territory_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Territory_Name)).Select(s => s.Territory_Name.ToString()).ToArray();
                country_Codes_Param = string.Join(",", country_Codes);
                if (country_Codes_Param == "" && RegionCodes != "")
                    country_Codes_Param = "-1";
                //else
                //    country_Codes_Param = "";
                CCODE = string.Join(",", country_Names);
            }
            else if (RegionCodes != "" || Tag == "")
            {
                string[] terms = RegionCodes.Split('﹐');
                string[] country_Codes = new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Country_Name) && x.Is_Active == "Y" && x.Is_Theatrical_Territory == "Y").Select(s => "C" + s.Country_Code.ToString()).ToArray();
                country_Codes_Param = string.Join(",", country_Codes);
                if (country_Codes_Param == "" && RegionCodes != "")
                    country_Codes_Param = "-1";
                //else
                //    country_Codes_Param = "";
                CCODE = string.Join(",", country_Codes);
            }

            days = days + Range;
            ReportParameter[] parm = new ReportParameter[15];

            parm[0] = new ReportParameter("titleCodes", title_names);
            parm[1] = new ReportParameter("platformCodes", platformCodes);
            parm[2] = new ReportParameter("countryCodes", country_Codes_Param);
            parm[3] = new ReportParameter("expiryDays", days);
            parm[4] = new ReportParameter("Deal_Type", expiryFor);
            parm[5] = new ReportParameter("IncludeDomestic", Domestic);
            parm[6] = new ReportParameter("IncludeSubDeal", SubDeal);
            parm[7] = new ReportParameter("BusinessUnit_Code", BUCode);
            parm[8] = new ReportParameter("DateFormat", dateformat);
            parm[9] = new ReportParameter("CountryCodeForFilter", CCODE);
            parm[10] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[11] = new ReportParameter("StartDate", Range != "E" ? GlobalUtil.MakedateFormat(FromDate) : " ");
            parm[12] = new ReportParameter("EndDate", Range != "E" ? GlobalUtil.MakedateFormat(ToDate) : " ");
            parm[13] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[14] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Acquisition_Expiry_Reports");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region -------------Content Wise Music Usage Report------------
        public ActionResult ContentMusicUsageReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForContentwiseMusicUsageReport);
            BindFormatDDL();
            return View();
        }
        public JsonResult PopulateTitleForContentWise(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && x.Deal_Type_Code == GlobalParams.Deal_Type_Content).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList().Distinct();
            }
            return Json(result);
        }
        public PartialViewResult BindContentMusicUsageReport(string TitleCodes, string FromDate, string ToDate, string dateformat)
        {
            string FinalFromDate = "";
            string FinalToDate = "";
            string title_names = TitleAutosuggest(TitleCodes);
            if (FromDate != "" && ToDate != "")
            {
                string frommonth = FromDate.Substring(0, 3);
                int fromyear = Convert.ToInt32(FromDate.Substring(FromDate.Length - 4, 4));

                int tomonth = DateTime.ParseExact(ToDate.Substring(0, 3), "MMM", CultureInfo.InvariantCulture).Month;

                int toyear = Convert.ToInt32(ToDate.Substring(ToDate.Length - 4, 4));
                int daysInMonths = System.DateTime.DaysInMonth(toyear, tomonth);

                FinalFromDate = "01-" + frommonth + "-" + fromyear;
                FinalToDate = daysInMonths + "-" + ToDate.Substring(0, 3) + "-" + toyear;
            }
            ReportParameter[] parm = new ReportParameter[7];
            parm[0] = new ReportParameter("Title_Codes", title_names);
            parm[1] = new ReportParameter("AiringDate_From", FinalFromDate);
            parm[2] = new ReportParameter("AiringDate_To", FinalToDate);
            parm[3] = new ReportParameter("DateFormat", dateformat);
            parm[4] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[5] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[6] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Content_Wise_Music_Wise");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region -------------Music Consumption Report------------
        public ActionResult MusicConsumptionReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForLabelwiseMusicCounsumptionReport);
            BindFormatDDL();
            return View();
        }
        public JsonResult MusicLabelMusicConsumption(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Label_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y").Select(x => new { Music_Label_Name = x.Music_Label_Name, Music_Label_Code = x.Music_Label_Code }).ToList().Distinct();
            }
            return Json(result);
        }
        public JsonResult ContentMusicConsumption(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && x.Deal_Type_Code == GlobalParams.Deal_Type_Content).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList().Distinct();
            }
            return Json(result);
        }
        public PartialViewResult BindMusicConsumptionReport(string musicList, string contentList, string txtfrom, string txtto, string dateformat)
        {
            string FinalFromDate = "";
            string FinalToDate = "";
            string title_names = TitleAutosuggest(contentList);
            string music_label_names = MusicLableAutosuggest(musicList);
            if (txtfrom != "" && txtto != "")
            {
                string frommonth = txtfrom.Substring(0, 3);
                int fromyear = Convert.ToInt32(txtfrom.Substring(txtfrom.Length - 4, 4));

                int tomonth = DateTime.ParseExact(txtto.Substring(0, 3), "MMM", CultureInfo.InvariantCulture).Month;

                int toyear = Convert.ToInt32(txtto.Substring(txtto.Length - 4, 4));
                int daysInMonths = System.DateTime.DaysInMonth(toyear, tomonth);

                FinalFromDate = "01-" + frommonth + "-" + fromyear;
                FinalToDate = daysInMonths + "-" + txtto.Substring(0, 3) + "-" + toyear;
            }

            ReportParameter[] parm = new ReportParameter[8];
            parm[0] = new ReportParameter("Title_Codes", title_names);
            parm[1] = new ReportParameter("Music_Label_Codes", music_label_names);
            parm[2] = new ReportParameter("AiringDate_From", FinalFromDate);
            parm[3] = new ReportParameter("AiringDate_To", FinalToDate);
            parm[4] = new ReportParameter("DateFormat", dateformat);
            parm[5] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[6] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[7] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "MUSIC_LABEL_CONSUMPTION");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region -----------------Territory Language Audit Report------------------
        public ActionResult TerritoryLanguageAuditReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForTerritoryLanguageAuditReport);
            return View();
        }
        public PartialViewResult GetData(string AuditType, string SearchString, int PageNo, int recordPerPage)
        {
            List<USP_Audit_Log_Report_for_Territory_and_Language_Group_Result> lst_Log_Report;
            lst_Log_Report = new USP_Service(objLoginEntity.ConnectionStringName).USP_Audit_Log_Report_for_Territory_and_Language_Group(SearchString.Trim(), AuditType).ToList();
            List<USP_Audit_Log_Report_for_Territory_and_Language_Group_Result> lst = new List<USP_Audit_Log_Report_for_Territory_and_Language_Group_Result>();
            int RecordCount = 0;
            RecordCount = lst_Log_Report.Count;
            ViewBag.RecordCount = RecordCount;
            ViewBag.SearchText = SearchString;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                PageNo = GetPaging(PageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lst_Log_Report.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            return PartialView("~/Views/Reports/_TerritoryLanguageAuditList.cshtml", lst);
        }
        private int GetPaging(int pageNo, int recordPerPage, int recordCount, out int noOfRecordSkip, out int noOfRecordTake)
        {
            noOfRecordSkip = noOfRecordTake = 0;
            if (recordCount > 0)
            {
                int cnt = pageNo * recordPerPage;
                if (cnt >= recordCount)
                {
                    int v1 = recordCount / recordPerPage;
                    if ((v1 * recordPerPage) == recordCount)
                        pageNo = v1;
                    else
                        pageNo = v1 + 1;
                }
                noOfRecordSkip = recordPerPage * (pageNo - 1);
                if (recordCount < (noOfRecordSkip + recordPerPage))
                    noOfRecordTake = recordCount - noOfRecordSkip;
                else
                    noOfRecordTake = recordPerPage;
            }
            return pageNo;
        }
        #endregion
        #region -------------Run Utiliazation Report-----------------
        public ActionResult RunUtilizationReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForRunUtilizationReport);
            int BU_Code = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();

            ViewBag.BusinessUnitList = GetBusinessUnitList();
            List<SelectListItem> lstRunType = new List<SelectListItem>();
            lstRunType.Add(new SelectListItem { Text = "Please Select", Value = "0" });
            lstRunType.Add(new SelectListItem { Text = "Limited", Value = "C" });
            lstRunType.Add(new SelectListItem { Text = "Unlimited", Value = "U" });
            ViewBag.RunType = lstRunType;

            int cnt = new Channel_Region_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Region_Code > 0 && x.Business_Unit_Code.Contains(BU_Code.ToString())).Count();
            if (cnt > 0)
            {
                ViewBag.ClusterList = new SelectList(new Channel_Region_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Region_Code > 0 && x.Business_Unit_Code.Contains(BU_Code.ToString())), "Channel_Region_Code", "Channel_Region_Name").Distinct().ToList();
            }
            ViewBag.count = cnt;
            return View();
        }
        public JsonResult BindTitleForRunUtilization(int BU_Code, string keyword = "", string TitleType = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();

                List<string> lstTitleTypeCode = new List<string>();

                if (TitleType == "M")
                {
                    System_Parameter_New Movies_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Movies").FirstOrDefault();
                    lstTitleTypeCode = Movies_system_Parameter.Parameter_Value.Split(',').ToList();
                }
                else
                {
                    System_Parameter_New Show_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Show").FirstOrDefault();
                    lstTitleTypeCode = Show_system_Parameter.Parameter_Value.Split(',').ToList();
                    //lstTitleTypeCode.Any(a => x.Deal_Type_Code.ToString() == a) &&
                }

                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lstTitleTypeCode.Any(a => x.Deal_Type_Code.ToString() == a) && x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Acq_Deal_Movie
                                                                       .Any(ADM => ADM.Title.Title_Code == x.Title_Code) && x.Acq_Deal_Movie
                                                                       .Any(AD => AD.Acq_Deal.Business_Unit_Code == BU_Code)).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList().Distinct();
            }
            return Json(result);
        }
        public JsonResult CountChannelRegion(int BUCode)
        {
            int cnt = new Channel_Region_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Region_Code > 0 && x.Business_Unit_Code.Contains(BUCode.ToString())).Count();
            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("count", cnt);
            return Json(obj);
        }
        public JsonResult BindChannelForRunUtlization(int ClusterCode, string keyword = "")
        {
            if (ClusterCode.ToString() == "0")
            {
                dynamic result = "";
                if (!string.IsNullOrEmpty(keyword))
                {
                    List<string> terms = keyword.Split('﹐').ToList();
                    terms = terms.Select(s => s.Trim()).ToList();
                    string searchString = terms.LastOrDefault().ToString().Trim();
                    result = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y").Select(x => new { Channel_Name = x.Channel_Name, Channel_Code = x.Channel_Code }).ToList().Distinct();
                }
                return Json(result);
            }
            else
            {
                dynamic result = "";
                if (!string.IsNullOrEmpty(keyword))
                {
                    List<string> terms = keyword.Split('﹐').ToList();
                    terms = terms.Select(s => s.Trim()).ToList();
                    string searchString = terms.LastOrDefault().ToString().Trim();
                    result = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && x.Channel_Region_Mapping.Any(crm => crm.Channel_code == x.Channel_Code && crm.Channel_Region_Code == ClusterCode)).Select(x => new { Channel_Name = x.Channel_Name, Channel_Code = x.Channel_Code }).ToList().Distinct();
                }
                return Json(result);
            }
        }
        public ActionResult BindRunUtilizationReport(string BU_Code, string TitleCodes, string ChannelCodes, string AllYears, string ParamExpandOrCollapse, string RunType, string IsDealExpire, string ClusterCode, string BUName, string TitleType)
        {
            if (TitleType == "M")
                TitleType = "Movie";
            else
                TitleType = "Program";
            int DealTypeCode = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Type_Name == TitleType).Select(s => s.Deal_Type_Code).FirstOrDefault();
            string title_names = TypeWiseTitleAutosuggest(TitleCodes, DealTypeCode);
            string channel_names = ChannelAutosuggest(ChannelCodes);
            string ReportName = "CHANNEL_WISE_CONSUMPTION";
            if (ClusterCode != "")
            {
                if (ChannelCodes == "")
                {
                    ChannelCodes = String.Join(",", new Channel_Region_Mapping_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Region_Code.ToString() == ClusterCode).Select(x => x.Channel_code).ToList());
                }
            }
            ReportParameter[] parm;
            if (BUName.Contains("English"))
                parm = new ReportParameter[13];
            else
                parm = new ReportParameter[12];
            parm[0] = new ReportParameter("BU_Code", BU_Code);
            parm[1] = new ReportParameter("TitleCodes", title_names);
            parm[2] = new ReportParameter("Flag", "MOVIE");
            parm[3] = new ReportParameter("DMContentCodes", "0");
            parm[4] = new ReportParameter("ChannelCodes", channel_names);
            parm[5] = new ReportParameter("AllYears", AllYears);
            parm[6] = new ReportParameter("ParamExpandOrCollapse", ParamExpandOrCollapse);
            parm[7] = new ReportParameter("Run_Type", RunType);
            parm[8] = new ReportParameter("IsDealExpire", IsDealExpire);
            parm[9] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[10] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[11] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            if (BUName.Contains("English"))
            {
                parm[12] = new ReportParameter("Channel_Region", "0");
                ReportName = "CHANNEL_WISE_CONSUMPTION_ENGLISH";
            }
            ReportViewer rptViewer = BindReport(parm, "CHANNEL_WISE_CONSUMPTION_ENGLISH");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region---------------- P&A Rights Report----------------------------------------------------

        public ActionResult PARightsReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForPARightsReport);
            string isAdvAncillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Ancillary_Advanced" && x.IsActive == "Y").Select(x => x.Parameter_Value.ToString()).FirstOrDefault();
            ViewBag.isAdvAncillary = isAdvAncillary;
            if (isAdvAncillary == "Y")
            {


                ViewBag.AncillaryTypeList = new MultiSelectList(new Ancillary_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true)
                                        .Select(i => new { Display_Value = i.Ancillary_Type_Code, Display_Text = i.Ancillary_Type_Name }).ToList().Distinct(),
                                        "Display_Value", "Display_Text").ToList();

            }
            ViewBag.BusinessUnitList = GetBusinessUnitList();
            return View();
        }
        public PartialViewResult BindPARList(int BUCode, int pageNo, int recordPerPage)
        {
            int RecordCount = 0;
            List<Acq_Adv_Ancillary_Report> lst = new List<Acq_Adv_Ancillary_Report>();
            lstMHReport = new Acq_Adv_Ancillary_Report_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Business_Unit_Code == BUCode).OrderByDescending(o => o.Acq_Adv_Ancillary_Report_Code).ToList();

            RecordCount = lstMHReport.Where(w => w.Accessibility.Trim() == "P" || (w.Accessibility.Trim() == "R" && w.Generated_By == objLoginUser.Users_Code)).Count();
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstMHReport.Where(w => w.Accessibility.Trim() == "P" || (w.Accessibility.Trim() == "R" && w.Generated_By == objLoginUser.Users_Code)).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.RecordCount = RecordCount;
            return PartialView("~/Views/PA_Rights_Reports/_PARightsDataList.cshtml", lst);
        }

        public PartialViewResult BindCriteriaDetailsPopup(int AcqAdvAncillaryReportCode)
        {
            Acq_Adv_Ancillary_Report objPAR = lstMHReport.Where(x => x.Acq_Adv_Ancillary_Report_Code == AcqAdvAncillaryReportCode).FirstOrDefault();
            var arrOfTitle = objPAR.Title_Codes.TrimEnd('﹐');
            string strTitle = string.Join(",", arrOfTitle);

            ViewBag.BusinessUnit = Get_Business_Unit(Convert.ToInt32(objPAR.Business_Unit_Code));
            // ViewBag.AncillaryType = Get_Ancillary_Type(Convert.ToInt32(objPAR.Ancillary_Type_Codes));
            //ViewBag.Title = Get_Title(objMUR.Title_Codes);
            // var ArrTitleCodes = objMUR.Title_Codes.Trim('﹐');
            var lstPlatformNames = new List<string>();
            if (objPAR.Platform_Codes != "")
            {
                var tempPlatformcode = objPAR.Platform_Codes.Split(',').Select(int.Parse).Distinct().ToList();
                var lstPlatform = new Platform_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstPlatformNames = lstPlatform.FindAll(x => tempPlatformcode.Any(y => y == x.Platform_Code)).Select(s => s.Platform_Name).ToList();
                ViewBag.PlatForm = string.Join(",", lstPlatformNames);
            }
            else
            {
                ViewBag.PlatForm = "NA";
            }
            var lstTitleNames = new List<string>();
            if (objPAR.Title_Codes != "")
            {
                var tempTitlecode = objPAR.Title_Codes.Split(',').Select(int.Parse).Distinct().ToList();
                var lstTitle = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstTitleNames = lstTitle.FindAll(x => tempTitlecode.Any(y => y == x.Title_Code)).Select(s => s.Title_Name).ToList();
                ViewBag.Title = string.Join(",", lstTitleNames);
            }
            else
            {
                ViewBag.Title = "NA";
            }
            var lstAncillaryNames = new List<string>();
            if (objPAR.Ancillary_Type_Codes != null && objPAR.Ancillary_Type_Codes != "")
            {
                var tempAncillarycode = objPAR.Ancillary_Type_Codes.Split(',').Select(int.Parse).Distinct().ToList();
                var lstAncillary = new Ancillary_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
                lstAncillaryNames = lstAncillary.FindAll(x => tempAncillarycode.Any(y => y == x.Ancillary_Type_Code)).Select(s => s.Ancillary_Type_Name).ToList();
                ViewBag.AncillaryType = string.Join(",", lstAncillaryNames);
            }
            else
            {
                ViewBag.AncillaryType = "NA";
            }
            if (objPAR.Agreement_No != "")
            {
                ViewBag.AgreementNo = objPAR.Agreement_No;
            }
            else
            {
                ViewBag.AgreementNo = "NA";
            }

            if (objPAR.IncludeExpired == "Y")
            {
                ViewBag.IncludeExpired = "Yes";
            }
            else
            {
                ViewBag.IncludeExpired = "No";
            }

            return PartialView("~/Views/PA_Rights_Reports/_CriteriaDetails.cshtml");
        }
        public JsonResult GetPARStatus(string PARCode)
        {
            int PACode = Convert.ToInt32(PARCode);
            string recordStatus = new Acq_Adv_Ancillary_Report_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Acq_Adv_Ancillary_Report_Code == PACode).Select(s => s.Report_Status).FirstOrDefault();
            var obj = new
            {
                RecordStatus = recordStatus,

            };
            return Json(obj);
        }
        public JsonResult DownloadReport(int MURCode)
        {
            //string fileName = new Acq_Adv_Ancillary_Report_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Acq_Adv_Ancillary_Report_Code == MURCode).Select(s => s.Report_Name).FirstOrDefault();
            string fullPath = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "P&ARightsReport").Select(s => s.Parameter_Value).FirstOrDefault();

            //fullPath = fullPath + "Adv_Ancillary_Report_Sheet_" + MURCode + ".xlsx";
            fullPath = (Server.MapPath("~") + fullPath + "\\" + "Adv_Ancillary_Report_Sheet_" + MURCode + ".xlsx");
            //string path = fullPath + fileName;


            FileInfo file = new FileInfo(fullPath);
            if (file.Exists)
            {
                var obj = new
                {
                    path = fullPath,
                    temppath = fullPath
                };
                return Json(obj);
            }
            else
            {
                var obj = new
                {
                    path = "",
                    temppath = fullPath
                };
                return Json(obj);
            }
        }

        public void Download(int MURCode)
        {
            //string fileName = new Music_Usage_Report_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Music_Usage_Report_Code == MURCode).Select(s => s.File_Name).FirstOrDefault();
            string fullPath = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.Parameter_Name == "P&ARightsReport").Select(s => s.Parameter_Value).FirstOrDefault();
            fullPath = (Server.MapPath("~") + fullPath + "\\" + "Adv_Ancillary_Report_Sheet_" + MURCode + ".xlsx");
            //string path = fullPath + fileName;
            //string path = (Server.MapPath("~") + fullPath + "\\" + fileName);

            FileInfo file = new FileInfo(fullPath);
            Dictionary<string, object> obj = new Dictionary<string, object>();
            if (file.Exists)
            {
                byte[] bts = System.IO.File.ReadAllBytes(fullPath);
                Response.Clear();
                Response.ClearHeaders();
                Response.AddHeader("Content-Type", "Application/ms-excel");
                Response.AddHeader("Content-Length", bts.Length.ToString());
                Response.AddHeader("Content-Disposition", "attachment;   filename=" + "Adv_Ancillary_Report_Sheet_" + MURCode + ".xlsx");
                Response.BinaryWrite(bts);
                Response.Flush();
                //WebClient client = new WebClient();
                //Byte[] buffer = client.DownloadData(path);
                //Response.Clear();
                //Response.ContentType = "application/ms-excel";
                //Response.AddHeader("content-disposition", "Attachment;filename=" + fileName);
                //Response.WriteFile(path);
                //Response.End();
            }
        }

        public JsonResult DeleteReportData(string MURCode)
        {
            Acq_Adv_Ancillary_Report_Service objService = new Acq_Adv_Ancillary_Report_Service(objLoginEntity.ConnectionStringName);
            Acq_Adv_Ancillary_Report objMUR = objService.GetById(Convert.ToInt32(MURCode));
            objMUR.EntityState = State.Deleted;

            dynamic resultSet;
            bool isValid = objService.Save(objMUR, out resultSet);

            Dictionary<string, object> objdic = new Dictionary<string, object>();
            objdic.Add("Message", "Data Deleted Successfully");
            return Json(objdic);
        }

        public string Get_Business_Unit(int BUCode)
        {
            string BU_names = "";

            if (BUCode != 0)
                BU_names = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Business_Unit_Code == BUCode).Select(s => s.Business_Unit_Name).FirstOrDefault();
            return BU_names;

        }

        public JsonResult BindPATitleList(int BU_Code, string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();

                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Name.ToUpper().Contains(searchString.ToUpper()) && s.Is_Active == "Y" && s.Acq_Deal_Movie
                                                                          .Any(ADM => ADM.Title.Title_Code == s.Title_Code) && s.Acq_Deal_Movie
                                                                          .Any(AD => AD.Acq_Deal.Business_Unit_Code == BU_Code)).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();
            }
            return Json(result);

        }

        public JsonResult BindPARightsReport(string txtCriteriaName, string AccessibilityType, string agreementNo, string businessUnitcode, string titleCodes, string AncillaryTypeCode = "", string platformCodes = "", string IncludeExpired = "N") // string txtfrom , string txtto, string dateformat, string datetimeformat, string txtCriteriaName, string AccessibilityType,
        {

            string title_names = TitleAutosuggest(titleCodes);
            string isAdvAncillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Ancillary_Advanced" && x.IsActive == "Y").Select(x => x.Parameter_Value.ToString()).FirstOrDefault();
            string status = "S", message = objMessageKey.Recordsavedsuccessfully;
            //string from = "";
            //string to = "";


            string strTitle = string.Join(",", titleCodes);
            string strAncilaary = string.Join(",", AncillaryTypeCode);
            string strContent = string.Join(",", titleCodes);

            //if (txtfrom != "")
            //    from = GlobalUtil.MakedateFormat(txtfrom);
            //if (txtto != "")
            //    to = GlobalUtil.MakedateFormat(txtto);

            Acq_Adv_Ancillary_Report_Service objService = new Acq_Adv_Ancillary_Report_Service(objLoginEntity.ConnectionStringName);
            Acq_Adv_Ancillary_Report objPAR = new RightsU_Entities.Acq_Adv_Ancillary_Report();
            objPAR.EntityState = State.Added;

            objPAR.Title_Codes = title_names;
            objPAR.Agreement_No = agreementNo;
            objPAR.Business_Unit_Code = Convert.ToInt32(businessUnitcode);
            // objPAR.Date_Format = dateformat;
            // objPAR.DateTime_Format = datetimeformat;
            objPAR.Platform_Codes = platformCodes;
            objPAR.Created_By = objLoginUser.First_Name + " " + objLoginUser.Last_Name;
            objPAR.Report_Name = txtCriteriaName;
            objPAR.IncludeExpired = IncludeExpired;
            objPAR.Accessibility = AccessibilityType;
            objPAR.File_Name = "";
            objPAR.Report_Status = "P";
            objPAR.Generated_By = objLoginUser.Users_Code;
            objPAR.Generated_On = System.DateTime.Now;
            if (AncillaryTypeCode != "")
                objPAR.Ancillary_Type_Codes = AncillaryTypeCode;
            else
                objPAR.Ancillary_Type_Codes = "";


            dynamic resultSet;
            bool isValid = objService.Save(objPAR, out resultSet);

            if (!isValid)
            {
                status = "E";
                message = resultSet;
            }

            var obj = new
            {
                Status = status,
                Message = message
            };
            return Json(obj);
        }
        public JsonResult RefreshReport(int PARCode)
        {
            Acq_Adv_Ancillary_Report_Service objService = new Acq_Adv_Ancillary_Report_Service(objLoginEntity.ConnectionStringName);
            Acq_Adv_Ancillary_Report objPAR = objService.GetById(PARCode);
            objPAR.EntityState = State.Modified;
            objPAR.File_Name = "";
            objPAR.Report_Status = "P";
            objPAR.Error_Message = "";

            dynamic resultSet;
            bool isValid = objService.Save(objPAR, out resultSet);

            Dictionary<string, object> obj = new Dictionary<string, object>();
            obj.Add("Message", "Data Refreshed Successfully");
            return Json(obj);
        }
        //public PartialViewResult BindPARightsReport(string agreementNo, string businessUnitcode, string titleCodes, string AncillaryTypeCode = "", string platformCodes = "", string IncludeExpired = "N")
        //{
        //    string title_names = TitleAutosuggest(titleCodes);
        //    string isAdvAncillary = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_Ancillary_Advanced" && x.IsActive == "Y").Select(x => x.Parameter_Value.ToString()).FirstOrDefault();
        //    if (isAdvAncillary == "Y")
        //    {
        //        if (platformCodes != " ")
        //            platformCodes = GetSelectedPlatform(platformCodes, businessUnitcode);

        //        title_names = title_names == "" ? " " : title_names;
        //        agreementNo = agreementNo == "" ? " " : agreementNo;
        //        AncillaryTypeCode = AncillaryTypeCode == "" ? "0" : AncillaryTypeCode;

        //        ReportParameter[] parm = new ReportParameter[9];
        //        parm[0] = new ReportParameter("Agreement_No", agreementNo);
        //        parm[1] = new ReportParameter("Title_Codes", title_names);//Title Name Means Title Codes
        //        parm[2] = new ReportParameter("Business_Unit_Code", businessUnitcode.ToString());
        //        parm[3] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
        //        parm[4] = new ReportParameter("Ancillary_Type_Code", AncillaryTypeCode);
        //        parm[5] = new ReportParameter("Platform_Codes", platformCodes);
        //        parm[6] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
        //        parm[7] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
        //        parm[8] = new ReportParameter("IncludeExpired", IncludeExpired);
        //        ReportViewer rptViewer = BindReport(parm, "rpt_AdvAncillaryReport");
        //        ViewBag.ReportViewer = rptViewer;
        //    }
        //    else
        //    {
        //        ReportParameter[] parm = new ReportParameter[7];
        //        parm[0] = new ReportParameter("Agreement_No", agreementNo);
        //        parm[1] = new ReportParameter("Title_Name", title_names);//Title Name Means Title Codes
        //        parm[2] = new ReportParameter("Business_Unit_Code", businessUnitcode.ToString());
        //        parm[3] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
        //        parm[4] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
        //        parm[5] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
        //        ReportViewer rptViewer = BindReport(parm, "rpt_AncillaryRightsReport");
        //        ViewBag.ReportViewer = rptViewer;
        //    }

        //    return PartialView("~/Views/Shared/ReportViewer.cshtml");
        //}
        #endregion-----------------------------------------------------------------------------------

        #region---------------- Cost Report----------------------------------------------------
        public ActionResult CostReport()
        {
            int ModuleCode = objLoginUser.moduleCode;
            if (ModuleCode == GlobalParams.ModuleCodeForCostReport)
                LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCostReport);
            else
                LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForRevenueReport);
            BindFormatDDL();
            if (Request.QueryString["modulecode"] == GlobalParams.ModuleCodeForRevenueReport.ToString())
            {
                ViewBag.Module = "rev";
            }
            else if (Request.QueryString["modulecode"] == GlobalParams.ModuleCodeForCostReport.ToString())
            {
                ViewBag.Module = "acq";
            }
            // ViewBag.TitleList = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Reference_Flag != "T").OrderBy(t => t.Title_Name), "Title_Code", "Title_Name").ToList();
            return View();
        }
        public PartialViewResult BindCostReport(string agreementNo, string StartDate, string EndDate, string[] titleCodes, string IncludeExpiry, string ModuleCode, string dateformat, string numberformat)
        {
            string numberResult = numberformat.Split('~')[0];
            string strTitleCodes = string.Join(",", titleCodes);
            string title_names = TitleAutosuggest(strTitleCodes);
            ReportParameter[] parm = new ReportParameter[11];
            //ReportParameter[] parm = new ReportParameter[6];
            parm[0] = new ReportParameter("Agreement_No", agreementNo);
            parm[1] = new ReportParameter("Title_Codes", title_names);//Title Name Means Title Codes
            parm[2] = new ReportParameter("Start_Date", GlobalUtil.MakedateFormat(StartDate));
            parm[3] = new ReportParameter("End_Date", GlobalUtil.MakedateFormat(EndDate));
            parm[4] = new ReportParameter("IncludeExpiredDeals", IncludeExpiry.ToString());
            parm[5] = new ReportParameter("ModuleCode", ModuleCode.ToString());
            parm[6] = new ReportParameter("DateFormat", dateformat);
            parm[7] = new ReportParameter("NumberFormat", numberResult);
            parm[8] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[9] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[10] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Cost_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        public JsonResult PopulateTitleForCost(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper())).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();
            }
            return Json(result);
        }
        #endregion-----------------------------------------------------------------------------------

        #region---------------Music Usage report-----------------------------------------------------
        public ActionResult MusicUsageReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicUsageReport);
            BindFormatDDL();
            var paramValue = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "MusicThemeVisibility").Select(x => x.Parameter_Value).SingleOrDefault();
            ViewBag.parmValue = paramValue;
            //int code = 1;
            int BU_Code = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();

            Deal_Type_Service objDTS = new Deal_Type_Service(objLoginEntity.ConnectionStringName);
            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            ViewBag.BusinessUnitList = GetBusinessUnitList();

            ViewBag.ChannelList = new SelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Channel_Code", "Channel_Name").ToList();
            ViewBag.TitleTypeList = new SelectList(new Music_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(t => t.Is_Active == "Y"), "Music_Type_Code", "Music_Type_Name").ToList();
            ViewBag.MusicLabelList = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(m => m.Is_Active == "Y"), "Music_Label_Code", "Music_Label_Name").ToList();
            ViewBag.StarCastList = new SelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(t => t.Talent_Role.Any(x => x.Role_Code == GlobalParams.CodeForStarCast)), "Talent_Code", "Talent_Name").ToList();
            ViewBag.GenresList = new SelectList(new Genre_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Genres_Code", "Genres_Name").ToList();
            ViewBag.MusicThemeList = new SelectList(new Music_Theme_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Theme_Code", "Music_Theme_Name").ToList();

            return View();
        }

        public JsonResult BindContentList(int BU_Code, string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && (x.Reference_Flag != "T" || x.Reference_Flag == null) && x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code)).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();
            }
            return Json(result);
        }
        public JsonResult BindStarCast(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Name.ToUpper().Contains(searchString.ToUpper())).Select(x => new { Talent_Name = x.Talent_Name, Talent_Code = x.Talent_Code }).ToList().Distinct();
            }
            return Json(result);
        }
        public PartialViewResult BindMusicUsageReport(string businessUnitcode, string[] Content, string EpisodeFrom, string EpisodeTo, string[] Channel, string[] TitleType,
            string[] MusicLabel, string txtfrom, string txtto, string[] StarCast, string[] Genres, string[] MusicTheme, string dateformat, string datetimeformat)
        {
            string from = "";
            string to = "";

            string strContent = string.Join(",", Content);
            string strChannel = string.Join(",", Channel);
            string strTitle = string.Join(",", TitleType);
            string strMusicLabel = string.Join(",", MusicLabel);
            string strStarCast = string.Join(",", StarCast);
            string strGenrres = string.Join(",", Genres);
            string strMusicTheme = string.Join(",", MusicTheme);

            string title_names = TitleAutosuggest(strContent);
            string starcast_names = TalentAutosuggest(strStarCast);

            if (txtfrom != "")
                from = GlobalUtil.MakedateFormat(txtfrom);
            if (txtto != "")
                to = GlobalUtil.MakedateFormat(txtto);

            ReportParameter[] parm = new ReportParameter[15];
            parm[0] = new ReportParameter("Title_Code", title_names);
            parm[1] = new ReportParameter("Channel", strChannel);
            parm[2] = new ReportParameter("StartDate", from);
            parm[3] = new ReportParameter("EndDate", to);
            parm[4] = new ReportParameter("TitleType", strTitle);
            parm[5] = new ReportParameter("Genre", strGenrres);
            parm[6] = new ReportParameter("MusicLabel", strMusicLabel);
            parm[7] = new ReportParameter("StarCast", starcast_names);
            parm[8] = new ReportParameter("Theme", strMusicTheme);
            parm[9] = new ReportParameter("BuCode", businessUnitcode);
            parm[10] = new ReportParameter("EpisodeFrom", EpisodeFrom == "" ? "0" : EpisodeFrom);
            parm[11] = new ReportParameter("EpisodeTo", EpisodeTo == "" ? "0" : EpisodeTo);
            parm[12] = new ReportParameter("DateFormat", dateformat);
            parm[13] = new ReportParameter("DateTimeFormat", datetimeformat);
            parm[14] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            //parm[15] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            //parm[16] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "rptMusicUsage");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }

        #endregion---------------Music Usage report-----------------------------------------------------
        #region-----Music Airing Report----
        public ActionResult MusicAiringReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicAiringReport);
            BindFormatDDL();
            List<USP_Get_Title_Content_Data_Result> lstGTCD = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Title_Content_Data("TC").ToList();
            var fromDate = DateTime.Today;
            var toDate = fromDate.AddDays(7);
            ViewBag.fromDate = fromDate.ToShortDateString();
            ViewBag.toDate = toDate.ToShortDateString();
            ViewBag.ContentList = new SelectList(lstGTCD, "Display_Value", "Display_Text").ToList();
            ViewBag.ChannelList = new SelectList(new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Channel_Code", "Channel_Name").ToList();
            return View();
        }
        public JsonResult AutoMusicTrackName(string keyword)
        {
            List<string> terms = keyword.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            var result = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y").Distinct().
                Select(x => new { Music_Title_Name = x.Music_Title_Name, Music_Title_Code = x.Music_Title_Code }).ToList();

            return Json(result);
        }
        public JsonResult ValidationDate(string dateFrom, string dateTo)
        {
            string Message = "";
            var DateFrom = Convert.ToDateTime(dateFrom);
            var DateTo = Convert.ToDateTime(dateTo);
            bool totalday = DateTo < DateFrom;
            if (totalday)
            {
                Message = "To date should be greater than From date";
            }
            TimeSpan totalDayDiff = DateTo - DateFrom;
            var dayDiff = totalDayDiff.TotalDays;
            if (dayDiff > 7)
            {
                Message = "The Airirng date range should be less than or equal to 7";
            }

            var obj = new
            {
                Message = Message
            };
            return Json(obj);
        }
        public PartialViewResult BindMusicAiringReport(string contentCode, string dateFrom, string dateTo, string episodeFrom, string episodeTo, string musicTrackCode, string channelCode, string dateformat, string datetimeformat)
        {
            string music_track_names = MusicTitleAutosuggest(musicTrackCode);
            if (contentCode == "")
                contentCode = " ";

            ReportParameter[] param = new ReportParameter[12];
            param[0] = new ReportParameter("Title_Content_Code", contentCode);
            param[1] = new ReportParameter("Episode_From", episodeFrom);
            param[2] = new ReportParameter("Episode_To", episodeTo);
            param[3] = new ReportParameter("Date_From", GlobalUtil.MakedateFormat(dateFrom));
            param[4] = new ReportParameter("Date_To", GlobalUtil.MakedateFormat(dateTo));
            param[5] = new ReportParameter("Music_Title_Code", music_track_names);
            param[6] = new ReportParameter("Channel_Code", channelCode);
            param[7] = new ReportParameter("DateFormat", dateformat);
            param[8] = new ReportParameter("DateTimeFormat", datetimeformat);
            param[9] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            param[10] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            param[11] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(param, "Music_Airing_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion
        #region -- Music Track Audit report--
        public ActionResult MusicTrackActivityReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicTrackActivityReport);
            BindFormatDDL();
            return View();
        }
        public PartialViewResult BindMusicTrackAuditReport(string userCode, string dateFrom, string dateTo, string dateformat)
        {
            string user_names = UserAutosuggest(userCode);
            ReportParameter[] param = new ReportParameter[7];
            param[0] = new ReportParameter("User_Id", user_names);
            param[1] = new ReportParameter("Date_From", GlobalUtil.MakedateFormat(dateFrom));
            param[2] = new ReportParameter("Date_To", GlobalUtil.MakedateFormat(dateTo));
            param[3] = new ReportParameter("DateFormat", dateformat);
            param[4] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            param[5] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            param[6] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(param, "Music_Track_Audit_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region --- Amort Report ---
        public ActionResult AmortReport()
        {
            return View();
        }
        #endregion
        #region --- Channel Wise Music Usage Report-----
        public ActionResult ChannelWiseMusicUsageReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForChannelWiseMusicUsageReport);
            BindFormatDDL();
            return View();
        }
        public JsonResult PopulateChannelList(string keyword = "")
        {
            List<string> terms = keyword.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            var result = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Channel_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y").Distinct().
                Select(x => new { Channel_Name = x.Channel_Name, Channel_Code = x.Channel_Code }).ToList();

            return Json(result);
        }
        public JsonResult PopulateMusicList(string keyword = "")
        {
            List<string> terms = keyword.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();
            var result = new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Label_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y").Distinct().
                Select(x => new { Music_Label_Name = x.Music_Label_Name, Music_Label_Code = x.Music_Label_Code }).ToList();

            return Json(result);
        }
        public PartialViewResult BindChannelWiseMusicUsageReport(string contentCode, string musiclabelCode, string channelCode, string dateFrom, string dateTo, string dateformat)
        {
            string channel_names = ChannelAutosuggest(channelCode);
            string music_label_names = MusicLableAutosuggest(musiclabelCode);
            string title_names = TitleAutosuggest(contentCode);

            string FinalFromDate = "";
            string FinalToDate = "";
            if (dateFrom != "" && dateTo != "")
            {
                string frommonth = dateFrom.Substring(0, 3);
                int fromyear = Convert.ToInt32(dateFrom.Substring(dateFrom.Length - 4, 4));

                int tomonth = DateTime.ParseExact(dateTo.Substring(0, 3), "MMM", CultureInfo.InvariantCulture).Month;

                int toyear = Convert.ToInt32(dateTo.Substring(dateTo.Length - 4, 4));
                int daysInMonths = System.DateTime.DaysInMonth(toyear, tomonth);

                FinalFromDate = "01-" + frommonth + "-" + fromyear;
                FinalToDate = daysInMonths + "-" + dateTo.Substring(0, 3) + "-" + toyear;
            }

            ReportParameter[] parm = new ReportParameter[9];
            parm[0] = new ReportParameter("Title_Codes", title_names);
            parm[1] = new ReportParameter("Music_Label_Codes", music_label_names);
            parm[2] = new ReportParameter("Channel_Codes", channel_names);
            parm[3] = new ReportParameter("AiringDate_From", FinalFromDate);
            parm[4] = new ReportParameter("AiringDate_To", FinalToDate);
            parm[5] = new ReportParameter("DateFormat", dateformat);
            parm[6] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[7] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[8] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Channel_Wise_Music_Usage_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        public JsonResult PopulateContentName(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Name.ToUpper().Contains(searchString.ToUpper()) && s.Is_Active == "Y" && s.Deal_Type_Code == GlobalParams.Deal_Type_Content).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();

            }

            return Json(result);
        }
        #endregion

        #region---------------- Revenue Report----------------------------------------------------
        public ActionResult RevenueReport()
        {
            BindFormatDDL();
            ViewBag.TitleList = new SelectList(new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Reference_Flag != "T").OrderBy(t => t.Title_Name), "Title_Code", "Title_Name").ToList();
            return View();
        }
        public PartialViewResult BindRevenueReport(string agreementNo, string StartDate, string EndDate, string[] titleCodes, string IncludeExpiry, string ModuleCode, string dateformat, string numberformat)
        {
            string numberResult = numberformat.Split('~')[0];
            string strTitle = string.Join(",", titleCodes);
            string title_names = TitleAutosuggest(strTitle);
            ReportParameter[] parm = new ReportParameter[11];
            //ReportParameter[] parm = new ReportParameter[6];
            parm[0] = new ReportParameter("Agreement_No", agreementNo);
            parm[1] = new ReportParameter("Title_Codes", title_names);//Title Name Means Title Codes
            parm[2] = new ReportParameter("Start_Date", GlobalUtil.MakedateFormat(StartDate));
            parm[3] = new ReportParameter("End_Date", GlobalUtil.MakedateFormat(EndDate));
            parm[4] = new ReportParameter("IncludeExpiredDeals", IncludeExpiry.ToString());
            parm[5] = new ReportParameter("ModuleCode", ModuleCode.ToString());
            parm[6] = new ReportParameter("DateFormat", dateformat);
            parm[7] = new ReportParameter("NumberFormat", numberResult);
            parm[8] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[9] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[10] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Cost_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion-----------------------------------------------------------------------------------

        #region--------------------Attachment Report-------------------------------------------------

        public ActionResult DealAttachmentReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAttachmentReport);
            ViewBag.BusinessUnitList = GetBusinessUnitList();
            string moduleCode = Request.QueryString["modulecode"];
            ViewBag.Code = moduleCode;
            ViewBag.DocumentTypeList = new SelectList(new Document_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(t => t.Document_Type_Name), "Document_Type_Code", "Document_Type_Name").ToList();
            List<SelectListItem> lstDeal = new List<SelectListItem>();
            lstDeal.Add(new SelectListItem { Text = "Acquisition Deals", Value = "A" });
            lstDeal.Add(new SelectListItem { Text = "Syndication Deals", Value = "S" });
            ViewBag.DealList = lstDeal;
            return View();
        }
        public PartialViewResult BindDealAttachmentReport(string businessUnitcode, string DealNo, string Type, string Title, string DocumentType)
        {
            string title_names = TitleAutosuggest(Title);
            ReportParameter[] parm = new ReportParameter[8];

            parm[0] = new ReportParameter("Agreement_No", DealNo);
            parm[1] = new ReportParameter("Type", Type);
            parm[2] = new ReportParameter("Title_Codes", title_names);
            parm[3] = new ReportParameter("Business_Unit_Code", businessUnitcode);
            parm[4] = new ReportParameter("Document_Type_Code", DocumentType);
            parm[5] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[6] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[7] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Attachment_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        public JsonResult PopulateTitleForAttachment(int BU_Code, int Module_Code, string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                if (Module_Code == GlobalParams.ModuleCodeForAcqDeal)
                {
                    result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Reference_Flag != "T" && x.Acq_Deal_Movie.Any(AM => AM.Acq_Deal.Business_Unit_Code == BU_Code)).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).Distinct().ToList();
                }
                else
                {
                    result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Reference_Flag != "T" && x.Syn_Deal_Movie.Any(SM => SM.Syn_Deal.Business_Unit_Code == BU_Code)).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();
                }
            }
            return Json(result);
        }


        #endregion-----------------------------------------------------------------------------------

        #region -----------Episodic Cost Report----------------------------
        public ActionResult EpisodicCostReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForEpisodicCostReport);
            BindFormatDDL();
            Session["ABC"] = null;

            ViewBag.Deal_Type = new SelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(t => t.Deal_Type_Name), "Deal_Type_Code", "Deal_Type_Name").ToList();
            ViewBag.BusinessUnit = new SelectList(new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(t => t.Business_Unit_Name), "Business_Unit_Code", "Business_Unit_Name").ToList();
            var lstAcq_Deal_Movie = new Acq_Deal_Movie_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList();
            Session["ABC"] = lstAcq_Deal_Movie;
            return View();
        }

        public JsonResult Bind_Title(int Selected_BUCode, int selectedDeal_Type, string Selected_Title_Codes = "", string Searched_Title = "")
        {
            List<string> terms = Searched_Title.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            var lstAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Business_Unit_Code == Selected_BUCode && x.Deal_Type_Code == selectedDeal_Type).Select(x => x.Acq_Deal_Code).ToList();
            var lstAcq_Deal_Movie = (List<Acq_Deal_Movie>)Session["ABC"];

            var b = from ad in lstAcq_Deal
                    join adm in lstAcq_Deal_Movie on ad equals adm.Acq_Deal_Code
                    select new { TitleName = adm.Title.Title_Name, TitleCode = adm.Title_Code };

            string searchString = terms.LastOrDefault().ToString().Trim();


            var result = b.Where(x => x.TitleName.ToLower().Contains(searchString.ToLower()) && !terms.ToString().ToLower().Contains(x.TitleName.ToLower()))
                .Select(i => new { TitleName = i.TitleName, TitleCode = i.TitleCode }).Distinct().ToList();

            return Json(result);
        }

        public JsonResult Bind_Aggrement(int Selected_BUCode, string Selected_Aggr_Codes = "", string Searched_Aggr = "")
        {
            List<string> terms = Searched_Aggr.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            var lstAcq_Deal = new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Business_Unit_Code == Selected_BUCode).ToList();

            string searchString = terms.LastOrDefault().ToString().Trim();

            var result = lstAcq_Deal.Where(x => x.Agreement_No.ToLower().Contains(searchString.ToLower()) && !terms.ToString().ToLower().Contains(x.Agreement_No.ToLower()))
                .Select(i => new { AgreementName = i.Agreement_No, Deal_Code = i.Acq_Deal_Code }).Distinct().ToList();

            return Json(result);
        }

        public PartialViewResult BindEpisodicReport(string AcqDealCode, string TitleCode, string BUCode, string Eps_From, string Eps_To, string DealTypeCode, string numberformat)
        {
            string numberResult = numberformat.Split('~')[0];

            ReportParameter[] parm = new ReportParameter[10];
            string TitleCodes = TitleAutosuggest(TitleCode);
            parm[0] = new ReportParameter("DealCode", AcqDealCode);
            parm[1] = new ReportParameter("TitleCode", TitleCodes);
            parm[2] = new ReportParameter("Eps_From", Eps_From);
            parm[3] = new ReportParameter("Eps_To", Eps_To);
            parm[4] = new ReportParameter("BUCode", BUCode);
            parm[5] = new ReportParameter("Deal_Type_Code", DealTypeCode);
            parm[6] = new ReportParameter("NumberFormat", numberResult);
            parm[7] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[8] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[9] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(parm, "Episodic_Cost_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region ---Music Deal List Report---
        public ActionResult MusicDealListReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForMusicDealListReport);
            BindFormatDDL();
            ViewBag.MusicLabel = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Music_Label_Code", "Music_Label_Name").ToList();
            return View();
        }
        public JsonResult PopulateAgreementNumber(string searchPrefix = "")
        {
            dynamic result = "";

            if (!string.IsNullOrEmpty(searchPrefix))
            {
                result = new Music_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Agreement_No.Contains(searchPrefix)).Select(x => new { Text = x.Agreement_No, code = x.Music_Deal_Code });
            }
            return Json(result);
        }
        public PartialViewResult BindMusicDealListReport(string agreementNo, string musicLabelcode, string startDate, string endDate, bool expiredDeal, string dateformat, string numberformat)
        {
            string numberResult = numberformat.Split('~')[0];

            string ExpiredDeal = "";
            if (expiredDeal == true)
            {
                ExpiredDeal = "Y";
            }
            else
            {
                ExpiredDeal = "N";
            }
            ReportParameter[] param = new ReportParameter[10];
            param[0] = new ReportParameter("Agreement_No", agreementNo);
            param[1] = new ReportParameter("MusicLabelCode", musicLabelcode);
            param[2] = new ReportParameter("start_Date", GlobalUtil.MakedateFormat(startDate));
            param[3] = new ReportParameter("End_Date", GlobalUtil.MakedateFormat(endDate));
            param[4] = new ReportParameter("Expired_Deal", ExpiredDeal);
            param[5] = new ReportParameter("DateFormat", dateformat);
            param[6] = new ReportParameter("NumberFormat", numberResult);
            param[7] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            param[8] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            param[9] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());
            ReportViewer rptViewer = BindReport(param, "Music_Deal_List_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion

        #region---------------- Title Amort Report----------------------------------------------------

        public ActionResult Title_Amort_Report()
        {
            return View();
        }

        public JsonResult BindTitle_Amort_List(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();

                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => s.Title_Name.ToUpper().Contains(searchString.ToUpper()) && s.Is_Active == "Y" && s.Acq_Deal_Movie
                                                                          .Any(ADM => ADM.Title.Title_Code == s.Title_Code)).Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();
            }
            return Json(result);

        }
        public PartialViewResult BindTitle_Amort_Report(string titleCodes)
        {
            string title_names = TitleAutosuggest(titleCodes);
            ReportParameter[] parm = new ReportParameter[0];
            ReportViewer rptViewer = BindReport(parm, "Title_Amort_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion-----------------------------------------------------------------------------------

        private ReportViewer BindReport(ReportParameter[] parm, string ReportName, string ErrorMessage = "")
        {
            ReportViewer rptViewer = new ReportViewer();
            try
            {
                rptViewer.ShowParameterPrompts = false;
                ReportCredential(rptViewer);
                rptViewer.ServerReport.ReportPath = string.Empty;
                if (rptViewer.ServerReport.ReportPath == "")
                {
                    UTOFrameWork.FrameworkClasses.ReportSetting objRS = new UTOFrameWork.FrameworkClasses.ReportSetting();
                    rptViewer.ServerReport.ReportPath = objRS.GetReport(ReportName);
                    if (ReportName == "rptIPR_IntDom_Report")
                    {
                        rptViewer.ServerReport.DisplayName = "rptIPR_Report";
                    }
                }
                rptViewer.Visible = true;
                rptViewer.ProcessingMode = ProcessingMode.Remote;
                if (ReportName != "Title_Amort_Report")
                    rptViewer.ServerReport.SetParameters(parm);
                rptViewer.ServerReport.Refresh();
                ErrorMessage = "";
                // return rptViewer;
            }
            catch (Exception ex)
            {
                ErrorMessage = ex.Message;
                // return rptViewer;
            }
            return rptViewer;
        }

        public void ReportCredential(ReportViewer rptViewer)
        {
            var rptCredetialList = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.IsActive == "Y" && w.Parameter_Name.Contains("RPT_")).ToList();

            string ReportingServer = rptCredetialList.Where(x => x.Parameter_Name == "RPT_ReportingServer").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["ReportingServer"];
            string IsCredentialRequired = rptCredetialList.Where(x => x.Parameter_Name == "RPT_IsCredentialRequired").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["IsCredentialRequired"];

            if (IsCredentialRequired.ToUpper() == "TRUE")
            {
                string CredentialPassWord = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserPassWord").Select(x => x.Parameter_Value).FirstOrDefault();// ConfigurationManager.AppSettings["CredentialsUserPassWord"];
                string CredentialUser = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialsUserName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialsUserName"];
                string CredentialdomainName = rptCredetialList.Where(x => x.Parameter_Name == "RPT_CredentialdomainName").Select(x => x.Parameter_Value).FirstOrDefault();//  ConfigurationManager.AppSettings["CredentialdomainName"];
                rptViewer.ServerReport.ReportServerCredentials = new ReportServerCredentials(CredentialUser, CredentialPassWord, CredentialdomainName);
            }

            if (rptViewer.ServerReport.ReportServerUrl.OriginalString == "http://localhost/reportserver")
                rptViewer.ServerReport.ReportServerUrl = new Uri(ReportingServer);
        }
        public string TitleAutosuggest(string Title)
        {
            Title = Title.Trim().Trim('﹐').Trim();
            string title_names = "";
            if (Title != "")
            {
                string[] terms = Title.Split('﹐');
                string[] Title_Codes = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Title_Name)).Select(s => s.Title_Code.ToString()).ToArray();
                title_names = string.Join(", ", Title_Codes);
                if (title_names == "")
                    title_names = "-1";
            }
            return title_names;
        }
        public string ChannelAutosuggest(string ChannelCodes)
        {
            ChannelCodes = ChannelCodes.Trim().Trim('﹐').Trim();
            string channel_names = "";
            if (ChannelCodes != "")
            {
                string[] terms = ChannelCodes.Split('﹐');
                string[] Channel_Code = new Channel_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Channel_Name)).Select(s => s.Channel_Code.ToString()).ToArray();
                channel_names = string.Join(", ", Channel_Code);
            }
            return channel_names;
        }
        public string TalentAutosuggest(string TalentCode)
        {
            TalentCode = TalentCode.Trim().Trim('﹐').Trim();
            string starcast_names = "";
            if (TalentCode != "")
            {
                string[] terms = TalentCode.Split('﹐');
                string[] Talent_Code = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Talent_Name)).Select(s => s.Talent_Code.ToString()).ToArray();
                starcast_names = string.Join(", ", Talent_Code);
            }
            return starcast_names;
        }
        public string MusicLableAutosuggest(string musicList)
        {
            musicList = musicList.Trim().Trim('﹐').Trim();
            string music_label_names = "";
            if (musicList != "")
            {
                string[] terms = musicList.Split('﹐');
                string[] Music_Lable_Codes = new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Music_Label_Name)).Select(s => s.Music_Label_Code.ToString()).ToArray();
                music_label_names = string.Join(", ", Music_Lable_Codes);
            }
            return music_label_names;
        }
        public string UserAutosuggest(string userCode)
        {
            userCode = userCode.Trim().Trim('﹐').Trim();
            string user_names = "";
            if (userCode != "")
            {
                string[] terms = userCode.Split('﹐');
                string[] User_Codes = new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Login_Name)).Select(s => s.Users_Code.ToString()).ToArray();
                user_names = string.Join(", ", User_Codes);
                if (user_names == "")
                    user_names = "-1";

            }
            return user_names;
        }
        public string MusicTitleAutosuggest(string musicTrackCode)
        {
            musicTrackCode = musicTrackCode.Trim().Trim('﹐').Trim();
            string music_track_names = "";
            if (musicTrackCode != "")
            {
                string[] terms = musicTrackCode.Split('﹐');
                string[] Music_Track_Codes = new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.Music_Title_Name)).Select(s => s.Music_Title_Code.ToString()).ToArray();
                music_track_names = string.Join(", ", Music_Track_Codes);
            }
            return music_track_names;
        }
        public void BindFormatDDL()
        {
            ViewBag.DateFormat = new SelectList(new Report_Format_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Format_Type == "D").OrderBy(x => x.Order_By), "Format", "Format").ToList();
            ViewBag.DateTimeFormat = new SelectList(new Report_Format_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Format_Type == "F").OrderBy(x => x.Order_By), "Format", "Format").ToList();
            ViewBag.NumberFormat = new SelectList(new Report_Format_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Format_Type == "N").OrderBy(x => x.Order_By), "Result", "Format").ToList();
            ViewBag.TimeFormat = new SelectList(new Report_Format_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Format_Type == "T").OrderBy(x => x.Order_By), "Format", "Format").ToList();

        }

        #region---------------Title Milestone Report
        public ActionResult TitleMilestoneReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeFortitleMilestoneReport);
            //ViewBag.BusinessUnitList = GetBusinessUnitList();
            //string moduleCode = Request.QueryString["modulecode"];
            //ViewBag.Code = moduleCode;
            ViewBag.TalentName = new SelectList(new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(t => t.Talent_Code), "Talent_Code", "Talent_Name").ToList();
            ViewBag.MilestoneNatureName = new SelectList(new Milestone_Nature_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").OrderBy(t => t.Milestone_Nature_Code), "Milestone_Nature_Code", "Milestone_Nature_Name").ToList();

            return View();
        }
        public PartialViewResult BindTitleMilestoneReport(string Title, string TalentName, string MilestonenatureName, string FromDate, string ToDate)
        {
            string title_names = TitleAutosuggest(Title);
            if (title_names == "")
                title_names = " ";
            string Talent_Name = TalentAutosuggest(TalentName);
            if (Talent_Name == "")
                Talent_Name = " ";

            ReportParameter[] parm = new ReportParameter[8];
            parm[0] = new ReportParameter("TitleCode", title_names);
            parm[1] = new ReportParameter("TalentCode", Talent_Name);
            parm[2] = new ReportParameter("MilestoneNatureCode", MilestonenatureName);
            parm[3] = new ReportParameter("StartRange", GlobalUtil.MakedateFormat(FromDate));
            parm[4] = new ReportParameter("EndRange", GlobalUtil.MakedateFormat(ToDate));
            parm[5] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            parm[6] = new ReportParameter("SysLanguageCode", objLoginUser.System_Language_Code.ToString());
            parm[7] = new ReportParameter("Module_Code", objLoginUser.moduleCode.ToString());

            ReportViewer rptViewer = BindReport(parm, "TitleMilestone_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        public JsonResult PopulateTitleForTitleMilestone(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y" && x.Reference_Flag != "T").Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList().Distinct();
            }
            return Json(result);
        }

        public JsonResult PopulateTalentTitleMilestone(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new Talent_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Talent_Name.ToUpper().Contains(searchString.ToUpper()) && x.Is_Active == "Y").Select(x => new { Talent_Name = x.Talent_Name, Talent_Code = x.Talent_Code }).ToList().Distinct();
            }
            return Json(result);
        }
        #endregion

        #region--- Title Details report ---
        public ActionResult TitleDetailsReport()
        {
            return View("~/Views/Reports/TitleDetailsReport.cshtml");
        }
        public JsonResult BindAdvanced_Search_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();

            var lstTalent = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Talent_Name().ToList();
            var lstStarCast = lstTalent.Where(x => x.Role_Code == GlobalParams.Role_code_StarCast);
            var lstDirector = lstTalent.Where(x => x.Role_Code == GlobalParams.RoleCode_Director);
            var lstProducer = lstTalent.Where(x => x.Role_Code == GlobalParams.RoleCode_Producer);

            MultiSelectList lstLanguage = new MultiSelectList(new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Select(i => new { Display_Value = i.Language_Code, Display_Text = i.Language_Name }).ToList(), "Display_Value", "Display_Text");

            var lst_title = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Original_Language_Code != null).Select(x => x.Original_Language_Code).Distinct().ToList();
            var lst_Lang = new Language_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();

            var lstOgLang = (from t1 in lst_title
                             join t2 in lst_Lang on t1.Value equals t2.Language_Code
                             select new { t1.Value, t2.Language_Name }).ToList();

            MultiSelectList lstOrigLang = new MultiSelectList(lstOgLang
               .Select(i => new { Display_Value = i.Value, Display_Text = i.Language_Name }).ToList(), "Display_Value", "Display_Text");


            MultiSelectList lstCountry = new MultiSelectList(new Country_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Select(i => new { Display_Value = i.Country_Code, Display_Text = i.Country_Name }).ToList(), "Display_Value", "Display_Text");
            MultiSelectList lstDealType = new MultiSelectList(new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .Select(i => new { Display_Value = i.Deal_Type_Code, Display_Text = i.Deal_Type_Name }).ToList(), "Display_Value", "Display_Text");
            MultiSelectList lstTStarCast = new MultiSelectList(lstStarCast.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
                "Display_Value", "Display_Text");
            MultiSelectList lstTProducer = new MultiSelectList(lstProducer.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
               "Display_Value", "Display_Text");
            MultiSelectList lstTDirector = new MultiSelectList(lstDirector.Select(i => new { Display_Value = i.Talent_Code, Display_Text = i.Talent_Name }),
                "Display_Value", "Display_Text");
            MultiSelectList lstGenres = new MultiSelectList(new Genre_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
            .Select(i => new { Display_Value = i.Genres_Code, Display_Text = i.Genres_Name }).ToList(), "Display_Value", "Display_Text");


            objJson.Add("lstGenres", lstGenres);
            objJson.Add("lstTProducer", lstTProducer);
            objJson.Add("lstTStarCast", lstTStarCast);
            objJson.Add("lstTDirector", lstTDirector);
            objJson.Add("lstLanguage", lstLanguage);
            objJson.Add("lstOrigLang", lstOrigLang);
            objJson.Add("lstCountry", lstCountry);
            objJson.Add("lstDealType", lstDealType);
            return Json(objJson);
        }

        public PartialViewResult BindTitleDetailsReports(string SrchStarCast = "", string SrchLanguage = "", string SrchYearOfRelease = "", string SrchTitle = "", string SrchDirector = "",
         string SrhDealTypeCode = "", string SrchOrigLang = "", string SrchOrigTitle = "", string SrchProducer = "", string SrchGenres = "", bool ExtendedMetaData = false)
        {
            var TitleList = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").Select(x => new { x.Title_Code, x.Title_Name, x.Original_Title }).ToList();
            string sql = "";

            if (SrchLanguage != "")
                sql += " AND Title_Language_Code IN(" + SrchLanguage + ")";
            if (SrchOrigLang != "")
                sql += " AND Original_Language_Code IN(" + SrchOrigLang + ")";
            if (SrchYearOfRelease != "")
                sql += " AND  Year_Of_Production like " + "'" + SrchYearOfRelease + "%'";
            if (SrchDirector != "")
                sql += " AND T.Title_Code in (select TT.Title_Code from Title_Talent TT where Talent_Code in (" + SrchDirector + ") AND Role_Code = " + GlobalParams.RoleCode_Director + ")";
            if (SrchStarCast != "")
                sql += " AND T.Title_Code in (select TT.Title_Code from Title_Talent TT  where Talent_Code in (" + SrchStarCast + ") AND Role_Code = " + GlobalParams.RoleCode_StarCast + ")";
            if (SrchProducer != "")
                sql += " AND T.Title_Code in (select TT.Title_Code from Title_Talent TT  where Talent_Code in (" + SrchProducer + ") AND Role_Code = " + GlobalParams.Role_code_Producer + ")";
            if (SrchGenres != "")
                sql += "  AND T.Title_code in (select TG.Title_Code from Title_Geners TG where TG.Genres_Code IN (" + SrchGenres + "))";

            string TitleCode = "", OrgTitleCode = "";
            if (SrchTitle != "")
            {
                string[] words = SrchTitle.Split('﹐');
                foreach (string word in words)
                {
                    int? a = TitleList.Where(x => x.Title_Name == word).Select(x => x.Title_Code).FirstOrDefault();
                    if (a != null && a != 0)
                    {
                        TitleCode += a.ToString() + ",";
                    }
                }
                TitleCode = TitleCode.Remove(TitleCode.Length - 1);
            }

            if (SrchOrigTitle != "")
            {
                string[] words = SrchOrigTitle.Split('﹐');
                foreach (string word in words)
                {
                    int? a = TitleList.Where(x => x.Original_Title == word).Select(x => x.Title_Code).FirstOrDefault();
                    if (a != null && a != 0)
                    {
                        OrgTitleCode += a.ToString() + ",";
                    }
                }
                OrgTitleCode = OrgTitleCode.Remove(OrgTitleCode.Length - 1);
            }

            string Entity = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Title_Detail_Report_Visibility").Select(X => X.Parameter_Value.ToString()).FirstOrDefault();
            ReportParameter[] parm = new ReportParameter[17];
            parm[0] = new ReportParameter("DealTypeCode", SrhDealTypeCode == "" ? " " : SrhDealTypeCode);
            parm[1] = new ReportParameter("TitleName", SrchTitle == "" ? " " : SrchTitle.Replace('﹐', ','));
            parm[2] = new ReportParameter("OriginalTitleName", SrchOrigTitle == "" ? " " : SrchOrigTitle.Replace('﹐', ','));
            parm[3] = new ReportParameter("AdvanceSearch", sql == "" ? " " : sql);
            parm[4] = new ReportParameter("Extended_Meta_Data", Convert.ToString(ExtendedMetaData == true ? "Y" : "N"));

            parm[5] = new ReportParameter("Title_Code", TitleCode == "" ? " " : TitleCode);
            parm[6] = new ReportParameter("Deal_Type_Code", SrhDealTypeCode == "" ? " " : SrhDealTypeCode);
            parm[7] = new ReportParameter("Title_Language_Code", SrchLanguage == "" ? " " : SrchLanguage);
            parm[8] = new ReportParameter("KeyStarcastCode", SrchStarCast == "" ? " " : SrchStarCast);
            parm[9] = new ReportParameter("Director_Code", SrchDirector == "" ? " " : SrchDirector);
            parm[10] = new ReportParameter("Producer_Code", SrchProducer == "" ? " " : SrchProducer);
            parm[11] = new ReportParameter("Genres_Code", SrchGenres == "" ? " " : SrchGenres);
            parm[12] = new ReportParameter("OriginalTitle_Code", OrgTitleCode == "" ? " " : OrgTitleCode);
            parm[13] = new ReportParameter("OriginalLanguage_Code", SrchOrigLang == "" ? " " : SrchOrigLang);
            parm[14] = new ReportParameter("User_Code", objLoginUser.Users_Code.ToString());
            parm[15] = new ReportParameter("YearofRelease", SrchYearOfRelease == "" ? " " : SrchYearOfRelease);
            parm[16] = new ReportParameter("RightsU_Entities", Entity);


            ReportViewer rptViewer = BindReport(parm, "Title_Details_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        #endregion
        #region--- Project Milestone Report
        public ActionResult ProjectMilestoneReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeFortitleMilestoneReport);
            ViewBag.MilestoneNatureName = new SelectList(new Milestone_Nature_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y")
                .OrderBy(t => t.Milestone_Nature_Code), "Milestone_Nature_Code", "Milestone_Nature_Name").ToList();
            return View();
        }
        public string ProjectAutosuggest(string Project)
        {
            Project = Project.Trim().Trim('﹐').Trim();
            string Project_names = "";
            if (Project != "")
            {
                string[] terms = Project.Split('﹐');
                string[] Project_Codes = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName).SearchFor(x => terms.Contains(x.ProjectName))
                    .Select(s => s.ProjectMilestoneCode.ToString()).ToArray();
                Project_names = string.Join(", ", Project_Codes);
                if (Project_names == "")
                    Project_names = "-1";
            }
            return Project_names;
        }
        public PartialViewResult BindProjectMilestoneReport(string Project, string MilestoneNatureCode, string ExpiryDays)
        {
            string Project_names = ProjectAutosuggest(Project);
            if (Project_names == "")
                Project_names = " ";

            ReportParameter[] parm = new ReportParameter[3];
            parm[0] = new ReportParameter("ProjectMilestoneCodes", Project_names);
            parm[1] = new ReportParameter("MilestoneNatureCode", MilestoneNatureCode);
            parm[2] = new ReportParameter("ExpiryInDay", ExpiryDays);

            ReportViewer rptViewer = BindReport(parm, "ProjectMilestone_Report");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }
        public JsonResult PopulateProjectForTitleMilestone(string keyword = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();
                result = new ProjectMilestone_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.ProjectName.ToUpper().Contains(searchString.ToUpper()))
                    .Select(x => new { ProjectName = x.ProjectName, ProjectMilestoneCode = x.ProjectMilestoneCode }).ToList().Distinct();
            }
            return Json(result);
        }
        #endregion

        #region --- Deal Status Report----

        public ActionResult DealStatusReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDealListReport);
            BindFormatDDL();
            ViewBag.UserModuleRights = GetUserModuleRights();
            string rightsForAllBU = GetUserModuleRights();
            List<SelectListItem> lstDeal = new List<SelectListItem>();
            lstDeal.Add(new SelectListItem { Text = "Acquisition Deals", Value = GlobalParams.ModuleCodeForAcqDeal.ToString() });
            lstDeal.Add(new SelectListItem { Text = "Syndication Deals", Value = GlobalParams.ModuleCodeForSynDeal.ToString() });
            ViewBag.DealList = lstDeal;

            Title_Service objTS = new Title_Service(objLoginEntity.ConnectionStringName);
            int BU_Code = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Users_Business_Unit.Any(u => u.Users_Code == objLoginUser.Users_Code)).Select(s => s.Business_Unit_Code).FirstOrDefault();
            ViewBag.UserName = new MultiSelectList(new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y"), "Users_Code", "First_Name").ToList();

            ViewBag.status = new SelectList(new Deal_Tag_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Deal_Tag_Code > 0), "Deal_Tag_Code", "Deal_Tag_Description").ToList();
            ViewBag.AcquisitionDeal = new SelectList(new Acq_Deal_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Business_Unit.Users_Business_Unit.All(u => u.Users_Code == objLoginUser.Users_Code)).Distinct()).ToList();

            ViewBag.DealWorkFlowStatus = new SelectList(new Deal_Workflow_Status_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).Select(x => new { x.Deal_Workflow_Status_Name, x.Deal_WorkflowFlag }).Distinct(), "Deal_WorkflowFlag", "Deal_Workflow_Status_Name").ToList();

            if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~") && rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true, true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllBusinessUnit + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(true);
            }
            else if (rightsForAllBU.Contains("~" + GlobalParams.RightCodeForAllRegionalGEC + "~"))
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList(false, true);
            }
            else
            {
                ViewBag.BusinessUnitList = GetBusinessUnitList();
            }
            var AllowDealSegment = ViewBag.AllowDealSegment = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Gen_Deal_Segment").Select(x => x.Parameter_Value).FirstOrDefault();
            var IsAllowTypeOfFilm = ViewBag.IsAllowTypeOfFilm = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AcqSyn_Type_Of_Film").Select(x => x.Parameter_Value).FirstOrDefault();

            if (AllowDealSegment == "Y")
            {
                ViewBag.Deal_Segment = new SelectList(new Deal_Segment_Service(objLoginEntity.ConnectionStringName).SearchFor(x => true).ToList(), "Deal_Segment_Code", "Deal_Segment_Name");
            }

            if (IsAllowTypeOfFilm == "Y")
            {
                ViewBag.TypeOfFilm = new SelectList(new Extended_Columns_Value_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Columns_Code == 2).Select(x => new { Columns_Value_Code = x.Columns_Value_Code, Columns_Value = x.Columns_Value }).ToList(), "Columns_Value_Code", "Columns_Value");
            }
            var Is_AllowMultiBUacqdealreport = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "Is_AllowMultiBUacqdealreport").Select(x => x.Parameter_Value).FirstOrDefault();
            ViewBag.Is_AllowMultiBUacqdealreport = Is_AllowMultiBUacqdealreport;
            return View();
        }

        public PartialViewResult BindDealStatusReport(string dealCode, string businessUnitcode, string dateformat, string acqDealCode, string userName, string startDate, string endDate, bool isExpiredDeal, string dealWorkflowStatus)
        {
            ReportViewer rptViewer = new ReportViewer();
            try
            {
                string strShowExpiredDeals = (isExpiredDeal == true) ? "Y" : "N";
                if (acqDealCode == "")
                    acqDealCode = "0";

                if (dealCode == GlobalParams.ModuleCodeForAcqDeal.ToString())
                {
                    ReportParameter[] parm = new ReportParameter[10];
                    parm[0] = new ReportParameter("ModuleCode", dealCode);
                    parm[1] = new ReportParameter("BusinessUnitcode", businessUnitcode);
                    parm[2] = new ReportParameter("UserCode", userName);
                    parm[3] = new ReportParameter("AgreementNo", acqDealCode);
                    parm[4] = new ReportParameter("StartDate", startDate);
                    parm[5] = new ReportParameter("EndDate", endDate);
                    parm[6] = new ReportParameter("Show_Expired", strShowExpiredDeals);
                    parm[7] = new ReportParameter("DateFormat", dateformat);
                    parm[8] = new ReportParameter("Created_By", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
                    parm[9] = new ReportParameter("DealWorkflowStatus", dealWorkflowStatus);
                    rptViewer = BindReport(parm, "rptDealStatusReport");
                }
                else if (dealCode == GlobalParams.ModuleCodeForSynDeal.ToString())
                {
                    ReportParameter[] parm = new ReportParameter[10];
                    parm[0] = new ReportParameter("ModuleCode", dealCode);
                    parm[1] = new ReportParameter("BusinessUnitcode", businessUnitcode);
                    parm[2] = new ReportParameter("UserCode", userName);
                    parm[3] = new ReportParameter("AgreementNo", acqDealCode);
                    parm[4] = new ReportParameter("StartDate", startDate);
                    parm[5] = new ReportParameter("EndDate", endDate);
                    parm[6] = new ReportParameter("Show_Expired", strShowExpiredDeals);
                    parm[7] = new ReportParameter("DateFormat", dateformat);
                    parm[8] = new ReportParameter("Created_By", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
                    parm[9] = new ReportParameter("DealWorkflowStatus", dealWorkflowStatus);
                    rptViewer = BindReport(parm, "rptDealStatusReport");
                }
            }
            catch (Exception e)
            {
                throw e;
            }

            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }

        public JsonResult BindUserDropdown(string businessUnitcode)
        {
            dynamic result = "";
            string[] arr_BUCodes = businessUnitcode.Split(',');


            int[] arrUsers = new Users_Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arr_BUCodes.Contains(x.Business_Unit_Code.ToString())).Select(s => s.Users_Code ?? 0).ToArray();

            result = new MultiSelectList(new User_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && arrUsers.Contains(x.Users_Code)), "Users_Code", "First_Name").ToList();

            return Json(result);
        }

        #endregion

        #region ---Music Availability Report----

        public ActionResult MusicAvailabilityReport()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForAcqDealListReport);
            ViewBag.MusicLabelList = GetMusicLabelList();

            return View();
        }

        public SelectList GetMusicLabelList()
        {
            List<SelectListItem> list = new SelectList(new Music_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Select(i => new { Display_Value = i.Music_Label_Code, Display_Text = i.Music_Label_Name }).ToList().Distinct(), "Display_Value", "Display_Text").ToList();

            return new SelectList(list, "Value", "Text");
        }

        public JsonResult BindTitleForMusicAvailReport(string keyword = "", string TitleType = "", string selectedMusicLabelCode = "")
        {
            dynamic result = "";
            if (!string.IsNullOrEmpty(keyword))
            {
                List<string> terms = keyword.Split('﹐').ToList();
                terms = terms.Select(s => s.Trim()).ToList();
                string searchString = terms.LastOrDefault().ToString().Trim();

                List<string> lstTitleTypeCode = new List<string>();

                if (TitleType == "M")
                {
                    System_Parameter_New Movies_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Movies").FirstOrDefault();
                    lstTitleTypeCode = Movies_system_Parameter.Parameter_Value.Split(',').ToList();
                }
                else
                {
                    System_Parameter_New Show_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Show").FirstOrDefault();
                    lstTitleTypeCode = Show_system_Parameter.Parameter_Value.Split(',').ToList();
                }

                //result = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Title_Name.ToUpper().Contains(searchString.ToUpper()) && x.Music_Label_Code == MusicLabelCode
                //&& lstTitleTypeCode.Any(a => x.Deal_Type_Code.ToString() == a))
                //    .Select(x => new { Title_Name = x.Title_Name, Title_Code = x.Title_Code }).ToList();

                if (!string.IsNullOrEmpty(selectedMusicLabelCode))
                {
                    int MusicLabelCode = Convert.ToInt32(selectedMusicLabelCode);

                    result =
                        new SelectList((from x in new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lstTitleTypeCode.Any(a => x.Deal_Type_Code.ToString() == a) && x.Title_Name.ToUpper().Contains(searchString.ToUpper())).ToList()
                                        join y in new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).ToList()
                                        on x.Title_Code equals y.Title_Code
                                        join z in new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(y => y.Music_Label_Code == MusicLabelCode).ToList()
                                        on y.Music_Title_Code equals z.Music_Title_Code
                                        select new
                                        {
                                            x.Title_Name,
                                            x.Title_Code
                                        }).Distinct(), "Title_Code", "Title_Name").OrderBy(x => x.Text).ToList();
                }
                else
                {
                    result =
                        new SelectList((from x in new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => lstTitleTypeCode.Any(a => x.Deal_Type_Code.ToString() == a) && x.Title_Name.ToUpper().Contains(searchString.ToUpper())).ToList()
                                        join y in new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(y => true).ToList()
                                        on x.Title_Code equals y.Title_Code
                                        select new
                                        {
                                            x.Title_Name,
                                            x.Title_Code
                                        }).Distinct(), "Title_Code", "Title_Name").OrderBy(x => x.Text).ToList();
                }
            }
            return Json(result);
        }

        public JsonResult BindMusicTitleForMusicAvailReport(string keyword = "", string selectedMusicLabelCode = "", string selectedTitleCodes = "")
        {
            dynamic result = "";

            List<string> terms = keyword.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();
            string searchString = terms.LastOrDefault().ToString().Trim();

            if (!string.IsNullOrEmpty(selectedMusicLabelCode) && !string.IsNullOrEmpty(selectedTitleCodes))
            {
                int MusicLabelCode = Convert.ToInt32(selectedMusicLabelCode);
                List<string> lstTitleCodes = selectedTitleCodes.Split(',').ToList();
                lstTitleCodes = lstTitleCodes.Select(s => s.Trim()).Where(x => !string.IsNullOrWhiteSpace(x)).ToList();
                int[] TitleCodes = lstTitleCodes.Select(int.Parse).ToArray();

                result =
                new SelectList((from x in new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => TitleCodes.Contains(x.Title_Code ?? 0) && x.Music_Title_Name.ToUpper().Contains(searchString.ToUpper())).ToList()
                                join y in new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Label_Code == MusicLabelCode).ToList()
                                on x.Music_Title_Code equals y.Music_Title_Code
                                select new
                                {
                                    x.Music_Title_Name,
                                    x.Music_Title_Code
                                }).Distinct(), "Music_Title_Code", "Music_Title_Name").OrderBy(x => x.Text).ToList();
            }
            else if (!string.IsNullOrEmpty(selectedMusicLabelCode) && string.IsNullOrEmpty(selectedTitleCodes))
            {
                int MusicLabelCode = Convert.ToInt32(selectedMusicLabelCode);

                result =
                new SelectList((from x in new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name.ToUpper().Contains(searchString.ToUpper())).ToList()
                                join y in new Music_Title_Label_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Label_Code == MusicLabelCode).ToList()
                                on x.Music_Title_Code equals y.Music_Title_Code
                                select new
                                {
                                    x.Music_Title_Name,
                                    x.Music_Title_Code
                                }).Distinct(), "Music_Title_Code", "Music_Title_Name").OrderBy(x => x.Text).ToList();
            }
            else if (!string.IsNullOrEmpty(selectedTitleCodes) && string.IsNullOrEmpty(selectedMusicLabelCode))
            {
                List<string> lstTitleCodes = selectedTitleCodes.Split(',').ToList();
                lstTitleCodes = lstTitleCodes.Select(s => s.Trim()).Where(x => !string.IsNullOrWhiteSpace(x)).ToList();

                int[] TitleCodes = lstTitleCodes.Select(int.Parse).ToArray();

                result =
                new SelectList((from x in new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => TitleCodes.Contains(x.Title_Code ?? 0) && x.Music_Title_Name.ToUpper().Contains(searchString.ToUpper())).ToList()
                                select new
                                {
                                    x.Music_Title_Name,
                                    x.Music_Title_Code
                                }).Distinct(), "Music_Title_Code", "Music_Title_Name").OrderBy(x => x.Text).ToList();
            }
            else
            {
                result =
                new SelectList((from x in new Music_Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Music_Title_Name.ToUpper().Contains(searchString.ToUpper())).ToList()
                                select new
                                {
                                    x.Music_Title_Name,
                                    x.Music_Title_Code
                                }).Distinct(), "Music_Title_Code", "Music_Title_Name").OrderBy(x => x.Text).ToList();
            }

            return Json(result);
        }

        public PartialViewResult BindMusicAvailExcelReport(string MusicLabelCode = "", string selectedTitleCodes = "", string selectedMusicTitleCodes = "", string TitleType = "")
        {
            ReportParameter[] parm = new ReportParameter[5];
            parm[0] = new ReportParameter("Music_Label_Code", MusicLabelCode);
            parm[1] = new ReportParameter("Title_Code", selectedTitleCodes);
            parm[2] = new ReportParameter("Music_Title_Code", selectedMusicTitleCodes);
            parm[3] = new ReportParameter("TitleType", TitleType == "M" ? "Movie" : TitleType == "S" ? "Show" : TitleType == "A" ? "Album" : "");
            parm[4] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);
            ReportViewer rptViewer = BindReport(parm, "rptMusicAvailability");
            ViewBag.ReportViewer = rptViewer;
            return PartialView("~/Views/Shared/ReportViewer.cshtml");
        }

        #endregion

        #region--- Audit Log report ---
        public ActionResult AuditLogReport()
        {
            return View("~/Views/Reports/AuditLogReport.cshtml");
        }
        public JsonResult BindAuditLog_Search_Controls()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();

            MultiSelectList lstMasterList = new MultiSelectList(new System_Module_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && (x.Parent_Module_Code == 1 || x.Parent_Module_Code == 58 || x.Parent_Module_Code == 61 || x.Parent_Module_Code == 62 || x.Parent_Module_Code == 63 || x.Parent_Module_Code == 22) && x.Module_Code != 61)
                .Select(i => new { Display_Value = i.Module_Code, Display_Text = i.Module_Name }).ToList(), "Display_Value", "Display_Text");
            MultiSelectList lstUsers = new MultiSelectList(new User_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true)
                .Select(i => new { Display_Value = i.Users_Code, Display_Text = i.Login_Name }).ToList(), "Display_Value", "Display_Text");

            var itemOrderBy = new List<DDLEnumData>();
            foreach (String value in Enum.GetNames(typeof(order)))
            {
                itemOrderBy.Add(new DDLEnumData
                {
                    Text = value,
                    Value = value
                });
            }

            MultiSelectList lstOrderByList = new MultiSelectList(itemOrderBy.Select(i => new { Display_Value = i.Value, Display_Text = i.Text }).ToList(), "Display_Value", "Display_Text");

            Dictionary<string, string> listActionType = new Dictionary<string, string>();
            listActionType.Add("Create", "C");
            listActionType.Add("Delete", "X");
            listActionType.Add("Update", "U");
            listActionType.Add("Active", "A");
            listActionType.Add("Deactive", "D");

            MultiSelectList lstActionType = new MultiSelectList(listActionType.Select(i => new { Display_Value = i.Value, Display_Text = i.Key }).ToList(), "Display_Value", "Display_Text");

            objJson.Add("lstMasterList", lstMasterList);
            objJson.Add("lstUsers", lstUsers);
            objJson.Add("lstActionType", lstActionType);
            objJson.Add("lstOrderByList", lstOrderByList);

            return Json(objJson);
        }
        public JsonResult BindAuditLogDetailsReports(string SrchMaster = "", string SrchUsers = "", string SrchLog = "", string SrchStartDate = "", string SrchEndDate = "", string SrchActionType = "", string SrchOrderBy = "asc", int pageNo = 1, int recordPerPage = 10, string sortType = "T")
        {
            string result = "", ret = "", ErrMsg = "";
            int PageNo = 1, TotalRecord = 0;
            int requestFrom = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(SrchStartDate));
            int requestTo = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().CalculateSeconds(Convert.ToDateTime(SrchEndDate).Date.AddDays(1));
            int moduleCode = Convert.ToInt32(SrchMaster), size = recordPerPage, page = pageNo;
            string searchValue = SrchLog, user = SrchUsers, userAction = SrchActionType, includePrevAuditVesion = "", AuthKey = "", OrderBy = "asc";

            if (SrchOrderBy != "")
                OrderBy = SrchOrderBy;

            var LogData = DependencyResolver.Current.GetService<RightsU_Plus.Controllers.GlobalController>().GetAuditLogAPI(OrderBy, Convert.ToString(sort.IntCode), requestFrom, requestTo, moduleCode, size, page, searchValue, user, userAction, includePrevAuditVesion = "", AuthKey = "");

            var LogDetail = JsonConvert.DeserializeObject<JsonData>(LogData);

            if (Convert.ToString(LogDetail.ErrorMessage) == "Success")
            {
                var temp = JsonConvert.DeserializeObject<AuditLogReturn>(Convert.ToString(LogDetail.Data));
                if (temp.auditData.Count > 0)
                {
                    foreach (var item in temp.auditData)
                    {
                        result = result + item + ",";
                    }

                    if (result.Length > 0)
                    {
                        result = result.Remove(result.Length - 1);
                        ret = "[" + result.Replace("\r\n", "") + "]";
                    }
                }
                else
                {
                    ret = "";
                }

                PageNo = temp.paging.page;
                TotalRecord = Convert.ToInt32(temp.paging.total);
                ErrMsg = "Success";
            }
            else
            {
                ErrMsg = "Error";
            }

            var obj = new
            {
                Record_Count = TotalRecord,
                Page_No = PageNo,
                auditData = ret,
                ErrorMessage = ErrMsg
            };

            return Json(obj);
        }

        #endregion

        public string TypeWiseTitleAutosuggest(string Title, int DealTypeCode)
        {
            Title = Title.Trim().Trim('﹐').Trim();
            string title_names = "";
            if (Title != "")
            {
                string[] terms = Title.Split('﹐');
                string[] Title_Codes = new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => (terms.Contains(x.Title_Name)) && x.Deal_Type_Code == DealTypeCode).Select(s => s.Title_Code.ToString()).ToArray();
                title_names = string.Join(", ", Title_Codes);
                if (title_names == "")
                    title_names = "-1";
            }
            return title_names;
        }
    }

    public class DDLEnumData
    {
        public string Text { get; set; }
        public string Value { get; set; }
    }
    public class JsonData
    {
        public string Status { get; set; }
        public string ErrorMessage { get; set; }
        public string Data { get; set; }
    }
}
