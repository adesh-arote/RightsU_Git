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
            //added by sachin shelar
            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            AL_Material_Tracking_Service objAL_Material_Tracking_Service = new AL_Material_Tracking_Service(objLoginEntity.ConnectionStringName);
            AL_Lab_Service objAL_Lab_Service = new AL_Lab_Service(objLoginEntity.ConnectionStringName);

            List<RightsU_Entities.Vendor> lstClients = objVendor_Service.SearchFor(s => true).Where(w => w.Party_Type == "C").ToList();
            ViewBag.ddlClient = new SelectList(lstClients, "Vendor_Code", "Vendor_Name");
      
            List<int?> lstMT = objAL_Material_Tracking_Service.SearchFor(s => true).Select(s => s.Vendor_Code).Distinct().ToList();
            List<RightsU_Entities.Vendor> lstDistributors = objVendor_Service.SearchFor(s => true).Where(w => lstMT.Any(a => w.Vendor_Code == a)).ToList();
            ViewBag.ddlDistributor = new SelectList(lstDistributors, "Vendor_Code", "Vendor_Name");
          
            List<AL_Lab> lstLab = objAL_Lab_Service.SearchFor(s => true).ToList();
            ViewBag.ddlLab = new SelectList(lstLab, "AL_Lab_Code", "AL_Lab_Name");
         
            return View();
        }

        public JsonResult SearchDeliveryTracking(string TabName = "", int Client = 0, string CycleDate = "", int Lab = 0, int Distributor = 0, string Display = "")
        {
            int recordcount = 0;
            if (TabName == "M")
            {
                //lstGetDeliveryTrackingListMovies_Result_Searched = 
                    GetDeliveryTrackingListMovies_Result(TabName, Client, CycleDate, Lab, Distributor, Display);

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

        public List<USPAL_GetDeliveryTrackingList_Result> GetDeliveryTrackingListMovies_Result(string TabName, int Client, string CycleDate, int Lab, int Distributor, string Display)
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
            int RecordCount = 0;

            ViewBag.CommandName = CommandName;
            ViewBag.AL_Material_Tracking_Code = id;
            ViewBag.TabName = CommandName;

            //added by sachin shelar
            List<USPAL_GetDeliveryTrackingList_Result> MaterialTrackingList, lst = new List<USPAL_GetDeliveryTrackingList_Result>();
            USPAL_GetDeliveryTrackingList_Result firstItem = new USPAL_GetDeliveryTrackingList_Result();
            MaterialTrackingList = lstGetDeliveryTrackingListMovies_Result_Searched.ToList();

            if (MaterialTrackingList.Count != 0)
            {
                RecordCount = MaterialTrackingList.Count - 1;

                firstItem = MaterialTrackingList[0];
                MaterialTrackingList.RemoveAt(0);
            }
            else
            {
                RecordCount = MaterialTrackingList.Count();               
            }

            //RecordCount = lstGetDeliveryTrackingListMovies_Result_Searched.Count - 1; // commented by sachin shelar

            if (RecordCount > 0)
            {
                int noOfRecordSkip, noOfRecordTake;
                pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                if (sortType == "T")
                    lst = MaterialTrackingList.Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();  // changed by sachin shelar
                //if (sortType == "NA")
                //    lst = lstGetDeliveryTrackingListMovies_Result_Searched.OrderBy(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                //if (sortType == "ND")
                //    lst = lstGetDeliveryTrackingListMovies_Result_Searched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                lst.Insert(0, firstItem); // added by sachin shelar
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