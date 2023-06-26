using RightsU_BLL;
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

        private AL_Purchase_Order_Rel_Service objPORel_Serice
        {
            get
            {
                if (Session["objPORel_Serice"] == null)
                    Session["objPORel_Serice"] = new AL_Purchase_Order_Rel_Service(objLoginEntity.ConnectionStringName);
                return (AL_Purchase_Order_Rel_Service)Session["objPORel_Serice"];
            }
            set { Session["objPORel_Serice"] = value; }
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

        //-----------------------------------------------------Purchase Order--------------------------------------------------------------------------------

        public ActionResult Index(int BookingSheetCode = 0)
        {
            //int BookingSheetCode = 0;
            if(BookingSheetCode == 0)
            {
                Session["BookingSheetCode"] = null;
                Session["config"] = null;
            }

            if (Session["BookingSheetCode"] != null)
            {                                            //-----To show success messages
                BookingSheetCode = Convert.ToInt32(Session["BookingSheetCode"]);
                //Session["BookingSheetCode"] = null;
            }
            if(Session["config"] != null)
            {
                string config = "";
                config = Convert.ToString(Session["config"]);
            }
            
            POData(BookingSheetCode);

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

        private void POData(int BookingSheetCode = 0)
        {
            if (BookingSheetCode > 0)
            {
                lstPOSearched = lstPO = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetPurchaseOrderList().Where(w => w.AL_Booking_Sheet_Code == BookingSheetCode).ToList();
            }
            else
            {
                lstPOSearched = lstPO = new USP_Service(objLoginEntity.ConnectionStringName).USPAL_GetPurchaseOrderList().ToList();
            }
        }

        public ActionResult BindPOList(int pageNo, int recordPerPage, string sortType)
        {
            List<USPAL_GetPurchaseOrderList_Result> lst = new List<USPAL_GetPurchaseOrderList_Result>();
                      
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
                    lst = lstPOSearched.OrderBy(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                if (sortType == "ND")
                    lst = lstPOSearched.OrderByDescending(o => o.Booking_Sheet_No).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
            }
           
            List<RightsU_Entities.User> lstUsers = objUser_Service.SearchFor(s => true).ToList();
            ViewBag.UserCode = lstUsers;

            if (Session["config"] != null)
            {
                string config = "";
                config = Convert.ToString(Session["config"]);
                ViewBag.Configuration = config;
            }

            return PartialView("_PurchaseOrderList", lst);
        }

        public JsonResult SearchPOList(string searchText)
        {
            if (!string.IsNullOrEmpty(searchText))
            {
                lstPOSearched = lstPO.Where(w => w.Vendor_Name != null && w.Vendor_Name.ToUpper().Contains(searchText.ToUpper()) || (w.Booking_Sheet_No != null && w.Booking_Sheet_No.ToUpper().Contains(searchText.ToUpper()))).ToList();
            }
            else
                lstPOSearched = lstPO;

            var obj = new
            {
                Record_Count = lstPOSearched.Count
            };

            return Json(obj);
        }

        //-----------------------------------------------------Purchase Order Details------------------------------------------------------------------------

        public ActionResult BindPODetails(int Purchase_Order_Code, int Proposal_Code)
        {
            USPAL_GetPurchaseOrderList_Result objPO = new USPAL_GetPurchaseOrderList_Result();
            objPO = lstPO.Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code).FirstOrDefault();

            objPoD.Client_Name = objPO.Vendor_Name;
            objPoD.Booking_sheet_No = objPO.Booking_Sheet_No;
            objPoD.Proposal_Cy = objPO.Proposal_CY;
            objPoD.Created_On = Convert.ToDateTime(objPO.Inserted_On);
            objPoD.Purchase_Order_Code = objPO.AL_Purchase_Order_Code;
            objPoD.Proposal_Code = objPO.AL_Proposal_Code;

            MovieTabData();
            ShowTabData();

            return PartialView("_PoDetailsView");
        }

        private void MovieTabData()
        {
            System_Parameter_New Movies_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Movies").FirstOrDefault();
            List<string> lstMovieCode = Movies_system_Parameter.Parameter_Value.Split(',').ToList();
            lstMovieDataSearched = lstMovieTabData = objPoDetailsData_Service.SearchFor(x => true).Where(w => lstMovieCode.Any(a => w.Title.Deal_Type_Code.ToString() == a)).ToList();
        }

        private void ShowTabData()
        {
            System_Parameter_New Show_system_Parameter = new System_Parameter_New_Service(objLoginEntity.ConnectionStringName).SearchFor(s => true).Where(w => w.Parameter_Name == "AL_DealType_Show").FirstOrDefault();
            List<string> lstShowCode = Show_system_Parameter.Parameter_Value.Split(',').ToList();
            lstShowDataSearched = lstShowTabData = objPoDetailsData_Service.SearchFor(x => true).Where(w => lstShowCode.Any(a => w.Title.Deal_Type_Code.ToString() == a)).ToList();
        }

        public JsonResult SearchPoDetails(string searchText, string TabName, int Purchase_Order_Code, int Proposal_Code)
        {
            List<AL_Purchase_Order_Details> lstPOD = new List<AL_Purchase_Order_Details>();
            List<AL_Purchase_Order_Rel> lstPOR = new List<AL_Purchase_Order_Rel>();

            int recordcount = 0;
            if (TabName == "MV")
            {
                if (!string.IsNullOrEmpty(searchText))
                {           
                    lstPOD = lstMovieTabData.Where(w => w.AL_Proposal_Code == Proposal_Code).ToList();
                    lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code && w.Status == "H").ToList();
                    lstMovieDataSearched = lstPOD.Where(w => lstPOR.Any(a => w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code)).ToList();
                    recordcount = lstMovieDataSearched.Count();
                }
                else
                {
                    //MovieTabData();
                    //lstMovieDataSearched = null;// to be changed by Sandip//lstMovieTabData.Where(m => m.AL_Purchase_Order_Code == Purchase_Order_Code).ToList();

                    lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code && w.Status == "N").ToList();
                    lstMovieDataSearched = lstMovieTabData.Where(w => lstPOR.Any(a => w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code) && w.AL_Proposal_Code == Proposal_Code).ToList();
                    recordcount = lstMovieDataSearched.Count();
                }
            }
            else if (TabName == "SH")
            {
                if (!string.IsNullOrEmpty(searchText))
                {
                    lstPOD = lstShowTabData.Where(w => w.AL_Proposal_Code == Proposal_Code).ToList();
                    lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code && w.Status == "H").ToList();
                    lstShowDataSearched = lstPOD.Where(w => lstPOR.Any(a => w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code)).GroupBy(g => g.PO_Number).Select(s => s.FirstOrDefault()).ToList();
                    recordcount = lstShowDataSearched.Count();
                }
                else
                {
                    //ShowTabData();
                    //lstShowDataSearched = null;// to be changed by Sandip //lstShowTabData.Where(x => x.AL_Purchase_Order_Code == Purchase_Order_Code).GroupBy(g => g.Vendor_Code).Select(s => s.FirstOrDefault()).ToList();

                    lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == Purchase_Order_Code && w.Status == "N").ToList();
                    lstShowDataSearched = lstShowTabData.Where(w => lstPOR.Any(a => (w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code) && w.AL_Proposal_Code == Proposal_Code)).GroupBy(g => g.PO_Number).Select(s => s.FirstOrDefault()).ToList();
                    recordcount = lstShowDataSearched.Count();
                }
            }

            var obj = new
            {
                Record_Count = recordcount,
            };
            return Json(obj);
        }

        public ActionResult BindMovieTabData(/*int Purchase_Order_Code, int Propsal_Code,*/ int pageNo, int recordPerPage, string sortType)
        {
            string message = "";
            int RecordCount = 0;
            List<AL_Purchase_Order_Details> lstTabData, lst = new List<AL_Purchase_Order_Details>();

            try
            {              
                RecordCount = lstMovieDataSearched.Count;
                //lstTabData = lstMovieDataSearched.Where(x => x.AL_Purchase_Order_Code == Purchase_Order_Code).ToList();
                //RecordCount = lstTabData.Count();

                if (RecordCount > 0)
                {
                    int noOfRecordSkip, noOfRecordTake;
                    pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                    if (sortType == "T")
                        lst = lstMovieDataSearched.OrderByDescending(o => o.Generated_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();
                                     
                    //lst = lstMovieDataSearched.OrderByDescending(o => o.Generated_On).ToList();
                    //DataTable dt = ToDataTable(lst);
                }
                else
                {
                    //lst = lstMovieDataSearched;
                    //DataTable dt = ToDataTable(lst);
                }
            }
            catch (Exception ex)
            {
                message = ex.Message;
            }
            return PartialView("_MovieTabDataView", lst);
        }

        public ActionResult BindShowTabData(/*int Purchase_Order_Code, int Propsal_Code,*/ int pageNo, int recordPerPage, string sortType)
        {
            string message = "";
            int RecordCount = 0;
            List<AL_Purchase_Order_Details> lstTabData, lst = new List<AL_Purchase_Order_Details>();
          
            try
            {
                RecordCount = lstShowDataSearched.Count;
                //lstTabData = lstShowDataSearched.Where(x => x.AL_Purchase_Order_Code == Purchase_Order_Code).GroupBy(g => g.Vendor_Code).Select(s => s.FirstOrDefault()).ToList();
                //RecordCount = lstTabData.Count();
              
                if (RecordCount > 0)
                {
                    int noOfRecordSkip, noOfRecordTake;
                    pageNo = GetPaging(pageNo, recordPerPage, RecordCount, out noOfRecordSkip, out noOfRecordTake);
                    if (sortType == "T")
                        lst = lstShowDataSearched.OrderByDescending(o => o.Generated_On).Skip(noOfRecordSkip).Take(noOfRecordTake).ToList();

                    //lst = lstTabData.OrderByDescending(o => o.Generated_On).ToList();
                    //DataTable dt = ToDataTable(lst);
                }
                else
                {
                    //lst = lstTabData;
                    //DataTable dt = ToDataTable(lst);
                }
            }
            catch (Exception ex)
            {
                message = ex.Message;
            }
            return PartialView("_ShowTabDataView", lst);
        }

        //-------------------------------------------------Refresh PO/POD and GetStatus----------------------------------------------------------------------

        public JsonResult GetPurchaseOrderStatus(int PurchaseOrderCode)
        {
            //int BookingSheetCode = 0;
            //if (Session["BookingSheetCode"] != null)
            //{                                            
            //    BookingSheetCode = Convert.ToInt32(Session["BookingSheetCode"]);
            //    //Session["BookingSheetCode"] = null;
            //}
            //POData(BookingSheetCode);

            string recordStatus = new AL_Purchase_Order_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.AL_Purchase_Order_Code == PurchaseOrderCode).Select(s => s.Status).FirstOrDefault();

            var obj = new
            {
                RecordStatus = recordStatus,
            };
            return Json(obj);
        }

        public JsonResult GetPurchaseOrderDetailStatus(int PurchaseOrderDetailCode)
        {
            string recordStatus = new AL_Purchase_Order_Details_Service(objLoginEntity.ConnectionStringName).SearchFor(w => w.AL_Purchase_Order_Details_Code == PurchaseOrderDetailCode).Select(s => s.Status).FirstOrDefault();

            var obj = new
            {
                RecordStatus = recordStatus,
            };
            return Json(obj);
        }

        public JsonResult RefreshPoList(int PurchaseOrderCode, int BookingSheetCode)
        {
            string status = "S", message = "";

            AL_Purchase_Order obj_AL_Purchase_Order = new AL_Purchase_Order();
            obj_AL_Purchase_Order = objPO_Service.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == PurchaseOrderCode).FirstOrDefault();

            RefreshPOD(PurchaseOrderCode);
            obj_AL_Purchase_Order.Status = "I";
            obj_AL_Purchase_Order.EntityState = State.Modified;


            dynamic resultSet;
            if (!objPO_Service.Save(obj_AL_Purchase_Order, out resultSet))
            {
                status = "E";
                message = resultSet;
            }
            else
            {
                status = "S";
                message = objMessageKey.Recordsavedsuccessfully;

                obj_AL_Purchase_Order = null;
                objPO_Service = null;

                //POData(BookingSheetCode);
            }

            var obj = new
            {
                RecordCount = lstPOSearched.Count,
                Status = status,
                Message = message
            };
            return Json(obj);
        }

        public void RefreshPOD(int PurchaseOrderCode)
        {           
            List<AL_Purchase_Order_Details>  lst_AL_Purchase_Order_Details = new List<AL_Purchase_Order_Details>();
            List<AL_Purchase_Order_Rel> lstPOR = new List<AL_Purchase_Order_Rel>();

            lstPOR = objPORel_Serice.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Code == PurchaseOrderCode && w.Status == "N").ToList();
            lst_AL_Purchase_Order_Details = objPoDetailsData_Service.SearchFor(s => true).ToList();
            lst_AL_Purchase_Order_Details = lst_AL_Purchase_Order_Details.Where(w => lstPOR.Any(a => w.AL_Purchase_Order_Details_Code == a.AL_Purchase_Order_Details_Code)).ToList();
            
            foreach (AL_Purchase_Order_Details obj_AL_Purchase_Order_Details in lst_AL_Purchase_Order_Details)
            {
                obj_AL_Purchase_Order_Details.Status = "P";
                obj_AL_Purchase_Order_Details.EntityState = State.Modified;

                dynamic resultSet;
                objPoDetailsData_Service.Save(obj_AL_Purchase_Order_Details, out resultSet);           
            }                     
        }

        //-----------------------------------------------------GetFileNameToDownload------------------------------------------------------------------------

        public JsonResult GetFileName(int PurchaseOrderDetailCode)
        {
            AL_Purchase_Order_Details_Service objAPOD_Service = new AL_Purchase_Order_Details_Service(objLoginEntity.ConnectionStringName);
        
            string Filename = objAPOD_Service.SearchFor(s => true).Where(w => w.AL_Purchase_Order_Details_Code == PurchaseOrderDetailCode).Select(s => s.PDF_File_Name).FirstOrDefault();
        
            return Json(Filename);
        }

        //--------------------------------------------------------GenericMethods-----------------------------------------------------------------------------

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
        public int? Proposal_Code { get; set; }
    }
}

#region
//public ActionResult BindTabData(string TabName, int Purchase_Order_Code)
//{
//    string message = "";
//    int RecordCount = 0;
//    List<AL_Purchase_Order_Details> lstTabData, lst = new List<AL_Purchase_Order_Details>();

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