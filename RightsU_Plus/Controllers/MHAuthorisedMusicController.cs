using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using RightsU_Entities;
using RightsU_BLL;
using UTOFrameWork.FrameworkClasses;
using System.Configuration;
using System.IO;
using System.Data.Entity.Core.Objects;
using Microsoft.Reporting.WebForms;

namespace RightsU_Plus.Controllers
{
    public class MHAuthorisedMusicController : BaseController
    {
        ReportViewer ReportViewer1;
        private List<RightsU_Entities.USPMHRequisitionList_Result> lst
        {
            get
            {
                if (Session["lstAuthorisedMusic"] == null)
                    Session["lstAuthorisedMusic"] = new List<RightsU_Entities.USPMHRequisitionList_Result>();
                return (List<RightsU_Entities.USPMHRequisitionList_Result>)Session["lstAuthorisedMusic"];
            }
            set { Session["lstAuthorisedMusic"] = value; }
        }
        private AuthorisedMusic_Search objPage_Properties
        {
            get
            {
                if (Session["AuthorisedMusic_Search_Page_Properties"] == null)
                    Session["AuthorisedMusic_Search_Page_Properties"] = new AuthorisedMusic_Search();
                return (AuthorisedMusic_Search)Session["AuthorisedMusic_Search_Page_Properties"];
            }
            set { Session["AuthorisedMusic_Search_Page_Properties"] = value; }
        }
       
        public ActionResult Index()
        {         
            string moduleCode = GlobalParams.ModuleCodeForAuthorisedMusic.ToString();
            ViewBag.UserModuleRights = GetUserModuleRights();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();

            string strBUCodes = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "BusinessUnitCodesForMHDashboard").Select(x => x.Parameter_Value).FirstOrDefault();
            string[] arrBUCodes = strBUCodes.Split(',');
            List<RightsU_Entities.Business_Unit> lstBU = new Business_Unit_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
            List<RightsU_Entities.Business_Unit> lstBU1 = lstBU.Where(x => (arrBUCodes.Contains(x.Business_Unit_Code.ToString()))).ToList();
            ViewBag.Business_Unit_Code_All = string.Join(",", lstBU.Select(s => s.Business_Unit_Code).ToArray());
            ViewBag.BU = new SelectList(lstBU1, "Business_Unit_Code", "Business_Unit_Name", 0);

