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
using System.IO;
using System.Web.UI;
using System.Text;
using System.Web.UI.WebControls;
using System.Data;
using System.Net;

namespace RightsU_Plus.Controllers
{
    public class Title_Objection_ListController : BaseController
    {
        #region --------------- ATTRIBUTES AND PROPERTIES---------------
        public CommonUtil objCommonUtil = new CommonUtil();
        public Title_Objection_List_Search Title_Objection_List_Search
        {
            get { return (Title_Objection_List_Search)Session["obj_Title_Objection_List_Search"]; }
            set { Session["obj_Title_Objection_List_Search"] = value; }
        }

        private List<Title_Licensor> lstTitle_Licensor
        {
            get
            {
                if (Session["lstTitle_Licensor"] == null)
                    Session["lstTitle_Licensor"] = new List<Title_Licensor>();
                return (List<Title_Licensor>)Session["lstTitle_Licensor"];
            }
            set { Session["lstTitle_Licensor"] = value; }
        }
        public bool isLocked
        {
            get;
            set;
        }
        string Err_filename = "WebPage_Log.txt";
        #endregion

        #region---------------Index & Bind-------------
        public ActionResult Index(string Message = "", string ReleaseRecord = "")
        {
            CommonUtil.WriteErrorLog("Index method of Title_Objection_ListController is executing", Err_filename);

            string IsMenu = "";
            Dictionary<string, string> obj_Dic_Layout = new Dictionary<string, string>();
            if (TempData["QS_LayOut"] != null)
            {
                CommonUtil.WriteErrorLog("Condition 1 executing", Err_filename);
                obj_Dic_Layout = TempData["QS_LayOut"] as Dictionary<string, string>;
                IsMenu = obj_Dic_Layout["IsMenu"];
                TempData.Keep("QS_LayOut");
                CommonUtil.WriteErrorLog("Condition 1 executed", Err_filename);
            }

            if (IsMenu == "Y")
            {
                CommonUtil.WriteErrorLog("Condition 2 executing", Err_filename);
                if (Session["obj_Syn_List_Search"] != null)
                    Session["obj_Syn_List_Search"] = null;
                Reset_Srch_Criteria();
                CommonUtil.WriteErrorLog("Condition 2 executed", Err_filename);
            }
            else
            {
                CommonUtil.WriteErrorLog("Condition 3 executing", Err_filename);
                if (Title_Objection_List_Search == null)
                    Title_Objection_List_Search = new Title_Objection_List_Search();
                ViewBag.isAdvanced = Title_Objection_List_Search.isAdvanced;
                ViewBag.DealNo_Search = Title_Objection_List_Search.DealNo_Search;
                ViewBag.Search = Title_Objection_List_Search.Common_Search;

                CommonUtil.WriteErrorLog(" Condition 3 executed", Err_filename);
            }

            CommonUtil.WriteErrorLog("USP_MODULE_RIGHTS executing", Err_filename);
            List<string> addRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForTitleObjection), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            CommonUtil.WriteErrorLog("USP_MODULE_RIGHTS executed", Err_filename);
            bool srchaddRights = false;
            if (addRights.FirstOrDefault() != null)
                srchaddRights = addRights.FirstOrDefault().Contains("~" + Convert.ToString(GlobalParams.RightCodeForAdd) + "~");
            ViewBag.AddVisibility = srchaddRights;
            ViewBag.UserSecurityCode = objLoginUser.Security_Group_Code;
            Title_Objection_List_Search.PageNo = 1;
            Dictionary<string, string> obj_Dic = new Dictionary<string, string>();
            if (TempData[GlobalParams.Cancel_From_Deal] != null)
            {
                obj_Dic = TempData[GlobalParams.Cancel_From_Deal] as Dictionary<string, string>;
                Title_Objection_List_Search.PageNo = Convert.ToInt32(obj_Dic["Page_No"] != null ? obj_Dic["Page_No"].ToString() : "1");
            }
            //ViewBag.Workflow_List = BindWorkflowStatus();
            ViewBag.PageNo = Title_Objection_List_Search.PageNo - 1;
            ViewBag.ReleaseRecord = ReleaseRecord;
            Session["FileName"] = "";
            Session["FileName"] = "Acq_General";

