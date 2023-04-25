using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class PurchaseOrderController : BaseController
    {
        #region --- Properties ---

        private List<RightsU_Entities.AL_Purchase_Order> lstPO
        {
            get
            {
                if (Session["lstPO"] == null)
                    Session["lstPO"] = new List<RightsU_Entities.AL_Purchase_Order>();
                return (List<RightsU_Entities.AL_Purchase_Order>)Session["lstPO"];
            }
            set { Session["lstPO"] = value; }
        }

        List<RightsU_Entities.AL_Purchase_Order> lstPOSearched
        {
            get
            {
                if (Session["lstPOSearched"] == null)
                    Session["lstPOSearched"] = new List<RightsU_Entities.AL_Purchase_Order>();
                return (List<RightsU_Entities.AL_Purchase_Order>)Session["lstPOSearched"];
            }
            set
            {
                Session["lstPOSearched"] = value;
            }
        }

        private AL_Purchase_Order_Service objPO_Service
        {
            get
            {
                if (Session["objPO_Service"] == null)
                    Session["objPO_Service"] = new AL_Purchase_Order_Service(objLoginEntity.ConnectionStringName);
                return (AL_Purchase_Order_Service)Session["objPO_Service"];
            }
            set { Session["objPO_Service"] = value; }
        }

        #endregion

        //-----------------------------------------------------POPaging---------------------------------------------------------------------------------------

        public ActionResult Index()
        {
            POData();

            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            lstSort.Add(new SelectListItem { Text = "Sort Booking Sheet No Asc", Value = "NA" });
            lstSort.Add(new SelectListItem { Text = "Sort Booking Sheet No Desc", Value = "ND" });
            ViewBag.SortType = lstSort;

            if (Session["Message"] != null)
            {                                            //-----To show success messages
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }
            return View();
        }

        private void POData()
        {
            lstPOSearched = lstPO = objPO_Service.SearchFor(x => true).OrderByDescending(o => o.Inserted_On).ToList();
            //lstBooking_Sheet_Searched = lstBooking_Sheet = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingSheetList().ToList();
        }

        public ActionResult BindPOList(int pageNo, int recordPerPage, string sortType)
        {
            List<AL_Purchase_Order> lst = new List<AL_Purchase_Order>();
            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);

            int RecordCount = 0;
            RecordCount = lstPOSearched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstPOSearched.OrderByDescending(o => o.Inserted_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (sortType == "NA")
                    lst = lstPOSearched.OrderBy(o => o.AL_Purchase_Order_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (sortType == "ND")
                    lst = lstPOSearched.OrderByDescending(o => o.AL_Purchase_Order_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).ToList();
            ViewBag.ClientCode = lstVendors;

            List<RightsU_Entities.User> lstUsers = objUser_Service.SearchFor(s => true).ToList();
            ViewBag.UserCode = lstUsers;

            return PartialView("_PurchaseOrderList", lst);
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

        public JsonResult SearchPOList(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText) )
            {
                lstPOSearched = lstPO.Where(w => w.Remarks != null && w.Remarks.ToUpper().Contains(searchText.ToUpper())).ToList();
            }
            else
                lstPOSearched = lstPO;

            var obj = new
            {
                Record_Count = lstPOSearched.Count
            };

            return Json(obj);
        }
    }
}