            string strDealTypeCodes = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Parameter_Name == "DealTypeCodesForMHDashboard").Select(x => x.Parameter_Value).FirstOrDefault();
            string[] arrDealTypeCodes = strDealTypeCodes.Split(',');
            List<RightsU_Entities.Deal_Type> lstDealType = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y").ToList();
            List<RightsU_Entities.Deal_Type> lstDealType1 = new Deal_Type_Service(objLoginEntity.ConnectionStringName).SearchFor(x => (arrDealTypeCodes.Contains(x.Deal_Type_Code.ToString()))).ToList();
            ViewBag.Deal_Type_Codes_All = string.Join(",", lstDealType.Select(s => s.Deal_Type_Code).ToArray());
            ViewBag.ShowType = new SelectList(lstDealType1, "Deal_type_Code", "Deal_Type_Name");
            return View();
        }
        public PartialViewResult BindAuthorisedMusicReport(string prodHouseCode = "", string statusCode = "", string usersCodes = "", string requestId = "", string fromDate = "", string toDate = "", string BUCode = "", string DealTypeCode = "", int pageNo = 1, int recordPerPage = 10)
        {
            int RecordCount = Convert.ToInt32(ViewBag.RecordCnt);
            usersCodes = usersCodes.Replace('﹐', ',');
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            lst = new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequisitionList(prodHouseCode, "", 1, fromDate, toDate, statusCode, "", BUCode, DealTypeCode, pageNo, recordPerPage, usersCodes, requestId, objRecordCount).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
            }
            lst = new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequisitionList(prodHouseCode, "", 1, fromDate, toDate, statusCode, "", BUCode, DealTypeCode, pageNo, recordPerPage, usersCodes, requestId, objRecordCount).ToList();
            ViewBag.PageSize = recordPerPage;
            ViewBag.RecordCnt = RecordCount;
            ViewBag.PageNumber = pageNo;
            return PartialView("~/Views/MHAuthorisedMusic/_AuthorisedMusicReport.cshtml", lst);
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
        public JsonResult GetUsersName(string Searched_User)
        {
            List<string> terms = Searched_User.Split('﹐').ToList();
            terms = terms.Select(s => s.Trim()).ToList();

            //Extract the term to be searched from the list
            string searchString = terms.LastOrDefault().ToString().Trim();
            
            var result = new MHUser_Service(objLoginEntity.ConnectionStringName)
                          .SearchFor(x => x.User.Login_Name.ToUpper().Contains(searchString.ToUpper()))
                          .Select(R => new { Mapping_Name = R.User.Login_Name, Mapping_Code = R.User.Login_Name }).Distinct().ToList();

            return Json(result);
        }
        public JsonResult BindSearch()
        {
            Dictionary<string, object> objJson = new Dictionary<string, object>();

            List<SelectListItem> lstVendor = new SelectList(new Vendor_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.Is_Active == "Y" && x.Vendor_Role.Any(s => s.Role_Code == 9)), "Vendor_Code", "Vendor_Name", 0).ToList();
            List<SelectListItem> lstStatus = new SelectList(new MHRequestStatu_Service(objLoginEntity.ConnectionStringName).SearchFor(x => x.RequestStatusName != "")
               , "MHRequestStatusCode", "RequestStatusName", 0).ToList();

            lstVendor.Insert(0, new SelectListItem() { Value = "", Text = "Please Select" });
            lstStatus.Insert(0, new SelectListItem() { Value = "", Text = "Please Select" });

            objJson.Add("ddlVendor", lstVendor);
            objJson.Add("ddlStatus", lstStatus);

            objJson.Add("objPage_Properties", objPage_Properties);
            return Json(objJson);
        }
        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForAuthorisedMusic), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
        }

        public void ExportToExcel(string prodHouseCode = "", string statusCode = "", string usersCodes = "", string requestId = "", string fromDate = "", string toDate = "", string businessUnitCode = "", string dealTypeCode = "", int pageNo = 1, int recordPerPage = 10)
        {
            int RecordCount = Convert.ToInt32(ViewBag.RecordCnt);
            usersCodes = usersCodes.Replace('﹐', ',');
            ObjectParameter objRecordCount = new ObjectParameter("RecordCount", RecordCount);
            List<RightsU_Entities.USPMHRequisitionList_Result>  lst1 = new USP_Service(objLoginEntity.ConnectionStringName).
                USPMHRequisitionList(prodHouseCode, "", 1, fromDate, toDate, statusCode, "", businessUnitCode, dealTypeCode, pageNo, recordPerPage, usersCodes, requestId, objRecordCount).ToList();
            RecordCount = Convert.ToInt32(objRecordCount.Value);
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
            }
            //new USP_Service(objLoginEntity.ConnectionStringName).USPMHRequisitionList(prodHouseCode, "", 1, 
            //    fromDate, toDate, statusCode, "", pageNo, recordPerPage, usersCodes, requestId, objRecordCount).ToList();

            ReportViewer1 = new ReportViewer();
           
            string extension;
            string encoding;
            string mimeType;
            string[] streams;
            Warning[] warnings;
            ReportParameter[] parm = new ReportParameter[15];

            parm[0] = new ReportParameter("ProductionHouseCode", string.IsNullOrEmpty(prodHouseCode) ? " " : prodHouseCode);
            parm[1] = new ReportParameter("MusicLabel", " ");
            parm[2] = new ReportParameter("MHRequestTypeCode", "1");
            parm[3] = new ReportParameter("FromDate", string.IsNullOrEmpty(fromDate) ? " " : fromDate);
            parm[4] = new ReportParameter("ToDate", string.IsNullOrEmpty(toDate) ? " " : toDate);
            parm[5] = new ReportParameter("StatusCode", string.IsNullOrEmpty(statusCode) ? " " : statusCode);
            parm[6] = new ReportParameter("TitleCode", " ");
            parm[7] = new ReportParameter("PageNo", Convert.ToString(pageNo));
            parm[8] = new ReportParameter("PageSize", Convert.ToString(RecordCount)); 
            parm[9] = new ReportParameter("UsersCode", string.IsNullOrEmpty(usersCodes) ? " " : usersCodes);
            parm[10] = new ReportParameter("RequestId", string.IsNullOrEmpty(requestId) ? " " : requestId);
            parm[11] = new ReportParameter("RecordCount", "0");
            parm[12] = new ReportParameter("MHProduction_House_Code", string.IsNullOrEmpty(prodHouseCode) ? " " : prodHouseCode);
            parm[13] = new ReportParameter("MHStatus_Code", string.IsNullOrEmpty(statusCode) ? " " : statusCode);
            parm[14] = new ReportParameter("CreatedBy", objLoginUser.First_Name + " " + objLoginUser.Last_Name);

            ReportCredential();
            ReportViewer1.ServerReport.ReportPath = string.Empty;
            if (ReportViewer1.ServerReport.ReportPath == "")
            {
                ReportSetting objRS = new ReportSetting();
                ReportViewer1.ServerReport.ReportPath = objRS.GetReport("rptMHRequisitionList");
            }
            ReportViewer1.ServerReport.SetParameters(parm);
            Byte[] buffer = ReportViewer1.ServerReport.Render("Excel", null, out extension, out encoding, out mimeType, out streams, out warnings);
            Response.Clear();
            Response.ContentType = "application/excel";
            Response.AddHeader("Content-disposition", "filename=MHAuthorisedMusic.xls");
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
    }
    public class AuthorisedMusic_Search
    {
        public string VendorCodes_Search { get; set; }
        public string StatusCode_Search { get; set; }
    }
}
