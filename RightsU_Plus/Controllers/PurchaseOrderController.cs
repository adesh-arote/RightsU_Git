﻿using RightsU_BLL;
using RightsU_Entities;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace RightsU_Plus.Controllers
{
    public class PurchaseOrderController : BaseController
    {
        #region --- Properties ---

        //private List<RightsU_Entities.AL_Purchase_Order> lstPO
        //{
        //    get
        //    {
        //        if (Session["lstPO"] == null)
        //            Session["lstPO"] = new List<RightsU_Entities.AL_Purchase_Order>();
        //        return (List<RightsU_Entities.AL_Purchase_Order>)Session["lstPO"];
        //    }
        //    set { Session["lstPO"] = value; }
        //}

        //List<RightsU_Entities.AL_Purchase_Order> lstPOSearched
        //{
        //    get
        //    {
        //        if (Session["lstPOSearched"] == null)
        //            Session["lstPOSearched"] = new List<RightsU_Entities.AL_Purchase_Order>();
        //        return (List<RightsU_Entities.AL_Purchase_Order>)Session["lstPOSearched"];
        //    }
        //    set
        //    {
        //        Session["lstPOSearched"] = value;
        //    }
        //}

        private List<USPAL_GetPurchaseOrderList_Result> lstPO
        {
            get
            {
                if (Session["lstPO"] == null)
                    Session["lstPO"] = new List<USPAL_GetPurchaseOrderList_Result>();
                return (List<USPAL_GetPurchaseOrderList_Result>)Session["lstPO"];
            }
            set { Session["lstPO"] = value; }
        }

        List<USPAL_GetPurchaseOrderList_Result> lstPOSearched
        {
            get
            {
                if (Session["lstPOSearched"] == null)
                    Session["lstPOSearched"] = new List<USPAL_GetPurchaseOrderList_Result>();
                return (List<USPAL_GetPurchaseOrderList_Result>)Session["lstPOSearched"];
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

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        private List<RightsU_Entities.AL_Purchase_Order_Details> lstMovieTabData
        {
            get
            {
                if (Session["lstMovieTabData"] == null)
                    Session["lstMovieTabData"] = new List<RightsU_Entities.AL_Purchase_Order_Details>();
                return (List<RightsU_Entities.AL_Purchase_Order_Details>)Session["lstMovieTabData"];
            }
            set { Session["lstMovieTabData"] = value; }
        }

        private List<RightsU_Entities.AL_Purchase_Order_Details> lstShowTabData
        {
            get
            {
                if (Session["lstShowTabData"] == null)
                    Session["lstShowTabData"] = new List<RightsU_Entities.AL_Purchase_Order_Details>();
                return (List<RightsU_Entities.AL_Purchase_Order_Details>)Session["lstShowTabData"];
            }
            set { Session["lstShowTabData"] = value; }
        }

        List<RightsU_Entities.AL_Purchase_Order_Details> lstMovieDataSearched
        {
            get
            {
                if (Session["lstMovieDataSearched"] == null)
                    Session["lstMovieDataSearched"] = new List<RightsU_Entities.AL_Purchase_Order_Details>();
                return (List<RightsU_Entities.AL_Purchase_Order_Details>)Session["lstMovieDataSearched"];
            }
            set
            {
                Session["lstMovieDataSearched"] = value;
            }
        }

        List<RightsU_Entities.AL_Purchase_Order_Details> lstShowDataSearched
        {
            get
            {
                if (Session["lstShowDataSearched"] == null)
                    Session["lstShowDataSearched"] = new List<RightsU_Entities.AL_Purchase_Order_Details>();
                return (List<RightsU_Entities.AL_Purchase_Order_Details>)Session["lstShowDataSearched"];
            }
            set
            {
                Session["lstShowDataSearched"] = value;
            }
        }

        private AL_Purchase_Order_Details_Service objPoDetailsData_Service
        {
            get
            {
                if (Session["objPoDetailsData_Service"] == null)
                    Session["objPoDetailsData_Service"] = new AL_Purchase_Order_Details_Service(objLoginEntity.ConnectionStringName);
                return (AL_Purchase_Order_Details_Service)Session["objPoDetailsData_Service"];
            }
            set { Session["objPoDetailsData_Service"] = value; }
        }

        //---------------------------------------------------------------------------------------------------------------------------------------------------

        private PoDetails objPoD
        {
            get
            {
                if (Session["objPoD"] == null)
                    Session["objPoD"] = new PoDetails();
                return (PoDetails)Session["objPoD"];
            }
            set { Session["objPoD"] = value; }
        }

        #endregion

        //-----------------------------------------------------POPaging--------------------------------------------------------------------------------------

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
            //lstPOSearched = lstPO = objPO_Service.SearchFor(x => true).OrderByDescending(o => o.Inserted_On).ToList();
            lstPOSearched = lstPO = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetPurchaseOrderList().ToList();
        }

        public ActionResult BindPOList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetPurchaseOrderList_Result> lst = new List<USPAL_GetPurchaseOrderList_Result>();
            //List<AL_Purchase_Order> lst = new List<AL_Purchase_Order>();
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
            if (!string.IsNullOrEmpty(searchText))
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

        public ActionResult BindPODetails(int Purchase_Order_Code)
        {
            USPAL_GetPurchaseOrderList_Result objPO = new USPAL_GetPurchaseOrderList_Result();
            objPO = lstPO.Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code).FirstOrDefault();

            objPoD.Client_Name = objPO.Vendor_Name;
            objPoD.Booking_sheet_No = objPO.Booking_Sheet_No;
            objPoD.Proposal_Cy = objPO.Proposal_CY;
            objPoD.Created_On = Convert.ToDateTime(objPO.Inserted_On);
            objPoD.Purchase_Order_Code = objPO.AL_Purchase_Order_Code;

            MovieTabData();
            ShowTabData();

            return PartialView("_PoDetailsView");
        }

        private void MovieTabData()
        {
            lstMovieDataSearched = lstMovieTabData = objPoDetailsData_Service.SearchFor(x => true).Where(w => w.Title_Content_Code == 1).ToList();
        }

        private void ShowTabData()
        {
            lstShowDataSearched = lstShowTabData = objPoDetailsData_Service.SearchFor(x => true).Where(w => w.Title_Content_Code != 1).ToList();
        }

        public ActionResult BindMovieTabData(int Purchase_Order_Code)
        {
            string message = "";
            int RecordCount = 0;
            List<AL_Purchase_Order_Details> lstTabData, lst = new List<AL_Purchase_Order_Details>();

            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).ToList();
            ViewBag.ClientCode = lstVendors;

            Title_Service objTitle_Service = new Title_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Title> lstTitles = objTitle_Service.SearchFor(s => true).ToList();
            ViewBag.TitleCode = lstTitles;

            try
            {
                lstTabData = lstMovieDataSearched.Where(x => x.AL_Purchase_Order_Code == Purchase_Order_Code).ToList();
                int Rcount = lstTabData.Count();

                RecordCount = Rcount;
                if (RecordCount > 0)
                {
                    lst = lstTabData;
                    DataTable dt = ToDataTable(lst);
                }
                else
                {
                    lst = lstMovieDataSearched;
                    DataTable dt = ToDataTable(lst);
                }
            }
            catch (Exception ex)
            {
                message = ex.Message;
            }
            return PartialView("_MovieTabDataView", lst);
        }

        public ActionResult BindShowTabData(string TabName, int Purchase_Order_Code)
        {
            string message = "";
            int RecordCount = 0;
            List<AL_Purchase_Order_Details> lstTabData, lst = new List<AL_Purchase_Order_Details>();

            Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).ToList();
            ViewBag.ClientCode = lstVendors;

            Title_Service objTitle_Service = new Title_Service(objLoginEntity.ConnectionStringName);
            List<RightsU_Entities.Title> lstTitles = objTitle_Service.SearchFor(s => true).ToList();
            ViewBag.TitleCode = lstTitles;

            try
            {
                lstTabData = lstShowDataSearched.Where(x => x.AL_Purchase_Order_Code == Purchase_Order_Code).ToList();
                int Rcount = lstTabData.Count();

                RecordCount = Rcount;
                if (RecordCount > 0)
                {
                    lst = lstTabData;

                    DataTable dt = ToDataTable(lst);
                }
                else
                {
                    lst = lstShowDataSearched;
                    DataTable dt = ToDataTable(lst);
                }
            }
            catch (Exception ex)
            {
                message = ex.Message;
            }
            return PartialView("_ShowTabDataView", lst);
        }

        public static DataTable ToDataTable<T>(List<T> items)
        {
            DataTable dataTable = new DataTable(typeof(T).Name);

            //Get all the properties
            System.Reflection.PropertyInfo[] Props = typeof(T).GetProperties(System.Reflection.BindingFlags.Public | System.Reflection.BindingFlags.Instance);
            foreach (System.Reflection.PropertyInfo prop in Props)
            {
                //Defining type of data column gives proper data table 
                var type = (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(Nullable<>) ? Nullable.GetUnderlyingType(prop.PropertyType) : prop.PropertyType);
                //Setting column names as Property names
                dataTable.Columns.Add(prop.Name, type);
            }
            foreach (T item in items)
            {
                var values = new object[Props.Length];
                for (int i = 0; i < Props.Length; i++)
                {
                    //inserting property values to datatable rows
                    values[i] = Props[i].GetValue(item, null);
                }
                dataTable.Rows.Add(values);
            }
            //put a breakpoint here and check datatable
            return dataTable;
        }
    }

    public class PoDetails
    {
        public string Client_Name { get; set; }
        public string Booking_sheet_No { get; set; }
        public string Proposal_Cy { get; set; }
        public DateTime Created_On { get; set; }
        public int Purchase_Order_Code { get; set; }
    }
}

