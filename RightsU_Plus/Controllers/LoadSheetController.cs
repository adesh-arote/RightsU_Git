using RightsU_BLL;
using RightsU_Entities;
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

        List<USPAL_GetLoadsheetList_Result> lstLoadSheet_Searched
        {
            get
            {
                if (Session["lstLoadSheet_Searched"] == null)
                    Session["lstLoadSheet_Searched"] = new List<USPAL_GetLoadsheetList_Result>();
                return (List<USPAL_GetLoadsheetList_Result>)Session["lstLoadSheet_Searched"];
            }
            set
            {
                Session["lstLoadSheet_Searched"] = value;
            }
        }

        List<USPAL_GetBookingsheetDataForLoadsheet_Result> lstBookingsheetDataForLoadsheet_Searched
        {
            get
            {
                if (Session["lstBookingsheetDataForLoadsheet_Searched"] == null)
                    Session["lstBookingsheetDataForLoadsheet_Searched"] = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
                return (List<USPAL_GetBookingsheetDataForLoadsheet_Result>)Session["lstBookingsheetDataForLoadsheet_Searched"];
            }
            set
            {
                Session["lstBookingsheetDataForLoadsheet_Searched"] = value;
            }
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
            lstLoadSheet_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetLoadsheetList().ToList();
            return View("~/Views/LoadSheet/Index.cshtml");
        }

        public JsonResult SearchBookingsheet(string searchText)
        {
            
            if (!string.IsNullOrEmpty(searchText))
            {
                lstBookingsheetDataForLoadsheet_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingsheetDataForLoadsheet("").ToList();
            }
            else
                lstBookingsheetDataForLoadsheet_Searched = lstBookingsheetDataForLoadsheet_Searched;

            var obj = new
            {
                Record_Count = lstBookingsheetDataForLoadsheet_Searched.Count
            };

            return Json(obj);
        }

        public PartialViewResult OpenBookingsheetPopup()
        {
            List<USPAL_GetBookingsheetDataForLoadsheet_Result> lst = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
            return PartialView("~/Views/LoadSheet/_AddLoadSheet.cshtml", lst);
        }
        public PartialViewResult BindBookingsheet(int pageNo, int recordPerPage, string sortType)
        {
            lstBookingsheetDataForLoadsheet_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingsheetDataForLoadsheet("").ToList();
            List<USPAL_GetBookingsheetDataForLoadsheet_Result> lst = new List<USPAL_GetBookingsheetDataForLoadsheet_Result>();
            int RecordCount = 0;
            RecordCount = lstBookingsheetDataForLoadsheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstBookingsheetDataForLoadsheet_Searched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstBookingsheetDataForLoadsheet_Searched.OrderBy(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstBookingsheetDataForLoadsheet_Searched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }


            return PartialView("~/Views/LoadSheet/_BookingsheetList.cshtml", lst);
        }

        public PartialViewResult BindLoadSheetList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetLoadsheetList_Result> lst = new List<USPAL_GetLoadsheetList_Result>();
            int RecordCount = 0;
            RecordCount = lstLoadSheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstLoadSheet_Searched.OrderByDescending(o => o.Inserted_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstLoadSheet_Searched.OrderBy(o => o.AL_Load_Sheet_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstLoadSheet_Searched.OrderByDescending(o => o.AL_Load_Sheet_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
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