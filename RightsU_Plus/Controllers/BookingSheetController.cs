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
        private List<RightsU_Entities.AL_Booking_Sheet> lstBooking_Sheet
        {
            get
            {
                if (Session["lstBooking_Sheet"] == null)
                    Session["lstBooking_Sheet"] = new List<RightsU_Entities.AL_Booking_Sheet>();
                return (List<RightsU_Entities.AL_Booking_Sheet>)Session["lstBooking_Sheet"];
            }
            set { Session["lstBooking_Sheet"] = value; }
        }

        private List<RightsU_Entities.AL_Booking_Sheet> lstBooking_Sheet_Searched
        {
            get
            {
                if (Session["lstBooking_Sheet_Searched"] == null)
                    Session["lstBooking_Sheet_Searched"] = new List<RightsU_Entities.AL_Booking_Sheet>();
                return (List<RightsU_Entities.AL_Booking_Sheet>)Session["lstBooking_Sheet_Searched"];
            }
            set { Session["lstBooking_Sheet_Searched"] = value; }
        }

        private RightsU_Entities.AL_Booking_Sheet objBooking_Sheet
        {
            get
            {
                if (Session["objBooking_Sheet"] == null)
                    Session["objBooking_Sheet"] = new RightsU_Entities.AL_Booking_Sheet();
                return (RightsU_Entities.AL_Booking_Sheet)Session["objBooking_Sheet"];
            }
            set { Session["objBooking_Sheet"] = value; }
        }

        private AL_Booking_Sheet_Service objBooking_Sheet_Service
        {
            get
            {
                if (Session["objBooking_Sheet_Service"] == null)
                    Session["objBooking_Sheet_Service"] = new AL_Booking_Sheet_Service(objLoginEntity.ConnectionStringName);
                return (AL_Booking_Sheet_Service)Session["objBooking_Sheet_Service"];
            }
            set { Session["objBooking_Sheet_Service"] = value; }
        }

        //-------------------------------------------------------------------------------------------------------------------------------------------------

        private List<RightsU_Entities.AL_Recommendation> lstRecommendation
        {
            get
            {
                if (Session["lstRecommendation"] == null)
                    Session["lstRecommendation"] = new List<RightsU_Entities.AL_Recommendation>();
                return (List<RightsU_Entities.AL_Recommendation>)Session["lstRecommendation"];
            }
            set { Session["lstRecommendation"] = value; }
        }

        private List<RightsU_Entities.AL_Recommendation> lstRecommendation_Searched
        {
            get
            {
                if (Session["lstRecommendation_Searched"] == null)
                    Session["lstRecommendation_Searched"] = new List<RightsU_Entities.AL_Recommendation>();
                return (List<RightsU_Entities.AL_Recommendation>)Session["lstRecommendation_Searched"];
            }
            set { Session["lstRecommendation_Searched"] = value; }
        }

        private RightsU_Entities.AL_Recommendation objRecommendation
        {
            get
            {
                if (Session["objRecommendation"] == null)
                    Session["objRecommendation"] = new RightsU_Entities.AL_Recommendation();
                return (RightsU_Entities.AL_Recommendation)Session["objRecommendation"];
            }
            set { Session["objRecommendation"] = value; }
        }

        private AL_Recommendation_Service objRecommendation_Service
        {
            get
            {
                if (Session["objRecommendation_Service"] == null)
                    Session["objRecommendation_Service"] = new AL_Recommendation_Service(objLoginEntity.ConnectionStringName);
                return (AL_Recommendation_Service)Session["objRecommendation_Service"];
            }
            set { Session["objRecommendation_Service"] = value; }
        }
       
        #endregion

        //-----------------------------------------------------Paging--------------------------------------------------------------------------------------

        public ActionResult Index()
        {
            FetchData1();
            FetchData2();

            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).Where(w => w.Party_Type == "C" && w.Is_Active == "Y").ToList();
            ViewBag.ddlClient = new SelectList(lstVendors.OrderBy(o => o.Vendor_Name), "Vendor_Code", "Vendor_Name");

            return View();
        }

        private void FetchData1()
        {
            lstBooking_Sheet_Searched = lstBooking_Sheet = objBooking_Sheet_Service.SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        private void FetchData2()
        {
            lstRecommendation_Searched = lstRecommendation = objRecommendation_Service.SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
        }

        public ActionResult BindBookingSheetList(int pageNo, int recordPerPage)
        {
            List<AL_Booking_Sheet> lst = new List<AL_Booking_Sheet>();
            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);

            int RecordCount = 0;
            RecordCount = lstBooking_Sheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstBooking_Sheet_Searched.OrderByDescending(o => o.AL_Booking_Sheet_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).ToList();
            ViewBag.ClientName = lstVendors;

            List<RightsU_Entities.User> lstUsers = objUser_Service.SearchFor(s => true).ToList();
            ViewBag.UserCode = lstUsers;

            return PartialView("_BookingSheetList", lst);
        }

        public ActionResult PendingRecommendationsList(int pageNo, int recordPerPage)
        {
            List<AL_Recommendation> lst = new List<AL_Recommendation>();

            int RecordCount = 0;
            RecordCount = lstRecommendation_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                lst = lstRecommendation_Searched.OrderByDescending(o => o.AL_Recommendation_Code).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
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

        public JsonResult SearchOnList(string searchText)
        {
            //if (!string.IsNullOrEmpty(searchText))
            //{
            //    lstBooking_Sheet_Searched = lstBooking_Sheet.Where(w => w.Vendor_Code != null && w.Vendor_Code.ToString().Contains(searchText.ToString())).ToList();
            //}        
            //else
            //    lstBooking_Sheet_Searched = lstBooking_Sheet;

            var obj = new
            {
                Record_Count = lstBooking_Sheet_Searched.Count
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