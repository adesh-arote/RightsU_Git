using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class DeliveryTrackingController : BaseController
    {
        #region-----------properties
        private List<USPAL_GetDeliveryTrackingList_Result> lstGetDeliveryTrackingListMovies_Result
        {
            get
            {
                if (Session["lstGetDeliveryTrackingListMovies_Result"] == null)
                    Session["lstGetDeliveryTrackingListMovies_Result"] = new List<USPAL_GetDeliveryTrackingList_Result>();
                return (List<USPAL_GetDeliveryTrackingList_Result>)Session["lstGetDeliveryTrackingListMovies_Result"];
            }
            set { Session["lstGetDeliveryTrackingListMovies_Result"] = value; }
        }
        private List<USPAL_GetDeliveryTrackingList_Result> lstGetDeliveryTrackingListMovies_Result_Searched
        {
            get
            {
                if (Session["lstGetDeliveryTrackingListMovies_Result_Searched"] == null)
                    Session["lstGetDeliveryTrackingListMovies_Result_Searched"] = new List<USPAL_GetDeliveryTrackingList_Result>();
                return (List<USPAL_GetDeliveryTrackingList_Result>)Session["lstGetDeliveryTrackingListMovies_Result_Searched"];
            }
            set { Session["lstGetDeliveryTrackingListMovies_Result_Searched"] = value; }
        }

        #endregion---------------------------------
        // GET: DeliveryTracking
        public ActionResult Index()
        {
            return View();
        }

        public JsonResult SearchDeliveryTracking(string searchText, string TabName)
        {
            int recordcount = 0;
            if (TabName == "M")
            {
                //lstGetDeliveryTrackingListMovies_Result_Searched = 
                    GetDeliveryTrackingListMovies_Result();

                recordcount = lstGetDeliveryTrackingListMovies_Result_Searched.Count -1 ;
            }
            else if (TabName == "S")
            {
                GetDeliveryTrackingListShows_Result();

                recordcount = lstGetDeliveryTrackingListMovies_Result_Searched.Count - 1;
            }

            var obj = new
            {
                Record_Count = recordcount
            };

            return Json(obj);
        }

        public List<USPAL_GetDeliveryTrackingList_Result> GetDeliveryTrackingListMovies_Result()
        {
            lstGetDeliveryTrackingListMovies_Result_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetDeliveryTrackingList(0, "", 0, 0, "","M").ToList();
            return lstGetDeliveryTrackingListMovies_Result;
        }

        public List<USPAL_GetDeliveryTrackingList_Result> GetDeliveryTrackingListShows_Result()
        {
            lstGetDeliveryTrackingListMovies_Result_Searched = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetDeliveryTrackingList(0, "", 0, 0, "", "S").ToList();
            return lstGetDeliveryTrackingListMovies_Result;
        }
        public ActionResult BindMoviesList(int pageNo, int recordPerPage, string sortType, string CommandName, int id)
        {
            List<USPAL_GetDeliveryTrackingList_Result> lst = new List<USPAL_GetDeliveryTrackingList_Result>();

            ViewBag.CommandName = CommandName;
            ViewBag.AL_Material_Tracking_Code = id;
            ViewBag.TabName = CommandName;
            int RecordCount = 0;
            RecordCount = lstGetDeliveryTrackingListMovies_Result_Searched.Count - 1;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstGetDeliveryTrackingListMovies_Result_Searched;//.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //if (sortType == "NA")
                //    lst = lstGetDeliveryTrackingListMovies_Result_Searched.OrderBy(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //if (sortType == "ND")
                //    lst = lstGetDeliveryTrackingListMovies_Result_Searched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return PartialView("~/Views/DeliveryTracking/_MoviesList.cshtml", lst);
        }

        public ActionResult BindShowsList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetDeliveryTrackingList_Result> lst = new List<USPAL_GetDeliveryTrackingList_Result>();

            //ViewBag.CommandName = CommandName;
            //ViewBag.AL_Material_Tracking_Code = id;

            int RecordCount = 0;
            RecordCount = lstGetDeliveryTrackingListMovies_Result_Searched.Count - 1;

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = lstGetDeliveryTrackingListMovies_Result_Searched;//.OrderByDescending(o => o.Last_Updated_Time).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //if (sortType == "NA")
                //    lst = lstGetDeliveryTrackingListMovies_Result_Searched.OrderBy(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //if (sortType == "ND")
                //    lst = lstGetDeliveryTrackingListMovies_Result_Searched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }

            return PartialView("~/Views/DeliveryTracking/_ShowsList.cshtml", lst);
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

        public JsonResult SaveDelivery(List<DeliveryTracking_UDT> lst)
        {
            string status = "S", message = "";
            new USP_Service(objLoginEntity.ConnectionStringName).SaveDeliveryTrackingUDT(lst);
            var obj = new
            {
                RecordCount = 0,// lstCurrency.Count,
                Status = status,
                Message = "Material Delivery Updates successfully"
            };
            return Json(obj);
        }
    }
}