using RightsU_Dapper.BLL.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
//using RightsU_BLL;
//using RightsU_Dapper.Entity;
using UTOFrameWork.FrameworkClasses;
namespace RightsU_Plus.Controllers
{
    public class SAP_WBSController : BaseController
    {
        private readonly USP_MODULE_RIGHTS_Service objUSP_MODULE_RIGHTS_Service = new USP_MODULE_RIGHTS_Service();
        private readonly SAP_WBS_Service objSAPWBSService = new SAP_WBS_Service();

        
        #region --Properties--
        private List<RightsU_Dapper.Entity.SAP_WBS> lstSAP_WBS
        {
            get
            {
                if (Session["lstSAP_WBS"] == null)
                    Session["lstSAP_WBS"] = new List<RightsU_Dapper.Entity.SAP_WBS>();
                return (List<RightsU_Dapper.Entity.SAP_WBS>)Session["lstSAP_WBS"];
            }
            set { Session["lstSAP_WBS"] = value; }
        }

        private List<RightsU_Dapper.Entity.SAP_WBS> lstSAP_WBS_Searched
        {
            get
            {
                if (Session["lstSAP_WBS_Searched"] == null)
                    Session["lstSAP_WBS_Searched"] = new List<RightsU_Dapper.Entity.SAP_WBS>();
                return (List<RightsU_Dapper.Entity.SAP_WBS>)Session["lstSAP_WBS_Searched"];
            }
            set { Session["lstSAP_WBS_Searched"] = value; }
        }
        #endregion
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForSAP_WBS);
            string moduleCode = GlobalParams.ModuleCodeForSAP_WBS.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = objLoginUser.System_Language_Code.ToString();
            lstSAP_WBS_Searched = lstSAP_WBS = objSAPWBSService.GetAll().ToList();
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            return View("~/Views/SAP_WBS/Index.cshtml");
        }
        public PartialViewResult BindSAP_WBSList(int pageNo, int recordPerPage, int sapWbsCode, string SortType = "")
        {
            ViewBag.SAP_WBS_Code = sapWbsCode;
            List<RightsU_Dapper.Entity.SAP_WBS> lst = new List<RightsU_Dapper.Entity.SAP_WBS>();
            int RecordCount = 0;
            RecordCount = lstSAP_WBS_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (SortType == "T")
                    lst = lstSAP_WBS_Searched.OrderByDescending(x=>x.Insert_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (SortType == "NA")
                    lst = lstSAP_WBS_Searched.OrderBy(x => x.WBS_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstSAP_WBS_Searched.OrderByDescending(x => x.WBS_Description).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/SAP_WBS/_SAP_WBS_List.cshtml", lst);
        }
        #region --Other Method--
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
        private string GetUserModuleRights()
        {
            string lstRights = objUSP_MODULE_RIGHTS_Service.USP_MODULE_RIGHTS(Convert.ToInt32(UTOFrameWork.FrameworkClasses.GlobalParams.ModuleCodeForSAP_WBS), objLoginUser.Security_Group_Code,objLoginUser.Users_Code).ToString();
            string rights = "";
            if (lstRights != null)
                rights = lstRights;

            return rights;
        }
        public JsonResult SearchSAP_WBS(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstSAP_WBS_Searched = lstSAP_WBS
                    .Where(w => 
                        w.WBS_Code.ToUpper().Contains(searchText.ToUpper().Trim())
                     || w.WBS_Description.ToUpper().Contains(searchText.ToUpper().Trim())
                     || w.Studio_Vendor.ToUpper().Contains(searchText.ToUpper().Trim())
                     || (w.Short_ID ?? "").ToUpper().Contains(searchText.ToUpper().Trim()) 
                     || w.Status.ToUpper().Contains(searchText.ToUpper().Trim())
                     || w.Sport_Type.ToUpper().Contains(searchText.ToUpper().Trim())
                 ).ToList();
            }
            else
                lstSAP_WBS_Searched = lstSAP_WBS;

            var obj = new
            {
                Record_Count = lstSAP_WBS_Searched.Count
            };
            return Json(obj);
        }

    }
}
