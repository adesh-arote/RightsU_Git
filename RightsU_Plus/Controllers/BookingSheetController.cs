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
        //private List<RightsU_Entities.AL_Booking_Sheet> lstBooking_Sheet
        //{
        //    get
        //    {
        //        if (Session["lstBooking_Sheet"] == null)
        //            Session["lstBooking_Sheet"] = new List<RightsU_Entities.AL_Booking_Sheet>();
        //        return (List<RightsU_Entities.AL_Booking_Sheet>)Session["lstBooking_Sheet"];
        //    }
        //    set { Session["lstBooking_Sheet"] = value; }
        //}

        //private List<RightsU_Entities.AL_Booking_Sheet> lstBooking_Sheet_Searched
        //{
        //    get
        //    {
        //        if (Session["lstBooking_Sheet_Searched"] == null)
        //            Session["lstBooking_Sheet_Searched"] = new List<RightsU_Entities.AL_Booking_Sheet>();
        //        return (List<RightsU_Entities.AL_Booking_Sheet>)Session["lstBooking_Sheet_Searched"];
        //    }
        //    set { Session["lstBooking_Sheet_Searched"] = value; }
        //}

        private List<USPAL_GetBookingSheetList_Result> lstBooking_Sheet
        {
            get
            {
                if (Session["lstBooking_Sheet"] == null)
                    Session["lstBooking_Sheet"] = new List<USPAL_GetBookingSheetList_Result>();
                return (List<USPAL_GetBookingSheetList_Result>)Session["lstBooking_Sheet"];
            }
            set { Session["lstBooking_Sheet"] = value; }
        }

        List<USPAL_GetBookingSheetList_Result> lstBooking_Sheet_Searched
        {
            get
            {
                if (Session["lstBooking_Sheet_Searched"] == null)
                    Session["lstBooking_Sheet_Searched"] = new List<USPAL_GetBookingSheetList_Result>();
                return (List<USPAL_GetBookingSheetList_Result>)Session["lstBooking_Sheet_Searched"];
            }
            set
            {
                Session["lstBooking_Sheet_Searched"] = value;
            }
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


        //private List<RightsU_Entities.AL_Recommendation> lstRecommendation
        //{
        //    get
        //    {
        //        if (Session["lstRecommendation"] == null)
        //            Session["lstRecommendation"] = new List<RightsU_Entities.AL_Recommendation>();
        //        return (List<RightsU_Entities.AL_Recommendation>)Session["lstRecommendation"];
        //    }
        //    set { Session["lstRecommendation"] = value; }
        //}

        //private List<RightsU_Entities.AL_Recommendation> lstRecommendation_Searched
        //{
        //    get
        //    {
        //        if (Session["lstRecommendation_Searched"] == null)
        //            Session["lstRecommendation_Searched"] = new List<RightsU_Entities.AL_Recommendation>();
        //        return (List<RightsU_Entities.AL_Recommendation>)Session["lstRecommendation_Searched"];
        //    }
        //    set { Session["lstRecommendation_Searched"] = value; }
        //}

        private List<USPAL_GetReCommendationList_Result> lstRecommendation
        {
            get
            {
                if (Session["lstRecommendation"] == null)
                    Session["lstRecommendation"] = new List<USPAL_GetReCommendationList_Result>();
                return (List<USPAL_GetReCommendationList_Result>)Session["lstRecommendation"];
            }
            set { Session["lstRecommendation"] = value; }
        }

        List<USPAL_GetReCommendationList_Result> lstRecommendation_Searched
        {
            get
            {
                if (Session["lstRecommendation_Searched"] == null)
                    Session["lstRecommendation_Searched"] = new List<USPAL_GetReCommendationList_Result>();
                return (List<USPAL_GetReCommendationList_Result>)Session["lstRecommendation_Searched"];
            }
            set
            {
                Session["lstRecommendation_Searched"] = value;
            }
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
            BookingSheetData();
            PendingReccomendationData();

            List<SelectListItem> lstSort = new List<SelectListItem>();
            lstSort.Add(new SelectListItem { Text = "Latest Modified", Value = "T" });
            //lstSort.Add(new SelectListItem { Text = "Sort Name Asc", Value = "NA" });
            //lstSort.Add(new SelectListItem { Text = "Sort Name Desc", Value = "ND" });
            ViewBag.SortType = lstSort;

            //Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            //List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).Where(w => w.Party_Type == "C" && w.Is_Active == "Y").ToList();
            //ViewBag.ddlClient = new SelectList(lstVendors.OrderBy(o => o.Vendor_Name), "Vendor_Code", "Vendor_Name");

            if (Session["Message"] != null)
            {                                            //-----To show success messages
                ViewBag.Message = Session["Message"];
                Session["Message"] = null;
            }

            return View();
        }

        private void BookingSheetData()
        {
            //lstBooking_Sheet_Searched = lstBooking_Sheet = objBooking_Sheet_Service.SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
            lstBooking_Sheet_Searched = lstBooking_Sheet = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetBookingSheetList().ToList();
        }

        private void PendingReccomendationData()
        {
            //lstRecommendation_Searched = lstRecommendation = objRecommendation_Service.SearchFor(x => true).OrderByDescending(o => o.Last_Updated_Time).ToList();
            lstRecommendation_Searched = lstRecommendation = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetReCommendationList().ToList();
        }

        public ActionResult BindBookingSheetList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetBookingSheetList_Result> lst = new List<USPAL_GetBookingSheetList_Result>();
            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            User_Service objUser_Service = new User_Service(objLoginEntity.ConnectionStringName);

            int RecordCount = 0;
            RecordCount = lstBooking_Sheet_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstBooking_Sheet_Searched.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).ToList();
            ViewBag.ClientName = lstVendors;

            List<RightsU_Entities.User> lstUsers = objUser_Service.SearchFor(s => true).ToList();
            ViewBag.UserCode = lstUsers;

            return PartialView("_BookingSheetList", lst);
        }

        public ActionResult PendingRecommendationsList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetReCommendationList_Result> lst = new List<USPAL_GetReCommendationList_Result>();

            int RecordCount = 0;
            RecordCount = lstRecommendation_Searched.Count;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
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

        public JsonResult SearchOnList(string searchText, string TabName)
        {
            int recorcount = 0;
            if (TabName == "BS")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstBooking_Sheet_Searched = lstBooking_Sheet.Where(w => w.Vendor_Name != null && w.Vendor_Name.ToString().Contains(searchText.ToString()) || (w.Booking_Sheet_No != null && w.Booking_Sheet_No.ToString().Contains(searchText.ToString()))).ToList();
                }
                else
                {
                    BookingSheetData();
                    lstBooking_Sheet_Searched = lstBooking_Sheet;
                }
                    
                recorcount = lstBooking_Sheet_Searched.Count;
            }
            else if(TabName == "PR")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstRecommendation_Searched = lstRecommendation.Where(w => w.Vendor_Name != null && w.Vendor_Name.ToString().Contains(searchText.ToString()) || (w.Proposal_No != null && w.Proposal_No.ToString().Contains(searchText.ToString()))).ToList();
                }
                else
                {
                    PendingReccomendationData();
                    lstRecommendation_Searched = lstRecommendation;
                }
                    
                recorcount = lstRecommendation_Searched.Count;
            }

            var obj = new
            {
                Record_Count = recorcount
            };

            return Json(obj);
        }

        //-----------------------------------------------------GenerateBookingSheet-----------------------------------------------------------------------------

        public JsonResult GenerateBookingSheet(int RecommendationCode)
        {
            string Status = "";
            string Message = "";
            Dictionary<string, object> obj = new Dictionary<string, object>();
            USPAL_GetReCommendationList_Result objRc = new USPAL_GetReCommendationList_Result();

            if (RecommendationCode != 0)
            {
                objRc = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetReCommendationList().Where(w => w.AL_Recommendation_Code == RecommendationCode).FirstOrDefault();
               
                objBooking_Sheet.AL_Recommendation_Code = objRc.AL_Recommendation_Code;               
                objBooking_Sheet.Last_Action_By = objLoginUser.Users_Code;
                objBooking_Sheet.Last_Updated_Time = DateTime.Now;
                objBooking_Sheet.Record_Status = "P";

                objBooking_Sheet.Vendor_Code = 2470;
                
                Random ran = new Random();
                int SheetNo = ran.Next(1, 100);
                objBooking_Sheet.Booking_Sheet_No = "BS000" + SheetNo;

                objBooking_Sheet.EntityState = State.Added;
            }

            dynamic resultSet;
            if (!objBooking_Sheet_Service.Save(objBooking_Sheet, out resultSet))
            {
                Status = "E";
                Message = resultSet;        
            }
            else
            {
                Status = "S";
                Message = "Sheet Generated Succesfully";      
            }

            var Obj = new
            {
                Status = Status,
                Message = Message
            };
            return Json(Obj);
        }
    }
}