#region
//public ActionResult BindTabData(string TabName, int Purchase_Order_Code)
//{
//    string message = "";
//    int RecordCount = 0;
//    List<AL_Purchase_Order_Details> lstTabData, lst = new List<AL_Purchase_Order_Details>();

//    Vendor_Service objVendor_Service = new Vendor_Service(objLoginEntity.ConnectionStringName);
//    List<RightsU_Entities.Vendor> lstVendors = objVendor_Service.SearchFor(s => true).ToList();
//    ViewBag.ClientCode = lstVendors;

//    Title_Service objTitle_Service = new Title_Service(objLoginEntity.ConnectionStringName);
//    List<RightsU_Entities.Title> lstTitles = objTitle_Service.SearchFor(s => true).ToList();
//    ViewBag.TitleCode = lstTitles;

//    if (TabName == "MV")
//    {
//        try
//        {
//            lstTabData = lstMovieDataSearched.Where(x => x.AL_Purchase_Order_Code == Purchase_Order_Code).ToList();
//            int Rcount = lstTabData.Count();

//            RecordCount = Rcount;
//            if (RecordCount > 0)
//            {
//                lst = lstTabData;
//                DataTable dt = ToDataTable(lst);
//            }
//            else
//            {
//                lst = lstMovieDataSearched;
//                DataTable dt = ToDataTable(lst);
//            }
//        }
//        catch (Exception ex)
//        {
//            message = ex.Message;
//        }
//        return PartialView("_MovieTabDataView", lst);
//    }
//    else if (TabName == "SH")
//    {
//        try
//        {
//            lstTabData = lstShowDataSearched.Where(x => x.AL_Purchase_Order_Code == Purchase_Order_Code).ToList();
//            int Rcount = lstTabData.Count();

//            RecordCount = Rcount;
//            if (RecordCount > 0)
//            {
//                lst = lstTabData;

//                DataTable dt = ToDataTable(lst);
//            }
//            else
//            {
//                lst = lstShowDataSearched;
//                DataTable dt = ToDataTable(lst);
//            }
//        }
//        catch (Exception ex)
//        {
//            message = ex.Message;
//        }
//        return PartialView("_ShowTabDataView", lst);
//    }

//    var obj = new
//    {
//        Status = "E",
//        message
//    };
//    return Json(obj);
//}
#endregion