            CommonUtil.WriteErrorLog("Index method of Title_Objection_ListController has been executed", Err_filename);
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/Title_Objection_List/Index.cshtml");
        }
        [HttpPost]
        public PartialViewResult PartialDealList(int Page,string Type, string commonSearch, string isTAdvanced, string strDealNo = "", string strTitleObjectionType = "", string strTitleObjectionStatus = "", string strTitles = "", string strLicensor = "", string strShowAll = "N", string ClearSession = "N")
         {
            string[] arrTitleName = strTitles.Split('﹐');
            //Type = string.Join(",", Type);
            string sstrTitles = string.Join(",", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrTitleName.Contains(x.Title_Name)).Select(y => y.Title_Code).ToList());
            CommonUtil.WriteErrorLog("BindGridView() method of Title_Objection_ListController is executing", Err_filename);
            IEnumerable<RightsU_Entities.USP_Title_Objection_Adv_List_Result> objList = BindGridView(commonSearch, Type, isTAdvanced, strDealNo, strTitleObjectionType, strTitleObjectionStatus, strTitles, strLicensor, strShowAll, Page, ClearSession);
            CommonUtil.WriteErrorLog("BindGridView() method if Title_Objection_ListController has been executed", Err_filename);
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/Title_Objection_List/_List_Title_Objection.cshtml", objList);
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForTitleObjection), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }
        public IEnumerable<RightsU_Entities.USP_Title_Objection_Adv_List_Result> BindGridView(string commonSearch = "",string Type = "", string isTAdvanced = "N", string strDealNo = "", string strTitleObjectionType = "",  string strTitleObjectionStatus = "", string strTitles = "", string strLicensor = "", string strShowAll = "N", int Page = 0, string ClearSession = "N")
        {
            string sql = "";
            if (ClearSession == "Y")
                Reset_Srch_Criteria();
            if (!string.IsNullOrEmpty(isTAdvanced.Trim()))
                Title_Objection_List_Search.isAdvanced = isTAdvanced;
            if (strShowAll == "N")
            {
                Title_Objection_List_Search.Common_Search = !string.IsNullOrEmpty(commonSearch.Trim()) ? commonSearch.Trim().Replace("'", "''") : "";
                if (Title_Objection_List_Search.isAdvanced == "Y")
                {
                    Title_Objection_List_Search.DealNo_Search = !string.IsNullOrEmpty(strDealNo) ? strDealNo.Trim() : "";
                    if (Title_Objection_List_Search.DealNo_Search != "")
                        sql += " and Tm.agreement_no like '%" + Title_Objection_List_Search.DealNo_Search.Trim().Replace("'", "''") + "%'";

                    Title_Objection_List_Search.TitleCodes_Search = !string.IsNullOrEmpty(strTitles) ? strTitles.Trim() : "";
                    if (Title_Objection_List_Search.TitleCodes_Search != "")
                        sql += "AND T.Title_Code IN(" + Title_Objection_List_Search.TitleCodes_Search + ")";

                    Title_Objection_List_Search.VendorCodes_Search = !string.IsNullOrEmpty(strLicensor) ? strLicensor.Trim() : "";
                    if (Title_Objection_List_Search.VendorCodes_Search != "")
                        sql += " AND V.Vendor_Code IN(" + Title_Objection_List_Search.VendorCodes_Search + ")";


                    Title_Objection_List_Search.TitleObjectionStatus_Search = strTitleObjectionStatus != "0" ? strTitleObjectionStatus : "0";
                    if(Title_Objection_List_Search.TitleObjectionStatus_Search != "" && Title_Objection_List_Search.TitleObjectionStatus_Search != "0")
                        sql += "AND TOS.Title_Objection_Status_Code IN(" + Title_Objection_List_Search.TitleObjectionStatus_Search + ")";

                    Title_Objection_List_Search.TitleObjectionType_Search = strTitleObjectionType != "0" ? strTitleObjectionType : "0";
                    if (Title_Objection_List_Search.TitleObjectionType_Search != "" && Title_Objection_List_Search.TitleObjectionType_Search != "0")
                        sql += "AND Objection_Type_Code IN(" + Title_Objection_List_Search.TitleObjectionType_Search + ")";
                   
                }
            }
            Title_Objection_List_Search.PageNo = Page + 1;
            int pageSize = 10;
            int RecordCount = 0;
            string isPaging = "Y";
            string orderByCndition = "Title_Objection_Code desc";
            CommonUtil.WriteErrorLog("USP_List_Acq is executing", Err_filename);
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            IEnumerable<RightsU_Entities.USP_Title_Objection_Adv_List_Result> objList = new List<RightsU_Entities.USP_Title_Objection_Adv_List_Result>();
            objList = new USP_Service(objLoginEntity.ConnectionStringName).USP_Title_Objection_Adv_List(sql, Type,Title_Objection_List_Search.PageNo, orderByCndition, isPaging, pageSize, objLoginUser.Users_Code, commonSearch, objRecordCount).ToList();

            CommonUtil.WriteErrorLog("USP_Title_Objection_Adv_List has been executed", Err_filename);
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            ViewBag.RecordCount = RecordCount;
            ViewBag.PageNo = Title_Objection_List_Search.PageNo;
            return objList;
        }
        #endregion

        #region -------------------- MAINTAIN SEARCH CRITERIA --------------------
        public JsonResult BindAdvanced_Search_Controls(bool Is_Bind_Control,string Type, string strTitles = "")
        {
            Dictionary<object, object> obj_Dictionary = new Dictionary<object, object>();
            Set_Srch_Criteria();
            List<USP_Get_Acq_PreReq_Result> obj_USP_Get_PreReq_Result = new List<USP_Get_Acq_PreReq_Result>();
            obj_USP_Get_PreReq_Result = BindAllDropDowns();
            string[] arrTitleName = Title_Objection_List_Search.TitleCodes_Search.Split(',');
            string strTitleNames = string.Join("﹐", new Title_Service(objLoginEntity.ConnectionStringName).SearchFor(x => arrTitleName.Contains(x.Title_Code.ToString())).Select(y => y.Title_Name).ToList());
            obj_Dictionary.Add("USP_Result", obj_USP_Get_PreReq_Result);
            

            if (Title_Objection_List_Search != null)
            {
                obj_Dictionary.Add("strTitleNames", strTitleNames);
                obj_Dictionary.Add("Title_Objection_List_Search", Title_Objection_List_Search);

            }
            return Json(obj_Dictionary);
        }
        private void Set_Srch_Criteria()
        {
            ViewBag.DealType_Search = Title_Objection_List_Search.TitleObjectionType_Search;
            ViewBag.Status_Search = Title_Objection_List_Search.Status_Search;
            ViewBag.WorkFlowStatus_Search = Title_Objection_List_Search.TitleObjectionStatus_Search;
            ViewBag.TitleCodes_Search = Title_Objection_List_Search.TitleCodes_Search;
            ViewBag.ProducerCodes_Search = Title_Objection_List_Search.VendorCodes_Search;
            ViewBag.PageNo = Title_Objection_List_Search.PageNo;
        }
        private void Reset_Srch_Criteria()
        {
            Title_Objection_List_Search = new Title_Objection_List_Search();
            Title_Objection_List_Search.Common_Search = "";
            Title_Objection_List_Search.DealNo_Search = "";
            Title_Objection_List_Search.TitleCodes_Search = "";
            Title_Objection_List_Search.VendorCodes_Search = "";
            Title_Objection_List_Search.Status_Search = "0";
            Title_Objection_List_Search.isAdvanced = "N";
            Title_Objection_List_Search.TitleObjectionType_Search = "0";
            Title_Objection_List_Search.PageNo = 1;
        }

        #endregion

        #region --------------- BUTTON EVENTS ---------------
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

        #region ---------------BIND DROPDOWNS---------------
        private List<USP_Get_Acq_PreReq_Result> BindAllDropDowns()
        {
            if(Title_Objection_List_Search.TitleObjectionType_Search == "")
            {
                Title_Objection_List_Search.TitleObjectionType_Search = "0";
            }
            List<USP_Get_Acq_PreReq_Result> obj_USP_Get_PreReq_Result = new USP_Service(objLoginEntity.ConnectionStringName).USP_Get_Acq_PreReq("OBT,OBS,TOV,TOB", "LST", objLoginUser.Users_Code, 0, Convert.ToInt32(Title_Objection_List_Search.TitleObjectionType_Search), Title_Objection_List_Search.BUCodes_Search).ToList();
            return obj_USP_Get_PreReq_Result;
        }

        #endregion
    }
}
