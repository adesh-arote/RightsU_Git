using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class BookingSheetController : BaseController
    {
        #region --- Properties ---
        private List<RightsU_Entities.Extended_Group> lstExtended_Group
        {
            get
            {
                if (Session["lstExtended_Group"] == null)
                    Session["lstExtended_Group"] = new List<RightsU_Entities.Extended_Group>();
                return (List<RightsU_Entities.Extended_Group>)Session["lstExtended_Group"];
            }
            set { Session["lstExtended_Group"] = value; }
        }

        private List<RightsU_Entities.Extended_Group> lstExtended_Group_Searched
        {
            get
            {
                if (Session["lstlstExtended_Group_Searched"] == null)
                    Session["lstlstExtended_Group_Searched"] = new List<RightsU_Entities.Extended_Group>();
                return (List<RightsU_Entities.Extended_Group>)Session["lstlstExtended_Group_Searched"];
            }
            set { Session["lstlstExtended_Group_Searched"] = value; }
        }

        private RightsU_Entities.Extended_Group objExtended_Group
        {
            get
            {
                if (Session["objExtended_Group"] == null)
                    Session["objExtended_Group"] = new RightsU_Entities.Extended_Group();
                return (RightsU_Entities.Extended_Group)Session["objExtended_Group"];
            }
            set { Session["objExtended_Group"] = value; }
        }
        #endregion

        //-----------------------------------------------------Paging--------------------------------------------------------------------------------------

        public ActionResult Index()
        {
            FetchData();
            //List<SelectListItem> lstSort = new List<SelectListItem>();
            //lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            //lstSort.Add(new SelectListItem { Text = "Sort Name Asc", Value = "NA" });
            //lstSort.Add(new SelectListItem { Text = "Sort Name Desc", Value = "ND" });
            //ViewBag.SortType = lstSort;

            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);

            List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).Where(w => w.Party_Type == "C" && w.Is_Active == "Y").ToList();
            ViewBag.ddlClient = new SelectList(lstVendors.OrderBy(o => o.Vendor_Name), "Vendor_Code", "Vendor_Name");
            //ViewBag.ddlClients = lstVendors;

            return View();
        }

        private void FetchData()
        {
            Extended_Group_Service objExtended_Group_Service = new Extended_Group_Service(objLoginEntity.ConnectionStringName);
            lstExtended_Group_Searched = lstExtended_Group = objExtended_Group_Service.SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        public ActionResult BindBookingSheetList(int pageNo, int recordPerPage, string sortType)
        {
            List<Extended_Group> lst = new List<Extended_Group>();

            int RecordCount = 0;
            RecordCount = lstExtended_Group_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstExtended_Group_Searched.OrderByDescending(o => o.Extended_Group_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstExtended_Group_Searched.OrderBy(o => o.Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstExtended_Group_Searched.OrderByDescending(o => o.Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return PartialView("_BookingSheetList", lst);
        }

        public ActionResult PendingRecommendationsList(int pageNo, int recordPerPage, string sortType)
        {
            List<Extended_Group> lst = new List<Extended_Group>();

            int RecordCount = 10;
            //RecordCount = lstExtended_Group_Searched.Count;
            RecordCount = 10;
            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstExtended_Group_Searched.OrderByDescending(o => o.Extended_Group_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else if (sortType == "NA")
                    lst = lstExtended_Group_Searched.OrderBy(o => o.Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                else
                    lst = lstExtended_Group_Searched.OrderByDescending(o => o.Group_Name).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return PartialView("_PendingRecommendationsList", lst);
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

        public JsonResult SearchBookingSheet(string searchText, int? ModuleCode)
        {
            if (!string.IsNullOrEmpty(searchText) && ModuleCode == null)
            {
                lstExtended_Group_Searched = lstExtended_Group.Where(w => w.Group_Name != null && w.Group_Name.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else if (searchText == "" && ModuleCode != null)
            {
                lstExtended_Group_Searched = lstExtended_Group.Where(w => w.Module_Code != null && w.Module_Code.ToString().Contains(ModuleCode.ToString())).ToList();
            }
            else if (!string.IsNullOrEmpty(searchText) && ModuleCode != null)
            {
                lstExtended_Group_Searched = lstExtended_Group.Where(w => (w.Group_Name != null && w.Group_Name.ToUpper().Contains(searchText.ToUpper())) && (w.Module_Code != null && w.Module_Code.ToString().Contains(ModuleCode.ToString()))).ToList();
            }
            else
                lstExtended_Group_Searched = lstExtended_Group;

            var obj = new
            {
                Record_Count = lstExtended_Group_Searched.Count
            };

            return Json(obj);
        }


        public ActionResult Create()
        {
            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);

            List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).ToList();
            ViewBag.ddlClient = new SelectList(lstVendors.OrderBy(o => o.Vendor_Name), "Vendor_Code", "Vendor_Name");

            return View();
        }
    }
}