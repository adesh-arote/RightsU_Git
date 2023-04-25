using RightsU_BLL;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using UTOFrameWork.FrameworkClasses;

namespace RightsU_Plus.Controllers
{
    public class LoadSheetController : BaseController
    {
        private List<RightsU_Entities.AL_Load_Sheet> lstAL_LoadSheet
        {
            get
            {
                if (Session["lstAL_Load_Sheet"] == null)
                    Session["lstAL_Load_Sheet"] = new List<RightsU_Entities.AL_Load_Sheet>();
                return (List<RightsU_Entities.AL_Load_Sheet>)Session["lstAL_Load_Sheet"];
            }
            set { Session["lstAL_Load_Sheet"] = value; }
        }

        private List<RightsU_Entities.AL_Load_Sheet> lstAL_Load_Sheet_Searched
        {
            get
            {
                if (Session["lstAL_Load_Sheet_Searched"] == null)
                    Session["lstAL_Load_Sheet_Searched"] = new List<RightsU_Entities.AL_Load_Sheet>();
                return (List<RightsU_Entities.AL_Load_Sheet>)Session["lstAL_Load_Sheet_Searched"];
            }
            set { Session["lstAL_Load_Sheet_Searched"] = value; }
        }

        private RightsU_Entities.AL_Load_Sheet objAL_Load_Sheet
        {
            get
            {
                if (Session["objAL_Load_Sheet"] == null)
                    Session["objAL_Load_Sheet"] = new RightsU_Entities.AL_Load_Sheet();
                return (RightsU_Entities.AL_Load_Sheet)Session["objAL_Load_Sheet"];
            }
            set { Session["objAL_Load_Sheet"] = value; }
        }

        private AL_Load_Sheet_Service objAL_Load_Sheet_Service
        {
            get
            {
                if (Session["objAL_Load_Sheet_Service"] == null)
                    Session["objAL_Load_Sheet_Service"] = new AL_Load_Sheet_Service(objLoginEntity.ConnectionStringName);
                return (AL_Load_Sheet_Service)Session["objAL_Load_Sheet_Service"];
            }
            set { Session["objCurrency_Service"] = value; }
        }

        // GET: LoadSheet
        public ActionResult Index()
        {
            LoadSystemMessage(Convert.ToInt32(objLoginUser.System_Language_Code), GlobalParams.ModuleCodeForCurrency);
            //string moduleCode = Request.QueryString["modulecode"];
            string moduleCode = GlobalParams.ModuleCodeForCurrency.ToString();
            string SysLanguageCode = objLoginUser.System_Language_Code.ToString();
            ViewBag.Code = moduleCode;
            ViewBag.LangCode = SysLanguageCode;
            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = objMessageKey.LatestModified, Value = "T" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameAsc, Value = "NA" });
            lstSort.Add(new SelectListItem { Text = objMessageKey.SortNameDesc, Value = "ND" });
            ViewBag.SortType = lstSort;
            ViewBag.UserModuleRights = GetUserModuleRights();
            lstAL_Load_Sheet_Searched = objAL_Load_Sheet_Service.SearchFor(x => true).ToList();
            return View("~/Views/LoadSheet/Index.cshtml");
        }
        public PartialViewResult AddLoadSheet(int loadSheetCode, string commandName)
        {
           

            
            return PartialView("~/Views/LoadSheet/_AddLoadSheet.cshtml", null);
        }

        public PartialViewResult BindLoadSheetList(int pageNo, int recordPerPage, string sortType)
        {
            List<RightsU_Entities.AL_Load_Sheet> lst = new List<RightsU_Entities.AL_Load_Sheet>();
            int RecordCount = 0;
            RecordCount = lstAL_Load_Sheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstAL_Load_Sheet_Searched.OrderByDescending(o => o.Updated_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstAL_Load_Sheet_Searched.OrderBy(o => o.Load_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstAL_Load_Sheet_Searched.OrderByDescending(o => o.Load_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
            ViewBag.UserModuleRights = GetUserModuleRights();
            return PartialView("~/Views/LoadSheet/_LoadSheetList.cshtml", lst);
        }


        private string GetUserModuleRights()
        {
            List<string> lstRights = new USP_Service(objLoginEntity.ConnectionStringName).USP_MODULE_RIGHTS(Convert.ToInt32(GlobalParams.ModuleCodeForCurrency), objLoginUser.Security_Group_Code, objLoginUser.Users_Code).ToList();
            string rights = "";
            if (lstRights.FirstOrDefault() != null)
                rights = lstRights.FirstOrDefault();

            return rights;
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
    }
}